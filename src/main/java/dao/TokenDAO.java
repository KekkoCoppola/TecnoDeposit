package dao;

import java.sql.*;
import java.time.Instant;
import java.security.SecureRandom;

public class TokenDAO {
	private static final SecureRandom RNG = new SecureRandom();
	public long id;
    public int userId;            // la tua FK è INT
    public byte[] payload;        // AES-GCM [IV||CT+TAG]
    public Timestamp expiresAt;
    public boolean used;


	public static String randomHex(int bytes) {
	    byte[] buf = new byte[bytes];
	    RNG.nextBytes(buf);
	    StringBuilder sb = new StringBuilder(bytes * 2);
	    for (byte b : buf) sb.append(String.format("%02x", b));
	    return sb.toString();
	}
	
	public static void insertRevealToken(int userId, String tokenHex, byte[] payload, Instant expiresAt) throws SQLException {
        String sql = "INSERT INTO user_token (user_id, token, purpose, payload, expires_at) " +
                     "VALUES (?, ?, 'REVEAL_PWD', ?, ?)";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, tokenHex);
            ps.setBytes(3, payload);
            ps.setTimestamp(4, Timestamp.from(expiresAt));
            ps.executeUpdate();
        }
    }
	public TokenDAO findValidByToken(String tokenHex) throws SQLException {
	    String sql = "SELECT id,user_id,payload,expires_at,used FROM user_token WHERE token=? AND purpose='REVEAL_PWD' LIMIT 1";
	    try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
	        ps.setString(1, tokenHex);
	        try (ResultSet rs = ps.executeQuery()) {
	            if (!rs.next()) return null;
	            TokenDAO ut = new TokenDAO();
	            ut.id = rs.getLong(1);
	            ut.userId = rs.getInt(2);
	            ut.payload = rs.getBytes(3);
	            ut.expiresAt = rs.getTimestamp(4);
	            ut.used = rs.getBoolean(5);
	            if (ut.used || ut.expiresAt.toInstant().isBefore(java.time.Instant.now())) return null;
	            return ut;
	        }
	    }
	}
	public void markUsedAndWipe(long id) throws SQLException {
	    try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(
	        "UPDATE user_token SET used=1, payload=NULL WHERE id=?")) {
	        ps.setLong(1, id);
	        ps.executeUpdate();
	    }
	}

}
