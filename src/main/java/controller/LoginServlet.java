package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.UserService;
import dao.DBConnection;
import java.io.IOException;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

//@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    public static Map<String, String> tokenStore = new HashMap<>();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session != null && session.getAttribute("username") != null) {
            // Utente già loggato → vai alla dashboard
            response.sendRedirect("dashboard");
            return;
        }
        String csrfToken = UUID.randomUUID().toString();
        request.getSession().setAttribute("csrfToken", csrfToken);

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberToken".equals(cookie.getName())) {
                    String token = cookie.getValue();
                    String username = tokenStore.get(token);

                    if (username != null) {
                        // ✅ Autologin riuscito
                        session = request.getSession(true);
                        session.setAttribute("username", username);
                        response.sendRedirect("dashboard");
                        return;
                    }
                }
            }
        }
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember-me");

        username = username.trim().toLowerCase();
        password = password.trim();

        String sessionToken = (String) request.getSession().getAttribute("csrfToken");
        String requestToken = request.getParameter("csrfToken");

        if (sessionToken == null || !sessionToken.equals(requestToken)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF token non valido");
            return;
        }

        Connection conn = null;
        try {
            conn = DBConnection.getConnection(); // Tua classe DBManager per la connessione al DB
            UserService userService = new UserService();

            String role = userService.loginUser(username, password, conn);

            if (role != null) {
                // Login riuscito, imposta la sessione
                HttpSession oldSession = request.getSession(false);
                if (oldSession != null)
                    oldSession.invalidate();

                HttpSession session = request.getSession(); // Otteniamo la sessione corrente o ne creiamo una nuova
                session.setAttribute("username", username);
                session.setAttribute("nomeCognome", userService.getNomeCognome(username));
                session.setAttribute("mail", userService.getMail(username, conn));
                session.setAttribute("ruolo", role);
                session.setAttribute("userId", UserService.getIdByUsername(username, conn));
                session.setAttribute("showSplash", true); // Flag per mostrare splash screen

                if ("on".equals(remember)) {
                    System.out.println("STO CREANDO IL COOKIE");
                    String token = UUID.randomUUID().toString(); // token sicuro
                    tokenStore.put(token, username); // salva token -> utente

                    Cookie cookie = new Cookie("rememberToken", token);
                    cookie.setHttpOnly(true);
                    cookie.setMaxAge(60 * 60 * 24 * 30); // 30 giorni
                    response.addCookie(cookie);
                }

                response.sendRedirect("dashboard"); // Dashboard utente

            } else {
                // Credenziali errate

                request.setAttribute("loginError", "Username o password errati.");
                RequestDispatcher dispatcher = request.getRequestDispatcher("/login.jsp");
                dispatcher.forward(request, response);
            }

        } catch (SQLException e) {
            System.out.println("CIAO MA FALLITA CONNESSIONE");
            throw new ServletException(e);
        } finally {
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception ignored) {
            }
        }
    }
}
