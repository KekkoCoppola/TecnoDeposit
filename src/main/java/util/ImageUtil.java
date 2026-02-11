package util;

import java.io.File;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.util.HashSet;
import java.util.Set;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.awt.Graphics2D;
import javax.imageio.ImageIO;

/**
 * Utility centralizzata per la gestione delle immagini articolo.
 * Evita duplicazione del codice tra ArticoloServlet e FiltroServlet.
 */
public class ImageUtil {

    private static final String[] ESTENSIONI = { ".png", ".jpg", ".jpeg", ".webp" };
    private static final String FALLBACK_IMAGE = "/Icon.png";

    // Cache delle immagini disponibili per performance
    private static Set<String> cachedFileNames = null;
    private static long cacheTimestamp = 0;
    private static final long CACHE_TTL_MS = 60000; // 1 minuto
    private static String cachedDirectoryPath = null;

    /**
     * Normalizza una stringa per creare un nome file valido.
     * Converte in lowercase, rimuove accenti e caratteri speciali.
     */
    public static String slugify(String input) {
        if (input == null || input.isEmpty())
            return "";
        return input.toLowerCase()
                .replaceAll("[àáäâ]", "a")
                .replaceAll("[èéëê]", "e")
                .replaceAll("[ìíïî]", "i")
                .replaceAll("[òóöô]", "o")
                .replaceAll("[ùúüû]", "u")
                .replaceAll("[^a-z0-9]", "");
    }

    /**
     * Aggiorna la cache dei file immagine se scaduta.
     */
    private static synchronized void refreshCacheIfNeeded(String directoryPath) {
        long now = System.currentTimeMillis();
        if (cachedFileNames == null ||
                !directoryPath.equals(cachedDirectoryPath) ||
                (now - cacheTimestamp) > CACHE_TTL_MS) {

            cachedFileNames = new HashSet<>();
            cachedDirectoryPath = directoryPath;
            cacheTimestamp = now;

            File dir = new File(directoryPath);
            if (dir.exists() && dir.isDirectory()) {
                File[] files = dir.listFiles();
                if (files != null) {
                    for (File f : files) {
                        if (f.isFile()) {
                            cachedFileNames.add(f.getName().toLowerCase());
                        }
                    }
                }
            }
        }
    }

    /**
     * Verifica se esiste un'immagine per l'articolo specificato.
     * Versione leggera per chiamate AJAX.
     * 
     * @param nome          Nome dell'articolo
     * @param marca         Marca dell'articolo
     * @param directoryPath Path assoluto della directory img
     * @return true se l'immagine esiste, false altrimenti
     */
    public static boolean esisteImmagine(String nome, String marca, String directoryPath) {
        if (nome == null || marca == null)
            return false;

        refreshCacheIfNeeded(directoryPath);
        String baseName = slugify(marca) + slugify(nome);

        for (String ext : ESTENSIONI) {
            if (cachedFileNames.contains((baseName + ext).toLowerCase())) {
                return true;
            }
        }
        return false;
    }

    /**
     * Trova il path dell'immagine per l'articolo specificato.
     * Ritorna l'icona di default se non trovata.
     * Aggiunge un parametro cache-busting per evitare problemi di cache del
     * browser.
     * 
     * @param nome          Nome dell'articolo
     * @param marca         Marca dell'articolo
     * @param directoryPath Path assoluto della directory img
     * @param baseUrl       URL base per le immagini (es. "img")
     * @return Path relativo dell'immagine con cache-buster (es.
     *         "img/gilbarcotestata.jpg?v=123456")
     */
    public static String trovaImmagineArticolo(String nome, String marca,
            String directoryPath, String baseUrl) {
        if (nome == null || marca == null || nome.isEmpty() || marca.isEmpty()) {
            return baseUrl + FALLBACK_IMAGE;
        }

        refreshCacheIfNeeded(directoryPath);
        String baseName = slugify(marca) + slugify(nome);

        for (String ext : ESTENSIONI) {
            String target = (baseName + ext).toLowerCase();
            if (cachedFileNames.contains(target)) {
                // Trova il nome file originale (preserva case)
                File dir = new File(directoryPath);
                File[] files = dir.listFiles();
                if (files != null) {
                    for (File f : files) {
                        if (f.getName().toLowerCase().equals(target)) {
                            // Aggiungi timestamp del file come cache-buster
                            long lastModified = f.lastModified();
                            return baseUrl + "/" + f.getName() + "?v=" + lastModified;
                        }
                    }
                }
            }
        }
        return baseUrl + FALLBACK_IMAGE;
    }

