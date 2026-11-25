package com.blood.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpSession;
import java.util.Locale;
import java.util.ResourceBundle;

public final class I18n {
    private static final String SESSION_KEY = "bloodlinkLocale";

    private I18n() { }

    public static Locale locale(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        String language = supportedLanguage(request.getParameter("lang"));
        if (language == null && session != null) {
            Object stored = session.getAttribute(SESSION_KEY);
            if (stored instanceof String) language = supportedLanguage((String) stored);
        }
        if (language == null && request.getCookies() != null) {
            for (Cookie cookie : request.getCookies()) {
                if (SESSION_KEY.equals(cookie.getName())) {
                    language = supportedLanguage(cookie.getValue());
                    if (language != null) break;
                }
            }
        }
        if (language == null) language = "en";
        if (session == null) session = request.getSession(true);
        session.setAttribute(SESSION_KEY, language);
        return Locale.forLanguageTag(language);
    }

    private static String supportedLanguage(String language) {
        if (language == null) return null;
        if ("en".equalsIgnoreCase(language) || "bn".equalsIgnoreCase(language)) {
            return language.toLowerCase(Locale.ROOT);
        }
        return null;
    }

    public static String message(HttpServletRequest request, String key) {
        Locale locale = locale(request);
        return ResourceBundle.getBundle("i18n.messages", locale).getString(key);
    }
}
