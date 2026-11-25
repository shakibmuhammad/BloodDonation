package com.blood.servlet.admin;

import com.blood.util.WebUtil;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/logout")
public class AdminLogoutServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws IOException{
        WebUtil.noStore(resp);
        WebUtil.invalidateSessionAndCookie(req,resp);
        resp.sendRedirect(req.getContextPath()+"/admin/login");
    }
}
