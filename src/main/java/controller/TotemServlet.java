package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.DBConnection;
import dao.TokenDAO;
import model.Articolo;
import model.ListaArticoli;
import model.UserService;

public class TotemServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Pagina di Login del Totem
            // Invalida sessione se esiste per emulare un utente "totem" slegato dagli
            // accessi normali
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            req.getRequestDispatcher("/totem_login.jsp").forward(req, resp);
        } else if (pathInfo.equals("/dashboard")) {
            // Controlla se il totem è autenticato nella sessione corrente
            HttpSession session = req.getSession(false);
            if (session != null && Boolean.TRUE.equals(session.getAttribute("totem_auth"))) {
                req.getRequestDispatcher("/totem_dashboard.jsp").forward(req, resp);
            } else {
                // Se non ha il PIN valido in sessione, torna al login del totem
                resp.sendRedirect(req.getContextPath() + "/t-8f92a1b3c4d5e6f7g8h9i0j");
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pathInfo = req.getPathInfo();

        if (pathInfo == null || pathInfo.equals("/")) {
            // Seleziona la logica in base al parametro ricevuto: PIN o QR Token
            String qrToken = req.getParameter("qr_token");
            String pin = req.getParameter("pin");

            if (qrToken != null && !qrToken.trim().isEmpty()) {
                // HOTFIX per layout tastiera Scanner: i lettori configurati su layout US
                // in un OS italiano traducono fisicamente il tasto '-' in un apostrofo '''.
                qrToken = qrToken.replace("'", "-");

                jakarta.servlet.http.HttpSession session = req.getSession(false);
                Integer loggedUserId = (session != null) ? (Integer) session.getAttribute("logged_totem_userId") : null;

                if (loggedUserId != null) {
                    // L'utente è loggato: la scansione è una matricola di un articolo
                    Articolo articolo = ListaArticoli.getArticoloByMatricola(qrToken);
                    if (articolo != null) {
                        @SuppressWarnings("unchecked")
                        List<Articolo> scannedArticles = (List<Articolo>) session
                                .getAttribute("totem_scanned_articles");
                        if (scannedArticles == null) {
                            scannedArticles = new ArrayList<>();
                        }
                        // Evita duplicati (opzionale, ma consigliato)
                        boolean alreadyScanned = scannedArticles.stream()
                                .anyMatch(a -> a.getMatricola().equals(articolo.getMatricola()));
                        if (!alreadyScanned) {
                            scannedArticles.add(articolo);
                            session.setAttribute("totem_scanned_articles", scannedArticles);
                            session.setAttribute("totem_success_msg", "Articolo aggiunto!");
                        } else {
                            session.setAttribute("totem_error_msg", "Articolo già in lista.");
                        }
                    } else {
                        session.setAttribute("totem_error_msg", "Articolo non trovato.");
                    }
                    resp.sendRedirect(req.getContextPath() + "/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard");

                } else {
                    // Nessun utente loggato: la scansione è un token di login
                    TokenDAO tokenDAO = new TokenDAO();
                    try {
                        TokenDAO validToken = tokenDAO.findValidQrToken(qrToken);
                        if (validToken != null) {
                            int userId = validToken.userId;
                            String userNome = UserService.getNomeById(userId);

                            tokenDAO.markUsedAndWipe(validToken.id);

                            if (session != null) {
                                session.setAttribute("logged_totem_user", userNome);
                                session.setAttribute("logged_totem_userId", userId);
                                session.setAttribute("totem_scanned_articles", new ArrayList<Articolo>()); // Inizializza
                                                                                                           // la lista
                                session.setAttribute("totem_success_msg", "Benvenuto " + userNome + "!");
                            }

                            resp.sendRedirect(req.getContextPath() + "/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard");
                        } else {
                            if (session != null) {
                                session.setAttribute("totem_error_msg", "QR Code non valido o scaduto.");
                            }
                            resp.sendRedirect(req.getContextPath() + "/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                        if (session != null)
                            session.setAttribute("totem_error_msg", "Errore DB: Impossibile verificare il QR.");
                        resp.sendRedirect(req.getContextPath() + "/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard");
                    }
                }

            } else if (pin != null) {
                // Logica PIN (Accesso alla postazione Totem)
                UserService userService = new UserService();
                String ruolo = null;

                try (Connection conn = DBConnection.getConnection()) {
                    ruolo = userService.loginUser("totem", pin, conn);
                } catch (SQLException e) {
                    e.printStackTrace();
                    req.setAttribute("error", "Errore di connessione al database.");
                    req.getRequestDispatcher("/totem_login.jsp").forward(req, resp);
                    return;
                }

                if (ruolo != null) {
                    HttpSession session = req.getSession(true);
                    session.setAttribute("totem_auth", true);
                    session.setAttribute("ruolo", "totem");
                    resp.sendRedirect(req.getContextPath() + "/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard");
                } else {
                    req.setAttribute("error", "PIN errato o postazione non configurata.");
                    req.getRequestDispatcher("/totem_login.jsp").forward(req, resp);
                }
            } else {
                req.getRequestDispatcher("/totem_login.jsp").forward(req, resp);
            }
        } else if (pathInfo.equals("/dashboard")) {
            // Logica per le azioni di finalizzazione (Assegna / Deposita) dalla Dashboard
            String action = req.getParameter("totem_action");
            HttpSession session = req.getSession(false);

            if (session != null && Boolean.TRUE.equals(session.getAttribute("totem_auth")) && action != null) {
                @SuppressWarnings("unchecked")
                List<Articolo> scannedArticles = (List<Articolo>) session.getAttribute("totem_scanned_articles");
                String loggedUser = (String) session.getAttribute("logged_totem_user");

                if (scannedArticles != null && !scannedArticles.isEmpty() && loggedUser != null) {
                    ListaArticoli la = new ListaArticoli();

                    try {
                        if ("assign".equals(action)) {
                            for (Articolo art : scannedArticles) {
                                art.setStato(Articolo.Stato.ASSEGNATO);
                                art.setTecnico(loggedUser);
                                la.updateArticolo(art, loggedUser);
                            }
                            session.setAttribute("totem_success_msg",
                                    scannedArticles.size() + " articoli assegnati a " + loggedUser);

                        } else if ("deposit".equals(action)) {
                            String brokenMatricoleStr = req.getParameter("broken_matricole");
                            List<String> brokenMatricole = new ArrayList<>();

                            if (brokenMatricoleStr != null && !brokenMatricoleStr.trim().isEmpty()) {
                                String[] parts = brokenMatricoleStr.trim().split("\\r?\\n");
                                for (String p : parts) {
                                    String mat = p.trim().replace("'", "-"); // Hotfix scanner US->IT layout
                                    if (!mat.isEmpty()) {
                                        brokenMatricole.add(mat);
                                    }
                                }
                            }

                            int guastiCount = 0;
                            int magazzinoCount = 0;

                            for (Articolo art : scannedArticles) {
                                if (brokenMatricole.contains(art.getMatricola())) {
                                    art.setStato(Articolo.Stato.GUASTO);
                                    guastiCount++;
                                } else {
                                    art.setStato(Articolo.Stato.IN_MAGAZZINO);
                                    magazzinoCount++;
                                }
                                art.setTecnico(""); // Rimuove eventuali assegnazioni
                                la.updateArticolo(art, loggedUser);
                            }

                            session.setAttribute("totem_success_msg", "Deposito completato: " + magazzinoCount
                                    + " In Magazzino, " + guastiCount + " Guasti.");
                        } else if ("cancel".equals(action)) {
                            session.setAttribute("totem_success_msg", "Operazione annullata. Operatore scollegato.");
                        }

                        // Svuota la coda dopo l'operazione e scollega l'operatore
                        scannedArticles.clear();
                        session.setAttribute("totem_scanned_articles", scannedArticles);
                        session.removeAttribute("logged_totem_userId");
                        session.removeAttribute("logged_totem_user");

                    } catch (SQLException e) {
                        e.printStackTrace();
                        session.setAttribute("totem_error_msg", "Errore durante il salvataggio nel database.");
                    }
                }
            }
            resp.sendRedirect(req.getContextPath() + "/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard");
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
