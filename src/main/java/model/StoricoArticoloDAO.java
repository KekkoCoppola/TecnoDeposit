package model;
import java.sql.*;
import java.sql.Date;
import java.util.*;

import dao.DBConnection;

public class StoricoArticoloDAO {

    public static List<Map<String, String>> getStoricoByArticoloId(int idArticolo) {
        List<Map<String, String>> storico = new ArrayList<>();

        String query = "SELECT * FROM storico_articolo WHERE id_articolo = ? ORDER BY data_modifica DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, idArticolo);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> record = new HashMap<>();
                record.put("data", rs.getString("data_modifica"));
                record.put("utente", rs.getString("utente_modifica"));
                record.put("motivazione", rs.getString("motivazione"));
                record.put("nome", rs.getString("nome"));
                record.put("stato", rs.getString("stato"));
                storico.add(record);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return storico;
    }
    
    public static Articolo getArticoloById(int id) {
		Articolo articolo = new Articolo();
	      
        String query = "SELECT * FROM storico_articolo where id_articolo = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

           	stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                articolo = new Articolo();
                articolo.setId(rs.getInt("id_articolo"));
                articolo.setMatricola(rs.getString("matricola"));
                articolo.setNome(rs.getString("nome"));
                articolo.setMarca(rs.getString("marca"));
                articolo.setCompatibilita(rs.getString("compatibilita"));
                articolo.setDdt(rs.getInt("ddt"));
                articolo.setDdtSpedizione(rs.getInt("ddtSpedizione"));
                articolo.setTecnico(rs.getString("tecnico"));
                articolo.setPv(rs.getString("pv"));
                articolo.setProvenienza(rs.getString("provenienza"));
                articolo.setFornitore(rs.getString("fornitore"));

                Date dataRicezione = rs.getDate("data_ricezione");
                if (dataRicezione != null)
                    articolo.setDataRic_DDT(dataRicezione.toLocalDate());

                Date dataSpedizione = rs.getDate("data_spedizione");
                if (dataSpedizione != null)
                    articolo.setDataSpe_DDT(dataSpedizione.toLocalDate());

                Date dataGaranzia = rs.getDate("data_garanzia");
                if (dataGaranzia != null)
                    articolo.setDataGaranzia(dataGaranzia.toLocalDate());

                articolo.setNote(rs.getString("note"));
                articolo.setStato(Articolo.Stato.valueOf(rs.getString("stato")));
                articolo.setImmagine(rs.getString("immagine"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articolo;

	}
    
    public static List<String> getModificheArticolo(int idArticolo) {
        List<Map<String, String>> storico = new ArrayList<>();
        List<String> modifiche = new ArrayList<>();

        String query = "SELECT * FROM storico_articolo WHERE id_articolo = ? ORDER BY data_modifica ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, idArticolo);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
            	Map<String, String> versione = new HashMap<>();
            	versione.put("matricola", rs.getString("matricola"));
            	versione.put("nome", rs.getString("nome"));
            	versione.put("marca", rs.getString("marca"));
            	versione.put("compatibilita", rs.getString("compatibilita"));
            	versione.put("ddt", String.valueOf(rs.getInt("ddt")));

            	versione.put("ddtSpedizione", String.valueOf(rs.getInt("ddtSpedizione")));

            	versione.put("tecnico", rs.getString("tecnico"));
            	versione.put("pv", rs.getString("pv"));
            	versione.put("provenienza", rs.getString("provenienza"));
            	versione.put("fornitore", rs.getString("fornitore"));
            	versione.put("data_ricezione", rs.getString("data_ricezione"));
            	versione.put("data_spedizione", rs.getString("data_spedizione"));
            	versione.put("data_garanzia", rs.getString("data_garanzia"));
            	versione.put("note", rs.getString("note"));
            	versione.put("stato", rs.getString("stato"));
            	versione.put("immagine", rs.getString("immagine"));

            	versione.put("data", rs.getString("data_modifica")); // timestamp modifica
            	versione.put("utente", rs.getString("utente_modifica"));
            	versione.put("motivazione", rs.getString("motivazione"));

            	storico.add(versione);

            }

            for (int i = storico.size() - 1; i > 0; i--) {
                Map<String, String> precedente = storico.get(i - 1); // più recente
                Map<String, String> attuale = storico.get(i);        // precedente


                for (String campo : attuale.keySet()) {
                    if (campo.equals("data")) continue;

                    String valAttuale = attuale.get(campo);
                    String valPrec = precedente.get(campo);

                    if ((valAttuale != null && !valAttuale.equals(valPrec)) ||
                        (valAttuale == null && valPrec != null)) {

                        String riga = campo.toUpperCase() + " da " +
                                (valPrec != null ? valPrec : "-") + " -----> a " +
                                (valAttuale != null ? valAttuale : "-") +
                                " (il " + attuale.get("data") + ","+" utente: "+attuale.get("utente")+")";

                        modifiche.add(riga);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return modifiche;
    }

}
