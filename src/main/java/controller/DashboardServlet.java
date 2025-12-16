package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Articolo;
import model.ListaArticoli;
import model.ListaFornitori;
import model.UserService;

public class DashboardServlet extends HttpServlet{
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ListaArticoli lista = new ListaArticoli();
		UserService us = new UserService();
		
		
		List<String> nomi = lista.getCampo(Articolo::getNome);
		List<String> marche = lista.getCampo(Articolo::getMarca);
		List<String> compatibilita = lista.getCampo(Articolo::getCompatibilita);
		List<String> provenienza = lista.getCampo(Articolo::getProvenienza);
		ListaFornitori listaF = new ListaFornitori();
		List<String> pv = lista.getCampo(Articolo::getPv);
		List<String> fornitori = listaF.getAllfornitoriNames();
		List<String> tecnici = us.getAllTecnici();
	
		request.setAttribute("nomi", nomi);
		request.setAttribute("marche", marche);
		request.setAttribute("compatibilita", compatibilita);
		request.setAttribute("provenienze", provenienza);
		request.setAttribute("pvs", pv);
		request.setAttribute("fornitori", fornitori);
		request.setAttribute("tecnici", tecnici);
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) { 
            response.sendRedirect("login"); 
            return;
        }
        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }
	
}
