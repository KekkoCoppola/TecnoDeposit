package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import dao.DBConnection;


public class ListaFornitori {
	public List<Fornitore> getAllfornitori() {
        List<Fornitore> fornitori = new ArrayList<>();
      
        String query = "SELECT * FROM fornitore";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Fornitore f = new Fornitore();
                f.setId(rs.getInt("id")); 
                f.setNome(rs.getString("nome"));
                f.setMail(rs.getString("mail"));
                f.setPiva(rs.getString("partita_iva"));
                f.setTelefono(rs.getString("telefono"));
                f.setIndirizzo(rs.getString("indirizzo"));
                
                fornitori.add(f);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fornitori;
    }
	
	public List<String> getAllfornitoriNames() {
        List<String> fornitori = new ArrayList<>();
      
        String query = "SELECT nome FROM fornitore";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                fornitori.add(rs.getString("nome"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return fornitori;
    }
	
	public String getMostUsedFornitore() {
		String f="indefinito";
		String query ="SELECT\r\n"
				+ "  fornitore AS NomeFornitore,\r\n"
				+ "  COUNT(*) AS NumeroArticoli\r\n"
				+ "FROM\r\n"
				+ "  articolo\r\n"
				+ "WHERE\r\n"
				+ "  fornitore IS NOT NULL\r\n"
				+ "  AND TRIM(fornitore) <> ''\r\n"
				+ "GROUP BY\r\n"
				+ "  fornitore\r\n"
				+ "ORDER BY\r\n"
				+ "  NumeroArticoli DESC\r\n"
				+ "LIMIT 1;";
		try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(query);
	             ResultSet rs = stmt.executeQuery()) {

	            while (rs.next()) {
	                f=rs.getString("NomeFornitore");
	            }

	        } catch (SQLException e) {
	            e.printStackTrace();
	        }
		
		return f;
	}
	
	
    public void addFornitore(Fornitore f) {
        String query = "INSERT INTO fornitore(nome, mail, partita_iva, telefono,indirizzo) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

        	stmt.setString(1, f.getNome());
            stmt.setString(2, f.getMail());
            stmt.setString(3, f.getPiva());
            stmt.setString(4, f.getTelefono());
            stmt.setString(5, f.getIndirizzo());

            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
      
    }
    
    public static String getMailFornitore(int id) throws SQLException {
    	String query = "SELECT mail FROM Fornitore WHERE id = ?";
    	String mail = "ERRORE MAIL";
        try (Connection conn = DBConnection.getConnection();
        	PreparedStatement stmtNome = conn.prepareStatement(query)) {
            stmtNome.setInt(1, id);
            ResultSet rs = stmtNome.executeQuery();
            if (rs.next()) {
                mail = rs.getString("mail");
            } 
        }catch(SQLException e) {
        	e.printStackTrace();
        }
        return mail;
    }
    
    public void updateFornitore(Fornitore f) {
        String query = "UPDATE fornitore SET nome = ?, mail = ?, partita_iva = ?, telefono = ?, indirizzo = ?  WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

        	stmt.setString(1, f.getNome());
            stmt.setString(2, f.getMail());
            stmt.setString(3, f.getPiva());
            stmt.setString(4, f.getTelefono());
            stmt.setString(5, f.getIndirizzo());
            if (f.getId()>=0) {
                stmt.setInt(6, f.getId());
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }
            stmt.executeUpdate();
       
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void deleteFornitore(int id) {
        String query = "DELETE FROM fornitore WHERE id = ?";
       
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<Fornitore> filtra(String nome) {
    	List<Fornitore> fornitori = getAllfornitori();

        return fornitori.stream().filter(f -> {
            boolean match = true;
            if (nome != null && !nome.isEmpty()) {
                match &= f.getNome().toLowerCase().contains(nome.toLowerCase());
         
            }
         
            return match;
        }).collect(Collectors.toList());
    }
    
    public int countFornitori() {
    	String query = "SELECT COUNT(*) FROM fornitore";
    	int count=-1;
    	try (Connection conn = DBConnection.getConnection();
    			Statement stmt = conn.createStatement()){ 
    	
    	
    		ResultSet rs = stmt.executeQuery(query);
	    	if (rs.next()) {
	            count = rs.getInt(1);
	    	}
    	} catch (SQLException e) {
                    e.printStackTrace();
                }
    	return count;
    }
    public List<Integer> countArticoliPerFornitore(List<Fornitore> fornitore) {
        List<Integer> counts = new ArrayList<>();
        String query = "SELECT COUNT(*) FROM articolo WHERE fornitore = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            for (Fornitore f : fornitore) {
                stmt.setString(1, f.getNome());
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        counts.add(rs.getInt(1));
                    } else {
                        counts.add(0);
                    }
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return counts;
    }
}
