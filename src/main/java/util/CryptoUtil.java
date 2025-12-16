package util;

import javax.crypto.Cipher;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public class CryptoUtil {
    private static final SecureRandom RNG = new SecureRandom();
    private static final int IV_LEN = 12;       // raccomandato per GCM
    private static final int TAG_BITS = 128;    // 16 byte di tag

    public static SecretKey loadAesKeyFromEnv(String envVar) {
        String b64 = System.getenv(envVar);
        if (b64 == null || b64.isBlank()) {
            throw new IllegalStateException(envVar + " non impostata nell'ambiente");
        }
        byte[] key = Base64.getDecoder().decode(b64);
        if (key.length != 32) throw new IllegalArgumentException("La chiave AES deve essere 32 byte (256 bit)");
        return new SecretKeySpec(key, "AES");
    }

    /** Ritorna [IV(12) || CIPHERTEXT+TAG], salvabile in VARBINARY */
    public static byte[] encryptAesGcm(byte[] plaintext, SecretKey key) {
        try {
            byte[] iv = new byte[IV_LEN];
            RNG.nextBytes(iv);
            Cipher c = Cipher.getInstance("AES/GCM/NoPadding");
            c.init(Cipher.ENCRYPT_MODE, key, new GCMParameterSpec(TAG_BITS, iv));
            byte[] ct = c.doFinal(plaintext);

            byte[] out = new byte[IV_LEN + ct.length];
            System.arraycopy(iv, 0, out, 0, IV_LEN);
            System.arraycopy(ct, 0, out, IV_LEN, ct.length);
            return out;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static byte[] decryptAesGcm(byte[] ivPlusCt, SecretKey key) {
        try {
            byte[] iv = java.util.Arrays.copyOfRange(ivPlusCt, 0, IV_LEN);
            byte[] ct = java.util.Arrays.copyOfRange(ivPlusCt, IV_LEN, ivPlusCt.length);
            Cipher c = Cipher.getInstance("AES/GCM/NoPadding");
            c.init(Cipher.DECRYPT_MODE, key, new GCMParameterSpec(TAG_BITS, iv));
            return c.doFinal(ct);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
