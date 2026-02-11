package util;

import jakarta.servlet.ServletContext;
import java.io.File;

/**
 * Configurazione centralizzata per lo storage delle immagini.
 * Gestisce il path delle immagini in modo cross-platform (Windows/Linux).
 * Le immagini vengono salvate FUORI dalla directory di deploy per sopravvivere
 * ai riavvii.
 */
public class ImageStorageConfig {

    // Directory per Windows (sviluppo)
    private static final String WINDOWS_BASE_PATH = "C:\\TecnoDepositData\\img";

    // Nome directory relativa per Linux (produzione)
    private static final String LINUX_RELATIVE_DIR = "tecnodeposit-data/img";

    // Cache del path (calcolato una sola volta)
    private static String cachedImagePath = null;
    private static final Object lock = new Object();

    /**
     * Ottiene il path assoluto della directory immagini esterna.
     * Crea la directory automaticamente se non esiste.
     * 
     * @param servletContext Il ServletContext per ottenere il path di Tomcat
     * @return Path assoluto della directory immagini
     */
    public static String getImageDirectory(ServletContext servletContext) {
        synchronized (lock) {
            if (cachedImagePath != null) {
                return cachedImagePath;
            }

            String imagePath;
            String os = System.getProperty("os.name").toLowerCase();

            if (os.contains("win")) {
                // Windows: usa path fisso
                imagePath = WINDOWS_BASE_PATH;
            } else {
                // Linux/Mac: usa path relativo a Tomcat
                // Ottiene il path reale della webapp, poi risale di 2 livelli (fuori webapps)
                String realPath = servletContext.getRealPath("/");
                if (realPath != null) {
                    File webappDir = new File(realPath);
                    // Risale: webapp -> webapps -> tomcat_base -> tecnodeposit-data/img
                    File tomcatBase = webappDir.getParentFile().getParentFile();
                    imagePath = new File(tomcatBase, LINUX_RELATIVE_DIR).getAbsolutePath();
                } else {
                    // Fallback: usa /opt/tecnodeposit/img
                    imagePath = "/opt/tecnodeposit/img";
                }
            }

            // Crea la directory se non esiste
            File imgDir = new File(imagePath);
            if (!imgDir.exists()) {
                boolean created = imgDir.mkdirs();
                if (created) {
                    System.out.println("✅ [ImageStorageConfig] Creata directory immagini: " + imagePath);
                } else {
                    System.err.println("❌ [ImageStorageConfig] Impossibile creare directory: " + imagePath);
                }
            }

            cachedImagePath = imagePath;
            System.out.println("📁 [ImageStorageConfig] Directory immagini: " + imagePath + " (OS: " + os + ")");
            return cachedImagePath;
        }
    }

    /**
     * Invalida la cache del path (utile per testing).
     */
    public static void invalidateCache() {
        synchronized (lock) {
            cachedImagePath = null;
        }
    }

    /**
     * Verifica se la directory immagini esiste ed è scrivibile.
     */
    public static boolean isDirectoryWritable(ServletContext servletContext) {
        File dir = new File(getImageDirectory(servletContext));
        return dir.exists() && dir.isDirectory() && dir.canWrite();
    }
}
