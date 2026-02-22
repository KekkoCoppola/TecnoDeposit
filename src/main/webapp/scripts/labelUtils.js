/**
 * labelUtils.js - Utility condivisa per generazione etichette QR
 * Layout: 64mm × 25mm, QR a sinistra, info (nome, matricola, data sped.) a destra
 */

// Dimensioni etichetta in mm — uso var per evitare errori di ri-dichiarazione
var LABEL_W_MM = 64;
var LABEL_H_MM = 25;
var MM_TO_PX = 3.78; // ~96 DPI

// Dimensioni canvas in px (alta risoluzione per qualità)
var SCALE = 3; // moltiplicatore per rendering nitido
var LABEL_W_PX = Math.round(LABEL_W_MM * MM_TO_PX * SCALE);
var LABEL_H_PX = Math.round(LABEL_H_MM * MM_TO_PX * SCALE);
var QR_SIZE_PX = LABEL_H_PX - 12 * SCALE;

// Logo base64 (IconBN.png)
var LOGO_BASE64 = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAAAXNSR0IArs4c6QAAAUZJREFUWEdjZKAQMFBfU3BQUJBgcHJy8mVnZ4eYmJhRBXHgxv79+4ZGRkbZ9+/fX3BwMHACpnaMjKycigkJCTEbFdXV1dwaGho1PHjx5WJiQmZm5sLi4uKYkZGJr+zs7Ahbtx489nV1TUmJSXp6ekxIiJCPeDLly+H0NBQRUbGRmFgYLCwsEhLS8tX7e3tqVpbW0+FhYVhYmKSiYkJ+fn5yZs3b65qaGgwcOFCZmZmYmJj4mZGR4fLlyzVwcnLy38bGxg8zMzHF1dbVcXV2dhISEUF5enqampoxfPjwIfn5+UFRU1ICBgTEhImIYGBg5ePAgRUZG+paWlpCSklJaWpqapKgUFBQQEBBRtL7+/lJJSYkDh8uXLwZubm5GRkeFISEjYxo8fH0HBwYCZmZn5JSYmRsbGRJiYmCQBvmkV7nP+AKUAAAAASUVORK5CYII=";

/**
 * Genera un QRCode come canvas, con logo opzionale al centro
 * @param {string} text - Testo da codificare nel QR
 * @param {number} size - Dimensione del QR in pixel
 * @param {HTMLImageElement|null} logoImg - Elemento <img> del logo (opzionale)
 * @returns {Promise<HTMLCanvasElement>}
 */
function generateQR(text, size, logoImg) {
    return new Promise(function (resolve, reject) {
        try {
            var tempDiv = document.createElement('div');
            tempDiv.style.position = 'absolute';
            tempDiv.style.left = '-9999px';
            document.body.appendChild(tempDiv);

            new QRCode(tempDiv, {
                text: text,
                width: size,
                height: size,
                colorDark: "#000000",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.H
            });

            setTimeout(function () {
                var canvas = tempDiv.querySelector('canvas');
                if (canvas && logoImg) {
                    var ctx = canvas.getContext('2d');
                    var logoSize = Math.round(size * 0.22);
                    var centerX = (canvas.width - logoSize) / 2;
                    var centerY = (canvas.height - logoSize) / 2;

                    // Sfondo bianco sotto il logo per leggibilità
                    ctx.fillStyle = '#ffffff';
                    ctx.fillRect(centerX - 2, centerY - 2, logoSize + 4, logoSize + 4);

                    if (logoImg.complete && logoImg.naturalWidth > 0) {
                        ctx.drawImage(logoImg, centerX, centerY, logoSize, logoSize);
                        document.body.removeChild(tempDiv);
                        resolve(canvas);
                    } else {
                        logoImg.onload = function () {
                            ctx.drawImage(logoImg, centerX, centerY, logoSize, logoSize);
                            document.body.removeChild(tempDiv);
                            resolve(canvas);
                        };
                    }
                } else if (canvas) {
                    document.body.removeChild(tempDiv);
                    resolve(canvas);
                } else {
                    document.body.removeChild(tempDiv);
                    reject(new Error('QR canvas non generato'));
                }
            }, 150);
        } catch (e) {
            console.error('Errore in generateQR:', e);
            reject(e);
        }
    });
}

/**
 * Renderizza etichetta rettangolare su un <canvas>
 * Layout: QR a sinistra, testo a destra (nome, matricola, data spedizione)
 *
 * @param {HTMLCanvasElement} targetCanvas - Canvas di destinazione
 * @param {object} data - { matricola, nome, dataSpe }
 * @param {HTMLImageElement|null} logoImg - Logo da sovrapporre al QR (opzionale)
 * @returns {Promise<void>}
 */
