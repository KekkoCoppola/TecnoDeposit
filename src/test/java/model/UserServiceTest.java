package model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import java.sql.Connection;
import java.sql.SQLException;
import static org.junit.jupiter.api.Assertions.*;

class UserServiceTest {

    @Test
    void testVerifyOtp_Correct() throws SQLException {
        boolean result = UserService.verifyOtp("a3D!9fLk7@pQ4zV6m#Y1dR8wK$eJ0tN3cX7zT1wF5hR8uP2sL0vM9gB6dQ3yC4", null);
        assertTrue(result);
    }

    @Test
    void testVerifyOtp_Incorrect() throws SQLException {
        boolean result = UserService.verifyOtp("wrong_otp", null);
        assertFalse(result);
    }
}
