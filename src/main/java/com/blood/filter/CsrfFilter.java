package com.blood.filter;

import com.blood.util.CsrfUtil;
import com.blood.util.WebUtil;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

public class CsrfFilter implements Filter {
    public void init(FilterConfig config) { }
    public void doFilter(ServletRequest request,ServletResponse response,FilterChain chain)throws IOException,ServletException{
        HttpServletRequest http=(HttpServletRequest)request;
        if("POST".equalsIgnoreCase(http.getMethod())&&!CsrfUtil.valid(http)){
            HttpServletResponse httpResponse=(HttpServletResponse)response;
            WebUtil.noStore(httpResponse);
            String path=http.getServletPath();
            if("/login".equals(path)||"/admin/login".equals(path)){
                String target=http.getContextPath()+path+"?sessionExpired=1";
                String returnTo=http.getParameter("returnTo");
                if("/login".equals(path)&&returnTo!=null&&!returnTo.isEmpty())target+="&returnTo="+URLEncoder.encode(returnTo,StandardCharsets.UTF_8.name());
                httpResponse.sendRedirect(target);
            }else{
                httpResponse.sendError(403,"Invalid or expired form token. Please reload the page and try again.");
            }
            return;
        }
        chain.doFilter(request,response);
    }
    public void destroy() { }
}
