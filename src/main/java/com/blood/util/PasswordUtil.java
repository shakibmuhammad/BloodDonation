package com.blood.util;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;

public final class PasswordUtil {
    private static final SecureRandom RANDOM = new SecureRandom();
    private static final char[] HEX = "0123456789abcdef".toCharArray();
    private PasswordUtil() { }
    public static String newSalt() {
        byte[] bytes = new byte[24]; RANDOM.nextBytes(bytes); return toHex(bytes);
    }
    public static String hash(String password, String salt) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            return toHex(digest.digest((salt + password).getBytes(StandardCharsets.UTF_8)));
        } catch (Exception ex) { throw new IllegalStateException("SHA-256 is unavailable", ex); }
    }
    public static boolean verify(String password, String salt, String expectedHash) {
        if (password == null || salt == null || expectedHash == null) return false;
        return MessageDigest.isEqual(hash(password, salt).getBytes(StandardCharsets.US_ASCII), expectedHash.toLowerCase().getBytes(StandardCharsets.US_ASCII));
    }
    private static String toHex(byte[] bytes) {
        char[] out = new char[bytes.length * 2];
        for (int i = 0; i < bytes.length; i++) { out[i * 2] = HEX[(bytes[i] >>> 4) & 15]; out[i * 2 + 1] = HEX[bytes[i] & 15]; }
        return new String(out);
    }
}
