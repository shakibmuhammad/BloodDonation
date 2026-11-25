package com.blood.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Locale;
import java.util.ResourceBundle;

public final class I18n {
    private static final String SESSION_KEY = "bloodlinkLocale";

    private I18n() { }

    public static Locale locale(HttpServletRequest request) {
        String requested = request.getParameter("lang");
        HttpSession session = request.getSession(false);
        if ("en".equalsIgnoreCase(requested) || "bn".equalsIgnoreCase(requested)) {
            if (session == null) session = request.getSession(true);
            session.setAttribute(SESSION_KEY, requested.toLowerCase(Locale.ROOT));
        }
        Object stored = session == null ? null : session.getAttribute(SESSION_KEY);
        String language = stored instanceof String ? (String) stored : "en";
        if (!"en".equals(language) && !"bn".equals(language)) language = "en";
        return Locale.forLanguageTag(language);
    }

    public static String message(HttpServletRequest request, String key) {
        Locale locale = locale(request);
        return ResourceBundle.getBundle("i18n.messages", locale).getString(key);
    }
}
