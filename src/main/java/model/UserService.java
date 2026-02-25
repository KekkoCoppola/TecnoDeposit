package model;

import org.mindrot.jbcrypt.BCrypt;

import dao.DBConnection;
import model.Articolo.Stato;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class UserService {

    public String loginUser(String username, String password, Connection conn) throws SQLException {

        String query = "SELECT password,ruolo FROM utenti WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            // System.out.println("PROVO L'ACCESSSO:");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                String ruolo = rs.getString("ruolo");
                // System.out.println("RUOLO IDENTIFICATO:"+ruolo);
                if (BCrypt.checkpw(password, hashedPassword)) {
                    PreparedStatement updateStmt = conn.prepareStatement(
                            "UPDATE utenti SET ultimo_accesso = NOW() WHERE username = ?");
                    updateStmt.setString(1, username);
                    updateStmt.executeUpdate();

                    PreparedStatement attivoStmt = conn.prepareStatement(
                            "UPDATE utenti SET stato = 'attivo' WHERE username = ?");
                    attivoStmt.setString(1, username);
                    attivoStmt.executeUpdate();
                    return ruolo;
                }
            }
        }
        return null;
    }

    public static Boolean verifyPassword(String mail, String password, Connection conn) throws SQLException {

        String query = "SELECT password FROM utenti WHERE mail = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, mail);
            // System.out.println("PROVO L'ACCESSSO:");
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                // System.out.println("RUOLO IDENTIFICATO:"+ruolo);
                if (BCrypt.checkpw(password, hashedPassword)) {

                    return true;
                }
            }
        }
        return false;
    }

    public static Boolean verifyOtp(String Otp, Connection conn) throws SQLException {

        String otpSaved = "a3D!9fLk7@pQ4zV6m#Y1dR8wK$eJ0tN3cX7zT1wF5hR8uP2sL0vM9gB6dQ3yC4";
        return otpSaved.equals(Otp);
    }

    public boolean registerUser(String username, String mail, String nome, String cognome, String password,
            String ruolo, String telefono, Connection conn) throws SQLException {
        if (doesUserExist(username, mail, conn, "utenti")) {
            return false;
        }
        String nomeCognome = Stream.of(nome, cognome)
                .filter(s -> s != null && !s.isBlank())
                .collect(Collectors.joining(" "));
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        String query = "INSERT INTO utenti (username, password,mail,nomeCognome, ruolo,telefono) VALUES (?, ?, ?,?,?,?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);
            stmt.setString(3, mail);
            stmt.setString(4, nomeCognome);
            stmt.setString(5, ruolo);
            stmt.setString(6, telefono);
            int rows = stmt.executeUpdate();
            return rows > 0;
        }
    }

    public void updateUser(String username, String mail, String nome, String cognome, String password, String ruolo,
            String telefono, int id) {
        boolean updatePassword = password != null && !password.trim().isEmpty();
        String nomeCognome = Stream.of(nome, cognome)
                .filter(s -> s != null && !s.isBlank())
                .collect(Collectors.joining(" "));
        String query = updatePassword
                ? "UPDATE utenti SET username = ?, mail = ?, nomeCognome = ?, password = ?, ruolo = ?, telefono = ? WHERE id = ?"
                : "UPDATE utenti SET username = ?, mail = ?, nomeCognome = ?, ruolo = ?, telefono = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            int index = 1;
            stmt.setString(index++, username);
            stmt.setString(index++, mail);
            stmt.setString(index++, nomeCognome);

            if (updatePassword) {
                String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
                stmt.setString(index++, hashedPassword);
            }

            stmt.setString(index++, ruolo);
            stmt.setString(index++, telefono);

            if (id >= 0) {
                stmt.setInt(index, id);
            } else {
                stmt.setNull(index, java.sql.Types.INTEGER);
            }

            stmt.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public String getMail(String username, Connection conn) throws SQLException {
        String query = "SELECT mail FROM utenti WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String mail = rs.getString("mail");
                return mail;
            } else {
                return null;
            }
        }
    }

    public static int getIdByUsername(String username, Connection conn) throws SQLException {
        String query = "SELECT id FROM utenti WHERE username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                int id = rs.getInt("id");
                return id;
            } else {
                return -1;
            }
        }
    }

    public static List<Integer> getIdMagazzinieriEAdmin(Connection conn) throws SQLException {
        String query = "SELECT id FROM utenti WHERE ruolo IN ('Magazziniere', 'Amministratore')";
        List<Integer> ids = new ArrayList<>();

        try (PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                ids.add(rs.getInt("id"));
            }
        }

        return ids;
    }

    public String getNomeCognome(String username) throws SQLException {
        String query = "SELECT nomeCognome FROM utenti WHERE username = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String nomeCognome = rs.getString("nomeCognome");
                return nomeCognome;
            } else {
                return null;
            }
        }
    }

    public static String getNomeById(int id) throws SQLException {
        String query = "SELECT nomeCognome FROM utenti WHERE id = ?";
        Connection conn = DBConnection.getConnection();
        try (PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String nomeCognome = rs.getString("nomeCognome");
                return nomeCognome;
            } else {
                return null;
            }
        }
    }

    private boolean doesUserExist(String username, String mail, Connection conn, String table) throws SQLException {
        String query = "SELECT id FROM " + table + " WHERE mail = ? OR username = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, mail);
            stmt.setString(2, username);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();

        String query = "SELECT * FROM utenti";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setUsername(rs.getString("username"));
                u.setMail(rs.getString("mail"));
                u.setRuolo(rs.getString("ruolo"));
                try {
                    String nomeCognome = rs.getString("nomeCognome");
                    String[] parts = nomeCognome.trim().split("\\s+", 2);

                    String nome = parts.length > 0 ? parts[0] : "";
                    String cognome = parts.length > 1 ? parts[1] : "";

                    u.setNome(nome);
                    u.setCognome(cognome);
                } catch (Exception e) {
                    if (rs.getString("nomeCognome") == null || rs.getString("nomeCognome").isEmpty()) {
                        u.setNome("");
                        u.setCognome("");
                    }
                }
                ;
                u.setStato(rs.getString("stato"));
                u.setUltimoAccesso(rs.getTimestamp("ultimo_accesso"));
                if (rs.getString("telefono") == null)
                    u.setTelefono("");
                u.setTelefono(rs.getString("telefono"));

                users.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return users;
    }

    public List<String> getAllTecnici() {
        List<String> tecnici = new ArrayList<>();

        String query = "SELECT nomeCognome FROM utenti WHERE ruolo = 'Tecnico'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                String nomeCognome = rs.getString("nomeCognome");
                tecnici.add(nomeCognome);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tecnici;
    }

    public void deleteUser(int id) {
        String query = "DELETE FROM utenti WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public int countUser() {
        String query = "SELECT COUNT(*) FROM utenti";
        int count = -1;
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement()) {

            ResultSet rs = stmt.executeQuery(query);
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
}
