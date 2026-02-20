package controller;

import model.Articolo;
import model.ListaArticoli;
import util.ImageUtil;
import util.ImageStorageConfig;
import dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;

/**
 * Servlet per il refresh massivo delle immagini articolo.
 * Itera tutti gli articoli, ricalcola il match immagine dal filesystem
 * usando ImageUtil.trovaImmagineArticolo(), e aggiorna la colonna immagine nel
 * DB.
 * 
 * Endpoint: GET /api/refresh-images
 * Risposta: JSON {"success": true, "updated": N}
 */
public class ImageRefreshServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Verifica autenticazione e ruolo
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            sendError(response, "Non autenticato", 401);
            return;
        }

        String ruolo = (String) session.getAttribute("ruolo");
        if (!"Amministratore".equals(ruolo) && !"Magazziniere".equals(ruolo)) {
            sendError(response, "Permesso negato", 403);
            return;
        }

        try {
            // 1. Invalida la cache immagini per forzare la ri-scansione del filesystem
            ImageUtil.invalidateCache();

            // 2. Carica tutti gli articoli
            ListaArticoli lista = new ListaArticoli();
            List<Articolo> articoli = lista.getAllarticoli();

            String imageDir = ImageStorageConfig.getImageDirectory(getServletContext());
            int updated = 0;

            // 3. Aggiorna le immagini nel DB con un batch di UPDATE leggeri
            String sql = "UPDATE articolo SET immagine = ? WHERE id = ?";

            try (Connection conn = DBConnection.getConnection();
                    PreparedStatement stmt = conn.prepareStatement(sql)) {

                for (Articolo a : articoli) {
                    String nuovaImmagine = ImageUtil.trovaImmagineArticolo(
                            a.getNome(), a.getMarca(), imageDir, "ext-img");

                    // Aggiorna solo se l'immagine è cambiata
                    String vecchiaImmagine = a.getImmagine();
                    if (vecchiaImmagine == null || !vecchiaImmagine.equals(nuovaImmagine)) {
                        stmt.setString(1, nuovaImmagine);
                        stmt.setInt(2, a.getId());
                        stmt.addBatch();
                        updated++;
                    }
                }

                if (updated > 0) {
                    stmt.executeBatch();
                }
            }

            System.out.println(
                    "🔄 [ImageRefresh] Aggiornate " + updated + " immagini su " + articoli.size() + " articoli");

            // 4. Risposta JSON
            PrintWriter out = response.getWriter();
            out.print("{\"success\":true,\"updated\":" + updated + ",\"total\":" + articoli.size() + "}");
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Errore durante il refresh: " + e.getMessage(), 500);
        }
    }

    private void sendError(HttpServletResponse response, String message, int status) throws IOException {
        response.setStatus(status);
        PrintWriter out = response.getWriter();
        out.print("{\"success\":false,\"error\":\"" + message.replace("\"", "\\\"") + "\"}");
        out.flush();
    }
}
