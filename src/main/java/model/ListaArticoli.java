package model;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import java.util.function.Function;

import dao.DBConnection;
import model.Articolo.Stato;

public class ListaArticoli {
    public List<Articolo> getAllarticoli() {
        List<Articolo> articoli = new ArrayList<>();

        String query = "SELECT a.* FROM articolo a " +
                "LEFT JOIN (SELECT id_articolo, MAX(data_modifica) as ultima_modifica " +
                "           FROM storico_articolo GROUP BY id_articolo) s " +
                "ON a.id = s.id_articolo " +
                "ORDER BY COALESCE(s.ultima_modifica, a.id) DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

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

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articoli;
    }

    public List<String> getAllNomi() {
        List<String> articoli = new ArrayList<>();

        String query = "SELECT nome FROM articolo";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                articoli.add(rs.getString("nome"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articoli;
    }

    public static Articolo getArticoloById(int id) {
        Articolo articolo = new Articolo();

        String query = "SELECT * FROM articolo where id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                articolo = new Articolo();
                articolo.setId(rs.getInt("id"));
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
                String statoStr = rs.getString("stato");

                if (statoStr != null) {
                    Stato stato = Stato.valueOf(statoStr.replace(" ", "_").toUpperCase());
                    articolo.setStato(stato);
                } else {
                    articolo.setStato(Stato.GUASTO); // oppure un valore di default, tipo Stato.UNKNOWN
                }
                articolo.setImmagine(rs.getString("immagine"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return articolo;

    }

    public void addArticolo(Articolo articolo) {
        String query = "INSERT INTO articolo (matricola, nome, marca, compatibilita,ddt,ddtSpedizione,tecnico,pv,provenienza,fornitore,data_ricezione,data_spedizione,data_garanzia,note,stato,immagine,richiesta_garanzia) VALUES (? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ? , ?,?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, articolo.getMatricola());
            stmt.setString(2, articolo.getNome());
            stmt.setString(3, articolo.getMarca());
            stmt.setString(4, articolo.getCompatibilita());
            if (articolo.getDdt() > 0) {
                stmt.setInt(5, articolo.getDdt());
            } else {
                stmt.setNull(5, java.sql.Types.INTEGER);
            }
            if (articolo.getDdtSpedizione() > 0) {
                stmt.setInt(6, articolo.getDdtSpedizione());
            } else {
                stmt.setNull(6, java.sql.Types.INTEGER);
            }
            stmt.setString(7, articolo.getTecnico());
            stmt.setString(8, articolo.getPv());
            stmt.setString(9, articolo.getProvenienza());
            stmt.setString(10, articolo.getFornitore());
            if (articolo.getDataRic_DDT() != null) {
                stmt.setDate(11, java.sql.Date.valueOf(articolo.getDataRic_DDT()));
            } else {
                stmt.setNull(11, java.sql.Types.DATE);
            }

            if (articolo.getDataSpe_DDT() != null) {
                stmt.setDate(12, java.sql.Date.valueOf(articolo.getDataSpe_DDT()));
            } else {
                stmt.setNull(12, java.sql.Types.DATE);
            }

            if (articolo.getDataGaranzia() != null) {
                stmt.setDate(13, java.sql.Date.valueOf(articolo.getDataGaranzia()));
            } else {
                stmt.setNull(13, java.sql.Types.DATE);
            }
            stmt.setString(14, articolo.getNote());
            stmt.setString(15, articolo.getStato().toString());
            stmt.setString(16, articolo.getImmagine());
            stmt.setBoolean(17, articolo.getRichiestaGaranzia());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }

    }

    public void updateArticolo(Articolo articolo, String utenteModifica) throws SQLException {
        String queryUpdate = "UPDATE articolo SET matricola = ?, nome = ?, marca = ?, compatibilita = ?, ddt = ?, ddtSpedizione = ?, tecnico = ?, pv = ?, provenienza = ?, fornitore = ?, data_ricezione = ?, data_spedizione = ?, data_garanzia = ?, note = ?, stato = ?, richiesta_garanzia = ?, immagine = ? WHERE id = ?";

        String queryStorico = "INSERT INTO storico_articolo (id_articolo, matricola, nome, marca, compatibilita, ddt, ddtSpedizione, tecnico, pv, provenienza, fornitore, data_ricezione, data_spedizione, data_garanzia, note, stato, immagine, utente_modifica, motivazione) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection()) {

            // 🔁 STEP 1 - LOG VERSIONE PRIMA DELL'UPDATE
            try (PreparedStatement stmtSelectBefore = conn.prepareStatement("SELECT * FROM articolo WHERE id = ?")) {
                stmtSelectBefore.setInt(1, articolo.getId());
                ResultSet rs = stmtSelectBefore.executeQuery();

                if (rs.next()) {
                    try (PreparedStatement stmtStorico = conn.prepareStatement(queryStorico)) {
                        stmtStorico.setInt(1, rs.getInt("id"));
                        stmtStorico.setString(2, rs.getString("matricola"));
                        stmtStorico.setString(3, rs.getString("nome"));
                        stmtStorico.setString(4, rs.getString("marca"));
                        stmtStorico.setString(5, rs.getString("compatibilita"));
                        stmtStorico.setInt(6, rs.getInt("ddt"));
                        stmtStorico.setInt(7, rs.getInt("ddtSpedizione"));
                        stmtStorico.setString(8, rs.getString("tecnico"));
                        stmtStorico.setString(9, rs.getString("pv"));
                        stmtStorico.setString(10, rs.getString("provenienza"));
                        stmtStorico.setString(11, rs.getString("fornitore"));
                        stmtStorico.setDate(12, rs.getDate("data_ricezione"));
                        stmtStorico.setDate(13, rs.getDate("data_spedizione"));
                        stmtStorico.setDate(14, rs.getDate("data_garanzia"));
                        stmtStorico.setString(15, rs.getString("note"));
                        stmtStorico.setString(16, rs.getString("stato"));
                        stmtStorico.setString(17, rs.getString("immagine"));
                        stmtStorico.setString(18, utenteModifica);
                        stmtStorico.setString(19, "");
                        stmtStorico.executeUpdate();
                    }
                }
            }

            // 🔄 STEP 2 - AGGIORNAMENTO ARTICOLO
            try (PreparedStatement stmtUpdate = conn.prepareStatement(queryUpdate)) {
                stmtUpdate.setString(1, articolo.getMatricola());
                stmtUpdate.setString(2, articolo.getNome());
                stmtUpdate.setString(3, articolo.getMarca());
                stmtUpdate.setString(4, articolo.getCompatibilita());

                if (articolo.getDdt() > 0) {
                    stmtUpdate.setInt(5, articolo.getDdt());
                } else {
                    stmtUpdate.setNull(5, java.sql.Types.INTEGER);
                }

                if (articolo.getDdtSpedizione() > 0) {
                    stmtUpdate.setInt(6, articolo.getDdtSpedizione());
                } else {
                    stmtUpdate.setNull(6, java.sql.Types.INTEGER);
                }

                stmtUpdate.setString(7, articolo.getTecnico());
                stmtUpdate.setString(8, articolo.getPv());
                stmtUpdate.setString(9, articolo.getProvenienza());
                stmtUpdate.setString(10, articolo.getFornitore());

                if (articolo.getDataRic_DDT() != null) {
                    stmtUpdate.setDate(11, java.sql.Date.valueOf(articolo.getDataRic_DDT()));
                } else {
                    stmtUpdate.setNull(11, java.sql.Types.DATE);
                }

                if (articolo.getDataSpe_DDT() != null) {
                    stmtUpdate.setDate(12, java.sql.Date.valueOf(articolo.getDataSpe_DDT()));
                } else {
                    stmtUpdate.setNull(12, java.sql.Types.DATE);
                }

                if (articolo.getDataGaranzia() != null) {
                    stmtUpdate.setDate(13, java.sql.Date.valueOf(articolo.getDataGaranzia()));
                } else {
                    stmtUpdate.setNull(13, java.sql.Types.DATE);
                }

                stmtUpdate.setString(14, articolo.getNote());
                stmtUpdate.setString(15, articolo.getStato().toString());
                stmtUpdate.setBoolean(16, articolo.getRichiestaGaranzia());
                stmtUpdate.setString(17, articolo.getImmagine());
                stmtUpdate.setInt(18, articolo.getId());

                stmtUpdate.executeUpdate();
            }

            // ✅ STEP 3 - LOG VERSIONE DOPO L'UPDATE
            try (PreparedStatement stmtSelectAfter = conn.prepareStatement("SELECT * FROM articolo WHERE id = ?")) {
                stmtSelectAfter.setInt(1, articolo.getId());
                ResultSet rs = stmtSelectAfter.executeQuery();

                if (rs.next()) {
                    try (PreparedStatement stmtStorico = conn.prepareStatement(queryStorico)) {
                        stmtStorico.setInt(1, rs.getInt("id"));
                        stmtStorico.setString(2, rs.getString("matricola"));
                        stmtStorico.setString(3, rs.getString("nome"));
                        stmtStorico.setString(4, rs.getString("marca"));
                        stmtStorico.setString(5, rs.getString("compatibilita"));
                        stmtStorico.setInt(6, rs.getInt("ddt"));
                        stmtStorico.setInt(7, rs.getInt("ddtSpedizione"));
                        stmtStorico.setString(8, rs.getString("tecnico"));
                        stmtStorico.setString(9, rs.getString("pv"));
                        stmtStorico.setString(10, rs.getString("provenienza"));
                        stmtStorico.setString(11, rs.getString("fornitore"));
                        stmtStorico.setDate(12, rs.getDate("data_ricezione"));
                        stmtStorico.setDate(13, rs.getDate("data_spedizione"));
                        stmtStorico.setDate(14, rs.getDate("data_garanzia"));
                        stmtStorico.setString(15, rs.getString("note"));
                        stmtStorico.setString(16, rs.getString("stato"));
                        stmtStorico.setString(17, rs.getString("immagine"));
                        stmtStorico.setString(18, utenteModifica);
                        stmtStorico.setString(19, "");
                        stmtStorico.executeUpdate();
                    }
                }
            }
            NotificationService.createNotificaTemporaneaPerTutti(utenteModifica + " ha modificato un articolo");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteArticolo(int id) {
        String deleteRichieste = "DELETE FROM richiesta_riga WHERE articolo_id = ?";
        String deleteArticolo = "DELETE FROM articolo WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false); // disattiva l'autocommit per la transazione

            try (PreparedStatement ps1 = conn.prepareStatement(deleteRichieste);
                    PreparedStatement ps2 = conn.prepareStatement(deleteArticolo)) {

                // 1️⃣ Elimina tutte le richieste che contengono l’articolo
                ps1.setInt(1, id);
                ps1.executeUpdate();

                // 2️⃣ Ora puoi eliminare l’articolo
                ps2.setInt(1, id);
                ps2.executeUpdate();

                conn.commit(); // tutto ok → conferma

            } catch (SQLException e) {
                conn.rollback(); // errore → annulla tutto
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Articolo> getArticoliPaginati(int offset, int limit) {
        List<Articolo> lista = new ArrayList<>();
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM articoli LIMIT ? OFFSET ?");
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Articolo a = new Articolo();
                // Popola l'articolo
                lista.add(a);
            }
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return lista;
    }

    public List<String> getMarche() {
        List<Articolo> articoli = getAllarticoli();
        return articoli.stream().map(Articolo::getMarca).distinct().collect(Collectors.toList());
    }

    public List<String> getCampoFromDb(String column) {
        List<String> campo = new ArrayList<>();
        String sql = "SELECT DISTINCT " + column + (column.equals("matricola") ? "" : ", matricola") + " FROM articolo";

        try (Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String value = rs.getString(column);
                String matricola = column.equals("matricola") ? value : rs.getString("matricola");

                if (value != null && matricola != null) {
                    campo.add(value);
                }
            }

        } catch (SQLException e) {
            System.err.println("Errore durante la query su colonna: " + column);
            e.printStackTrace();
        }

        return campo;
    }

    public List<String> getCampo(Function<Articolo, String> fieldExtractor) {
        List<Articolo> articoli = getAllarticoli();
        return articoli.stream()
                .map(fieldExtractor)
                .filter(Objects::nonNull)
                .distinct()
                .collect(Collectors.toList());
    }

    public List<Articolo> getArticoliPronti() {
        return getAllarticoli().stream()
                .filter(a -> "In magazzino".equalsIgnoreCase(a.getStato().toString())
                        || "Riparato".equalsIgnoreCase(a.getStato().toString()))
                .toList();
    }

    /**
     * Trova tutti gli articoli disponibili (In magazzino o Riparato) con il nome
     * specificato.
     * Usato per l'assegnazione di quantità multiple durante l'approvazione
     * richieste.
     */
    public List<Articolo> getArticoliDisponibiliByNome(String nome) {
        if (nome == null || nome.isBlank())
            return new java.util.ArrayList<>();
        return getAllarticoli().stream()
                .filter(a -> nome.equalsIgnoreCase(a.getNome()))
                .filter(a -> "In magazzino".equalsIgnoreCase(a.getStato().toString())
                        || "Riparato".equalsIgnoreCase(a.getStato().toString()))
                .toList();
    }

    /**
     * Trova gli articoli assegnati a un tecnico con il nome specificato.
     * Usato per il rifiuto di richieste precedentemente approvate.
     */
    public List<Articolo> getArticoliAssegnatiByNomeETecnico(String nome, String tecnico) {
        if (nome == null || nome.isBlank() || tecnico == null || tecnico.isBlank())
            return new java.util.ArrayList<>();
        return getAllarticoli().stream()
                .filter(a -> nome.equalsIgnoreCase(a.getNome()))
                .filter(a -> tecnico.equalsIgnoreCase(a.getTecnico()))
                .filter(a -> "Assegnato".equalsIgnoreCase(a.getStato().toString()))
                .toList();
    }

    public List<Articolo> filtra(String search, String stato, String marca, String dataRicezione, String nome,
            String check) {
        List<Articolo> articoli = getAllarticoli();
        // System.out.println("OTTENUTO: "+search+" | "+stato+" | "+marca+" |
        // "+dataRicezione);

        return articoli.stream().filter(a -> {
            boolean match = true;
            if (search != null && !search.isEmpty()) {
                String searchLower = search.toLowerCase();

                match &= (a.getNome() != null && a.getNome().toLowerCase().contains(searchLower)) ||
                        (a.getMatricola() != null && a.getMatricola().toLowerCase().contains(searchLower)) ||
                        (a.getFornitore() != null && a.getFornitore().toLowerCase().contains(searchLower)) ||
                        (a.getTecnico() != null && a.getTecnico().toLowerCase().contains(searchLower));
            }
            if (check.equals("nascondi"))
                match &= !a.getStato().toString().equalsIgnoreCase("installato");
            if (stato != null && !stato.isEmpty()) {
                System.out.println("MATCH TRA |" + a.getStato().name() + "| e |" + stato.trim() + "|");
                match &= a.getStato().toString().equalsIgnoreCase(stato.trim());

            } // Se nessun filtro stato è applicato, escludi gli articoli già installati

            if (marca != null && !marca.isEmpty()) {
                match &= a.getMarca().equalsIgnoreCase(marca);
            }
            if (nome != null && !nome.isEmpty()) {
                if (a.getTecnico() == null || !a.getTecnico().equalsIgnoreCase(nome)) {
                    match = false;
                }
            }
            if (dataRicezione != null && !dataRicezione.isEmpty()) {
                if (a.getDataRic_DDT() == null)
                    match = false;
                else {
                    match &= a.getDataRic_DDT().toString().equals(dataRicezione);
                }
            }
            return match;
        }).collect(Collectors.toList());
    }

    public int countArticoli() {
        String query = "SELECT COUNT(*) FROM articolo";
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

    public int countArticoliPerStato(String stato) {
        String query = "SELECT COUNT(*) FROM articolo WHERE stato = ?";
        int count = -1;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, stato);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int countArticoliByNome(String nome) {
        String query = "SELECT COUNT(*) FROM articolo WHERE nome = ?";
        int count = -1;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, nome);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int countArticoliDisponibiliByNome(String nome) {
        String query = "SELECT COUNT(*) \r\n"
                + "FROM articolo \r\n"
                + "WHERE nome = ? \r\n"
                + "AND stato IN ('Riparato', 'In Magazzino')";
        int count = -1;

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, nome);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int countArticoliScaduti() {
        String query = "SELECT COUNT(*) FROM articolo WHERE data_garanzia < CURDATE()";
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
        if (count == -1)
            return count + 1;
        else
            return count;
    }

    public static List<Articolo> getArticoloByFornitore(int idFornitore) {
        List<Articolo> lista = new ArrayList<>();

        String nomeFornitore = null;
        try (Connection conn = DBConnection.getConnection()) {
            // Recupera nome del fornitore
            String queryNome = "SELECT nome FROM fornitore WHERE id = ?";
            try (PreparedStatement stmtNome = conn.prepareStatement(queryNome)) {
                stmtNome.setInt(1, idFornitore);
                ResultSet rs = stmtNome.executeQuery();
                if (rs.next()) {
                    nomeFornitore = rs.getString("nome");
                } else {
                    return lista; // Nessun fornitore trovato, ritorna lista vuota
                }
            }
            Articolo articolo = new Articolo();
            // Recupera gli articoli con quel nome fornitore
            String query = "SELECT * FROM articolo WHERE fornitore = ?";
            try (PreparedStatement stmt = conn.prepareStatement(query)) {
                stmt.setString(1, nomeFornitore);
                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    articolo = new Articolo();
                    articolo.setId(rs.getInt("id"));
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
                    String statoStr = rs.getString("stato");

                    if (statoStr != null) {
                        Stato stato = Stato.valueOf(statoStr.replace(" ", "_").toUpperCase());
                        articolo.setStato(stato);
                    } else {
                        articolo.setStato(Stato.GUASTO); // oppure un valore di default, tipo Stato.UNKNOWN
                    }
                    articolo.setImmagine(rs.getString("immagine"));
                    articolo.setRichiestaGaranzia(rs.getBoolean("richiesta_garanzia"));
                    lista.add(articolo);
                }

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return lista;
    }

    public int countArticoliInAttesa() {
        String query = "SELECT COUNT(*) FROM articolo WHERE stato = 'In Attesa'";
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
        if (count == -1)
            return count + 1;
        else
            return count;
    }

    public List<String> getNomiTecnici() {
        List<String> tecnici = new ArrayList<>();
        String query = "SELECT DISTINCT tecnico FROM articolo " +
                "WHERE tecnico IS NOT NULL AND TRIM(tecnico) <> ''";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query);
                ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                tecnici.add(rs.getString("tecnico"));
            }

        } catch (SQLException e) {
            e.printStackTrace(); // O gestisci con log
        }

        return tecnici;
    }

    public List<Integer> countArticoliPerTecnico(List<String> tecnici) {
        List<Integer> counts = new ArrayList<>();
        String query = "SELECT COUNT(*) FROM articolo WHERE tecnico = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement stmt = conn.prepareStatement(query)) {

            for (String tecnico : tecnici) {
                stmt.setString(1, tecnico);
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
