package controller;

import util.ImageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.*;

/**
 * Servlet per upload e compressione immagini articolo.
 * Accetta multipart form data, comprime l'immagine e la salva.
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB in memory
        maxFileSize = 5 * 1024 * 1024, // 5MB max per file
        maxRequestSize = 6 * 1024 * 1024 // 6MB max request
)
public class ImageUploadServlet extends HttpServlet {

    private static final int MAX_WIDTH = 400;
    private static final int MAX_HEIGHT = 400;
    private static final float JPEG_QUALITY = 0.80f;
    private static final String[] ALLOWED_TYPES = { "image/jpeg", "image/png", "image/gif", "image/webp" };

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String nome = request.getParameter("nome");
            String marca = request.getParameter("marca");
            Part filePart = request.getPart("image");

            // Validazione parametri
            if (nome == null || nome.trim().isEmpty() ||
                    marca == null || marca.trim().isEmpty()) {
                sendError(response, "Nome e Marca sono obbligatori");
                return;
            }

            if (filePart == null || filePart.getSize() == 0) {
                sendError(response, "Nessun file caricato");
                return;
            }

            // Validazione tipo file
            String contentType = filePart.getContentType();
            if (!isAllowedType(contentType)) {
                sendError(response, "Tipo file non ammesso. Usa JPG, PNG, GIF o WebP");
                return;
            }

            // Validazione dimensione (già gestita da @MultipartConfig ma double-check)
            if (filePart.getSize() > 5 * 1024 * 1024) {
                sendError(response, "File troppo grande. Max 5MB");
                return;
            }

            // Leggi immagine con correzione orientamento EXIF
            BufferedImage originalImage = ImageUtil.readImageWithExifCorrection(filePart.getInputStream());
            if (originalImage == null) {
                sendError(response, "Impossibile leggere l'immagine");
                return;
            }

            // Comprimi e salva
            String outputPath = ImageUtil.compressAndSave(
                    originalImage,
                    nome,
                    marca,
                    getServletContext().getRealPath("/img"),
                    MAX_WIDTH,
                    MAX_HEIGHT,
                    JPEG_QUALITY);

            // Risposta JSON
            PrintWriter out = response.getWriter();
            out.print("{\"success\":true,\"path\":\"" + outputPath + "\"}");
            out.flush();

        } catch (Exception e) {
            e.printStackTrace();
            sendError(response, "Errore durante l'upload: " + e.getMessage());
        }
    }

    private boolean isAllowedType(String contentType) {
        for (String allowed : ALLOWED_TYPES) {
            if (allowed.equalsIgnoreCase(contentType)) {
                return true;
            }
        }
        return false;
    }

    private void sendError(HttpServletResponse response, String message) throws IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        PrintWriter out = response.getWriter();
        out.print("{\"success\":false,\"error\":\"" + message.replace("\"", "\\\"") + "\"}");
        out.flush();
    }
}
