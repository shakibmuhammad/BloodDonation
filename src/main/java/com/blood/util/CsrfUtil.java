package com.blood.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public final class CsrfUtil {
    public static final String SESSION_KEY = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();
    private CsrfUtil() { }
    public static String token(HttpSession session) {
        String value = (String) session.getAttribute(SESSION_KEY);
        if (value == null) { byte[] bytes = new byte[32]; RANDOM.nextBytes(bytes); value = Base64.getUrlEncoder().withoutPadding().encodeToString(bytes); session.setAttribute(SESSION_KEY, value); }
        return value;
    }
    public static boolean valid(HttpServletRequest request) {
        Object expected = request.getSession(false) == null ? null : request.getSession(false).getAttribute(SESSION_KEY);
        String submitted = request.getParameter("csrfToken");
        return expected instanceof String && submitted != null && java.security.MessageDigest.isEqual(((String) expected).getBytes(java.nio.charset.StandardCharsets.UTF_8), submitted.getBytes(java.nio.charset.StandardCharsets.UTF_8));
    }
}
