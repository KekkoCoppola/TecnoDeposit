<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="it">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TecnoDeposit - Accesso Totem</title>
        <!-- CSS di base e font simile a quello del progetto -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,600,700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Totem.css">
    </head>

    <body class="totem-body">

        <div class="totem-container">

            <div class="totem-header">
                <img src="${pageContext.request.contextPath}/img/Icon.png" alt="TecnoDeposit Logo" class="totem-logo"
                    style="height: 80px;">
                <p>Digita il PIN di sicurezza e premi Invio.</p>
            </div>

            <div class="totem-content">
                <% String error=(String) request.getAttribute("error"); if (error !=null) { %>
                    <div class="totem-error"><i class="fas fa-exclamation-circle"></i>
                        <%= error %>
                    </div>
                    <% } %>

                        <form action="${pageContext.request.contextPath}/t-8f92a1b3c4d5e6f7g8h9i0j" method="POST"
                            id="totem-form">

                            <!-- Input visibile tipo password (abilitato alla tastiera fisica) -->
                            <input type="password" id="pin-display" name="pin" class="totem-pin-input"
                                placeholder="°°°°°°" autofocus required autocomplete="off">

                            <p style="color: #95a5a6; font-size: 14px; margin-top: 10px;">Attendi il caricamento
                                automatico o premi Invio.</p>
                        </form>
            </div>
        </div>

        <script>
            const pinDisplay = document.getElementById('pin-display');

            // Mantieni sempre il focus nell'input per non dover usare il mouse
            document.addEventListener('click', () => {
                pinDisplay.focus();
            });

            // Focus automatico immediato
            window.onload = function () {
                pinDisplay.focus();
            };

            // Autoclick submit when reach length 7 (optional enhancement since pin is 7 digits)
            pinDisplay.addEventListener('input', function () {
                if (this.value.length === 7) {
                    document.getElementById('totem-form').submit();
                }
            });
        </script>
    </body>

    </html>