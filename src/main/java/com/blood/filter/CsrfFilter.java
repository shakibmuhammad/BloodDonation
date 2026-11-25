package com.blood.filter;

import com.blood.util.CsrfUtil;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CsrfFilter implements Filter {
    public void init(FilterConfig config) { }
    public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)throws IOException,ServletException{
        HttpServletRequest http=(HttpServletRequest)request;
        if("POST".equalsIgnoreCase(http.getMethod())&&!CsrfUtil.valid(http)){((HttpServletResponse)response).sendError(403,"Invalid or expired form token. Please reload the page and try again.");return;}
        chain.doFilter(request,response);
    }
    public void destroy() { }
}
