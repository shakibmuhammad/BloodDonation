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
import java.sql.Date;

@WebServlet(urlPatterns={"/user/dashboard","/user/profile","/user/edit-profile"})
public class ProfileServlet extends HttpServlet {
    private long donorId(HttpServletRequest req){return (Long)req.getSession(false).getAttribute("donorId");}
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        try{Donor donor=new DonorDAO().findById(donorId(req));req.setAttribute("donor",donor);
            if("/user/edit-profile".equals(req.getServletPath())){LocationDAO locations=new LocationDAO();req.setAttribute("districts",locations.districts());req.setAttribute("divisions",locations.divisions());if(donor!=null)req.setAttribute("upazilas",locations.upazilas(donor.getDistrictId()));req.getRequestDispatcher("/user/edit-profile.jsp").forward(req,resp);}
            else if("/user/profile".equals(req.getServletPath()))req.getRequestDispatcher("/user/profile.jsp").forward(req,resp);
            else req.getRequestDispatcher("/user/dashboard.jsp").forward(req,resp);
        }catch(Exception ex){WebUtil.serverError(req,resp,ex);}
    }
    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        DonorDAO dao=new DonorDAO();long id=donorId(req);String path=req.getServletPath(),action=req.getParameter("action");
        try{
            if("/user/profile".equals(path)&&"toggleAvailability".equals(action)){Donor d=dao.findById(id);dao.updateAvailability(id,"Y".equals(d.getAvailable())?false:true);resp.sendRedirect(req.getContextPath()+"/user/profile?updated=1");return;}
            if("/user/profile".equals(path)&&"donation".equals(action)){Date date;try{date=Date.valueOf(req.getParameter("lastDonation"));}catch(Exception ex){req.setAttribute("error",I18n.message(req,"validation.donationDate"));doGet(req,resp);return;}if(date.after(new Date(System.currentTimeMillis()))){req.setAttribute("error",I18n.message(req,"validation.futureDonation"));doGet(req,resp);return;}dao.updateLastDonation(id,date);resp.sendRedirect(req.getContextPath()+"/user/profile?updated=1");return;}
            if("/user/edit-profile".equals(path)){String name=Validator.clean(req.getParameter("fullName")),phone=Validator.clean(req.getParameter("phone")),group=req.getParameter("bloodGroup"),address=Validator.clean(req.getParameter("address"));Long district=Validator.positiveId(req.getParameter("districtId")),upazila=Validator.positiveId(req.getParameter("upazilaId"));String error=null;
                if(!Validator.required(name,120))error=I18n.message(req,"validation.name");else if(!Validator.phone(phone))error=I18n.message(req,"validation.phone");else if(!Validator.bloodGroup(group))error=I18n.message(req,"validation.bloodGroup");else if(district==null||!new LocationDAO().districtExists(district))error=I18n.message(req,"validation.district");else if(upazila!=null&&!new LocationDAO().upazilaBelongsTo(upazila,district))error=I18n.message(req,"validation.upazila");else if(address.length()>240)error=I18n.message(req,"validation.addressLength");
                if(error!=null){req.setAttribute("error",error);doGet(req,resp);return;}Donor d=new Donor();d.setDonorId(id);d.setFullName(name);d.setPhone(phone.replaceAll("[ -]",""));d.setBloodGroup(group);d.setDistrictId(district);d.setUpazilaId(upazila);d.setAddress(address);dao.updateProfile(d);req.getSession().setAttribute("donorName",name);resp.sendRedirect(req.getContextPath()+"/user/profile?updated=1");return;
            }
            resp.sendError(400);
        }catch(java.sql.SQLException ex){req.setAttribute("error",I18n.message(req,"validation.duplicatePhone"));doGet(req,resp);}catch(Exception ex){WebUtil.serverError(req,resp,ex);}
    }
}
