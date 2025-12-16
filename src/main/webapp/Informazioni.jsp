<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/x-icon" href="/static/favicon.ico">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <style>
    .step-icon {
            background-color: #b91c1c;
            color: white;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 12px;
            flex-shrink: 0;
    }
        </style>
<meta charset="UTF-8">
</head>
<body>
            <section id="getting-started" class="bg-white rounded-lg shadow-md p-6 mb-8">
                <div class="flex items-center mb-6">
                    <i class="fas fa-play w-6 h-6 text-red-600 mr-2"></i>
                    <h2 class="text-2xl font-bold text-gray-800">Cosa fare</h2>
                </div>
                <div class="space-y-6">
                    <!-- Step 1 -->
                    <div class="flex items-start">
                        <div class="step-icon">
                            <span class="font-semibold">1</span>
                        </div>
                        <div>
                            <h3 class="text-lg font-semibold text-gray-800 mb-2">Entra nel tuo account</h3>
                            <p class="text-gray-700 mb-3">Effettua il login per accedere a tutte le funzionalità della piattaforma TecnoDeposit.</p>
                            <div class="bg-gray-100 rounded-lg p-3 inline-block mb-3">
                                <img src="img/tutorial/Login.png" alt="Schermata di registrazione" class="rounded-md shadow-sm max-w-full h-auto">
                            </div>
                            <p class="text-gray-600 text-sm"><i data-feather="info" class="w-4 h-4 inline mr-1"></i> Hai bisogno di un amministratore locale che registri le tue credenziali per avere l'account.</p>
                        </div>
                    </div>

                    <!-- Step 2 -->
                    <div class="flex items-start">
                        <div class="step-icon">
                            <span class="font-semibold">2</span>
                        </div>
                        <div>
                            <h3 class="text-lg font-semibold text-gray-800 mb-2">Gestisci il magazzino</h3>
                            <p class="text-gray-700 mb-3">Imposta gli articoli secondo le tue necessità per ottenere un'esperienza su misura.</p>
                            <div class="bg-gray-100 rounded-lg p-3 inline-block mb-3">
                                <img src="img/tutorial/Articoli.png" alt="Schermata del profilo" class="rounded-md shadow-sm max-w-full h-auto">
                            </div>
                            <ul class="list-disc pl-5 text-gray-700 space-y-1">
                                <li><i class="fas fa-plus"></i> Aggiungi un nuovo articolo</li>
                                <li><i class="fas fa-eye"></i> Visualizza il suo stato e il suo storico</li>
                                <li><i class="fas fa-user"></i> Scopri a chi è assegnato</li>
                                <li><i class="fas fa-location-dot"></i> oppure dov'è collocato</li>
                            </ul>
                        </div>
                    </div>

                    <!-- Step 3 -->
                    <div class="flex items-start">
                        <div class="step-icon">
                            <span class="font-semibold">3</span>
                        </div>
                        <div>
                            <h3 class="text-lg font-semibold text-gray-800 mb-2">Esplora le funzionalità</h3>
                            <p class="text-gray-700 mb-3">Scopri tutto ciò che la mia piattaforma può offrirti.</p>
                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mb-3">
                                <div class="bg-gray-100 rounded-lg p-3">
                                    <img src="img/tutorial/Statistiche.png" alt="Funzionalità 1" class="rounded-md shadow-sm w-full h-auto">
                                </div>
                                <div class="bg-gray-100 rounded-lg p-3">
                                    <img src="img/tutorial/Dettagli.png" alt="Funzionalità 2" class="rounded-md shadow-sm w-full h-auto">
                                </div>
                                <div class="bg-gray-100 rounded-lg p-3">
                                    <img src="img/tutorial/Richieste.png" alt="Funzionalità 3" class="rounded-md shadow-sm w-full h-auto">
                                </div>
                            </div>
                            <p class="text-gray-700">Non esitare a sperimentare con le diverse opzioni disponibili!</p>
                        </div>
                    </div>
                </div>
            </section>
</body>
</html>