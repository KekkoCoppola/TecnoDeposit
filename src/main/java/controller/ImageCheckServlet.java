package controller;

import util.ImageUtil;
import util.ImageStorageConfig;
import model.ListaArticoli;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

/**
 * Endpoint AJAX per verificare l'esistenza di un'immagine articolo.
 * Risposta JSON leggera per feedback real-time nel modal.
 * Include anche il conteggio degli articoli con stessa marca+nome.
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

        String directoryPath = ImageStorageConfig.getImageDirectory(getServletContext());
        boolean found = ImageUtil.esisteImmagine(nome, marca, directoryPath);
        String path = found ? ImageUtil.trovaImmagineArticolo(nome, marca, directoryPath, "ext-img") : "img/Icon.png";

        // Conta quanti articoli condividono questa combinazione nome+marca
        int count = 0;
        if (nome != null && !nome.trim().isEmpty()) {
            ListaArticoli listaArticoli = new ListaArticoli();
            count = listaArticoli.countArticoliByNome(nome.trim());
        }

        PrintWriter out = response.getWriter();
        out.print("{\"found\":" + found + ",\"path\":\"" + path + "\",\"count\":" + count + "}");
        out.flush();
    }
}
