package com.blood.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public final class WebUtil {
    private WebUtil() { }
    public static void noStore(HttpServletResponse response) {
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
    }
    public static void invalidateSessionAndCookie(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();
        Cookie cookie = new Cookie("JSESSIONID", "");
        String contextPath = request.getContextPath();
        cookie.setPath(contextPath == null || contextPath.isEmpty() ? "/" : contextPath);
        cookie.setMaxAge(0);
        cookie.setHttpOnly(true);
        cookie.setSecure(request.isSecure());
        response.addCookie(cookie);
    }
    public static void serverError(HttpServletRequest request,javax.servlet.http.HttpServletResponse response,Exception ex)throws IOException,javax.servlet.ServletException{
        request.getServletContext().log("BloodDonation request failed",ex);
        response.setStatus(500);request.getRequestDispatcher("/error/500.jsp").forward(request,response);
    }
}
