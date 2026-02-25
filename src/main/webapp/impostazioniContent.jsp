<%@ page import="model.User" %>
	<%@ page import="model.UserService" %>
		<%@ page import="java.util.List" %>
			<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
				<!DOCTYPE html>
				<html>

				<head>
					<meta charset="UTF-8">
					<title></title>
				</head>

				<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
				<style>
					.user-table {
						min-width: 100%;
					}

					.user-table th,
					.user-table td {
						white-space: nowrap;
						padding: 12px 15px;
					}

					.dropdown-content {
						display: none;
						position: absolute;
						right: 0;
						background-color: white;
						min-width: 200px;
						box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
						z-index: 1;
						border-radius: 0.5rem;
					}

					.dropdown:hover .dropdown-content {
						display: block;
					}

					.status-active {
						background-color: #10B981;
					}

					.status-inactive {
						background-color: #EF4444;
					}

					.status-pending {
						background-color: #F59E0B;
					}

					/* Paginazione tabella utenti */
					.user-pagination {
						display: flex;
						align-items: center;
						justify-content: center;
						gap: 8px;
						padding: 16px 0;
					}

					.user-pagination button {
						padding: 6px 14px;
						border: 1px solid #d1d5db;
						border-radius: 8px;
						background: white;
						cursor: pointer;
						font-size: 14px;
						transition: all 0.15s;
					}

					.user-pagination button:hover:not(:disabled) {
						background: #f3f4f6;
					}

					.user-pagination button:disabled {
						opacity: 0.4;
						cursor: not-allowed;
					}

					.user-pagination button.active {
						background: #ef4444;
						color: white;
						border-color: #ef4444;
					}

					.user-pagination .page-info {
						font-size: 13px;
						color: #6b7280;
					}
				</style>

				<body>
					<div class="pb-24 md:pb-0">
						<div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
							<div>
								<h1 class="text-3xl font-bold text-gray-800">Gestione Utenti</h1>
								<p class="text-gray-600">Gestione completa degli utenti</p>
							</div>
							<button id="addUserBtn"
								class="bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-lg flex items-center gap-2 transition-colors">
								<i class="fas fa-user-plus"></i> Nuovo Utente
							</button>
						</div>

						<!-- Users Table -->

						<div class="overflow-x-auto">
							<table class="user-table min-w-full divide-y divide-gray-200">
								<thead class="bg-gray-50">

									<tr>
										<th scope="col"
											class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											<div class="flex items-center">

												<span class="ml-2">Utente</span>
											</div>
										</th>
										<th scope="col"
											class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Ruolo
										</th>
										<th scope="col"
											class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Stato Attuale
										</th>
										<th scope="col"
											class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
											Ultimo accesso
										</th>
										<th scope="col"
											class="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
											Azioni
										</th>
									</tr>
								</thead>
								<tbody class="bg-white divide-y divide-gray-200">

									<% String ruoloUtenteLoggato=(String) session.getAttribute("ruolo"); UserService
										utenti=new UserService(); List<User> users =
										utenti.getAllUsers();
										//System.out.println("PRODOTTI: "+articoli);
										int i=0;
										if (users != null && !users.isEmpty()) {
										for (User u : users) {
										i++;

										%>
										<tr class="hover:bg-gray-50">
											<td class=" px-6 py-4 whitespace-nowrap">
												<div class="flex items-center">

													<div class="flex-shrink-0 h-10 w-10">
														<div
															class="w-10 h-10 rounded-full bg-[#d1d1d1] flex items-center justify-center">
															<i class="fas fa-user"></i>
														</div>
													</div>
													<div class="ml-4">
														<div class="text-sm font-medium text-gray-900">
															<%= u.getUsername() %>
														</div>
														<div class="text-sm text-gray-500">
															<%= u.getMail() %>
														</div>
													</div>
												</div>
											</td>
											<% String coloreRuolo="blue" ; if(u.getRuolo().equals("Developer"))
												coloreRuolo="purple" ; if(u.getRuolo().equals("Amministratore"))
												coloreRuolo="yellow" ; if(u.getRuolo().equals("Magazziniere"))
												coloreRuolo="orange" ; %>
												<td class="px-6 py-4 whitespace-nowrap">
													<span
														class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-<%=coloreRuolo %>-100 text-<%=coloreRuolo %>-800">
														<%= u.getRuolo() %>
													</span>
												</td>
												<% String coloreStato="green" ; if(u.getStato().equals("inattivo"))
													coloreStato="red" ; %>
													<td class="px-6 py-4 whitespace-nowrap">
														<span
															class="px-2 inline-flex text-xs leading-5 font-semibold rounded-full bg-<%=coloreStato %>-100 text-<%=coloreStato %>-800">
															<%= u.getStato() %>
														</span>
													</td>
													<td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
														<%= u.getUltimoAccesso2() %>
													</td>
													<td
														class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
														<div data-username="<%= u.getUsername() %>"
															data-telefono="<%= u.getTelefono() %>"
															data-id="<%= u.getId() %>" data-mail="<%= u.getMail() %>"
															data-ruolo="<%= u.getRuolo() %>"
															data-nome="<%= u.getNome() %>"
															data-cognome="<%= u.getCognome() %>"
															data-stato="<%= u.getStato() %>"
															class="userCard flex justify-end space-x-2">
															<%if(ruoloUtenteLoggato.equals("Amministratore") ||
																session.getAttribute("userId").equals(u.getId())){ %>
																<button
																	class="editUser text-indigo-600 hover:text-indigo-900">
																	<i class="fas fa-user-edit"></i>
																</button>
																<%}else{ %>
																	<button
																		class="viewUser text-indigo-600 hover:text-gray-900">
																		<i class="fas fa-eye"></i>
																	</button>
																	<%} %>

														</div>
													</td>
										</tr>
										<% } } else { %>
											<p>Nessun Utente disponibile.</p>
											<% } %>

								</tbody>
							</table>
							<!-- Paginazione Utenti -->
							<div id="userPagination" class="user-pagination"></div>
						</div>
						<!-- ALTRI TASTI -->
						<div class="bg-white rounded-xl shadow-md overflow-hidden">
							<div class="px-6 py-4 border-b border-gray-200">
								<h2 class="text-lg font-semibold text-gray-800">Altre Impostazioni</h2>
							</div>
							<div class="divide-y divide-gray-200">
								<div class="p-4 hover:bg-gray-50">
									<div class="flex items-center">
										<button id="btnGeneratePdf"
											class="fas fa-file-pdf text-red-600 bg-red-100 p-2 rounded-full mr-4">
										</button>

										<div class="flex-1">
											<p class="text-sm font-medium text-red-600">Scarica Etichette Qr</p>
											<p class="text-xs text-gray-500">Scarica un file pdf con tutte le
												etichette degli articoli.</p>
										</div>



										<div id="loadingOverlay" style="
							  display: none;
							  position: fixed;
							  top:0; left:0; right:0; bottom:0;
							  background: rgba(0,0,0,0.5);
							  color: white;
							  font-size: 24px;
							  font-weight: bold;
							  text-align: center;
							  padding-top: 20vh;
							  z-index: 9999;
							">
											Generazione PDF in corso, attendere...
										</div>
									</div>
								</div>
								<div class="p-4 hover:bg-gray-50">
									<div class="flex items-center">
										<button id="btnGenerateExcel"
											class="fas fa-file-excel text-green-600 bg-green-100 p-2 rounded-full mr-4">
										</button>
										<div class="flex-1">
											<p class="text-sm font-medium text-green-600">Esporta File Excel</p>
											<p class="text-xs text-gray-500">Esporta un file excel con la lista
												completa degli articoli.</p>
										</div>
									</div>
								</div>
								<% if(session.getAttribute("ruolo").equals("Amministratore") ||
									session.getAttribute("ruolo").equals("Magazziniere")){ %>
									<div class="p-4 hover:bg-gray-50">
										<div class="flex items-center">
											<button id="btnRefreshImages"
												class="fas fa-images text-blue-600 bg-blue-100 p-2 rounded-full mr-4">
											</button>
											<div class="flex-1">
												<p class="text-sm font-medium text-blue-600">Refresh Immagini
												</p>
												<p class="text-xs text-gray-500">Ricalcola e aggiorna le
													immagini di tutti gli articoli dal filesystem.</p>
											</div>
										</div>
									</div>
									<div class="p-4 hover:bg-gray-50 rounded-xl border border-gray-200">
										<form action="<%=request.getContextPath()%>/impostazioni" method="post"
											enctype="multipart/form-data" id="importForm"
											class="flex items-center gap-3 flex-wrap">

											<!-- input file nascosto -->
											<input id="fileInput" name="file" type="file" accept=".txt" class="sr-only">

											<!-- bottone "scegli file" -->
											<label for="fileInput"
												class="inline-flex items-center gap-2 px-4 py-2 rounded-xl border border-gray-300 bg-white shadow-sm cursor-pointer hover:bg-gray-100">
												<i class="fa-solid fa-file-arrow-up"></i>
												<span>Scegli file .txt</span>
											</label>

											<!-- nome file selezionato -->
											<span id="fileName" class="text-sm text-gray-600 italic">
												Nessun file selezionato
											</span>

											<!-- pulsante invio -->
											<button type="submit"
												class="ml-auto px-4 py-2 rounded-xl bg-blue-600 text-white hover:bg-blue-700 disabled:opacity-50"
												disabled>
												Importa
											</button>
										</form>

										<p class="mt-2 text-xs text-gray-500">
											Importa la lista articoli dal file .txt generato da TecnoDeposit.exe
										</p>
									</div>

									<div class="p-4 hover:bg-gray-50">
										<div class="flex items-center">
											<button id="openWipeModal"
												class="fas fa-trash text-red-800 bg-red-300 p-2 rounded-full mr-4">
											</button>
											<div class="flex-1">
												<p class="text-sm font-medium text-red-800">Svuota Magazzino</p>
												<p class="text-xs text-gray-500">Elimina definitivamente la
													lista degli articoli.</p>
											</div>
										</div>
									</div>
									<% } %>






										<div id="wipeModal" class="fixed inset-0 bg-black/50 hidden z-50">
											<div class="bg-white rounded-xl w-full max-w-lg mx-auto mt-24 p-6">
												<h2 class="text-xl font-semibold text-red-700 mb-2"><i
														class="fas fa-warning"></i> Conferma distruttiva</h2>
												<p class="text-sm text-gray-600 mb-4">
													Operazione PERICOLOSA. Verranno azzerate tutte le
													giacenze.<br>
													Step 1: inserisci la password del tuo account.
												</p>

												<form id="wipeStep1" method="post"
													action="<%=request.getContextPath()%>/impostazioni">
													<input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
													<input type="hidden" name="step" value="preview">

													<div class="mb-3">
														<label class="block text-sm font-medium mb-1">Scrivi
															esattamente: <b>SVUOTA MAGAZZINO</b></label>
														<input name="phrase" class="w-full border rounded-lg px-3 py-2"
															autocomplete=off placeholder="SVUOTA MAGAZZINO" required>
													</div>

													<div class="mb-3">
														<label class="block text-sm font-medium mb-1">Password
															attuale</label>
														<input name="passwordDelete" type="password"
															class="w-full border rounded-lg px-3 py-2" autocomplete=off
															required>
													</div>

													<div class="flex items-center gap-2 text-sm mb-4">
														<input id="backupCheck" type="checkbox"
															class="h-4 w-4 border rounded" required>
														<label for="backupCheck">Confermo di aver eseguito il
															backup oggi</label>
													</div>

													<div class="flex justify-end gap-2">
														<button type="button" id="closeWipeModal"
															class="px-3 py-2 border rounded-lg">Annulla</button>
														<button
															class="px-3 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
															Invia
														</button>
													</div>
												</form>

												<div id="previewBox" class="hidden mt-6 border-t pt-4">
													<p class="text-sm text-gray-700 mb-2">Anteprima elementi
														interessati:</p>
													<pre id="previewData" class="text-xs bg-gray-50 p-3 rounded"></pre>

													<form id="wipeStep2" method="post"
														action="<%=request.getContextPath()%>/impostazioni">
														<input type="hidden" name="csrf"
															value="${sessionScope.csrfToken}">
														<input type="hidden" name="step" value="execute">
														<input type="hidden" name="challengeId" id="challengeId">

														<div class="mb-3">
															<label class="block text-sm font-medium mb-1">Token
																inviato dal Dev</label>
															<input name="otp" class="w-full border rounded-lg px-3 py-2"
																required>
														</div>

														<div class="flex justify-end gap-2">
															<button type="button" id="cancelExec"
																class="px-3 py-2 border rounded-lg">Annulla</button>
															<button
																class="px-3 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700">
																Conferma svuotamento
															</button>
														</div>
													</form>
												</div>
											</div>
										</div>
										<!--  <div class="p-4 hover:bg-gray-50">
                    <div class="flex items-center">
                        <div class="bg-yellow-100 p-2 rounded-full mr-4">
                            <i class="fas fa-exclamation-triangle text-yellow-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Zona E raggiunta capacità massima</p>
                            <p class="text-xs text-gray-500">3 ore fa</p>
                        </div>
                    </div>
                </div>-->
							</div>
							<!--  <div class="px-6 py-4 border-t border-gray-200 text-center">
                <a href="#" class="text-sm font-medium text-red-600 hover:text-red-800">Visualizza tutte le attività</a>
            </div> -->
						</div>
						<!-- Modal Backdrop -->
						<div id="modalBackdrop"
							class="fixed inset-0 bg-black bg-opacity-50 z-40 hidden animate-fade-in"></div>

						<!-- Modal Container -->
						<div id="profileModal" class="fixed inset-0 flex items-center justify-center z-50 hidden">
							<div
								class="bg-white rounded-xl shadow-2xl w-full max-w-2xl max-h-[90vh] overflow-hidden animate-slide-up">
								<!-- Modal Header -->
								<div
									class="bg-gradient-to-r from-red-600 to-gray-700 p-6 flex justify-between items-center">
									<div class="flex items-center space-x-3">
										<i class="fas fa-user-cog text-white text-2xl"></i>
										<h2 id="titolo" class="text-white text-xl font-bold">Modifica Utente
										</h2>
									</div>
									<button id="closeModalBtn" class="text-white hover:text-gray-200 transition-colors">
										<i class="fas fa-times text-xl"></i>
									</button>
								</div>

								<!-- Modal Content -->
								<div class="custom-scrollbar overflow-y-auto p-6"
									style="max-height: calc(90vh - 120px)">
									<!-- Profile Picture Section -->
									<div class="mb-8">
										<div class="flex flex-col items-center">
											<div
												class="w-32 h-32 rounded-full bg-gray-200 border-4 border-white shadow-lg flex items-center justify-center">
												<i class="fas fa-user text-6xl text-gray-600"></i>
											</div>

										</div>
									</div>

									<!-- Form Section -->
									<form id="profileForm" class="space-y-6" method="post" action="impostazioni">
										<input type="hidden" name="id" id="userId">
										<input type="hidden" name="action" id="formAction" value="add">
										<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
											<!-- Ruolo -->
											<div>
												<label for="ruolo"
													class="block text-sm font-medium text-gray-700 mb-1">Ruolo</label>
												<div class="relative">
													<div
														class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
														<i class="fas fa-tag text-gray-400"></i>
													</div>
													<select id="role" name="ruolo"
														class="pl-10 w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500 shadow-sm"
														required>
														<option value="Tecnico">Tecnico</option>
														<option value="Amministratore">Amministratore</option>
														<option value="Magazziniere">Magazziniere</option>
													</select>

												</div>
											</div>
											<!-- First Name -->
											<div>
												<label for="username"
													class="block text-sm font-medium text-gray-700 mb-1">Username</label>
												<div class="relative">
													<div
														class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
														<i class="fas fa-user text-gray-400"></i>
													</div>
													<input type="text" id="username" name="username"
														class="pl-10 w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500 shadow-sm">
												</div>
											</div>

											<div>
												<label for="nome"
													class="block text-sm font-medium text-gray-700 mb-1">Nome</label>
												<div class="relative">
													<div
														class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
														<i class="fas fa-id-card text-gray-400"></i>
													</div>
													<input type="text" id="nome" name="nome"
														class="pl-10 w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500 shadow-sm">
												</div>
											</div>
											<div>
												<label for="cognome"
													class="block text-sm font-medium text-gray-700 mb-1">Cognome</label>
												<div class="relative">
													<div
														class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
														<i class="fas fa-signature text-gray-400"></i>
													</div>
													<input type="text" id="cognome" name="cognome"
														class="pl-10 w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500 shadow-sm">
												</div>
											</div>
											<!-- Email -->
											<div>
												<label for="email"
													class="block text-sm font-medium text-gray-700 mb-1">Email</label>
												<div class="relative">
													<div
														class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
														<i class="fas fa-envelope text-gray-400"></i>
													</div>
													<input type="email" id="email" name="mail"
														class="pl-10 w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500 shadow-sm">
												</div>
											</div>
											<!-- PASS -->
											<div>
												<label for="password"
													class="block text-sm font-medium text-gray-700 mb-1">Password</label>
												<div class="relative">
													<div
														class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
														<i class="fas fa-lock text-gray-400"></i>
													</div>
													<input type="text" id="password" name="password"
														class="pl-10 w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500 shadow-sm">
												</div>
											</div>
										</div>



										<!-- Phone -->
										<div>
											<label for="phone"
												class="block text-sm font-medium text-gray-700 mb-1">Numero di
												telefono</label>
											<div class="relative">
												<div
													class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
													<i class="fas fa-phone text-gray-400"></i>
												</div>
												<input type="tel" id="phone" name="telefono"
													class="pl-10 w-full rounded-lg border-gray-300 focus:border-blue-500 focus:ring-blue-500 shadow-sm">
											</div>
										</div>

									</form>
								</div>

								<!-- Modal Footer -->
								<div
									class="bg-gray-50 px-6 py-4 flex flex-col sm:flex-row justify-between items-center border-t border-gray-200">
									<button id="deleteAccountBtn"
										class="text-red-600 hover:text-red-800 font-medium text-sm mb-3 sm:mb-0">
										<i class="fas fa-trash-alt mr-1"></i> Cancella Utente
									</button>
									<div class="space-x-3">
										<button id="cancelBtn"
											class="px-4 py-2 border border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-100 transition-colors">
											Annulla
										</button>
										<button id="saveBtn" type="submit"
											class="px-6 py-2 bg-red-600 text-white font-medium rounded-lg hover:bg-red-700 transition-colors shadow-md">
											<i class="fas fa-save mr-2"></i>Salva
										</button>
									</div>
								</div>
							</div>
						</div>

						<!-- DELETE MODAL -->
						<div id="deleteModal"
							class="modal fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
							<div class="bg-white rounded-lg shadow-xl w-full max-w-md fade-in">
								<div class="p-6">
									<div class="flex items-center justify-center mb-4">
										<div class="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center">
											<i class="fas fa-exclamation-triangle text-red-600 text-xl"></i>
										</div>
									</div>
									<h3 class="text-lg font-semibold text-center mb-2">Conferma eliminazione
									</h3>
									<p class="text-gray-600 text-center mb-6">Sei sicuro di voler eliminare
										questo utente? Questa azione non può essere annullata.</p>
									<div class="flex justify-center space-x-4">
										<button id="cancel-delete"
											class=" px-4 py-2 border rounded-lg hover:bg-gray-100">
											Annulla
										</button>
										<button id="confirm-delete"
											class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg"
											name="delete">
											Elimina
										</button>
									</div>
								</div>
							</div>
						</div>
						<img id="qrLogo" src="img/IconBN.png" style="display:none;" />


				</body>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

				<script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js"></script>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
				<script src="scripts/labelUtils.js"></script>
				<script src="scripts/impostazioniScript.js"></script>



				<script>
					let currentUserId = null;
					const ruoloUtente = "<%= ruoloUtenteLoggato %>";
					//VIEW IN BASE ALL'UTENTE
					document.addEventListener('DOMContentLoaded', function () {
						if (ruoloUtente === "Tecnico" || ruoloUtente === "Magazziniere") {
							//PULSANTE ADD
							addUser.style.display = 'none';
						}
					});
					const addUser = document.getElementById('addUserBtn');
					const editUser = document.querySelectorAll('.editUser');
					const deleteUser = document.getElementById('deleteAccountBtn');
					const viewUser = document.querySelectorAll('.viewUser');
					const modal = document.getElementById('profileModal');

					const closeModalBtn = document.getElementById('closeModalBtn');
					const cancelBtn = document.getElementById('cancelBtn');
					const cancelDeleteBtn = document.getElementById('cancel-delete');
					const confirmDeleteBtn = document.getElementById('confirm-delete');
					//SAVE
					document.getElementById("saveBtn").addEventListener("click", function (e) {
						e.preventDefault(); // se è dentro un form, impedisce l'invio automatico
						let valid = true;
						let messages = [];

						const username = document.getElementById("username").value.trim();
						const nome = document.getElementById("nome").value.trim();
						const cognome = document.getElementById("cognome").value.trim();
						const email = document.getElementById("email").value.trim();
						const password = document.getElementById("password").value.trim();

						// Username
						if (username === "") {
							valid = false;
							messages.push("⚠️ Il campo Username è obbligatorio");
						}

						// Nome
						if (nome === "") {
							valid = false;
							messages.push("⚠️ Il campo Nome è obbligatorio");
						}

						// Cognome
						if (cognome === "") {
							valid = false;
							messages.push("⚠️ Il campo Cognome è obbligatorio");
						}

						// Email
						if (email === "") {
							valid = false;
							messages.push("⚠️ Il campo Email è obbligatorio");
						} else {
							// Regex semplice per email valida
							const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
							if (!emailRegex.test(email)) {
								valid = false;
								messages.push("⚠️ Inserisci un'email valida");
							}
						}

						// Password
						if (password === "" && document.getElementById('titolo').textContent === 'Aggiungi Nuovo Utente') {
							valid = false;
							messages.push("⚠️ Il campo Password è obbligatorio");
						}

						// Se ci sono errori → blocca invio e mostra alert
						if (!valid) {
							e.preventDefault();
							alert(messages.join("\n"));
						} else document.getElementById('profileForm').submit();
					});


					//CHIUSURA MODALE
					function closeModal() {
						modalBackdrop.classList.add('hidden');
						profileModal.classList.add('hidden');
						document.body.style.overflow = 'auto';
						currentUserId = null;
					}
					//ADD
					addUser.addEventListener('click', function () {
						console.log("CLICCATO ADD")
						modal.scrollTop = 0;
						document.getElementById('profileForm').reset();
						modal.classList.remove('hidden');
						modalBackdrop.classList.remove('hidden');
						document.getElementById('formAction').value = 'add';
						deleteUser.classList.add('hidden');
						document.getElementById('titolo').textContent = "Aggiungi Nuovo Utente";

					});

					//DELETE ZONE
					deleteUser.addEventListener('click', function () {
						console.log("CLICCATO DELETE")

						if (!currentUserId) {
							console.error("ID utente non definito.");
							return;
						}

						modal.scrollTop = 0;
						document.getElementById('deleteModal').classList.remove('hidden');
						console.log("PRESO ID: " + currentUserId);
						confirmDeleteBtn.dataset.id = currentUserId;
					});

					cancelDeleteBtn.addEventListener('click', function () {
						deleteModal.classList.add('hidden');
					});

					confirmDeleteBtn.addEventListener('click', function () {
						closeModal();
						deleteModal.classList.add('hidden');
						document.getElementById('formAction').value = 'delete';
						const id = this.dataset.id; // Prende l'id salvato prima
						document.getElementById('userId').value = id;
						console.log("PRESO ID: " + id);


						document.getElementById('profileForm').submit();

					});

					//CHIUSURA MODALE
					closeModalBtn.addEventListener('click', closeModal);
					cancelBtn.addEventListener('click', closeModal);
					modalBackdrop.addEventListener('click', closeModal);

					//EDIT
					editUser.forEach(button => {
						button.addEventListener('click', function () {
							document.getElementById('formAction').value = 'update';
							deleteUser.classList.remove('hidden');
							modalBackdrop.classList.remove('hidden');
							profileModal.classList.remove('hidden');
							document.body.style.overflow = 'auto';
							document.getElementById('titolo').textContent = "Modifica Utente";

							// Reset readOnly/disabled da eventuale view precedente
							document.getElementById('username').readOnly = false;
							document.getElementById('email').readOnly = false;
							document.getElementById('phone').readOnly = false;
							document.getElementById('password').readOnly = false;
							document.getElementById('nome').readOnly = false;
							document.getElementById('cognome').readOnly = false;
							document.getElementById('role').disabled = false;
							// Ripristina pulsanti nascosti dal view
							document.getElementById('saveBtn').classList.remove('hidden');
							document.getElementById('cancelBtn').classList.remove('hidden');

							const card = button.closest('.userCard');

							const id = card.dataset.id;
							const username = card.dataset.username;
							const nome = card.dataset.nome;
							const cognome = card.dataset.cognome;
							const mail = card.dataset.mail;
							const ruolo = card.dataset.ruolo;
							const telefono = card.dataset.telefono;
							document.getElementById("role").value = ruolo;
							const stato = card.dataset.stato;
							console.log(username);
							document.getElementById('userId').value = id;
							currentUserId = id;
							if (ruoloUtente === "Tecnico") {
								document.getElementById('password').readOnly = true;
								document.getElementById('role').disabled = true;
								// Assicura che il ruolo venga inviato anche con select disabled
								let hiddenRuolo = document.getElementById('hiddenRuolo');
								if (!hiddenRuolo) {
									hiddenRuolo = document.createElement('input');
									hiddenRuolo.type = 'hidden';
									hiddenRuolo.name = 'ruolo';
									hiddenRuolo.id = 'hiddenRuolo';
									document.getElementById('profileForm').appendChild(hiddenRuolo);
								}
								hiddenRuolo.value = ruolo;
							} else {
								// Admin: rimuovi hidden ruolo se presente (il select funziona)
								const oldHidden = document.getElementById('hiddenRuolo');
								if (oldHidden) oldHidden.remove();
							}
							document.getElementById('username').value = username;
							document.getElementById('nome').value = nome;
							document.getElementById('cognome').value = cognome;
							document.getElementById('email').value = mail;

							document.getElementById('phone').value = telefono;

						});
					});

					//IMPORT
					(() => {
						const form = document.getElementById('importForm');
						const input = document.getElementById('fileInput');
						const nameEl = document.getElementById('fileName');
						const submitBtn = form.querySelector('button[type="submit"]');
						if (!form || !input || !submitBtn) {
							console.error('IMPORT: elementi non trovati', { form, input, submitBtn });
							return;
						}
						// (opzionale) attiva drag&drop sulla card
						const card = form.closest('div');
						['dragover', 'dragenter'].forEach(ev => card.addEventListener(ev, e => {
							e.preventDefault(); card.classList.add('ring-2', 'ring-blue-500');
						}));
						['dragleave', 'drop'].forEach(ev => card.addEventListener(ev, e => {
							e.preventDefault(); card.classList.remove('ring-2', 'ring-blue-500');
						}));
						card.addEventListener('drop', e => {
							if (e.dataTransfer.files?.length) {
								input.files = e.dataTransfer.files;
								input.dispatchEvent(new Event('change', { bubbles: true }));
							}
						});

						input.addEventListener('change', () => {
							const f = input.files[0];
							console.log('IMPORT change fired:', f ? { name: f.name, size: f.size } : 'no file');

							if (!f) { nameEl.textContent = 'Nessun file selezionato'; submitBtn.disabled = true; return; }

							// vincolo: solo .txt e max 5MB (regola se vuoi)
							if (!/\.txt$/i.test(f.name)) { alert('Seleziona un file .txt'); input.value = ''; nameEl.textContent = 'Formato non valido'; submitBtn.disabled = true; return; }
							if (f.size > 100 * 1024 * 1024) { alert('File troppo grande (max 100MB)'); input.value = ''; nameEl.textContent = 'File troppo grande'; submitBtn.disabled = true; return; }

							nameEl.textContent = f.name + `(` + Math.round(f.size / 1024) + `KB)`;
							submitBtn.disabled = false;

							// (se vuoi invio automatico appena scelto)
							// form.submit();
						});
					})();

					//SVUOTAMAGAZZINO
					const $modal = document.getElementById('wipeModal');
					document.getElementById('openWipeModal')?.addEventListener('click', () => $modal.classList.remove('hidden'));
					document.getElementById('closeWipeModal')?.addEventListener('click', () => $modal.classList.add('hidden'));
					document.getElementById('cancelExec')?.addEventListener('click', () => $modal.classList.add('hidden'));

					// Intercetta Step1 per fare anteprima via fetch (Ajax opzionale)
					document.getElementById('wipeStep1')?.addEventListener('submit', async (e) => {
						e.preventDefault();
						const form = new FormData(e.target);
						const res = await fetch(e.target.action, { method: 'POST', body: form });
						if (!res.ok) { alert('Controlla i campi e riprova'); return; }
						const data = await res.json(); // {challengeId, totaleArticoli, totalePezzi, dettagli:[...]}
						document.getElementById('challengeId').value = data.challengeId;
						document.getElementById('previewData').textContent =
							"Pezzi Totali: " + data.totalePezzi +
							"\nArticoli coinvolti: " + data.totaleArticoli;

						document.getElementById('previewBox').classList.remove('hidden');
					});

					//VIEW
					viewUser.forEach(button => {
						button.addEventListener('click', function () {

							modalBackdrop.classList.remove('hidden');
							profileModal.classList.remove('hidden');
							document.body.style.overflow = 'auto';
							deleteAccountBtn.classList.add('hidden');
							cancelBtn.classList.add('hidden');
							saveBtn.classList.add('hidden');
							titolo.textContent = 'Visualizza Utente';

							const card = button.closest('.userCard');

							const id = card.dataset.id;
							const username = card.dataset.username;
							const mail = card.dataset.mail;
							const nome = card.dataset.nome;
							const cognome = card.dataset.cognome;
							const ruolo = card.dataset.ruolo;
							document.getElementById("role").value = ruolo;
							const stato = card.dataset.stato;
							const telefono = card.dataset.telefono;
							console.log(username);

							document.getElementById('role').disabled = true;
							document.getElementById('username').readOnly = true;
							document.getElementById('email').readOnly = true;
							document.getElementById('phone').readOnly = true;
							document.getElementById('password').readOnly = true;
							document.getElementById('nome').readOnly = true;
							document.getElementById('cognome').readOnly = true;

							document.getElementById('username').value = username;
							document.getElementById('nome').value = nome;
							document.getElementById('cognome').value = cognome;
							//document.getElementById('password').textContent  = "Matricola: "+ matricola;
							document.getElementById('email').value = mail;
							document.getElementById('phone').value = telefono;

						});
					});


					//EXCEL — carica dati on-demand via fetch
					document.getElementById("btnGenerateExcel").addEventListener("click", async () => {
						document.getElementById('loadingOverlay').style.display = 'block';
						document.getElementById("loadingOverlay").innerHTML = "Caricamento dati per Excel...";
						try {
							const resp = await fetch('<%= request.getContextPath() %>/impostazioni?action=exportData&type=excel');
							const articoli = await resp.json();

							document.getElementById("loadingOverlay").innerHTML = "Generando file excel attendere...";

							const header = ["NOME", "MATRICOLA", "PROVENIENZA", "CENTRO REVISIONE", "RICHIESTA GARANZIA", "DATA SPEDIZIONE", "DDT SPEDIZIONE", "DATA RIENTRO", "DDT RIENTRO", "NOTE"];

							const data = articoli.map(a => [
								a.nome, a.matricola, a.provenienza, a.centroRevisione,
								a.garanzia, a.dataSpedizione, a.ddtSpedizione,
								a.dataRientro, a.ddtRientro, a.note
							]);

							const wsData = [header, ...data];
							const ws = XLSX.utils.aoa_to_sheet(wsData);

							// Grassetto + centratura per intestazioni
							header.forEach((_, colIdx) => {
								const cell = ws[XLSX.utils.encode_cell({ c: colIdx, r: 0 })];
								if (cell) {
									cell.s = {
										font: { bold: true },
										alignment: { horizontal: "center" }
									};
								}
							});

							ws['!cols'] = [
								{ wch: 30 }, { wch: 20 }, { wch: 20 }, { wch: 25 },
								{ wch: 15 }, { wch: 18 }, { wch: 18 }, { wch: 18 },
								{ wch: 18 }, { wch: 60 }
							];

							const wb = XLSX.utils.book_new();
							XLSX.utils.book_append_sheet(wb, ws, "Articoli");
							XLSX.writeFile(wb, "articoli_magazzino.xlsx");
						} catch (e) {
							alert('Errore caricamento dati: ' + e.message);
						} finally {
							document.getElementById('loadingOverlay').style.display = 'none';
						}
					});

					//GENERAZIONE ETICHETTE — carica dati on-demand via fetch
					const { jsPDF } = window.jspdf;

					document.getElementById('btnGeneratePdf').addEventListener('click', async () => {
						document.getElementById('loadingOverlay').style.display = 'block';
						document.getElementById("loadingOverlay").innerHTML = "Caricamento dati etichette...";

						try {
							const resp = await fetch('<%= request.getContextPath() %>/impostazioni?action=exportData&type=labels');
							const dati = await resp.json();

							const pdf = new jsPDF({
								unit: 'mm',
								format: 'a4',
							});

							const pageWidth = pdf.internal.pageSize.getWidth();
							const pageHeight = pdf.internal.pageSize.getHeight();

							const labelW = 64;
							const labelH = 25;
							const margin = 5;
							const gapX = 3;
							const gapY = 3;
							const cols = Math.floor((pageWidth - margin * 2 + gapX) / (labelW + gapX));

							const logoImg = document.getElementById('qrLogo');

							let x = margin;
							let y = margin;

							for (let i = 0; i < dati.length; i++) {
								const item = dati[i];
								document.getElementById("loadingOverlay").innerHTML = "Generando pdf per<br>" + item.nome + "<br>" + (i + 1) + "/" + dati.length + "<br>attendere...";

								await renderLabelPDF(pdf, x, y, item, logoImg);

								if ((i + 1) % cols === 0) {
									x = margin;
									y += labelH + gapY;
									if (y + labelH > pageHeight - margin) {
										pdf.addPage();
										y = margin;
									}
								} else {
									x += labelW + gapX;
								}
							}

							pdf.save('etichette_qr_tecnodeposit.pdf');
						} catch (e) {
							alert('Errore caricamento dati: ' + e.message);
						} finally {
							document.getElementById('loadingOverlay').style.display = 'none';
						}
					});

					//REFRESH IMMAGINI
					document.getElementById('btnRefreshImages').addEventListener('click', async () => {
						document.getElementById('loadingOverlay').style.display = 'block';
						document.getElementById('loadingOverlay').innerHTML = 'Aggiornamento immagini in corso...<br>Attendere.';
						try {
							const resp = await fetch('<%= request.getContextPath() %>/api/refresh-images');
							const data = await resp.json();
							document.getElementById('loadingOverlay').style.display = 'none';
							if (data.success) {
								showToast('Aggiornate ' + data.updated + ' immagini su ' + data.total + ' articoli.', 'success');
							} else {
								showToast('Errore: ' + (data.error || 'sconosciuto'), 'error');
							}
						} catch (e) {
							document.getElementById('loadingOverlay').style.display = 'none';
							showToast('Errore di rete: ' + e.message, 'error');
						}
					});

					// Toast helper
					function showToast(msg, type) {
						const toast = document.createElement('div');
						toast.className = 'fixed top-4 right-4 z-[9999] px-6 py-3 rounded-xl shadow-lg text-white text-sm font-medium transition-all duration-500 ' +
							(type === 'success' ? 'bg-green-600' : 'bg-red-600');
						toast.textContent = msg;
						document.body.appendChild(toast);
						setTimeout(() => { toast.style.opacity = '0'; setTimeout(() => toast.remove(), 500); }, 4000);
					}

					// ═══════════════════════════════════════════
					// PAGINAZIONE TABELLA UTENTI
					// ═══════════════════════════════════════════
					(() => {
						const USERS_PER_PAGE = 10;
						const tbody = document.querySelector('.user-table tbody');
						const paginationEl = document.getElementById('userPagination');
						if (!tbody || !paginationEl) return;

						const allRows = Array.from(tbody.querySelectorAll('tr'));
						const totalPages = Math.ceil(allRows.length / USERS_PER_PAGE);
						let currentPage = 1;

						// Se ci sono pochi utenti, non servono i controlli
						if (totalPages <= 1) { paginationEl.style.display = 'none'; return; }

						function showPage(page) {
							currentPage = page;
							const start = (page - 1) * USERS_PER_PAGE;
							const end = start + USERS_PER_PAGE;

							allRows.forEach((row, i) => {
								row.style.display = (i >= start && i < end) ? '' : 'none';
							});

							renderPagination();
						}

						function renderPagination() {
							let html = '';
							html += '<button ' + (currentPage === 1 ? 'disabled' : '') + ' data-page="' + (currentPage - 1) + '"><i class="fas fa-chevron-left"></i></button>';

							for (let p = 1; p <= totalPages; p++) {
								if (totalPages > 7 && Math.abs(p - currentPage) > 2 && p !== 1 && p !== totalPages) {
									if (p === 2 || p === totalPages - 1) html += '<span class="page-info">...</span>';
									continue;
								}
								html += '<button class="' + (p === currentPage ? 'active' : '') + '" data-page="' + p + '">' + p + '</button>';
							}

							html += '<button ' + (currentPage === totalPages ? 'disabled' : '') + ' data-page="' + (currentPage + 1) + '"><i class="fas fa-chevron-right"></i></button>';
							html += '<span class="page-info">' + allRows.length + ' utenti</span>';

							paginationEl.innerHTML = html;

							paginationEl.querySelectorAll('button[data-page]').forEach(btn => {
								btn.addEventListener('click', () => showPage(parseInt(btn.dataset.page)));
							});
						}

						showPage(1);
					})();

				</script>
				</div>

				</html>