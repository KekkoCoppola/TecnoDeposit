package dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {
    private static Properties config = null;

    static {
        loadConfig();
    }

    private static void loadConfig() {
        config = new Properties();
        try (InputStream input = DBConnection.class.getClassLoader()
                .getResourceAsStream("config.properties")) {
            if (input == null) {
                System.err.println("⚠️ config.properties not found, using environment variables");
                return;
            }
            config.load(input);
        } catch (IOException e) {
            System.err.println("❌ Error loading config.properties: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private static String getConfigValue(String key, String envVar, String defaultValue) {
        // Priority: 1. config.properties, 2. environment variable, 3. default
        String value = config != null ? config.getProperty(key) : null;
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(envVar);
        }
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName(getConfigValue("db.driver", "DB_DRIVER", "com.mysql.cj.jdbc.Driver"));
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL JDBC Driver not found!");
            throw new SQLException("Database driver not found", e);
        }

        String url = getConfigValue("db.url", "DB_URL", "jdbc:mysql://localhost:3306/tecnodeposit");
        String user = getConfigValue("db.username", "DB_USERNAME", "root");
        String password = getConfigValue("db.password", "DB_PASSWORD", "");

        // Security check: warn if using default values
        if (password.isEmpty()) {
            System.err.println("⚠️ WARNING: Database password not configured!");
        }

        return DriverManager.getConnection(url, user, password);
    }
}