    /**
     * Invalida la cache delle immagini.
     * Utile dopo upload di nuove immagini.
     */
    public static synchronized void invalidateCache() {
        cachedFileNames = null;
        cacheTimestamp = 0;
    }

    /**
     * Comprime e salva un'immagine uploadata.
     * Ridimensiona a max width/height mantenendo aspect ratio, salva come JPG.
     * 
     * @param image     Immagine originale
     * @param nome      Nome articolo
     * @param marca     Marca articolo
     * @param outputDir Directory di output
     * @param maxWidth  Larghezza massima
     * @param maxHeight Altezza massima
     * @param quality   Qualità JPEG (0.0-1.0)
     * @return Path relativo dell'immagine salvata
     */
    public static String compressAndSave(java.awt.image.BufferedImage image,
            String nome, String marca,
            String outputDir,
            int maxWidth, int maxHeight,
            float quality) throws java.io.IOException {

        // VERIFICA DIRECTORY - crea se non esiste
        File outputDirFile = new File(outputDir);
        if (!outputDirFile.exists()) {
            boolean created = outputDirFile.mkdirs();
            if (!created) {
                throw new java.io.IOException("Impossibile creare directory: " + outputDir);
            }
            System.out.println("✅ [ImageUtil] Creata directory: " + outputDir);
        }

        System.out
                .println("📁 [ImageUtil] Directory output: " + outputDir + " (exists: " + outputDirFile.exists() + ")");

        // Calcola nuove dimensioni mantenendo aspect ratio
        int originalWidth = image.getWidth();
        int originalHeight = image.getHeight();

        double ratio = Math.min(
                (double) maxWidth / originalWidth,
                (double) maxHeight / originalHeight);

        // Solo ridimensiona se necessario
        int newWidth = originalWidth;
        int newHeight = originalHeight;
        if (ratio < 1.0) {
            newWidth = (int) (originalWidth * ratio);
            newHeight = (int) (originalHeight * ratio);
        }

        // Crea immagine ridimensionata
        java.awt.image.BufferedImage resized = new java.awt.image.BufferedImage(
                newWidth, newHeight, java.awt.image.BufferedImage.TYPE_INT_RGB);
        java.awt.Graphics2D g2d = resized.createGraphics();
        g2d.setRenderingHint(java.awt.RenderingHints.KEY_INTERPOLATION,
                java.awt.RenderingHints.VALUE_INTERPOLATION_BILINEAR);
        g2d.setRenderingHint(java.awt.RenderingHints.KEY_RENDERING,
                java.awt.RenderingHints.VALUE_RENDER_QUALITY);
        g2d.setRenderingHint(java.awt.RenderingHints.KEY_ANTIALIASING,
                java.awt.RenderingHints.VALUE_ANTIALIAS_ON);

        // Sfondo bianco per trasparenza PNG
        g2d.setColor(java.awt.Color.WHITE);
        g2d.fillRect(0, 0, newWidth, newHeight);
        g2d.drawImage(image, 0, 0, newWidth, newHeight, null);
        g2d.dispose();

        // Nome file slugified
        String baseName = slugify(marca) + slugify(nome);
        String fileName = baseName + ".jpg";
        java.io.File outputFile = new java.io.File(outputDir, fileName);

        System.out.println("📷 [ImageUtil] Salvataggio immagine: " + outputFile.getAbsolutePath());

        // Salva come JPEG con qualità specificata
        java.util.Iterator<javax.imageio.ImageWriter> writers = javax.imageio.ImageIO
                .getImageWritersByFormatName("jpg");
        if (!writers.hasNext()) {
            throw new java.io.IOException("No JPG writer found");
        }

        javax.imageio.ImageWriter writer = writers.next();
        javax.imageio.ImageWriteParam param = writer.getDefaultWriteParam();
        param.setCompressionMode(javax.imageio.ImageWriteParam.MODE_EXPLICIT);
        param.setCompressionQuality(quality);

        // Usa FileOutputStream diretto per evitare problemi con
        // ImageIO.createImageOutputStream
        try (java.io.FileOutputStream fos = new java.io.FileOutputStream(outputFile);
                javax.imageio.stream.ImageOutputStream ios = javax.imageio.ImageIO.createImageOutputStream(fos)) {

            if (ios == null) {
                throw new java.io.IOException(
                        "Impossibile creare ImageOutputStream per: " + outputFile.getAbsolutePath());
            }

            writer.setOutput(ios);
            writer.write(null, new javax.imageio.IIOImage(resized, null, null), param);
            ios.flush();
        } finally {
            writer.dispose();
        }

        System.out.println("✅ [ImageUtil] Immagine salvata: " + outputFile.getAbsolutePath() + " ("
                + outputFile.length() + " bytes)");

        // Invalida cache per vedere nuova immagine
        invalidateCache();

        return "img/" + fileName;
    }

