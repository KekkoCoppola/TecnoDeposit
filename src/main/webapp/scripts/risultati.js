

// Se la tua dashboard inserisce questa JSP via AJAX in un <div id="contenitore-articoli">,
// intercetto i click dei link pager e ricarico in AJAX senza cambiare pagina.
// Se non trovi il contenitore, i link funzioneranno come normali <a> (fallback).
document.addEventListener('click', function(e){
  const a = e.target.closest('a[data-ajax="true"]');
  if(!a) return;
  const container = document.getElementById('risultati'); // <-- usa l'ID che già usi
  if(!container) return; // fallback: lascia la navigazione normale
  e.preventDefault();
  fetch(a.getAttribute('href'), { headers: { 'X-Requested-With': 'XMLHttpRequest' }})
    .then(r => r.text())
    .then(html => { container.innerHTML = html; })
    .catch(console.error);
});
  var addButton = document.getElementById('add-article-btn');
  var editButtons = document.querySelectorAll('.edit-btn');
  var assegnaButtons = document.querySelectorAll('.assegnaButton');
  var confirmDeleteBtn = document.getElementById('confirm-delete');
  var deleteModal = document.getElementById('delete-modal');
  var cancelDeleteBtn = document.getElementById('cancel-delete');
  var modaleDettagli = document.getElementById('articleModal');
  var deleteButtons = document.querySelectorAll('.delete-btn');
  var overlayDettagli = document.querySelector('#articleModal .modal-overlay');
  
  
  //MODALE STORICO




  
  //VISUALIZZAZIONE IN BASE ALL'UTENTE
  document.addEventListener('DOMContentLoaded', function() {
      if (ruoloUtente === "Tecnico") {
      	//CAMPI FORM
        document.getElementById('divNome').style.display = 'none';
        document.getElementById('divNote').style.display = 'none';
        document.getElementById('divMatricola').style.display = 'none';
        document.getElementById('divComp').style.display = 'none';
        document.getElementById('divDatagar').style.display = 'none';
        document.getElementById('divDataspe').style.display = 'none';
        document.getElementById('divFornitore').style.display = 'none';
        document.getElementById('divTecnico').style.display = 'none';
        document.getElementById('divMarca').style.display = 'none';
        document.getElementById('divDdt').style.display = 'none';
        document.getElementById('divDdtSpedizione').style.display = 'none';
        document.getElementById('divPv').style.display = 'block';
        document.getElementById('divDataric').style.display = 'none';
        document.getElementById('divProvenienza').style.display = 'block';
        document.getElementById('divAssegnaAMe').style.display = 'block';
        
        

		//PULSANTE ADD
        document.getElementById('add-article-btn').style.display = 'none';
      }else document.getElementById('Articoli-personali').style.display = 'none';
  });
  
    function closeModal() {
        modaleDettagli.classList.add('hidden');
        document.body.style.overflow = 'auto';
    }

  
    
    cancelDeleteBtn.addEventListener('click', function() {
        deleteModal.classList.add('hidden');
    });
    
	function apriDettagli(e){
		console.log(e);
		 const tagNonCliccabili = ['P', 'SPAN', 'H2','BUTTON']; // Aggiungi altri se necessario

		    if (tagNonCliccabili.includes(e.target.tagName)) {
		        return; // Non aprire il modale
		    }
		
		modaleDettagli.classList.remove('hidden');
        document.body.style.overflow = 'auto';
        const card = event.currentTarget; 
        
        
        const id = card.dataset.id;
        const nome = card.dataset.nome;
        const matricola = card.dataset.matricola;
        const marca = card.dataset.marca;
        const compatibilita = card.dataset.compatibilita;
        const ddt = card.dataset.ddt;
        const ddtSpedizione = card.dataset.ddtSpedizione;
        const tecnico = card.dataset.tecnico;
        const pv = card.dataset.pv;
        const provenienza = card.dataset.provenienza;
        const fornitore = card.dataset.fornitore;
        var dataric = card.dataset.dataric;
        var dataspe = card.dataset.dataspe;
        var datagar = card.dataset.datagar;
        const note = card.dataset.note;
        const stato = card.dataset.stato;
        const immagine = card.dataset.immagine;
        const richiesta = card.dataset.richiestaGaranzia;

        
        function formatToItalian(dateStr) {
            if (!dateStr) return "";
            var parts = dateStr.split("-");
            
            if (parts.length === 3 && parts[0] && parts[1] && parts[2]) {
                return parts[2]+"/"+parts[1]+"/"+parts[0];
            }
            return "";
        }

        dataric = formatToItalian(dataric);
        dataspe = formatToItalian(dataspe);
        datagar = formatToItalian(datagar);

        
        console.log("ID ARTICOLO: "+id+ " DDT SPEDIZIONE = "+ddtSpedizione+" DDT RIENTRO = "+ddt);
        
        document.getElementById('nomeDettagli').textContent  = nome;
        document.getElementById('matricolaDettagli').innerHTML = '<i class="fas fa-barcode"></i> Matricola: ' + matricola;
   		document.getElementById('marcaDettagli').textContent = marca;
   		document.getElementById('compatibilitaDettagli').textContent  = compatibilita;
        document.getElementById('ddtDettagli').textContent  = ddt;
        document.getElementById('ddtSpedizioneDettagli').textContent  = ddtSpedizione;
   		document.getElementById('tecnicoDettagli').textContent = tecnico;
   		document.getElementById('pvDettagli').textContent  = pv;
   		document.getElementById('provenienzaDettagli').textContent  = provenienza;
        document.getElementById('fornitoreDettagli').textContent  = fornitore;
   		document.getElementById('dataricDettagli').textContent = dataric;
   		document.getElementById('dataspeDettagli').textContent  = dataspe;
        document.getElementById('datagarDettagli').textContent  = datagar;
   		document.getElementById('noteDettagli').textContent = note;
   		document.getElementById('statoDettagli').textContent  = stato;
   		document.getElementById('immagineDettagli').src = immagine;
   		document.getElementById('richiestagarDettagli').textContent =richiesta === "true" ? "SI" : "NO";
   		const span = document.getElementById('richiestagarDettagli');
   		span.classList.remove("text-green-600", "text-red-600");

       	// Aggiunge il colore corretto
       	if (richiesta === "true") {
      		span.classList.add("font-medium");
	       	span.classList.add("text-green-600");
	    } else {
	    	span.classList.add("font-medium");
	       	span.classList.add("text-red-600");
	    	}

   		console.log(richiesta);
   		
   		const statoBox = document.getElementById('statoDettagli');
   		statoBox.classList.remove('status-riparato','status-in-magazzino','status-installato','status-destinato','status-assegnato','status-guasto','status-non-riparato','status-non-riparabile');
   		switch (stato) {
   	  case 'Guasto':
   	    statoBox.classList.add('status-guasto');
   	    break;
   	  case 'In attesa':
   	    statoBox.classList.add('status-in-attesa');
   	    break;
   	  case 'In magazzino':
   	    statoBox.classList.add('status-in-magazzino');
   	    break;
   	 case 'Riparato':
    	    statoBox.classList.add('status-riparato');
    	    break;
   	 case 'Destinato':
    	    statoBox.classList.add('status-destinato');
    	    break;
   	 case 'Assegnato':
    	    statoBox.classList.add('status-assegnato');
    	    break;
   	 case 'Installato':
    	    statoBox.classList.add('status-installato');
    	    break;
   	case 'Non riparato':
	    statoBox.classList.add('status-non-riparato');
	    break;
   	case 'Non riparabile':
	    statoBox.classList.add('status-non-riparabile');
	    break;
   	  default:
   	    statoBox.classList.add('bg-gray-300'); // stato sconosciuto
   	document.getElementById('bodyDettagli').scrollTop = 0;
   	}

	}
    
  //APERTURA ADD
	addButton.addEventListener('click', function() {
		modal.scrollTop = 0;
		document.getElementById('article-form').reset();
		modal.classList.remove('hidden');
		document.getElementById('formAction').value = 'add';
		document.getElementById('modal-title').textContent = "Aggiungi Nuovo Articolo";
    });
  
	
    //APERTURA EDIT
    editButtons.forEach(button => {
        button.addEventListener('click', function(e) {
        	e.stopPropagation(); 
        	modal.scrollTop = 0;
        	modal.classList.remove('hidden');
        	document.getElementById('formAction').value = 'update';
        	const card = button.closest('.article-card'); // trova il contenitore
            
            const id = card.dataset.id;
            const nome = card.dataset.nome;
            const matricola = card.dataset.matricola;
            const marca = card.dataset.marca;
            const compatibilita = card.dataset.compatibilita;
            const ddt = card.dataset.ddt;
            const ddtSpedizione = card.dataset.ddtSpedizione;
            const tecnico = card.dataset.tecnico;
            const pv = card.dataset.pv;
            const provenienza = card.dataset.provenienza;
            const fornitore = card.dataset.fornitore;
            var dataric = card.dataset.dataric;
            var dataspe = card.dataset.dataspe;
            var datagar = card.dataset.datagar;
            const note = card.dataset.note;
            const stato = card.dataset.stato;
            const immagine = card.dataset.immagine;
            const richiesta = card.dataset.richiestaGaranzia;
            
            
            if (!card) {
                console.error("❌ Elemento .article-card non trovato. Controlla che il bottone sia dentro la card.", button);
                return;
              }
            
            document.getElementById('formId').value = id;
            document.getElementById('statoInput').value = stato;
            document.getElementById('nomeInput').value = nome;
            document.getElementById('marcaInput').value = marca;
            document.getElementById('compatibilitaInput').value = compatibilita;
            document.getElementById('matricolaInput').value = matricola;
            document.getElementById('ddtInput').value = ddt;
            document.getElementById('ddtSpedizioneInput').value  = ddtSpedizione;
            document.getElementById('provenienzaInput').value = provenienza;
            document.getElementById('fornitoreInput').value = fornitore;
            document.getElementById('tecnicoInput').value = tecnico;
            document.getElementById('pvInput').value = pv;
            document.getElementById('datagarInput').value = datagar;
            document.getElementById('dataspeInput').value = dataspe;
            document.getElementById('dataricInput').value = dataric;
            document.getElementById('noteInput').value = note;
            document.getElementById('richiestaInput').checked = richiesta === "true";
            
            document.getElementById('modal-title').textContent = "Modifica Articolo";
            
            // Trigger check immagine dopo aver popolato i campi
            if (typeof checkImmagineArticolo === 'function') {
                checkImmagineArticolo();
            }
        });
    });
    //ASSEGNA BUTTON
    assegnaButtons.forEach(button => {
        button.addEventListener('click', function(e) {
        	e.stopPropagation(); 
        	modal.scrollTop = 0;
        	document.getElementById('formAction').value = 'update';
        	const card = button.closest('.article-card'); // trova il contenitore
            
            const id = card.dataset.id;
            const nome = card.dataset.nome;
            const matricola = card.dataset.matricola;
            const marca = card.dataset.marca;
            const compatibilita = card.dataset.compatibilita;
            const ddt = card.dataset.ddt;
            const ddtSpedizione = card.dataset.ddtSpedizione;
            const tecnico = card.dataset.tecnico;
            const pv = card.dataset.pv;
            const provenienza = card.dataset.provenienza;
            const fornitore = card.dataset.fornitore;
            var dataric = card.dataset.dataric;
            var dataspe = card.dataset.dataspe;
            var datagar = card.dataset.datagar;
            const note = card.dataset.note;
            const stato = card.dataset.stato;
            const immagine = card.dataset.immagine;
            const richiesta = card.dataset.richiestaGaranzia;
            
            
            if (!card) {
                console.error("❌ Elemento .article-card non trovato. Controlla che il bottone sia dentro la card.", button);
                return;
              }
            
            document.getElementById('formId').value = id;
            document.getElementById('statoInput').value = stato;
            document.getElementById('nomeInput').value = nome;
            document.getElementById('marcaInput').value = marca;
            document.getElementById('compatibilitaInput').value = compatibilita;
            document.getElementById('matricolaInput').value = matricola;
            document.getElementById('ddtInput').value = ddt;
            document.getElementById('ddtSpedizioneInput').value  = ddtSpedizione;
            document.getElementById('provenienzaInput').value = provenienza;
            document.getElementById('fornitoreInput').value = fornitore;
            document.getElementById('tecnicoInput').value = tecnico;
            document.getElementById('pvInput').value = pv;
            document.getElementById('datagarInput').value = datagar;
            document.getElementById('dataspeInput').value = dataspe;
            document.getElementById('dataricInput').value = dataric;
            document.getElementById('noteInput').value = note;
            document.getElementById('richiestaInput').checked = richiesta === "true";
            
            document.getElementById('modal-title').textContent = "Modifica Articolo";
            
        });
    });
    
    //DELETE
    deleteButtons.forEach(button => {
    	
        button.addEventListener('click', function(e) {
        	e.stopPropagation(); 
        	deleteModal.classList.remove('hidden');
        	const card = button.closest('.article-card'); // trova il contenitore
        	const id = card.dataset.id;
        	confirmDeleteBtn.dataset.id = id;
        });
    });
    
    confirmDeleteBtn.addEventListener('click', function() { 
    	
    	deleteModal.classList.add('hidden');
    	document.getElementById('formAction').value = 'delete';
    	const id = this.dataset.id; // Prende l'id salvato prima
        document.getElementById('formId').value = id;
    	console.log("PRESO ID: "+id);
        
    	
        document.getElementById('article-form').submit();  
        
      });

    window.addEventListener('click', function(e) {
    	
        if (e.target === modal) {
            modal.classList.add('hidden');
        }
        if (e.target === deleteModal) {
            deleteModal.classList.add('hidden');
        }
        if (e.target === modaleDettagli || e.target === overlayDettagli) {
            modaleDettagli.classList.add('hidden');
        }
    });
    
    //QR CODE
    document.querySelectorAll('.openQrModal').forEach(function (button) {
		button.addEventListener('click', function () {
    document.getElementById('qrModal').classList.remove('hidden');
    document.getElementById('qrcode').innerHTML = "";
    const card = button.closest('.article-card'); 
    const matricola = card.dataset.matricola;
    const nome = card.dataset.nome;
    document.getElementById('nomeQr').textContent = nome;
    document.getElementById('matricolaQr').textContent = matricola;
    
    new QRCode(document.getElementById("qrcode"), {
      text: matricola,
      width: 200,
      height: 200,
      colorDark: "#000000",
      colorLight: "#ffffff",
      correctLevel: QRCode.CorrectLevel.H 
   			 });
  		});
    });

  document.getElementById('closeQrModal').addEventListener('click', function () {
    document.getElementById('qrModal').classList.add('hidden');
  });
  //DOWNLOAD QR
	function scaricaQR() {
	  const qrCanvas = document.querySelector('#qrcode canvas');
	  if (!qrCanvas) return alert("QR non generato");
	
	  const link = document.createElement('a');
	  link.download = 'qr.png';
	  link.href = qrCanvas.toDataURL("image/png");
	  link.click();
	}
	//STAMPA QR

	function stampaQR() {
	  const qrCanvas = document.querySelector('#qrcode canvas');
	  if (!qrCanvas) return alert("QR non generato");
	
	  const qrData = qrCanvas.toDataURL("image/png");
	  const nome = document.getElementById("nomeQr").textContent || "Articolo";
	
	  const logoBase64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAUZJREFUWEdjZKAQMFBfU3BQUJBgcHJy8mVnZ4eYmJhRBXHgxv79+4ZGRkbZ9+/fX3BwMHACpnaMjKycigkJCTEbFdXV1dwaGho1PHjx5WJiQmZm5sLi4uKYkZGJr+zs7Ahbtx489nV1TUmJSXp6ekxIiJCPeDLly+H0NBQRUbGRmFgYLCwsEhLS8tX7e3tqVpbW0+FhYVhYmKSiYkJ+fn5yZs3b65qaGgwcOFCZmZmYmJj4mZGR4fLlyzVwcnLy38bGxg8zMzHF1dbVcXV2dhISEUF5enqampoxfPjwIfn5+UFRU1ICBgTEhImIYGBg5ePAgRUZG+paWlpCSklJaWpqapKgUFBQQEBBRtL7+/lJJSYkDh8uXLwZubm5GRkeFISEjYxo8fH0HBwYCZmZn5JSYmRsbGRJiYmCQBvmkV7nP+AKUAAAAASUVORK5CYII=";
	
	  // Costruzione HTML temporaneo
	  const html = `
	    <div style="width:58mm; font-family:monospace; text-align:center; padding:5mm;">
	      <img src="${logoBase64}" width="40" height="40"><br>
	      <p style="margin:0;">${nome}</p>
	      <img src="${qrData}" width="150" height="150">
	    </div>
	  `;
	
	  const container = document.getElementById("etichetta-stampa");
	  container.innerHTML = html;
	  container.style.display = "block";
	
	  // Stampa del contenuto HTML esistente (molto più stabile)
	  const printWindow = window.print();
	
	  // Ripristina stato originale
	  setTimeout(() => {
	    container.style.display = "none";
	    container.innerHTML = "";
	  }, 1000);
	}

