package controller;

import java.util.List;

import java.io.IOException;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.StoricoArticoloDAO;

public class StoricoArticoloServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        // Controllo sessione
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login");
            return;
        }

        int idArticolo = Integer.parseInt(request.getParameter("id"));

        List<String> storicoList = StoricoArticoloDAO.getModificheArticolo(idArticolo);

        request.setAttribute("storico", storicoList);
        request.setAttribute("idArticolo", idArticolo);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/storicoArticolo.jsp");
        dispatcher.forward(request, response);
    }
}
