package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import dao.DBConnection;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

import model.UserService;
import model.NotificationService;
import model.Notification;


public class NotificationServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
	    HttpSession session = req.getSession(false);
	    if (session == null || session.getAttribute("username") == null) {
	        resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
	        return;
	    }
	    try (Connection conn = DBConnection.getConnection()) {
	        int userId = UserService.getIdByUsername((String) session.getAttribute("username"), conn);
	        NotificationService notificationService = new NotificationService();
	        List<Notification> notifications = notificationService.getUnreadNotifications(userId);

	        resp.setContentType("application/json");
	        StringBuilder sb = new StringBuilder();
	        sb.append("[");
	        for (int i = 0; i < notifications.size(); i++) {
	            Notification n = notifications.get(i);
	            sb.append("{")
	              .append("\"id\":").append(n.getId()).append(",")
	              .append("\"userId\":").append(n.getUserId()).append(",")
	              .append("\"message\":\"").append(n.getMessage().replace("\"", "\\\"")).append("\",")
	              .append("\"read\":").append(n.isRead()).append(",")
	              .append("\"createdAt\":\"").append(n.getCreatedAt()).append("\"")
	              .append("}");
	            if (i < notifications.size() - 1) sb.append(",");
	        }
	        sb.append("]");
	        resp.getWriter().write(sb.toString());

	    } catch (SQLException e) {
	        resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
	        e.printStackTrace();
	    }
	}


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
    	HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
        	resp.sendRedirect("login");
            return;
        }
        String idParam = req.getParameter("id");
        
        if (idParam == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        int notificationId = Integer.parseInt(idParam);
        NotificationService notificationService = new NotificationService();
        // Segna la notifica come letta
        
        try {
			notificationService.markNotificationAsRead(notificationId);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        resp.setStatus(HttpServletResponse.SC_OK);
    }
}