function renderLabel(targetCanvas, data, logoImg) {
    targetCanvas.width = LABEL_W_PX;
    targetCanvas.height = LABEL_H_PX;
    var ctx = targetCanvas.getContext('2d');

    // Sfondo bianco
    ctx.fillStyle = '#ffffff';
    ctx.fillRect(0, 0, LABEL_W_PX, LABEL_H_PX);

    // Bordo arrotondato
    var r = 6 * SCALE;
    ctx.strokeStyle = '#333333';
    ctx.lineWidth = 1.5 * SCALE;
    roundRect(ctx, 1, 1, LABEL_W_PX - 2, LABEL_H_PX - 2, r);
    ctx.stroke();

    // --- QR Code a sinistra ---
    var padding = 6 * SCALE;
    var qrSize = LABEL_H_PX - padding * 2;

    return generateQR(data.matricola, qrSize, logoImg).then(function (qrCanvas) {
        ctx.drawImage(qrCanvas, padding, padding, qrSize, qrSize);

        // --- Linea separatrice ---
        var sepX = padding + qrSize + padding;
        ctx.strokeStyle = '#cccccc';
        ctx.lineWidth = 1 * SCALE;
        ctx.beginPath();
        ctx.moveTo(sepX, padding);
        ctx.lineTo(sepX, LABEL_H_PX - padding);
        ctx.stroke();

        // --- Testo a destra ---
        var textX = sepX + padding;
        var textMaxW = LABEL_W_PX - textX - padding;
        var lineHeight = 6 * SCALE;
        var textY = padding + lineHeight + 2 * SCALE;

        // Nome (bold, più grande)
        ctx.fillStyle = '#1a1a1a';
        ctx.font = 'bold ' + (5.5 * SCALE) + 'px Arial, sans-serif';
        var truncatedNome = truncateText(ctx, data.nome || '', textMaxW);
        ctx.fillText(truncatedNome, textX, textY);

        // Matricola
        textY += lineHeight + 2 * SCALE;
        ctx.fillStyle = '#444444';
        ctx.font = (4.5 * SCALE) + "px 'Courier New', monospace";
        ctx.fillText(data.matricola || '', textX, textY);

        // Data spedizione
        textY += lineHeight + 1 * SCALE;
        ctx.fillStyle = '#666666';
        ctx.font = (4 * SCALE) + 'px Arial, sans-serif';
        var dataSpeFormatted = formatDate(data.dataSpe);
        ctx.fillText(dataSpeFormatted ? 'Sped: ' + dataSpeFormatted : '', textX, textY);
    }).catch(function (e) {
        console.error('Errore renderLabel:', e);
    });
}

/**
 * Scarica l'etichetta come immagine PNG
 * @param {object} data - { matricola, nome, dataSpe }
 * @param {HTMLImageElement|null} logoImg - Logo opzionale
 */
function downloadLabelPNG(data, logoImg) {
    var canvas = document.createElement('canvas');
    renderLabel(canvas, data, logoImg).then(function () {
        var link = document.createElement('a');
        var filename = 'etichetta_' + (data.matricola || 'qr').replace(/[^a-zA-Z0-9]/g, '_') + '.png';
        link.download = filename;
        link.href = canvas.toDataURL('image/png');
        link.click();
    });
}

/**
 * Stampa l'etichetta
 * @param {object} data - { matricola, nome, dataSpe }
 * @param {HTMLImageElement|null} logoImg - Logo opzionale
 */
function printLabel(data, logoImg) {
    var canvas = document.createElement('canvas');
    renderLabel(canvas, data, logoImg).then(function () {
        var imgData = canvas.toDataURL('image/png');

        // Apri una finestra popup dedicata con solo l'etichetta
        var printWin = window.open('', '_blank', 'width=400,height=200');
        if (!printWin) return alert('Popup bloccato dal browser. Abilita i popup per stampare.');

        printWin.document.open();
        printWin.document.write(
            '<!DOCTYPE html>' +
            '<html><head><title>Stampa Etichetta</title>' +
            '<style>' +
            '@page {' +
            '  size: ' + LABEL_W_MM + 'mm ' + LABEL_H_MM + 'mm;' +
            '  margin: 0;' +
            '}' +
            '* { margin: 0; padding: 0; box-sizing: border-box; }' +
            'html, body {' +
            '  width: ' + LABEL_W_MM + 'mm;' +
            '  height: ' + LABEL_H_MM + 'mm;' +
            '  overflow: hidden;' +
            '}' +
            'img {' +
            '  display: block;' +
            '  width: ' + LABEL_W_MM + 'mm;' +
            '  height: ' + LABEL_H_MM + 'mm;' +
            '  object-fit: contain;' +
            '}' +
            '</style></head>' +
            '<body>' +
            '<img src="' + imgData + '">' +
            '</body></html>'
        );
        printWin.document.close();

        // Attendi il caricamento dell'immagine, poi stampa e chiudi
        printWin.onload = function () {
            setTimeout(function () {
                printWin.focus();
                printWin.print();
                // Chiudi dopo che l'utente chiude la dialog di stampa
                setTimeout(function () { printWin.close(); }, 500);
            }, 200);
        };
    });
}

