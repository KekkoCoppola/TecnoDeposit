<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<%@ page import="java.util.List" %>
<%@ page import="model.Fornitore" %>
<%@ page import="model.ListaFornitori" %>

<%
    List<Fornitore> fornitori = (List<Fornitore>) request.getAttribute("fornitori");
	
//System.out.println("CIAO SONO RISULTATI, HO RICEVUTO "+articoli.size()+" ARTICOLI");
        if (fornitori != null && !fornitori.isEmpty()) {
			for (int i = 0; i < fornitori.size(); i++) {
				Fornitore f = fornitori.get(i);
		%>					
	<div 					data-id="<%= f.getId() %>"
							data-nome="<%= f.getNome() %>"
                    	    data-mail="<%= f.getMail() %>"
                    	    data-indirizzo="<%= f.getIndirizzo() %>"
                    	    data-piva="<%= f.getPiva() %>"
                    	    data-telefono="<%= f.getTelefono() %>"			
                    	    class="supplier-card bg-white rounded-xl shadow-sm p-6 transition-all duration-300 border border-gray-100 hover:border-red-200">
                <div class="flex justify-between items-start mb-4">
                    <div>
                        <h3 class="font-bold text-lg text-gray-800"><%=f.getNome() %></h3>
                        <!--  <p class="text-gray-500 text-sm">Categoria</p>-->
                    </div>
                    <!--<button class="favBtn text-gray-300 hover:text-yellow-400 text-xl" data-favorite="false">
                        <i class="far fa-star"></i>
                    </button>  -->
                </div>
                <div class="flex items-center gap-2 mb-3">
                    <i class="fas fa-map-marker-alt text-gray-400"></i>
                    <span class="text-gray-600"><%=f.getIndirizzo() %></span>
                </div>
                <div class="flex items-center gap-2 mb-3">
                    <i class="fas fa-phone text-gray-400"></i>
                    <span class="text-gray-600"><%=f.getTelefono() %></span>
                </div>
                <div class="flex items-center gap-2 mb-4">
                    <i class="fas fa-envelope text-gray-400"></i>
                    <span class="text-gray-600"><%=f.getMail() %></span>
                </div>
                <div class="flex items-center gap-2 mb-4">
                    <i class="fas fa-file-invoice text-gray-400"></i>
                    <span class="text-gray-600"><%=f.getPiva() %></span>
                </div>
                <div class="flex justify-between items-center">
                    <span class="bg-white text-white text-xs px-2 py-1 rounded"></span>
                    <div class="flex gap-2">
                    	<button  aria-label="Visualizza articoli del fornitore" title="Visualizza articoli del Fornitore" onclick="caricaCatalogoFornitore(<%=f.getId() %>)" class="catalog-suppliers text-gray-500 hover:text-gray-700">
                            <i class="fas fa-folder-open"></i>
                        </button>
                        <button  aria-label="Visualizza fornitore" title="Visualizza Fornitore" class="view-suppliers text-blue-500 hover:text-blue-700">
                            <i class="fas fa-eye"></i>
                        </button>
                        <button class="edit-suppliers text-blue-500 hover:text-blue-700">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="delete-suppliers text-red-500 hover:text-red-700">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            
		</div>  
		<%
	}
%>

<%
    } else {
%>
    <p>Nessun fornitore trovato.</p>
<%
    }
%> 
</html>