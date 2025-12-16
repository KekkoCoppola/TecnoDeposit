package controller;

import java.util.List;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.Articolo;
import model.ListaArticoli;
import model.ListaFornitori;

public class CatalogoFornitoreServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login");
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        String mail = "ERRORE MAIL";
		try {
			mail = ListaFornitori.getMailFornitore(id);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
        List<Articolo> lista = ListaArticoli.getArticoloByFornitore(id);
        
        request.setAttribute("articoliFornitore", lista);
        request.setAttribute("mailFornitore", mail);
        //System.out.println("MAIL OTTENUTA: "+mail);
        RequestDispatcher dispatcher = request.getRequestDispatcher("catalogoFornitore.jsp");
		dispatcher.include(request, response);
    	
    }
}
