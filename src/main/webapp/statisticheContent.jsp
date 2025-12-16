<!DOCTYPE html>
<%@ page import="model.Articolo" %>
<%@ page import="model.Fornitore" %>
<%@ page import="model.ListaArticoli" %>
<%@ page import="model.ListaFornitori" %>
<%@ page import="model.UserService" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>

<%	
	ListaArticoli lista = new ListaArticoli();
	ListaFornitori listaF = new ListaFornitori();
	List<Fornitore> fornitori = listaF.getAllfornitori();
	List<Integer> countF = listaF.countArticoliPerFornitore(fornitori);
	List<String> stati = Arrays.asList("Riparato", "In magazzino", "Installato", "Destinato", "Assegnato", "In Attesa", "Guasto");
	UserService users = new UserService();
	List<String> tecnici = lista.getNomiTecnici();
	List<Integer> assegnati = lista.countArticoliPerTecnico(tecnici);
%>
<html lang="it">
<head>
    <meta charset="UTF-8">
    
    <title>Dashboard Statistiche Magazzino</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .chart-container {
            position: relative;
            height: 300px;
        }
        .progress-bar {
            height: 8px;
            border-radius: 4px;
            background-color: #d4291d;
        }
        .progress-bar-fill {
            height: 100%;
            border-radius: 4px;
            transition: width 0.5s ease;
        }
    </style>
</head>
<body class="bg-gray-50 font-sans">
    <div class="container mx-auto px-4 py-8">
        <!-- Header -->
        <div class="flex justify-between items-center mb-8">
            <h1 class="text-3xl font-bold text-gray-800">
                <i class="fas fa-warehouse text-red-600 mr-3"></i>
                Statistiche Magazzino
            </h1>
            
        </div>

        <!-- KPI Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
            <!-- Occupazione -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Articoli Totali</p>
                        <p class="text-2xl font-bold text-gray-900 mt-1"><%=lista.countArticoli() %></p>
                        <!-- BARRA DI RIEMPIMENTO MAGAZZINO <div class="w-full bg-gray-200 rounded-full h-2 mt-3">
                            <div class="bg-red-600 h-2 rounded-full" style="width: 78%"></div>
                        </div> -->
                    </div>
                    <div class="bg-red-100 p-3 rounded-full">
                        <i class="fas fa-boxes text-red-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <!-- Movimenti -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Utenti Presenti Nel Sistema</p>
                        <p class="text-2xl font-bold text-gray-900 mt-1"><%=users.countUser() %></p>
                        
                    </div>
                    <div class="bg-green-100 p-3 rounded-full">
                        <i class="fas fa-user text-green-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <!-- Zone Attive -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <div class="flex items-center justify-between">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Centri Revisione Attivi</p>
                        <p class="text-2xl font-bold text-gray-900 mt-1"><%=listaF.countFornitori() %></p>
                        <p class="text-sm text-gray-500 mt-1">Centro con più articoli: <%=listaF.getMostUsedFornitore() %></p>
                    </div>
                    <div class="bg-yellow-100 p-3 rounded-full">
                        <i class="fas fa-screwdriver-wrench text-yellow-600 text-xl"></i>
                    </div>
                </div>
            </div>

            <!-- Turnover -->
            <div class="bg-white rounded-xl shadow-md p-6 cursor-pointer">
                <div class="flex items-center justify-between" onclick="window.location.href='dashboard?stato=In%20attesa'">
                    <div>
                        <p class="text-sm font-medium text-gray-500">Articoli In Attesa Di Riparazione</p>
                        <p class="text-2xl font-bold text-gray-900 mt-1"><%=lista.countArticoliInAttesa() %></p>
                        <p class="text-sm text-gray-500 mt-1"></p>
                    </div>
                    <div class="bg-purple-100 p-3 rounded-full">
                        <i class="fas fa-hourglass-half text-purple-600 text-xl"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Charts -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
            <!-- Andamento Occupazione -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-lg font-semibold text-gray-800 mb-4">Andamento Occupazione Tecnici</h2>
                <div class="chart-container">
                    <canvas id="occupationTrendChart"></canvas>
                </div>
            </div>

            <!-- Distribuzione Articoli -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-lg font-semibold text-gray-800 mb-4">Distribuzione Articoli</h2>
                <div class="chart-container">
                    <canvas id="zoneDistributionChart"></canvas>
                </div>
            </div>
            <!-- Distribuzione Centri Revisione -->
            <div class="bg-white rounded-xl shadow-md p-6">
                <h2 class="text-lg font-semibold text-gray-800 mb-4">Andamento Occupazione Centri Revisione</h2>
                <div class="chart-container">
                    <canvas id="occupationRevisionChart"></canvas>
                </div>
            </div>
        </div>
