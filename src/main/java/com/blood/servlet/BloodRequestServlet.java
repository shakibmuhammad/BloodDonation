package com.blood.servlet;

import com.blood.dao.LocationDAO;
import com.blood.dao.RequestDAO;
import com.blood.model.BloodRequest;
import com.blood.util.Validator;
import com.blood.util.I18n;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;

@WebServlet("/request")
public class BloodRequestServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{try{LocationDAO locations=new LocationDAO();req.setAttribute("districts",locations.districts());req.setAttribute("divisions",locations.divisions());req.getRequestDispatcher("/request-blood.jsp").forward(req,resp);}catch(Exception ex){WebUtil.serverError(req,resp,ex);}}
    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        String name=Validator.clean(req.getParameter("patientName")),group=req.getParameter("bloodGroup"),hospital=Validator.clean(req.getParameter("hospital")),phone=Validator.clean(req.getParameter("contactPhone")),details=Validator.clean(req.getParameter("details"));Long district=Validator.positiveId(req.getParameter("districtId")),upazila=Validator.positiveId(req.getParameter("upazilaId"));Date needed=null;try{needed=Date.valueOf(req.getParameter("neededDate"));}catch(Exception ignored){}
        String error=null;if(!Validator.required(name,120))error=I18n.message(req,"validation.patientName");else if(!Validator.bloodGroup(group))error=I18n.message(req,"validation.bloodGroup");else if(!Validator.required(hospital,180))error=I18n.message(req,"validation.hospital");else if(district==null||!new LocationDAO().districtExists(district))error=I18n.message(req,"validation.district");else if(upazila!=null&&!new LocationDAO().upazilaBelongsTo(upazila,district))error=I18n.message(req,"validation.upazila");else if(!Validator.phone(phone))error=I18n.message(req,"validation.phone");else if(needed==null||needed.toLocalDate().isBefore(LocalDate.now()))error=I18n.message(req,"validation.neededDate");else if(details.length()>1000)error=I18n.message(req,"validation.detailsLength");
        if(error!=null){req.setAttribute("error",error);doGet(req,resp);return;}try{BloodRequest r=new BloodRequest();r.setPatientName(name);r.setBloodGroup(group);r.setHospital(hospital);r.setDistrictId(district);r.setUpazilaId(upazila);r.setContactPhone(phone.replaceAll("[ -]",""));r.setNeededDate(needed);r.setDetails(details);new RequestDAO().create(r);resp.sendRedirect(req.getContextPath()+"/requests?posted=1");}catch(Exception ex){WebUtil.serverError(req,resp,ex);}
    }
}
