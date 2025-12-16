package controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.Fornitore;
import model.ListaFornitori;


public class fornitoriServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Verifica se l'utente è loggato
		HttpSession session = request.getSession(false); // false significa non creare una nuova sessione se non esiste
        if (session == null || session.getAttribute("username") == null) {
            // Se la sessione non esiste o non contiene l'attributo "user", l'utente non è loggato
            response.sendRedirect("login"); // Reindirizza l'utente alla pagina di login
            return;
        }
        
		ListaFornitori lista = new ListaFornitori();

        String nome = request.getParameter("search");

		List<Fornitore> filtrata= lista.filtra(nome);
		//System.out.println("OTTENGO LA LISTA : "+filtrata);
        request.setAttribute("fornitori", filtrata);
        
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        if (isAjax) {
            request.getRequestDispatcher("partials/risultatiFornitori.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/fornitori.jsp").forward(request, response);
        }
        
    }
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login");
            return;
        }
		String action = request.getParameter("action");
	      
        System.out.println("RICEVUTO: "+action);
   
        if ("add".equals(action) || "update".equals(action)) {
            
        	String nome = request.getParameter("nome");
        	String mail = request.getParameter("mail");
        	String indirizzo = request.getParameter("indirizzo");
        	String iva = request.getParameter("iva");
        	String telefono = request.getParameter("telefono");
        	
        	Fornitore f = new Fornitore(nome,mail,iva ,indirizzo,telefono);
            
            ListaFornitori listaFornitori= new ListaFornitori();
            
            if("add".equals(action))
            	listaFornitori.addFornitore(f);
            if("update".equals(action)) {
            	int id = Integer.parseInt(request.getParameter("id"));
                f.setId(id);
                listaFornitori.updateFornitore(f);
            }
            	

            response.sendRedirect(request.getContextPath() + "/fornitori");
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            System.out.println("SIAMO UI");
            if (idStr != null && !idStr.isEmpty()) {
                try {
                    int id = Integer.parseInt(idStr);
                    ListaFornitori listaFornitori= new ListaFornitori();
                    System.out.println("✅ ELIMINANDO Articolo: " + id);
                    listaFornitori.deleteFornitore(id);
                } catch (NumberFormatException e) {
                    System.err.println("❌ ID non valido per la cancellazione: " + idStr);
                    // Puoi anche gestire un errore utente qui
                }
            } else {
                System.err.println("❌ Parametro 'id' mancante per la cancellazione.");
            }

            response.sendRedirect(request.getContextPath() + "/fornitori");
        }
	}

}
