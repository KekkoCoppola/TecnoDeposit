<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Articolo" %>
<%@ page import="model.ListaArticoli" %>
<%@ page import="java.util.List" %>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Articoli</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .fade-in {
            animation: fadeIn 0.3s ease-in-out;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .sidebar {
            transition: all 0.3s ease;
        }
        
        .sidebar.collapsed {
            width: 70px;
        }
        
        .sidebar.collapsed .sidebar-text {
            display: none;
        }
        
        .sidebar.collapsed .logo-text {
            display: none;
        }
        
        .sidebar.collapsed .nav-item {
            justify-content: center;
        }
        
        .article-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
        }
        
        .modal {
            transition: opacity 0.3s ease;
        }
        
        .status-badge {
            font-size: 0.7rem;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
        }
        
        .status-riparato { background-color: #3b82f6; color: white; }
        .status-in-magazzino { background-color: #10b981; color: white; }
        .status-installato { background-color: #8b5cf6; color: white; }
        .status-destinato { background-color: #098edb; color: white; }
        .status-assegnato { background-color: #098edb; color: white; }
        .status-in-attesa { background-color: #eba834; color: white; }
        .status-guasto { background-color: #6e0303; color: white; }

        /* Profile dropdown styles */
        .profile-dropdown {
            display: none;
            position: absolute;
            right: 0;
            top: 100%;
            margin-top: 0.5rem;
            min-width: 200px;
            background-color: white;
            border-radius: 0.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            z-index: 50;
            overflow: hidden;
        }

        .profile-dropdown.show {
            display: block;
            animation: fadeIn 0.2s ease-out;
        }

        .profile-dropdown-item {
            padding: 0.75rem 1rem;
            display: flex;
            align-items: center;
            color: #4b5563;
            transition: all 0.2s;
        }

        .profile-dropdown-item:hover {
            background-color: #f9fafb;
            color: #1f2937;
        }

        .profile-dropdown-item i {
            margin-right: 0.75rem;
            width: 20px;
            text-align: center;
        }

        .profile-dropdown-divider {
            height: 1px;
            background-color: #e5e7eb;
            margin: 0.25rem 0;
        }
    </style>
</head>
<body class="bg-gray-50 font-sans">
    <div class="flex h-screen overflow-hidden">
        <!-- Sidebar -->
        <div id="sidebar" class="sidebar bg-[#e52c1f] text-white w-64 flex flex-col">
            <div class="p-4 flex items-center border-b border-[#c5271b]">
                <div class="w-10 h-10 rounded-full bg-[#d4291d] flex items-center justify-center">
                    <i class="fas fa-box-open text-xl"></i>
                </div>
                <span class="logo-text ml-3 text-xl font-bold">TecnoDeposit</span>
            </div>
            
            <div class="p-4 border-b border-[#c5271b]">
                <div class="flex items-center">
                    <div class="w-10 h-10 rounded-full bg-[#d4291d] flex items-center justify-center">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="sidebar-text ml-3">
                    <%
					    String username = (String) session.getAttribute("username");
                    	String ruolo = (String) session.getAttribute("ruolo");
                    	String mail = (String) session.getAttribute("mail");
					
					%>
                        <p class="font-medium"><%= username %></p>
                        <p class="text-xs text-[#f8b4b0]"><%= ruolo %></p>
                    </div>
                </div>
            </div>
            
            <nav class="flex-1 p-4">
                <ul class="space-y-2">
                    <li>
                        <a href="#" class="nav-item flex items-center p-2 rounded-lg bg-[#d4291d]">
                            <i class="fas fa-table"></i>
                            <span class="sidebar-text ml-3">Dashboard</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item flex items-center p-2 rounded-lg hover:bg-[#d4291d]">
                            <i class="fas fa-boxes"></i>
                            <span class="sidebar-text ml-3">Articoli</span>
                            <span class="sidebar-text ml-auto bg-[#d4291d] text-xs px-2 py-1 rounded-full">12</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item flex items-center p-2 rounded-lg hover:bg-[#d4291d]">
                            <i class="fas fa-tags"></i>
                            <span class="sidebar-text ml-3">Fornitori</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item flex items-center p-2 rounded-lg hover:bg-[#d4291d]">
                            <i class="fas fa-chart-bar"></i>
                            <span class="sidebar-text ml-3">Statistiche</span>
                        </a>
                    </li>
                    <li>
                        <a href="#" class="nav-item flex items-center p-2 rounded-lg hover:bg-[#d4291d]">
                            <i class="fas fa-cog"></i>
                            <span class="sidebar-text ml-3">Impostazioni</span>
                        </a>
                    </li>
                </ul>
            </nav>
            
            <div class="p-4 border-t border-[#c5271b]">
                <button id="toggle-sidebar" class="flex items-center text-[#f8b4b0] hover:text-white">
                    <i class="fas fa-chevron-left"></i>
                    <span class="sidebar-text ml-3">Riduci</span>
                </button>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="flex-1 flex flex-col overflow-hidden">
            <!-- Top Navigation -->
            <header class="bg-white shadow-sm">
                <div class="flex items-center justify-between px-6 py-4">
                    <div class="flex items-center">
                        <h1 class="text-xl font-semibold text-gray-800">Gestione Articoli</h1>
                    </div>
                    
                    <div class="flex items-center space-x-4">
                        <div class="relative">
                            <input type="text" placeholder="Cerca per matricola o nome..." class="pl-10 pr-4 py-2 border rounded-lg focus:outline-none focus:ring-2 focus:ring-[#e52c1f]">
                            <i class="fas fa-search absolute left-3 top-3 text-gray-400"></i>
                        </div>
                        <button class="p-2 rounded-full bg-gray-100 text-gray-600 hover:bg-gray-200">
                            <i class="fas fa-bell"></i>
                        </button>
                        <div class="relative">
                            <button id="profile-btn" class="w-8 h-8 rounded-full bg-[#e52c1f] flex items-center justify-center text-white">
                                <i class="fas fa-user"></i>
                            </button>
                            <!-- Profile Dropdown -->
                            <div id="profile-dropdown" class="profile-dropdown">
                                <div class="p-4 border-b">
                                    <p class="font-medium"><%= username %></p>
                                    <p class="text-sm text-gray-500"> <%=mail %></p>
                                </div>
                                <div class="py-1">
                                    <a href="#" class="profile-dropdown-item">
                                        <i class="fas fa-user"></i>
                                        <span>Profilo</span>
                                    </a>
                                    <a href="#" class="profile-dropdown-item">
                                        <i class="fas fa-cog"></i>
                                        <span>Impostazioni</span>
                                    </a>
                                    <a href="#" class="profile-dropdown-item">
                                        <i class="fas fa-bell"></i>
                                        <span>Notifiche</span>
                                    </a>
                                </div>
                                <div class="profile-dropdown-divider"></div>
                                <div class="py-1">
                                    <a href="#" class="profile-dropdown-item">
                                        <i class="fas fa-question-circle"></i>
                                        <span>Aiuto</span>
                                    </a>
                                    <a href="#" class="profile-dropdown-item">
                                        <i class="fas fa-info-circle"></i>
                                        <span>Informazioni</span>
                                    </a>
                                </div>
                                <div class="profile-dropdown-divider"></div>
                                <div class="py-1">
                                    <a href="<%= request.getContextPath() %>/logout" class="profile-dropdown-item text-red-600 hover:text-red-700" id="logout-btn">
                                        <i class="fas fa-sign-out-alt"></i>
                                        <span>Logout</span>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            
            <!-- Main Content Area -->
            <main class="flex-1 overflow-y-auto p-6">
                <div class="mb-6 flex justify-between items-center">
                    <div>
                        <h2 class="text-2xl font-bold text-gray-800">Tutti gli Articoli</h2>
                        <p class="text-gray-600">Gestisci inventario</p>
                    </div>
                    <button id="add-article-btn" class="bg-[#e52c1f] hover:bg-[#c5271b] text-white px-4 py-2 rounded-lg flex items-center">
                        <i class="fas fa-plus mr-2"></i> Aggiungi Articolo
                    </button>
                </div>
                
                <!-- Filters -->
                <div class="bg-white rounded-lg shadow-sm p-4 mb-6">
                    <div class="flex flex-wrap items-center gap-4">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Stato</label>
                            <select class="border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]">
                                <option>Tutti</option>
                                <option>Riparato</option>
                                <option>In magazzino</option>
                                <option>Installato</option>
                                <option>Destinato</option>
                                <option>Assegnato</option>
                                <option>In attesa</option>
                                <option>Guasto</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Marca</label>
                            <select class="border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]">
                                <option>Tutte</option>
                                <option>Apple</option>
                                <option>Samsung</option>
                                <option>HP</option>
                                <option>Dell</option>
                                <option>Lenovo</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Data ricezione</label>
                            <input type="date" class="border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]">
                        </div>
                        <button class="mt-6 bg-gray-100 hover:bg-gray-200 text-gray-800 px-4 py-2 rounded-lg">
                            <i class="fas fa-filter mr-2"></i> Filtra
                        </button>
                        <button class="mt-6 bg-[#fce5e3] hover:bg-[#f8b4b0] text-[#e52c1f] px-4 py-2 rounded-lg">
                            <i class="fas fa-sync-alt mr-2"></i> Reset
                        </button>
                    </div>
                </div>
                
                <!-- Articles Grid --><div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                <%
    System.out.println("\n==================== INIZIO DEBUG ====================\n");
        ListaArticoli lista = new ListaArticoli();
        List<Articolo> articoli = lista.getAllarticoli();
        System.out.println("PRODOTTI: "+articoli);
        if (articoli != null && !articoli.isEmpty()) {
            for (Articolo a : articoli) {
    %>
                
                    <!-- Article Card 1 -->
                    <div class="article-card bg-white rounded-lg shadow-sm overflow-hidden transition-all duration-300">
                        <div class="relative">
                              <img src="https://www.ripple-service.it/wp-content/uploads/2022/07/Riscaldatore-150W-500x500.jpg" alt="Articolo" class="w-full h-48 object-cover">
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
                                 <span class="bg-blue-100 text-blue-800 text-xs px-2 py-1 rounded-full">Categoria</span> 
                            </div>
                            <div class="mt-3 space-y-2">
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Marca:</span>
                                    <span class="text-sm font-medium"><%= a.getMarca() %></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">DDT:</span>
                                    <span class="text-sm font-medium"><%= a.getDdt() %></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Ricezione:</span>
                                    <span class="text-sm font-medium"><%= a.getDataRic_DDT() %></span>
                                </div>
                                <div class="flex justify-between">
                                    <span class="text-sm text-gray-600">Compatibilità:</span>
                                    <span class="text-sm font-medium"><%= a.getCompatibilita() %></span>
                                </div>
                            </div>
                            <div class="mt-4 flex space-x-2">
                                <button class="edit-btn flex-1 bg-[#fce5e3] text-[#e52c1f] hover:bg-[#f8b4b0] px-3 py-1 rounded-lg text-sm flex items-center justify-center">
                                    <i class="fas fa-edit mr-1"></i> Modifica
                                </button>
                                <button class="delete-btn flex-1 bg-red-100 text-red-700 hover:bg-red-200 px-3 py-1 rounded-lg text-sm flex items-center justify-center">
                                    <i class="fas fa-trash-alt mr-1"></i> Elimina
                                </button>
                            </div>
                        </div>
                    </div>
                    <%
            }
        } else {
    %>
            <p>Nessun prodotto disponibile.</p>
    <%
        }
    %>
                    
                   
                <!-- Pagination -->
                <div class="mt-8 flex justify-between items-center">
                    <div class="text-sm text-gray-600">
                        Mostrando 1-4 di 12 articoli
                    </div>
                    <div class="flex space-x-2">
                        <button class="px-3 py-1 border rounded-lg hover:bg-gray-100">
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <button class="px-3 py-1 border rounded-lg bg-[#e52c1f] text-white">1</button>
                        <button class="px-3 py-1 border rounded-lg hover:bg-gray-100">2</button>
                        <button class="px-3 py-1 border rounded-lg hover:bg-gray-100">3</button>
                        <button class="px-3 py-1 border rounded-lg hover:bg-gray-100">
                            <i class="fas fa-chevron-right"></i>
                        </button>
                    </div>
                </div>
            </main>
        </div>
    </div>
    
    <!-- Add Article Modal -->
    <div id="article-modal" class="modal fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 hidden">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl fade-in">
            <div class="flex justify-between items-center border-b px-6 py-4">
                <h3 id="modal-title" class="text-lg font-semibold">Aggiungi Nuovo Articolo</h3>
                <button id="close-modal" class="text-gray-500 hover:text-gray-700">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="p-6">
                <form id="article-form" action="articolo" method="post">
                <input type="hidden" name="action" value="add" />
                
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Stato*</label>
            <select class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name="stato" required>
                <option value="">Seleziona stato</option>
                <option value="Riparato">Riparato</option>
                <option value="In magazzino">In magazzino</option>
                <option value="Installato">Installato</option>
                <option value="Destinato">Destinato</option>
                <option value="Assegnato">Assegnato</option>
                <option value="In attesa">In attesa</option>
                <option value="Guasto">Guasto</option>
            </select>
        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Nome articolo*</label>
                            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name="nome" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-gray-700 mb-1">Marca*</label>
            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name="marca" required>
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Compatibilità*</label>
            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name="compatibilita" required>
        </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Matricola</label>
            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "matricola">
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Ddt</label>
            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "ddt">
        </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Provenienza</label>
            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "provenienza">
        </div>
               <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Fornitore</label>
            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "fornitore">
        </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Tecnico</label>
            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "tecnico">
        </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">P.V. Di Destinazione</label>
            <input type="text" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "pv">
        </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Data Garanzia</label>
            <input type="date" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "dataGaranzia">
        </div>


        <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Data ricezione</label>
            <input type="date" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "dataRic_DDT">
        </div>
        <div>
            <label class="block text-sm font-medium text-gray-700 mb-1">Data spedizione</label>
            <input type="date" class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" name = "dataSpe_DDT">
        </div>
        <div class="md:col-span-2">
            <label class="block text-sm font-medium text-gray-700 mb-1">Note</label>
            <textarea class="w-full border rounded-lg px-4 py-2 focus:outline-none focus:ring-2 focus:ring-[#e52c1f]" rows="3" name = "note"></textarea>
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
    
    <!-- Delete Confirmation Modal -->
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
    
    <script>
        // Toggle Sidebar
        document.getElementById('toggle-sidebar').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('collapsed');
            const icon = this.querySelector('i');
            if (document.getElementById('sidebar').classList.contains('collapsed')) {
                icon.classList.remove('fa-chevron-left');
                icon.classList.add('fa-chevron-right');
                this.querySelector('.sidebar-text').textContent = 'Espandi';
            } else {
                icon.classList.remove('fa-chevron-right');
                icon.classList.add('fa-chevron-left');
                this.querySelector('.sidebar-text').textContent = 'Riduci';
            }
        });
        
        // Profile Dropdown Toggle
        const profileBtn = document.getElementById('profile-btn');
        const profileDropdown = document.getElementById('profile-dropdown');
        
        profileBtn.addEventListener('click', function(e) {
            e.stopPropagation();
            profileDropdown.classList.toggle('show');
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
            if (!profileBtn.contains(e.target) && !profileDropdown.contains(e.target)) {
                profileDropdown.classList.remove('show');
            }
        });
        
        // Logout functionality
        /*document.getElementById('logout-btn').addEventListener('click', function(e) {
            e.preventDefault();
            // Here you would typically redirect to logout page or clear session
            //alert('Logout effettuato con successo!');
            // window.location.href = '/logout';
        });*/
        
        // Modal Handling
        const modal = document.getElementById('article-modal');
        const deleteModal = document.getElementById('delete-modal');
        const addBtn = document.getElementById('add-article-btn');
        const closeBtn = document.getElementById('close-modal');
        const cancelBtn = document.getElementById('cancel-btn');
        const cancelDeleteBtn = document.getElementById('cancel-delete');
        const confirmDeleteBtn = document.getElementById('confirm-delete');
        const editButtons = document.querySelectorAll('.edit-btn');
        const deleteButtons = document.querySelectorAll('.delete-btn');
        
        // Open Add Modal
        addBtn.addEventListener('click', function() {
            document.getElementById('modal-title').textContent = 'Aggiungi Nuovo Articolo';
            modal.classList.remove('hidden');
        });
        
        // Open Edit Modal
        editButtons.forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('modal-title').textContent = 'Modifica Articolo';
                modal.classList.remove('hidden');
            });
        });
        
        // Open Delete Modal
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                deleteModal.classList.remove('hidden');
            });
        });
        
        // Close Modals
        closeBtn.addEventListener('click', function() {
            modal.classList.add('hidden');
        });
        
        cancelBtn.addEventListener('click', function() {
            modal.classList.add('hidden');
        });
        
        cancelDeleteBtn.addEventListener('click', function() {
            deleteModal.classList.add('hidden');
        });
        
        // Confirm Delete
        confirmDeleteBtn.addEventListener('click', function() {
            // Here you would typically make an AJAX call to delete the item
            deleteModal.classList.add('hidden');
            
            // Show success message (you could implement a toast notification)
            alert('Articolo eliminato con successo!');
        });
        
        /* Form Submission
        document.getElementById('article-form').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Here you would typically make an AJAX call to save the data
            modal.classList.add('hidden');
            
            // Show success message (you could implement a toast notification)
            alert('Articolo salvato con successo!');
        });*/
        
        // Close modals when clicking outside
        window.addEventListener('click', function(e) {
            if (e.target === modal) {
                modal.classList.add('hidden');
            }
            if (e.target === deleteModal) {
                deleteModal.classList.add('hidden');
            }
        });
    </script>
</body>
</html>