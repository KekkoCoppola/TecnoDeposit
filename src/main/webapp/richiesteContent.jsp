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
										<link rel="stylesheet"
											href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
														<i class="fas fa-boxes mr-2 text-red-500"></i> Richieste
														Materiale
													</h1>
													<% RichiestaDAO rd=new RichiestaDAO(); String ruolo=(String)
														session.getAttribute("ruolo"); %>
												</div>
											</header>

											<!-- Main Content -->
											<div class="bg-white rounded-lg shadow-md overflow-hidden">
												<!-- Tabs -->
												<div class="flex border-b">
													<%if(ruolo.equals("Tecnico")){ %>
														<button id="send-tab"
															class="tab-button px-6 py-4 text-gray-600 hover:text-red-500 focus:outline-none ">
															<i class="fas fa-paper-plane mr-2"></i> Invia
														</button>
														<button id="sent-tab"
															class="tab-button px-6 py-4 text-gray-600 hover:text-red-500 focus:outline-none">
															<i class="fas fa-paperclip mr-2"></i> Richieste Inviate
														</button>
														<%}if(!ruolo.equals("Tecnico")){ %>
															<button id="received-tab"
																class="tab-button px-6 py-4 text-gray-600 hover:text-red-500 focus:outline-none ">
																<i class="fas fa-inbox mr-2"></i> Richieste Ricevute
															</button>
															<%} %>
												</div>

												<!-- Tab Content -->
												<div class="p-6">
													<!-- Send Request Form -->
													<div id="send-content" class="tab-content">
														<%--======SERVER: esporta la lista articoli in JS======--%>
															<% ListaArticoli listaA=new ListaArticoli(); List<Articolo>
																all = listaA.getArticoliPronti(); // o come recuperi tu
																%>
																<script>
																	const ARTICOLI = [
					    <% for (int i = 0; i < all.size(); i++) {
					         Articolo a = all.get(i);
					         String nome = a.getNome() != null ? a.getNome().replace("\"", "\\\"") : "";
					         
					    %> { id:<%=a.getId() %>, nome: `<%=nome%>`, disponibili: `<%=listaA.countArticoliDisponibiliByNome(nome)%>` } <%= (i < all.size() - 1) ? "," : "" %>
					    <% } %>
					  ];
																</script>

																<form id="formRichieste" action="richieste-materiale"
																	method="post" autocomplete="off">

																	<!-- Container principale con stile card -->
																	<div
																		class="bg-white rounded-2xl shadow-md border border-gray-100 p-4 sm:p-6">

																		<!-- Sezione Ricerca Materiale -->
																		<div class="mb-6">
																			<h3
																				class="text-sm font-semibold text-gray-800 uppercase tracking-wide mb-4 flex items-center gap-2">
																				<i
																					class="fas fa-box text-[#e52c1f]"></i>
																				Aggiungi Materiale
																			</h3>

																			<div
																				class="flex flex-col sm:flex-row gap-3">
																				<!-- Campo Materiale con autocomplete -->
																				<div class="relative flex-1">
																					<div
																						class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
																						<i
																							class="fas fa-search text-gray-400"></i>
																					</div>
																					<input id="materialInput"
																						type="text" autocomplete="off"
																						class="w-full pl-11 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-gray-800 placeholder-gray-400
					                 focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
					                 transition-all duration-200" placeholder="Cerca materiale per nome...">
																					<!-- dropdown suggerimenti -->
																					<div id="suggestBox"
																						class="absolute z-20 mt-1 w-full max-h-60 overflow-auto rounded-xl border border-gray-200 bg-white shadow-xl hidden">
																					</div>
																					<!-- messaggio esito -->
																					<p id="materialMsg"
																						class="mt-1.5 text-xs text-gray-500">
																					</p>
																				</div>

																				<!-- Quantità -->
																				<div class="w-full sm:w-32">
																					<div class="relative">
																						<div
																							class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
																							<i
																								class="fas fa-hashtag text-gray-400"></i>
																						</div>
																						<input id="qtyInput"
																							type="number" min="1"
																							value="1" class="w-full pl-11 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-gray-800 text-center font-semibold
					                   focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
					                   transition-all duration-200" placeholder="Qtà">
																					</div>
																				</div>

																				<!-- Bottoni Aggiungi / Svuota -->
																				<div class="flex gap-2">
																					<button type="button"
																						id="addItemBtn" class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-5 py-3 bg-[#e52c1f] hover:bg-[#c5271b] text-white rounded-xl
					                 transition-all duration-200 shadow-sm hover:shadow-md font-medium">
																						<i class="fas fa-plus"></i>
																						<span>Aggiungi</span>
																					</button>
																					<button type="button"
																						id="clearItemBtn" class="flex items-center justify-center gap-2 px-4 py-3 bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-xl
					                 transition-all duration-200 border border-gray-200">
																						<i class="fas fa-trash-alt"></i>
																					</button>
																				</div>
																			</div>
																		</div>

																		<!-- Lista articoli selezionati -->
																		<div class="mb-6">
																			<h3
																				class="text-sm font-semibold text-gray-800 uppercase tracking-wide mb-3 flex items-center gap-2">
																				<i
																					class="fas fa-clipboard-list text-violet-500"></i>
																				Articoli Richiesti
																			</h3>
																			<div
																				class="bg-gray-50 rounded-xl border border-gray-200 p-3 min-h-[60px]">
																				<ul id="selectedList" class="space-y-2">
																				</ul>
																				<p
																					class="text-gray-400 text-sm text-center py-2 empty-list-msg">
																					Nessun articolo aggiunto</p>
																			</div>
																		</div>

																		<!-- Griglia Motivo + Urgenza -->
																		<div
																			class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">

																			<!-- Motivo -->
																			<div>
																				<label
																					class="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">
																					<i
																						class="fas fa-tag mr-1 text-gray-400"></i>Motivo
																				</label>
																				<select id="motivo" name="motivo" class="w-full bg-gray-50 border border-gray-200 rounded-xl px-4 py-3 text-gray-700
					               focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
					               transition-all duration-200 cursor-pointer appearance-none
					               bg-[url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27%236b7280%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e')]
					               bg-[length:1.25rem] bg-[right_0.75rem_center] bg-no-repeat pr-10">
																					<option value="Reintegro">Reintegro
																					</option>
																					<option value="Fornitura">Fornitura
																					</option>
																				</select>
																			</div>

																			<!-- Urgenza -->
																			<div>
																				<label
																					class="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">
																					<i
																						class="fas fa-bolt mr-1 text-gray-400"></i>Urgenza
																				</label>
																				<div class="flex gap-2">
																					<label class="flex-1">
																						<input type="radio"
																							name="urgenza" value="Alta"
																							class="sr-only peer"
																							checked>
																						<div class="w-full py-2.5 px-3 rounded-xl border-2 border-gray-200 bg-gray-50 text-center cursor-pointer
					                      transition-all duration-200 text-sm font-medium text-gray-600
					                      peer-checked:border-red-500 peer-checked:bg-red-50 peer-checked:text-red-700
					                      hover:border-gray-300">
																							<i
																								class="fas fa-fire mr-1"></i>Alta
																						</div>
																					</label>
																					<label class="flex-1">
																						<input type="radio"
																							name="urgenza" value="Media"
																							class="sr-only peer">
																						<div class="w-full py-2.5 px-3 rounded-xl border-2 border-gray-200 bg-gray-50 text-center cursor-pointer
					                      transition-all duration-200 text-sm font-medium text-gray-600
					                      peer-checked:border-orange-500 peer-checked:bg-orange-50 peer-checked:text-orange-700
					                      hover:border-gray-300">
																							<i
																								class="fas fa-minus mr-1"></i>Media
																						</div>
																					</label>
																					<label class="flex-1">
																						<input type="radio"
																							name="urgenza" value="Bassa"
																							class="sr-only peer">
																						<div class="w-full py-2.5 px-3 rounded-xl border-2 border-gray-200 bg-gray-50 text-center cursor-pointer
					                      transition-all duration-200 text-sm font-medium text-gray-600
					                      peer-checked:border-green-500 peer-checked:bg-green-50 peer-checked:text-green-700
					                      hover:border-gray-300">
																							<i
																								class="fas fa-angle-down mr-1"></i>Bassa
																						</div>
																					</label>
																				</div>
																			</div>
																		</div>

																		<!-- Note -->
																		<div class="mb-6">
																			<label
																				class="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">
																				<i
																					class="fas fa-sticky-note mr-1 text-gray-400"></i>Note
																				(opzionale)
																			</label>
																			<textarea id="note" name="note" rows="3"
																				class="w-full bg-gray-50 border border-gray-200 rounded-xl px-4 py-3 text-gray-700 placeholder-gray-400
					             focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
					             transition-all duration-200 resize-none" placeholder="Aggiungi note o dettagli sulla richiesta..."></textarea>
																		</div>

																		<!-- Hidden fields per articoli -->
																		<div id="hiddenFields"></div>

																		<!-- Bottone Invia -->
																		<div class="flex justify-end">
																			<button type="submit" id="send" class="inline-flex items-center gap-2 px-6 py-3 bg-gradient-to-r from-[#e52c1f] to-[#c5271b] hover:from-[#c5271b] hover:to-[#991b1b]
					             text-white rounded-xl transition-all duration-200 shadow-md hover:shadow-lg font-semibold">
																				<i class="fas fa-paper-plane"></i>
																				<span>Invia Richiesta</span>
																			</button>
																		</div>

																	</div>
																</form>

																<style>
																	#selectedList:not(:empty)+.empty-list-msg {
																		display: none;
																	}
																</style>
																<script></script>

													</div>

													<!-- Sent Requests -->
													<div id="sent-content" class="tab-content hidden">

														<!-- Container con stile card -->
														<div
															class="bg-white rounded-2xl shadow-md border border-gray-100 p-4 sm:p-6">
															<h3
																class="text-sm font-semibold text-gray-800 uppercase tracking-wide mb-4 flex items-center gap-2">
																<i class="fas fa-paper-plane text-[#e52c1f]"></i> Le Mie
																Richieste Inviate
															</h3>

															<div class="space-y-4">
																<% List<Richiesta> listaInviate =
																	rd.findByRichiedente((int)
																	session.getAttribute("userId"));
																	if(listaInviate!=null && !listaInviate.isEmpty()){
																	for(Richiesta r : listaInviate){

																	// ---- mapping stile/icone URGENZA ----
																	String urg = (r.getUrgenza() != null ?
																	r.getUrgenza() : "media").toLowerCase();
																	String urgCls, urgIcon;
																	switch (urg) {case "alta": urgCls = "bg-red-100 text-red-700 border border-red-200"; urgIcon = "fa-fire";
																	break;
																	case "bassa": urgCls = "bg-green-100 text-green-700 border border-green-200"; urgIcon ="fas fa-angle-down"; break;
																	default: urgCls = "bg-orange-100 text-orange-700 border border-orange-200"; urgIcon ="fa-exclamation-triangle";
																	}

																	// ---- mapping stile/icone STATO ----
																	String stato = (r.getStato() != null ? r.getStato(): "in_attesa");
																	String stCls, stIcon;
																	switch (stato) {
																	case "approvata": stCls = "bg-emerald-100 text-emerald-700 border border-emerald-200"; stIcon=
																	"fa-check"; break;
																	case "rifiutata": stCls = "bg-red-100 text-red-700 border border-red-200"; stIcon = "fa-times"; break;
																	case "evasa": stCls = "bg-gray-100 text-gray-700 border border-gray-200"; stIcon = "fa-box"; break;
																	default: stCls = "bg-yellow-100 text-yellow-700 border border-yellow-200"; stIcon =
																	"fa-hourglass-half";
																	}

																	// ---- motivo (badge secondario) ----
																	String motivo = (r.getMotivo() != null ?
																	r.getMotivo() : "-");
																	%>

																	<!-- Request Card -->
																	<div
																		class="bg-gray-50 rounded-xl border border-gray-200 overflow-hidden hover:shadow-md transition-all duration-200">

																		<!-- Header con badge -->
																		<div
																			class="flex flex-wrap items-center gap-2 p-4 bg-white border-b border-gray-100">
																			<!-- URGENZA -->
																			<span
																				class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold <%= urgCls %>">
																				<i class="fas <%= urgIcon %>"></i>
																				<%= urg.toUpperCase() %>
																			</span>
																			<!-- STATO -->
																			<span
																				class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold <%= stCls %>">
																				<i class="fas <%= stIcon %>"></i>
																				<%= stato.replace("_"," ").toUpperCase() %>
									          </span>
									          <!-- MOTIVO -->
									          <span class=" inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-semibold
																					bg-blue-50 text-blue-700 border
																					border-blue-200">
																					<i class="fas fa-tag"></i>
																					<%= motivo %>
																			</span>
																		</div>

																		<!-- Articoli richiesti -->
																		<div class="p-4">
																			<p
																				class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">
																				<i class="fas fa-box mr-1"></i>Articoli
																				Richiesti
																			</p>

																			<div
																				class="bg-white rounded-lg border border-gray-200 overflow-hidden">
																				<% List<RichiestaRiga> righeInviate =
																					r.getRighe();
																					if (righeInviate != null &&
																					!righeInviate.isEmpty()) {
																					for (RichiestaRiga rr :
																					righeInviate) {
																					Articolo ai =
																					ListaArticoli.getArticoloById(rr.getArticoloId());
																					%>
																					<div
																						class="flex items-center justify-between px-4 py-3 border-b border-gray-100 last:border-b-0">
																						<span
																							class="font-medium text-gray-800">
																							<%= ai !=null ? ai.getNome()
																								: ("ID " + rr.getArticoloId()) %></span>
									              <span class=" inline-flex items-center justify-center min-w-[28px] h-7 px-2 rounded-lg
																								bg-[#e52c1f] text-white
																								text-sm font-bold">
																								<%= rr.getQuantita() %>
																						</span>
																					</div>
																					<% } } else { %>
																						<div
																							class="px-4 py-3 text-gray-400 text-sm text-center">
																							Nessun articolo</div>
																						<% } %>
																			</div>
																		</div>

																		<!-- Footer: meta + azioni -->
																		<div class="px-4 pb-4">
																			<!-- Note -->
																			<% if(r.getNote() !=null &&
																				!r.getNote().isBlank()) { %>
																				<div
																					class="mb-3 p-3 bg-white rounded-lg border border-gray-200">
																					<p
																						class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">
																						<i
																							class="fas fa-sticky-note mr-1"></i>Note
																					</p>
																					<p class="text-sm text-gray-600">
																						<%= r.getNote() %>
																					</p>
																				</div>
																				<% } %>

																					<!-- Meta + Azioni -->
																					<div
																						class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
																						<p
																							class="text-xs text-gray-500">
																							<i
																								class="fas fa-clock mr-1"></i>
																							Inviata il <%=
																								r.getDataRichiesta().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
																								%>
																								alle <%=
																									r.getDataRichiesta().format(DateTimeFormatter.ofPattern("HH:mm"))
																									%>
																						</p>

																						<form
																							action="richieste-materiale"
																							method="post"
																							onsubmit="return confirm('Confermi la cancellazione?');">
																							<input type="hidden"
																								name="op"
																								value="delete">
																							<input type="hidden"
																								name="id"
																								value="<%= r.getId() %>">
																							<button type="submit" class="inline-flex items-center gap-2 px-4 py-2 bg-red-50 hover:bg-red-100 text-red-600 rounded-xl 
									                       border border-red-200 transition-all duration-200 text-sm font-medium">
																								<i
																									class="fas fa-trash-alt"></i>
																								<span>Cancella</span>
																							</button>
																						</form>
																					</div>
																		</div>

																	</div>

																	<% } } else { %>
																		<div class="text-center py-8">
																			<div
																				class="w-16 h-16 mx-auto mb-4 rounded-full bg-gray-100 flex items-center justify-center">
																				<i
																					class="fas fa-inbox text-2xl text-gray-400"></i>
																			</div>
																			<p class="text-gray-500">Nessuna richiesta
																				inviata</p>
																		</div>
																		<% } %>
															</div>
														</div>
													</div>

													<!-- Received Requests -->
													<div id="received-content" class="tab-content hidden">

														<!-- Container con stile card -->
														<div
															class="bg-white rounded-2xl shadow-md border border-gray-100 p-4 sm:p-6">
															<h3
																class="text-sm font-semibold text-gray-800 uppercase tracking-wide mb-4 flex items-center gap-2">
																<i class="fas fa-inbox text-[#e52c1f]"></i> Richieste
																Ricevute
															</h3>

															<div class="space-y-4">
																<% List<Richiesta> lista = rd.getAllRichieste();
																	if(lista!=null && !lista.isEmpty()){
																	for(Richiesta r : lista){

																	// ---- mapping stile/icone URGENZA ----
																	String urg = (r.getUrgenza() != null ?
																	r.getUrgenza() : "media").toLowerCase();
																	String urgCls, urgIcon;
																	switch (urg) {
																	case "alta": urgCls = "bg-red-100 text-red-700 border border-red-200"; urgIcon = "fa-fire"; break;
																	case "bassa": urgCls = "bg-green-100 text-green-700 border border-green-200"; urgIcon =
																	"fas fa-angle-down"; break;
																	default: urgCls = "bg-orange-100 text-orange-700 border border-orange-200"; urgIcon =
																	"fa-exclamation-triangle";
																	}

																	// ---- mapping stile/icone STATO + sfondo card ----
																	String stato = (r.getStato() != null ? r.getStato()
																	: "in_attesa");
																	String stCls, stIcon, cardBg;
																	switch (stato) {
																	case "approvata": stCls = "bg-emerald-100 text-emerald-700 border border-emerald-200"; stIcon
																	= "fa-check"; cardBg = "bg-emerald-50/50"; break;
																	case "rifiutata": stCls = "bg-red-100 text-red-700 border border-red-200"; stIcon = "fa-times"; cardBg
																	= "bg-red-50/50"; break;
																	case "evasa": stCls = "bg-gray-100 text-gray-700 border border-gray-200"; stIcon = "fa-box"; cardBg =
																	"bg-gray-100/50"; break;
																	default: stCls = "bg-yellow-100 text-yellow-700 border border-yellow-200"; stIcon =
																	"fa-hourglass-half"; cardBg = "bg-white";
																	}
																	// ---- bordo sinistro priorità ----
																	String borderLeft;
																	switch (urg) {
																	case "alta": borderLeft = "border-l-4 border-l-red-500"; break;
																	case "bassa": borderLeft = "border-l-4 border-l-green-500"; break;
																	default: borderLeft = "border-l-4 border-l-orange-400";
																	}
																	// ---- motivo ----
																	String motivo = (r.getMotivo() != null ?
																	r.getMotivo() : "-");
																	%>

																	<!-- Request Card con bordo sinistro priorità -->
																	<div
																		class="<%= cardBg %> <%= borderLeft %> rounded-xl border border-gray-200 overflow-hidden hover:shadow-lg transition-all duration-200">

																		<!-- RIGA 1: Priorità grande + Richiedente -->
																		<div
																			class="flex items-center justify-between p-4 border-b border-gray-100">
																			<div class="flex items-center gap-3">
																				<span
																					class="inline-flex items-center gap-2 px-4 py-2 rounded-full text-sm font-bold <%= urgCls %> shadow-sm">
																					<i class="fas <%= urgIcon %>"></i>
																					<%= urg.toUpperCase() %>
																				</span>
																				<span
																					class="text-lg font-semibold text-gray-800">
																					<i
																						class="fas fa-user text-violet-500 mr-1"></i>
																					<%= UserService.getNomeById(r.getRichiedenteId())
																						%>
																				</span>
																			</div>
																			<span class="text-xs text-gray-400">
																				<i class="fas fa-clock mr-1"></i>
																				<%= r.getDataRichiesta().format(DateTimeFormatter.ofPattern("dd/MMHH:mm")) %>
																			</span>
																		</div>

																		<!-- RIGA 2: Stato prominente + Motivo piccolo -->
																		<div
																			class="flex items-center gap-3 px-4 py-2 bg-white/60">
																			<span
																				class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-bold <%= stCls %>">
																				<i class="fas <%= stIcon %>"></i>
																				<%= stato.replace("_"," ").toUpperCase() %>
										</span>
										<span class=" text-xs text-gray-500">
																					<i class="fas fa-tag mr-1"></i>
																					<%= motivo %>
																			</span>
																		</div>
																		<!-- Articoli richiesti -->
																		<div class="p-4">
																			<p
																				class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">
																				<i class="fas fa-box mr-1"></i>Articoli
																				Richiesti
																			</p>

																			<div
																				class="bg-white rounded-lg border border-gray-200 overflow-hidden">
																				<% List<RichiestaRiga> righeInviate =
																					r.getRighe();
																					if (righeInviate != null &&
																					!righeInviate.isEmpty()) {
																					for (RichiestaRiga rr :
																					righeInviate) {
																					Articolo ai =
																					ListaArticoli.getArticoloById(rr.getArticoloId());
																					%>
																					<div
																						class="flex items-center justify-between px-4 py-3 border-b border-gray-100 last:border-b-0">
																						<span
																							class="font-medium text-gray-800">
																							<%= ai !=null ? ai.getNome()
																								: ("ID " + rr.getArticoloId()) %></span>
									              <span class=" inline-flex items-center justify-center min-w-[28px] h-7 px-2 rounded-lg
																								bg-[#e52c1f] text-white
																								text-sm font-bold">
																								<%= rr.getQuantita() %>
																						</span>
																					</div>
																					<% } } else { %>
																						<div
																							class="px-4 py-3 text-gray-400 text-sm text-center">
																							Nessun articolo</div>
																						<% } %>
																			</div>
																		</div>

																		<!-- Footer: meta + azioni -->
																		<div class="px-4 pb-4">
																			<!-- Note -->
																			<% if(r.getNote() !=null &&
																				!r.getNote().isBlank()) { %>
																				<div
																					class="mb-3 p-3 bg-white rounded-lg border border-gray-200">
																					<p
																						class="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1">
																						<i
																							class="fas fa-sticky-note mr-1"></i>Note
																					</p>
																					<p class="text-sm text-gray-600">
																						<%= r.getNote() %>
																					</p>
																				</div>
																				<% } %>

																					<!-- Meta + Azioni -->
																					<div
																						class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
																						<p
																							class="text-xs text-gray-500">
																							<i
																								class="fas fa-clock mr-1"></i>
																							Inviata il <%=
																								r.getDataRichiesta().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"))
																								%>
																								alle <%=
																									r.getDataRichiesta().format(DateTimeFormatter.ofPattern("HH:mm"))
																									%>
																						</p>

																						<form
																							action="richieste-materiale"
																							method="post">
																							<input type="hidden"
																								name="op"
																								value="update">
																							<input type="hidden"
																								name="id"
																								value="<%= r.getId() %>">
																							<div class="flex gap-2">
																								<% if(!r.getStato().equals("rifiutata"))
																									{ %>
																									<button
																										type="submit"
																										name="stato"
																										value="rifiutata"
																										class="inline-flex items-center gap-2 px-4 py-2 bg-red-50 hover:bg-red-100 text-red-600 rounded-xl 
									                         border border-red-200 transition-all duration-200 text-sm font-medium">
																										<i
																											class="fas fa-times"></i>
																										<span>Rifiuta</span>
																									</button>
																									<% } %>
																										<% if(!r.getStato().equals("approvata"))
																											{ %>
																											<button
																												type="submit"
																												name="stato"
																												value="approvata"
																												class="inline-flex items-center gap-2 px-4 py-2 bg-emerald-50 hover:bg-emerald-100 text-emerald-600 rounded-xl 
									                         border border-emerald-200 transition-all duration-200 text-sm font-medium">
																												<i
																													class="fas fa-check"></i>
																												<span>Approva</span>
																											</button>
																											<% } %>
																							</div>
																						</form>
																					</div>
																		</div>

																	</div>

																	<% } } else { %>
																		<div class="text-center py-8">
																			<div
																				class="w-16 h-16 mx-auto mb-4 rounded-full bg-gray-100 flex items-center justify-center">
																				<i
																					class="fas fa-inbox text-2xl text-gray-400"></i>
																			</div>
																			<p class="text-gray-500">Nessuna richiesta
																				ricevuta</p>
																		</div>
																		<% } %>
															</div>
														</div>
													</div>

												</div>
											</div>
										</div>
										</div>

										<script>

											// Tab switching functionality
											document.addEventListener('DOMContentLoaded', function () {

												const tabs = document.querySelectorAll('.tab-button');
												const contents = document.querySelectorAll('.tab-content');

												tabs.forEach(tab => {
													tab.addEventListener('click', function () {
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


											(function () {
												const $input = document.getElementById('materialInput');
												const $box = document.getElementById('suggestBox');
												const $msg = document.getElementById('materialMsg');
												const $qty = document.getElementById('qtyInput');
												const $add = document.getElementById('addItemBtn');
												const $clear = document.getElementById('clearItemBtn');
												const $list = document.getElementById('selectedList');
												const $hidden = document.getElementById('hiddenFields');


												let activeIndex = -1;
												let currentMatches = [];
												let selectedArticolo = null; // {id, nome}

												function norm(s) { return (s || '').toLowerCase().normalize('NFD').replace(/\p{Diacritic}/gu, ''); }

												function renderSuggest(matches) {
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
						        <span class="text-gray-800 font-medium truncate">`+ m.nome + `</span>
						        <span class="inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-xs font-medium
						               bg-green-100 text-green-700">
								    
								    `+ m.disponibili + ` disp.
								  </span>
						      </div>`;
														item.addEventListener('click', () => pick(i));
														$box.appendChild(item);
													});
													$box.classList.remove('hidden');
												}


												function search(q) {
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

												function pick(i) {
													const a = currentMatches[i];
													if (!a) return;

													selectedArticolo = a;
													$input.value = a.nome;
													$box.classList.add('hidden');

													$msg.className = 'mt-1 text-xs text-green-700';
													$msg.textContent = `Selezionato: ` + a.nome + ` | disponibili: ` + a.disponibili;

													const max = Math.max(1, parseInt(a.disponibili, 10) || 1);
													$qty.setAttribute('min', '1');
													$qty.setAttribute('step', '1');
													$qty.setAttribute('max', String(max));

													// 🔴 rimuovi eventuali vecchi handler
													if ($qty._onInput) $qty.removeEventListener('input', $qty._onInput);
													if ($qty._onBlur) $qty.removeEventListener('blur', $qty._onBlur);
													if ($qty._onChange) $qty.removeEventListener('change', $qty._onChange);

													// 🟢 crea e registra nuovi handler chiusi sul nuovo max
													$qty._onInput = makeClampHandler(max);
													$qty._onBlur = () => forceValid(max);
													$qty._onChange = () => forceValid(max);

													$qty.addEventListener('input', $qty._onInput);
													$qty.addEventListener('blur', $qty._onBlur);
													$qty.addEventListener('change', $qty._onChange);

													// clamp immediato al nuovo range
													forceValid(max);

													$input.focus();
												}

												$input.addEventListener('input', (e) => search(e.target.value));
												$input.addEventListener('focus', () => { if (currentMatches.length) $box.classList.remove('hidden'); });
												document.addEventListener('click', (e) => { if (!e.target.closest('#suggestBox') && e.target !== $input) $box.classList.add('hidden'); });

												$input.addEventListener('keydown', (e) => {
													if ($box.classList.contains('hidden')) return;
													const items = Array.from($box.querySelectorAll('button'));
													if (e.key === 'ArrowDown') { e.preventDefault(); activeIndex = (activeIndex + 1) % items.length; items[activeIndex].focus(); }
													if (e.key === 'ArrowUp') { e.preventDefault(); activeIndex = (activeIndex - 1 + items.length) % items.length; items[activeIndex].focus(); }
													if (e.key === 'Enter') { e.preventDefault(); if (activeIndex >= 0) items[activeIndex].click(); }
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

												function addSelected() {
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
					        <span class="font-medium text-gray-800">`+ selectedArticolo.nome + `</span>
					       
					      </div>
					      <div class="flex items-center gap-3">
					        <span class="inline-block px-2 py-0.5 rounded-full bg-indigo-600 text-white text-sm font-semibold">`+ qta + `</span>
					        <button type="button" class="text-red-600 hover:text-red-700" title="Rimuovi">
					          <i class="fas fa-times"></i>
					        </button>
					      </div>`;
													// bottone rimuovi
													li.querySelector('button').addEventListener('click', () => {
														li.remove();
														hiddenQty.remove();
														hiddenId.remove();
													});
													$list.appendChild(li);

													// hidden fields per submit
													const hiddenId = document.createElement('input');
													hiddenId.type = 'hidden'; hiddenId.name = 'articoloId'; hiddenId.value = String(selectedArticolo.id);
													const hiddenQty = document.createElement('input');
													hiddenQty.type = 'hidden'; hiddenQty.name = 'quantita'; hiddenQty.value = String(qta);
													$hidden.appendChild(hiddenId);
													$hidden.appendChild(hiddenQty);

													// reset input
													selectedArticolo = null;
													$input.value = '';
													$qty.value = 1;
													$msg.textContent = '';
												}

												function warn(t) {
													$msg.className = 'mt-1 text-xs text-red-600';
													$msg.textContent = t;
													$box.classList.add('hidden');
												}

												$add.addEventListener('click', addSelected);
												$qty.addEventListener('keydown', (e) => { if (e.key === 'Enter') { e.preventDefault(); addSelected(); } });
												$clear.addEventListener('click', () => {
													$list.innerHTML = ''; $hidden.innerHTML = '';
													$input.value = ''; $qty.value = 1; $msg.textContent = ''; selectedArticolo = null;
												});
											})();
										</script>
									</body>

									</html>