package model;

import java.sql.Timestamp;

public class Notification {
    private int id;               // ID univoco della notifica
    private int userId;           // ID utente destinatario
    private String message;       // Messaggio della notifica
    private boolean read;         // Se la notifica è stata letta o meno
    private Timestamp createdAt;  // Timestamp di creazione

    // Costruttore completo
    public Notification(int id, int userId, String message, boolean read, Timestamp createdAt) {
        this.id = id;
        this.userId = userId;
        this.message = message;
        this.read = read;
        this.createdAt = createdAt;
    }
    
    public Notification(int id,int userId, String message, Timestamp timestamp) {
        this.id = id;
        this.userId = userId;
        this.message = message;
        this.createdAt = timestamp;
    }

    // Costruttore senza id (per creazione nuova notifica)
    public Notification(int userId, String message) {
        this.userId = userId;
        this.message = message;
        this.read = false;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }

    // Getter e Setter

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isRead() {
        return read;
    }

    public void setRead(boolean read) {
        this.read = read;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // --- Helper Metodi Parser Payload Nascosto (Senza alterare DB schema) ---
    // Struttura message supposta: "Testo per Utente|#|url_link|#|url_immagine"

    public String getDisplayText() {
        if(message != null && message.contains("|#|")) {
            return message.split("\\|#\\|")[0];
        }
        return message;
    }

    public String getLink() {
        if(message != null && message.contains("|#|")) {
            String[] parts = message.split("\\|#\\|");
            return parts.length > 1 ? parts[1] : "";
        }
        return "";
    }

    public String getImage() {
        if(message != null && message.contains("|#|")) {
            String[] parts = message.split("\\|#\\|");
            return parts.length > 2 ? parts[2] : "";
        }
        return "";
    }
}
