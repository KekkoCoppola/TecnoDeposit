<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ page import="java.util.List" %>
            <%@ page import="model.Articolo" %>
                <%@ page import="java.time.format.DateTimeFormatter" %>

                    <!DOCTYPE html>
                    <html>

                    <body>

                        <% List<Articolo> articoli = (List<Articolo>) request.getAttribute("articoliFornitore");
                                //System.out.println("CIAO SONO RISULTATI, HO RICEVUTO "+articoli.size()+" ARTICOLI");
                                if (articoli != null && !articoli.isEmpty()) {

                                // Conta articoli in attesa
                                int countInAttesa = 0;
                                for (Articolo art : articoli) {
                                if ("In attesa".equalsIgnoreCase(art.getStato().toString())) {
                                countInAttesa++;
                                }
                                }
                                %>
                                <% StringBuilder body=new StringBuilder(); body.append("Salve,%0D%0A%0D%0A La seguente lista contiene tutti gli articoli attualmente in attesa di revisione di cui non è stato ricevuto riscontro:%0D%0A%0D%0A");
                                for (Articolo a : articoli) { 
                                	if("In attesa".equalsIgnoreCase(a.getStato().toString())) { 
                                		String dataSpedizione=a.getDataSpe_DDT() !=null ? a.getDataSpe_DDT().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")): "N/D" ;
                                		body.append("- ").append(a.getNome()+" marca "+a.getMarca()+" spedito il "+dataSpedizione+" con DDT numero "+a.getDdt()).append(" %0D%0A");
                                		} 
                                	}
                                    body.append("%0D%0AResto in attesa di un vostro riscontro.%0D%0ACordiali saluti,%0D%0ATecnoAGM");
                                    body.append("%0D%0A%0D%0A%0D%0AQuesta mail è stata generata dal software di magazzinaggio TecnoDeposit™.");
                                    String mailBody=body.toString();
                                    //Mostra pulsante SOLO se ci sono articoli in attesa E non è un Tecnico
                                    if(countInAttesa> 0 && !session.getAttribute("ruolo").equals("Tecnico")){ %>

                                    <!-- Pulsante Notifica Tutti - Sticky in basso -->
                                    <div class="sticky bottom-4 z-40 flex justify-center mb-4">
                                        <a href="mailto:<%=request.getAttribute(" mailFornitore")
                                            %>?subject=Lista%20Articoli%20In%20Attesa%20di%20Revisione&body=<%= mailBody
                                                %>" class="inline-flex items-center gap-2 px-5 py-3 bg-gradient-to-r
                                                from-yellow-400 to-orange-500 text-white font-semibold
                                                rounded-full shadow-lg hover:shadow-xl hover:from-yellow-500
                                                hover:to-orange-600 transition-all">
                                                <i class="fas fa-envelope"></i>
                                                <span>Notifica <b>
                                                        <%= countInAttesa %>
                                                    </b> Articol<%= countInAttesa==1 ? "o" : "i" %> In Attesa</span>
                                        </a>
                                    </div>
                                    <%} %>
                                        <div
                                            class="p-4 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                                            <% for (int i=0; i < articoli.size(); i++) { Articolo a=articoli.get(i); %>
                                                <div
                                                    class="article-card bg-white rounded-2xl shadow-md hover:shadow-2xl overflow-hidden transition-all duration-300 w-full max-w-sm flex flex-col justify-between h-full hover:-translate-y-1 border border-gray-100">
                                                    <div class="relative group">
                                                        <img loading="lazy"
                                                            src="<%= (a.getImmagine() != null && !a.getImmagine().isEmpty()) && !a.getImmagine().equals("null") ? a.getImmagine() : "img/Icon.png" %>" alt="Articolo"
                                                        class="w-full aspect-[4/3] object-cover transition-transform
                                                        duration-300 group-hover:scale-105">
                                                        <div
                                                            class="absolute inset-0 bg-gradient-to-t from-black/40 via-transparent to-transparent">
                                                        </div>
                                                        <% String stato=a.getStato().toString(); String
                                                            statoCss="status-" + stato.toLowerCase().replace(" ", "-").replace("à", "a" ); %>
                                                            <span
                                                                class="status-badge <%= statoCss %> absolute top-3 right-3 backdrop-blur-md bg-white/80 px-3 py-1 rounded-full text-xs font-semibold shadow-lg border border-white/50">
                                                                <%= a.getStato() %>
                                                            </span>
                                                    </div>
                                                    <div class="p-4 bg-gradient-to-b from-gray-50/50 to-white">
                                                        <div class="flex justify-between items-start mb-3">
                                                            <div class="flex-1 min-w-0">
                                                                <h3 class="font-bold text-lg text-gray-800 truncate">
                                                                    <%= a.getNome() %>
                                                                </h3>
                                                                <p
                                                                    class="text-xs text-gray-500 font-mono bg-gray-100 inline-block px-2 py-0.5 rounded mt-1">
                                                                    <%= a.getMatricola() %>
                                                                </p>
                                                            </div>
                                                        </div>
                                                        <div class="space-y-2 text-sm">
                                                            <div
                                                                class="flex justify-between items-center py-1 border-b border-gray-100">
                                                                <span class="text-gray-500 flex items-center gap-2"><i
                                                                        class="fas fa-location-arrow text-xs text-gray-400"></i>Provenienza</span>
                                                                <span
                                                                    class="font-medium text-gray-700 truncate max-w-[120px]">
                                                                    <%= a.getProvenienza() %>
                                                                </span>
                                                            </div>
                                                            <div
                                                                class="flex justify-between items-center py-1 border-b border-gray-100">
                                                                <span class="text-gray-500 flex items-center gap-2"><i
                                                                        class="fas fa-truck text-xs text-gray-400"></i>DDT
                                                                    Spedizione</span>
                                                                <% if(a.getDataSpe_DDT()!=null){ %>
                                                                    <span class="font-medium text-gray-700">
                                                                        <%= a.getDdtSpedizione() %> &bull; <%=
                                                                                a.getDataSpe_DDT().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                                                                                %>
                                                                    </span>
                                                                    <% }else{ %>
                                                                        <span class="font-medium text-gray-700">
                                                                            <%= a.getDdtSpedizione() %> &bull;N/D
                                                                        </span>
                                                                        <% } %>
                                                            </div>
                                                            <div
                                                                class="flex justify-between items-center py-1 border-b border-gray-100">
                                                                <span class="text-gray-500 flex items-center gap-2"><i
                                                                        class="fas fa-undo-alt text-xs text-gray-400"></i>DDT
                                                                    Ricezione</span>
                                                                <% if(a.getDataRic_DDT()!=null){ %>
                                                                    <span class="font-medium text-gray-700">
                                                                        <%= a.getDdt() %> &bull; <%=
                                                                                a.getDataRic_DDT().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                                                                                %>
                                                                    </span>
                                                                    <% }else{ %>
                                                                        <span class="font-medium text-gray-700">
                                                                            <%= a.getDdt() %> &bull;N/D
                                                                        </span>
                                                                        <% } %>
                                                            </div>
                                                            <div class="flex justify-between items-center py-1">
                                                                <span class="text-gray-500 flex items-center gap-2"><i
                                                                        class="fas fa-shield-alt text-xs text-gray-400"></i>Richiesta
                                                                    Garanzia</span>
                                                                <span
                                                                    class="font-medium <%= a.getRichiestaGaranzia() ? "text-green-600" : "text-red-600" %>">
                                                                    <%= a.getRichiestaGaranzia() ? "SI" : "NO" %>
                                                                </span>
                                                            </div>
                                                        </div>
                                                        <div class="mt-4 flex gap-2">
                                                            <button title="Visualizza Nella Dashboard"
                                                                aria-label="Visualizza Nella Dashboard"
                                                                onclick="window.location.href='dashboard?search=<%=a.getMatricola()%>'"
                                                                class="flex-1 bg-gradient-to-r from-blue-500 to-blue-600 text-white hover:from-blue-600 hover:to-blue-700 px-3 py-2 rounded-xl text-sm font-medium flex items-center justify-center shadow-sm hover:shadow-md transition-all">
                                                                <i class="fas fa-eye mr-1.5"></i> Visualizza
                                                            </button>
                                                            <%if(a.getStato().toString().equals("In attesa")&&
                                                                !session.getAttribute("ruolo").equals("Tecnico")) {
                                                                String dataSpeSingola=a.getDataSpe_DDT() !=null ?
                                                                a.getDataSpe_DDT().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"))
                                                                : "N/D" ; %>
                                                                <a title="Notifica Centro Revisione"
                                                                    aria-label="Notifica Centro Revisione"
                                                                    class="flex-1 bg-gradient-to-r from-yellow-400 to-yellow-500 text-white hover:from-yellow-500 hover:to-yellow-600 px-3 py-2 rounded-xl text-sm font-medium flex items-center justify-center shadow-sm hover:shadow-md transition-all"
                                                                    href="mailto:<%=request.getAttribute("mailFornitore")%>?subject=Notifica%20Materiale%20In%20Revisione&body=Salve,%0D%0A%0D%0AChiedo
                                                                    ulteriori informazioni sul materiale inviato in
                                                                    revisione:%0D%0A%0D%0A- <%=a.getNome()%> marca
                                                                        <%=a.getMarca()%> inviato il giorno
                                                                            <%=dataSpeSingola%> con DDT numero
                                                                                <%=a.getDdt()%>%0D%0A%0D%0ANon è stato
                                                                                    ancora ricevuto nessun aggiornamento
                                                                                    su tale
                                                                                    materiale.%0D%0A%0D%0AAttendo un
                                                                                    vostro riscontro%0D%0ACordiali
                                                                                    saluti,%0D%0ATecnoAGM%0D%0A%0D%0A%0D%0AQuesta
                                                                                    mail è stata generata dal software
                                                                                    di magazzinaggio TecnoDeposit™.">
                                                                                    <i
                                                                                        class="fas fa-envelope mr-1.5"></i>
                                                                                    Notifica
                                                                </a>
                                                                <%} %>
                                                        </div>
                                                    </div>
                                                </div>
                                                <% } %>

                                                    <% } else { %>
                                                        <p>Nessun articolo trovato.</p>
                                                        <% } %>
                                        </div>


                    </body>

                    </html>