<%@ page import="model.Richiesta" %>
<%@ page import="model.RichiestaRiga" %>
<%@ page import="model.Articolo" %>
<%@ page import="model.UserService" %>
<%@ page import="model.ListaArticoli" %>
<%@ page import="dao.RichiestaDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .request-card {
            transition: all 0.3s ease;
        }
        .request-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        .status-pending {
            background-color: #FEF3C7;
            color: #92400E;
        }
        .status-approved {
            background-color: #D1FAE5;
            color: #065F46;
        }
        .status-rejected {
            background-color: #FEE2E2;
            color: #991B1B;
        }
        .tab-active {
            border-bottom: 3px solid #ef4444;
            color: #ef4444;
            font-weight: 600;
        }
    </style>
</head>
<body class="bg-gray-50 min-h-screen">
    <div class="container mx-auto px-4 py-8">
        <!-- Header -->
        <header class="mb-8">
            <div class="flex justify-between items-center">
                <h1 class="text-3xl font-bold text-gray-800">
                    <i class="fas fa-boxes mr-2 text-red-500"></i> Richieste Materiale
                </h1>
				<%
					RichiestaDAO rd = new RichiestaDAO(); 
					String ruolo = (String) session.getAttribute("ruolo");
				%>
            </div>
        </header>

        <!-- Main Content -->
        <div class="bg-white rounded-lg shadow-md overflow-hidden">
            <!-- Tabs -->
            <div class="flex border-b">
            	<%if(ruolo.equals("Tecnico")){ %>
                <button id="send-tab" class="tab-button px-6 py-4 text-gray-600 hover:text-red-500 focus:outline-none ">
                    <i class="fas fa-paper-plane mr-2"></i> Invia
                </button>
                <button id="sent-tab" class="tab-button px-6 py-4 text-gray-600 hover:text-red-500 focus:outline-none">
                    <i class="fas fa-paperclip mr-2"></i> Richieste Inviate
                </button>
                <%}if(!ruolo.equals("Tecnico")){ %>
                <button id="received-tab" class="tab-button px-6 py-4 text-gray-600 hover:text-red-500 focus:outline-none ">
                    <i class="fas fa-inbox mr-2"></i> Richieste Ricevute
                </button>
                <%} %>
            </div>
			
            <!-- Tab Content -->
            <div class="p-6">
                <!-- Send Request Form -->
                <div id="send-content" class="tab-content">
                    <%-- ====== SERVER: esporta la lista articoli in JS ====== --%>
					<%
						ListaArticoli listaA = new ListaArticoli();
					    List<Articolo> all = listaA.getArticoliPronti(); // o come recuperi tu
					%>
					<script>
					  const ARTICOLI = [
					    <% for (int i=0; i<all.size(); i++) {
					         Articolo a = all.get(i);
					         String nome = a.getNome() != null ? a.getNome().replace("\"","\\\"") : "";
					         
					    %>{ id:<%=a.getId()%>, nome:`<%=nome%>`,disponibili:`<%=listaA.countArticoliDisponibiliByNome(nome)%>`  }<%= (i<all.size()-1) ? "," : "" %>
					    <% } %>
					  ];
					</script>
					<form id="formRichieste" action="richieste-materiale" method="post" autocomplete="off">
					<!-- ====== FORM: campo Materiale con autocomplete + Quantità + Lista selezionati ====== -->
					<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
					
						<!-- Materiale -->
					  <div class="relative">
					    <label class="block text-sm font-medium text-gray-700 mb-1">Materiale</label>
					    <input id="materialInput" type="text" autocomplete="off"
					           class="w-full rounded-md border border-gray-300 focus:border-indigo-500 focus:ring-indigo-500"
					           placeholder="Cerca materiale per nome...">
					    <!-- dropdown suggerimenti -->
					    <div id="suggestBox"
					         class="absolute z-20 mt-1 w-full max-h-60 overflow-auto rounded-md border border-gray-200 bg-white shadow-lg hidden"></div>
					    <!-- messaggio esito -->
					    <p id="materialMsg" class="mt-1 text-xs text-gray-500"></p>
					  </div>
					
					  <!-- Quantità -->
					  <div>
					    <label class="block text-sm font-medium text-gray-700 mb-1">Quantità</label>
					    <input id="qtyInput" type="number" min="1" value="1"
					           class="w-full rounded-md border border-gray-300 focus:border-indigo-500 focus:ring-indigo-500"
					           placeholder="Inserisci Quantità">
					  </div>
					</div>
					
					<div class="mt-4 flex items-center gap-3">
					  <button type="button" id="addItemBtn"
					          class="inline-flex items-center gap-2 px-4 py-2 rounded-md border bg-indigo-600 text-white hover:bg-indigo-700">
					    <i class="fas fa-plus"></i> Aggiungi
					  </button>
					  <button type="button" id="clearItemBtn"
					          class="px-3 py-2 rounded-md bg-gray-100 text-gray-700 hover:bg-gray-200">
					    Svuota elenco
					  </button>
					</div>
					<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
					<div>
					    <label class="block text-sm font-medium text-gray-700 mb-1"><b>Motivo</b></label>
					    <select id="motivo" name="motivo" class="w-full rounded-md border border-gray-300 focus:border-indigo-500 focus:ring-indigo-500">
					           <option value="Reintegro">Reintegro</option>
					           <option value="Fornitura">Fornitura</option>
					    </select>
					  </div>
					  <div>
						  <span class="block text-sm font-medium text-gray-700 mb-1"><b>Urgenza</b></span>
						  <div class="flex items-center gap-6">
						    <label class="inline-flex items-center gap-2 cursor-pointer">
						      <input type="radio" name="urgenza" value="Alta"
						             class="text-indigo-600 focus:ring-indigo-500" checked>
						      <span>Alta</span>
						    </label>
						
						    <label class="inline-flex items-center gap-2 cursor-pointer">
						      <input type="radio" name="urgenza" value="Media"
						             class="text-indigo-600 focus:ring-indigo-500">
						      <span>Media</span>
						    </label>
						    <label class="inline-flex items-center gap-2 cursor-pointer">
						      <input type="radio" name="urgenza" value="Bassa"
						             class="text-indigo-600 focus:ring-indigo-500">
						      <span>Bassa</span>
						    </label>
						  </div>
						</div>
						
						</div>
						<br><br>
						<div>
					    <label class="block text-sm font-medium text-gray-700 mb-1"><b>Note</b></label>
					    <textarea id="note" name="note" class="w-full rounded-md border border-gray-300 focus:border-indigo-500 focus:ring-indigo-500"></textarea>

					  </div>
											
					<!-- Lista articoli aggiunti -->
					<div class="mt-4">
					  <h4 class="text-sm font-semibold text-gray-700 mb-2">Articoli richiesti</h4>
					  <ul id="selectedList" class="space-y-2"></ul>
					</div>
					
					<!-- qui finiscono gli hidden field articoloId[] e quantita[] -->
					<div id="hiddenFields"></div>
					<div class="text-right">
					<button type="submit" id="send"
					          class=" inline-flex items-center gap-2 px-4 py-2 rounded-md bg-red-600 text-white hover:bg-red-700">
					    <i class="fas fa-paper-plane"></i>Invia Richiesta
					  </button>
					  </form>
						
					  </div>
					<script>
					
					</script>

                </div>

                <!-- Sent Requests -->
                <div id="sent-content" class="tab-content hidden">      
                    <div class="space-y-4">
                        <!-- Request Card 1 -->
                        <% 
                        	
                        	List<Richiesta> listaInviate = rd.findByRichiedente((int) session.getAttribute("userId"));
                        	if(listaInviate!=null && !listaInviate.isEmpty()){
                        		for(Richiesta r : listaInviate){
                        
                        
					    // ---- mapping stile/icone URGENZA ----
					    String urg = (r.getUrgenza() != null ? r.getUrgenza() : "media").toLowerCase();
					    String urgCls, urgIcon;
					    switch (urg) {
					        case "alta":  urgCls = "bg-red-100 text-red-700 border-red-30";    urgIcon = "fa-fire"; break;
					        case "bassa": urgCls = "bg-green-100 text-green-700 border-green-30";  urgIcon = "fa-check-circle"; break;
					        default:      urgCls = "bg-orange-100 text-orange-700 border-orange-30"; urgIcon = "fa-exclamation-triangle";
					    }
					
					    // ---- mapping stile/icone STATO ----
					    String stato = (r.getStato() != null ? r.getStato() : "in_attesa");
					    String stCls, stIcon;
					    switch (stato) {
					        case "approvata": stCls = "bg-green-100 text-green-700 border-green-30"; stIcon = "fa-check"; break;
					        case "rifiutata": stCls = "bg-red-100 text-red-700 border-red-30";   stIcon = "fa-times"; break;
					        case "evasa":     stCls = "bg-gray-100 text-gray-700 border-gray-30";  stIcon = "fa-box"; break;
					        default:          stCls = "bg-yellow-100 text-yellow-700 border-yellow-30"; stIcon = "fa-hourglass-half";
					    }
					
					    // ---- motivo (badge secondario) ----
					    String motivo = (r.getMotivo() != null ? r.getMotivo() : "-");
					%>
					
					<div class="request-card bg-white p-4 rounded-lg border border-gray-200">
					
					  <!-- header con badge -->
					  <div class="flex flex-wrap items-center justify-between gap-2 mb-4 bg-gray-50 px-3 py-2 rounded-md">
					  <!-- URGENZA -->
					  <span class="inline-flex items-center gap-2 px-3 py-1 rounded-md text-sm font-semibold <%= urgCls %>">
					    <i class="fas <%= urgIcon %>"></i>
					    URGENZA <%= urg.toUpperCase() %>
					  </span>
					  <!-- STATO -->
					  <span class="inline-flex items-center gap-2 px-3 py-1 rounded-md text-sm font-semibold <%= stCls %>">
					    <i class="fas <%= stIcon %>"></i>
					    <%= stato.replace("_"," ").toUpperCase() %>
					  </span>
					</div>
					
					  <!-- Motivo -->
					  <p class="mb-3">
					    <span class="inline-flex items-center gap-2 px-3 py-1 rounded-md bg-blue-100 text-blue-700 text-xs font-semibold">
					      <i class="fas fa-box"></i> <%= motivo %>
					    </span>
					  </p>
					
					  <!-- Articoli: lista mobile + tabella desktop -->
						<div class="rounded-lg border border-gray-200 shadow-sm overflow-hidden">
						
						  <!-- MOBILE (fino a md) -->
						  <div class="md:hidden divide-y divide-gray-100">
						    <%
						      List<RichiestaRiga> righeInviate = r.getRighe();
						      if (righeInviate != null && !righeInviate.isEmpty()) {
						        for (RichiestaRiga rr : righeInviate) {
						          Articolo ai = ListaArticoli.getArticoloById(rr.getArticoloId());
						    %>
						    <div class="flex items-start justify-between gap-3 px-4 py-3">
						      <div class="min-w-0">
						        <div class="font-medium text-gray-800 break-words">
						          <%= ai != null ? ai.getNome() : ("ID " + rr.getArticoloId()) %>
						        </div>
						      </div>
						      <span class="shrink-0 inline-block px-2 py-0.5 rounded-full bg-indigo-600 text-white font-semibold">
						        <%= rr.getQuantita() %>
						      </span>
						    </div>
						    <%  } } else { %>
						    <div class="px-4 py-3 text-gray-500">Nessun articolo in questa richiesta.</div>
						    <% } %>
						  </div>
						
						  <!-- DESKTOP (da md in su) -->
						  <div class="hidden md:block overflow-x-auto">
						    <table class="min-w-full table-fixed divide-y divide-gray-200">
						      <thead class="bg-gray-100 text-xs text-gray-600 uppercase">
						        <tr>
						          <th class="px-4 py-2 text-left w-3/4">Articolo</th>
						          <th class="px-4 py-2 text-right w-1/4">Quantità</th>
						        </tr>
						      </thead>
						      <tbody class="divide-y divide-gray-100">
						        <%
						          if (righeInviate != null && !righeInviate.isEmpty()) {
						            for (RichiestaRiga rr : righeInviate) {
						              Articolo ai = ListaArticoli.getArticoloById(rr.getArticoloId());
						        %>
						        <tr>
						          <td class="px-4 py-2 font-medium text-gray-800 break-words">
						            <%= ai != null ? ai.getNome() : ("ID " + rr.getArticoloId()) %>
						          </td>
						          <td class="px-4 py-2 text-right">
						            <span class="inline-block px-2 py-0.5 rounded-full bg-indigo-600 text-white font-semibold">
						              <%= rr.getQuantita() %>
						            </span>
						          </td>
						        </tr>
						        <%  } } else { %>
						        <tr>
						          <td class="px-4 py-3 text-gray-500" colspan="2">Nessun articolo in questa richiesta.</td>
						        </tr>
						        <% } %>
						      </tbody>
						    </table>
						  </div>
						</div>

					
					  <!-- meta -->
					  <p class="text-xs text-gray-500 mt-2">Inviata il: <%= r.getDataRichiesta().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %></p>
					
					  <!-- note + azioni -->
					  
						<h3 class="mt-4 font-semibold">Note</h3>
						<div class="mt-2 pt-3 border-t border-gray-100">
						  <p class="text-sm text-gray-600 break-words">
						    <%= r.getNote() != null && !r.getNote().isBlank() ? r.getNote() : "-" %>
						  </p>
						
						  <form action="richieste-materiale" method="post"
							      onsubmit="return confirm('Confermi la cancellazione?');">
							      <div class="flex flex-col-reverse sm:flex-row justify-end gap-2">
							  <input type="hidden" name="op" value="delete">
							  <input type="hidden" name="id" value="<%= r.getId() %>">
							  <button type="submit"
							          class="px-4 py-2 bg-red-600 text-white rounded-md text-sm hover:bg-red-700 shadow-sm">
							    <i class="fas fa-trash mr-1"></i> Cancella
							  </button>
							  </div>
							</form>
					    </div>
					  </div>
					

                        <%
                        		}
                        	}else
                        %><p>Nessuna Richiesta Trovata</p>
                    </div>
                        
           
                </div>

                <!-- Received Requests -->
                <div id="received-content" class="tab-content hidden">
                    <div class="flex justify-between items-center mb-6">
                        <h2 class="text-xl font-semibold text-gray-800">Richieste Ricevute</h2>
                        
                    </div>
                    
                    <div class="space-y-4">
                        <!-- Received Request 1 -->
                        <% 
                        	
                        	List<Richiesta> lista = rd.getAllRichieste();
                        	if(lista!=null && !lista.isEmpty()){
                        		for(Richiesta r : lista){
                        
					    // ---- mapping stile/icone URGENZA ----
					    String urg = (r.getUrgenza() != null ? r.getUrgenza() : "media").toLowerCase();
					    String urgCls, urgIcon;
					    switch (urg) {
					        case "alta":  urgCls = "bg-red-100 text-red-700 border-red-30";    urgIcon = "fa-fire"; break;
					        case "bassa": urgCls = "bg-green-100 text-green-700 border-green-30";  urgIcon = "fa-check-circle"; break;
					        default:      urgCls = "bg-orange-100 text-orange-700 border-orange-30"; urgIcon = "fa-exclamation-triangle";
					    }
					
					    // ---- mapping stile/icone STATO ----
					    String stato = (r.getStato() != null ? r.getStato() : "in_attesa");
					    String stCls, stIcon;
					    switch (stato) {
					        case "approvata": stCls = "bg-green-100 text-green-700 border-green-30"; stIcon = "fa-check"; break;
					        case "rifiutata": stCls = "bg-red-100 text-red-700 border-red-30";   stIcon = "fa-times"; break;
					        case "evasa":     stCls = "bg-gray-100 text-gray-700 border-gray-30";  stIcon = "fa-box"; break;
					        default:          stCls = "bg-yellow-100 text-yellow-700 border-yellow-30"; stIcon = "fa-hourglass-half";
					    }
					
					    // ---- motivo (badge secondario) ----
					    String motivo = (r.getMotivo() != null ? r.getMotivo() : "-");
					%>
					
					<div class="request-card bg-white p-4 rounded-lg border border-gray-200">
					
					  <!-- header con badge -->
					  <div class="flex flex-wrap items-center justify-between gap-2 mb-4 bg-gray-50 px-3 py-2 rounded-md">
					  <!-- URGENZA -->
					  <span class="inline-flex items-center gap-2 px-3 py-1 rounded-md text-sm font-semibold <%= urgCls %>">
					    <i class="fas <%= urgIcon %>"></i>
					    URGENZA <%= urg.toUpperCase() %>
					  </span>
					  <!-- STATO -->
					  <span class="inline-flex items-center gap-2 px-3 py-1 rounded-md text-sm font-semibold <%= stCls %>">
					    <i class="fas <%= stIcon %>"></i>
					    <%= stato.replace("_"," ").toUpperCase() %>
					  </span>
					</div>
					
					  <!-- Motivo -->
					  <p class="mb-3">
					    <span class="inline-flex items-center gap-2 px-3 py-1 rounded-md bg-blue-100 text-blue-700 text-xs font-semibold">
					      <i class="fas fa-box"></i> <%= motivo %>
					    </span>
					  </p>
					
					  <!-- Tabella articoli -->
					  <!-- Articoli: lista mobile + tabella desktop -->
						<div class="rounded-lg border border-gray-200 shadow-sm overflow-hidden">
						
						  <!-- MOBILE (fino a md) -->
						  <div class="md:hidden divide-y divide-gray-100">
						    <%
						      List<RichiestaRiga> righeInviate = r.getRighe();
						      if (righeInviate != null && !righeInviate.isEmpty()) {
						        for (RichiestaRiga rr : righeInviate) {
						          Articolo ai = ListaArticoli.getArticoloById(rr.getArticoloId());
						    %>
						    <div class="flex items-start justify-between gap-3 px-4 py-3">
						      <div class="min-w-0">
						        <div class="font-medium text-gray-800 break-words">
						          <%= ai != null ? ai.getNome() : ("ID " + rr.getArticoloId()) %>
						        </div>
						      </div>
						      <span class="shrink-0 inline-block px-2 py-0.5 rounded-full bg-indigo-600 text-white font-semibold">
						        <%= rr.getQuantita() %>
						      </span>
						    </div>
						    <%  } } else { %>
						    <div class="px-4 py-3 text-gray-500">Nessun articolo in questa richiesta.</div>
						    <% } %>
						  </div>
						
						  <!-- DESKTOP (da md in su) -->
						  <div class="hidden md:block overflow-x-auto">
						    <table class="min-w-full table-fixed divide-y divide-gray-200">
						      <thead class="bg-gray-100 text-xs text-gray-600 uppercase">
						        <tr>
						          <th class="px-4 py-2 text-left w-3/4">Articolo</th>
						          <th class="px-4 py-2 text-right w-1/4">Quantità</th>
						        </tr>
						      </thead>
						      <tbody class="divide-y divide-gray-100">
						        <%
						          if (righeInviate != null && !righeInviate.isEmpty()) {
						            for (RichiestaRiga rr : righeInviate) {
						              Articolo ai = ListaArticoli.getArticoloById(rr.getArticoloId());
						        %>
						        <tr>
						          <td class="px-4 py-2 font-medium text-gray-800 break-words">
						            <%= ai != null ? ai.getNome() : ("ID " + rr.getArticoloId()) %>
						          </td>
						          <td class="px-4 py-2 text-right">
						            <span class="inline-block px-2 py-0.5 rounded-full bg-indigo-600 text-white font-semibold">
						              <%= rr.getQuantita() %>
						            </span>
						          </td>
						        </tr>
						        <%  } } else { %>
						        <tr>
						          <td class="px-4 py-3 text-gray-500" colspan="2">Nessun articolo in questa richiesta.</td>
						        </tr>
						        <% } %>
						      </tbody>
						    </table>
						  </div>
						</div>

					
					  <!-- meta -->
					  <p class="text-xs text-gray-500 mt-2">
						  Inviata il: <%= r.getDataRichiesta().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
						  da <b><%= UserService.getNomeById(r.getRichiedenteId()) %></b>
						</p>
											
					  <!-- note + azioni -->
					  <h3 class="mt-4 font-semibold">Note</h3>
						<div class="mt-2 pt-3 border-t border-gray-100">
						  <p class="text-sm text-gray-600 break-words">
						    <%= r.getNote() != null && !r.getNote().isBlank() ? r.getNote() : "-" %>
						  </p>
						
						  <form action="richieste-materiale" method="post" class="mt-4">
						    <input type="hidden" name="op" value="update">
						    <input type="hidden" name="id" value="<%= r.getId() %>">
						
						    <!-- Bottoni: stack su mobile, inline da sm in su -->
						    <div class="flex flex-col-reverse sm:flex-row justify-end gap-2">
						      <% if(!r.getStato().equals("rifiutata")) { %>
						      <button type="submit" name="stato" value="rifiutata"
						        class="px-4 py-2 bg-red-600 text-white rounded-md text-sm hover:bg-red-700 shadow-sm">
						        <i class="fas fa-times mr-1"></i> Rifiuta
						      </button>
						      <% } %>
						      <% if(!r.getStato().equals("approvata")) { %>
						      <button type="submit" name="stato" value="approvata"
						        class="px-4 py-2 bg-green-600 text-white rounded-md text-sm hover:bg-green-700 shadow-sm">
						        <i class="fas fa-check mr-1"></i> Approva
						      </button>
						      <% } %>
						    </div>
						  </form>
					  </div>
					</div>

                        <%
                        		}
                        	}else
                        %><p>Nessuna Richiesta Trovata</p>
                    </div>
                    
                    
                </div>
            </div>
        </div>
    </div>

    <script>
    
        // Tab switching functionality
        document.addEventListener('DOMContentLoaded', function() {
        	
            const tabs = document.querySelectorAll('.tab-button');
            const contents = document.querySelectorAll('.tab-content');
            
            tabs.forEach(tab => {
                tab.addEventListener('click', function() {
                    // Remove active class from all tabs
                    tabs.forEach(t => t.classList.remove('tab-active'));
                    // Add active class to clicked tab
                    this.classList.add('tab-active');
                    
                    // Hide all content
                    contents.forEach(content => content.classList.add('hidden'));
                    
                    // Show corresponding content
                    const contentId = this.id.replace('-tab', '-content');
                    document.getElementById(contentId).classList.remove('hidden');
                });
            });
            if (!<%= "Tecnico".equals(ruolo) %>) {
                const el = document.getElementById("received-tab");
                if (el) el.click();
              }else document.getElementById("send-tab").click();
         
            
           
        });
        //INVIO RICHIESTE
        
        
        (function(){
					  const $input = document.getElementById('materialInput');
					  const $box   = document.getElementById('suggestBox');
					  const $msg   = document.getElementById('materialMsg');
					  const $qty   = document.getElementById('qtyInput');
					  const $add   = document.getElementById('addItemBtn');
					  const $clear = document.getElementById('clearItemBtn');
					  const $list  = document.getElementById('selectedList');
					  const $hidden= document.getElementById('hiddenFields');
					  
					
					  let activeIndex = -1;
					  let currentMatches = [];
					  let selectedArticolo = null; // {id, nome}
					
					  function norm(s){ return (s||'').toLowerCase().normalize('NFD').replace(/\p{Diacritic}/gu,''); }
						
					  function renderSuggest(matches){
						  $box.innerHTML = '';
						  if (!matches.length) { $box.classList.add('hidden'); return; }
						  matches.slice(0, 12).forEach((m, i) => {
						    const item = document.createElement('button');
						    item.type = 'button';
						    item.className =
						      'w-full text-left px-3 py-2 hover:bg-indigo-50 focus:bg-indigo-50 focus:outline-none';
						    item.dataset.index = i;
						    item.innerHTML = `
						      <div class="flex items-center justify-between">
						        <span class="text-gray-800 font-medium truncate">`+m.nome+`</span>
						        <span class="inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-xs font-medium
						               bg-green-100 text-green-700">
								    
								    `+m.disponibili+` disp.
								  </span>
						      </div>`;
						    item.addEventListener('click', () => pick(i)); 
						    $box.appendChild(item);
						  });
						  $box.classList.remove('hidden');
						}
					  
					
					  function search(q){
						  if (!q || q.trim().length < 1) {
						    $box.classList.add('hidden'); 
						    $msg.textContent = '';
						    selectedArticolo = null;
						    activeIndex = -1;
						    return;
						  }

						  const nq = norm(q);
						  const seen = new Set();          // nomi già visti (normalizzati)
						  const unique = [];

						  for (const a of ARTICOLI) {
						    const nameNorm = norm(a.nome || '');
						    if (nameNorm.includes(nq) && !seen.has(nameNorm)) {
						      seen.add(nameNorm);
						      unique.push(a);              // tieni il primo articolo con quel nome
						    }
						  }

						  currentMatches = unique;

						  if (!currentMatches.length) {
						    $msg.className = 'mt-1 text-xs text-red-600';
						    $msg.textContent = 'Nessun articolo trovato';
						    $box.classList.add('hidden');
						    selectedArticolo = null;
						  } else {
						    $msg.className = 'mt-1 text-xs text-gray-500';
						    $msg.textContent = `Suggerimenti: ${currentMatches.length}`;
						    renderSuggest(currentMatches);
						  }
						  activeIndex = -1;
						}
					
					  function pick(i){
						  const a = currentMatches[i];
						  if (!a) return;

						  selectedArticolo = a;
						  $input.value = a.nome;
						  $box.classList.add('hidden');

						  $msg.className = 'mt-1 text-xs text-green-700';
						  $msg.textContent = `Selezionato: `+a.nome+` | disponibili: `+a.disponibili;

						  const max = Math.max(1, parseInt(a.disponibili, 10) || 1);
						  $qty.setAttribute('min', '1');
						  $qty.setAttribute('step', '1');
						  $qty.setAttribute('max', String(max));

						  // 🔴 rimuovi eventuali vecchi handler
						  if ($qty._onInput)  $qty.removeEventListener('input',  $qty._onInput);
						  if ($qty._onBlur)   $qty.removeEventListener('blur',   $qty._onBlur);
						  if ($qty._onChange) $qty.removeEventListener('change', $qty._onChange);

						  // 🟢 crea e registra nuovi handler chiusi sul nuovo max
						  $qty._onInput  = makeClampHandler(max);
						  $qty._onBlur   = () => forceValid(max);
						  $qty._onChange = () => forceValid(max);

						  $qty.addEventListener('input',  $qty._onInput);
						  $qty.addEventListener('blur',   $qty._onBlur);
						  $qty.addEventListener('change', $qty._onChange);

						  // clamp immediato al nuovo range
						  forceValid(max);

						  $input.focus();
						}
					
					  $input.addEventListener('input', (e)=> search(e.target.value));
					  $input.addEventListener('focus', ()=> { if (currentMatches.length) $box.classList.remove('hidden'); });
					  document.addEventListener('click', (e)=> { if (!e.target.closest('#suggestBox') && e.target!==$input) $box.classList.add('hidden'); });
					
					  $input.addEventListener('keydown', (e)=>{
					    if ($box.classList.contains('hidden')) return;
					    const items = Array.from($box.querySelectorAll('button'));
					    if (e.key === 'ArrowDown') { e.preventDefault(); activeIndex = (activeIndex+1) % items.length; items[activeIndex].focus(); }
					    if (e.key === 'ArrowUp')   { e.preventDefault(); activeIndex = (activeIndex-1+items.length) % items.length; items[activeIndex].focus(); }
					    if (e.key === 'Enter')     { e.preventDefault(); if (activeIndex>=0) items[activeIndex].click(); }
					  });
					  
					  function makeClampHandler(max) {
						  return function clamp() {
						    // consenti campo vuoto mentre digiti
						    const raw = ($qty.value ?? '').toString().trim();
						    if (raw === '') return;

						    let val = parseInt(raw, 10);
						    if (!Number.isFinite(val)) val = 1;
						    if (val < 1) val = 1;
						    if (val > max) val = max;
						    if ($qty.value !== String(val)) $qty.value = String(val);
						  };
						}

						// clamp finale su blur/change (chiude sempre nel range)
						function forceValid(max) {
						  let val = parseInt($qty.value || '1', 10);
						  if (!Number.isFinite(val)) val = 1;
						  if (val < 1) val = 1;
						  if (val > max) val = max;
						  $qty.value = String(val);
						}
					
					  function addSelected(){
					    // se non ho scelto dal menu, prova match esatto/uniqueness
					    if (!selectedArticolo) {
					      const q = $input.value.trim();
					      if (!q) { warn('Inserisci un materiale'); return; }
					      const exact = ARTICOLI.filter(a => norm(a.nome) === norm(q));
					      if (exact.length === 1) selectedArticolo = exact[0];
					      else { warn('Seleziona un materiale dall’elenco'); return; }
					    }
					    const maxAttr = parseInt($qty.getAttribute('max') || '1', 10) || 1;
					    const entered = parseInt($qty.value || '1', 10) || 1;
					    const qta = Math.max(1, Math.min(entered, maxAttr));
					    // crea riga visuale
					    const li = document.createElement('li');
					    li.className = 'flex items-center justify-between rounded-md border border-gray-200 px-3 py-2';
					    li.innerHTML = `
					      <div class="flex items-center gap-2">
					        <i class="fas fa-box text-gray-500"></i>
					        <span class="font-medium text-gray-800">`+selectedArticolo.nome+`</span>
					       
					      </div>
					      <div class="flex items-center gap-3">
					        <span class="inline-block px-2 py-0.5 rounded-full bg-indigo-600 text-white text-sm font-semibold">`+qta+`</span>
					        <button type="button" class="text-red-600 hover:text-red-700" title="Rimuovi">
					          <i class="fas fa-times"></i>
					        </button>
					      </div>`;
					    // bottone rimuovi
					    li.querySelector('button').addEventListener('click', ()=> {
					      li.remove();
					      hiddenQty.remove();
					      hiddenId.remove();
					    });
					    $list.appendChild(li);
					
					    // hidden fields per submit
					    const hiddenId  = document.createElement('input');
					    hiddenId.type = 'hidden'; hiddenId.name = 'articoloId'; hiddenId.value = String(selectedArticolo.id);
					    const hiddenQty = document.createElement('input');
					    hiddenQty.type = 'hidden'; hiddenQty.name = 'quantita';  hiddenQty.value = String(qta);
					    $hidden.appendChild(hiddenId);
					    $hidden.appendChild(hiddenQty);
					
					    // reset input
					    selectedArticolo = null;
					    $input.value = '';
					    $qty.value = 1;
					    $msg.textContent = '';
					  }
					
					  function warn(t){
					    $msg.className = 'mt-1 text-xs text-red-600';
					    $msg.textContent = t;
					    $box.classList.add('hidden');
					  }
					
					  $add.addEventListener('click', addSelected);
					  $qty.addEventListener('keydown', (e)=> { if(e.key==='Enter'){ e.preventDefault(); addSelected(); }});
					  $clear.addEventListener('click', ()=>{
					    $list.innerHTML = ''; $hidden.innerHTML = '';
					    $input.value=''; $qty.value=1; $msg.textContent=''; selectedArticolo=null;
					  });
					})();
    </script>
</body>
</html>