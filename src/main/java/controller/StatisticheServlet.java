package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class StatisticheServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verifica se l'utente è loggato
        HttpSession session = request.getSession(false); // false significa non creare una nuova sessione se non esiste
        if (session == null || session.getAttribute("username") == null) {
            // Se la sessione non esiste o non contiene l'attributo "user", l'utente non è loggato
            response.sendRedirect("login"); // Reindirizza l'utente alla pagina di login
            return;
        }
        
        // Se l'utente è loggato, procedi con la visualizzazione della pagina
        request.getRequestDispatcher("/statistiche.jsp").forward(request, response);
    }

}
