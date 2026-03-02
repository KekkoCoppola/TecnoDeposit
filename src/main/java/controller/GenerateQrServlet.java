package controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;

import dao.TokenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/api/generate-qr-login")
public class GenerateQrServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Verifica sessione e autenticazione
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Utente non autenticato o sessione scaduta\"}");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Generazione del token sicuro (64 hex characters)
        String tokenHex = TokenDAO.randomHex(32);
        // Scadenza a 2 minuti da ora (temporaneo)
        Instant expiresAt = Instant.now().plus(2, ChronoUnit.MINUTES);

        try {
            // Inseriamo nel DB mascherato
            TokenDAO.insertQrToken(userId, tokenHex, expiresAt);

            // Risposta JSON di successo
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            PrintWriter out = response.getWriter();
            out.print("{\"success\": true, \"token\": \"" + tokenHex + "\"}");
            out.flush();

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500
            response.setContentType("application/json");
            response.getWriter().write("{\"error\": \"Errore di sistema nella generazione del QR Code\"}");
        }
    }
}
