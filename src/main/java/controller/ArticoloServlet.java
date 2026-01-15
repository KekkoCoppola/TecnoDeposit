package controller;

import model.Articolo;
import model.Articolo.Stato;
import model.ListaArticoli;
import util.ImageUtil;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class ArticoloServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login");
            return;
        }
        String action = request.getParameter("action");
        String assegnaAction = request.getParameter("assegnaAction");
        String nomeCognome = (String) session.getAttribute("nomeCognome");
        String username = (String) session.getAttribute("username");

        System.out.println("RICEVUTO: " + action);

        if ("add".equals(action) || "update".equals(action)) {

            String statoStr = request.getParameter("stato");
            Stato stato = Stato.valueOf(statoStr.replace(" ", "_").toUpperCase());

            String nome = getValidParam(request, "nome");
            String marca = getValidParam(request, "marca");
            String compatibilita = getValidParam(request, "compatibilita");
            String fornitore = getValidParam(request, "fornitore");
            String matricola = getValidParam(request, "matricola");
            String provenienza = getValidParam(request, "provenienza");
            String tecnico = getValidParam(request, "tecnico");
            String pv = getValidParam(request, "pv");
            String note = getValidParam(request, "note");
            boolean garanziaFlag = "SI".equals(request.getParameter("checkGaranzia")) ? true : false;
            System.out.println(
                    "OTTENUTA RICHIESTA = " + garanziaFlag + " da valore " + request.getParameter("checkGaranzia")
                            + " con richiedente " + username);

            // Invalida cache prima di cercare l'immagine (assicura che immagini appena
            // caricate siano trovate)
            ImageUtil.invalidateCache();

            // Usa ImageUtil centralizzato per trovare l'immagine
            String immagine = ImageUtil.trovaImmagineArticolo(nome, marca, getServletContext().getRealPath("/img"),
                    "img");
            System.out.println("📷 Immagine trovata per " + nome + "/" + marca + ": " + immagine);

            int ddt = -1;
            int ddtSpedizione = -1;
            try {
                String ddtStr = request.getParameter("ddt");
                String ddtSpedizioneStr = request.getParameter("ddtSpedizione");
                if (ddtStr != null && !ddtStr.isEmpty()) {
                    ddt = Integer.parseInt(ddtStr);
                }
                if (ddtSpedizioneStr != null && !ddtSpedizioneStr.isEmpty()) {
                    ddtSpedizione = Integer.parseInt(ddtSpedizioneStr);
                }
            } catch (NumberFormatException e) {
                System.err.println("❌ Errore nel parsing di 'ddt'");
            }

            LocalDate dataRic_DDT = parseLocalDate(request.getParameter("dataRic_DDT"));
            LocalDate dataSpe_DDT = parseLocalDate(request.getParameter("dataSpe_DDT"));
            LocalDate dataGaranzia = parseLocalDate(request.getParameter("dataGaranzia"));

            Articolo articolo = new Articolo(nome, marca, compatibilita, matricola, provenienza, note, ddt, stato,
                    tecnico, fornitore, pv, dataRic_DDT, dataSpe_DDT, dataGaranzia, immagine, ddtSpedizione,
                    garanziaFlag);
            ListaArticoli listaArticoli = new ListaArticoli();

            if ("add".equals(action))
                listaArticoli.addArticolo(articolo);
            if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                articolo.setId(id);
                System.out.println("ID ARTICOLO " + id);
                try {
                    listaArticoli.updateArticolo(articolo, username);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
            if ("assegna".equals(assegnaAction)) {
                int id = Integer.parseInt(request.getParameter("id"));
                articolo.setId(id);
                articolo.setStato(Stato.ASSEGNATO);
                articolo.setTecnico(nomeCognome);

                System.out.println("ID ARTICOLO " + id);
                try {
                    listaArticoli.updateArticolo(articolo, username);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }

            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            System.out.println("SIAMO UI");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    ListaArticoli listaArticoli = new ListaArticoli();
                    System.out.println("✅ ELIMINANDO Articolo: " + id);
                    listaArticoli.deleteArticolo(id);
                } catch (NumberFormatException e) {
                    System.err.println("❌ ID non valido per la cancellazione: " + idStr);
                }
            } else {
                System.err.println("❌ Parametro 'id' mancante per la cancellazione.");
            }

            response.sendRedirect(request.getContextPath() + "/dashboard");
        }
    }

    private String getValidParam(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        return (value != null && !value.trim().isEmpty()) ? value : "";
    }

    private LocalDate parseLocalDate(String dateStr) {
        if (dateStr != null && !dateStr.trim().isEmpty()) {
            try {
                return LocalDate.parse(dateStr);
            } catch (DateTimeParseException e) {
                System.err.println("❌ Errore nel parsing della data: " + dateStr);
            }
        }
        return null;
    }
}
