<%@ page contentType="text/html; charset=UTF-8" language="java" %>
    <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


        <!DOCTYPE html>
        <html>

        <head>
            <link rel="icon" type="image/png" href="img/Icon.png">
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

            <!-- PWA Meta Tags -->
            <meta name="theme-color" content="#e52c1f">
            <meta name="apple-mobile-web-app-capable" content="yes">
            <meta name="apple-mobile-web-app-status-bar-style" content="black-translucent">
            <meta name="apple-mobile-web-app-title" content="TecnoDeposit">
            <link rel="apple-touch-icon" href="img/Icon.png">
            <link rel="manifest" href="manifest.json">

            <title>
                <c:out value="${pageTitle}" />
            </title>
            <script src="https://cdn.tailwindcss.com"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                <%@ include file="partials/styles.jspf" %>
            </style>
        </head>

        <body class="bg-gray-50 font-sans">
            <%@ include file="partials/splashscreen.jspf" %>
                <div class="flex h-screen overflow-hidden">
                    <%@ include file="partials/sidebar.jspf" %>

                        <div class="flex-1 flex flex-col overflow-hidden">
                            <%@ include file="partials/header.jspf" %>

                                <!-- Main content -->
                                <div class="p-6 overflow-y-auto flex-1 fade-in">
                                    <jsp:include page="${contentPage}" />
                                </div>
                        </div>
                </div>

                <%-- Changelog Banner (mostra novità al primo accesso dopo aggiornamento) --%>
                    <%@ include file="partials/changelog.jspf" %>

                        <script><%@ include file = "partials/scripts.jspf" %>
                        </script>

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