package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.DBConnection;


public class NotificationService {
	public NotificationService() {}
	
	public List<Notification> getUnreadNotifications(int userId) throws SQLException {
	    String sql = "SELECT * FROM notifications WHERE user_id = ? AND is_read = FALSE ORDER BY created_at DESC";
	    try (PreparedStatement stmt = DBConnection.getConnection().prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	        ResultSet rs = stmt.executeQuery();
	        List<Notification> notifications = new ArrayList<>();
	        while (rs.next()) {
	            notifications.add(new Notification(rs.getInt("id"),userId, rs.getString("message"), rs.getTimestamp("created_at")));
	        }
	        return notifications;
	    }
	}
	
	public static void createNotification(int userId, String message) throws SQLException {
	    String sql = "INSERT INTO notifications (user_id, message, is_read) VALUES (?, ?, false)";
	    try (PreparedStatement stmt = DBConnection.getConnection().prepareStatement(sql)) {
	        stmt.setInt(1, userId);
	        stmt.setString(2, message);
	        stmt.executeUpdate();
	    }
	}
	public static void createNotificaTemporaneaPerTutti(String message) {
	    // Estrai l'autore dal messaggio
	    String autore = message.split(" ha ")[0];
	    int idInviante = -1;

	    try {
	        idInviante = UserService.getIdByUsername(autore, DBConnection.getConnection());
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    String getUsersSQL = "SELECT id FROM utenti WHERE stato = 'attivo' AND id <> ?";
	    String insertSQL = "INSERT INTO notifications (user_id, message, is_read, scadenza) " +
	                       "VALUES (?, ?, false, NOW() + INTERVAL 30 SECOND)";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement stmtUtenti = conn.prepareStatement(getUsersSQL)) {

	        stmtUtenti.setInt(1, idInviante);

	        try (ResultSet rs = stmtUtenti.executeQuery();
	             PreparedStatement stmtInsert = conn.prepareStatement(insertSQL)) {

	            while (rs.next()) {
	                int userId = rs.getInt("id");

	                stmtInsert.setInt(1, userId);
	                stmtInsert.setString(2, message);
	                stmtInsert.executeUpdate();
	            }
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}

	
	public static int createNotificaPerTutti(String message, int excludeUserId) throws SQLException {
	    final String sql =
	        "INSERT INTO notifications (user_id, message, is_read) " +
	        "SELECT id, ?, FALSE FROM utenti WHERE id <> ?";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {
	        ps.setString(1, message);
	        ps.setInt(2, excludeUserId);
	        return ps.executeUpdate(); // restituisce quante notifiche sono state create
	    }
	}



	
	public void markNotificationAsRead(int notificationId) throws SQLException {
	    String sql = "UPDATE notifications SET is_read = TRUE WHERE id = ?";
	    try (PreparedStatement stmt = DBConnection.getConnection().prepareStatement(sql)) {
	        stmt.setInt(1, notificationId);
	        stmt.executeUpdate();
	    }
	}

}
