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
											<header class="mb-6 sm:mb-8">
												<div
													class="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
													<h1
														class="text-2xl sm:text-3xl font-bold text-gray-800 tracking-tight">
														<div
															class="w-10 h-10 sm:w-12 sm:h-12 bg-red-100 text-red-600 rounded-xl inline-flex items-center justify-center mr-3 shadow-sm">
															<i class="fas fa-boxes text-xl sm:text-2xl"></i>
														</div>
														<span class="align-middle">Richieste Materiale</span>
													</h1>
													<% RichiestaDAO rd=new RichiestaDAO(); String ruolo=(String)
														session.getAttribute("ruolo"); %>
												</div>
											</header>

											<!-- Main Content -->
											<div
												class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden">
												<!-- Tabs (scrollabili su mobile) -->
												<div class="flex overflow-x-auto border-b hide-scrollbar bg-gray-50/50">
													<%if(ruolo.equals("Tecnico")){ %>
														<button id="send-tab"
															class="tab-button whitespace-nowrap px-4 sm:px-6 py-4 text-sm sm:text-base font-medium text-gray-500 hover:text-red-500 hover:bg-red-50/30 focus:outline-none transition-colors">
															<i class="fas fa-paper-plane mr-2"></i> Invia Richiesta
														</button>
														<button id="sent-tab"
															class="tab-button whitespace-nowrap px-4 sm:px-6 py-4 text-sm sm:text-base font-medium text-gray-500 hover:text-red-500 hover:bg-red-50/30 focus:outline-none transition-colors">
															<i class="fas fa-history mr-2"></i> Richieste Inviate
														</button>
														<%}if(!ruolo.equals("Tecnico")){ %>
															<button id="received-tab"
																class="tab-button whitespace-nowrap px-4 sm:px-6 py-4 text-sm sm:text-base font-medium text-gray-500 hover:text-red-500 hover:bg-red-50/30 focus:outline-none transition-colors">
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

																	<!-- Container principale -->
																	<div
																		class="max-w-4xl mx-auto space-y-6 sm:space-y-8">

																		<!-- Sezione Aggiungi Materiale -->
																		<div
																			class="bg-white rounded-2xl border border-gray-200 shadow-sm overflow-hidden">
																			<div
																				class="bg-gray-50/50 border-b border-gray-100 px-5 py-4">
																				<h3
																					class="text-sm font-bold text-gray-800 uppercase tracking-wider flex items-center gap-2">
																					<i
																						class="fas fa-box-open text-[#e52c1f]"></i>
																					Seleziona Materiale
																				</h3>
																			</div>
																			<div class="p-5 sm:p-6">
																				<div
																					class="flex flex-col sm:flex-row gap-4 items-start sm:items-center">
																					<!-- Campo Materiale con autocomplete -->
																					<div
																						class="relative w-full sm:flex-1">
																						<div
																							class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
																							<i
																								class="fas fa-search text-gray-400"></i>
																						</div>
																						<input id="materialInput"
																							type="text"
																							autocomplete="off" class="w-full pl-11 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-gray-800 placeholder-gray-400
																							focus:outline-none focus:ring-2 focus:ring-[#e52c1f]/50 focus:border-[#e52c1f] focus:bg-white
																							transition-all duration-200 shadow-inner" placeholder="Cerca materiale per nome...">
																						<!-- dropdown suggerimenti -->
																						<div id="suggestBox"
																							class="absolute z-20 mt-2 w-full max-h-60 overflow-auto rounded-xl border border-gray-200 bg-white shadow-xl hidden">
																						</div>
																						<!-- messaggio esito -->
																						<p id="materialMsg"
																							class="mt-2 text-xs font-medium text-gray-500">
																						</p>
																					</div>

																					<!-- Quantità con bottoni + e - -->
																					<div
																						class="w-full sm:w-auto flex items-center gap-2">
																						<div
																							class="flex items-center bg-gray-50 border border-gray-200 rounded-xl h-[50px] overflow-hidden shadow-inner">
																							<button type="button"
																								id="qtyDecBtn"
																								class="w-10 h-full flex items-center justify-center text-gray-500 hover:text-[#e52c1f] hover:bg-gray-100 transition-colors border-r border-gray-200"
																								title="Riduci quantità">
																								<i
																									class="fas fa-minus text-sm"></i>
																							</button>
																							<input id="qtyInput"
																								type="number" min="1"
																								value="1"
																								class="w-16 h-full text-center text-gray-800 font-bold bg-transparent focus:outline-none focus:bg-white transition-colors appearance-none outline-none m-0"
																								style="-moz-appearance: textfield;"
																								placeholder="Qtà">
																							<button type="button"
																								id="qtyIncBtn"
																								class="w-10 h-full flex items-center justify-center text-gray-500 hover:text-[#e52c1f] hover:bg-gray-100 transition-colors border-l border-gray-200"
																								title="Aumenta quantità">
																								<i
																									class="fas fa-plus text-sm"></i>
																							</button>
																						</div>
																					</div>

																					<!-- Bottoni Aggiungi / Svuota -->
																					<div
																						class="w-full sm:w-auto flex gap-2">
																						<button type="button"
																							id="addItemBtn" class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-6 h-[50px] bg-[#e52c1f] hover:bg-[#c5271b] text-white rounded-xl
																							transition-all duration-200 shadow-sm hover:shadow-md font-medium">
																							<i class="fas fa-plus"></i>
																							<span
																								class="sm:hidden lg:inline">Aggiungi</span>
																						</button>
																						<button type="button"
																							id="clearItemBtn" class="flex-1 sm:flex-none flex items-center justify-center gap-2 px-4 h-[50px] bg-gray-100 hover:bg-gray-200 text-gray-600 rounded-xl
																							transition-all duration-200 border border-gray-200" title="Svuota riga">
																							<i
																								class="fas fa-eraser"></i>
																						</button>
																					</div>
																				</div>
																			</div>
																		</div>

																		<!-- Articoli Richiesti (Lista) -->
																		<div>
																			<h3
																				class="text-sm font-bold text-gray-800 uppercase tracking-wider mb-3 flex items-center gap-2 px-1">
																				<i
																					class="fas fa-clipboard-list text-violet-500"></i>
																				Riepilogo Richiesta
																			</h3>
																			<div
																				class="bg-gray-50 rounded-2xl border border-gray-200 p-4 min-h-[80px] shadow-inner">
																				<ul id="selectedList" class="space-y-3">
																				</ul>
																				<div
																					class="empty-list-msg flex flex-col items-center justify-center py-6 text-gray-400">
																					<i
																						class="fas fa-box-open text-3xl mb-2 opacity-50"></i>
																					<p class="text-sm font-medium">
																						Nessun articolo aggiunto</p>
																				</div>
																			</div>
																		</div>

																		<!-- Dettagli Richiesta (Motivo, Urgenza, Note) -->
																		<div
																			class="bg-white rounded-2xl border border-gray-200 shadow-sm p-5 sm:p-6">
																			<div
																				class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
																				<!-- Motivo -->
																				<div>
																					<label
																						class="block text-xs font-bold text-gray-600 uppercase tracking-widest mb-2">
																						Motivo
																					</label>
																					<select id="motivo" name="motivo"
																						class="w-full bg-gray-50 border border-gray-200 rounded-xl px-4 py-3.5 text-gray-700 font-medium
																						focus:outline-none focus:ring-2 focus:ring-[#e52c1f]/50 focus:border-[#e52c1f] focus:bg-white
																						transition-all duration-200 cursor-pointer appearance-none shadow-sm
																						bg-[url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27%236b7280%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e')]
																						bg-[length:1.25rem] bg-[right_1rem_center] bg-no-repeat pr-10">
																						<option value="Reintegro">
																							Reintegro Standard</option>
																						<option value="Fornitura">Nuova
																							Fornitura</option>
																					</select>
																				</div>

																				<!-- Urgenza -->
																				<div>
																					<label
																						class="block text-xs font-bold text-gray-600 uppercase tracking-widest mb-2">
																						Urgenza
																					</label>
																					<div class="flex gap-2">
																						<label
																							class="flex-1 cursor-pointer">
																							<input type="radio"
																								name="urgenza"
																								value="Alta"
																								class="sr-only peer"
																								checked>
																							<div class="w-full py-3.5 px-2 rounded-xl border-2 border-gray-200 bg-gray-50 text-center
																								transition-all duration-200 text-sm font-bold text-gray-500
																								peer-checked:border-red-500 peer-checked:bg-red-50 peer-checked:text-red-700 peer-checked:shadow-sm
																								hover:bg-gray-100 flex items-center justify-center gap-1.5">
																								<i
																									class="fas fa-fire"></i>
																								<span
																									class="hidden sm:inline">Alta</span>
																							</div>
																						</label>
																						<label
																							class="flex-1 cursor-pointer">
																							<input type="radio"
																								name="urgenza"
																								value="Media"
																								class="sr-only peer">
																							<div class="w-full py-3.5 px-2 rounded-xl border-2 border-gray-200 bg-gray-50 text-center
																								transition-all duration-200 text-sm font-bold text-gray-500
																								peer-checked:border-orange-500 peer-checked:bg-orange-50 peer-checked:text-orange-700 peer-checked:shadow-sm
																								hover:bg-gray-100 flex items-center justify-center gap-1.5">
																								<i
																									class="fas fa-bolt"></i>
																								<span
																									class="hidden sm:inline">Media</span>
																							</div>
																						</label>
																						<label
																							class="flex-1 cursor-pointer">
																							<input type="radio"
																								name="urgenza"
																								value="Bassa"
																								class="sr-only peer">
																							<div class="w-full py-3.5 px-2 rounded-xl border-2 border-gray-200 bg-gray-50 text-center
																								transition-all duration-200 text-sm font-bold text-gray-500
																								peer-checked:border-green-500 peer-checked:bg-green-50 peer-checked:text-green-700 peer-checked:shadow-sm
																								hover:bg-gray-100 flex items-center justify-center gap-1.5">
																								<i
																									class="fas fa-leaf"></i>
																								<span
																									class="hidden sm:inline">Bassa</span>
																							</div>
																						</label>
																					</div>
																				</div>
																			</div>

																			<!-- Note -->
																			<div>
																				<label
																					class="block text-xs font-bold text-gray-600 uppercase tracking-widest mb-2 flex items-center justify-between">
																					<span>Note Aggiuntive</span>
																					<span
																						class="text-[10px] bg-gray-100 text-gray-500 px-2 py-0.5 rounded-md">Opzionale</span>
																				</label>
																				<textarea id="note" name="note" rows="3"
																					class="w-full bg-gray-50 border border-gray-200 rounded-xl px-4 py-3 text-gray-700 placeholder-gray-400
																					focus:outline-none focus:ring-2 focus:ring-[#e52c1f]/50 focus:border-[#e52c1f] focus:bg-white
																					transition-all duration-200 resize-none shadow-sm" placeholder="Specifica dettagli sulla richiesta (es. 'Mi serve per il cantiere X')..."></textarea>
																			</div>
																		</div>

																		<!-- Hidden fields per articoli -->
																		<div id="hiddenFields"></div>

																		<!-- Bottone Invia -->
																		<div class="flex justify-end pt-4">
																			<button type="submit" id="send"
																				class="w-full sm:w-auto inline-flex items-center justify-center gap-3 px-8 py-4 bg-gradient-to-r from-[#e52c1f] to-[#c5271b] hover:from-[#c5271b] hover:to-[#991b1b]
																				text-white rounded-xl transition-all duration-300 shadow-lg hover:shadow-xl hover:-translate-y-0.5 font-bold text-lg">
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

														<!-- Container -->
														<div
															class="bg-transparent sm:bg-white sm:rounded-2xl sm:shadow-sm sm:border sm:border-gray-100 sm:p-6">
															<h3
																class="hidden sm:flex text-lg font-bold text-gray-800 tracking-tight mb-6 items-center gap-2">
																<i class="fas fa-history text-[#e52c1f]"></i> Storico
																Richieste Inviate
															</h3>

															<div
																class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
																<% List<Richiesta> listaInviate =
																	rd.findByRichiedente((int)
																	session.getAttribute("userId"));
																	if(listaInviate!=null && !listaInviate.isEmpty()){
																	for(Richiesta r : listaInviate){

																	// ---- mapping stile/icone URGENZA ----
																	String urg = (r.getUrgenza() != null ?
																	r.getUrgenza() : "media").toLowerCase();
																	String urgCls, urgIcon;
																	switch (urg) {
																	case "alta": urgCls = "bg-red-100 text-red-700";
																	urgIcon = "fa-fire"; break;
																	case "bassa": urgCls = "bg-green-100 text-green-700"; urgIcon ="fas fa-leaf"; break;
																	default: urgCls = "bg-orange-100 text-orange-700";
																	urgIcon ="fa-bolt";
																	}

																	// ---- mapping stile/icone STATO ----
																	String stato = (r.getStato() != null ? r.getStato()
																	: "in_attesa");
																	String stCls, stIcon, borderSt;
																	switch (stato) {
																	case "approvata": stCls = "bg-emerald-50 text-emerald-700 border-emerald-200"; stIcon=
																	"fa-check"; borderSt="border-t-4 border-t-emerald-500"; break;
																	case "rifiutata": stCls = "bg-red-50 text-red-700 border-red-200"; stIcon = "fa-times";
																	borderSt="border-t-4 border-t-red-500"; break;
																	case "evasa": stCls = "bg-gray-50 text-gray-700 border-gray-200"; stIcon = "fa-box-check";
																	borderSt="border-t-4 border-t-gray-400"; break;
																	default: stCls = "bg-amber-50 text-amber-700 border-amber-200"; stIcon = "fa-hourglass-half";
																	borderSt="border-t-4 border-t-amber-500";
																	}

																	// ---- motivo ----
																	String motivo = (r.getMotivo() != null ?
																	r.getMotivo() : "-");
																	%>

																	<!-- Request Card -->
																	<div
																		class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-all duration-300 flex flex-col <%= borderSt %>">

																		<!-- Header Card -->
																		<div
																			class="p-4 sm:p-5 border-b border-gray-50 flex flex-col gap-3">
																			<div
																				class="flex justify-between items-start">
																				<div class="flex flex-col gap-1">
																					<span
																						class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Stato</span>
																					<span
																						class="inline-flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold border <%= stCls %>">
																						<i
																							class="fas <%= stIcon %>"></i>
																						<%= stato.replace("_"," ").toUpperCase() %>
																					</span>
																				</div>
																				<div class=" flex flex-col items-end gap-1">
																							<span
																								class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Urgenza</span>
																							<span
																								class="inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-xs font-bold <%= urgCls %>">
																								<i
																									class="fas <%= urgIcon %>"></i>
																								<%= urg.toUpperCase() %>
																							</span>
																				</div>
																			</div>
																			<div
																				class="flex items-center gap-2 text-xs font-semibold text-gray-500 bg-gray-50 px-3 py-2 rounded-lg mt-2">
																				<i class="fas fa-tag opacity-70"></i>
																				<span>
																					<%= motivo %>
																				</span>
																			</div>
																		</div>

																		<!-- Articoli richiesti -->
																		<div class="p-4 sm:p-5 flex-1 bg-gray-50/30">
																			<p
																				class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-3 flex items-center gap-1.5">
																				<i class="fas fa-box-open"></i> Articoli
																			</p>

																			<div class="space-y-2">
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
																						class="flex items-center justify-between text-sm bg-white border border-gray-100 rounded-lg px-3 py-2 shadow-sm">
																						<span
																							class="font-medium text-gray-700 truncate mr-2">
																							<%= ai !=null ? ai.getNome()
																								: ("ID " + rr.getArticoloId()) %>
																						</span>
																						<span class=" inline-flex items-center justify-center min-w-[24px] h-6 px-1.5 rounded
																								bg-indigo-50
																								text-indigo-700
																								font-bold border
																								border-indigo-100">
																								<%= rr.getQuantita() %>
																						</span>
																					</div>
																					<% } } else { %>
																						<div
																							class="px-4 py-3 text-gray-400 text-sm text-center italic border border-dashed rounded-lg">
																							Nul</div>
																						<% } %>
																			</div>
																		</div>

																		<!-- Footer: meta + azioni -->
																		<div
																			class="p-4 sm:p-5 border-t border-gray-50 mt-auto bg-white">
																			<% if(r.getNote() !=null &&
																				!r.getNote().isBlank()) { %>
																				<div class="mb-4 text-xs">
																					<span
																						class="font-bold text-gray-400 uppercase tracking-wider block mb-1">Note:</span>
																					<p class="text-gray-600 bg-gray-50 p-2 rounded-lg border border-gray-100 italic line-clamp-2"
																						title="<%= r.getNote().replace("\"", "&quot;" ) %>">
																						<%= r.getNote() %>
																					</p>
																				</div>
																				<% } %>

																					<div
																						class="flex items-center justify-between mt-2 pt-2 border-t border-gray-50 border-dashed">
																						<div
																							class="text-[10px] sm:text-xs text-gray-400 font-medium">
																							<i
																								class="fas fa-calendar-alt mr-1"></i>
																							<%= r.getDataRichiesta().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
																						</div>

																						<form
																							action="richieste-materiale"
																							method="post"
																							onsubmit="return confirm('Sei sicuro di voler annullare questa richiesta?');">
																							<input type="hidden"
																								name="op"
																								value="delete">
																							<input type="hidden"
																								name="id"
																								value="<%= r.getId() %>">
																							<button type="submit"
																								class="inline-flex items-center justify-center w-8 h-8 rounded-full bg-red-50 hover:bg-red-500 text-red-500 hover:text-white transition-all duration-200"
																								title="Annulla Richiesta">
																								<i
																									class="fas fa-trash-alt text-sm"></i>
																							</button>
																						</form>
																					</div>
																		</div>
																	</div>
																	<% } } else { %>
																		<div
																			class="col-span-full py-16 text-center bg-gray-50 rounded-2xl border border-dashed border-gray-200">
																			<div
																				class="w-20 h-20 mx-auto mb-4 rounded-full bg-white shadow-sm flex items-center justify-center">
																				<i
																					class="fas fa-wind text-3xl text-gray-300"></i>
																			</div>
																			<h4
																				class="text-lg font-bold text-gray-700 mb-1">
																				Nessuna richiesta inviata</h4>
																			<p class="text-sm text-gray-500">Non hai
																				ancora inviato richieste di materiale.
																			</p>
																		</div>
																		<% } %>
															</div>
														</div>
													</div>

													<!-- Received Requests -->
													<div id="received-content" class="tab-content hidden">

														<!-- Container -->
														<div
															class="bg-transparent sm:bg-white sm:rounded-2xl sm:shadow-sm sm:border sm:border-gray-100 sm:p-6">
															<h3
																class="hidden sm:flex text-lg font-bold text-gray-800 tracking-tight mb-6 items-center gap-2">
																<i class="fas fa-inbox text-[#e52c1f]"></i> Richieste
																Ricevute da Gestire
															</h3>

															<div
																class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
																<% List<Richiesta> lista = rd.getAllRichieste();
																	if(lista!=null && !lista.isEmpty()){
																	for(Richiesta r : lista){

																	// ---- mapping stile/icone URGENZA ----
																	String urg = (r.getUrgenza() != null ?
																	r.getUrgenza() : "media").toLowerCase();
																	String urgCls, urgIcon;
																	switch (urg) {
																	case "alta": urgCls = "bg-red-100 text-red-700";
																	urgIcon = "fa-fire"; break;
																	case "bassa": urgCls = "bg-green-100 text-green-700"; urgIcon ="fas fa-leaf"; break;
																	default: urgCls = "bg-orange-100 text-orange-700";
																	urgIcon ="fa-bolt";
																	}

																	// ---- mapping stile/icone STATO ----
																	String stato = (r.getStato() != null ? r.getStato()
																	: "in_attesa");
																	String stCls, stIcon, borderSt;
																	switch (stato) {
																	case "approvata": stCls = "bg-emerald-50 text-emerald-700 border-emerald-200"; stIcon=
																	"fa-check"; borderSt="border-t-4 border-t-emerald-500 opacity-70"; break;
																	case "rifiutata": stCls = "bg-red-50 text-red-700 border-red-200"; stIcon = "fa-times";
																	borderSt="border-t-4 border-t-red-500 opacity-70";
																	break;
																	case "evasa": stCls = "bg-gray-50 text-gray-700 border-gray-200"; stIcon = "fa-box-check";
																	borderSt="border-t-4 border-t-gray-400 opacity-70";
																	break;
																	default: stCls = "bg-amber-50 text-amber-700 border-amber-200"; stIcon = "fa-hourglass-half";
																	borderSt="border-t-4 border-t-amber-500 ring-2 ring-amber-500/20";
																	}

																	// ---- motivo ----
																	String motivo = (r.getMotivo() != null ?
																	r.getMotivo() : "-");
																	%>

																	<!-- Request Card -->
																	<div
																		class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition-all duration-300 flex flex-col <%= borderSt %> relative">

																		<!-- Header Card -->
																		<div
																			class="p-4 sm:p-5 border-b border-gray-50 flex flex-col gap-3">
																			<div
																				class="flex justify-between items-start">
																				<div class="flex flex-col gap-1">
																					<span
																						class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Richiedente</span>
																					<span
																						class="inline-flex items-center gap-2 text-sm font-bold text-gray-800">
																						<div
																							class="w-6 h-6 rounded-full bg-indigo-100 text-indigo-700 flex items-center justify-center text-xs">
																							<i class="fas fa-user"></i>
																						</div>
																						<%= UserService.getNomeById(r.getRichiedenteId())
																							%>
																					</span>
																				</div>
																				<div
																					class="flex flex-col items-end gap-1">
																					<span
																						class="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Urgenza</span>
																					<span
																						class="inline-flex items-center gap-1 px-2.5 py-1 rounded-md text-xs font-bold <%= urgCls %>">
																						<i
																							class="fas <%= urgIcon %>"></i>
																						<%= urg.toUpperCase() %>
																					</span>
																				</div>
																			</div>

																			<div
																				class="flex justify-between items-center mt-1">
																				<span
																					class="inline-flex items-center gap-1.5 px-3 py-1 rounded-lg text-xs font-bold border <%= stCls %>">
																					<i class="fas <%= stIcon %>"></i>
																					<%= stato.replace("_"," ").toUpperCase() %>
																				</span>
																				<div class=" flex items-center gap-1.5 text-xs font-medium text-gray-500 bg-gray-50 px-2 py-1
																						rounded-md">
																						<i
																							class="fas fa-tag opacity-70"></i>
																						<span>
																							<%= motivo %>
																						</span>
																			</div>
																		</div>
																	</div>

																	<!-- Articoli richiesti -->
																	<div class="p-4 sm:p-5 flex-1 bg-gray-50/30">
																		<p
																			class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mb-3 flex items-center gap-1.5">
																			<i class="fas fa-box-open"></i> Articoli
																		</p>

																		<div class="space-y-2">
																			<% List<RichiestaRiga> righeInviate =
																				r.getRighe();
																				if (righeInviate != null &&
																				!righeInviate.isEmpty()) {
																				for (RichiestaRiga rr : righeInviate) {
																				Articolo ai =
																				ListaArticoli.getArticoloById(rr.getArticoloId());
																				%>
																				<div
																					class="flex items-center justify-between text-sm bg-white border border-gray-100 rounded-lg px-3 py-2 shadow-sm">
																					<span
																						class="font-medium text-gray-700 truncate mr-2">
																						<%= ai !=null ? ai.getNome() :
																							("ID " + rr.getArticoloId()) %>
																						</span>
																						<span class=" inline-flex items-center justify-center min-w-[24px] h-6 px-1.5 rounded
																							bg-[#e52c1f]/10
																							text-[#e52c1f] font-bold
																							border border-[#e52c1f]/20">
																							<%= rr.getQuantita() %>
																					</span>
																				</div>
																				<% } } else { %>
																					<div
																						class="px-4 py-3 text-gray-400 text-sm text-center italic border border-dashed rounded-lg">
																						Nul</div>
																					<% } %>
																		</div>
																	</div>

																	<!-- Footer: meta + azioni -->
																	<div
																		class="p-4 sm:p-5 border-t border-gray-50 mt-auto bg-white">
																		<% if(r.getNote() !=null &&
																			!r.getNote().isBlank()) { %>
																			<div class="mb-4 text-xs">
																				<span
																					class="font-bold text-gray-400 uppercase tracking-wider block mb-1">Note:</span>
																				<p class="text-gray-600 bg-gray-50 p-2 rounded-lg border border-gray-100 italic line-clamp-2"
																					title="<%= r.getNote().replace("\"", "&quot;" ) %>">
																					<%= r.getNote() %>
																				</p>
																			</div>
																			<% } %>

																				<div
																					class="flex flex-col gap-3 mt-2 pt-2 border-t border-gray-50 border-dashed">
																					<div
																						class="text-[10px] sm:text-xs text-gray-400 font-medium text-center mb-1">
																						<i
																							class="fas fa-calendar-alt mr-1"></i>
																						Ricevuta il <%=
																							r.getDataRichiesta().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
																					</div>

																					<form action="richieste-materiale"
																						method="post"
																						class="flex gap-2 w-full">
																						<input type="hidden" name="op"
																							value="update">
																						<input type="hidden" name="id"
																							value="<%= r.getId() %>">

																						<% if(!r.getStato().equals("rifiutata"))
																							{ %>
																							<button type="submit"
																								name="stato"
																								value="rifiutata"
																								class="flex-1 inline-flex items-center justify-center gap-1.5 px-3 py-2.5 bg-red-50 hover:bg-red-500 text-red-600 hover:text-white rounded-xl border border-red-100 hover:border-red-500 transition-all duration-200 text-sm font-bold shadow-sm">
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
																										class="flex-1 inline-flex items-center justify-center gap-1.5 px-3 py-2.5 bg-emerald-50 hover:bg-emerald-500 text-emerald-600 hover:text-white rounded-xl border border-emerald-100 hover:border-emerald-500 transition-all duration-200 text-sm font-bold shadow-sm">
																										<i
																											class="fas fa-check"></i>
																										<span>Approva</span>
																									</button>
																									<% } %>
																					</form>
																				</div>
																	</div>
															</div>
															<% } } else { %>
																<div
																	class="col-span-full py-16 text-center bg-gray-50 rounded-2xl border border-dashed border-gray-200">
																	<div
																		class="w-20 h-20 mx-auto mb-4 rounded-full bg-white shadow-sm flex items-center justify-center">
																		<i
																			class="fas fa-inbox text-3xl text-gray-300"></i>
																	</div>
																	<h4 class="text-lg font-bold text-gray-700 mb-1">
																		Nessuna richiesta da gestire</h4>
																	<p class="text-sm text-gray-500">Ottimo lavoro! La
																		coda delle richieste è vuota.</p>
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
												const $qtyDecBtn = document.getElementById('qtyDecBtn');
												const $qtyIncBtn = document.getElementById('qtyIncBtn');
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
														if (isNaN(val)) val = 1;
														if (val < 1) val = 1;
														if (val > max) val = max;
														$qty.value = val;
													};
												}

												// clamp finale su blur/change (chiude sempre nel range)
												function forceValid(max) {
													const raw = ($qty.value ?? '').toString().trim();
													let val = parseInt(raw, 10);
													if (isNaN(val) || val < 1) val = 1;
													if (val > max) val = max;
													$qty.value = val;
												}

												// Handlers bottoni +/- quantità
												$qtyDecBtn.addEventListener('click', () => {
													let val = parseInt($qty.value, 10) || 1;
													if (val > 1) {
														$qty.value = val - 1;
														if ($qty._onChange) $qty._onChange();
													}
												});

												$qtyIncBtn.addEventListener('click', () => {
													let val = parseInt($qty.value, 10) || 1;
													const max = parseInt($qty.getAttribute('max'), 10) || 999;
													if (val < max) {
														$qty.value = val + 1;
														if ($qty._onChange) $qty._onChange();
													}
												});

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