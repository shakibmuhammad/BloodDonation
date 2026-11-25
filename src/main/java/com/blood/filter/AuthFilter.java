package com.blood.filter;

import com.blood.util.I18n;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class AuthFilter implements Filter {
    public void init(FilterConfig config) { }

    public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)throws IOException,ServletException{
        HttpServletRequest http=(HttpServletRequest)request;
        String path=http.getServletPath();
        boolean requestForm="/request".equals(path)||"/request-blood.jsp".equals(path);
        HttpSession session=http.getSession(false);
        boolean donorLoggedIn=session!=null&&session.getAttribute("donorId")!=null;
        boolean adminLoggedIn=session!=null&&session.getAttribute("adminId")!=null;
        boolean allowed=requestForm?(donorLoggedIn||adminLoggedIn):donorLoggedIn;
        if(!allowed){
            I18n.locale(http);
            String returnPath="/request-blood.jsp".equals(path)?"/request":http.getRequestURI().substring(http.getContextPath().length());
            String query=http.getQueryString();
            if(query!=null&&!query.isEmpty())returnPath+="?"+query;
            String target=http.getContextPath()+"/login?returnTo="+URLEncoder.encode(returnPath,StandardCharsets.UTF_8);
            ((HttpServletResponse)response).sendRedirect(target);
            return;
        }
        chain.doFilter(request,response);
    }

    public void destroy() { }
}
