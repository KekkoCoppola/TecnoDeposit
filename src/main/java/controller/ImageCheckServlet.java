package controller;

import util.ImageUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Endpoint AJAX per verificare l'esistenza di un'immagine articolo.
 * Risposta JSON leggera per feedback real-time nel modal.
 */
public class ImageCheckServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        // Disabilita cache browser per avere sempre risposta fresca
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");

        String nome = request.getParameter("nome");
        String marca = request.getParameter("marca");

        String directoryPath = getServletContext().getRealPath("/img");
        boolean found = ImageUtil.esisteImmagine(nome, marca, directoryPath);
        String path = found ? ImageUtil.trovaImmagineArticolo(nome, marca, directoryPath, "img") : "img/Icon.png";

        PrintWriter out = response.getWriter();
        out.print("{\"found\":" + found + ",\"path\":\"" + path + "\"}");
        out.flush();
    }
}
