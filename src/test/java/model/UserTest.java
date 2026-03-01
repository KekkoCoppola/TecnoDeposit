package model;

import org.junit.jupiter.api.Test;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import static org.junit.jupiter.api.Assertions.*;

class UserTest {

    @Test
    void testUserGettersAndSetters() {
        User user = new User();
        user.setUsername("testuser");
        user.setMail("test@example.com");
        user.setNome("Mario");
        user.setCognome("Rossi");
        user.setRuolo("Tecnico");
        user.setStato("Attivo");

        assertEquals("testuser", user.getUsername());
        assertEquals("test@example.com", user.getMail());
        assertEquals("Mario", user.getNome());
        assertEquals("Rossi", user.getCognome());
        assertEquals("Tecnico", user.getRuolo());
        assertEquals("Attivo", user.getStato());
    }

    @Test
    void testGetUltimoAccesso2_WhenNull() {
        User user = new User();
        user.setUltimoAccesso(null);
        assertEquals("Mai effettuato", user.getUltimoAccesso2());
    }

    @Test
    void testGetUltimoAccesso2_WhenNotNull() {
        User user = new User();
        // 2023-10-05 14:30:00
        LocalDateTime ldt = LocalDateTime.of(2023, 10, 5, 14, 30);
        Timestamp timestamp = Timestamp.valueOf(ldt);
        user.setUltimoAccesso(timestamp);

        assertEquals("05/10/2023 14:30", user.getUltimoAccesso2());
    }
}
