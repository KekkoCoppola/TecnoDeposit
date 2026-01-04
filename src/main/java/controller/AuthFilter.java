package controller;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.DispatcherType;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Set;

public class AuthFilter implements Filter {

    private ServletContext ctx;

    // Percorsi “aperti” (aggiungi qui eventuali altre pagine pubbliche)
    private static final Set<String> WHITELIST_EXACT = Set.of(
            "/", // root URL -> landing page
            "/landingPage.html",
            "/api/contact-form", // form contatto landing page
            "/Login.jsp",
            "/login.jsp",
            "/login", // es. servlet di login
            "/logout", // es. servlet di logout
            "/register", // eventuale registrazione
            "/favicon.ico");

    // Prefissi “aperti” per statici
    private static final String[] WHITELIST_PREFIX = {
            "/css/", "/js/", "/img/", "/images/", "/fonts/", "/static/", "/assets/"
    };

    // Estensioni statiche da lasciare passare
    private static final String[] STATIC_EXT = {
            ".css", ".js", ".map", ".png", ".jpg", ".jpeg", ".gif", ".svg",
            ".webp", ".ico", ".woff", ".woff2", ".ttf", ".eot", ".mp4", ".json"
    };

    @Override
    public void init(FilterConfig filterConfig) {
        this.ctx = filterConfig.getServletContext();
        ctx.log("[AuthFilter] Inizializzato");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        final String contextPath = req.getContextPath(); // es. /TecnoDeposit
        final String uri = req.getRequestURI(); // es. /TecnoDeposit/admin/pagina.jsp
        final String path = uri.substring(contextPath.length()); // es. /admin/pagina.jsp

        // 1) Permetti WHITELIST (login, statici, ecc.)
        if (isWhitelisted(path)) {
            chain.doFilter(request, response);
            return;
        }

        // 2) Controlla sessione
        HttpSession session = req.getSession(false);
        boolean loggedIn = session != null &&
                (session.getAttribute("userId") != null // usa ciò che hai davvero in sessione
                        || session.getAttribute("username") != null
                        || session.getAttribute("email") != null);

        if (loggedIn) {
            chain.doFilter(request, response);
            return;
        }

        // 3) Utente NON loggato
        if ("XMLHttpRequest".equalsIgnoreCase(req.getHeader("X-Requested-With"))) {
            // Richiesta AJAX: rispondi 401 JSON per evitare redirect loop sul fetch
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.setContentType("application/json;charset=UTF-8");
            resp.getWriter().write("{\"success\":false,\"error\":\"AUTH_REQUIRED\"}");
        } else {
            // Redirect alla pagina di login, con ritorno alla pagina richiesta
            // Utente NON loggato (non-AJAX)
            HttpSession s = req.getSession(true);
            s.setAttribute("FLASH_LOGIN_ERROR", "Effettua il login.");
            resp.sendRedirect(req.getContextPath() + "/login");

        }
    }

    @Override
    public void destroy() {
    }

    private boolean isWhitelisted(String path) {
        // esatti
        if (WHITELIST_EXACT.contains(path))
            return true;

        // prefissi
        for (String p : WHITELIST_PREFIX) {
            if (path.startsWith(p))
                return true;
        }

        // estensioni statiche
        for (String ext : STATIC_EXT) {
            if (path.endsWith(ext))
                return true;
        }

        return false;
    }

    private String urlEncode(String s) {
        try {
            return java.net.URLEncoder.encode(s, java.nio.charset.StandardCharsets.UTF_8);
        } catch (Exception e) {
            return "";
        }
    }
}
