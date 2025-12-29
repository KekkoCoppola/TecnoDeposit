<!DOCTYPE html>
<html lang="it">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <link rel="icon" type="image/png" href="img/Icon.png">
    <title>Login - TecnoDeposit</title>

    <!-- PWA Meta Tags -->
    <meta name="theme-color" content="#e52c1f">
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
    <meta name="apple-mobile-web-app-title" content="TecnoDeposit">
    <link rel="apple-touch-icon" href="img/Icon.png">
    <link rel="manifest" href="manifest.json">

    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="css/Login.css">
</head>
<div id=background></div>

<body class="bg-gradient-to-br from-red-50 to-gray-100 min-h-screen flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl shadow-xl overflow-hidden w-full max-w-md">

        <div class="logo-space bg-gradient-to-r from-red-500 to-gray-600 p-8 flex items-center justify-center">
            <div class="w-32 h-32 bg-white/20 rounded-full flex items-center justify-center border-4 border-white/30">
                <img src="img/Icon.png" class="fas fa-user-circle text-white text-6xl opacity-80 animate-float"
                    style="animation: float 3s ease-in-out infinite;" height=100 width=100>

            </div>
        </div>

        <div class="p-8">
            <h1 class="text-3xl font-bold text-center text-gray-800 mb-2">Bentornato</h1>
            <p class="text-gray-500 text-center mb-8">Inserisci le credenziali TecnoDeposit</p>

            <form class="space-y-6" action="login" method="POST">
                <input type="hidden" name="csrfToken" value="${csrfToken}">

                <div>
                    <label for="username" class="block text-sm font-medium text-gray-700 mb-1">Username</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-user text-gray-400"></i>
                        </div>
                        <input id="username" name="username" type="text" required
                            class="input-field pl-10 block w-full rounded-lg border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 py-3 px-4 border"
                            placeholder="Inserisci l'username" autocapitalize="none" autocomplete="off"
                            autocorrect="off" oninput="this.value = this.value.toLowerCase();">
                    </div>
                </div>

                <div>
                    <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
                            <i class="fas fa-lock text-gray-400"></i>
                        </div>
                        <input id="password" name="password" type="password" required
                            class="input-field pl-10 block w-full rounded-lg border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 py-3 px-4 border"
                            placeholder="Inserisci la password" autocomplete="off">
                        <div class="absolute inset-y-0 right-0 pr-3 flex items-center">
                            <button type="button" class="text-gray-400 hover:text-gray-500 focus:outline-none">
                                <i class="fas fa-eye-slash"></i>
                            </button>
                        </div>
                    </div>
                </div>

                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <input id="remember-me" name="remember-me" type="checkbox"
                            class="h-4 w-4 rounded border-gray-300 text-red-600 focus:ring-red-500">
                        <label for="remember-me" class="ml-2 block text-sm text-gray-700">Ricordami</label>
                    </div>

                    <div class="text-sm">
                        <a href="#" class="font-medium text-gray-600 hover:text-red-500"
                            onclick="alert('Contatta il supporto TecnoDeposit a : assistenza@tecnodeposit.it')">Password
                            Dimenticata?</a>
                    </div>
                </div>

                <div>
                    <button type="submit"
                        class="btn-login w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-all duration-300">
                        Accedi
                    </button>
                </div>
            </form>


        </div>
    </div>

    <% String errore=(String) request.getAttribute("loginError"); String flash=(String)
        session.getAttribute("FLASH_LOGIN_ERROR"); %>
        <% if (errore !=null || flash!=null) { %>
            <div id="notificaErrore"
                class="fixed top-5 left-1/2 transform -translate-x-1/2 bg-red-500 text-white px-4 py-2 rounded shadow z-50 animate-slide-down">
                <i class="fas fa-exclamation-circle mr-2"></i>
                <%= (flash !=null ? flash : errore) %>
            </div>
            <% session.removeAttribute("FLASH_LOGIN_ERROR");} %>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/vanta/dist/vanta.net.min.js"></script>
                <script src="scripts/login.js"></script>

                <!-- Registrazione Service Worker PWA -->
                <script>
                    if ('serviceWorker' in navigator) {
                        navigator.serviceWorker.register('sw.js')
                            .then(reg => console.log('SW registrato'))
                            .catch(err => console.log('SW errore:', err));
                    }
                </script>

</body>

</html>