<!--
        Efficiency Metrics
        <div class="bg-white rounded-xl shadow-md p-6 mb-8">
            <h2 class="text-lg font-semibold text-gray-800 mb-6">Metriche di Efficienza</h2>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div>
                    <h3 class="text-sm font-medium text-gray-500 mb-2">Tempo Medio Prelevamento</h3>
                    <div class="flex items-end">
                        <p class="text-2xl font-bold text-gray-900">12.4</p>
                        <p class="text-sm text-gray-500 ml-1 mb-1">minuti</p>
                    </div>
                    <div class="mt-2">
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-green-100 text-green-800">
                            <i class="fas fa-arrow-down mr-1 text-xs"></i> 8% miglioramento
                        </span>
                    </div>
                </div>
                <div>
                    <h3 class="text-sm font-medium text-gray-500 mb-2">Utilizzo Spazio</h3>
                    <div class="flex items-end">
                        <p class="text-2xl font-bold text-gray-900">84%</p>
                        <p class="text-sm text-gray-500 ml-1 mb-1">della capacità</p>
                    </div>
                    <div class="w-full bg-gray-200 rounded-full h-2 mt-3">
                        <div class="bg-red-600 h-2 rounded-full" style="width: 84%"></div>
                    </div>
                </div>
                <div>
                    <h3 class="text-sm font-medium text-gray-500 mb-2">Produttività Operatori</h3>
                    <div class="flex items-end">
                        <p class="text-2xl font-bold text-gray-900">92%</p>
                        <p class="text-sm text-gray-500 ml-1 mb-1">dell'obiettivo</p>
                    </div>
                    <div class="mt-2">
                        <span class="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-yellow-100 text-yellow-800">
                            <i class="fas fa-equals mr-1 text-xs"></i> Stabile
                        </span>
                    </div>
                </div>
            </div>
        </div>

         Movimenti Recenti 
        <div class="bg-white rounded-xl shadow-md overflow-hidden">
            <div class="px-6 py-4 border-b border-gray-200">
                <h2 class="text-lg font-semibold text-gray-800">Attività Recenti</h2>
            </div>
            <div class="divide-y divide-gray-200">
                <div class="p-4 hover:bg-gray-50">
                    <div class="flex items-center">
                        <div class="bg-red-100 p-2 rounded-full mr-4">
                            <i class="fas fa-arrow-right text-red-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Trasferimento tra zone completato</p>
                            <p class="text-xs text-gray-500">Da Zona A a Zona B - 15 minuti fa</p>
                        </div>
                    </div>
                </div>
                <div class="p-4 hover:bg-gray-50">
                    <div class="flex items-center">
                        <div class="bg-green-100 p-2 rounded-full mr-4">
                            <i class="fas fa-arrow-down text-green-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Carico merci completato</p>
                            <p class="text-xs text-gray-500">Zona D - 1 ora fa</p>
                        </div>
                    </div>
                </div>
                <div class="p-4 hover:bg-gray-50">
                    <div class="flex items-center">
                        <div class="bg-purple-100 p-2 rounded-full mr-4">
                            <i class="fas fa-arrow-up text-purple-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Scarico merci completato</p>
                            <p class="text-xs text-gray-500">Zona F - 2 ore fa</p>
                        </div>
                    </div>
                </div>
                <div class="p-4 hover:bg-gray-50">
                    <div class="flex items-center">
                        <div class="bg-yellow-100 p-2 rounded-full mr-4">
                            <i class="fas fa-exclamation-triangle text-yellow-600"></i>
                        </div>
                        <div class="flex-1">
                            <p class="text-sm font-medium text-gray-900">Zona E raggiunta capacità massima</p>
                            <p class="text-xs text-gray-500">3 ore fa</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="px-6 py-4 border-t border-gray-200 text-center">
                <a href="#" class="text-sm font-medium text-red-600 hover:text-red-800">Visualizza tutte le attività</a>
            </div>
        </div>
    </div>
  -->
    <script>
 // Occupation Trend Chart
    const occupationRCtx = document.getElementById('occupationRevisionChart').getContext('2d');
    const occupationRChart = new Chart(occupationRCtx, {
        type: 'bar',
        data: {
            labels: [<% for (int i = 0; i < fornitori.size(); i++) {
                out.print("\"" + fornitori.get(i).getNome() + "\"");
                if (i < fornitori.size() - 1) out.print(", ");
            } %>],
            datasets: [{
                label: 'Percentuale Occupazione',
                data: [<% for (int i = 0; i < countF.size(); i++) {
                out.print(countF.get(i));
                if (i < countF.size() - 1) out.print(", ");
            } %>
			],
				borderColor: 'rgba(249, 115, 22, 0.6)',
                backgroundColor: 'rgba(253, 224, 71, 0.6)',
                borderWidth: 2,
                borderRadius: 6,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    callbacks: {
                        label: function(context) {
                            return context.parsed.y +" "+ 'Articoli';
                        }
                    }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,                    
                    ticks: {
                        callback: function(value) {
                            return value;
                        }
                    },
                    grid: {
                        borderDash: [5],
                    }
                },
                x: {
                    grid: {
                        display: false
                    }
                }
            }
        }
    });
    
    
    
    
        // Occupation Trend Chart
        const occupationCtx = document.getElementById('occupationTrendChart').getContext('2d');
        const occupationChart = new Chart(occupationCtx, {
            type: 'bar',
            data: {
                labels: [<% for (int i = 0; i < tecnici.size(); i++) {
                    out.print("\"" + tecnici.get(i) + "\"");
                    if (i < tecnici.size() - 1) out.print(", ");
                } %>],
                datasets: [{
                    label: 'Percentuale Occupazione',
                    data: [<% for (int i = 0; i < assegnati.size(); i++) {
                    out.print(assegnati.get(i));
                    if (i < assegnati.size() - 1) out.print(", ");
                } %>
				],
                    borderColor: '#3B82F6',
                    backgroundColor: 'rgba(59, 130, 246, 0.05)',
                    fill: true,
                    tension: 0.3,
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y +" "+ 'Articoli';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,                    
                        ticks: {
                            callback: function(value) {
                                return value;
                            }
                        },
                        grid: {
                            borderDash: [5],
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });

        // Zone Distribution Chart
        const zoneCtx = document.getElementById('zoneDistributionChart').getContext('2d');
        const zoneChart = new Chart(zoneCtx, {
            type: 'bar',
            data: {
                labels: ['Riparati', 'In Magazzino', 'Installati', 'Destinati', 'Assegnati', 'In Attesa','Guasti'],
                datasets: [{
                    label: 'Livello Occupazione',
                    data: [ 
                    	
                    	
                  <%for (int i = 0; i < stati.size(); i++) {
                	  //System.out.println("STO VERIFICANDO I "+stati.get(i) +" e ne sono "+lista.countArticoliPerStato(stati.get(i)));
           out.print(lista.countArticoliPerStato(stati.get(i)));
          if (i < stati.size() - 1) out.print(", ");
        } %>
        
        
        ],
                    backgroundColor: [
                        '#3b82f6',
                        '#10b981',
                        '#8b5cf6',
                        '#098edb',
                        '#098edb',
                        '#eba834',
                        '#6e0303'
                    ],
                    borderRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                return context.parsed.y + ' articoli';
                            }
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: <%=lista.countArticoli()%>,
                        ticks: {
                            callback: function(value) {
                                return value ;
                            }
                        },
                        grid: {
                            borderDash: [5],
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>