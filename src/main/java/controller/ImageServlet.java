package controller;

import util.ImageStorageConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.nio.file.Files;

/**
 * Servlet per servire le immagini dalla directory esterna.
 * Mappa URL /ext-img/* ai file nella directory di storage esterno.
 */
public class ImageServlet extends HttpServlet {

    private static final String DEFAULT_CONTENT_TYPE = "image/jpeg";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Ottieni il nome del file richiesto
        String pathInfo = request.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Nome file mancante");
            return;
        }

        // Rimuovi slash iniziale
        String fileName = pathInfo.substring(1);

        // Rimuovi eventuali parametri query (es. ?v=123456 per cache-busting)
        int queryIndex = fileName.indexOf('?');
        if (queryIndex > 0) {
            fileName = fileName.substring(0, queryIndex);
        }

        // Previeni path traversal attacks
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Path non valido");
            return;
        }

        // Ottieni il path della directory immagini
        String imageDir = ImageStorageConfig.getImageDirectory(getServletContext());
        File imageFile = new File(imageDir, fileName);

        // Verifica che il file esista
        if (!imageFile.exists() || !imageFile.isFile()) {
            // Prova a servire l'immagine di fallback dalla webapp
            String fallbackPath = getServletContext().getRealPath("/img/Icon.png");
            if (fallbackPath != null) {
                imageFile = new File(fallbackPath);
            }
            if (!imageFile.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Immagine non trovata");
                return;
            }
        }

        // Determina il content type
        String contentType = getServletContext().getMimeType(fileName);
        if (contentType == null) {
            contentType = DEFAULT_CONTENT_TYPE;
        }

        // Imposta headers
        response.setContentType(contentType);
        response.setContentLengthLong(imageFile.length());

        // Cache headers (1 ora di cache, ma con revalidation)
        response.setHeader("Cache-Control", "public, max-age=3600, must-revalidate");
        response.setDateHeader("Last-Modified", imageFile.lastModified());

        // Serve il file
        try (InputStream in = new FileInputStream(imageFile);
                OutputStream out = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
}
