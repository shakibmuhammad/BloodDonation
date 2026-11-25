package com.blood.filter;

import com.blood.util.CsrfUtil;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class EncodingFilter implements Filter {
    public void init(FilterConfig config) { }
    public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)throws IOException,ServletException{
        request.setCharacterEncoding("UTF-8");response.setCharacterEncoding("UTF-8");
        HttpServletRequest http=(HttpServletRequest)request;
        request.setAttribute("csrfToken",CsrfUtil.token(http.getSession(true)));
        chain.doFilter(request,response);
    }
    public void destroy() { }
}
