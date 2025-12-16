package util;

import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.sql.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

import dao.DBConnection;


public class TableMaintenance {

    /** Esegue: dump -> clear (DELETE o TRUNCATE). */
    public static void backupAndClearTable(Connection externalConn,
                                           String tableName,
                                           Path dumpFile,
                                           boolean preferTruncate,
                                           boolean preserveAutoIncrementIfTruncate,
                                           boolean includeTriggers) throws Exception {

        validateTableIdentifier(tableName);
        ensureParentDir(dumpFile);

        boolean closeConn = false;
        Connection conn = externalConn;
        if (conn == null || conn.isClosed()) {
            conn = DBConnection.getConnection();
            closeConn = true;
        }

        try {
            // 1) DUMP COMPLETO
            dumpTableToSql(conn, tableName, dumpFile, includeTriggers);

            // 2) SVUOTA TABELLA
            if (preferTruncate) {
                // Opzionale: preserva l'auto_increment originale
                Long nextAuto = null;
                if (preserveAutoIncrementIfTruncate) {
                    nextAuto = readAutoIncrement(conn, tableName);
                }

                // TRUNCATE (fuori da transazione)
                boolean auto = conn.getAutoCommit();
                if (!auto) conn.commit(); // chiudi eventuale tx aperta
                try (Statement st = conn.createStatement()) {
                    st.executeUpdate("TRUNCATE TABLE `" + tableName + "`");
                } catch (SQLException ex) {
                    // Se fallisce (es. FK 1701), fallback a DELETE
                    if (!attemptDeleteAll(conn, tableName)) {
                        throw new SQLException("TRUNCATE fallito e DELETE fallback impossibile: " + ex.getMessage(), ex);
                    }
                }

                if (preserveAutoIncrementIfTruncate && nextAuto != null && nextAuto > 1) {
                    try (Statement st = conn.createStatement()) {
                        st.executeUpdate("ALTER TABLE `" + tableName + "` AUTO_INCREMENT = " + nextAuto);
                    }
                }

            } else {
                // DELETE in transazione (rollback possibile)
                boolean oldAuto = conn.getAutoCommit();
                conn.setAutoCommit(false);
                try {
                    try (Statement st = conn.createStatement()) {
                        st.executeUpdate("DELETE FROM `" + tableName + "`"); // no WHERE: tutte le righe
                    }
                    conn.commit();
                } catch (SQLException ex) {
                    conn.rollback();
                    throw ex;
                } finally {
                    conn.setAutoCommit(oldAuto);
                }
            }

        } finally {
            if (closeConn && conn != null) try { conn.close(); } catch (Exception ignore) {}
        }
    }

    /** Crea un dump .sql della tabella: CREATE TABLE + INSERT + (opzionalmente) TRIGGER. */
    public static void dumpTableToSql(Connection conn, String tableName, Path outFile, boolean includeTriggers)
            throws SQLException, IOException {

        validateTableIdentifier(tableName);
        ensureParentDir(outFile);

        try (BufferedWriter w = Files.newBufferedWriter(outFile, StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING)) {

            // Header
            w.write("-- Dump generato da TableMaintenance\n");
            w.write("-- Tabella: `" + tableName + "`\n");
            w.write("-- Data: " + timestamp() + "\n\n");
            w.write("SET NAMES utf8mb4;\n");
            w.write("SET FOREIGN_KEY_CHECKS=0;\n");
            w.write("START TRANSACTION;\n\n");

            // SHOW CREATE TABLE
            String createStmt = showCreateTable(conn, tableName);
            w.write("-- Struttura\n");
            w.write("DROP TABLE IF EXISTS `" + tableName + "`;\n");
            w.write(createStmt + ";\n\n");

            // Dati -> INSERT
            w.write("-- Dati\n");
            writeInserts(conn, tableName, w);

            // Trigger (opzionale)
            if (includeTriggers) {
                writeTriggers(conn, tableName, w);
            }

            w.write("\nCOMMIT;\n");
            w.write("SET FOREIGN_KEY_CHECKS=1;\n");
        }
    }

    // ===================== Helpers DUMP =====================

    private static String showCreateTable(Connection conn, String tableName) throws SQLException {
        String sql = "SHOW CREATE TABLE `" + tableName + "`";
        try (Statement st = conn.createStatement(); ResultSet rs = st.executeQuery(sql)) {
            if (!rs.next()) throw new SQLException("SHOW CREATE TABLE non ha restituito risultati per " + tableName);
            // Colonna 2 normalmente è "Create Table"
            return rs.getString(2);
        }
    }

