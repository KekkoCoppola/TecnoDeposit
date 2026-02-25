package controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.crypto.SecretKey;

import dao.DBConnection;
import dao.TokenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Articolo;
import model.UserService;
import model.ListaArticoli;
import util.CryptoUtil;
import util.EmailConfig;
import util.EmailService;
import util.TableMaintenance;
import util.ArticoloImportParser;

import jakarta.servlet.annotation.MultipartConfig;

@MultipartConfig // puoi aggiungere limiti se vuoi
public class ImpostazioniServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Verifica se l'utente è loggato
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("username") == null) {
			response.sendRedirect("login");
			return;
		}

		// API AJAX: restituisce dati articoli come JSON (per Excel/PDF)
		String action = request.getParameter("action");
		if ("exportData".equals(action)) {
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");

			ListaArticoli lista = new ListaArticoli();
			String type = request.getParameter("type");

			StringBuilder sb = new StringBuilder();

			if ("labels".equals(type)) {
				// Dati per etichette PDF: matricola, nome, dataSpe
				List<String> matricole = lista.getCampoFromDb("matricola");
				List<String> nomi = lista.getCampoFromDb("nome");
				List<String> dateSpe = lista.getCampoFromDb("data_spedizione");
				int size = Math.min(matricole.size(), Math.min(nomi.size(), dateSpe.size()));

				sb.append("[");
				for (int j = 0; j < size; j++) {
					if (j > 0)
						sb.append(",");
					sb.append("{\"matricola\":\"").append(escapeJson(matricole.get(j)))
							.append("\",\"nome\":\"").append(escapeJson(nomi.get(j)))
							.append("\",\"dataSpe\":\"")
							.append(escapeJson(dateSpe.get(j) != null ? dateSpe.get(j) : ""))
							.append("\"}");
				}
				sb.append("]");
			} else {
				// Dati per Excel: tutti i campi
				List<Articolo> articoli = lista.getAllarticoli();
				java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");

				sb.append("[");
				for (int j = 0; j < articoli.size(); j++) {
					Articolo a = articoli.get(j);
					if (j > 0)
						sb.append(",");
					sb.append("{")
							.append("\"nome\":\"").append(escapeJson(a.getNome())).append("\"")
							.append(",\"matricola\":\"").append(escapeJson(a.getMatricola())).append("\"")
							.append(",\"provenienza\":\"").append(escapeJson(a.getProvenienza())).append("\"")
							.append(",\"centroRevisione\":\"").append(escapeJson(a.getFornitore())).append("\"")
							.append(",\"garanzia\":\"").append(a.getRichiestaGaranzia() ? "SI" : "NO").append("\"")
							.append(",\"dataSpedizione\":\"")
							.append(a.getDataSpe_DDT() != null ? a.getDataSpe_DDT().format(fmt) : "").append("\"")
							.append(",\"ddtSpedizione\":\"").append(a.getDdt() != -1 ? a.getDdt() : 0).append("\"")
							.append(",\"dataRientro\":\"")
							.append(a.getDataRic_DDT() != null ? a.getDataRic_DDT().format(fmt) : "").append("\"")
							.append(",\"ddtRientro\":\"").append(a.getDdtSpedizione() != -1 ? a.getDdtSpedizione() : 0)
							.append("\"")
							.append(",\"note\":\"").append(escapeJson(a.getNote())).append("\"")
							.append("}");
				}
				sb.append("]");
			}

			response.getWriter().write(sb.toString());
			return;
		}

		// Se l'utente è loggato, procedi con la visualizzazione della pagina
		request.getRequestDispatcher("/impostazioni.jsp").forward(request, response);
	}

	/** Escape stringa per JSON (evita injection/errori di parsing) */
	private static String escapeJson(String s) {
		if (s == null)
			return "";
		return s.replace("\\", "\\\\")
				.replace("\"", "\\\"")
				.replace("\n", "\\n")
				.replace("\r", "\\r")
				.replace("\t", "\\t");
	}

	@Override

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("username") == null) {
			response.sendRedirect("login");
			return;
		}
		if (session.getAttribute("ruolo").equals("Tecnico")) {
			response.sendRedirect("impostazioni");
			return;
		}

		String step = request.getParameter("step");
		String email = (String) session.getAttribute("mail");
		int userId = (int) session.getAttribute("userId");

		try {
			if ("preview".equals(step)) {
				String phrase = request.getParameter("phrase");
				String password = request.getParameter("passwordDelete");

				// 1) verifica frase
				if (!"SVUOTA MAGAZZINO".equalsIgnoreCase(phrase != null ? phrase.trim() : "")) {
					response.sendError(400);
					return;
				}
				System.out.print("OTTENGO PASS: " + password + "E MAIL " + email + " ED IL MATCH RISULTA "
						+ UserService.verifyPassword(email, password, DBConnection.getConnection()));
				// 2) verifica password utente (usa tuo PasswordUtil/BCrypt)
				if (!UserService.verifyPassword(email, password, DBConnection.getConnection())) {
					response.sendError(401);
					return;
				}

				ListaArticoli listaA = new ListaArticoli();
				List<String> articoli = listaA.getAllNomi();
				String articoliJson = "[\"" + String.join("\",\"", articoli) + "\"]";
				// JSON out
				response.setContentType("application/json");
				response.getWriter().write(
						"{\"challengeId\":\"" + userId + "\",\"totaleArticoli\":" + articoliJson + ",\"totalePezzi\":"
								+ listaA.countArticoli() + "}");

			}

			if ("execute".equals(step)) {
				String challengeId = request.getParameter("challengeId");
				String otp = request.getParameter("otp");
				if (!UserService.verifyOtp(otp, DBConnection.getConnection())) {
					response.sendError(401);
					return;
				}
				Path dir = Paths.get("/var/backups/tecnodeposit"); // o "C:/var/backups/tecnodeposit" su Windows
				Files.createDirectories(dir); // crea se mancante

				Path dump = dir.resolve("backupBy_" + userId + "_articoli_" + TableMaintenance.timestamp() + ".sql");
				// passa 'dump' al metodo di dump

				TableMaintenance.backupAndClearTable(
						DBConnection.getConnection(),
						"articolo",
						dump,
						/* preferTruncate */ false, // usa DELETE (più sicuro, rollback possibile)
						/* preserveAutoIncrementIfTruncate */ true,
						/* includeTriggers */ true);
				response.sendRedirect("impostazioni");
				return;
			}
		} catch (Exception e) {
			response.sendRedirect("impostazioni");
			return;
		}
		String action = request.getParameter("action");
		if (action == null) {
			Part filePart = request.getPart("file");

			if (filePart != null && filePart.getSize() > 0) {
				System.out.println("HO PRESO IL FILE");
				List<String> lines = new ArrayList<>();
				try (BufferedReader br = new BufferedReader(
						new InputStreamReader(filePart.getInputStream(), StandardCharsets.UTF_8))) {
					String line;
					while ((line = br.readLine()) != null) {
						// rimuovi eventuale BOM dalla prima riga
						if (lines.isEmpty() && line.length() > 0 && line.charAt(0) == '\uFEFF') {
							line = line.substring(1);
						}
						lines.add(line);
					}
				}
				List<Articolo> articoli = ArticoloImportParser.read(lines);

				int inseriti = 0;
				ListaArticoli la = new ListaArticoli();
				for (Articolo a : articoli) {
					try {
						la.addArticolo(a);
					} catch (Exception ex) {
						ex.printStackTrace();
					}
				}
				response.sendRedirect("impostazioni");
				return;

			}
		}

		System.out.println("RICEVUTO: " + action);
		UserService us = new UserService();

		if ("add".equals(action) || "update".equals(action)) {

			String username = request.getParameter("username");
			String nome = request.getParameter("nome");
			String cognome = request.getParameter("cognome");
			String mail = request.getParameter("mail");
			String password = request.getParameter("password");
			String telefono = request.getParameter("telefono");
			String ruolo = request.getParameter("ruolo");
			System.out.println("ruolo= " + ruolo);

			// u.setTelefono(telefono);

			if ("add".equals(action))
				try {
					boolean inserted = us.registerUser(username, mail, nome, cognome, password, ruolo, telefono,
							DBConnection.getConnection());

					if (!inserted) {
						response.sendRedirect(request.getContextPath() + "/impostazioni?error=duplicate");
						return;
					}

					// Email + crittografia in blocco separato:
					// se fallisce, l'utente è già creato → nessun errore 500
					try {
						int idUser = us.getIdByUsername(username, DBConnection.getConnection());
						SecretKey aesKey = CryptoUtil.loadAesKeyFromEnv("TD_AES_KEY_B64");

						byte[] payload = CryptoUtil.encryptAesGcm(
								password.getBytes(StandardCharsets.UTF_8),
								aesKey);

						String tokenHex = TokenDAO.randomHex(32);
						Instant expiresAt = Instant.now().plus(24, ChronoUnit.HOURS);
						TokenDAO.insertRevealToken(idUser, tokenHex, payload, expiresAt);

						// Get base URL from config or system property
						String baseUrl = System.getProperty("app.base.url", "http://localhost:8080/TecnoDeposit");
						String revealUrl = baseUrl + "/credenziali?token=" + tokenHex;

						// Create email service from configuration
						EmailService mailer = EmailConfig.createEmailService();

						String html = """
								<!DOCTYPE html>
								<html lang="it">
								<head>
								  <meta charset="UTF-8">
								  <title>Messaggio di sicurezza</title>
								  <meta name="x-apple-disable-message-reformatting">
								  <meta name="color-scheme" content="light only">
								  <style>
								    /* Alcuni client accettano media query basiche */
								    @media only screen and (max-width:600px){
								      .container{width:100% !important}
								      .padded{padding-left:20px !important;padding-right:20px !important}
								    }
								  </style>
								</head>
								<body style="margin:0;padding:0;background:#f8fafc;font-family:Arial,Helvetica,sans-serif;">
								  <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#f8fafc;">
								    <tr>
								      <td align="center" style="padding:24px 12px;">
								        <table role="presentation" width="600" class="container" cellpadding="0" cellspacing="0" style="width:600px;max-width:600px;background:#ffffff;border-radius:10px;overflow:hidden;">
								          <!-- Header -->
								          <tr>
								            <td style="background:#dc2626;padding:20px 24px;color:#ffffff;">
								              <table role="presentation" width="100%%">
								                <tr>
								                  <td align="left">
								                    <div style="font-size:22px;font-weight:700;line-height:1.2;">Messaggio Di Sicurezza</div>
								                    <div style="font-size:13px;opacity:.9;">One-time reveal link</div>
								                  </td>
								                  <td align="right">

								                  </td>
								                </tr>
								              </table>
								            </td>
								          </tr>

								          <!-- Body -->
								          <tr>
								            <td class="padded" style="padding:24px;">
								              <table role="presentation" width="100%%" cellpadding="0" cellspacing="0">
								                <tr>
								                  <td style="padding-bottom:16px;">
								                    <table role="presentation">
								                      <tr>
								                        <td style="padding-right:12px;">
								                          <img src="https://tecnodeposit.it/img/Icon.png" alt="TecnoDeposit" width="48" height="48" style="border-radius:999px;display:block;">
								                        </td>
								                        <td>
								                          <div style="font-weight:700;">TecnoDeposit</div>
								                          <div style="font-size:12px;color:#6b7280;">via no-reply@tecnodeposit.it</div>
								                        </td>
								                      </tr>
								                    </table>
								                  </td>
								                </tr>

								                <tr><td style="font-size:18px;font-weight:700;padding-bottom:8px;">Hai ricevuto un messaggio di sicurezza</td></tr>
								                <tr><td style="color:#374151;padding-bottom:8px;">Ciao,</td></tr>
								                <tr><td style="color:#374151;padding-bottom:8px;">L'admin del gestionale TecnoDeposit ha creato un account per te!</td></tr>
								                <tr><td style="color:#374151;padding-bottom:8px;">Le credenziali di accesso sono username: ___USERNAME___ e la password la puoi scoprire cliccando il pulsante qui sotto.</td></tr>
								                <tr><td style="color:#374151;padding-bottom:16px;">Attenzione! Il link scadrà una volta aperto: assicurati di salvare la password da qualche parte.</td></tr>

								                <!-- Pulsante -->
								                <tr>
								                  <td align="center" style="padding:16px 0 8px 0;">
								                    <a href="___TOKEN___"
								                       style="background:#2563eb;color:#ffffff;text-decoration:none;font-weight:700;
								                              display:inline-block;padding:12px 24px;border-radius:10px;">
								                      <!-- Occhio SVG -->
								                      <span style="vertical-align:middle;display:inline-block;margin-right:8px;">
								                        <svg width="18" height="18" viewBox="0 0 24 24" aria-hidden="true">
								                          <path fill="#ffffff" d="M12 5C7 5 2.73 8.11 1 12c1.73 3.89 6 7 11 7s9.27-3.11 11-7c-1.73-3.89-6-7-11-7zm0 12a5 5 0 110-10 5 5 0 010 10zm0-8a3 3 0 100 6 3 3 0 000-6z"/>
								                        </svg>
								                      </span>
								                      Scopri password
								                    </a>
								                    <div style="font-size:11px;color:#6b7280;margin-top:6px;">Questo link è monouso.</div>
								                  </td>
								                </tr>

								                <!-- Box sicurezza -->
								                <tr>
								                  <td style="background:#f3f4f6;border-radius:8px;padding:12px;color:#374151;">
								                    <table role="presentation">
								                      <tr>
								                        <td style="vertical-align:top;padding-right:8px;">
								                          <svg width="18" height="18" viewBox="0 0 24 24" aria-hidden="true">
								                            <path fill="#10b981" d="M12 2a10 10 0 1010 10A10.011 10.011 0 0012 2zm1 15h-2v-2h2zm0-4h-2V7h2z"/>
								                          </svg>
								                        </td>
								                        <td>
								                          <div style="font-weight:700;margin-bottom:4px;">Security Information</div>
								                          <div style="font-size:13px;color:#4b5563;">Questo è un link One-Time-Reveal e verrà eliminato una volta utilizzato.</div>
								                        </td>
								                      </tr>
								                    </table>
								                  </td>
								                </tr>

								                <tr><td style="font-size:13px;color:#6b7280;padding-top:12px;">
								                  Se non aspettavi questo messaggio, <a href="mailto:assistenza@tecnodeposit.it" style="color:#2563eb;">contattaci</a>.
								                </td></tr>
								              </table>
								            </td>
								          </tr>

								          <!-- Footer -->
								          <tr>
								            <td align="center" style="background:#f3f4f6;padding:16px;color:#4b5563;font-size:12px;">
								              <div>™ 2025 TecnoDeposit</div>
								              <div style="margin-top:4px;"><a href="https://www.tecnodeposit.it" style="color:#2563eb;text-decoration:none;">www.tecnodeposit.it</a></div>
								            </td>
								          </tr>

								        </table>
								      </td>
								    </tr>
								  </table>
								</body>
								</html>
								""";
						html = html.replace("___TOKEN___", revealUrl);
						html = html.replace("___USERNAME___", "<b>" + username + "</b>");

						mailer.sendHtml(mail, "Creazione Account TecnoDeposit | " + revealUrl, html,
								"no-reply@tecnodeposit.it");
						System.out.println("✅ Email inviata a " + mail);
					} catch (Exception emailEx) {
						// Email/crypto fallita, ma l'utente è già stato creato
						System.err.println(
								"⚠️ Utente '" + username + "' creato, ma invio email fallito: " + emailEx.getMessage());
						emailEx.printStackTrace();
					}

				} catch (SQLException e) {
					System.err.println("❌ Errore creazione utente: " + e.getMessage());
					e.printStackTrace();
				}
			if ("update".equals(action)) {
				int id = Integer.parseInt(request.getParameter("id"));
				us.updateUser(username, mail, nome, cognome, password, ruolo, telefono, id);

			}
			response.sendRedirect(request.getContextPath() + "/impostazioni");
		} else if ("delete".equals(action)) {
			String idStr = request.getParameter("id");
			System.out.println("SIAMO UI");
			if (idStr != null && !idStr.isEmpty()) {
				try {
					int id = Integer.parseInt(idStr);

					System.out.println("✅ ELIMINANDO Articolo: " + id);
					us.deleteUser(id);
				} catch (NumberFormatException e) {
					System.err.println("❌ ID non valido per la cancellazione: " + idStr);
					// Puoi anche gestire un errore utente qui
				}
			} else {
				System.err.println("❌ Parametro 'id' mancante per la cancellazione.");
			}

			response.sendRedirect(request.getContextPath() + "/impostazioni");
		}
	}

}
