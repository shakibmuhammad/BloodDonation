package com.blood.filter;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AdminFilter implements Filter {
    public void init(FilterConfig config) { }
    public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)throws IOException,ServletException{
        HttpServletRequest http=(HttpServletRequest)request;String path=http.getServletPath();
        if(path.equals("/admin/login")||path.equals("/admin/login.jsp")){chain.doFilter(request,response);return;}
        if(http.getSession(false)==null||http.getSession(false).getAttribute("adminId")==null){((HttpServletResponse)response).sendRedirect(http.getContextPath()+"/admin/login");return;}
        chain.doFilter(request,response);
    }
    public void destroy() { }
}
