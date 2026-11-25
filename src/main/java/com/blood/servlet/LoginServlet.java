package com.blood.servlet;

import com.blood.dao.AdminDAO;
import com.blood.dao.DonorDAO;
import com.blood.model.Admin;
import com.blood.model.Donor;
import com.blood.util.I18n;
import com.blood.util.Validator;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        req.getRequestDispatcher("/login.jsp").forward(req,resp);
    }

    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        String identity=Validator.clean(req.getParameter("identity"));
        String password=req.getParameter("password");
        String returnTo=safeReturnPath(req.getParameter("returnTo"));
        try{
            if(identity.isEmpty()||password==null){
                req.setAttribute("error",I18n.message(req,"login.failed"));
                doGet(req,resp);
                return;
            }
            Donor donor=new DonorDAO().authenticate(identity,password);
            if(donor!=null){
                if("PENDING".equals(donor.getStatus())){
                    req.setAttribute("error",I18n.message(req,"login.pendingApproval"));
                    doGet(req,resp);
                    return;
                }
                HttpSession old=req.getSession(false);
                if(old!=null)old.invalidate();
                HttpSession session=req.getSession(true);
                session.setAttribute("donorId",donor.getDonorId());
                session.setAttribute("donorName",donor.getFullName());
                resp.sendRedirect(req.getContextPath()+(returnTo==null?"/user/dashboard":returnTo));
                return;
            }

            Admin admin=new AdminDAO().authenticate(identity,password);
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
            resp.sendRedirect(req.getContextPath()+(returnTo==null?"/admin/dashboard":returnTo));
        }catch(Exception ex){
            WebUtil.serverError(req,resp,ex);
        }
    }

    private String safeReturnPath(String value){
        if(value==null||value.isEmpty()||!value.startsWith("/")||value.startsWith("//")||value.indexOf('\\')>=0)return null;
        for(int i=0;i<value.length();i++){
            char ch=value.charAt(i);
            if(ch<0x20||ch==0x7f)return null;
        }
        try{
            URI uri=new URI(value);
            String path=uri.getRawPath();
            if(uri.getScheme()!=null||uri.getRawAuthority()!=null||path==null||!path.startsWith("/")||path.startsWith("//"))return null;
            return value;
        }catch(URISyntaxException ex){
            return null;
        }
    }
}
