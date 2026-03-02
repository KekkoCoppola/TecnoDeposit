package util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import dao.TokenDAO;

/**
 * Listener che si avvia assieme all'applicazione web e pianifica un job
 * periodico per la pulizia dei token scaduti (es. i token QR di Login o
 * i recuperi password scaduti).
 */
@WebListener
public class TokenCleanupListener implements ServletContextListener {

    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Usa un singolo thread in background per la manutenzione leggera
        scheduler = Executors.newSingleThreadScheduledExecutor();

        // Pianifica l'esecuzione periodica:
        // - Inizia dopo 1 minuto dall'avvio del server
        // - Si ripete ogni 15 minuti
        scheduler.scheduleAtFixedRate(() -> {
            try {
                TokenDAO.deleteExpiredTokens();
            } catch (Exception e) {
                System.err.println("[TokenCleanupListener] Errore imprevisto nel task schedulato: " + e.getMessage());
            }
        }, 1, 15, TimeUnit.MINUTES);

        System.out.println("[TokenCleanupListener] Job pulizia token pianificato (ogni 15 minuti).");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
            System.out.println("[TokenCleanupListener] Job pulizia token terminato.");
        }
    }
}
