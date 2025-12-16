package util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Helper class to load Email configuration from properties file
 */
public class EmailConfig {
    private static Properties config = null;

    static {
        loadConfig();
    }

    private static void loadConfig() {
        config = new Properties();
        try (InputStream input = EmailConfig.class.getClassLoader()
                .getResourceAsStream("config.properties")) {
            if (input == null) {
                System.err.println("⚠️ config.properties not found for EmailConfig");
                return;
            }
            config.load(input);
        } catch (IOException e) {
            System.err.println("❌ Error loading config.properties for EmailConfig: " + e.getMessage());
        }
    }

    private static String getConfigValue(String key, String envVar, String defaultValue) {
        String value = config != null ? config.getProperty(key) : null;
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(envVar);
        }
        return (value != null && !value.trim().isEmpty()) ? value : defaultValue;
    }

    public static String getSmtpHost() {
        return getConfigValue("email.smtp.host", "EMAIL_SMTP_HOST", "smtp.gmail.com");
    }

    public static int getSmtpPort() {
        String portStr = getConfigValue("email.smtp.port", "EMAIL_SMTP_PORT", "587");
        return Integer.parseInt(portStr);
    }

    public static String getSmtpUsername() {
        return getConfigValue("email.smtp.username", "EMAIL_SMTP_USERNAME", "");
    }

    public static String getSmtpPassword() {
        return getConfigValue("email.smtp.password", "EMAIL_SMTP_PASSWORD", "");
    }

    public static String getFromAddress() {
        return getConfigValue("email.smtp.from", "EMAIL_SMTP_FROM", "noreply@tecnodeposit.it");
    }

    public static boolean getStartTls() {
        String value = getConfigValue("email.smtp.starttls", "EMAIL_SMTP_STARTTLS", "true");
        return Boolean.parseBoolean(value);
    }

    /**
     * Creates an EmailService instance with configuration from properties file
     */
    public static EmailService createEmailService() {
        return new EmailService(
                getSmtpHost(),
                getSmtpPort(),
                getSmtpUsername(),
                getSmtpPassword(),
                getStartTls(),
                getFromAddress());
    }
}
