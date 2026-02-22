<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <%@ page import="java.util.List" %>
            <%@ page import="model.Articolo" %>
                <%@ page import="model.ListaArticoli" %>
                    <style>
                        @media print {
                            .no-print {
                                display: none !important;
                            }
                        }
                    </style>
                    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
                    <script src="scripts/labelUtils.js"></script>
                    <script src="scripts/risultati.js"></script>

                    <% List<Articolo> articoli = (List<Articolo>) request.getAttribute("articoli");
                            if (articoli != null && !articoli.isEmpty()) {
                            %>
                            <% for (int i=0; i < articoli.size(); i++) { Articolo a=articoli.get(i); %>
                                <div data-id="<%= a.getId() %>"
                                    class="article-card bg-white rounded-2xl shadow-md hover:shadow-2xl overflow-hidden transition-all duration-300 w-full max-w-sm flex flex-col justify-between h-full hover:-translate-y-1 border border-gray-100"
                                    onclick="apriDettagli(event)" data-nome="<%= a.getNome() %>"
                                    data-matricola="<%= a.getMatricola() %>" data-marca="<%= a.getMarca() %>"
                                    data-compatibilita="<%= a.getCompatibilita() %>" data-ddt="<%= a.getDdt() %>"
                                    data-ddt-spedizione="<%= a.getDdtSpedizione() %>"
                                    data-tecnico="<%= a.getTecnico() %>" data-pv="<%= a.getPv() %>"
                                    data-provenienza="<%= a.getProvenienza() %>"
                                    data-fornitore="<%= a.getFornitore() %>" data-dataric="<%= a.getDataRic_DDT() %>"
                                    data-dataspe="<%= a.getDataSpe_DDT() %>" data-datagar="<%= a.getDataGaranzia() %>"
                                    data-note="<%= a.getNote() %>" data-stato="<%= a.getStato() %>"
                                    data-immagine="<%= a.getImmagine() %>"
                                    data-richiesta-garanzia="<%= a.getRichiestaGaranzia() %>">
                                    <div class="relative group">
                                        <img loading="lazy"
                                            src="<%= (a.getImmagine() != null && !a.getImmagine().isEmpty()) && !a.getImmagine().equals("null") ? a.getImmagine() : "img/Icon.png" %> " alt="Articolo" class="w-full
                                        aspect-[4/3] object-cover transition-transform duration-300
                                        group-hover:scale-105" >
                                        <div
                                            class="absolute inset-0 bg-gradient-to-t from-black/40 via-transparent to-transparent">
                                        </div>
                                        <% String stato=a.getStato().toString(); String statoCss="status-" +
                                            stato.toLowerCase().replace(" ", " -").replace("à", "a" ); %>
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
                                            <div class="flex gap-1 ml-2">
                                                <button title="Storico modifiche" aria-label="Storico modifiche"
                                                    onclick="event.stopPropagation(); caricaStoricoArticolo(<%=a.getId() %>)"
                                                    class="w-8 h-8 flex items-center justify-center rounded-full bg-gray-100 hover:bg-red-100 text-gray-500 hover:text-red-600 transition-colors"><i
                                                        class="fas fa-history text-sm"></i></button>
                                                <button title="Etichetta QR" aria-label="Etichetta QR"
                                                    class="openQrModal w-8 h-8 flex items-center justify-center rounded-full bg-gray-100 hover:bg-red-100 text-gray-500 hover:text-red-600 transition-colors"><i
                                                        class="fas fa-qrcode text-sm"></i></button>
                                            </div>
                                        </div>
                                        <div class="space-y-2 text-sm">
                                            <div
                                                class="flex justify-between items-center py-1 border-b border-gray-100">
                                                <span class="text-gray-500 flex items-center gap-2"><i
                                                        class="fas fa-location-arrow text-xs text-gray-400"></i>Provenienza</span>
                                                <span class="font-medium text-gray-700 truncate max-w-[120px]">
                                                    <%= a.getProvenienza() %>
                                                </span>
                                            </div>
                                            <div
                                                class="flex justify-between items-center py-1 border-b border-gray-100">
                                                <span class="text-gray-500 flex items-center gap-2"><i
                                                        class="fas fa-tools text-xs text-gray-400"></i>Centro
                                                    Revisione</span>
                                                <span class="font-medium text-gray-700 truncate max-w-[120px]">
                                                    <%= a.getFornitore() %>
                                                </span>
                                            </div>
                                            <div class="flex justify-between items-center py-1">
                                                <span class="text-gray-500 flex items-center gap-2"><i
                                                        class="fas fa-user text-xs text-gray-400"></i>Tecnico</span>
                                                <span class="font-medium text-gray-700 truncate max-w-[120px]">
                                                    <%= a.getTecnico() %>
                                                </span>
                                            </div>
                                        </div>
                                        <div class="mt-4 flex gap-2">
                                            <button
                                                class="edit-btn flex-1 bg-gradient-to-r from-blue-500 to-blue-600 text-white hover:from-blue-600 hover:to-blue-700 px-3 py-2 rounded-xl text-sm font-medium flex items-center justify-center shadow-sm hover:shadow-md transition-all"
                                                data-id="${articolo.id}">
                                                <i class="fas fa-edit mr-1.5"></i> Modifica
                                            </button>
                                            <% if(session.getAttribute("ruolo").equals("Tecnico")){ %>
                                                <button id="assegnaInput" type="submit" name="assegnaAction"
                                                    value="assegna" form="article-form"
                                                    class="assegnaButton flex-1 bg-gradient-to-r from-gray-500 to-gray-600 text-white hover:from-gray-600 hover:to-gray-700 px-3 py-2 rounded-xl text-sm font-medium flex items-center justify-center shadow-sm hover:shadow-md transition-all"
                                                    data-id="${articolo.id}">
                                                    <i class="fas fa-dolly mr-1.5"></i> Assegna
                                                </button>
                                                <% } %>
                                                    <button
                                                        class="delete-btn flex-1 bg-gradient-to-r from-red-500 to-red-600 text-white hover:from-red-600 hover:to-red-700 px-3 py-2 rounded-xl text-sm font-medium flex items-center justify-center shadow-sm hover:shadow-md transition-all"
                                                        data-id="${articolo.id}">
                                                        <i class="fas fa-trash-alt mr-1.5"></i> Elimina
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
                                    Ctotale.textContent = <%=request.getAttribute("TotaleArticoli") %>;
                                    Ctotale.parentElement.style.display = (Ctotale.textContent == 0) ? "none" : "flex";

                                    CinAttesa.textContent = <%=request.getAttribute("countInattesa") %>;
                                    CinAttesa.parentElement.style.display = (CinAttesa.textContent == 0) ? "none" : "flex";

                                    CinMagazzino.textContent = <%=request.getAttribute("countInmagazzino") %>;
                                    CinMagazzino.parentElement.style.display = (CinMagazzino.textContent == 0) ? "none" : "flex";

                                    Cinstallato.textContent = <%=request.getAttribute("countInstallato") %>;
                                    Cinstallato.parentElement.style.display = (Cinstallato.textContent == 0) ? "none" : "flex";

                                    Cdestinato.textContent = <%=request.getAttribute("countDestinato") %>;
                                    Cdestinato.parentElement.style.display = (Cdestinato.textContent == 0) ? "none" : "flex";

                                    Cassegnato.textContent = <%=request.getAttribute("countAssegnato") %>;
                                    Cassegnato.parentElement.style.display = (Cassegnato.textContent == 0) ? "none" : "flex";

                                    Cguasto.textContent = <%=request.getAttribute("countGuasto") %>;
                                    Cguasto.parentElement.style.display = (Cguasto.textContent == 0) ? "none" : "flex";

                                    Criparato.textContent = <%=request.getAttribute("countRiparato") %>;
                                    Criparato.parentElement.style.display = (Criparato.textContent == 0) ? "none" : "flex";

                                    CnonRiparato.textContent = <%=request.getAttribute("countNonRiparato") %>;
                                    CnonRiparato.parentElement.style.display = (CnonRiparato.textContent == 0) ? "none" : "flex";

                                    CnonRiparabile.textContent = <%=request.getAttribute("countNonRiparabile") %>;
                                    CnonRiparabile.parentElement.style.display = (CnonRiparabile.textContent == 0) ? "none" : "flex";
                                </script>
                                <% } %>

                                    <% } else { %>
                                        <p>Nessun articolo trovato.</p>
                                        <% } %>
                                            <!-- Modale Etichetta QR -->
                                            <div id="qrModal"
                                                class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
                                                <div class="bg-white rounded-xl p-5 relative shadow-2xl"
                                                    style="max-width: 420px; width: 95%;">
                                                    <button id="closeQrModal"
                                                        class="no-print absolute top-2 right-3 text-gray-500 hover:text-black text-xl">&times;</button>
                                                    <h2 class="no-print text-lg font-semibold mb-4">Anteprima Etichetta
                                                    </h2>
                                                    <div class="flex justify-center">
                                                        <canvas id="labelCanvas"
                                                            style="width: 100%; max-width: 380px; border: 1px solid #e5e7eb; border-radius: 8px;"></canvas>
                                                    </div>
                                                    <img id="qrLogo" src="img/IconBN.png" style="display:none;" />
                                                    <div class="flex justify-center gap-4 mt-4">
                                                        <button id="btnScaricaLabel"
                                                            class="no-print px-4 py-2 text-sm font-medium text-red-600 hover:text-red-800 transition-colors"><i
                                                                class="fas fa-download"></i> Scarica PNG</button>
                                                        <button id="btnStampaLabel"
                                                            class="no-print px-4 py-2 text-sm font-medium text-red-600 hover:text-red-800 transition-colors"><i
                                                                class="fas fa-print"></i> Stampa</button>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- MODALE STORICO ARTICOLO -->
                                            <!-- Modale storico movimenti -->
                                            <div id="historyModal" class="fixed inset-0 z-50 hidden overflow-y-auto">
                                                <div
                                                    class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                                                    <!-- Sfondo -->
                                                    <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                                                        <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
                                                    </div>

                                                    <!-- Contenuto del modale -->
                                                    <div
                                                        class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-2xl sm:w-full">
                                                        <!-- Header -->
                                                        <div
                                                            class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:items-center sm:justify-between border-b border-gray-200">
                                                            <h3 class="text-lg leading-6 font-medium text-gray-900">
                                                                <i class="fas fa-history mr-2 text-red-600"></i> Storico
                                                                Modifiche Articolo
                                                            </h3>
                                                            <button onclick="closeModalStorico()"
                                                                class="text-gray-400 hover:text-gray-500 focus:outline-none">
                                                                <i class="fas fa-times text-xl"></i>
                                                            </button>
                                                        </div>

                                                        <!-- Corpo dinamico -->
                                                        <div id="modalContentAreaStorico" class="px-4 pt-5 pb-4 sm:p-6">
                                                            <div class="text-sm text-gray-500">Caricamento in corso...
                                                            </div>
                                                        </div>

                                                        <!-- Footer -->
                                                        <div
                                                            class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse border-t border-gray-200">
                                                            <button type="button" onclick="closeModalStorico()"
                                                                class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none sm:ml-3 sm:w-auto sm:text-sm">
                                                                Chiudi
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- ARTICOLO DETTAGLI MODALE -->
                                            <div id="articleModal"
                                                class="modal fixed inset-0 z-50 flex items-center justify-center hidden">
                                                <div
                                                    class="modal-overlay absolute inset-0 bg-black/60 backdrop-blur-sm">
                                                </div>

                                                <div
                                                    class="modal-container bg-white w-11/12 md:max-w-2xl mx-auto rounded-2xl shadow-2xl z-50 max-h-[90vh] flex flex-col overflow-hidden">
                                                    <!-- Header -->
                                                    <div
                                                        class="modal-header flex justify-between items-center px-6 py-4 bg-gradient-to-r from-red-500 to-red-600">
                                                        <h3
                                                            class="text-xl font-bold text-white flex items-center gap-2">
                                                            <i class="fas fa-box-open"></i> Dettagli Articolo
                                                        </h3>
                                                        <button onclick="closeModal()"
                                                            class="w-8 h-8 flex items-center justify-center rounded-full bg-white/20 hover:bg-white/30 text-white transition-colors">
                                                            <i class="fas fa-times"></i>
                                                        </button>
                                                    </div>

                                                    <!-- Body -->
                                                    <div id="bodyDettagli"
                                                        class="modal-body p-6 overflow-y-auto flex-1 bg-gray-50">
                                                        <div class="flex flex-col gap-5">
                                                            <!-- Immagine con badge stato -->
                                                            <div
                                                                class="relative rounded-xl overflow-hidden shadow-lg bg-white">
                                                                <img id="immagineDettagli" src="img/Icon.png"
                                                                    alt="Articolo"
                                                                    class="w-full max-h-64 object-contain bg-gray-100">
                                                                <span id="statoDettagli"
                                                                    class="status-badge absolute top-3 right-3 backdrop-blur-md bg-white/90 px-4 py-1.5 rounded-full text-sm font-bold shadow-lg border border-white/50"></span>
                                                            </div>

                                                            <!-- Nome e Matricola -->
                                                            <div class="bg-white rounded-xl p-4 shadow-sm">
                                                                <h2 id="nomeDettagli"
                                                                    class="text-2xl font-bold text-gray-800 mb-1"></h2>
                                                                <p id="matricolaDettagli"
                                                                    class="text-sm text-gray-500 font-mono bg-gray-100 inline-block px-3 py-1 rounded-lg">
                                                                </p>
                                                            </div>

                                                            <!-- Card Info Prodotto -->
                                                            <div class="bg-white rounded-xl p-4 shadow-sm">
                                                                <h4
                                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wide mb-3 flex items-center gap-2">
                                                                    <i class="fas fa-info-circle text-blue-500"></i>
                                                                    Informazioni Prodotto
                                                                </h4>
                                                                <div class="grid grid-cols-2 gap-3">
                                                                    <div class="flex flex-col">
                                                                        <span class="text-xs text-gray-400">Marca</span>
                                                                        <span id="marcaDettagli"
                                                                            class="font-semibold text-blue-600"></span>
                                                                    </div>
                                                                    <div class="flex flex-col">
                                                                        <span
                                                                            class="text-xs text-gray-400">Compatibilità</span>
                                                                        <span id="compatibilitaDettagli"
                                                                            class="font-semibold text-green-600"></span>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Card Assegnazione -->
                                                            <div class="bg-white rounded-xl p-4 shadow-sm">
                                                                <h4
                                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wide mb-3 flex items-center gap-2">
                                                                    <i class="fas fa-users text-purple-500"></i>
                                                                    Assegnazione
                                                                </h4>
                                                                <div class="space-y-2">
                                                                    <div
                                                                        class="flex justify-between items-center py-2 border-b border-gray-100">
                                                                        <span
                                                                            class="text-gray-500 text-sm flex items-center gap-2"><i
                                                                                class="fas fa-user-cog text-purple-400"></i>
                                                                            Tecnico</span>
                                                                        <span id="tecnicoDettagli"
                                                                            class="font-medium text-gray-700"></span>
                                                                    </div>
                                                                    <div
                                                                        class="flex justify-between items-center py-2 border-b border-gray-100">
                                                                        <span
                                                                            class="text-gray-500 text-sm flex items-center gap-2"><i
                                                                                class="fas fa-location-arrow text-purple-400"></i>
                                                                            Provenienza</span>
                                                                        <span id="provenienzaDettagli"
                                                                            class="font-medium text-gray-700"></span>
                                                                    </div>
                                                                    <div
                                                                        class="flex justify-between items-center py-2 border-b border-gray-100">
                                                                        <span
                                                                            class="text-gray-500 text-sm flex items-center gap-2"><i
                                                                                class="fas fa-map-marker-alt text-purple-400"></i>
                                                                            P.V. Destinazione</span>
                                                                        <span id="pvDettagli"
                                                                            class="font-medium text-gray-700"></span>
                                                                    </div>
                                                                    <div class="flex justify-between items-center py-2">
                                                                        <span
                                                                            class="text-gray-500 text-sm flex items-center gap-2"><i
                                                                                class="fas fa-tools text-purple-400"></i>
                                                                            Centro Revisione</span>
                                                                        <span id="fornitoreDettagli"
                                                                            class="font-medium text-gray-700"></span>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Card DDT e Spedizioni -->
                                                            <div class="bg-white rounded-xl p-4 shadow-sm">
                                                                <h4
                                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wide mb-3 flex items-center gap-2">
                                                                    <i class="fas fa-truck text-orange-500"></i>
                                                                    Spedizioni
                                                                </h4>
                                                                <div class="grid grid-cols-2 gap-3">
                                                                    <div class="bg-orange-50 rounded-lg p-3">
                                                                        <span
                                                                            class="text-xs text-orange-600 font-medium">DDT
                                                                            Ricezione</span>
                                                                        <p id="ddtDettagli"
                                                                            class="font-bold text-gray-800 text-lg"></p>
                                                                    </div>
                                                                    <div class="bg-orange-50 rounded-lg p-3">
                                                                        <span
                                                                            class="text-xs text-orange-600 font-medium">Data
                                                                            Ricezione</span>
                                                                        <p id="dataricDettagli"
                                                                            class="font-bold text-gray-800 text-lg"></p>
                                                                    </div>
                                                                    <div class="bg-blue-50 rounded-lg p-3">
                                                                        <span
                                                                            class="text-xs text-blue-600 font-medium">DDT
                                                                            Spedizione</span>
                                                                        <p id="ddtSpedizioneDettagli"
                                                                            class="font-bold text-gray-800 text-lg"></p>
                                                                    </div>
                                                                    <div class="bg-blue-50 rounded-lg p-3">
                                                                        <span
                                                                            class="text-xs text-blue-600 font-medium">Data
                                                                            Spedizione</span>
                                                                        <p id="dataspeDettagli"
                                                                            class="font-bold text-gray-800 text-lg"></p>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Card Garanzia -->
                                                            <div class="bg-white rounded-xl p-4 shadow-sm">
                                                                <h4
                                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wide mb-3 flex items-center gap-2">
                                                                    <i class="fas fa-shield-alt text-green-500"></i>
                                                                    Garanzia
                                                                </h4>
                                                                <div class="grid grid-cols-2 gap-3">
                                                                    <div class="bg-green-50 rounded-lg p-3">
                                                                        <span
                                                                            class="text-xs text-green-600 font-medium">Data
                                                                            Garanzia</span>
                                                                        <p id="datagarDettagli"
                                                                            class="font-bold text-gray-800 text-lg"></p>
                                                                    </div>
                                                                    <div class="bg-green-50 rounded-lg p-3">
                                                                        <span
                                                                            class="text-xs text-green-600 font-medium">Richiesta
                                                                            Garanzia</span>
                                                                        <p id="richiestagarDettagli"
                                                                            class="font-bold text-gray-800 text-lg"></p>
                                                                    </div>
                                                                </div>
                                                            </div>

                                                            <!-- Card Note -->
                                                            <div class="bg-white rounded-xl p-4 shadow-sm">
                                                                <h4
                                                                    class="text-xs font-bold text-gray-400 uppercase tracking-wide mb-3 flex items-center gap-2">
                                                                    <i class="fas fa-sticky-note text-yellow-500"></i>
                                                                    Note
                                                                </h4>
                                                                <p id="noteDettagli"
                                                                    class="text-gray-700 bg-yellow-50 rounded-lg p-3 text-sm">
                                                                </p>
                                                            </div>

                                                        </div>
                                                    </div>

                                                    <!-- Footer -->

                                                </div>
                                            </div>
                                            <div id="delete-modal"
                                                class="modal fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
                                                <div class="bg-white rounded-lg shadow-xl w-full max-w-md fade-in">
                                                    <div class="p-6">
                                                        <div class="flex items-center justify-center mb-4">
                                                            <div
                                                                class="w-12 h-12 rounded-full bg-red-100 flex items-center justify-center">
                                                                <i
                                                                    class="fas fa-exclamation-triangle text-red-600 text-xl"></i>
                                                            </div>
                                                        </div>
                                                        <h3 class="text-lg font-semibold text-center mb-2">Conferma
                                                            eliminazione</h3>
                                                        <p class="text-gray-600 text-center mb-6">Sei sicuro di voler
                                                            eliminare questo articolo? Questa azione non può essere
                                                            annullata.</p>
                                                        <div class="flex justify-center space-x-4">
                                                            <button id="cancel-delete"
                                                                class="px-4 py-2 border rounded-lg hover:bg-gray-100">
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
                                            <div id="etichetta-stampa" style="display:none;"></div>
                                            <% Integer pagina=(Integer) request.getAttribute("page"); Integer
                                                size=(Integer) request.getAttribute("size"); Integer total=(Integer)
                                                request.getAttribute("total"); if (pagina==null) pagina=1; if
                                                (size==null) size=24; if (total==null) total=0; int maxPage=(int)
                                                Math.ceil(total / (double) size); 
                                                String qSearch=request.getParameter("search")
                                                !=null ? request.getParameter("search") : "" ; 
                                                String qStato=request.getParameter("stato") !=null ?
                                                request.getParameter("stato") : "" ;
                                                
                                                String qMarca=request.getParameter("marca") !=null ?
                                                request.getParameter("marca") : "" ; 
                                                
                                                String qData=request.getParameter("data") !=null ? request.getParameter("data")
                                                : "" ; 
                                                
                                                String qNome=request.getParameter("nome") !=null ? request.getParameter("nome") : "" ;
                                                
                                                String qInst=request.getParameter("installatiCheck") !=null ? request.getParameter("installatiCheck") : "nascondi" ;
                                                String baseQuery="search=" + java.net.URLEncoder.encode(qSearch, "UTF-8" ) + "&stato=" + java.net.URLEncoder.encode(qStato, "UTF-8" ) + "&marca=" +java.net.URLEncoder.encode(qMarca, "UTF-8" ) + "&data=" +java.net.URLEncoder.encode(qData, "UTF-8" ) + "&nome=" +java.net.URLEncoder.encode(qNome, "UTF-8" ) + "&installatiCheck=" +java.net.URLEncoder.encode(qInst, "UTF-8" ) + "&size=" + size; %>

                                                <!-- Paginazione sticky, estetica migliorata -->
                                                <!-- Spacer per evitare overlap su desktop (mostrato solo da md in su) -->
                                                <div aria-hidden="true" class="hidden md:block h-16"></div>

                                                <nav role="navigation" aria-label="Paginazione risultati" class="no-print sticky bottom-0 z-50 px-3
            md:fixed md:inset-x-0" style="bottom: max(1rem, env(safe-area-inset-bottom));">
                                                    <div class="mx-auto w-full flex justify-center">
                                                        <div class="inline-flex items-center gap-1 sm:gap-2 rounded-full border border-gray-200
                bg-white/85 backdrop-blur-sm shadow-lg supports-[backdrop-filter]:bg-white/60
                px-2 py-1.5 sm:px-3 sm:py-2">

                                                            <!-- PRECEDENTE -->
                                                            <a class="group inline-flex items-center gap-1 sm:gap-2 rounded-full text-xs sm:text-sm font-medium
                 px-3 py-2 sm:px-3 sm:py-2 transition hover:bg-gray-100
                 <%= (pagina <= 1 ? " opacity-50 pointer-events-none" : "" ) %>"
                                                                href="<%=request.getContextPath() %>/filtro?<%=
                                                                        baseQuery %>&page=<%= (pagina - 1) %>"
                                                                            data-ajax="risultati"
                                                                            aria-label="Pagina precedente"
                                                                            aria-disabled="<%= (pagina <=1) %>">
                                                                                <i class="fas fa-chevron-left"></i>
                                                                                <span
                                                                                    class="hidden sm:inline">Precedente</span>
                                                            </a>

                                                            <!-- INDICATORE PAGINA -->
                                                            <span
                                                                class="select-none text-xs sm:text-sm text-gray-700 whitespace-nowrap px-2 sm:px-3"
                                                                role="status">
                                                                Pag. <span class="font-semibold">
                                                                    <%= pagina %>
                                                                </span>
                                                                <span class="mx-1 text-gray-400">/</span>
                                                                <span class="font-medium">
                                                                    <%= Math.max(1, maxPage) %>
                                                                </span>
                                                            </span>

                                                            <!-- SUCCESSIVA -->
                                                            <a class="group inline-flex items-center gap-1 sm:gap-2 rounded-full text-xs sm:text-sm font-medium
                 px-3 py-2 sm:px-3 sm:py-2 transition hover:bg-gray-100
                 <%= (pagina >= maxPage ? " opacity-50 pointer-events-none" : "" ) %>"
                                                                href="<%=request.getContextPath() %>/filtro?<%=
                                                                        baseQuery %>&page=<%= (pagina + 1) %>"
                                                                            data-ajax="risultati"
                                                                            aria-label="Pagina successiva"
                                                                            aria-disabled="<%= (pagina>= maxPage) %>">
                                                                                <span
                                                                                    class="hidden sm:inline">Successiva</span>
                                                                                <i class="fas fa-chevron-right"></i>
                                                            </a>

                                                        </div>
                                                    </div>
                                                </nav>
                                                <script>
                                                    function caricaStoricoArticolo(id) {
                                                        fetch('<%=request.getContextPath()%>' + '/storico-articolo?id=' + id)
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