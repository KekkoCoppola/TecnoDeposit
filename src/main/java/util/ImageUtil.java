package util;

import java.io.File;
import java.util.HashSet;
import java.util.Set;

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
     * 
     * @param nome          Nome dell'articolo
     * @param marca         Marca dell'articolo
     * @param directoryPath Path assoluto della directory img
     * @param baseUrl       URL base per le immagini (es. "img")
     * @return Path relativo dell'immagine (es. "img/gilbarcotestata.jpg")
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
                            return baseUrl + "/" + f.getName();
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

        try (javax.imageio.stream.ImageOutputStream ios = javax.imageio.ImageIO.createImageOutputStream(outputFile)) {
            writer.setOutput(ios);
            writer.write(null, new javax.imageio.IIOImage(resized, null, null), param);
        } finally {
            writer.dispose();
        }

        // Invalida cache per vedere nuova immagine
        invalidateCache();

        return "img/" + fileName;
    }
}
