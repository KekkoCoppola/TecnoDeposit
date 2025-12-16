package controller;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import dao.DBConnection;

//@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Ottieni la sessione corrente, se esiste
        HttpSession session = request.getSession(false);
        
        if (session != null) {
        	String username = (String) session.getAttribute("username");
        	Connection conn;
			try {
				conn = DBConnection.getConnection();
				PreparedStatement attivoStmt = conn.prepareStatement(
        	        "UPDATE utenti SET stato = 'inattivo' WHERE username = ?");
            attivoStmt.setString(1, username);
            attivoStmt.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            
            
            session.invalidate(); // Invalida la sessione
            System.out.println("INVALIDO SESSIONE... logout di "+username);
            
            
        }
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberToken".equals(cookie.getName())) {
                	System.out.println("STO ELIMINANDO IL COOKIE");
                    String token = cookie.getValue();
                    LoginServlet.tokenStore.remove(token);

                    // Elimina cookie nel browser
                    cookie.setMaxAge(0);
                    cookie.setPath("/");
                    response.addCookie(cookie);
                }
            }
        }
        
        // Reindirizza l'utente alla pagina di login (o homepage)
        response.sendRedirect(request.getContextPath() + "/login");
    }
}