/**
 * Renderizza etichetta nel PDF (jsPDF)
 * @param {jsPDF} pdf - Istanza jsPDF
 * @param {number} x - Posizione X in mm
 * @param {number} y - Posizione Y in mm
 * @param {object} data - { matricola, nome, dataSpe }
 * @param {HTMLImageElement|null} logoImg - Logo opzionale
 */
function renderLabelPDF(pdf, x, y, data, logoImg) {
    var w = LABEL_W_MM;
    var h = LABEL_H_MM;

    // Sfondo bianco e bordo
    pdf.setFillColor(255, 255, 255);
    pdf.roundedRect(x, y, w, h, 2, 2, 'F');
    pdf.setDrawColor(60, 60, 60);
    pdf.setLineWidth(0.4);
    pdf.roundedRect(x, y, w, h, 2, 2);

    // QR code a sinistra
    var qrMargin = 2;
    var qrSize = h - qrMargin * 2; // ~21mm

    return generateQR(data.matricola, 128, logoImg).then(function (qrCanvas) {
        var qrImgData = qrCanvas.toDataURL('image/png');
        pdf.addImage(qrImgData, 'PNG', x + qrMargin, y + qrMargin, qrSize, qrSize);

        // Linea separatrice
        var sepX = x + qrMargin + qrSize + 1.5;
        pdf.setDrawColor(200, 200, 200);
        pdf.setLineWidth(0.3);
        pdf.line(sepX, y + qrMargin, sepX, y + h - qrMargin);

        // Testo a destra
        var textX = sepX + 2;
        var maxTextW = w - (textX - x) - 2;

        // Nome (bold)
        pdf.setFont('helvetica', 'bold');
        pdf.setFontSize(8);
        pdf.setTextColor(26, 26, 26);
        var nomeLines = pdf.splitTextToSize(data.nome || '', maxTextW);
        pdf.text(nomeLines.slice(0, 2), textX, y + 6);

        // Matricola
        var matY = nomeLines.length > 1 ? y + 13 : y + 11;
        pdf.setFont('courier', 'normal');
        pdf.setFontSize(7);
        pdf.setTextColor(68, 68, 68);
        pdf.text(data.matricola || '', textX, matY);

        // Data spedizione
        var dateY = matY + 4.5;
        pdf.setFont('helvetica', 'normal');
        pdf.setFontSize(6.5);
        pdf.setTextColor(100, 100, 100);
        var dataSpeFormatted = formatDate(data.dataSpe);
        if (dataSpeFormatted) {
            pdf.text('Sped: ' + dataSpeFormatted, textX, dateY);
        }
    });
}


// === Helper Functions ===

/**
 * Disegna un rettangolo arrotondato su un context 2D
 */
function roundRect(ctx, x, y, w, h, r) {
    ctx.beginPath();
    ctx.moveTo(x + r, y);
    ctx.lineTo(x + w - r, y);
    ctx.arcTo(x + w, y, x + w, y + r, r);
    ctx.lineTo(x + w, y + h - r);
    ctx.arcTo(x + w, y + h, x + w - r, y + h, r);
    ctx.lineTo(x + r, y + h);
    ctx.arcTo(x, y + h, x, y + h - r, r);
    ctx.lineTo(x, y + r);
    ctx.arcTo(x, y, x + r, y, r);
    ctx.closePath();
}

/**
 * Tronca il testo aggiungendo "..." se supera la larghezza massima
 */
function truncateText(ctx, text, maxWidth) {
    if (ctx.measureText(text).width <= maxWidth) return text;
    var truncated = text;
    while (truncated.length > 0 && ctx.measureText(truncated + '...').width > maxWidth) {
        truncated = truncated.slice(0, -1);
    }
    return truncated + '...';
}

/**
 * Formatta una data nel formato dd/mm/yyyy italiano
 * Gestisce stringhe ISO (yyyy-mm-dd), Date objects, e null
 */
function formatDate(dateStr) {
    if (!dateStr || dateStr === 'null' || dateStr === 'undefined' || dateStr === '') return '';
    try {
        // Se è già in formato dd/mm/yyyy
        if (/^\d{2}\/\d{2}\/\d{4}$/.test(dateStr)) return dateStr;
        // Se è formato ISO yyyy-mm-dd
        if (/^\d{4}-\d{2}-\d{2}/.test(dateStr)) {
            var parts = dateStr.split('-');
            return parts[2].substring(0, 2) + '/' + parts[1] + '/' + parts[0];
        }
        return dateStr;
    } catch (e) {
        return '';
    }
}
