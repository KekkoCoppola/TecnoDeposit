<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Articolo" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<!DOCTYPE html>
<html>
<body>

<%
    List<Articolo> articoli = (List<Articolo>) request.getAttribute("articoliFornitore");
//System.out.println("CIAO SONO RISULTATI, HO RICEVUTO "+articoli.size()+" ARTICOLI");
    if (articoli != null && !articoli.isEmpty()) {
%>
	<%
    StringBuilder body = new StringBuilder();
    body.append("Salve,%0D%0A%0D%0ALa seguente lista contiene tutti gli articoli attualmente in attesa di revisione di cui non è stato ricevuto riscontro:%0D%0A%0D%0A");

    for (Articolo a : articoli) {
        if ("In attesa".equalsIgnoreCase(a.getStato().toString())) {
            body.append("- ").append(a.getNome()+" marca "+a.getMarca()+" spedito il "+a.getDataSpe_DDT().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"))+" con DDT numero "+a.getDdt()).append("%0D%0A");
        }
    }

    body.append("%0D%0AResto in attesa di un vostro riscontro.%0D%0ACordiali saluti,%0D%0ATecnoAGM");
    body.append("%0D%0A%0D%0A%0D%0AQuesta mail è stata generata dal software di magazzinaggio TecnoDeposit™.");
    String mailBody = body.toString();
    
    if(!session.getAttribute("ruolo").equals("Tecnico")){
	%>

	<div class="mb-6 flex justify-start">
			<a href="mailto:<%=request.getAttribute("mailFornitore") %>?subject=Lista%20Articoli%20In%20Attesa%20di%20Revisione&body=<%= mailBody %>" class="ml-4 mt-4 mb-4 px-4 py-2 bg-yellow-100 text-yellow-700 rounded hover:bg-yellow-200">
			  <i class="fas fa-envelope mr-2"></i> Notifica <b>Tutti</b> Gli Articoli In Attesa Di Revisione
			</a>
	</div>
	<%} %>
<div class="p-4 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <%
    
            for (int i = 0; i < articoli.size(); i++) {
                Articolo a = articoli.get(i);
        %>
        <div class="article-card bg-white rounded-lg shadow-sm overflow-hidden transition-all duration-300 w-full max-w-xs mx-auto flex flex-col justify-between h-full" >
                        <div class="relative " >
                              <img src="<%= (a.getImmagine() != null && !a.getImmagine().isEmpty()) && !a.getImmagine().equals("null") ? a.getImmagine() : "img/Icon.png" %> " alt="Articolo" class="w-full aspect-[4/3] object-cover" >
                            <%
							    String stato = a.getStato().toString(); // E.g., "In attesa"
							    String statoCss = "status-" + stato.toLowerCase().replace(" ", "-").replace("à", "a");
							%>
                            <span class="status-badge <%= statoCss %> absolute top-2 right-2"><%= a.getStato() %></span>
                        </div>
                        <div class="p-4">
                            <div class="flex justify-between items-start">
                                <div>
                                    <h3 class="font-semibold text-lg"><%= a.getNome() %></h3>
                                    <p class="text-sm text-gray-500">Matricola: <%= a.getMatricola() %></p>
                                </div>
                                
                            </div>
                            <div class="mt-3 space-y-2">
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Provenienza:</span>
                                    <span class="text-sm font-medium"><%= a.getProvenienza() %></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">DDT Spedizione:</span>
                                    <%
                                    	if(a.getDataSpe_DDT()!=null){
                                    %>
                                    <span class="text-sm font-medium"><%= a.getDdtSpedizione() %> &bull; <%= a.getDataSpe_DDT().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></span>
                                    <%
                                    	}else{
                                    %>
                                    <span class="text-sm font-medium"><%= a.getDdtSpedizione() %> &bull;N/D</span>
                                    <%
                                    	}
                                    %>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">DDT Ricezione:</span>
                                    <%
                                    	if(a.getDataRic_DDT()!=null){
                                    %>
                                    <span class="text-sm font-medium"><%= a.getDdt() %> &bull; <%= a.getDataRic_DDT().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %></span>
                                    <%
                                    	}else{
                                    %>
                                    <span class="text-sm font-medium"><%= a.getDdt() %> &bull;N/D</span>
                                    <%
                                    	}
                                    %>
                                </div>
                                <div class="flex justify-between">
								    <span class="text-sm text-gray-600">Richiesta Garanzia:</span>
								    <span class="text-sm font-medium <%= a.getRichiestaGaranzia() ? "text-green-600" : "text-red-600" %>">
								        <%= a.getRichiestaGaranzia() ? "SI" : "NO" %>
								    </span>
								</div>
                            </div>
                            <div class="mt-4 flex space-x-2">
                                <button title="Visualizza Nella Dashboard" aria-label="Visualizza Nella Dashboard" onclick="window.location.href='dashboard?search=<%=a.getMatricola()%>'" class="flex-1 bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1 rounded-lg text-sm flex items-center justify-center">
                                        <i class="fas fa-eye"></i> Visualizza
                                    </button>
                                    <%if(a.getStato().toString().equals("In attesa")&& !session.getAttribute("ruolo").equals("Tecnico")) {%>
									<a title="Notifica Centro Revisione" aria-label="Notifica Centro Revisione" class="flex-1 bg-yellow-100 text-yellow-700 hover:bg-yellow-200 px-3 py-1 rounded-lg text-sm flex items-center justify-center" href="mailto:<%=request.getAttribute("mailFornitore")%>?subject=Notifica%20Materiale%20In%20Revisione&body=Salve,%0D%0A%0D%0AChiedo ulteriori informazioni sul materiale inviato in revisione: %0D%0A%0D%0A- <%=a.getNome() %> marca <%=a.getMarca()%> inviato il giorno <%= a.getDataSpe_DDT().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) %> con DDT numero <%=a.getDdt() %>%0D%0A%0D%0ANon è stato ancora ricevuto nessun aggiornamento su tale materiale.%0D%0A%0D%0AAttendo un vostro riscontro%0D%0ACordiali saluti,%0D%0ATecnoAGM%0D%0A%0D%0A%0D%0AQuesta mail è stata generata dal software di magazzinaggio TecnoDeposit™.">
                                        <i class="fas fa-envelope"></i> Notifica
                                    </a>
								<%} %>
                            </div>
                        </div>
                    </div>
        <%
            }
        %>

<%
    } else {
%>
    <p>Nessun articolo trovato.</p>
<%
    }
%>
</div>


</body>
</html>
