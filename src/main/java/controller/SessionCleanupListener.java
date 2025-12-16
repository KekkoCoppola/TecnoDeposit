package controller;

import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import java.sql.*;

import dao.DBConnection;

public class SessionCleanupListener implements HttpSessionListener {
	 @Override
	    public void sessionDestroyed(HttpSessionEvent se) {
	        String username = (String) se.getSession().getAttribute("username");
	        if (username != null) {
	            try (Connection conn = DBConnection.getConnection();
	                 PreparedStatement stmt = conn.prepareStatement(
	                     "UPDATE utenti SET stato = 'inattivo' WHERE username = ?")) {
	                stmt.setString(1, username);
	                stmt.executeUpdate();
	            } catch (SQLException e) {
	                e.printStackTrace();
	            }
	        }
	    }
}
