package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import util.EmailConfig;
import util.EmailService;

/**
 * Servlet per gestire le richieste dal form della Landing Page.
 * Invia una email di notifica con i dati del form.
 */
public class ContactFormServlet extends HttpServlet {

    private static final String NOTIFICATION_EMAIL = "francescocoppola877@gmail.com";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
            // Recupera i dati dal form
            String nome = sanitize(request.getParameter("nome"));
            String cognome = sanitize(request.getParameter("cognome"));
            String email = sanitize(request.getParameter("email"));
            String telefono = sanitize(request.getParameter("telefono"));
            String azienda = sanitize(request.getParameter("azienda"));
            String settore = sanitize(request.getParameter("settore"));
            String messaggio = sanitize(request.getParameter("messaggio"));

            // Validazione base
            if (nome.isEmpty() || cognome.isEmpty() || email.isEmpty() || azienda.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.write("{\"success\":false,\"error\":\"Campi obbligatori mancanti\"}");
                return;
            }

            // Componi l'email HTML
            String htmlEmail = buildEmailHtml(nome, cognome, email, telefono, azienda, settore, messaggio);
            String subject = "🚀 Nuova Richiesta TecnoDeposit da " + nome + " " + cognome + " (" + azienda + ")";

            // Invia email
            EmailService emailService = EmailConfig.createEmailService();
            emailService.sendHtml(NOTIFICATION_EMAIL, subject, htmlEmail, email);

            // Risposta di successo
            out.write("{\"success\":true,\"message\":\"Richiesta inviata correttamente\"}");

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.write("{\"success\":false,\"error\":\"Errore nell'invio della richiesta\"}");
        }
    }

    private String sanitize(String input) {
        if (input == null)
            return "";
        return input.trim()
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String buildEmailHtml(String nome, String cognome, String email,
            String telefono, String azienda, String settore, String messaggio) {

        String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
        String telefonoVal = telefono.isEmpty() ? "Non specificato" : telefono;
        String settoreVal = settore.isEmpty() ? "Non specificato" : settore;
        String messaggioVal = messaggio.isEmpty() ? "<em>Nessun messaggio</em>" : messaggio;

        StringBuilder sb = new StringBuilder();
        sb.append("<!DOCTYPE html>");
        sb.append("<html><head><meta charset=\"UTF-8\"><style>");
        sb.append(
                "body { font-family: 'Segoe UI', Arial, sans-serif; background-color: #f5f5f5; margin: 0; padding: 20px; }");
        sb.append(
                ".container { max-width: 600px; margin: 0 auto; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }");
        sb.append(
                ".header { background: linear-gradient(135deg, #e52c1f 0%, #c5271b 100%); color: white; padding: 30px; text-align: center; }");
        sb.append(".header h1 { margin: 0; font-size: 24px; }");
        sb.append(".header p { margin: 10px 0 0 0; opacity: 0.9; }");
        sb.append(".content { padding: 30px; }");
        sb.append(".field { margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #eee; }");
        sb.append(".field:last-child { border-bottom: none; margin-bottom: 0; }");
        sb.append(
                ".label { font-size: 12px; color: #888; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 5px; }");
        sb.append(".value { font-size: 16px; color: #333; font-weight: 500; }");
        sb.append(
                ".message-box { background: #f8f9fa; border-left: 4px solid #e52c1f; padding: 15px; border-radius: 4px; margin-top: 10px; }");
        sb.append(".footer { background: #f8f9fa; padding: 20px; text-align: center; color: #888; font-size: 13px; }");
        sb.append(
                ".badge { display: inline-block; background: #e52c1f; color: white; padding: 4px 12px; border-radius: 20px; font-size: 12px; }");
        sb.append("</style></head><body>");
        sb.append("<div class=\"container\">");
        sb.append("<div class=\"header\">");
        sb.append("<h1>📩 Nuova Richiesta Servizio</h1>");
        sb.append("<p>Ricevuta il ").append(now).append("</p>");
        sb.append("</div>");
        sb.append("<div class=\"content\">");
        sb.append("<div class=\"field\"><div class=\"label\">Nome e Cognome</div>");
        sb.append("<div class=\"value\">").append(nome).append(" ").append(cognome).append("</div></div>");
        sb.append("<div class=\"field\"><div class=\"label\">Email</div>");
        sb.append("<div class=\"value\"><a href=\"mailto:").append(email).append("\">").append(email)
                .append("</a></div></div>");
        sb.append("<div class=\"field\"><div class=\"label\">Telefono</div>");
        sb.append("<div class=\"value\">").append(telefonoVal).append("</div></div>");
        sb.append("<div class=\"field\"><div class=\"label\">Azienda</div>");
        sb.append("<div class=\"value\">").append(azienda).append("</div></div>");
        sb.append("<div class=\"field\"><div class=\"label\">Settore</div>");
        sb.append("<div class=\"value\"><span class=\"badge\">").append(settoreVal).append("</span></div></div>");
        sb.append("<div class=\"field\"><div class=\"label\">Messaggio</div>");
        sb.append("<div class=\"message-box\">").append(messaggioVal).append("</div></div>");
        sb.append("</div>");
        sb.append("<div class=\"footer\">");
        sb.append("TecnoDeposit • Gestione Inventario Intelligente<br>");
        sb.append("<a href=\"https://app.tecnodeposit.it\">app.tecnodeposit.it</a>");
        sb.append("</div></div></body></html>");

        return sb.toString();
    }
}
