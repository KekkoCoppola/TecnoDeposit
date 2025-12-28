<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


  <%@ page import="model.Articolo" %>
    <%@ page import="model.UserService" %>
      <%@ page import="model.ListaArticoli" %>
        <%@ page import="java.util.List" %>
          <!DOCTYPE html>
          <html>

          <head>
            <meta charset="UTF-8">
            <style>
              #reader {
                width: 300px;
                margin: 0 auto;
              }

              /* From Uiverse.io by Dev-MdTuhin */
              .checkbox-wrapper-10 .tgl {
                display: none;
              }

              .checkbox-wrapper-10 .tgl,
              .checkbox-wrapper-10 .tgl:after,
              .checkbox-wrapper-10 .tgl:before,
              .checkbox-wrapper-10 .tgl *,
              .checkbox-wrapper-10 .tgl *:after,
              .checkbox-wrapper-10 .tgl *:before,
              .checkbox-wrapper-10 .tgl+.tgl-btn {
                box-sizing: border-box;
              }

              .checkbox-wrapper-10 .tgl::-moz-selection,
              .checkbox-wrapper-10 .tgl:after::-moz-selection,
              .checkbox-wrapper-10 .tgl:before::-moz-selection,
              .checkbox-wrapper-10 .tgl *::-moz-selection,
              .checkbox-wrapper-10 .tgl *:after::-moz-selection,
              .checkbox-wrapper-10 .tgl *:before::-moz-selection,
              .checkbox-wrapper-10 .tgl+.tgl-btn::-moz-selection,
              .checkbox-wrapper-10 .tgl::selection,
              .checkbox-wrapper-10 .tgl:after::selection,
              .checkbox-wrapper-10 .tgl:before::selection,
              .checkbox-wrapper-10 .tgl *::selection,
              .checkbox-wrapper-10 .tgl *:after::selection,
              .checkbox-wrapper-10 .tgl *:before::selection,
              .checkbox-wrapper-10 .tgl+.tgl-btn::selection {
                background: none;
              }

              .checkbox-wrapper-10 .tgl+.tgl-btn {
                outline: 0;
                display: block;
                width: 4em;
                height: 2em;
                position: relative;
                cursor: pointer;
                -webkit-user-select: none;
                -moz-user-select: none;
                -ms-user-select: none;
                user-select: none;
              }

              .checkbox-wrapper-10 .tgl+.tgl-btn:after,
              .checkbox-wrapper-10 .tgl+.tgl-btn:before {
                position: relative;
                display: block;
                content: "";
                width: 50%;
                height: 100%;
              }

              .checkbox-wrapper-10 .tgl+.tgl-btn:after {
                left: 0;
              }

              .checkbox-wrapper-10 .tgl+.tgl-btn:before {
                display: none;
              }

              .checkbox-wrapper-10 .tgl:checked+.tgl-btn:after {
                left: 50%;
              }

              .checkbox-wrapper-10 .tgl-flip+.tgl-btn {
                padding: 2px;
                transition: all 0.2s ease;
                font-family: sans-serif;
                perspective: 100px;
              }

              .checkbox-wrapper-10 .tgl-flip+.tgl-btn:after,
              .checkbox-wrapper-10 .tgl-flip+.tgl-btn:before {
                display: inline-block;
                transition: all 0.4s ease;
                width: 100%;
                text-align: center;
                position: absolute;
                line-height: 2em;
                font-weight: bold;
                color: #fff;
                position: absolute;
                top: 0;
                left: 0;
                -webkit-backface-visibility: hidden;
                backface-visibility: hidden;
                border-radius: 4px;
              }

              .checkbox-wrapper-10 .tgl-flip+.tgl-btn:after {
                content: attr(data-tg-on);
                background: #02C66F;
                transform: rotateY(-180deg);
              }

              .checkbox-wrapper-10 .tgl-flip+.tgl-btn:before {
                background: #FF3A19;
                content: attr(data-tg-off);
              }

              .checkbox-wrapper-10 .tgl-flip+.tgl-btn:active:before {
                transform: rotateY(-20deg);
              }

              .checkbox-wrapper-10 .tgl-flip:checked+.tgl-btn:before {
                transform: rotateY(180deg);
              }

              .checkbox-wrapper-10 .tgl-flip:checked+.tgl-btn:after {
                transform: rotateY(0);
                left: 0;
                background: #7FC6A6;
              }

              .checkbox-wrapper-10 .tgl-flip:checked+.tgl-btn:active:after {
                transform: rotateY(20deg);
              }
            </style>

          </head>


          <body>
            <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>

            <!-- Main Content Area -->
            <main class="flex-1 overflow-y-auto p-6">
              <div class="mb-6 flex justify-between items-center">
                <div>
                  <h2 class="text-2xl font-bold text-gray-800">Tutti gli Articoli</h2>
                  <p class="text-gray-600">Gestisci inventario</p>
                </div>

                <button id="add-article-btn"
                  class="bg-[#e52c1f] hover:bg-[#c5271b] text-white px-4 py-2 rounded-lg flex items-center">
                  <i class="fas fa-plus mr-2"></i> Aggiungi Articolo
                </button>

              </div>
              <!-- Filters -->
              <div class="bg-white rounded-lg shadow-sm p-4 mb-6">
                <div class="flex flex-wrap items-end gap-3 sm:gap-4">

                  <!-- Cerca -->
                  <div class="relative w-full sm:w-auto min-w-[240px]">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Cerca</label>
                    <input id="searchInput" type="text" placeholder="Cerca per qualsiasi campo"
                      class="w-full pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#e52c1f]">
                    <!-- icona centrata verticalmente -->
                    <i class="fas fa-search absolute left-3 top-9 text-gray-400"></i>
                  </div>

                  <!-- Scanner -->
                  <div class="relative w-[calc(50%-0.375rem)] sm:w-auto min-w-[160px]">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Scanner</label>
                    <button onclick="startScanner()"
                      class="w-full font-bold py-2 px-4 rounded bg-gray-200 text-black hover:bg-gray-600 hover:text-white">
                      <i class="fas fa-expand"></i>
                    </button>
                  </div>

                  <!-- MODALE SCANNER -->
                  <div id="scanner-modal"
                    class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
                    <div class="bg-white rounded-lg shadow-lg p-6 relative w-full max-w-md mx-3">
                      <button onclick="chiudiScanner()"
                        class="absolute top-2 right-2 text-gray-600 hover:text-gray-900">
                        <i class="fas fa-times"></i>
                      </button>
                      <h2 class="text-lg font-semibold mb-4">Scanner QR / Barcode</h2>
                      <div id="reader" style="width: 100%;"></div>
                    </div>
                  </div>

                  <!-- Stato -->
                  <div class="w-[calc(50%-0.375rem)] sm:w-auto min-w-[220px]">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Stato</label>
                    <select id="statusFilter"
                      class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]">
                      <option>Tutti</option>
                      <option>Riparato</option>
                      <option>In magazzino</option>
                      <option>Installato</option>
                      <option>Destinato</option>
                      <option>Assegnato</option>
                      <option>In attesa</option>
                      <option>Guasto</option>
                      <option>Non Riparato</option>
                      <option>Non Riparabile</option>
                    </select>
                  </div>

                  <!-- Marca -->
                  <div class="w-[calc(50%-0.375rem)] sm:w-auto min-w-[220px]">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Marca</label>
                    <select id="brandFilter"
                      class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]">
                      <option>Tutte</option>
                      <% String ruoloUtenteLoggato=(String) session.getAttribute("ruolo"); List<String> marche = (List
                        <String>) request.getAttribute("marche");
                          if (marche != null)
                          for (String marca : marche) {
                          %>
                          <option value="<%= marca %>">
                            <%= marca %>
                          </option>
                          <% } %>
                    </select>
                  </div>

                  <!-- Data ricezione -->
                  <div class="w-[calc(50%-0.375rem)] sm:w-auto min-w-[200px]">
                    <label class="block text-sm font-medium text-gray-700 mb-1">Data ricezione</label>
                    <input id="dateFilter" type="date"
                      class="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]">
                  </div>

                  <!-- I miei articoli -->
                  <button onclick="aggiornaNome(this)" id="Articoli-personali"
                    class="w-full sm:w-auto mt-2 sm:mt-6 bg-gray-100 hover:bg-gray-200 text-gray-800 px-4 py-2 rounded-lg">
                    <i class="fas fa-box mr-2"></i> I Miei Articoli
                  </button>

                  <input id="installatiCheck" name="installatiCheck" value="indefinito" class="hidden">

                  <!-- Toggle installati -->
                  <button id="toggleInstallati"
                    class="w-full sm:w-auto mt-2 sm:mt-6 bg-gray-100 hover:bg-gray-200 text-gray-800 px-4 py-2 rounded-lg">
                    <i id="iconToggle" class="fas fa-eye-slash mr-2"></i>
                    <span id="textToggle">Mostra Installati</span>
                  </button>

                  <!-- Toggle ordinamento -->
                  <button id="toggleOrdinamento"
                    class="w-full sm:w-auto mt-2 sm:mt-6 bg-gray-100 hover:bg-gray-200 text-gray-800 px-4 py-2 rounded-lg">
                    <i id="iconOrdinamento" class="fas fa-clock mr-2"></i>
                    <span id="textOrdinamento">Ultima Modifica</span>
                  </button>

                  <!-- Reset -->
                  <button
                    class="w-full sm:w-auto mt-2 sm:mt-6 bg-[#fce5e3] hover:bg-[#f8b4b0] text-[#e52c1f] px-4 py-2 rounded-lg"
                    onclick="resetta()">
                    <i class="fas fa-sync-alt mr-2"></i> Reset
                  </button>

                  <!-- (questo reader extra resta, ho solo reso il contenitore responsive) -->
                  <div id="reader" style="width: 100%; max-width: 300px;"></div>

                </div>
              </div>

              <!-- COUNTERS -->
              <% ListaArticoli ls=new ListaArticoli(); %>
                <section id="statsBar" aria-live="polite" role="region"
                  class="mt-2 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6 gap-2">

                  <!-- Totale trovati -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-slate-100 to-white
              border border-slate-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px]">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-slate-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-layer-group text-slate-500"></i> Articoli trovati
                    </span>
                    <span id="count-total" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-slate-500 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- In attesa -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-yellow-50 to-white
              border border-yellow-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=In%20attesa'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-yellow-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-hourglass-half text-yellow-500"></i> In Attesa
                    </span>
                    <span id="count-In_attesa" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-yellow-500 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- In magazzino -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-green-50 to-white
              border border-green-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=In%20magazzino'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-green-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-warehouse text-green-500"></i> In Magazzino
                    </span>
                    <span id="count-In_magazzino" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-green-500 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- Installati -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-violet-50 to-white
              border border-violet-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=Installato'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-violet-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-plug text-violet-500"></i> Installati
                    </span>
                    <span id="count-Installato" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-violet-500 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- Destinati -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-sky-50 to-white
              border border-sky-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=Destinato'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-sky-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-location-arrow text-sky-500"></i> Destinati
                    </span>
                    <span id="count-Destinato" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-sky-500 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- Assegnati -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-sky-50 to-white
              border border-sky-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=Assegnato'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-sky-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-user-check text-sky-500"></i> Assegnati
                    </span>
                    <span id="count-Assegnato" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-sky-600 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- Guasti -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-red-50 to-white
              border border-red-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=Guasto'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-red-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-exclamation-triangle text-red-600"></i> Guasti
                    </span>
                    <span id="count-Guasto" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-red-600 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- Riparati -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-blue-50 to-white
              border border-blue-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=Riparato'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-blue-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-wrench text-blue-500"></i> Riparati
                    </span>
                    <span id="count-Riparato" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-blue-500 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- Non Riparati -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-orange-50 to-white
              border border-orange-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=Non%20Riparato'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-orange-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-times-circle text-orange-500"></i> Non Riparati
                    </span>
                    <span id="count-Non_Riparato" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-orange-500 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>

                  <!-- Non Riparabili -->
                  <div class="flex items-center justify-between rounded-xl bg-gradient-to-r from-gray-50 to-white
              border border-gray-200 shadow px-3 py-2 sm:px-3 sm:py-2 min-h-[52px] cursor-pointer"
                    onclick="window.location.href='dashboard?stato=Non%20Riparabile'">
                    <span
                      class="text-[13px] sm:text-sm font-semibold text-gray-900 flex items-center gap-2 whitespace-nowrap">
                      <i class="fas fa-trash-alt text-gray-600"></i> Non Riparabili
                    </span>
                    <span id="count-Non_Riparabile" class="inline-flex items-center justify-center min-w-8 h-6 sm:min-w-10 sm:h-7 px-2 rounded-full
                 bg-gray-600 text-white shadow-md text-[12px] sm:text-sm">0</span>
                  </div>
                </section>

                <br><br><br>

                <!-- Articles Grid -->
                <div id="risultati"
                  class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 2xl:grid-cols-5 gap-6 p-2">
                  <%@ include file="partials/risultati.jsp" %>
                </div>



            </main>




            <!-- POPOLAMENTO SUGGERIMENTI -->
            <datalist id="suggerimentiMarche">
              <% if (marche !=null) for (String marca : marche) { %>
                <option value="<%= marca %>">
                  <%= marca %>
                </option>
                <% } %>
            </datalist>
            <!--  <datalist id="suggerimentiFornitore">
		    
		</datalist>-->
            <datalist id="suggerimentiCompatibilita">
              <% List<String> compatibilita = (List<String>) request.getAttribute("compatibilita");
                  if (compatibilita != null)
                  for (String compatibilit : compatibilita) {
                  %>
                  <option value="<%= compatibilit %>">
                    <%= compatibilit %>
                  </option>
                  <% } %>
            </datalist>

            <datalist id="suggerimentiProvenienza">
              <% List<String> provenienze = (List<String>) request.getAttribute("provenienze");
                  if (provenienze != null)
                  for (String provenienza : provenienze) {
                  %>
                  <option value="<%= provenienza %>">
                    <%= provenienza %>
                  </option>
                  <% }else System.out.println("VUOTA PROVENIENZA"); %>
            </datalist>
            <datalist id="suggerimentiPv">
              <% List<String> pvs = (List<String>) request.getAttribute("pvs");
                  if (pvs != null)
                  for (String pv : pvs) {
                  %>
                  <option value="<%= pv %>">
                    <%= pv %>
                  </option>
                  <% } %>
            </datalist>
            <datalist id="suggerimentiNome">
              <% List<String> nomi = (List<String>) request.getAttribute("nomi");
                  if (nomi != null)
                  for (String nome : nomi) {
                  %>
                  <option value="<%= nome %>">
                    <%= nome %>
                  </option>
                  <% } %>
            </datalist>

            <!-- Add Article Modal -->
            <div id="article-modal"
              class="modal fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
              <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl max-h-[90vh] overflow-y-auto fade-in">

                <div class="flex justify-between items-center border-b px-6 py-4">
                  <h3 id="modal-title" class="text-lg font-semibold">Aggiungi Nuovo Articolo</h3>
                  <button id="close-modal" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                  </button>
                </div>
                <div class="p-6">
                  <form id="article-form" action="articolo" method="post" autocomplete="off">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="id" id="formId"> <!-- Solo per update -->

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                      <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Stato*</label>
                        <select id="statoInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="stato" required>
                          <option value="">Seleziona stato</option>
                          <option value="Riparato">Riparato</option>
                          <option value="In magazzino">In magazzino</option>
                          <option value="Installato">Installato</option>
                          <option value="Destinato">Destinato</option>
                          <option value="Assegnato">Assegnato</option>
                          <option value="In attesa">In attesa</option>
                          <option value="Guasto">Guasto</option>
                          <option value="Non riparato">Non riparato</option>
                          <option value="Non riparabile">Non riparabile</option>
                        </select>
                      </div>

                      <div id="divAssegnaAMe" style="display: none;">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Assegna A Me</label>
                        <input type="hidden" name="nomeCognome" value="<%= session.getAttribute(" nomeCognome") %>" />
                        <input type="hidden" name="username" value="<%= session.getAttribute(" username") %>" />

                        <button id="assegnaInput" type="submit" name="assegnaAction" value="assegna"
                          class="px-4 py-2 border rounded-lg hover:bg-gray-100"><i class="fas fa-box"></i> Assegna a
                          me</button>
                      </div>

                      <div id="divNome">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Nome articolo*</label>
                        <input type="text" id="nomeInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="nome" list="suggerimentiNome" required>
                      </div>
                      <div id="divMarca">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Marca*</label>
                        <input type="text" id="marcaInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="marca" list="suggerimentiMarche" required>
                        <!-- Indicatore stato immagine -->
                        <span id="imageStatus" class="text-xs mt-1 block hidden">
                          <i id="imageStatusIcon" class="fas fa-image mr-1"></i>
                          <span id="imageStatusText"></span>
                        </span>
                        <!-- Pulsante Upload (appare solo se immagine non trovata) -->
                        <div id="imageUploadContainer" class="mt-2 hidden">
                          <div class="flex gap-2 flex-wrap">
                            <!-- Pulsante Scatta Foto -->
                            <label
                              class="cursor-pointer inline-flex items-center px-3 py-1.5 bg-blue-50 hover:bg-blue-100 rounded-lg text-sm text-blue-700 border border-blue-300">
                              <i class="fas fa-camera mr-2"></i>
                              <span>Scatta foto</span>
                              <input type="file" id="imageCameraInput" accept="image/*" capture="environment"
                                class="hidden">
                            </label>
                            <!-- Pulsante Carica da Galleria -->
                            <label
                              class="cursor-pointer inline-flex items-center px-3 py-1.5 bg-gray-100 hover:bg-gray-200 rounded-lg text-sm text-gray-700 border border-dashed border-gray-400">
                              <i class="fas fa-images mr-2"></i>
                              <span>Galleria</span>
                              <input type="file" id="imageGalleryInput" accept="image/*" class="hidden">
                            </label>
                          </div>
                          <div id="imageSelectedInfo" class="text-xs text-green-600 mt-1 hidden">
                            <i class="fas fa-check-circle mr-1"></i>
                            <span id="imageFileName"></span>
                          </div>
                          <img id="imagePreview" class="mt-2 max-h-20 rounded hidden" alt="Preview">
                        </div>
                      </div>
                      <div id="divComp">

                        <label class="block text-sm font-medium text-gray-700 mb-1">Compatibilità</label>
                        <input type="text" id="compatibilitaInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="compatibilita" list="suggerimentiCompatibilita">
                      </div>
                      <div id="divMatricola">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Matricola</label>
                        <div class="flex gap-2">
                          <input type="text" id="matricolaInput"
                            class="flex-1 border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                            name="matricola">
                          <button type="button" onclick="startMatricolaScanner()"
                            class="px-3 py-2 bg-gray-200 hover:bg-gray-600 hover:text-white rounded-lg"
                            title="Scansiona Matricola">
                            <i class="fas fa-expand"></i>
                          </button>
                        </div>
                      </div>
                      <!-- MODALE SCANNER MATRICOLA -->
                      <div id="matricola-scanner-modal"
                        class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[60] hidden">
                        <div class="bg-white rounded-lg shadow-lg p-6 relative w-full max-w-md mx-3">
                          <button type="button" onclick="chiudiMatricolaScanner()"
                            class="absolute top-2 right-2 text-gray-600 hover:text-gray-900">
                            <i class="fas fa-times"></i>
                          </button>
                          <h2 class="text-lg font-semibold mb-4">Scansiona Matricola</h2>
                          <div id="readerMatricola" style="width: 100%;"></div>
                        </div>
                      </div>
                      <div id="divProvenienza">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Provenienza</label>
                        <input type="text" id="provenienzaInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="provenienza" list="suggerimentiProvenienza">
                      </div>
                      <div id="divPv">
                        <label class="block text-sm font-medium text-gray-700 mb-1">P.V. Di Destinazione</label>
                        <input type="text" id="pvInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="pv" list="suggerimentiPv">
                      </div>
                      <div id="divTecnico">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Tecnico</label>
                        <select id="tecnicoInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="tecnico">
                          <option value="">Seleziona Tecnico</option>
                          <% List<String> tecnici = (List<String>) request.getAttribute("tecnici");
                              if (tecnici != null) {
                              for (String tecnico : tecnici) {
                              %>
                              <option value="<%= tecnico %>">
                                <%= tecnico %>
                              </option>
                              <% } } %>
                        </select>
                      </div>

                      <div id="divDataspe">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Data spedizione</label>
                        <input type="date" id="dataspeInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="dataSpe_DDT">
                      </div>
                      <div id="divDdtSpedizione">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Ddt Spedizione</label>
                        <input type="number" id="ddtSpedizioneInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="ddtSpedizione">
                      </div>
                      <div id="divDataric">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Data rientro</label>
                        <input type="date" id="dataricInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="dataRic_DDT">
                      </div>
                      <div id="divDdt">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Ddt Rientro</label>
                        <input type="number" id="ddtInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="ddt">
                      </div>

                      <div id="divFornitore">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Centro Per Revisione</label>
                        <select id="fornitoreInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="fornitore">
                          <option value="">Seleziona Centro</option>
                          <% List<String> fornitori = (List<String>) request.getAttribute("fornitori");
                              if (fornitori != null) {
                              for (String fornitore : fornitori) {
                              %>
                              <option value="<%= fornitore %>">
                                <%= fornitore %>
                              </option>
                              <% } } %>
                        </select>

                      </div>



                      <div id="divDatagar">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Data Garanzia</label>

                        <input type="date" id="datagarInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          name="dataGaranzia">
                        <div class="checkbox-wrapper-10">
                          <label class="block text-sm font-medium text-gray-700 mb-1">Richiesta Garanzia</label>
                          <input type="checkbox" name="checkGaranzia" id="richiestaInput" class="tgl tgl-flip"
                            value="SI">
                          <label for="richiestaInput" data-tg-on="SI" data-tg-off="NO" class="tgl-btn"></label>

                        </div>

                      </div>



                      <div class="md:col-span-2" id="divNote">
                        <label class="block text-sm font-medium text-gray-700 mb-1">Note</label>
                        <textarea id="noteInput"
                          class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]"
                          rows="3" name="note"></textarea>
                      </div>
                    </div>

                    <div class="mt-6 flex justify-end space-x-3">
                      <button type="button" id="cancel-btn" class="px-4 py-2 border rounded-lg hover:bg-gray-100">
                        Annulla
                      </button>
                      <button type="submit" class="bg-[#e52c1f] hover:bg-[#c5271b] text-white px-4 py-2 rounded-lg">
                        Salva Articolo
                      </button>
                    </div>
                  </form>


                </div>
              </div>
            </div>


            <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

            <!-- SCRIPT AJAX -->
            <script>
	<%
                UserService users = new UserService();
		String username = (String) session.getAttribute("username");
		
	%>
	var nomeCompletoUtente = "";
              function aggiornaNome(button) {
                nomeCompletoUtente = "<%=users.getNomeCognome(username)%>";
                button.classList.remove("bg-gray-100", "hover:bg-gray-200");
                button.classList.add("bg-gray-200", "hover:bg-gray-300");
              }
              $(document).ready(function () {
                const params = new URLSearchParams(window.location.search);
                const search = params.get("search");
                const stato = params.get("stato");

                if (search) {
                  document.getElementById("searchInput").value = search; // imposta il valore nell'input
                }
                if (stato) {
                  document.getElementById("statusFilter").value = stato; // imposta il valore nell'input
                }

                aggiornaArticoli(); // viene chiamata una sola volta, dopo che #searchInput è settato
              });

              function aggiornaArticoli() {

                var search = $("#searchInput").val();
                var marca = $("#brandFilter").val();
                var stato = $("#statusFilter").val();
                var data = $("#dateFilter").val();

                /* Stampo in console
                   console.log("Dati inviati:");
                   console.log("Search: " + search);
                   console.log("Marca: " + marca);
                   console.log("Stato: " + stato);
                   console.log("Data: " + data);
                   console.log("Nome: " + nomeCompletoUtente);*/

                $.get("filtro", {
                  search: search,
                  marca: marca,
                  stato: stato,
                  data: data,
                  nome: nomeCompletoUtente,
                  installatiCheck: $("#installatiCheck").val() // <-- aggiunto qui!
                }, function (data) {
                  $("#risultati").html(data);
                  // Applica ordinamento se alfabetico
                  if (ordinamentoCorrente === "alfabetico") {
                    ordinaAlfabetico();
                  }
                  if (ruoloUtente === "Tecnico") {
                    $(".delete-btn").hide();
                    console.log("Pulsanti delete nascosti per il ruolo Tecnico");
                  } else $(".assegnaButton").hide();
                });
              }
              $("#Articoli-personali").on("click", aggiornaArticoli);
              $("#searchInput").on("input", aggiornaArticoli);
              $("#brandFilter").on("change", aggiornaArticoli);
              $("#statusFilter").on("change", aggiornaArticoli);
              $("#dateFilter").on("change", aggiornaArticoli);

              // ORDINAMENTO
              var ordinamentoCorrente = "modifica"; // default

              $("#toggleOrdinamento").on("click", function () {
                if (ordinamentoCorrente === "modifica") {
                  ordinamentoCorrente = "alfabetico";
                  $("#iconOrdinamento").removeClass("fa-clock").addClass("fa-sort-alpha-down");
                  $("#textOrdinamento").text("A-Z");
                  ordinaAlfabetico();
                } else {
                  ordinamentoCorrente = "modifica";
                  $("#iconOrdinamento").removeClass("fa-sort-alpha-down").addClass("fa-clock");
                  $("#textOrdinamento").text("Ultima Modifica");
                  aggiornaArticoli(); // ricarica dal server (già ordinato per modifica)
                }
              });

              function ordinaAlfabetico() {
                var $container = $("#risultati");
                var $cards = $container.children(".article-card:visible").detach();
                $cards.sort(function (a, b) {
                  var nomeA = ($(a).data("nome") || "").toLowerCase();
                  var nomeB = ($(b).data("nome") || "").toLowerCase();
                  return nomeA.localeCompare(nomeB);
                });
                $container.prepend($cards);
              }
            </script>
            <script>

              const ruoloUtente = "<%= ruoloUtenteLoggato %>";
              const form = document.getElementById("hiddenForm");
              const modal = document.getElementById('article-modal');

              //const addBtn = document.getElementById('add-article-btn');
              const closeBtn = document.getElementById('close-modal');
              const cancelBtn = document.getElementById('cancel-btn');

              document.getElementById("toggleInstallati").addEventListener("click", function () {
                const icon = document.getElementById("iconToggle");
                const text = document.getElementById("textToggle");
                const isEyeOpen = icon.classList.contains("fa-eye");

                icon.classList.toggle("fa-eye");
                icon.classList.toggle("fa-eye-slash");
                text.textContent = isEyeOpen ? "Mostra Installati" : "Nascondi Installati";

                const input = document.getElementById("installatiCheck");
                input.value = (input.value === "mostra") ? "nascondi" : "mostra";
                aggiornaArticoli();
              });


              closeBtn.addEventListener('click', function () {
                modal.classList.add('hidden');
              });

              cancelBtn.addEventListener('click', function () {
                modal.classList.add('hidden');
              });

              // === CHECK IMMAGINE REAL-TIME + UPLOAD ===
              let imageCheckTimeout = null;
              let pendingImageFile = null; // File da uploadare al submit

              function checkImmagineArticolo() {
                const nome = document.getElementById('nomeInput').value.trim();
                const marca = document.getElementById('marcaInput').value.trim();
                const statusSpan = document.getElementById('imageStatus');
                const statusIcon = document.getElementById('imageStatusIcon');
                const statusText = document.getElementById('imageStatusText');
                const uploadContainer = document.getElementById('imageUploadContainer');

                // Nascondi tutto se campi vuoti
                if (!nome || !marca) {
                  statusSpan.classList.add('hidden');
                  uploadContainer.classList.add('hidden');
                  return;
                }

                // Debounce 300ms
                clearTimeout(imageCheckTimeout);
                imageCheckTimeout = setTimeout(function () {
                  $.get('api/check-image', { nome: nome, marca: marca }, function (response) {
                    statusSpan.classList.remove('hidden');
                    if (response.found) {
                      statusSpan.className = 'text-xs mt-1 block text-green-600';
                      statusIcon.className = 'fas fa-check-circle mr-1';
                      statusText.textContent = 'Immagine trovata';
                      uploadContainer.classList.add('hidden');
                    } else {
                      statusSpan.className = 'text-xs mt-1 block text-gray-500';
                      statusIcon.className = 'fas fa-image mr-1';
                      statusText.textContent = 'Nessuna immagine';
                      uploadContainer.classList.remove('hidden');
                    }
                  }).fail(function () {
                    statusSpan.classList.add('hidden');
                    uploadContainer.classList.add('hidden');
                  });
                }, 300);
              }

              // Handler per immagine selezionata (sia camera che gallery)
              function handleImageSelect(e) {
                const file = e.target.files[0];
                const preview = document.getElementById('imagePreview');
                const fileInfo = document.getElementById('imageSelectedInfo');
                const fileName = document.getElementById('imageFileName');

                if (file) {
                  pendingImageFile = file;
                  preview.src = URL.createObjectURL(file);
                  preview.classList.remove('hidden');
                  fileInfo.classList.remove('hidden');
                  fileName.textContent = file.name.substring(0, 25) + (file.name.length > 25 ? '...' : '');
                } else {
                  pendingImageFile = null;
                  preview.classList.add('hidden');
                  fileInfo.classList.add('hidden');
                }
              }

              // Listener per entrambi gli input
              document.getElementById('imageCameraInput').addEventListener('change', handleImageSelect);
              document.getElementById('imageGalleryInput').addEventListener('change', handleImageSelect);

              // Override form submit per upload immagine prima
              document.getElementById('article-form').addEventListener('submit', function (e) {
                if (pendingImageFile) {
                  e.preventDefault();
                  const nome = document.getElementById('nomeInput').value.trim();
                  const marca = document.getElementById('marcaInput').value.trim();

                  const formData = new FormData();
                  formData.append('image', pendingImageFile);
                  formData.append('nome', nome);
                  formData.append('marca', marca);

                  // Upload immagine
                  $.ajax({
                    url: 'api/upload-image',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (response) {
                      pendingImageFile = null;
                      // Ora submit il form normalmente
                      document.getElementById('article-form').submit();
                    },
                    error: function (xhr) {
                      alert('Errore upload immagine: ' + (xhr.responseJSON?.error || 'Errore sconosciuto'));
                    }
                  });
                }
              });

              // Listener sui campi nome e marca
              document.getElementById('nomeInput').addEventListener('input', checkImmagineArticolo);
              document.getElementById('marcaInput').addEventListener('input', checkImmagineArticolo);

              // Reset quando si apre il modal
              document.getElementById('add-article-btn').addEventListener('click', function () {
                document.getElementById('imageStatus').classList.add('hidden');
                document.getElementById('imageUploadContainer').classList.add('hidden');
                document.getElementById('imagePreview').classList.add('hidden');
                document.getElementById('imageSelectedInfo').classList.add('hidden');
                document.getElementById('imageCameraInput').value = '';
                document.getElementById('imageGalleryInput').value = '';
                pendingImageFile = null;
              });

              function resetta() {
                document.getElementById('searchInput').value = '';
                document.getElementById('statusFilter').value = 'Tutti';
                document.getElementById('brandFilter').value = 'Tutte';
                document.getElementById('dateFilter').value = '';
                nomeCompletoUtente = "";
                window.history.replaceState(null, "", "dashboard");

                aggiornaArticoli();
              }

              const formId = document.getElementById("form-id");
              const formAction = document.getElementById("form-action");
              //BARCODE
              let html5QrCode;

              function startScanner() {
                document.getElementById("scanner-modal").classList.remove("hidden");

                html5QrCode = new Html5Qrcode("reader");

                html5QrCode.start(
                  { facingMode: "environment" },
                  { fps: 10, qrbox: 250 },
                  (decodedText, decodedResult) => {
                    resetta();
                    document.getElementById("searchInput").value = decodedText;
                    aggiornaArticoli();
                    aggiornaArticoli();
                    html5QrCode.stop().then(() => {
                      html5QrCode.clear();
                      chiudiScanner();
                    });
                  },
                  (errorMessage) => {
                  }
                );
              }

              function chiudiScanner() {
                document.getElementById("scanner-modal").classList.add("hidden");
                if (html5QrCode) {
                  html5QrCode.stop().then(() => html5QrCode.clear()).catch((err) => console.error(err));
                }
              }

              // SCANNER MATRICOLA
              let html5QrCodeMatricola;

              function startMatricolaScanner() {
                document.getElementById("matricola-scanner-modal").classList.remove("hidden");
                html5QrCodeMatricola = new Html5Qrcode("readerMatricola");
                html5QrCodeMatricola.start(
                  { facingMode: "environment" },
                  { fps: 10, qrbox: 250 },
                  (decodedText, decodedResult) => {
                    document.getElementById("matricolaInput").value = decodedText;
                    html5QrCodeMatricola.stop().then(() => {
                      html5QrCodeMatricola.clear();
                      chiudiMatricolaScanner();
                    });
                  },
                  (errorMessage) => {
                  }
                );
              }

              function chiudiMatricolaScanner() {
                document.getElementById("matricola-scanner-modal").classList.add("hidden");
                if (html5QrCodeMatricola) {
                  html5QrCodeMatricola.stop().then(() => html5QrCodeMatricola.clear()).catch((err) => console.error(err));
                }
              }
              //PAGINAZIONE PULITA DI SCRIPT
              // Sostituisce il contenitore con l'HTML ricevuto E riesegue tutti i <script> (inline e con src)
              function replaceWithScripts(container, html) {
                const parser = new DOMParser();
                const doc = parser.parseFromString(html, 'text/html');

                // Estrai script dalla risposta
                const newScripts = Array.from(doc.querySelectorAll('script'));
                newScripts.forEach(s => s.parentNode.removeChild(s)); // toglili, li rieseguiremo manualmente

                // Rimpiazza il contenitore con il nuovo markup (senza script)
                container.innerHTML = '';
                Array.from(doc.body.childNodes).forEach(n => container.appendChild(n));

                // Riesegui gli script nell'ordine
                newScripts.forEach(old => {
                  const s = document.createElement('script');
                  // Copia attributi utili
                  if (old.type) s.type = old.type;
                  if (old.src) {
                    s.src = old.src;
                    // Se vuoi garantirti il re-download, togli cache o aggiungi bust:
                    // s.src = old.src + (old.src.includes('?') ? '&' : '?') + '_=' + Date.now();
                    s.async = old.async;
                    s.defer = old.defer;
                  } else {
                    s.textContent = old.textContent;
                  }
                  document.body.appendChild(s); // esegue
                });
              }
              document.addEventListener('click', function (e) {
                const a = e.target.closest('a[data-ajax="risultati"]');
                if (!a) return;

                const container = document.getElementById('risultati'); // ID del div dove inietti la JSP
                if (!container) return; // fallback: lascia navigazione normale

                e.preventDefault();
                fetch(a.href, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
                  .then(r => r.text())
                  .then(html => {
                    replaceWithScripts(container, html);
                    // aspetto che il layout si stabilizzi e poi scrollo il contenitore giusto
                    requestAnimationFrame(() => {
                      requestAnimationFrame(() => {
                        scrollToTopAround(container, true);
                      });
                    });
                  })
                  .catch(console.error);
              });

              function getScrollParent(el) {
                for (let p = el; p && p !== document.body; p = p.parentElement) {
                  const s = getComputedStyle(p);
                  if (/(auto|scroll)/.test(s.overflowY) && p.scrollHeight > p.clientHeight) return p;
                }
                return null;
              }

              function scrollToTopAround(el, smooth = true) {
                const scroller = getScrollParent(el) || document.scrollingElement || document.documentElement;
                const opts = smooth ? { top: 0, behavior: 'smooth' } : { top: 0 };
                if (scroller === document.scrollingElement || scroller === document.documentElement || scroller === document.body) {
                  window.scrollTo(opts);
                } else {
                  scroller.scrollTo(opts);
                }
              }



            </script>
          </body>

          </html>