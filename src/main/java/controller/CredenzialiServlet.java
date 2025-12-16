package controller;

import dao.TokenDAO;
import util.CryptoUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import javax.crypto.SecretKey;
import java.io.IOException;
import java.nio.charset.StandardCharsets;


public class CredenzialiServlet extends HttpServlet {
    private final TokenDAO tokenDAO = new TokenDAO();
    private SecretKey aesKey;

    @Override public void init() {
        // Carico la chiave AES una volta sola
        aesKey = CryptoUtil.loadAesKeyFromEnv("TD_AES_KEY_B64");
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String token = req.getParameter("token");
        if (token == null || token.length() != 64) {
            req.setAttribute("error", "Link non valido.");
            req.getRequestDispatcher("/credenziali_error.jsp").forward(req, resp);
            return;
        }

        dao.TokenDAO ut;
        try {
            ut = tokenDAO.findValidByToken(token);
            if (ut == null || ut.payload == null) {
                req.setAttribute("error", "Link scaduto o già utilizzato.");
                req.getRequestDispatcher("/credenziali_error.jsp").forward(req, resp);
                return;
            }

            // Decifra password
            byte[] plain = util.CryptoUtil.decryptAesGcm(ut.payload, aesKey);
            String password = new String(plain, StandardCharsets.UTF_8);

            // ONE-TIME: invalida subito e cancella payload
            tokenDAO.markUsedAndWipe(ut.id);

            // Passo la password alla JSP (non loggare!)
            req.setAttribute("password", password);
            req.getRequestDispatcher("/credenziali.jsp").forward(req, resp);

        } catch (Exception e) {
            req.setAttribute("error", "Errore interno. Contatta l'amministratore.");
            req.getRequestDispatcher("/credenziali_error.jsp").forward(req, resp);
        }
    }
}
