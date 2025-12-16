package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.NotificationService;
import model.Richiesta;
import model.RichiestaRiga;
import model.UserService;
import model.ListaArticoli;
import model.Articolo;
import model.Articolo.Stato;
import dao.DBConnection;
import dao.RichiestaDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class RichiesteServlet extends HttpServlet {
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login"); 
            return;
        }
        
        // Se l'utente è loggato, procedi con la visualizzazione della pagina
        request.getRequestDispatcher("/richieste.jsp").forward(request, response);
    }
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect("login");
            return;
        }
        
        RichiestaDAO rd = new RichiestaDAO();
        
        String op = request.getParameter("op");
        
        
        if ("delete".equals(op)) {
            int id = Integer.parseInt(request.getParameter("id"));
            try {
            	rd.removeRichiesta(id);                 // ON DELETE CASCADE rimuove anche le righe
            	response.sendRedirect(request.getContextPath() + "/richieste-materiale");
            } catch (SQLException e) {
            	response.sendError(500, "Errore cancellazione richiesta");
            }
            return;
        }if("update".equals(op)) {
        	int id = Integer.parseInt(request.getParameter("id"));
            String nuovoStato = request.getParameter("stato"); // "approvata" | "rifiutata"

            if (nuovoStato == null || 
                !(nuovoStato.equals("approvata") || nuovoStato.equals("rifiutata"))) {
            	response.sendError(400, "Stato non valido");
                return;
            }

            try {
            	Richiesta ru = RichiestaDAO.getRichiestaById(id);
            	NotificationService.createNotification(ru.getRichiedenteId(), "La tua richiesta materiale è stata "+nuovoStato);
                rd.updateRichiesta(id, nuovoStato);
                List<Articolo> listaApprovati = RichiestaDAO.getArticoliByRichiestaId(ru.getId());
                if(nuovoStato.equals("approvata")) {
                	for(Articolo art : listaApprovati) {
                		art.setStato(Stato.ASSEGNATO);
                		art.setTecnico(UserService.getNomeById(ru.getRichiedenteId()));
                		ListaArticoli la = new ListaArticoli();
                		la.updateArticolo(art, (String) session.getAttribute("username"));

                	}
                }else if(nuovoStato.equals("rifiutata")) {
                	for(Articolo art : listaApprovati) {
                		art.setStato(Stato.IN_MAGAZZINO);
                		art.setTecnico("");
                		ListaArticoli la = new ListaArticoli();
                		la.updateArticolo(art, (String) session.getAttribute("username"));
                	}
                }
                response.sendRedirect(request.getContextPath() + "/richieste-materiale");
            } catch (SQLException e) {
            	response.sendError(500, "Errore aggiornamento stato");
            }
            return;
        }
        
        
        
        String urgenza = request.getParameter("urgenza");
        String motivo = request.getParameter("motivo");
        String note = request.getParameter("note");
        int richiedenteId = (int) request.getSession().getAttribute("userId");
        
        String[] articoloIds = request.getParameterValues("articoloId");
        String[] quantitaArr = request.getParameterValues("quantita");

        
        List<RichiestaRiga> righe = new ArrayList<>();
        for (int i = 0; i < articoloIds.length; i++) {
            String idStr = articoloIds[i];
            String qStr  = quantitaArr[i];

            if (idStr == null || idStr.isBlank()) continue; // (se prevedi “non catalogati”, gestiscili a parte)
            int articoloId;
            int qta = 1;

            try { articoloId = Integer.parseInt(idStr); } catch (Exception e) { continue; }
            try { qta = Math.max(1, Integer.parseInt(qStr)); } catch (Exception ignore) {}
            
            RichiestaRiga rr = new RichiestaRiga();
            rr.setArticoloId(articoloId);
            rr.setQuantita(qta);
            righe.add(rr);
        }
        if (righe.isEmpty()) {
        	response.sendError(400, "La richiesta non contiene articoli validi.");
            return;
        }

        Richiesta r = new Richiesta();
        r.setRichiedenteId(richiedenteId);
        r.setStato("in_attesa");                 // stato iniziale
        r.setUrgenza(urgenza);                 // "alta|media|bassa"
        r.setMotivo(motivo);                     // "Reintegro|Fornitura" (coerente col tuo ENUM)
        r.setCommento(null);                     // se hai un campo commento separato
        r.setNote(note);
        r.setRighe(righe);
        r.setDataRichiesta(java.time.LocalDateTime.now());
        try {
			rd.addRichiesta(r);
			List<Integer> ids = UserService.getIdMagazzinieriEAdmin(DBConnection.getConnection());
			for(int id : ids)
				NotificationService.createNotification(id, "Nuova richiesta materiale da "+session.getAttribute("username"));
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        request.getRequestDispatcher("/richieste.jsp").forward(request, response);
   
	}

}
