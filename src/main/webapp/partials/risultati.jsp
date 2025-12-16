<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Articolo" %>
<%@ page import="model.ListaArticoli" %>
<style>@media print {
  .no-print {
    display: none !important;
  }
}</style>
<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
<script src="scripts/risultati.js"></script>

<%
    List<Articolo> articoli = (List<Articolo>) request.getAttribute("articoli");
    if (articoli != null && !articoli.isEmpty()) {
%>
        <%
            for (int i = 0; i < articoli.size(); i++) {
                Articolo a = articoli.get(i);
        %>
            <div data-id="<%= a.getId() %>" class="article-card bg-white rounded-lg shadow-sm overflow-hidden transition-all duration-300 w-full max-w-xs mx-auto flex flex-col justify-between h-full" onclick="apriDettagli(event)" 
                    	
                    	     data-nome="<%= a.getNome() %>"
                    	     data-matricola="<%= a.getMatricola() %>"
                    	     data-marca="<%= a.getMarca() %>"
                    	     data-compatibilita="<%= a.getCompatibilita() %>"
                    	     data-ddt="<%= a.getDdt() %>"
                    	     data-ddt-spedizione="<%= a.getDdtSpedizione() %>"
                    	     data-tecnico="<%= a.getTecnico() %>"
                    	     data-pv="<%= a.getPv() %>"
                    	     data-provenienza="<%= a.getProvenienza() %>"
                    	     data-fornitore="<%= a.getFornitore() %>"
                    	     data-dataric="<%= a.getDataRic_DDT() %>"
                    	     data-dataspe="<%= a.getDataSpe_DDT() %>"
                    	     data-datagar="<%= a.getDataGaranzia() %>"
                    	     data-note="<%= a.getNote() %>"
                    	     data-stato="<%= a.getStato() %>"
                    	     data-immagine="<%= a.getImmagine() %>"
                    	     data-richiesta-garanzia="<%= a.getRichiestaGaranzia() %>"
                    >
                        <div class="relative " >
                              <img loading="lazy" src="<%= (a.getImmagine() != null && !a.getImmagine().isEmpty()) && !a.getImmagine().equals("null") ? a.getImmagine() : "img/Icon.png" %> " alt="Articolo" class="w-full aspect-[4/3] object-cover" >
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
                                 <button title="Storico modifiche" aria-label="Storico modifiche" onclick="caricaStoricoArticolo(<%=a.getId() %>)" class="fas fa-history px-4 py-2 text-sm font-medium text-red-600 hover:text-red-800"></button>
                                 <button title="Etichetta QR" aria-label="Etichetta QR" class="openQrModal fas fa-qrcode px-4 py-2 text-sm font-medium text-red-600 hover:text-red-800"></button>
                            </div>
                            <div class="mt-3 space-y-2">
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Provenienza:</span>
                                    <span class="text-sm font-medium"><%= a.getProvenienza() %></span>
                                </div>
                                <!--  <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">DDT:</span>
                                    <span class="text-sm font-medium"><%= a.getDdt() %></span>
                                </div>-->
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Centro Per Revisione:</span>
                                    <span class="text-sm font-medium"><%= a.getFornitore() %></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Tecnico:</span>
                                    <span class="text-sm font-medium"><%= a.getTecnico() %></span>
                                </div>
                            </div>
                            <div class="mt-4 flex space-x-2">
                                <button class="edit-btn flex-1 bg-blue-100 text-blue-700 hover:bg-blue-200 px-3 py-1 rounded-lg text-sm flex items-center justify-center" data-id="${articolo.id}">
                                    <i class="fas fa-edit mr-1"></i> Modifica
                                </button>
                                <%
                                	if(session.getAttribute("ruolo").equals("Tecnico")){
                                %>
                               <button id="assegnaInput" type="submit"name="assegnaAction"
								        value="assegna"
								        form="article-form"   
								        class="assegnaButton flex-1 bg-gray-100 text-black hover:bg-gray-200 px-3 py-1 rounded-lg text-sm flex items-center justify-center"
								        data-id="${articolo.id}">
								  <i class="fas fa-dolly"></i> Assegna a me
								</button>
								<%
                                	}
								%>
                                <button class="delete-btn flex-1 bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1 rounded-lg text-sm flex items-center justify-center" data-id="${articolo.id}">
                                    <i class="fas fa-trash-alt mr-1"></i> Elimina
                                </button>
                                
                            </div>
                        </div>
                    </div>
                    <script>
                    // Imposta i valori dai request attribute
                    var Ctotale = document.getElementById("count-total");
                    var CinAttesa = document.getElementById("count-In_attesa");
                    var CinMagazzino = document.getElementById("count-In_magazzino");
                    var Cinstallato = document.getElementById("count-Installato");
                    var Cdestinato = document.getElementById("count-Destinato");
                    var Cassegnato = document.getElementById("count-Assegnato");
                    var Cguasto = document.getElementById("count-Guasto");
                    var Criparato = document.getElementById("count-Riparato");
                    var CnonRiparato = document.getElementById("count-Non_Riparato");
                    var CnonRiparabile = document.getElementById("count-Non_Riparabile");

                    // Assegnazione e visualizzazione condizionale
                    Ctotale.textContent = <%=request.getAttribute("TotaleArticoli")%>;
                    Ctotale.parentElement.style.display = (Ctotale.textContent == 0) ? "none" : "flex";

                    CinAttesa.textContent = <%=request.getAttribute("countInattesa")%>;
                    CinAttesa.parentElement.style.display = (CinAttesa.textContent == 0) ? "none" : "flex";

                    CinMagazzino.textContent = <%=request.getAttribute("countInmagazzino")%>;
                    CinMagazzino.parentElement.style.display = (CinMagazzino.textContent == 0) ? "none" : "flex";

                    Cinstallato.textContent = <%=request.getAttribute("countInstallato")%>;
                    Cinstallato.parentElement.style.display = (Cinstallato.textContent == 0) ? "none" : "flex";

                    Cdestinato.textContent = <%=request.getAttribute("countDestinato")%>;
                    Cdestinato.parentElement.style.display = (Cdestinato.textContent == 0) ? "none" : "flex";

                    Cassegnato.textContent = <%=request.getAttribute("countAssegnato")%>;
                    Cassegnato.parentElement.style.display = (Cassegnato.textContent == 0) ? "none" : "flex";

                    Cguasto.textContent = <%=request.getAttribute("countGuasto")%>;
                    Cguasto.parentElement.style.display = (Cguasto.textContent == 0) ? "none" : "flex";

                    Criparato.textContent = <%=request.getAttribute("countRiparato")%>;
                    Criparato.parentElement.style.display = (Criparato.textContent == 0) ? "none" : "flex";

                    CnonRiparato.textContent = <%=request.getAttribute("countNonRiparato")%>;
                    CnonRiparato.parentElement.style.display = (CnonRiparato.textContent == 0) ? "none" : "flex";

                    CnonRiparabile.textContent = <%=request.getAttribute("countNonRiparabile")%>;
                    CnonRiparabile.parentElement.style.display = (CnonRiparabile.textContent == 0) ? "none" : "flex";
                  </script>
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
<!-- Modale QRCODE-->
	<div id="qrModal" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
	  <div class="bg-white rounded-lg p-6 relative w-80">
	    <button id="closeQrModal" class="no-print absolute top-2 right-3 text-gray-500 hover:text-black text-xl">&times;</button>
	    <h2 class="no-print text-lg font-semibold mb-4">QR Code</h2>
	    <div style="position: relative; width: 200px; height: 200px; margin: auto;">
	      <div id="qrcode" style="position: absolute; top: 0; left: 0;"></div>
	      <img id="qrLogo" src="img/IconBN.png" style="position: absolute; top: 75px; left: 75px; width: 50px; height: 50px;" />
	      
	    </div>
	    <span id="nomeQr" class="block text-center mt-4 font-medium text-gray-700"></span>
	    <span id="matricolaQr" class="block text-center mt-4 font-medium text-gray-700"></span>
	    <div class="flex justify-center gap-4 mt-4">
		  <button onclick="scaricaQR()" class="no-print px-4 py-2 text-sm font-medium text-red-600 hover:text-red-800"><i class="fas fa-download"></i> Scarica PNG</button>
		  <button onclick="stampaQR()" class="no-print px-4 py-2 text-sm font-medium text-red-600 hover:text-red-800"><i class="fas fa-print"></i> Stampa</button>
		</div>
	    
	  </div>
	</div>
	<!-- MODALE STORICO ARTICOLO -->
	    <!-- Modale storico movimenti -->
<div id="historyModal" class="fixed inset-0 z-50 hidden overflow-y-auto">
    <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
        <!-- Sfondo -->
        <div class="fixed inset-0 transition-opacity" aria-hidden="true">
            <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
        </div>

        <!-- Contenuto del modale -->
        <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full">
            <!-- Header -->
            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:items-center sm:justify-between border-b border-gray-200">
                <h3 class="text-lg leading-6 font-medium text-gray-900">
                    <i class="fas fa-history mr-2 text-red-600"></i> Storico Modifiche Articolo
                </h3>
                <button onclick="closeModalStorico()" class="text-gray-400 hover:text-gray-500 focus:outline-none">
                    <i class="fas fa-times text-xl"></i>
                </button>
            </div>

            <!-- Corpo dinamico -->
            <div id="modalContentAreaStorico" class="px-4 pt-5 pb-4 sm:p-6">
                <div class="text-sm text-gray-500">Caricamento in corso...</div>
            </div>

            <!-- Footer -->
            <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse border-t border-gray-200">
                <button type="button" onclick="closeModalStorico()" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none sm:ml-3 sm:w-auto sm:text-sm">
                    Chiudi
                </button>
            </div>
        </div>
    </div>
</div>

<!-- ARTICOLO DETTAGLI MODALE -->
    <div id="articleModal" class="modal fixed inset-0 z-50 flex items-center justify-center hidden">
        <div class="modal-overlay absolute inset-0 bg-black opacity-50"></div>
        
        <div class="modal-container bg-white w-11/12 md:max-w-2xl mx-auto rounded shadow-lg z-50  max-h-[90vh] flex flex-col">
            <!-- Header -->
            <div class="modal-header flex justify-between items-center p-4 border-b">
                <h3 class="text-xl font-bold">Dettagli Articolo</h3>
                <button onclick="closeModal()" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            
            <!-- Body -->
            <div id="bodyDettagli" class="modal-body p-6 overflow-y-auto flex-1" >
                <div class="flex flex-col gap-6">
                    <!-- Immagine -->
                    <div class="w-full ">
                    <div class="relative">
                            <span id="statoDettagli" class="status-badge absolute top-2 right-2"></span>
                            </div>
                        <img id="immagineDettagli" src="img/Icon.png" alt="Articolo" class="w-full max-w-full max-h-full object-contain rounded-lg shadow">
                    </div>
                    
                    <!-- Dettagli -->
                    <div class="w-full">
                    
                        <h2 id="nomeDettagli" class="text-2xl font-bold mb-2"></h2>
                   
                        <p id="matricolaDettagli"class="text-gray-600 mb-4"></p>
                        
                        <div class="space-y-3">
                       
                            <div>
                           		<i class="fas fa-industry"></i>
                                <span class="font-medium text-gray-700">Marca:</span>
                                <span id="marcaDettagli" class="ml-2 text-blue-600 font-bold">NON VALIDO</span>
                            </div>
                            
                            <div>
                            	<i class="fas fa-puzzle-piece"></i>
                                <span class="font-medium text-gray-700">Compatibilita:</span>
                                <span id="compatibilitaDettagli" class="ml-2 text-green-600">NON VALIDO</span>
                            </div>
                            
                            
                            <hr class="my-4 border-gray-300" />
                            <div>
                            	<i class="fas fa-user-cog"></i>
                                <span class="font-medium text-gray-700">Tecnico:</span>
                                <span id="tecnicoDettagli" class="ml-2">NON VALIDO</span>
                            </div>
                            
                            <div>
                            	<i class="fas fa-location-arrow"></i>
                                <span class="font-medium text-gray-700">Provenienza:</span>
                                <span id="provenienzaDettagli" class="ml-2">NON VALIDO</span>
                            </div>
                            <div>
                            	<i class="fas fa-map-marker-alt"></i>
                                <span class="font-medium text-gray-700">P.V. Di Destinazione:</span>
                                <span id="pvDettagli" class="ml-2">NON VALIDO</span>
                            </div>

                            <div>
                            	<i class="fas fa-screwdriver-wrench"></i>
                                <span class="font-medium text-gray-700">Centro Per Revisione:</span>
                                <span id="fornitoreDettagli" class="ml-2">NON VALIDO</span>
                            </div>
                            <hr class="my-4 border-gray-300" />
                            <div>
                            	<i class="fas fa-undo-alt"></i>
                                <span class="font-medium text-gray-700">DDT Ricezione:</span>
                                <span id="ddtDettagli" class="ml-2">NON VALIDO</span>
                            </div>
                            <div>
                            	<i class="fas fa-calendar-check"></i>
                                <span class="font-medium text-gray-700">Data Ricezione:</span>
                                <span id="dataricDettagli" class="ml-2">NON VALIDO</span>
                            </div>
                            
                            <div>
                            	<i class="fas fa-truck-loading"></i>
                                <span class="font-medium text-gray-700">DDT Spedizione:</span>
                                <span id="ddtSpedizioneDettagli" class="ml-2">NON VALIDO</span>
                            </div>
                            
                            <div>
                            	<i class="fas fa-shipping-fast"></i>
                                <span class="font-medium text-gray-700">Data Spedizione:</span>
                                <span id="dataspeDettagli" class="ml-2">NON VALIDO</span>
                            </div>
                            <hr class="my-4 border-gray-300" />
                            
                            	<div>
	                            	<i class="fas fa-shield-alt"></i>
	                                <span class="font-medium text-gray-700">Data Garanzia:</span>
	                                <span id="datagarDettagli" class="ml-2">NON VALIDO</span>
                            	</div>
                             	<div>
	                            	<i class="fas fa-bullhorn"></i>
	                                <span class="font-medium text-gray-700">Richiesta Garanzia:</span>
	                                <span id="richiestagarDettagli" class="ml-2">NON VALIDO</span>
                            	</div>
                            <hr class="my-4 border-gray-300" />
                            	<div>
	                            	<i class="fas fa-sticky-note"></i>
	                                <span class="font-medium text-gray-700">Note:</span>
	                                <span id="noteDettagli" class="ml-2">NON VALIDO</span>
	                            </div>
							
                            
                          
                            
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Footer -->
            
        </div>
    </div>
        <div id="delete-modal" class="modal fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-md fade-in">
            <div class="p-6">
                <div class="flex items-center justify-center mb-4">
                    <div class="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center">
                        <i class="fas fa-exclamation-triangle text-red-600 text-xl"></i>
                    </div>
                </div>
                <h3 class="text-lg font-semibold text-center mb-2">Conferma eliminazione</h3>
                <p class="text-gray-600 text-center mb-6">Sei sicuro di voler eliminare questo articolo? Questa azione non può essere annullata.</p>
                <div class="flex justify-center space-x-4">
                    <button id="cancel-delete" class="px-4 py-2 border rounded-lg hover:bg-gray-100">
                        Annulla
                    </button>
                    <button id="confirm-delete" class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg" name="delete">
                        Elimina
                    </button>
                </div>
            </div>
        </div>
    </div>
    <div id="etichetta-stampa" style="display:none;"></div>
    <%
    Integer pagina   = (Integer) request.getAttribute("page");
    Integer size   = (Integer) request.getAttribute("size");
    Integer total  = (Integer) request.getAttribute("total");
    if (pagina == null)  pagina = 1;
    if (size == null)  size = 24;
    if (total == null) total = 0;

    int maxPage = (int) Math.ceil(total / (double) size);
    // ricostruisco i filtri correnti per non perderli tra le pagine
    String qSearch = request.getParameter("search") != null ? request.getParameter("search") : "";
    String qStato  = request.getParameter("stato")  != null ? request.getParameter("stato")  : "";
    String qMarca  = request.getParameter("marca")  != null ? request.getParameter("marca")  : "";
    String qData   = request.getParameter("data")   != null ? request.getParameter("data")   : "";
    String qNome   = request.getParameter("nome")   != null ? request.getParameter("nome")   : "";
    String qInst   = request.getParameter("installatiCheck") != null ? request.getParameter("installatiCheck") : "nascondi";

    String baseQuery = "search=" + java.net.URLEncoder.encode(qSearch, "UTF-8")
            + "&stato=" + java.net.URLEncoder.encode(qStato, "UTF-8")
            + "&marca=" + java.net.URLEncoder.encode(qMarca, "UTF-8")
            + "&data="  + java.net.URLEncoder.encode(qData,  "UTF-8")
            + "&nome="  + java.net.URLEncoder.encode(qNome,  "UTF-8")
            + "&installatiCheck=" + java.net.URLEncoder.encode(qInst, "UTF-8")
            + "&size=" + size;
%>

<!-- Paginazione sticky, estetica migliorata -->
<!-- Spacer per evitare overlap su desktop (mostrato solo da md in su) -->
<div aria-hidden="true" class="hidden md:block h-16"></div>

<nav role="navigation" aria-label="Paginazione risultati"
     class="no-print sticky bottom-0 z-50 px-3
            md:fixed md:inset-x-0"
     style="bottom: max(1rem, env(safe-area-inset-bottom));">
  <div class="mx-auto w-full flex justify-center">
    <div class="inline-flex items-center gap-1 sm:gap-2 rounded-full border border-gray-200
                bg-white/85 backdrop-blur-sm shadow-lg supports-[backdrop-filter]:bg-white/60
                px-2 py-1.5 sm:px-3 sm:py-2">

      <!-- PRECEDENTE -->
      <a class="group inline-flex items-center gap-1 sm:gap-2 rounded-full text-xs sm:text-sm font-medium
                 px-3 py-2 sm:px-3 sm:py-2 transition hover:bg-gray-100
                 <%= (pagina <= 1 ? "opacity-50 pointer-events-none" : "") %>"
         href="<%=request.getContextPath() %>/filtro?<%= baseQuery %>&page=<%= (pagina - 1) %>"
         data-ajax="risultati"
         aria-label="Pagina precedente"
         aria-disabled="<%= (pagina <= 1) %>">
        <i class="fas fa-chevron-left"></i>
        <span class="hidden sm:inline">Precedente</span>
      </a>

      <!-- INDICATORE PAGINA -->
      <span class="select-none text-xs sm:text-sm text-gray-700 whitespace-nowrap px-2 sm:px-3" role="status">
        Pag. <span class="font-semibold"><%= pagina %></span>
        <span class="mx-1 text-gray-400">/</span>
        <span class="font-medium"><%= Math.max(1, maxPage) %></span>
      </span>

      <!-- SUCCESSIVA -->
      <a class="group inline-flex items-center gap-1 sm:gap-2 rounded-full text-xs sm:text-sm font-medium
                 px-3 py-2 sm:px-3 sm:py-2 transition hover:bg-gray-100
                 <%= (pagina >= maxPage ? "opacity-50 pointer-events-none" : "") %>"
         href="<%=request.getContextPath() %>/filtro?<%= baseQuery %>&page=<%= (pagina + 1) %>"
         data-ajax="risultati"
         aria-label="Pagina successiva"
         aria-disabled="<%= (pagina >= maxPage) %>">
        <span class="hidden sm:inline">Successiva</span>
        <i class="fas fa-chevron-right"></i>
      </a>

    </div>
  </div>
</nav>
<script>
function caricaStoricoArticolo(id) {
	  fetch('<%=request.getContextPath()%>'+'/storico-articolo?id=' + id)
	    .then(response => response.text())
	    .then(html => {
	      document.getElementById('modalContentAreaStorico').innerHTML = html;
	      document.getElementById('historyModal').classList.remove('hidden');
	    })
	    .catch(error => console.error('Errore nel caricamento:', error));
	}
	
	function closeModalStorico() {
	  document.getElementById('historyModal').classList.add('hidden');
	  document.getElementById('modalContentAreaStorico').innerHTML = ''; 
	}

</script>





    
    




   
