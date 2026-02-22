
// Se la tua dashboard inserisce questa JSP via AJAX in un <div id="contenitore-articoli">,
// intercetto i click dei link pager e ricarico in AJAX senza cambiare pagina.
// Se non trovi il contenitore, i link funzioneranno come normali <a> (fallback).
document.addEventListener('click', function (e) {
  var a = e.target.closest('a[data-ajax="true"]');
  if (!a) return;
  var container = document.getElementById('risultati');
  if (!container) return;
  e.preventDefault();
  fetch(a.getAttribute('href'), { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
    .then(function (r) { return r.text(); })
    .then(function (html) { container.innerHTML = html; })
    .catch(console.error);
});

// Dati dell'articolo corrente per QR label scarica/stampa
var _currentLabelData = null;


//VISUALIZZAZIONE IN BASE ALL'UTENTE
document.addEventListener('DOMContentLoaded', function () {
  if (typeof ruoloUtente !== 'undefined' && ruoloUtente === "Tecnico") {
    //CAMPI FORM
    document.getElementById('divNome').style.display = 'none';
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
  } else {
    var artPersonali = document.getElementById('Articoli-personali');
    if (artPersonali) artPersonali.style.display = 'none';
  }
});


// ======================================================================
// EVENT DELEGATION — tutti i click handler delegati su document
// In questo modo funzionano sia al caricamento iniziale che dopo AJAX
// I modali vengono SEMPRE cercati freschi nel DOM (no variabili cached)
// ======================================================================

document.addEventListener('click', function (e) {

  // --- CANCEL DELETE ---
  if (e.target.closest('#cancel-delete')) {
    var dm = document.getElementById('delete-modal');
    if (dm) dm.classList.add('hidden');
    return;
  }

  // --- CONFIRM DELETE ---
  if (e.target.closest('#confirm-delete')) {
    var dm = document.getElementById('delete-modal');
    if (dm) dm.classList.add('hidden');
    document.getElementById('formAction').value = 'delete';
    var confirmBtn = e.target.closest('#confirm-delete');
    var id = confirmBtn.dataset.id;
    document.getElementById('formId').value = id;
    console.log("PRESO ID: " + id);
    document.getElementById('article-form').submit();
    return;
  }

  // --- CLOSE QR MODAL ---
  if (e.target.closest('#closeQrModal')) {
    var qm = document.getElementById('qrModal');
    if (qm) qm.classList.add('hidden');
    return;
  }

  // --- DOWNLOAD PNG ETICHETTA ---
  if (e.target.closest('#btnScaricaLabel')) {
    if (!_currentLabelData) return alert('Etichetta non generata');
    var logoImg = document.getElementById('qrLogo');
    downloadLabelPNG(_currentLabelData, logoImg);
    return;
  }

  // --- STAMPA ETICHETTA ---
  if (e.target.closest('#btnStampaLabel')) {
    if (!_currentLabelData) return alert('Etichetta non generata');
    var logoImg = document.getElementById('qrLogo');
    printLabel(_currentLabelData, logoImg);
    return;
  }

  // --- QR OPEN ---
  var qrBtn = e.target.closest('.openQrModal');
  if (qrBtn) {
    e.stopPropagation(); // impedisce apertura dettagli articolo
    var card = qrBtn.closest('.article-card');
    if (!card) return;
    var matricola = card.dataset.matricola;
    var nome = card.dataset.nome;
    var dataSpe = card.dataset.dataspe;

    if (!matricola || matricola.trim() === '' || matricola === 'null' || matricola === 'undefined') {
      showQrWarningToast('L\'articolo "' + nome + '" non ha una matricola');
      return;
    }

    _currentLabelData = { matricola: matricola, nome: nome, dataSpe: dataSpe };

    var qm = document.getElementById('qrModal');
    if (qm) qm.classList.remove('hidden');

    var canvas = document.getElementById('labelCanvas');
    var logoImg = document.getElementById('qrLogo');
    renderLabel(canvas, _currentLabelData, logoImg);
    return;
  }

  // --- EDIT ---
  var editBtn = e.target.closest('.edit-btn');
  if (editBtn) {
    e.stopPropagation(); // impedisce apertura dettagli articolo
    var modal = document.getElementById('article-modal');
    if (modal) modal.scrollTop = 0;
    if (modal) modal.classList.remove('hidden');
    document.getElementById('formAction').value = 'update';
    var card = editBtn.closest('.article-card');

    if (!card) {
      console.error("Elemento .article-card non trovato.", editBtn);
      return;
    }

    var id = card.dataset.id;
    var nome = card.dataset.nome;
    var matricola = card.dataset.matricola;
    var marca = card.dataset.marca;
    var compatibilita = card.dataset.compatibilita;
    var ddt = card.dataset.ddt;
    var ddtSpedizione = card.dataset.ddtSpedizione;
    var tecnico = card.dataset.tecnico;
    var pv = card.dataset.pv;
    var provenienza = card.dataset.provenienza;
    var fornitore = card.dataset.fornitore;
    var dataric = card.dataset.dataric;
    var dataspe = card.dataset.dataspe;
    var datagar = card.dataset.datagar;
    var note = card.dataset.note;
    var stato = card.dataset.stato;
    var immagine = card.dataset.immagine;
    var richiesta = card.dataset.richiestaGaranzia;

    document.getElementById('formId').value = id;
    document.getElementById('statoInput').value = stato;
    document.getElementById('nomeInput').value = nome;
    document.getElementById('marcaInput').value = marca;
    document.getElementById('compatibilitaInput').value = compatibilita;
    document.getElementById('matricolaInput').value = matricola;
    document.getElementById('ddtInput').value = ddt;
    document.getElementById('ddtSpedizioneInput').value = ddtSpedizione;
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

    if (typeof checkImmagineArticolo === 'function') {
      checkImmagineArticolo();
    }
    return;
  }

  // --- ASSEGNA ---
  var assegnaBtn = e.target.closest('.assegnaButton');
  if (assegnaBtn) {
    e.stopPropagation(); // impedisce apertura dettagli articolo
    var modal = document.getElementById('article-modal');
    if (modal) modal.scrollTop = 0;
    document.getElementById('formAction').value = 'update';
    var card = assegnaBtn.closest('.article-card');

    if (!card) {
      console.error("Elemento .article-card non trovato.", assegnaBtn);
      return;
    }

    var id = card.dataset.id;
    var nome = card.dataset.nome;
    var matricola = card.dataset.matricola;
    var marca = card.dataset.marca;
    var compatibilita = card.dataset.compatibilita;
    var ddt = card.dataset.ddt;
    var ddtSpedizione = card.dataset.ddtSpedizione;
    var tecnico = card.dataset.tecnico;
    var pv = card.dataset.pv;
    var provenienza = card.dataset.provenienza;
    var fornitore = card.dataset.fornitore;
    var dataric = card.dataset.dataric;
    var dataspe = card.dataset.dataspe;
    var datagar = card.dataset.datagar;
    var note = card.dataset.note;
    var stato = card.dataset.stato;
    var immagine = card.dataset.immagine;
    var richiesta = card.dataset.richiestaGaranzia;

    document.getElementById('formId').value = id;
    document.getElementById('statoInput').value = stato;
    document.getElementById('nomeInput').value = nome;
    document.getElementById('marcaInput').value = marca;
    document.getElementById('compatibilitaInput').value = compatibilita;
    document.getElementById('matricolaInput').value = matricola;
    document.getElementById('ddtInput').value = ddt;
    document.getElementById('ddtSpedizioneInput').value = ddtSpedizione;
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
    return;
  }

  // --- DELETE (apri conferma) ---
  var delBtn = e.target.closest('.delete-btn');
  if (delBtn) {
    e.stopPropagation(); // impedisce apertura dettagli articolo
    var dm = document.getElementById('delete-modal');
    if (dm) dm.classList.remove('hidden');
    var card = delBtn.closest('.article-card');
    if (card) {
      var confirmBtn = document.getElementById('confirm-delete');
      if (confirmBtn) confirmBtn.dataset.id = card.dataset.id;
    }
    return;
  }

  // --- ADD ---
  if (e.target.closest('#add-article-btn')) {
    var modal = document.getElementById('article-modal');
    if (modal) modal.scrollTop = 0;
    var form = document.getElementById('article-form');
    if (form) form.reset();
    if (modal) modal.classList.remove('hidden');
    document.getElementById('formAction').value = 'add';
    document.getElementById('modal-title').textContent = "Aggiungi Nuovo Articolo";
    return;
  }

});

// === CLICK FUORI MODALE PER CHIUDERE ===
window.addEventListener('click', function (e) {
  var modal = document.getElementById('article-modal');
  var deleteModal = document.getElementById('delete-modal');
  var modaleDettagli = document.getElementById('articleModal');
  var overlayDettagli = document.querySelector('#articleModal .modal-overlay');

  if (modal && e.target === modal) {
    modal.classList.add('hidden');
  }
  if (deleteModal && e.target === deleteModal) {
    deleteModal.classList.add('hidden');
  }
  if (modaleDettagli && (e.target === modaleDettagli || e.target === overlayDettagli)) {
    modaleDettagli.classList.add('hidden');
  }
});


// === FUNZIONI GLOBALI (accessibili da onclick inline nel JSP) ===

function closeModal() {
  var m = document.getElementById('articleModal');
  if (m) m.classList.add('hidden');
  document.body.style.overflow = 'auto';
}

function apriDettagli(e) {
  // Se il click proviene da un pulsante azione (edit, delete, QR, storico, assegna),
  // non aprire il modale dettagli
  if (e.target.closest('.edit-btn, .delete-btn, .openQrModal, .assegnaButton, [onclick*="caricaStoricoArticolo"]')) {
    return;
  }

  var modaleDettagli = document.getElementById('articleModal');
  if (!modaleDettagli) return;
  modaleDettagli.classList.remove('hidden');
  document.body.style.overflow = 'auto';
  var card = e.currentTarget;

  var id = card.dataset.id;
  var nome = card.dataset.nome;
  var matricola = card.dataset.matricola;
  var marca = card.dataset.marca;
  var compatibilita = card.dataset.compatibilita;
  var ddt = card.dataset.ddt;
  var ddtSpedizione = card.dataset.ddtSpedizione;
  var tecnico = card.dataset.tecnico;
  var pv = card.dataset.pv;
  var provenienza = card.dataset.provenienza;
  var fornitore = card.dataset.fornitore;
  var dataric = card.dataset.dataric;
  var dataspe = card.dataset.dataspe;
  var datagar = card.dataset.datagar;
  var note = card.dataset.note;
  var stato = card.dataset.stato;
  var immagine = card.dataset.immagine;
  var richiesta = card.dataset.richiestaGaranzia;

  function formatToItalian(dateStr) {
    if (!dateStr) return "";
    var parts = dateStr.split("-");
    if (parts.length === 3 && parts[0] && parts[1] && parts[2]) {
      return parts[2] + "/" + parts[1] + "/" + parts[0];
    }
    return "";
  }

  dataric = formatToItalian(dataric);
  dataspe = formatToItalian(dataspe);
  datagar = formatToItalian(datagar);

  console.log("ID ARTICOLO: " + id + " DDT SPEDIZIONE = " + ddtSpedizione + " DDT RIENTRO = " + ddt);

  document.getElementById('nomeDettagli').textContent = nome;
  document.getElementById('matricolaDettagli').innerHTML = '<i class="fas fa-barcode"></i> Matricola: ' + matricola;
  document.getElementById('marcaDettagli').textContent = marca;
  document.getElementById('compatibilitaDettagli').textContent = compatibilita;
  document.getElementById('ddtDettagli').textContent = ddt;
  document.getElementById('ddtSpedizioneDettagli').textContent = ddtSpedizione;
  document.getElementById('tecnicoDettagli').textContent = tecnico;
  document.getElementById('pvDettagli').textContent = pv;
  document.getElementById('provenienzaDettagli').textContent = provenienza;
  document.getElementById('fornitoreDettagli').textContent = fornitore;
  document.getElementById('dataricDettagli').textContent = dataric;
  document.getElementById('dataspeDettagli').textContent = dataspe;
  document.getElementById('datagarDettagli').textContent = datagar;
  document.getElementById('noteDettagli').textContent = note;
  document.getElementById('statoDettagli').textContent = stato;
  document.getElementById('immagineDettagli').src = immagine;
  document.getElementById('richiestagarDettagli').textContent = richiesta === "true" ? "SI" : "NO";
  var span = document.getElementById('richiestagarDettagli');
  span.classList.remove("text-green-600", "text-red-600");

  if (richiesta === "true") {
    span.classList.add("font-medium");
    span.classList.add("text-green-600");
  } else {
    span.classList.add("font-medium");
    span.classList.add("text-red-600");
  }

  var statoBox = document.getElementById('statoDettagli');
  statoBox.classList.remove('status-riparato', 'status-in-magazzino', 'status-installato', 'status-destinato', 'status-assegnato', 'status-guasto', 'status-non-riparato', 'status-non-riparabile');
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
      statoBox.classList.add('bg-gray-300');
      var bodyDett = document.getElementById('bodyDettagli');
      if (bodyDett) bodyDett.scrollTop = 0;
  }
}

// Funzione per mostrare toast di avviso QR
function showQrWarningToast(message) {
  var existingToast = document.getElementById('qr-warning-toast');
  if (existingToast) existingToast.remove();

  var toast = document.createElement('div');
  toast.id = 'qr-warning-toast';
  toast.className = 'fixed top-5 left-1/2 transform -translate-x-1/2 bg-orange-500 text-white px-4 py-3 rounded-lg shadow-lg z-[100] flex items-center gap-2 animate-slide-down';
  toast.innerHTML = '<i class="fas fa-exclamation-triangle"></i><span>' + message + '</span>';
  document.body.appendChild(toast);

  setTimeout(function () {
    toast.style.opacity = '0';
    toast.style.transition = 'opacity 0.3s';
    setTimeout(function () { toast.remove(); }, 300);
  }, 3000);
}
