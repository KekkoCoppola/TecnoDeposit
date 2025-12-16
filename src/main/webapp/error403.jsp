<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Accesso Negato - TecnoDeposit</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="website icon" type="png" href="img/Icon.png">
    <style>
        .pulse {
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        .bg-custom-gray {
            background-color: #f5f5f5;
        }
        .text-custom-red {
            color: #d32f2f;
        }
        .border-custom-red {
            border-color: #d32f2f;
        }
    </style>
</head>
<body class="bg-custom-gray min-h-screen flex flex-col items-center justify-center p-4">
    <div class="max-w-md w-full bg-white rounded-lg shadow-lg overflow-hidden pulse">
        <div class="bg-[#e52c1f] py-4 px-6">
            <h1 class="text-white text-2xl font-bold">
                <i class="fas fa-ban mr-2"></i> Accesso Negato
            </h1>
        </div>
        
        <div class="p-8 text-center">
            <div class="mb-6">
                <img  src = "img/Icon.png" class="fas fa-box-open text-custom-red text-7xl mb-4" width=90 height=90></i>
                <h2 class="text-4xl font-bold text-gray-800 mb-2">403</h2>
                <h3 class="text-2xl font-semibold text-gray-700">Accesso Negato</h3>
            </div>
            
            <p class="text-gray-600 mb-8">
                Sembra che il nostro sistema di sicurezza ti abbia negato l'accesso a questa pagina.
                <br>
                Ritenta tra poco o contatta l'assistenza.
            </p>
            
            <div class="flex flex-col sm:flex-row justify-center gap-4">
                <a href="<%= request.getContextPath() %>/logout" class="border-2 border-custom-red text-custom-red hover:bg-gray-100 font-bold py-3 px-6 rounded-lg transition duration-300">
                    <i class="fas fa-home mr-2"></i> Torna indietro
                </a>
                <a href="mailto:assistenza@tecnodeposit.it?subject=Richiesta%20Assistenza%20TecnoDeposit&body=Salve,%0D%0A%0D%0Aavrei bisogno di assistenza riguardo il servizio TecnoDeposit.%0D%0A[DESCRIVI LA PROBLEMATICA]%0D%0A%0D%0ACordiali saluti,[TUO USERNAME]" class="border-2 border-custom-red text-custom-red hover:bg-gray-100 font-bold py-3 px-6 rounded-lg transition duration-300">
                    <i class="fas fa-headset mr-2"></i> Contatta l'assistenza
                </a>
            </div>
        </div>
    </div>

    <script>
        // Aggiunge un effetto di caricamento
        document.addEventListener('DOMContentLoaded', function() {
            setTimeout(function() {
                document.querySelector('.pulse').style.animation = 'none';
            }, 3000);
            
            // Effetto per il pulsante home
            const homeBtn = document.querySelector('a[href="/"]');
            homeBtn.addEventListener('mouseover', function() {
                this.querySelector('i').classList.add('fa-bounce');
            });
            homeBtn.addEventListener('mouseout', function() {
                this.querySelector('i').classList.remove('fa-bounce');
            });
        });
    </script>
</body>
</html>