    /**
     * Legge l'orientamento EXIF da un array di byte JPEG.
     * Ritorna un valore da 1 a 8, dove 1 = normale.
     * 
     * Orientamenti comuni:
     * 1 = Normale
     * 3 = Ruotato 180°
     * 6 = Ruotato 90° orario (comune su smartphone)
     * 8 = Ruotato 90° antiorario
     */
    public static int getExifOrientation(byte[] imageData) {
        try {
            // Cerca marker EXIF nei primi bytes del JPEG
            if (imageData == null || imageData.length < 12)
                return 1;

            // Verifica che sia un JPEG (inizia con FFD8)
            if ((imageData[0] & 0xFF) != 0xFF || (imageData[1] & 0xFF) != 0xD8) {
                return 1; // Non è JPEG, nessuna rotazione
            }

            int offset = 2;
            while (offset < imageData.length - 2) {
                // Cerca marker APP1 (EXIF)
                if ((imageData[offset] & 0xFF) != 0xFF)
                    break;

                int marker = imageData[offset + 1] & 0xFF;

                // APP1 marker (0xE1) contiene EXIF
                if (marker == 0xE1) {
                    int segmentLength = ((imageData[offset + 2] & 0xFF) << 8) | (imageData[offset + 3] & 0xFF);

                    // Verifica "Exif\0\0"
                    if (offset + 10 < imageData.length &&
                            imageData[offset + 4] == 'E' && imageData[offset + 5] == 'x' &&
                            imageData[offset + 6] == 'i' && imageData[offset + 7] == 'f') {

                        int tiffStart = offset + 10;
                        boolean littleEndian = (imageData[tiffStart] == 'I');

                        // Salta all'IFD0
                        int ifdOffset = readInt(imageData, tiffStart + 4, littleEndian);
                        int ifdStart = tiffStart + ifdOffset;

                        if (ifdStart >= imageData.length - 2)
                            return 1;

                        int numEntries = readShort(imageData, ifdStart, littleEndian);

                        // Cerca tag Orientation (0x0112)
                        for (int i = 0; i < numEntries && ifdStart + 2 + i * 12 + 12 <= imageData.length; i++) {
                            int entryOffset = ifdStart + 2 + i * 12;
                            int tag = readShort(imageData, entryOffset, littleEndian);

                            if (tag == 0x0112) { // Orientation tag
                                return readShort(imageData, entryOffset + 8, littleEndian);
                            }
                        }
                    }
                    break;
                }

                // Passa al prossimo segmento
                if (marker >= 0xE0 && marker <= 0xEF) {
                    int segmentLength = ((imageData[offset + 2] & 0xFF) << 8) | (imageData[offset + 3] & 0xFF);
                    offset += 2 + segmentLength;
                } else {
                    break;
                }
            }
        } catch (Exception e) {
            // In caso di errore, assume orientamento normale
        }
        return 1;
    }

