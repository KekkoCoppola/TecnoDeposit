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
                  <p class="text-gray-600">Gestisci l'inventario</p>
                </div>

                <button id="add-article-btn"
                  class="bg-[#e52c1f] hover:bg-[#c5271b] text-white px-4 py-2 rounded-lg flex items-center">
                  <i class="fas fa-plus mr-2"></i> Aggiungi Articolo
                </button>

              </div>
              <!-- Filters -->
              <div class="bg-white rounded-2xl shadow-md border border-gray-100 p-4 sm:p-6 mb-6">

                <!-- Riga principale: Ricerca + Scanner -->
                <div class="flex flex-col sm:flex-row gap-3 mb-4">
                  <!-- Cerca -->
                  <div class="relative flex-1">
                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none">
                      <i class="fas fa-search text-gray-400"></i>
                    </div>
                    <input id="searchInput" type="text"
                      placeholder="Cerca per nome, matricola, compatibilità, tecnico..." class="w-full pl-11 pr-4 py-3 bg-gray-50 border border-gray-200 rounded-xl text-gray-800 placeholder-gray-400
                             focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
                             transition-all duration-200">
                  </div>

                  <!-- Scanner Button -->
                  <button onclick="startScanner()" class="flex items-center justify-center gap-2 px-5 py-3 bg-gray-800 hover:bg-gray-900 text-white rounded-xl
                           transition-all duration-200 shadow-sm hover:shadow-md min-w-[120px]">
                    <i class="fas fa-qrcode text-lg"></i>
                    <span class="font-medium">Scan</span>
                  </button>
                </div>

                <!-- MODALE SCANNER -->
                <div id="scanner-modal"
                  class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
                  <div class="bg-white rounded-lg shadow-lg p-6 relative w-full max-w-md mx-3">
                    <button onclick="chiudiScanner()" class="absolute top-2 right-2 text-gray-600 hover:text-gray-900">
                      <i class="fas fa-times"></i>
                    </button>
                    <h2 class="text-lg font-semibold mb-4">Scanner QR / Barcode</h2>
                    <div id="reader" style="width: 100%;"></div>
                  </div>
                </div>

                <!-- Griglia Filtri -->
                <div class="grid grid-cols-2 sm:grid-cols-2 md:grid-cols-5 gap-3 mb-4">

                  <!-- Stato -->
                  <div class="col-span-1">
                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5">
                      <i class="fas fa-tag mr-1 text-gray-400"></i>Stato
                    </label>
                    <select id="statusFilter" class="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2.5 text-gray-700 text-sm
                             focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
                             transition-all duration-200 cursor-pointer appearance-none
                             bg-[url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27%236b7280%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e')]
                             bg-[length:1.25rem] bg-[right_0.5rem_center] bg-no-repeat pr-8">
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
                  <div class="col-span-1">
                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5">
                      <i class="fas fa-industry mr-1 text-gray-400"></i>Marca
                    </label>
                    <select id="brandFilter" class="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2.5 text-gray-700 text-sm
                             focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
                             transition-all duration-200 cursor-pointer appearance-none
                             bg-[url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27%236b7280%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e')]
                             bg-[length:1.25rem] bg-[right_0.5rem_center] bg-no-repeat pr-8">
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

                  <!-- Centro Revisione -->
                  <div class="col-span-1">
                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5">
                      <i class="fas fa-building mr-1 text-gray-400"></i>Centro Rev.
                    </label>
                    <select id="fornitoreFilter" class="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2.5 text-gray-700 text-sm
                             focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
                             transition-all duration-200 cursor-pointer appearance-none
                             bg-[url('data:image/svg+xml;charset=UTF-8,%3csvg xmlns=%27http://www.w3.org/2000/svg%27 viewBox=%270 0 24 24%27 fill=%27none%27 stroke=%27%236b7280%27 stroke-width=%272%27 stroke-linecap=%27round%27 stroke-linejoin=%27round%27%3e%3cpolyline points=%276 9 12 15 18 9%27%3e%3c/polyline%3e%3c/svg%3e')]
                             bg-[length:1.25rem] bg-[right_0.5rem_center] bg-no-repeat pr-8">
                      <option>Tutti</option>
                      <% List<String> fornitoriList = (List<String>) request.getAttribute("fornitori");
                          if (fornitoriList != null)
                          for (String fornitoreItem : fornitoriList) {
                          %>
                          <option value="<%= fornitoreItem %>">
                            <%= fornitoreItem %>
                          </option>
                          <% } %>
                    </select>
                  </div>

                  <!-- Data ricezione -->
                  <div class="col-span-2 sm:col-span-1">
                    <label class="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5">
                      <i class="fas fa-calendar-alt mr-1 text-gray-400"></i>Data
                    </label>
                    <input id="dateFilter" type="date" class="w-full bg-gray-50 border border-gray-200 rounded-xl px-3 py-2.5 text-gray-700 text-sm
                             focus:outline-none focus:ring-2 focus:ring-[#e52c1f] focus:border-transparent focus:bg-white
                             transition-all duration-200">
                  </div>

                  <!-- Reset (nella griglia su mobile) -->
                  <div class="col-span-2 sm:col-span-1 flex items-end">
                    <button
                      class="w-full flex items-center justify-center gap-2 px-4 py-2.5 bg-red-50 hover:bg-red-100 
                             text-[#e52c1f] rounded-xl border border-red-200 transition-all duration-200 text-sm font-medium"
                      onclick="resetta()">
                      <i class="fas fa-undo-alt"></i>
                      <span>Reset</span>
                    </button>
                  </div>
                </div>

                <input id="installatiCheck" name="installatiCheck" value="indefinito" class="hidden">

                <!-- Azioni rapide -->
                <div class="flex flex-wrap gap-2">
                  <!-- I miei articoli -->
                  <button onclick="aggiornaNome(this)" id="Articoli-personali" class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 hover:border-gray-300 
                           hover:bg-gray-50 text-gray-700 rounded-xl transition-all duration-200 text-sm font-medium
                           shadow-sm hover:shadow">
                    <i class="fas fa-user-circle text-[#e52c1f]"></i>
                    <span>I Miei</span>
                  </button>

                  <!-- Toggle installati -->
                  <button id="toggleInstallati" class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 hover:border-gray-300 
                           hover:bg-gray-50 text-gray-700 rounded-xl transition-all duration-200 text-sm font-medium
                           shadow-sm hover:shadow">
                    <i id="iconToggle" class="fas fa-eye-slash text-violet-500"></i>
                    <span id="textToggle">Installati</span>
                  </button>

                  <!-- Toggle ordinamento -->
                  <button id="toggleOrdinamento" class="inline-flex items-center gap-2 px-4 py-2 bg-white border border-gray-200 hover:border-gray-300 
                           hover:bg-gray-50 text-gray-700 rounded-xl transition-all duration-200 text-sm font-medium
                           shadow-sm hover:shadow">
                    <i id="iconOrdinamento" class="fas fa-clock text-blue-500"></i>
                    <span id="textOrdinamento">Recenti</span>
                  </button>
                </div>

                <!-- Reader extra nascosto -->
                <div id="reader" style="width: 100%; max-width: 300px; display: none;"></div>

              </div>

              <!-- COUNTERS -->
              <% ListaArticoli ls=new ListaArticoli(); %>

                <!-- Container scrollabile su mobile -->
                <div class="overflow-x-auto pb-2 -mx-2 px-2 scrollbar-hide">
                  <section id="statsBar" aria-live="polite" role="region"
                    class="flex gap-2 min-w-max sm:grid sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-10 sm:min-w-0">

                    <!-- Totale trovati -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-slate-200 
                              px-4 py-3 min-w-[90px] hover:border-slate-400 hover:shadow-lg transition-all duration-200">
                      <div class="w-10 h-10 rounded-xl bg-slate-100 flex items-center justify-center mb-2 
                                group-hover:bg-slate-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-layer-group text-slate-600 text-lg"></i>
                      </div>
                      <span id="count-total" class="text-xl font-bold text-slate-800">0</span>
                      <span class="text-[10px] font-medium text-slate-500 uppercase tracking-wide">Trovati</span>
                    </div>

                    <!-- In attesa -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-yellow-200 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-yellow-400 hover:shadow-lg hover:shadow-yellow-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=In%20attesa'">
                      <div class="w-10 h-10 rounded-xl bg-yellow-100 flex items-center justify-center mb-2 
                                group-hover:bg-yellow-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-hourglass-half text-yellow-600 text-lg"></i>
                      </div>
                      <span id="count-In_attesa" class="text-xl font-bold text-yellow-700">0</span>
                      <span class="text-[10px] font-medium text-yellow-600 uppercase tracking-wide">Attesa</span>
                    </div>

                    <!-- In magazzino -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-emerald-200 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-emerald-400 hover:shadow-lg hover:shadow-emerald-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=In%20magazzino'">
                      <div class="w-10 h-10 rounded-xl bg-emerald-100 flex items-center justify-center mb-2 
                                group-hover:bg-emerald-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-warehouse text-emerald-600 text-lg"></i>
                      </div>
                      <span id="count-In_magazzino" class="text-xl font-bold text-emerald-700">0</span>
                      <span class="text-[10px] font-medium text-emerald-600 uppercase tracking-wide">Magazzino</span>
                    </div>

                    <!-- Installati -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-violet-200 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-violet-400 hover:shadow-lg hover:shadow-violet-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=Installato'">
                      <div class="w-10 h-10 rounded-xl bg-violet-100 flex items-center justify-center mb-2 
                                group-hover:bg-violet-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-plug text-violet-600 text-lg"></i>
                      </div>
                      <span id="count-Installato" class="text-xl font-bold text-violet-700">0</span>
                      <span class="text-[10px] font-medium text-violet-600 uppercase tracking-wide">Installati</span>
                    </div>

                    <!-- Destinati -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-sky-200 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-sky-400 hover:shadow-lg hover:shadow-sky-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=Destinato'">
                      <div class="w-10 h-10 rounded-xl bg-sky-100 flex items-center justify-center mb-2 
                                group-hover:bg-sky-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-location-arrow text-sky-600 text-lg"></i>
                      </div>
                      <span id="count-Destinato" class="text-xl font-bold text-sky-700">0</span>
                      <span class="text-[10px] font-medium text-sky-600 uppercase tracking-wide">Destinati</span>
                    </div>

                    <!-- Assegnati -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-cyan-200 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-cyan-400 hover:shadow-lg hover:shadow-cyan-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=Assegnato'">
                      <div class="w-10 h-10 rounded-xl bg-cyan-100 flex items-center justify-center mb-2 
                                group-hover:bg-cyan-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-user-check text-cyan-600 text-lg"></i>
                      </div>
                      <span id="count-Assegnato" class="text-xl font-bold text-cyan-700">0</span>
                      <span class="text-[10px] font-medium text-cyan-600 uppercase tracking-wide">Assegnati</span>
                    </div>

                    <!-- Guasti -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-red-200 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-red-400 hover:shadow-lg hover:shadow-red-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=Guasto'">
                      <div class="w-10 h-10 rounded-xl bg-red-100 flex items-center justify-center mb-2 
                                group-hover:bg-red-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-exclamation-triangle text-red-600 text-lg"></i>
                      </div>
                      <span id="count-Guasto" class="text-xl font-bold text-red-700">0</span>
                      <span class="text-[10px] font-medium text-red-600 uppercase tracking-wide">Guasti</span>
                    </div>

                    <!-- Riparati -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-blue-200 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-blue-400 hover:shadow-lg hover:shadow-blue-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=Riparato'">
                      <div class="w-10 h-10 rounded-xl bg-blue-100 flex items-center justify-center mb-2 
                                group-hover:bg-blue-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-wrench text-blue-600 text-lg"></i>
                      </div>
                      <span id="count-Riparato" class="text-xl font-bold text-blue-700">0</span>
                      <span class="text-[10px] font-medium text-blue-600 uppercase tracking-wide">Riparati</span>
                    </div>

                    <!-- Non Riparati -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-orange-200 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-orange-400 hover:shadow-lg hover:shadow-orange-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=Non%20Riparato'">
                      <div class="w-10 h-10 rounded-xl bg-orange-100 flex items-center justify-center mb-2 
                                group-hover:bg-orange-200 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-times-circle text-orange-600 text-lg"></i>
                      </div>
                      <span id="count-Non_Riparato" class="text-xl font-bold text-orange-700">0</span>
                      <span class="text-[10px] font-medium text-orange-600 uppercase tracking-wide">Non Rip.</span>
                    </div>

                    <!-- Non Riparabili -->
                    <div
                      class="group flex flex-col items-center justify-center rounded-2xl bg-white border-2 border-gray-300 
                              px-4 py-3 min-w-[90px] cursor-pointer hover:border-gray-400 hover:shadow-lg hover:shadow-gray-100 transition-all duration-200"
                      onclick="window.location.href='dashboard?stato=Non%20Riparabile'">
                      <div class="w-10 h-10 rounded-xl bg-gray-200 flex items-center justify-center mb-2 
                                group-hover:bg-gray-300 group-hover:scale-110 transition-all duration-200">
                        <i class="fas fa-ban text-gray-600 text-lg"></i>
                      </div>
                      <span id="count-Non_Riparabile" class="text-xl font-bold text-gray-700">0</span>
                      <span class="text-[10px] font-medium text-gray-500 uppercase tracking-wide">Scartati</span>
                    </div>

                  </section>
                </div>

                <style>
                  .scrollbar-hide::-webkit-scrollbar {
                    display: none;
                  }

                  .scrollbar-hide {
                    -ms-overflow-style: none;
                    scrollbar-width: none;
                  }
                </style>

                <div class="h-4"></div>


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
                          <!-- Pulsante per mostrare le opzioni di modifica immagine -->
                          <button type="button" id="showImageUploadBtn"
                            class="ml-2 text-blue-600 hover:text-blue-800 underline hidden"
                            onclick="document.getElementById('imageUploadContainer').classList.toggle('hidden')">
                            Modifica immagine
                          </button>
                        </span>
                        <!-- Input nascosto per il conteggio articoli condivisi -->
                        <input type="hidden" id="sharedImageCount" value="0">
                        <!-- Pulsante Upload -->
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

            <!-- MODALE CONFERMA MODIFICA IMMAGINE CONDIVISA -->
            <div id="image-confirm-modal"
              class="modal fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-[60] hidden">
              <div class="bg-white rounded-lg shadow-xl w-full max-w-md fade-in">
                <div class="p-6">
                  <div class="flex items-center justify-center mb-4">
                    <div class="w-12 h-12 rounded-full bg-orange-100 flex items-center justify-center">
                      <i class="fas fa-images text-orange-600 text-xl"></i>
                    </div>
                  </div>
                  <h3 class="text-lg font-semibold text-center mb-2">Modifica immagine condivisa</h3>
                  <p id="image-confirm-message" class="text-gray-600 text-center mb-6">
                    Questa immagine è condivisa con altri articoli. Vuoi modificarla per tutti?
                  </p>
                  <div class="flex justify-center space-x-4">
                    <button id="cancel-image-change" type="button"
                      class="px-4 py-2 border rounded-lg hover:bg-gray-100">
                      Annulla
                    </button>
                    <button id="confirm-image-change" type="button"
                      class="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg">
                      <i class="fas fa-check mr-1"></i> Modifica per tutti
                    </button>
                  </div>
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
                var fornitore = $("#fornitoreFilter").val();
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
                  fornitore: fornitore,
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
              $("#fornitoreFilter").on("change", aggiornaArticoli);
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
                const showUploadBtn = document.getElementById('showImageUploadBtn');
                const sharedCountInput = document.getElementById('sharedImageCount');

                // Nascondi tutto se campi vuoti
                if (!nome || !marca) {
                  statusSpan.classList.add('hidden');
                  uploadContainer.classList.add('hidden');
                  showUploadBtn.classList.add('hidden');
                  sharedCountInput.value = '0';
                  return;
                }

                // Debounce 300ms
                clearTimeout(imageCheckTimeout);
                imageCheckTimeout = setTimeout(function () {
                  $.get('api/check-image', { nome: nome, marca: marca }, function (response) {
                    statusSpan.classList.remove('hidden');
                    // Salva il conteggio degli articoli condivisi
                    sharedCountInput.value = response.count || 0;

                    if (response.found) {
                      statusSpan.className = 'text-xs mt-1 block text-green-600';
                      statusIcon.className = 'fas fa-check-circle mr-1';
                      statusText.textContent = 'Immagine trovata';
                      // Nascondi container upload ma mostra pulsante per modificare
                      uploadContainer.classList.add('hidden');
                      showUploadBtn.classList.remove('hidden');
                    } else {
                      statusSpan.className = 'text-xs mt-1 block text-gray-500';
                      statusIcon.className = 'fas fa-image mr-1';
                      statusText.textContent = 'Nessuna immagine';
                      uploadContainer.classList.remove('hidden');
                      showUploadBtn.classList.add('hidden');
                    }
                  }).fail(function () {
                    statusSpan.classList.add('hidden');
                    uploadContainer.classList.add('hidden');
                    showUploadBtn.classList.add('hidden');
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
                  const sharedCount = parseInt(document.getElementById('sharedImageCount').value) || 0;

                  // Se l'immagine è condivisa con più articoli, mostra modal di conferma
                  if (sharedCount > 1) {
                    // Aggiorna messaggio nel modal
                    document.getElementById('image-confirm-message').innerHTML =
                      'Questa immagine è condivisa con <strong>' + sharedCount + ' articoli</strong> con stesso nome e marca.<br><br>Vuoi modificarla per tutti?';
                    // Mostra modal
                    document.getElementById('image-confirm-modal').classList.remove('hidden');
                    return;
                  }

                  // Se non condivisa o già confermato, procedi con upload
                  eseguiUploadImmagine(nome, marca);
                }
              });

              // Handler conferma modifica immagine
              document.getElementById('confirm-image-change').addEventListener('click', function () {
                document.getElementById('image-confirm-modal').classList.add('hidden');
                const nome = document.getElementById('nomeInput').value.trim();
                const marca = document.getElementById('marcaInput').value.trim();

                console.log('🔍 Conferma cliccata. pendingImageFile:', pendingImageFile);

                if (!pendingImageFile) {
                  console.error('❌ pendingImageFile è null! Impossibile procedere.');
                  alert('Errore: nessun file immagine selezionato.');
                  return;
                }

                eseguiUploadImmagine(nome, marca);
              });

              // Handler annulla modifica immagine
              document.getElementById('cancel-image-change').addEventListener('click', function () {
                document.getElementById('image-confirm-modal').classList.add('hidden');
                // Resetta il file selezionato
                pendingImageFile = null;
                document.getElementById('imagePreview').classList.add('hidden');
                document.getElementById('imageSelectedInfo').classList.add('hidden');
                document.getElementById('imageCameraInput').value = '';
                document.getElementById('imageGalleryInput').value = '';
              });

              // Click fuori dal modal lo chiude
              document.getElementById('image-confirm-modal').addEventListener('click', function (e) {
                if (e.target === this) {
                  document.getElementById('cancel-image-change').click();
                }
              });

              // Funzione per eseguire l'upload dell'immagine
              function eseguiUploadImmagine(nome, marca) {
                console.log('📷 Inizio upload immagine per:', nome, marca);
                console.log('📦 File da caricare:', pendingImageFile);

                if (!pendingImageFile) {
                  console.error('❌ Nessun file da caricare!');
                  alert('Errore: nessun file immagine da caricare.');
                  return;
                }

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
                    console.log('✅ Upload completato:', response);
                    pendingImageFile = null;
                    // Ora submit il form normalmente
                    document.getElementById('article-form').submit();
                  },
                  error: function (xhr) {
                    console.error('❌ Errore upload:', xhr);
                    alert('Errore upload immagine: ' + (xhr.responseJSON?.error || 'Errore sconosciuto'));
                  }
                });
              }

              // Listener sui campi nome e marca
              document.getElementById('nomeInput').addEventListener('input', checkImmagineArticolo);
              document.getElementById('marcaInput').addEventListener('input', checkImmagineArticolo);

              // Reset quando si apre il modal
              document.getElementById('add-article-btn').addEventListener('click', function () {
                document.getElementById('imageStatus').classList.add('hidden');
                document.getElementById('imageUploadContainer').classList.add('hidden');
                document.getElementById('showImageUploadBtn').classList.add('hidden');
                document.getElementById('sharedImageCount').value = '0';
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
                document.getElementById('fornitoreFilter').value = 'Tutti';
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