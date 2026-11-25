package com.blood.servlet;

import com.blood.dao.DonorDAO;
import com.blood.dao.LocationDAO;
import com.blood.model.Donor;
import com.blood.util.Validator;
import com.blood.util.I18n;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{try{LocationDAO locations=new LocationDAO();req.setAttribute("districts",locations.districts());req.setAttribute("divisions",locations.divisions());req.getRequestDispatcher("/register.jsp").forward(req,resp);}catch(Exception ex){WebUtil.serverError(req,resp,ex);}}
    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        String name=Validator.clean(req.getParameter("fullName")),username=Validator.clean(req.getParameter("username")).toLowerCase(java.util.Locale.ROOT),email=Validator.clean(req.getParameter("email")).toLowerCase(java.util.Locale.ROOT),phone=Validator.clean(req.getParameter("phone")),group=req.getParameter("bloodGroup"),address=Validator.clean(req.getParameter("address")),pw=req.getParameter("password");Long district=Validator.positiveId(req.getParameter("districtId")),upazila=Validator.positiveId(req.getParameter("upazilaId"));
        String error=null;if(!Validator.required(name,120))error=I18n.message(req,"validation.name");else if(!Validator.username(username))error=I18n.message(req,"validation.username");else if(!Validator.email(email))error=I18n.message(req,"validation.email");else if(!Validator.phone(phone))error=I18n.message(req,"validation.phone");else if(!Validator.bloodGroup(group))error=I18n.message(req,"validation.bloodGroup");else if(district==null||!new LocationDAO().districtExists(district))error=I18n.message(req,"validation.district");else if(upazila!=null&&!new LocationDAO().upazilaBelongsTo(upazila,district))error=I18n.message(req,"validation.upazila");else if(address.length()>240)error=I18n.message(req,"validation.addressLength");else if(!Validator.password(pw))error=I18n.message(req,"validation.password");
        if(error!=null){req.setAttribute("error",error);doGet(req,resp);return;}
        try{Donor d=new Donor();d.setFullName(name);d.setUsername(username);d.setEmail(email);d.setPhone(phone.replaceAll("[ -]",""));d.setBloodGroup(group);d.setDistrictId(district);d.setUpazilaId(upazila);d.setAddress(address);new DonorDAO().register(d,pw);resp.sendRedirect(req.getContextPath()+"/login?registered=1");}catch(java.sql.SQLException ex){if(ex.getErrorCode()==1){req.setAttribute("error",I18n.message(req,"validation.duplicateAccount"));doGet(req,resp);}else{WebUtil.serverError(req,resp,ex);}}catch(Exception ex){WebUtil.serverError(req,resp,ex);}
    }
}
