package dao;

import model.Articolo;
import model.Richiesta;
import model.RichiestaRiga;
import model.Articolo.Stato;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class RichiestaDAO {
    public int addRichiesta(Richiesta richiesta) throws SQLException {
        String sqlTestata = """
            INSERT INTO richiesta (richiedente_id, stato, urgenza, motivo, commento, note)
            VALUES (?, 'in_attesa', ?, ?, ?, ?)
        """;
        String sqlRiga = """
            INSERT INTO richiesta_riga (richiesta_id, articolo_id, quantita, note)
            VALUES (?, ?, ?, ?)
        """;

        try (Connection conn = DBConnection.getConnection()) {
            boolean oldAuto = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try {
                // 1) Inserisci testata
                int richiestaId;
                try (PreparedStatement ps = conn.prepareStatement(sqlTestata, Statement.RETURN_GENERATED_KEYS)) {
                    ps.setInt(1, richiesta.getRichiedenteId());
                    ps.setString(2, nullToDefault(richiesta.getUrgenza(), "media"));
                    ps.setString(3, nullToDefault(richiesta.getMotivo(), "Reintegro"));
                    ps.setString(4, richiesta.getCommento());
                    ps.setString(5, richiesta.getNote());
                    ps.executeUpdate();

                    try (ResultSet rs = ps.getGeneratedKeys()) {
                        if (!rs.next()) throw new SQLException("Impossibile ottenere l'ID della richiesta.");
                        richiestaId = rs.getInt(1);
                    }
                }

                // 2) Inserisci righe (se presenti)
                List<RichiestaRiga> righe = richiesta.getRighe();
                if (righe != null && !righe.isEmpty()) {
                    try (PreparedStatement ps = conn.prepareStatement(sqlRiga)) {
                        for (RichiestaRiga r : righe) {
                            ps.setInt(1, richiestaId);
                            ps.setInt(2, r.getArticoloId());
                            ps.setInt(3, (r.getQuantita() > 0 ? r.getQuantita() : 1));
                            ps.setString(4, r.getNote());
                            ps.addBatch();
                        }
                        ps.executeBatch();
                    }
                }

                conn.commit();
                conn.setAutoCommit(oldAuto);
                return richiestaId;

            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            }
        }
    }

    /** Rimuove la richiesta. Se la FK richiesta_riga ha ON DELETE CASCADE, basta cancellare la testata. */
    public void removeRichiesta(int richiestaId) throws SQLException {
        String sqlDeleteTestata = "DELETE FROM richiesta WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlDeleteTestata)) {

            ps.setInt(1, richiestaId);
            ps.executeUpdate();
        }
    }
    
    public void updateRichiesta(int idRichiesta, String nuovoStato) throws SQLException {
    	String sql = "UPDATE richiesta SET stato = ? WHERE id = ?";
    	try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

               ps.setString(1, nuovoStato);
               ps.setInt(2, idRichiesta);
               try {
				ps.executeUpdate();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
           }
    }
    
    public static Richiesta getRichiestaById(int id) throws SQLException {
        final String sql = """
            SELECT
                r.id                           AS r_id,
                r.richiedente_id               AS r_richiedente_id,
                r.stato                        AS r_stato,
                r.data_richiesta               AS r_data_richiesta,
                r.urgenza                      AS r_urgenza,
                r.motivo                       AS r_motivo,
                r.commento                     AS r_commento,
                r.note                         AS r_note,
                rr.id                          AS rr_id,
                rr.articolo_id                 AS rr_articolo_id,
                rr.quantita                    AS rr_quantita,
                rr.note                        AS rr_note
                -- , a.nome AS articolo_nome   -- se vuoi anche il nome articolo via JOIN: aggiungi LEFT JOIN articolo a...
            FROM richiesta r
            LEFT JOIN richiesta_riga rr ON rr.richiesta_id = r.id
            -- LEFT JOIN articolo a ON a.id = rr.articolo_id   -- opzionale per avere il nome
            WHERE r.id = ?
            ORDER BY rr.id ASC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                Richiesta r = null;
                List<RichiestaRiga> righe = new ArrayList<>();

                while (rs.next()) {
                    if (r == null) {
                        r = new Richiesta();
                        r.setId(rs.getInt("r_id"));
                        r.setRichiedenteId(rs.getInt("r_richiedente_id"));
                        r.setStato(rs.getString("r_stato"));
                        Timestamp ts = rs.getTimestamp("r_data_richiesta");
                        r.setDataRichiesta(ts != null ? ts.toLocalDateTime() : null);
                        r.setUrgenza(rs.getString("r_urgenza"));
                        r.setMotivo(rs.getString("r_motivo"));
                        r.setCommento(rs.getString("r_commento"));
                        r.setNote(rs.getString("r_note"));
                        r.setRighe(righe);
                    }

                    int rigaId = rs.getInt("rr_id");
                    if (!rs.wasNull()) {
                        RichiestaRiga rr = new RichiestaRiga();
                        rr.setId(rigaId);
                        rr.setRichiestaId(id);
                        rr.setArticoloId(rs.getInt("rr_articolo_id"));
                        rr.setQuantita(rs.getInt("rr_quantita"));
                        rr.setNote(rs.getString("rr_note"));

                        // Se hai previsto un campo "articoloNome" nella classe RichiestaRiga, puoi valorizzarlo:
                        // rr.setArticoloNome(rs.getString("articolo_nome"));

                        righe.add(rr);
                    }
                }

                return r; // null se non trovata
            }
        }
    }

    
    public List<Richiesta> getAllRichieste() throws SQLException {
        String sqlRichieste = """
            SELECT id, richiedente_id, stato, data_richiesta, urgenza, motivo, commento, note
            FROM richiesta
            ORDER BY FIELD(urgenza, 'alta','media','bassa'), data_richiesta DESC
        """;

        String sqlRighe = """
            SELECT id, richiesta_id, articolo_id, quantita, note
            FROM richiesta_riga
            WHERE richiesta_id = ?
        """;

        List<Richiesta> richieste = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psReq = conn.prepareStatement(sqlRichieste);
             ResultSet rs = psReq.executeQuery()) {

            while (rs.next()) {
                // mappa testata
                Richiesta r = new Richiesta();
                r.setId(rs.getInt("id"));
                r.setRichiedenteId(rs.getInt("richiedente_id"));
                r.setStato(rs.getString("stato"));
                Timestamp ts = rs.getTimestamp("data_richiesta");
                if (ts != null) r.setDataRichiesta(ts.toLocalDateTime());
                r.setUrgenza(rs.getString("urgenza"));
                r.setMotivo(rs.getString("motivo"));
                r.setCommento(rs.getString("commento"));
                r.setNote(rs.getString("note"));

                // carica righe
                List<RichiestaRiga> righe = new ArrayList<>();
                try (PreparedStatement psR = conn.prepareStatement(sqlRighe)) {
                    psR.setInt(1, r.getId());
                    try (ResultSet rsR = psR.executeQuery()) {
                        while (rsR.next()) {
                            RichiestaRiga rr = new RichiestaRiga();
                            rr.setId(rsR.getInt("id"));
                            rr.setRichiestaId(rsR.getInt("richiesta_id"));
                            rr.setArticoloId(rsR.getInt("articolo_id"));
                            rr.setQuantita(rsR.getInt("quantita"));
                            rr.setNote(rsR.getString("note"));
                            righe.add(rr);
                        }
                    }
                }
                r.setRighe(righe);

                richieste.add(r);
            }
        }
        return richieste;
    }

    
    public List<Richiesta> findByRichiedente(int richiedenteId) throws SQLException {
        String sqlRichiesta = """
            SELECT id, richiedente_id, stato, data_richiesta, urgenza, motivo, commento, note
            FROM richiesta
            WHERE richiedente_id = ?
            ORDER BY data_richiesta DESC
        """;

        String sqlRighe = """
            SELECT id, richiesta_id, articolo_id, quantita, note
            FROM richiesta_riga
            WHERE richiesta_id = ?
        """;

        List<Richiesta> richieste = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psReq = conn.prepareStatement(sqlRichiesta)) {

            psReq.setInt(1, richiedenteId);

            try (ResultSet rs = psReq.executeQuery()) {
                while (rs.next()) {
                    Richiesta r = new Richiesta();
                    r.setId(rs.getInt("id"));
                    r.setRichiedenteId(rs.getInt("richiedente_id"));
                    r.setStato(rs.getString("stato"));
                    Timestamp ts = rs.getTimestamp("data_richiesta");
                    if (ts != null) r.setDataRichiesta(ts.toLocalDateTime());
                    r.setUrgenza(rs.getString("urgenza"));
                    r.setMotivo(rs.getString("motivo"));
                    r.setCommento(rs.getString("commento"));
                    r.setNote(rs.getString("note"));

                    // carico righe
                    List<RichiestaRiga> righe = new ArrayList<>();
                    try (PreparedStatement psRiga = conn.prepareStatement(sqlRighe)) {
                        psRiga.setInt(1, r.getId());
                        try (ResultSet rsR = psRiga.executeQuery()) {
                            while (rsR.next()) {
                                RichiestaRiga riga = new RichiestaRiga();
                                riga.setId(rsR.getInt("id"));
                                riga.setRichiestaId(rsR.getInt("richiesta_id"));
                                riga.setArticoloId(rsR.getInt("articolo_id"));
                                riga.setQuantita(rsR.getInt("quantita"));
                                riga.setNote(rsR.getString("note"));
                                righe.add(riga);
                            }
                        }
                    }
                    r.setRighe(righe);

                    richieste.add(r);
                }
            }
        }
        return richieste;
    }
    
    public static List<Articolo> getArticoliByRichiestaId(int richiestaId) throws SQLException {
        String sql = "SELECT a.* " +
                     "FROM richiesta_riga rr " +
                     "JOIN articolo a ON rr.articolo_id = a.id " +
                     "WHERE rr.richiesta_id = ?";

        List<Articolo> articoli = new ArrayList<>();

        try (PreparedStatement ps = DBConnection.getConnection().prepareStatement(sql)) {
            ps.setInt(1, richiestaId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                	Articolo a = new Articolo();
                    a.setId(rs.getInt("id"));
                    a.setMatricola(rs.getString("matricola"));
                    a.setNome(rs.getString("nome"));
                    a.setMarca(rs.getString("marca"));
                    a.setCompatibilita(rs.getString("compatibilita"));
                    a.setDdt(rs.getInt("ddt"));
                    a.setDdtSpedizione(rs.getInt("ddtSpedizione"));
                    a.setTecnico(rs.getString("tecnico"));
                    a.setPv(rs.getString("pv"));
                    a.setProvenienza(rs.getString("provenienza"));
                    a.setFornitore(rs.getString("fornitore"));             
                    a.setImmagine(rs.getString("immagine"));
                    a.setRichiestaGaranzia(rs.getBoolean("richiesta_garanzia"));
                    java.sql.Date sqlDate = rs.getDate("data_ricezione");
                    java.sql.Date sqlDate2 = rs.getDate("data_spedizione");
                    java.sql.Date sqlDate3 = rs.getDate("data_garanzia");
                    if (sqlDate != null) {
                        LocalDate dataRic = sqlDate.toLocalDate();
                        a.setDataRic_DDT(dataRic);
                    } else {
                        a.setDataRic_DDT(null); // o gestisci come preferisci
                    }
                    if (sqlDate2 != null) {
                    	LocalDate dataSpe = sqlDate2.toLocalDate();
                        a.setDataSpe_DDT(dataSpe);
                    } else {
                        a.setDataSpe_DDT(null); // o gestisci come preferisci
                    }
                    if (sqlDate3 != null) {
                    	LocalDate dataGar = sqlDate3.toLocalDate();
                        a.setDataGaranzia(dataGar);
                    } else {
                        a.setDataGaranzia(null); // o gestisci come preferisci
                    }
                    a.setNote(rs.getString("note"));
                    
                    String statoStr = rs.getString("stato");

                    if (statoStr != null) {
                        Stato stato = Stato.valueOf(statoStr.replace(" ", "_").toUpperCase());
                        a.setStato(stato);
                    } else {
                        a.setStato(Stato.GUASTO); // oppure un valore di default, tipo Stato.UNKNOWN
                    }
                    
                 
                    articoli.add(a);
                }
            }
        }
        return articoli;
    }


    
    private static String nullToDefault(String v, String def) {
        return (v == null || v.isBlank()) ? def : v;
        }
}