    private static void writeInserts(Connection conn, String tableName, BufferedWriter w) throws SQLException, IOException {
        String sql = "SELECT * FROM `" + tableName + "`";
        try (PreparedStatement ps = conn.prepareStatement(sql,
                ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY)) {
            // Streaming per MySQL (richiede parametri nel JDBC URL: useCursorFetch=true o fetchSize=MIN_VALUE)
            ps.setFetchSize(Integer.MIN_VALUE);

            try (ResultSet rs = ps.executeQuery()) {
                ResultSetMetaData md = rs.getMetaData();
                final int cols = md.getColumnCount();

                // Lista colonne
                StringBuilder colsList = new StringBuilder();
                colsList.append("(");
                for (int i = 1; i <= cols; i++) {
                    if (i > 1) colsList.append(", ");
                    colsList.append("`").append(md.getColumnLabel(i)).append("`");
                }
                colsList.append(")");

                int batchCount = 0;
                String prefix = "INSERT INTO `" + tableName + "` " + colsList + " VALUES ";

                StringBuilder insert = new StringBuilder(prefix);

                while (rs.next()) {
                    if (batchCount > 0) insert.append(",\n");
                    insert.append("(");
                    for (int i = 1; i <= cols; i++) {
                        if (i > 1) insert.append(", ");
                        insert.append(sqlLiteral(rs, md, i));
                    }
                    insert.append(")");
                    batchCount++;

                    // Scrivi a blocchi per non fare file con mega-righe
                    if (batchCount >= 500) {
                        insert.append(";");
                        w.write(insert.toString());
                        w.write("\n");
                        insert.setLength(0);
                        insert.append(prefix);
                        batchCount = 0;
                    }
                }

                if (batchCount > 0) {
                    insert.append(";");
                    w.write(insert.toString());
                    w.write("\n");
                }
            }
        }
    }

    private static String sqlLiteral(ResultSet rs, ResultSetMetaData md, int index) throws SQLException {
        Object val = rs.getObject(index);
        if (val == null) return "NULL";

        int type = md.getColumnType(index);
        switch (type) {
            case Types.TINYINT:
            case Types.SMALLINT:
            case Types.INTEGER:
            case Types.BIGINT:
            case Types.FLOAT:
            case Types.DOUBLE:
            case Types.DECIMAL:
            case Types.NUMERIC:
                // numerici non quotati
                return val.toString();

            case Types.BIT: {
                // BIT(1) spesso come boolean
                boolean b = rs.getBoolean(index);
                return b ? "1" : "0";
            }

            case Types.DATE:
            case Types.TIME:
            case Types.TIMESTAMP:
            case Types.TIMESTAMP_WITH_TIMEZONE:
                return "'" + rs.getString(index) + "'"; // formato JDBC conforme

            case Types.BINARY:
            case Types.VARBINARY:
            case Types.LONGVARBINARY:
                byte[] bytes = rs.getBytes(index);
                if (bytes == null) return "NULL";
                return toHex(bytes);

            default:
                // stringhe
                String s = rs.getString(index);
                return "'" + escapeSqlString(s) + "'";
        }
    }

    private static String toHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder("0x");
        for (byte b : bytes) {
            sb.append(String.format(Locale.ROOT, "%02x", b));
        }
        return sb.toString();
    }

    private static String escapeSqlString(String s) {
        if (s == null) return null;
        // escape backslash e apici singoli
        return s.replace("\\", "\\\\").replace("'", "''");
    }

    private static void writeTriggers(Connection conn, String tableName, BufferedWriter w) throws SQLException, IOException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SHOW TRIGGERS WHERE `Table` = ?")) {
            ps.setString(1, tableName);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String triggerName = rs.getString("Trigger");
                    try (Statement st2 = conn.createStatement();
                         ResultSet rs2 = st2.executeQuery("SHOW CREATE TRIGGER `" + triggerName + "`")) {
                        if (rs2.next()) {
                            String createTrig = rs2.getString("SQL Original Statement");
                            w.write("\n-- Trigger: " + triggerName + "\n");
                            w.write("DROP TRIGGER IF EXISTS `" + triggerName + "`;\n");
                            w.write(createTrig + ";\n");
                        }
                    }
                }
            }
        }
    }

    private static Long readAutoIncrement(Connection conn, String tableName) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT AUTO_INCREMENT FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ?")) {
            ps.setString(1, tableName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        return null;
    }

    private static boolean attemptDeleteAll(Connection conn, String tableName) {
        boolean oldAuto;
        try {
            oldAuto = conn.getAutoCommit();
            conn.setAutoCommit(false);
            try (Statement st = conn.createStatement()) {
                st.executeUpdate("DELETE FROM `" + tableName + "`");
            }
            conn.commit();
            return true;
        } catch (SQLException ex) {
            try { conn.rollback(); } catch (Exception ignore) {}
            return false;
        } finally {
            try { conn.setAutoCommit(true); } catch (Exception ignore) {}
        }
    }

    private static void validateTableIdentifier(String table) {
        // semplice guardia contro injection nel nome tabella
        if (table == null || !table.matches("[A-Za-z0-9_]+")) {
            throw new IllegalArgumentException("Nome tabella non valido: " + table);
        }
    }

    private static void ensureParentDir(Path file) throws IOException {
        Path parent = file.getParent();
        if (parent != null) Files.createDirectories(parent);
    }

    public static String timestamp() {
        return LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss"));
    }
}
