package com.blood.util;

import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public final class WebUtil {
    private WebUtil() { }
    public static void serverError(HttpServletRequest request,javax.servlet.http.HttpServletResponse response,Exception ex)throws IOException,javax.servlet.ServletException{
        request.getServletContext().log("BloodDonation request failed",ex);
        response.setStatus(500);request.getRequestDispatcher("/error/500.jsp").forward(request,response);
    }
}
