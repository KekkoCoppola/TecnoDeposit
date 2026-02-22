<!DOCTYPE html>
<html lang="it">
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Catalogo Fornitori Magazzino</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style>
            .supplier-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(239, 68, 68, 1);
            }

            .active-filter {
                background-color: #ef4444;
                color: white;
            }

            .search-input:focus {
                outline: none;
                box-shadow: 0 0 0 3px rgba(239, 68, 68, 1);
            }
        </style>
        <% ListaFornitori fornitori2=new ListaFornitori(); %>
    </head>

    <body class="bg-gray-50 min-h-screen">
        <div class="container mx-auto px-4 py-8">
            <!-- Header -->
            <header class="mb-10">
                <div class="flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-800">Catalogo Centri Revisione</h1>
                        <p class="text-gray-600">Gestione completa dei centri revisione affiliati</p>
                    </div>
                    <button id="addSupplierBtn"
                        class="bg-red-500 hover:bg-red-600 text-white px-6 py-2 rounded-lg flex items-center gap-2 transition-colors">
                        <i class="fas fa-plus"></i> Nuovo Centro Revisione
                    </button>
                </div>
            </header>

            <!-- Search and Filters -->
            <div class="mb-8 bg-white p-6 rounded-xl shadow-sm">
                <div class="flex flex-col md:flex-row gap-4 mb-6">
                    <div class="relative flex-grow">
                        <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        <input type="text" id="searchInput" placeholder="Cerca ..."
                            class="search-input pl-10 pr-4 py-2 w-full border border-gray-300 rounded-lg focus:border-red-500">
                    </div>

                </div>
                <!--  
            <div class="flex flex-wrap gap-2">
			  <button class="favSearch px-4 py-1 rounded-full border border-gray-300 hover:bg-gray-100">
			    <i class="far fa-star mr-1"></i> Preferiti
			  </button>
			</div>-->

                <!-- Stats -->
                <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
                    <div class="bg-white p-4 rounded-xl shadow-sm border-l-4 border-red-500">
                        <h3 class="text-gray-500 text-sm">Centri Revisione totali</h3>
                        <p class="text-2xl font-bold">
                            <%=fornitori2.countFornitori() %>
                        </p>
                    </div>

                </div>

                <!-- Suppliers List -->
                <div id="risultatiF" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                    <%@ include file="partials/risultatiFornitori.jsp" %>
                </div>



                <!-- Add Supplier Modal -->
                <div id="addSupplierModal"
                    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center hidden z-50">
                    <div class="bg-white rounded-xl p-6 w-full max-w-md">
                        <div class="flex justify-between items-center mb-4">
                            <h3 id="modal-title" class="text-xl font-bold text-gray-800">Aggiungi nuovo centro revisione
                            </h3>
                            <button id="closeModalBtn" class="text-gray-500 hover:text-gray-700">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <form id="supplierForm" action="fornitori" method="post">
                            <input type="hidden" name="id" id="supplierId">
                            <input type="hidden" name="action" id="formAction" value="add">
                            <div class="mb-4">
                                <label for="supplierName" class="block text-gray-700 mb-2">Nome centro revisione</label>
                                <input type="text" id="supplierName" name="nome"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:border-red-500">
                            </div>
                            <!--  <div class="mb-4">
                    <label for="supplierCategory" class="block text-gray-700 mb-2">Categoria</label>
                    <select id="supplierCategory" class="w-full px-3 py-2 border border-gray-300 rounded-lg bg-white">
                        <option value="elettronica">Elettronica</option>
                        <option value="ufficio">Materiale d'ufficio</option>
                        <option value="edilizia">Materiale edile</option>
                        <option value="alimentari">Prodotti alimentari</option>
                        <option value="chimici">Prodotti chimici</option>
                        <option value="altro">Altro</option>
                    </select>
                </div>-->
                            <div class="mb-4">
                                <label for="supplierMail" class="block text-gray-700 mb-2">Mail</label>
                                <input type="email" id="supplierMail" name="mail"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:border-red-500">
                            </div>
                            <div class="mb-4">
                                <label for="supplierLocation" class="block text-gray-700 mb-2">Indirizzo</label>
                                <input type="text" id="supplierLocation" name="indirizzo"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:border-red-500">
                            </div>
                            <div class="mb-4">
                                <label for="supplierPhone" class="block text-gray-700 mb-2">Telefono</label>
                                <input type="text" id="supplierPhone" name="telefono"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:border-red-500">
                            </div>
                            <div class="mb-4">
                                <label for="supplierIva" class="block text-gray-700 mb-2">Partita IVA
                                    (opzionale)</label>
                                <input type="text" id="supplierIva" name="iva"
                                    class="w-full px-3 py-2 border border-gray-300 rounded-lg focus:border-red-500">
                            </div>
                            <div class="flex justify-end gap-3 mt-6">
                                <button type="button" id="cancelBtn"
                                    class="px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-100">Annulla</button>
                                <button type="submit" id="saveBtn"
                                    class="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600">Salva</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- MODALE CATALOGO FORNITORI -->
            <div id="catalogModalF" class="fixed inset-0 z-50 hidden overflow-y-auto">
                <div class="flex items-center justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                    <!-- Sfondo -->
                    <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                        <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
                    </div>

                    <!-- Contenuto del modale -->
                    <div
                        class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-5xl sm:w-full">
                        <!-- Header -->
                        <div
                            class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:items-center sm:justify-between border-b border-gray-200">
                            <h3 id=modalCatalogoTitle class="text-lg leading-6 font-medium text-gray-900">
                                <i class="fas fa-folder-open mr-2 text-red-600"></i> Articoli del centro revisione
                            </h3>
                            <button onclick="closeModalCatalogo()"
                                class="text-gray-400 hover:text-gray-500 focus:outline-none">
                                <i class="fas fa-times text-xl"></i>
                            </button>
                        </div>

                        <!-- Corpo dinamico -->
                        <div id=modalContentAreaF class="">

                        </div>

                        <!-- Footer -->
                        <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse border-t border-gray-200">
                            <button type="button" onclick="closeModalCatalogo()"
                                class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-red-600 text-base font-medium text-white hover:bg-red-700 focus:outline-none sm:ml-3 sm:w-auto sm:text-sm">
                                Chiudi
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
                        <h3 class="text-lg font-semibold text-center mb-2">Conferma eliminazione</h3>
                        <p class="text-gray-600 text-center mb-6">Sei sicuro di voler eliminare questo centro? Questa
                            azione non può essere annullata.</p>
                        <div class="flex justify-center space-x-4">
                            <button class=" cancel-delete px-4 py-2 border rounded-lg hover:bg-gray-100">
                                Annulla
                            </button>
                            <button id="confirmDeleteBtn"
                                class="bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded-lg" name="delete">
                                Elimina
                            </button>
                        </div>
                    </div>
                </div>
            </div>



            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
            <script>
                const addButton = document.getElementById('addSupplierBtn');
                var editButtons = document.querySelectorAll('.edit-suppliers');
                var viewButtons = document.querySelectorAll('.view-suppliers');
                const modal = document.getElementById('addSupplierModal');
                const closeBtn = document.getElementById('closeModalBtn');
                const cancelBtn = document.getElementById('cancelBtn');
                const form = document.getElementById('supplierForm');
                const formAction = document.getElementById("form-action");
                var deleteButtons = document.querySelectorAll('.delete-btn');
                var cancelDeleteBtn = document.getElementById('cancel-delete');
                var deleteModal = document.getElementById('delete-modal');


                //APERTURA CATALOGO FORNITORE
                function caricaCatalogoFornitore(id) {
                    fetch('<%=request.getContextPath()%>' + '/catalogo-fornitore?id=' + id)
                        .then(response => response.text())
                        .then(html => {
                            document.getElementById('modalContentAreaF').innerHTML = html;
                            document.getElementById('catalogModalF').classList.remove('hidden');
                            document.getElementById('catalogModalF').scrollTop = 0;
                            // Inizializza filtri dopo che il contenuto è stato caricato
                            initCatalogoFiltri();
                        })
                        .catch(error => console.error('Errore nel caricamento:', error));
                }

                // === FILTRI CATALOGO FORNITORE (client-side) ===
                var _catalogoInstallatiVisibili = false; // default: nascosti

                function initCatalogoFiltri() {
                    _catalogoInstallatiVisibili = false;

                    var dropdown = document.getElementById('catalogoStatoFilter');
                    var toggleBtn = document.getElementById('catalogoToggleInstallati');

                    if (dropdown) {
                        dropdown.value = 'Tutti';
                        dropdown.addEventListener('change', function () {
                            var val = dropdown.value;
                            var icon = document.getElementById('catalogoIconToggle');
                            var text = document.getElementById('catalogoTextToggle');

                            if (val === 'Installato') {
                                // Selezionato "Installato" → mostra installati
                                _catalogoInstallatiVisibili = true;
                                if (icon) { icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); }
                                if (text) text.textContent = 'Nascondi Installati';
                            } else {
                                // Altro stato → nascondi installati
                                _catalogoInstallatiVisibili = false;
                                if (icon) { icon.classList.remove('fa-eye'); icon.classList.add('fa-eye-slash'); }
                                if (text) text.textContent = 'Installati';
                            }
                            filtraCatalogo();
                        });
                    }

                    if (toggleBtn) {
                        toggleBtn.addEventListener('click', function () {
                            _catalogoInstallatiVisibili = !_catalogoInstallatiVisibili;
                            var icon = document.getElementById('catalogoIconToggle');
                            var text = document.getElementById('catalogoTextToggle');

                            if (_catalogoInstallatiVisibili) {
                                if (icon) { icon.classList.remove('fa-eye-slash'); icon.classList.add('fa-eye'); }
                                if (text) text.textContent = 'Nascondi Installati';
                            } else {
                                if (icon) { icon.classList.remove('fa-eye'); icon.classList.add('fa-eye-slash'); }
                                if (text) text.textContent = 'Installati';
                            }
                            filtraCatalogo();
                        });
                    }

                    // Applicare filtro iniziale (nascondi installati by default)
                    filtraCatalogo();
                }

                function filtraCatalogo() {
                    var dropdown = document.getElementById('catalogoStatoFilter');
                    var statoScelto = dropdown ? dropdown.value : 'Tutti';
                    var cards = document.querySelectorAll('.catalogo-article-card');

                    cards.forEach(function (card) {
                        var cardStato = (card.getAttribute('data-stato') || '').trim();
                        var isInstallato = cardStato.toLowerCase() === 'installato';

                        // Logica visibilità
                        var visibile = true;

                        // 1. Filtro installati (se nascosti e la card è installato → nascondi)
                        if (!_catalogoInstallatiVisibili && isInstallato && statoScelto !== 'Installato') {
                            visibile = false;
                        }

                        // 2. Filtro stato dropdown
                        if (statoScelto !== 'Tutti') {
                            if (cardStato.toLowerCase() !== statoScelto.toLowerCase()) {
                                visibile = false;
                            }
                        }

                        card.style.display = visibile ? '' : 'none';
                    });
                }

                function closeModalCatalogo() {
                    document.getElementById('catalogModalF').classList.add('hidden');
                    document.getElementById('modalContentAreaF').innerHTML = '';
                }

                //PREFERITI ON/OFF
                $(document).on('click', '.favBtn', function (e) {
                    console.log("CLICATO FAV");
                    $(this).find('i').toggleClass('far fas');
                    $(this).find('i').toggleClass('text-gray-300 text-yellow-300');

                    const $btn = $(this);
                    let isFavorite = $btn.attr('data-favorite') === 'true';
                    isFavorite = !isFavorite;
                    $btn.attr('data-favorite', isFavorite).data('favorite', isFavorite);

                    console.log("Preferito?", isFavorite);
                });



                //EDIT
                $(document).on('click', '.edit-suppliers', function (e) {
                    e.stopPropagation();

                    const button = $(this);
                    const card = button.closest('.supplier-card');

                    if (!card.length) {
                        console.error("❌ Elemento .supplier-card non trovato.");
                        return;
                    }

                    modal.scrollTop = 0;
                    modal.classList.remove('hidden');
                    $('#formAction').val('update');
                    $('#modal-title').text("Modifica Centro Revisione");

                    $('#supplierId').val(card.data('id'));
                    $('#supplierName').val(card.data('nome'));
                    $('#supplierPhone').val(card.data('telefono'));
                    $('#supplierMail').val(card.data('mail'));
                    $('#supplierLocation').val(card.data('indirizzo'));
                    $('#supplierIva').val(card.data('piva'));

                    console.log("✅ Bottone edit cliccato");
                });
                //VIEW
                $(document).on('click', '.view-suppliers', function (e) {
                    e.stopPropagation();

                    const button = $(this);
                    const card = button.closest('.supplier-card');

                    if (!card.length) {
                        console.error("❌ Elemento .supplier-card non trovato.");
                        return;
                    }

                    modal.scrollTop = 0;
                    modal.classList.remove('hidden');

                    $('#modal-title').text("Visualizza Fornitore");

                    $('#supplierId').val(card.data('id'));
                    $('#supplierName').val(card.data('nome'));
                    $('#supplierPhone').val(card.data('telefono'));
                    $('#supplierMail').val(card.data('mail'));
                    $('#supplierLocation').val(card.data('indirizzo'));
                    $('#supplierIva').val(card.data('piva'));

                    $('#supplierId').prop('readonly', true);
                    $('#supplierName').prop('readonly', true);
                    $('#supplierPhone').prop('readonly', true);
                    $('#supplierMail').prop('readonly', true);
                    $('#supplierLocation').prop('readonly', true);
                    $('#supplierIva').prop('readonly', true);

                    $('#saveBtn').hide();
                    $('#cancelBtn').hide();

                    console.log("✅ Bottone edit cliccato");
                });
                //ANNULLA DELETE
                $(document).on('click', '.cancel-delete', function (e) {
                    e.stopPropagation();
                    $('#deleteModal').addClass('hidden');
                    ;
                });
                //DELETE
                $(document).on('click', '.delete-suppliers', function (e) {
                    e.stopPropagation();

                    const button = $(this);
                    const card = button.closest('.supplier-card');

                    if (!card.length) {
                        console.error("❌ Elemento .supplier-card non trovato.");
                        return;
                    }

                    const id = card.data('id');
                    $('#confirmDeleteBtn').data('id', id);
                    $('#deleteModal').removeClass('hidden');

                    console.log("🗑️ Bottone elimina cliccato per ID:", id);
                });
                //CONFERMA DELETE
                $('#confirmDeleteBtn').on('click', function () {
                    const id = $(this).data('id');

                    $('#deleteModal').addClass('hidden');
                    $('#formAction').val('delete');
                    $('#supplierId').val(id); // Usa lo stesso input hidden già usato per add/update

                    console.log("✅ Eliminazione confermata per ID:", id);

                    $('#supplierForm').submit(); // Invia il form esistente
                });



                //ADD
                addButton.addEventListener('click', function () {
                    modal.scrollTop = 0;
                    document.getElementById('supplierForm').reset();
                    modal.classList.remove('hidden');
                    document.getElementById('formAction').value = 'add';
                    document.getElementById('modal-title').textContent = "Aggiungi Nuovo Centro Revisione";
                });
                closeBtn.addEventListener('click', function () {
                    modal.classList.add('hidden');
                });

                cancelBtn.addEventListener('click', function () {
                    modal.classList.add('hidden');
                });


                const ruoloUtente = '<%=(String) session.getAttribute("ruolo") %>';
                $(document).ready(function () {
                    aggiornaFornitori();
                });
                //AGIORNA
                function aggiornaFornitori() {

                    var search = $("#searchInput").val();

                    // Stampo in console
                    console.log("Dati inviati:");
                    console.log("Search: " + search);
                    console.log("RUOLO: " + ruoloUtente);

                    $.get("fornitori", {
                        search: search
                    }, function (data) {
                        $("#risultatiF").html(data);
                        console.log("--------CARICO-----------\n" + data);
                        if (ruoloUtente === "Tecnico") {
                            $(".edit-suppliers").hide();
                            $(".delete-suppliers").hide();
                            $("#addSupplierBtn").hide();
                            console.log("Pulsanti edit nascosti per il ruolo Tecnico");
                        }
                        if (ruoloUtente === "Amministratore" || ruoloUtente === "Magazziniere") {
                            $(".view-suppliers").hide();
                        }
                    });
                }

                $("#searchInput").on("input", aggiornaFornitori);


            </script>
    </body>

</html>