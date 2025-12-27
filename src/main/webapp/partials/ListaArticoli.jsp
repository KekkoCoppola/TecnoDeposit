<%@ page import="model.Articolo" %>
    <%@ page import="model.ListaArticoli" %>
        <%@ page import="java.util.List" %>
            <%@ page contentType="text/html; charset=UTF-8" language="java" %>
                <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

                    <% System.out.println("\n====================INIZIO DEBUG====================\n"); final int
                        articoliPerPagina=100; int paginaCorrente=1; String paramPage=request.getParameter("page"); if
                        (paramPage !=null) { try { paginaCorrente=Integer.parseInt(paramPage); } catch
                        (NumberFormatException e) { paginaCorrente=1; } } ListaArticoli lista=new ListaArticoli();
                        List<Articolo> articoliTotali = lista.getAllarticoli();
                        //List<Articolo> articoliTotali = (List<Articolo>) request.getAttribute("listaArticoli");
                                int totaleArticoli = articoliTotali.size();
                                int totalePagine = (int) Math.ceil((double) totaleArticoli / articoliPerPagina);

                                int inizio = (paginaCorrente - 1) * articoliPerPagina;
                                int fine = Math.min(inizio + articoliPerPagina, totaleArticoli);
                                List<Articolo> articoli = articoliTotali.subList(inizio, fine);
                                    if (articoli != null && !articoli.isEmpty()) {
                                    for (Articolo a : articoli) {


                                    %>


                                    <!-- Article Cards -->
                                    <div data-id="<%= a.getId() %>"
                                        class="article-card bg-white rounded-2xl shadow-md hover:shadow-2xl overflow-hidden transition-all duration-300 w-full max-w-sm flex flex-col justify-between h-full hover:-translate-y-1 border border-gray-100"
                                        onclick="apriDettagli(event)" data-nome="<%= a.getNome() %>"
                                        data-matricola="<%= a.getMatricola() %>" data-marca="<%= a.getMarca() %>"
                                        data-compatibilita="<%= a.getCompatibilita() %>" data-ddt="<%= a.getDdt() %>"
                                        data-tecnico="<%= a.getTecnico() %>" data-pv="<%= a.getPv() %>"
                                        data-fornitore="<%= a.getFornitore() %>"
                                        data-dataric="<%= a.getDataRic_DDT() %>"
                                        data-dataspe="<%= a.getDataSpe_DDT() %>"
                                        data-datagar="<%= a.getDataGaranzia() %>" data-note="<%= a.getNote() %>"
                                        data-stato="<%= a.getStato() %>" data-immagine="<%= a.getImmagine() %>">
                                        <div class="relative group">
                                            <img loading="lazy"
                                                src="<%= (a.getImmagine() != null && !a.getImmagine().isEmpty()) && !a.getImmagine().equals("null") ? a.getImmagine() : "img/Icon.png" %>" alt="Articolo"
                                            class="w-full aspect-[4/3] object-cover transition-transform duration-300
                                            group-hover:scale-105">
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
                                            </div>
                                            <div class="space-y-2 text-sm">
                                                <div
                                                    class="flex justify-between items-center py-1 border-b border-gray-100">
                                                    <span class="text-gray-500 flex items-center gap-2"><i
                                                            class="fas fa-industry text-xs text-gray-400"></i>Marca</span>
                                                    <span class="font-medium text-gray-700 truncate max-w-[120px]">
                                                        <%= a.getMarca() %>
                                                    </span>
                                                </div>
                                                <div
                                                    class="flex justify-between items-center py-1 border-b border-gray-100">
                                                    <span class="text-gray-500 flex items-center gap-2"><i
                                                            class="fas fa-puzzle-piece text-xs text-gray-400"></i>Compatibilità</span>
                                                    <span class="font-medium text-gray-700 truncate max-w-[120px]">
                                                        <%= a.getCompatibilita() %>
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
                                                <button
                                                    class="delete-btn flex-1 bg-gradient-to-r from-red-500 to-red-600 text-white hover:from-red-600 hover:to-red-700 px-3 py-2 rounded-xl text-sm font-medium flex items-center justify-center shadow-sm hover:shadow-md transition-all"
                                                    data-id="${articolo.id}">
                                                    <i class="fas fa-trash-alt mr-1.5"></i> Elimina
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Modale -->

                                    <% } } else { %>
                                        <p>Nessun articolo disponibile.</p>
                                        <% } %>

                                            <!-- Paginazione -->
                                            <div class="mt-8 flex justify-between items-center">
                                                <div class="text-sm text-gray-600">
                                                    Mostrando <%= inizio + 1 %>-<%= fine %> di <%= totaleArticoli %>
                                                                articoli
                                                </div>
                                                <div class="flex space-x-2">
                                                    <% if (paginaCorrente> 1) { %>
                                                        <a href="?page=<%= paginaCorrente - 1 %>"
                                                            class="px-3 py-1 border rounded-lg hover:bg-gray-100">
                                                            <i class="fas fa-chevron-left"></i>
                                                        </a>
                                                        <% } else { %>
                                                            <span
                                                                class="px-3 py-1 border rounded-lg text-gray-400 cursor-not-allowed">
                                                                <i class="fas fa-chevron-left"></i>
                                                            </span>
                                                            <% } %>

                                                                <% for (int p=1; p <=totalePagine; p++) { %>
                                                                    <a href="?page=<%= p %>"
                                                                        class="px-3 py-1 border rounded-lg <%= p == paginaCorrente ? "bg-[#e52c1f] text-white" : "hover:bg-gray-100"
                                                                        %>">
                                                                        <%= p %>
                                                                    </a>
                                                                    <% } %>

                                                                        <% if (paginaCorrente < totalePagine) { %>
                                                                            <a href="?page=<%= paginaCorrente + 1 %>"
                                                                                class="px-3 py-1 border rounded-lg hover:bg-gray-100">
                                                                                <i class="fas fa-chevron-right"></i>
                                                                            </a>
                                                                            <% } else { %>
                                                                                <span
                                                                                    class="px-3 py-1 border rounded-lg text-gray-400 cursor-not-allowed">
                                                                                    <i class="fas fa-chevron-right"></i>
                                                                                </span>
                                                                                <% } %>
                                                </div>
                                            </div>

                                            <!-- MODALE ARTICOLO DETTAGLI -->
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
                                                                                class="fas fa-map-marker-alt text-purple-400"></i>
                                                                            P.V. Destinazione</span>
                                                                        <span id="pvDettagli"
                                                                            class="font-medium text-gray-700"></span>
                                                                    </div>
                                                                    <div class="flex justify-between items-center py-2">
                                                                        <span
                                                                            class="text-gray-500 text-sm flex items-center gap-2"><i
                                                                                class="fas fa-tools text-purple-400"></i>
                                                                            Fornitore</span>
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
                                                                            class="text-xs text-orange-600 font-medium">DDT</span>
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
                                                                    <div class="bg-blue-50 rounded-lg p-3 col-span-2">
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
                                                                <div class="bg-green-50 rounded-lg p-3">
                                                                    <span
                                                                        class="text-xs text-green-600 font-medium">Data
                                                                        Garanzia</span>
                                                                    <p id="datagarDettagli"
                                                                        class="font-bold text-gray-800 text-lg"></p>
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
                                                </div>
                                            </div>
                                            </div>

                                            <!-- MODALE DELETE -->
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

                                            <script>
                                                const addButton = document.getElementById('add-article-btn');
                                                const editButtons = document.querySelectorAll('.edit-btn');
                                                const confirmDeleteBtn = document.getElementById('confirm-delete');
                                                const deleteModal = document.getElementById('delete-modal');
                                                const cancelDeleteBtn = document.getElementById('cancel-delete');
                                                const modaleDettagli = document.getElementById('articleModal');
                                                const deleteButtons = document.querySelectorAll('.delete-btn');



                                                function closeModal() {
                                                    modaleDettagli.classList.add('hidden');
                                                    document.body.style.overflow = 'auto';
                                                }



                                                cancelDeleteBtn.addEventListener('click', function () {
                                                    deleteModal.classList.add('hidden');
                                                });

                                                function apriDettagli() {

                                                    modaleDettagli.classList.remove('hidden');
                                                    document.body.style.overflow = 'auto';
                                                    const card = event.currentTarget;


                                                    const id = card.dataset.id;
                                                    const nome = card.dataset.nome;
                                                    const matricola = card.dataset.matricola;
                                                    const marca = card.dataset.marca;
                                                    const compatibilita = card.dataset.compatibilita;
                                                    const ddt = card.dataset.ddt;
                                                    const tecnico = card.dataset.tecnico;
                                                    const pv = card.dataset.pv;
                                                    const fornitore = card.dataset.fornitore;
                                                    const dataric = card.dataset.dataric;
                                                    const dataspe = card.dataset.dataspe;
                                                    const datagar = card.dataset.datagar;
                                                    const note = card.dataset.note;
                                                    const stato = card.dataset.stato;
                                                    const immagine = card.dataset.immagine;

                                                    document.getElementById('nomeDettagli').textContent = nome;
                                                    document.getElementById('matricolaDettagli').textContent = "Matricola: " + matricola;
                                                    document.getElementById('marcaDettagli').textContent = marca;
                                                    document.getElementById('compatibilitaDettagli').textContent = compatibilita;
                                                    document.getElementById('ddtDettagli').textContent = ddt;
                                                    document.getElementById('tecnicoDettagli').textContent = tecnico;
                                                    document.getElementById('pvDettagli').textContent = pv;
                                                    document.getElementById('fornitoreDettagli').textContent = fornitore;
                                                    document.getElementById('dataricDettagli').textContent = dataric;
                                                    document.getElementById('dataspeDettagli').textContent = dataspe;
                                                    document.getElementById('datagarDettagli').textContent = datagar;
                                                    document.getElementById('noteDettagli').textContent = note;
                                                    document.getElementById('statoDettagli').textContent = stato;
                                                    document.getElementById('immagineDettagli').src = immagine;
                                                    console.log(stato);

                                                    const statoBox = document.getElementById('statoDettagli');
                                                    statoBox.classList.remove('status-riparato', 'status-in-magazzino', 'status-installato', 'status-destinato', 'status-assegnato', 'status-guasto');
                                                    switch (stato) {
                                                        case 'Guasto':
                                                            statoBox.classList.add('status-guasto');
                                                            break;
                                                        case 'In attesa':
                                                            statoBox.classList.add('status-in-attesa');
                                                            break;
                                                        case 'In magazzino':
                                                            statoBox.classList.add('status-in-magazzino');
                                                            break;
                                                        case 'Riparato':
                                                            statoBox.classList.add('status-riparato');
                                                            break;
                                                        case 'Destinato':
                                                            statoBox.classList.add('status-destinato');
                                                            break;
                                                        case 'Assegnato':
                                                            statoBox.classList.add('status-assegnato');
                                                            break;
                                                        case 'Installato':
                                                            statoBox.classList.add('status-installato');
                                                            break;
                                                        default:
                                                            statoBox.classList.add('bg-gray-300'); // stato sconosciuto
                                                            document.getElementById('bodyDettagli').scrollTop = 0;
                                                    }

                                                }

                                                //APERTURA ADD
                                                addButton.addEventListener('click', function () {
                                                    modal.scrollTop = 0;
                                                    document.getElementById('article-form').reset();
                                                    modal.classList.remove('hidden');
                                                    document.getElementById('formAction').value = 'add';
                                                    document.getElementById('modal-title').textContent = "Aggiungi Nuovo Articolo";
                                                });


                                                //APERTURA EDIT
                                                editButtons.forEach(button => {
                                                    button.addEventListener('click', function (e) {
                                                        e.stopPropagation();
                                                        modal.scrollTop = 0;
                                                        modal.classList.remove('hidden');
                                                        document.getElementById('formAction').value = 'update';
                                                        const card = button.closest('.article-card'); // trova il contenitore

                                                        const id = card.dataset.id;
                                                        const nome = card.dataset.nome;
                                                        const matricola = card.dataset.matricola;
                                                        const marca = card.dataset.marca;
                                                        const compatibilita = card.dataset.compatibilita;
                                                        const ddt = card.dataset.ddt;
                                                        const tecnico = card.dataset.tecnico;
                                                        const pv = card.dataset.pv;
                                                        const fornitore = card.dataset.fornitore;
                                                        const dataric = card.dataset.dataric;
                                                        const dataspe = card.dataset.dataspe;
                                                        const datagar = card.dataset.datagar;
                                                        const note = card.dataset.note;
                                                        const stato = card.dataset.stato;
                                                        const immagine = card.dataset.immagine;

                                                        if (!card) {
                                                            console.error("❌ Elemento .article-card non trovato. Controlla che il bottone sia dentro la card.", button);
                                                            return;
                                                        }

                                                        document.getElementById('formId').value = id;
                                                        document.getElementById('statoInput').value = stato;
                                                        document.getElementById('nomeInput').value = nome;
                                                        document.getElementById('marcaInput').value = marca;
                                                        document.getElementById('compatibilitaInput').value = compatibilita;
                                                        document.getElementById('matricolaInput').value = matricola;
                                                        document.getElementById('ddtInput').value = ddt;
                                                        document.getElementById('provenienzaInput').value = provenienza;
                                                        document.getElementById('fornitoreInput').value = fornitore;
                                                        document.getElementById('tecnicoInput').value = tecnico;
                                                        document.getElementById('pvInput').value = pv;
                                                        document.getElementById('datagarInput').value = datagar;
                                                        document.getElementById('dataspeInput').value = dataspe;
                                                        document.getElementById('dataricInput').value = dataric;
                                                        document.getElementById('noteInput').value = note;

                                                        document.getElementById('modal-title').textContent = "Modifica Articolo";

                                                    });
                                                });

                                                deleteButtons.forEach(button => {

                                                    button.addEventListener('click', function (e) {
                                                        e.stopPropagation();
                                                        deleteModal.classList.remove('hidden');
                                                        const card = button.closest('.article-card'); // trova il contenitore
                                                        const id = card.dataset.id;
                                                        confirmDeleteBtn.dataset.id = id;
                                                    });
                                                });

                                                confirmDeleteBtn.addEventListener('click', function () {

                                                    deleteModal.classList.add('hidden');
                                                    document.getElementById('formAction').value = 'delete';
                                                    const id = this.dataset.id; // Prende l'id salvato prima
                                                    document.getElementById('formId').value = id;
                                                    console.log("PRESO ID: " + id);


                                                    document.getElementById('article-form').submit();

                                                });

                                                window.addEventListener('click', function (e) {
                                                    console.log(e.target);
                                                    if (e.target === modal) {
                                                        modal.classList.add('hidden');
                                                    }
                                                    if (e.target === deleteModal) {
                                                        deleteModal.classList.add('hidden');
                                                    }
                                                    if (modaleDettagli && e.target === modaleDettagli) {
                                                        modaleDettagli.classList.add('hidden');
                                                    }
                                                });

                                            </script>