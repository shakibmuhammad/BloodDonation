package com.blood.servlet.admin;

import com.blood.dao.AdminDAO;
import com.blood.model.Admin;
import com.blood.util.I18n;
import com.blood.util.CsrfUtil;
import com.blood.util.Validator;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/login")
public class AdminLoginServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        WebUtil.noStore(resp);
        req.setAttribute("csrfToken",CsrfUtil.rotateToken(req.getSession(true)));
        req.getRequestDispatcher("/admin/login.jsp").forward(req,resp);
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        WebUtil.noStore(resp);
        try{
            Admin admin=new AdminDAO().authenticate(Validator.clean(req.getParameter("identity")),req.getParameter("password"));
            if(admin==null){
                req.setAttribute("error",I18n.message(req,"login.failed"));
                doGet(req,resp);
                return;
            }
            HttpSession old=req.getSession(false);
            if(old!=null)old.invalidate();
            HttpSession session=req.getSession(true);
            session.setAttribute("adminId",admin.getAdminId());
            session.setAttribute("adminName",admin.getUsername());
            resp.sendRedirect(req.getContextPath()+"/admin/dashboard");
        }catch(Exception ex){
            WebUtil.serverError(req,resp,ex);
        }
    }
}
