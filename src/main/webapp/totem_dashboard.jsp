<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <!DOCTYPE html>
    <html lang="it">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>TecnoDeposit - Area Totem</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,600,700&display=swap" rel="stylesheet">
        <link rel="stylesheet"
            href="${pageContext.request.contextPath}/css/Totem.css?v=<%= System.currentTimeMillis() %>">
    </head>

    <body class="totem-body">

        <div class="totem-dashboard-container">

            <% String successMsg=(String) session.getAttribute("totem_success_msg"); String errorMsg=(String)
                session.getAttribute("totem_error_msg"); String loggedUser=(String)
                session.getAttribute("logged_totem_user"); session.removeAttribute("totem_success_msg");
                session.removeAttribute("totem_error_msg"); %>

                <!-- Header -->
                <header class="totem-dash-header">
                    <img src="${pageContext.request.contextPath}/img/Icon.png" alt="TecnoDeposit Logo"
                        class="totem-dash-logo" style="height: 50px; border-radius: 8px;">
                    <div class="totem-dash-title">
                        <h1>Totem Articoli</h1>
                        <p>In attesa di input</p>
                    </div>

                    <% if (loggedUser !=null) { %>
                        <div class="totem-logout-btn"
                            style="background: transparent; border: none; font-size: 20px; color: var(--totem-light); max-width: 250px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                            <i class="fas fa-user-circle" style="font-size: 24px; vertical-align: middle;"></i> <strong>
                                <%= loggedUser %>
                            </strong>
                        </div>
                        <% } %>
                </header>

                <main class="totem-dash-main">
                    <!-- Messaggi Flash (Toast Notifications) -->

                    <div id="toast-container" class="totem-toast-container">
                        <% if (successMsg !=null) { %>
                            <div class="totem-toast totem-toast-success show">
                                <i class="fas fa-check-circle"></i> <span>
                                    <%= successMsg %>
                                </span>
                            </div>
                            <% } %>
                                <% if (errorMsg !=null) { %>
                                    <div class="totem-toast totem-toast-danger show">
                                        <i class="fas fa-exclamation-circle"></i> <span>
                                            <%= errorMsg %>
                                        </span>
                                    </div>
                                    <% } %>
                    </div>

                    <% if (loggedUser !=null) { java.util.List<model.Articolo> scannedArticles = (java.util.List
                        <model.Articolo>) session.getAttribute("totem_scanned_articles");

                            if (scannedArticles != null && !scannedArticles.isEmpty()) {
                            if (scannedArticles.size() == 1) {
                            model.Articolo primoArticolo = scannedArticles.get(0);
                            %>
                            <!-- Visualizzazione Unico Articolo (Espansa) -->
                            <div class="totem-single-item-view"
                                style="display: flex; width: 100%; height: 100%; max-height: 480px; gap: 30px; align-items: stretch; background: white; padding: 25px; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); border-left: 8px solid var(--totem-primary);">
                                <div class="item-img-container"
                                    style="flex: 0 0 45%; display: flex; justify-content: center; align-items: center; background: #f8f9fa; border-radius: 12px; overflow: hidden; padding: 15px;">
                                    <% String primoImg=(primoArticolo.getImmagine() !=null &&
                                        !primoArticolo.getImmagine().isEmpty() &&
                                        !primoArticolo.getImmagine().equals("null")) ? primoArticolo.getImmagine() :
                                        (request.getContextPath() + "/img/Icon.png" ); %>
                                        <img src="<%= primoImg %>" alt="Immagine Articolo"
                                            style="max-width: 100%; max-height: 100%; object-fit: contain;"
                                            onerror="this.src='${pageContext.request.contextPath}/img/Icon.png'">
                                </div>
                                <div class="item-details-container"
                                    style="flex: 1; display: flex; flex-direction: column; justify-content: center; gap: 15px;">
                                    <h2
                                        style="font-size: 36px; padding: 0; margin: 0; color: var(--totem-dark); line-height: 1.2;">
                                        <%= primoArticolo.getNome() %>
                                    </h2>
                                    <div class="item-matricola"
                                        style="font-size: 24px; color: var(--totem-primary); font-family: monospace; font-weight: bold; background: rgba(229, 44, 31, 0.1); padding: 8px 15px; border-radius: 8px; display: inline-block; align-self: flex-start;">
                                        <i class="fas fa-barcode"></i>
                                        <%= primoArticolo.getMatricola() %>
                                    </div>

                                    <div style="margin-top: 15px; display: flex; flex-direction: column; gap: 10px;">
                                        <div style="font-size: 20px; display: flex; align-items: baseline;">
                                            <span style="font-weight: 600; color: #64748b; width: 150px;">Stato:</span>
                                            <% String mainStatoEnum=primoArticolo.getStato().name(); String
                                                mainBadgeBg="#f1f5f9" ; String mainBadgeColor="var(--totem-dark)" ; if
                                                ("RIPARATO".equals(mainStatoEnum)) { mainBadgeBg="#3b82f6" ;
                                                mainBadgeColor="white" ; } else if
                                                ("IN_MAGAZZINO".equals(mainStatoEnum)) { mainBadgeBg="#10b981" ;
                                                mainBadgeColor="white" ; } else if ("INSTALLATO".equals(mainStatoEnum))
                                                { mainBadgeBg="#8b5cf6" ; mainBadgeColor="white" ; } else if
                                                ("DESTINATO".equals(mainStatoEnum)) { mainBadgeBg="#0ea5e9" ;
                                                mainBadgeColor="white" ; } else if ("ASSEGNATO".equals(mainStatoEnum)) {
                                                mainBadgeBg="#0284c7" ; mainBadgeColor="white" ; } else if
                                                ("IN_ATTESA_DI_RIPARAZIONE".equals(mainStatoEnum)) {
                                                mainBadgeBg="#facc15" ; mainBadgeColor="black" ; } else if
                                                ("GUASTO".equals(mainStatoEnum)) { mainBadgeBg="#b91c1c" ;
                                                mainBadgeColor="white" ; } else if
                                                ("NON_RIPARATO".equals(mainStatoEnum)) { mainBadgeBg="#f97316" ;
                                                mainBadgeColor="white" ; } else if
                                                ("NON_RIPARABILE".equals(mainStatoEnum)) { mainBadgeBg="#4b5563" ;
                                                mainBadgeColor="white" ; } %>
                                                <span
                                                    style="font-weight: 700; color: <%=mainBadgeColor%>; background: <%=mainBadgeBg%>; padding: 6px 12px; border-radius: 6px; font-size: 16px;">
                                                    <%= primoArticolo.getStato().toString() %>
                                                </span>
                                        </div>
                                        <div style="font-size: 20px; display: flex; align-items: baseline;">
                                            <span style="font-weight: 600; color: #64748b; width: 150px;">Marca:</span>
                                            <span style="color: var(--totem-dark);">
                                                <%= primoArticolo.getMarca() %>
                                            </span>
                                        </div>
                                        <div style="font-size: 20px; display: flex; align-items: baseline;">
                                            <span
                                                style="font-weight: 600; color: #64748b; width: 150px;">Compatibilità:</span>
                                            <span
                                                style="color: var(--totem-dark); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 250px;">
                                                <%= primoArticolo.getCompatibilita() %>
                                            </span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <% } else { %>
                                <!-- Visualizzazione Lista Ultra-Compatta (2+ Articoli) -->
                                <div class="totem-micro-list-container"
                                    style="display: flex; flex-direction: column; height: 100%; max-height: 480px; width: 100%; background: white; border-radius: 16px; box-shadow: 0 4px 20px rgba(0,0,0,0.05); padding: 15px; overflow: hidden;">
                                    <h3
                                        style="margin: 0 0 10px 0; font-size: 20px; color: var(--totem-primary); border-bottom: 2px solid #f1f5f9; padding-bottom: 8px;">
                                        Hai scansionato <%= scannedArticles.size() %> articoli
                                    </h3>
                                    <div class="micro-table-wrapper" style="flex: 1; overflow-y: auto;">
                                        <table class="totem-micro-table"
                                            style="width: 100%; border-collapse: collapse; text-align: left;">
                                            <thead style="position: sticky; top: 0; background: white; z-index: 1;">
                                                <tr
                                                    style="color: #64748b; font-size: 14px; border-bottom: 2px solid #e2e8f0;">
                                                    <th style="padding: 6px;">Immagine</th>
                                                    <th style="padding: 6px;">Matricola</th>
                                                    <th style="padding: 6px;">Nome Articolo</th>
                                                    <th style="padding: 6px;">Stato</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <% for (model.Articolo a : scannedArticles) { %>
                                                    <tr
                                                        style="border-bottom: 1px solid #f1f5f9; transition: background 0.2s;">
                                                        <td style="padding: 4px 6px;">
                                                            <div
                                                                style="width: 40px; height: 40px; border-radius: 6px; background: #f8f9fa; display: flex; align-items: center; justify-content: center; overflow: hidden;">
                                                                <% String aImg=(a.getImmagine() !=null &&
                                                                    !a.getImmagine().isEmpty() &&
                                                                    !a.getImmagine().equals("null")) ? a.getImmagine() :
                                                                    (request.getContextPath() + "/img/Icon.png" ); %>
                                                                    <img src="<%= aImg %>"
                                                                        style="max-width: 100%; max-height: 100%; object-fit: contain;"
                                                                        onerror="this.src='${pageContext.request.contextPath}/img/Icon.png'">
                                                            </div>
                                                        </td>
                                                        <td
                                                            style="padding: 4px 6px; font-family: monospace; font-size: 15px; font-weight: 600; color: var(--totem-primary);">
                                                            <%= a.getMatricola() %>
                                                        </td>
                                                        <td
                                                            style="padding: 4px 6px; font-size: 15px; font-weight: 500; color: var(--totem-dark); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 250px;">
                                                            <%= a.getNome() %>
                                                        </td>
                                                        <td style="padding: 4px 6px;">
                                                            <% String statoEnum=a.getStato().name(); String
                                                                badgeBg="#f1f5f9" ; String
                                                                badgeColor="var(--totem-dark)" ; if
                                                                ("RIPARATO".equals(statoEnum)) { badgeBg="#3b82f6" ;
                                                                badgeColor="white" ; } else if
                                                                ("IN_MAGAZZINO".equals(statoEnum)) { badgeBg="#10b981" ;
                                                                badgeColor="white" ; } else if
                                                                ("INSTALLATO".equals(statoEnum)) { badgeBg="#8b5cf6" ;
                                                                badgeColor="white" ; } else if
                                                                ("DESTINATO".equals(statoEnum)) { badgeBg="#0ea5e9" ;
                                                                badgeColor="white" ; } else if
                                                                ("ASSEGNATO".equals(statoEnum)) { badgeBg="#0284c7" ;
                                                                badgeColor="white" ; } else if
                                                                ("IN_ATTESA_DI_RIPARAZIONE".equals(statoEnum)) {
                                                                badgeBg="#facc15" ; badgeColor="black" ; } else if
                                                                ("GUASTO".equals(statoEnum)) { badgeBg="#b91c1c" ;
                                                                badgeColor="white" ; } else if
                                                                ("NON_RIPARATO".equals(statoEnum)) { badgeBg="#f97316" ;
                                                                badgeColor="white" ; } else if
                                                                ("NON_RIPARABILE".equals(statoEnum)) { badgeBg="#4b5563"
                                                                ; badgeColor="white" ; } %>
                                                                <span
                                                                    style="font-size: 12px; font-weight: 700; padding: 4px 8px; border-radius: 4px; background: <%=badgeBg%>; color: <%=badgeColor%>;">
                                                                    <%= a.getStato().toString() %>
                                                                </span>
                                                        </td>
                                                    </tr>
                                                    <% } %>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <% } %>
                                    <% } else { %>
                                        <!-- Modalità operativa attiva (Nessun articolo per ora, solo Login effettuato) -->
                                        <div class="totem-standby-card" style="border: 4px solid var(--totem-success);">
                                            <div
                                                style="color: var(--totem-success); font-size: 60px; margin-bottom: 20px;">
                                                <i class="fas fa-user-check"></i>
                                            </div>
                                            <h2
                                                style="color: var(--totem-success); font-size: 32px; margin-bottom: 15px;">
                                                Benvenuto, <%= loggedUser %>
                                            </h2>
                                            <div
                                                style="background: rgba(39, 174, 96, 0.1); padding: 20px; border-radius: 12px; border: 1px dashed var(--totem-success); width: 100%;">
                                                <p
                                                    style="font-size: 20px; color: var(--totem-dark); font-weight: 600; margin-bottom: 10px;">
                                                    <i class="fas fa-barcode"></i> Usa il lettore ottico per scansionare
                                                    gli articoli
                                                </p>
                                                <p style="font-size: 16px; color: #64748b;">
                                                    Gli articoli scansionati appariranno qui automaticamente.<br>
                                                    Successivamente potrai usare I tasti del tastierino
                                                    per l'assegnazione o il deposito.
                                                </p>
                                            </div>
                                        </div>
                                        <% } } else { %>
                                            <!-- Schermata di Standby Scansione -> Attesa QR Code Utente -->
                                            <div class="totem-standby-card">
                                                <div class="qr-scanner-animation">
                                                    <div class="scanner-laser"></div>
                                                    <i class="fas fa-qrcode qr-icon-large"></i>
                                                </div>
                                                <h2
                                                    style="font-size: 28px; color: var(--totem-primary); margin-bottom: 15px;">
                                                    Identificazione Operatore</h2>
                                                <p class="totem-subtitle"
                                                    style="margin-bottom: 20px; font-size: 18px; color: var(--totem-dark);">
                                                    Avvicina il tuo QR Code personale al lettore per iniziare.
                                                </p>

                                                <div
                                                    style="background: #f8f9fa; border-left: 4px solid var(--totem-secondary); padding: 15px; border-radius: 0 8px 8px 0; text-align: left; width: 100%;">
                                                    <p
                                                        style="font-size: 14px; color: #64748b; line-height: 1.5; margin: 0;">
                                                        <i class="fas fa-info-circle"
                                                            style="color: var(--totem-secondary);"></i>
                                                        Puoi trovare il tuo QR Code personale accedendo alla WebApp
                                                        TecnoDeposit, nel menu <strong>Profilo &gt; Accesso
                                                            Totem</strong>.
                                                    </p>
                                                </div>
                                            </div>
                                            <% } %>

                                                <!-- Form nascosto per catturare input scanner -->
                                                <form
                                                    action="${pageContext.request.contextPath}/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard"
                                                    method="POST" id="qr-form"
                                                    style="position: absolute; left: -9999px;">
                                                    <input type="text" id="qr-input" name="qr_token" autofocus
                                                        autocomplete="off">
                                                </form>

                </main>

                <!-- Modale Assegnazione (Tasto /) -->
                <div id="assign-modal" class="totem-modal-overlay">
                    <div class="totem-modal">
                        <h2><i class="fas fa-user-check"></i> Conferma Assegnazione</h2>
                        <p>Vuoi assegnare tutti gli articoli in coda al tecnico <strong>
                                <%= loggedUser %>
                            </strong>?</p>
                        <form action="${pageContext.request.contextPath}/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard"
                            method="POST" id="assign-form">
                            <input type="hidden" name="totem_action" value="assign">
                            <div class="totem-modal-actions">
                                <div class="totem-modal-btn cancel"><i class="fas fa-backspace"></i> ANNULLA (X)
                                </div>
                                <div class="totem-modal-btn confirm" id="assign-confirm-btn"><i
                                        class="fas fa-level-down-alt fa-rotate-90"></i>
                                    CONFERMA (✓)</div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modale Deposito/Guasto (Tasto *) -->
                <div id="deposit-modal" class="totem-modal-overlay">
                    <div class="totem-modal">
                        <h2><i class="fas fa-box"></i> Deposito in Magazzino</h2>
                        <p>Scannerizza le matricole degli articoli <strong>GUASTI</strong>.<br>
                            Se sono tutti funzionanti, non scannerizzare nulla.<br>
                            <strong>Premi Invio per C O N F E R M A R E.</strong>
                        </p>
                        <form action="${pageContext.request.contextPath}/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard"
                            method="POST" id="deposit-form">
                            <input type="hidden" name="totem_action" value="deposit">
                            <textarea name="broken_matricole" id="broken-input" class="totem-modal-input"
                                style="height: 100px; resize: none;" placeholder="Matricole..."
                                autocomplete="off"></textarea>
                            <div class="totem-modal-actions">
                                <div class="totem-modal-btn cancel"><i class="fas fa-backspace"></i> CHIUDI FINESTRA
                                    (X)
                                </div>
                                <div class="totem-modal-btn confirm" id="deposit-confirm-btn"><i
                                        class="fas fa-level-down-alt fa-rotate-90"></i>
                                    CONFERMA (✓)</div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Modale Annulla e Esci (Tasto Backspace) -->
                <div id="cancel-modal" class="totem-modal-overlay">
                    <div class="totem-modal">
                        <h2><i class="fas fa-exclamation-triangle" style="color: var(--totem-danger);"></i> Annulla
                            Operazione</h2>
                        <p>Vuoi annullare l'operazione in corso e scollegarti?</p>
                        <form action="${pageContext.request.contextPath}/t-8f92a1b3c4d5e6f7g8h9i0j/dashboard"
                            method="POST" id="cancel-form">
                            <input type="hidden" name="totem_action" value="cancel">
                            <div class="totem-modal-actions">
                                <div class="totem-modal-btn cancel"><i class="fas fa-times"></i> NO, TORNA INDIETRO
                                    (X)
                                </div>
                                <div class="totem-modal-btn confirm"><i class="fas fa-level-down-alt fa-rotate-90"></i>
                                    SÌ, ANNULLA E ESCI (✓)</div>
                            </div>
                        </form>
                    </div>
                </div>

                <footer class="totem-footer">
                    <span>TecnoDeposit ™ © 2026</span>
                </footer>

                <!-- Modale Animazione Assegnamento -->
                <div id="assign-success-overlay" class="assign-success-overlay">
                    <h2><i class="fas fa-check-circle" style="margin-right:12px;"></i>Assegnazione Completata!</h2>
                    <p>Gli articoli sono stati assegnati correttamente.</p>
                    <div class="totem-animation-scene">
                        <div class="totem-dolly-group">
                            <i class="fas fa-box box-icon top"></i>
                            <i class="fas fa-box box-icon"></i>
                            <i class="fas fa-dolly dolly-icon"></i>
                        </div>
                    </div>
                </div>
        </div>

        <script>
            function playAssignAnimationAndSubmit() {
                isModalActive = true;
                clearTimer();
                document.getElementById('assign-modal').classList.remove('active');

                const overlay = document.getElementById('assign-success-overlay');
                overlay.classList.add('active');

                // Submit form after animation finishes (4.5 seconds)
                setTimeout(() => {
                    assignForm.submit();
                }, 4500);
            }
            const qrInput = document.getElementById('qr-input');
            const assignModal = document.getElementById('assign-modal');
            const depositModal = document.getElementById('deposit-modal');
            const cancelModal = document.getElementById('cancel-modal');
            const brokenInput = document.getElementById('broken-input');
            const assignForm = document.getElementById('assign-form');
            const depositForm = document.getElementById('deposit-form');
            const cancelForm = document.getElementById('cancel-form');

            // Variabile per capire se siamo in the "modal mode" per dirottare gli input della tastiera
            let isModalActive = false;
            let hasScannedArticles = <%= (session.getAttribute("totem_scanned_articles") != null && !((java.util.List)session.getAttribute("totem_scanned_articles")).isEmpty()) ?"true" : "false" %>;
            let isOperatorLogged = <%= loggedUser != null ? "true" : "false" %>;

            let autoConfirmInterval = null;
            let autoConfirmTimeLeft = 5;

            function startTimer(modal) {
                clearTimer();
                if (modal === cancelModal || modal === depositModal) return; // Solo Assegnazione ha il timer

                autoConfirmTimeLeft = 5;
                let btnId = "assign-confirm-btn";
                let form = assignForm;
                let btn = document.getElementById(btnId);

                const updateBtnText = () => {
                    if (btn) btn.innerHTML = '<i class="fas fa-level-down-alt fa-rotate-90"></i> CONFERMA (' + autoConfirmTimeLeft + 's)';
                };

                updateBtnText();

                autoConfirmInterval = setInterval(() => {
                    autoConfirmTimeLeft--;
                    if (autoConfirmTimeLeft > 0) {
                        updateBtnText();
                    } else {
                        clearTimer();
                        playAssignAnimationAndSubmit();
                    }
                }, 1000);
            }

            function clearTimer() {
                if (autoConfirmInterval) {
                    clearInterval(autoConfirmInterval);
                    autoConfirmInterval = null;
                }
                const assignBtn = document.getElementById('assign-confirm-btn');
                if (assignBtn) assignBtn.innerHTML = '<i class="fas fa-level-down-alt fa-rotate-90"></i> CONFERMA (Enter)';
                const depositBtn = document.getElementById('deposit-confirm-btn');
                if (depositBtn) depositBtn.innerHTML = '<i class="fas fa-level-down-alt fa-rotate-90"></i> CONFERMA (Enter)';
            }

            document.getElementById('qr-form').action = "${pageContext.request.contextPath}/t-8f92a1b3c4d5e6f7g8h9i0j";

            // Gestione dei click (forza refocus sullo scanner MA non se siamo nel modale deposit)
            document.addEventListener('click', (e) => {
                // Reset timer on click inside active modals
                if (isModalActive) {
                    if (assignModal.classList.contains('active')) startTimer(assignModal);
                }

                if (!isModalActive && qrInput) {
                    qrInput.focus();
                } else if (isModalActive && depositModal.classList.contains('active')) {
                    brokenInput.focus();
                }
            });

            let lastKeyTime = Date.now();

            // Gestione Tastiera Globale
            document.addEventListener('keydown', (e) => {
                let timeSinceLastKey = Date.now() - lastKeyTime;
                lastKeyTime = Date.now();

                // 1. GESTIONE MODALI APERTI
                if (isModalActive) {
                    if (e.key !== 'Escape' && e.key !== 'Backspace' && e.key !== 'Enter') {
                        // Reset automatico del timer se l'utente continua a digitare (es. testuale matricole)
                        if (assignModal.classList.contains('active')) startTimer(assignModal);
                    }

                    if (e.key === 'Escape' || e.key === 'Escape') {
                        e.preventDefault();
                        closeAllModals();
                    } else if (e.key === 'Backspace') {
                        // Impedisci di tornare alla pagina precedente
                        if (document.activeElement !== brokenInput || brokenInput.value === '') {
                            e.preventDefault();
                            if (assignModal.classList.contains('active') || depositModal.classList.contains('active') || cancelModal.classList.contains('active')) {
                                closeAllModals();
                            }
                        }
                    } else if (e.key === 'Enter') {
                        if (assignModal.classList.contains('active')) {
                            e.preventDefault();
                            clearTimer();
                            playAssignAnimationAndSubmit();
                        } else if (cancelModal.classList.contains('active')) {
                            e.preventDefault();
                            cancelForm.submit();
                        } else if (depositModal.classList.contains('active')) {
                            // Timer anti-scanner: per evitare che uno scanner barcode invii Enter nel form sbagliato
                            if (timeSinceLastKey > 100) {
                                e.preventDefault();
                                clearTimer();
                                depositForm.submit();
                            }
                        }
                    }
                    return; // Blocca altre azioni se un modale è aperto
                }

                // 2. GESTIONE SCORCIATOIE NORMALI
                if (isOperatorLogged) {
                    if (e.key === 'Backspace') {
                        e.preventDefault(); // Impedisce history.back()
                        openModal(cancelModal);
                    } else if (hasScannedArticles) {
                        if (e.key === '/') {
                            e.preventDefault();
                            openModal(assignModal);
                        } else if (e.key === '*') {
                            e.preventDefault();
                            openModal(depositModal);
                        }
                    }
                }
            });

            function openModal(modal) {
                isModalActive = true;
                modal.classList.add('active');
                if (modal === depositModal) {
                    brokenInput.value = '';
                    if (brokenInput) setTimeout(() => brokenInput.focus(), 50);
                } else if (qrInput) {
                    qrInput.blur();
                }
                startTimer(modal);
            }

            function closeAllModals() {
                clearTimer();
                isModalActive = false;
                assignModal.classList.remove('active');
                depositModal.classList.remove('active');
                cancelModal.classList.remove('active');
                if (qrInput) qrInput.focus();
            }

            window.onload = function () {
                if (!isModalActive && qrInput) qrInput.focus();

                const toasts = document.querySelectorAll('.totem-toast');
                toasts.forEach(toast => {
                    setTimeout(() => toast.remove(), 3500);
                });
            };

            function logoutQr() {
                window.location.href = "${pageContext.request.contextPath}/t-8f92a1b3c4d5e6f7g8h9i0j";
            }
        </script>
    </body>

    </html>