    private static int readShort(byte[] data, int offset, boolean littleEndian) {
        if (offset + 1 >= data.length)
            return 0;
        if (littleEndian) {
            return (data[offset] & 0xFF) | ((data[offset + 1] & 0xFF) << 8);
        } else {
            return ((data[offset] & 0xFF) << 8) | (data[offset + 1] & 0xFF);
        }
    }

    private static int readInt(byte[] data, int offset, boolean littleEndian) {
        if (offset + 3 >= data.length)
            return 0;
        if (littleEndian) {
            return (data[offset] & 0xFF) | ((data[offset + 1] & 0xFF) << 8) |
                    ((data[offset + 2] & 0xFF) << 16) | ((data[offset + 3] & 0xFF) << 24);
        } else {
            return ((data[offset] & 0xFF) << 24) | ((data[offset + 1] & 0xFF) << 16) |
                    ((data[offset + 2] & 0xFF) << 8) | (data[offset + 3] & 0xFF);
        }
    }

    /**
     * Ruota un'immagine in base all'orientamento EXIF.
     */
    public static BufferedImage applyExifOrientation(BufferedImage image, int orientation) {
        if (orientation == 1 || orientation < 1 || orientation > 8) {
            return image; // Nessuna rotazione necessaria
        }

        int width = image.getWidth();
        int height = image.getHeight();

        AffineTransform transform = new AffineTransform();
        int newWidth = width;
        int newHeight = height;

        switch (orientation) {
            case 2: // Flip orizzontale
                transform.scale(-1, 1);
                transform.translate(-width, 0);
                break;
            case 3: // Ruota 180°
                transform.rotate(Math.PI, width / 2.0, height / 2.0);
                break;
            case 4: // Flip verticale
                transform.scale(1, -1);
                transform.translate(0, -height);
                break;
            case 5: // Flip + Ruota 90° antiorario
                newWidth = height;
                newHeight = width;
                transform.rotate(Math.PI / 2);
                transform.scale(1, -1);
                break;
            case 6: // Ruota 90° orario (MOLTO COMUNE su smartphone!)
                newWidth = height;
                newHeight = width;
                transform.rotate(Math.PI / 2);
                transform.translate(0, -height);
                break;
            case 7: // Flip + Ruota 90° orario
                newWidth = height;
                newHeight = width;
                transform.rotate(-Math.PI / 2);
                transform.scale(1, -1);
                transform.translate(-width, 0);
                break;
            case 8: // Ruota 90° antiorario
                newWidth = height;
                newHeight = width;
                transform.rotate(-Math.PI / 2);
                transform.translate(-width, 0);
                break;
        }

        BufferedImage rotated = new BufferedImage(newWidth, newHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = rotated.createGraphics();
        g.setColor(java.awt.Color.WHITE);
        g.fillRect(0, 0, newWidth, newHeight);
        g.drawImage(image, transform, null);
        g.dispose();

        return rotated;
    }

    /**
     * Legge un'immagine da InputStream applicando la correzione dell'orientamento
     * EXIF.
     */
    public static BufferedImage readImageWithExifCorrection(InputStream inputStream) throws java.io.IOException {
        // Leggi tutti i byte per poter analizzare l'EXIF
        ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        byte[] temp = new byte[8192];
        int bytesRead;
        while ((bytesRead = inputStream.read(temp)) != -1) {
            buffer.write(temp, 0, bytesRead);
        }
        byte[] imageData = buffer.toByteArray();

        // Leggi orientamento EXIF
        int orientation = getExifOrientation(imageData);

        // Leggi immagine
        BufferedImage image = ImageIO.read(new ByteArrayInputStream(imageData));
        if (image == null)
            return null;

        // Applica rotazione se necessaria
        return applyExifOrientation(image, orientation);
    }
}
