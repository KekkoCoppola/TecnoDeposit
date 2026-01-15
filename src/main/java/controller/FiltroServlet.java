package controller;

import model.Articolo;
import model.ListaArticoli;
import util.ImageUtil;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.IOException;
import java.util.List;

public class FiltroServlet extends HttpServlet {
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Disabilita cache browser per garantire contenuto sempre aggiornato
		response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
		response.setHeader("Pragma", "no-cache");
		response.setDateHeader("Expires", 0);

		StringBuffer url = request.getRequestURL(); // es: http://localhost:8080/TecnoDeposit/dashboard
		String query = request.getQueryString(); // es: stato=In%20attesa

		System.out.println("URL: " + url.toString());
		System.out.println("Query string: " + query);
		int page = 1;
		int size = 24;
		try {
			page = Integer.parseInt(request.getParameter("page"));
		} catch (Exception ignore) {
		}
		try {
			size = Integer.parseInt(request.getParameter("size"));
		} catch (Exception ignore) {
		}
		if (page < 1)
			page = 1;
		if (size < 1)
			size = 24;

		try {
			ListaArticoli lista = new ListaArticoli();

			String search = request.getParameter("search");
			String stato = request.getParameter("stato");
			String marca = request.getParameter("marca");
			String data = request.getParameter("data");
			String nome = request.getParameter("nome");
			String checkInstallati = request.getParameter("installatiCheck");

			HttpSession session = request.getSession();
			if (session.getAttribute("installatiCheck") == null) {
				session.setAttribute("installatiCheck", "nascondi");
			}

			// aggiorna la preferenza SOLO se il parametro è presente
			if (checkInstallati != null && ("mostra".equals(checkInstallati) || "nascondi".equals(checkInstallati))) {
				session.setAttribute("installatiCheck", checkInstallati);
			}

			if (stato != null && "Tutti".equals(stato))
				stato = "";
			if (marca != null && "Tutte".equals(marca))
				marca = "";

			List<Articolo> filtrata = lista.filtra(
					search, stato, marca, data, nome,
					(String) session.getAttribute("installatiCheck"));
			String[] stati = {
					"In attesa", "In magazzino", "Installato",
					"Destinato", "Assegnato", "Guasto",
					"Riparato", "Non Riparato", "Non Riparabile"
			};
			for (String stato1 : stati) {
				long count = filtrata.stream()
						.filter(a -> stato1.equalsIgnoreCase(a.getStato().toString()))
						.count();

				// crea un nome attributo leggibile, es. "countInAttesa"
				String nomeAttr = "count" + stato1
						.replace(" ", "") // rimuove spazi
						.replace("à", "a") // eventuali accentate
						.replace("è", "e");
				if (stato1.equals("Non Riparato"))
					System.out.println(nomeAttr);
				request.setAttribute(nomeAttr, count);
			}

			int total = filtrata.size();
			int from = Math.min((page - 1) * size, total);
			int to = Math.min(from + size, total);
			List<Articolo> pageItems = filtrata.subList(from, to);
			request.setAttribute("TotaleArticoli", total);
			// fallback immagine SOLO sugli elementi della pagina
			for (Articolo a : pageItems) {
				if (a.getImmagine() == null || a.getImmagine().isEmpty()) {
					a.setImmagine(ImageUtil.trovaImmagineArticolo(
							a.getNome(), a.getMarca(),
							getServletContext().getRealPath("/img"), "img"));
				}
			}

			// passa SOLO la pagina alla JSP
			request.setAttribute("articoli", pageItems);
			request.setAttribute("page", page);
			request.setAttribute("size", size);
			request.setAttribute("total", total);

			RequestDispatcher dispatcher = request.getRequestDispatcher("partials/risultati.jsp");
			dispatcher.include(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore interno: " + e.getMessage());
		}
	}

}
