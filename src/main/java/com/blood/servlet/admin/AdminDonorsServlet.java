package com.blood.servlet.admin;

import com.blood.dao.DonorDAO;
import com.blood.dao.LocationDAO;
import com.blood.model.Donor;
import com.blood.util.I18n;
import com.blood.util.Validator;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/donors")
public class AdminDonorsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        try {
            String status=Validator.clean(req.getParameter("status"));
            if(!status.matches("PENDING|ACTIVE|BLOCKED"))status="";
            int page=page(req);
            DonorDAO dao=new DonorDAO();
            long total=status.isEmpty()?dao.countAll():dao.countStatus(status);
            page=Math.min(page,(int)Math.min(Integer.MAX_VALUE,Math.max(1L,(total+14)/15)));
            req.setAttribute("donors",dao.listAdmin(status,page,15));
            req.setAttribute("totalDonors",total);
            req.setAttribute("status",status);
            req.setAttribute("page",page);
            req.setAttribute("districts",new LocationDAO().districts());
            Long editId=Validator.positiveId(req.getParameter("editId"));
            if(editId!=null)req.setAttribute("editDonor",dao.findById(editId));
            req.getRequestDispatcher("/admin/donors.jsp").forward(req,resp);
        } catch(Exception ex) {
            WebUtil.serverError(req,resp,ex);
        }
    }

    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        String action=req.getParameter("action");
        DonorDAO dao=new DonorDAO();
        try {
            if("create".equals(action)){
                Donor donor=readDonor(req);
                String username=Validator.clean(req.getParameter("username")).toLowerCase(java.util.Locale.ROOT);
                String password=req.getParameter("password");
                donor.setUsername(username);
                String error=validate(req,donor);
                if(error==null&&!Validator.password(password))error=I18n.message(req,"validation.password");
                if(error!=null){req.setAttribute("error",error);req.setAttribute("newDonor",donor);doGet(req,resp);return;}
                dao.register(donor,password);
            } else {
                Long id=Validator.positiveId(req.getParameter("donorId"));
                if(id==null){resp.sendError(400);return;}
                if("update".equals(action)){
                    Donor donor=readDonor(req);donor.setDonorId(id);
                    String error=validate(req,donor);
                    if(error!=null){req.setAttribute("error",error);req.setAttribute("editDonor",donor);doGet(req,resp);return;}
                    dao.updateAdmin(donor);
                } else if("approve".equals(action))dao.setStatus(id,"ACTIVE");
                else if("block".equals(action))dao.setStatus(id,"BLOCKED");
                else if("delete".equals(action))dao.delete(id);
                else {resp.sendError(400);return;}
            }
            resp.sendRedirect(req.getContextPath()+"/admin/donors?updated=1");
        } catch(java.sql.SQLException ex) {
            if(ex.getErrorCode()!=1){WebUtil.serverError(req,resp,ex);return;}
            req.setAttribute("error",I18n.message(req,"validation.duplicateAccount"));
            if("update".equals(action)){Long id=Validator.positiveId(req.getParameter("donorId"));if(id!=null){Donor donor=readDonor(req);donor.setDonorId(id);req.setAttribute("editDonor",donor);}}
            else if("create".equals(action)){Donor donor=readDonor(req);donor.setUsername(Validator.clean(req.getParameter("username")));req.setAttribute("newDonor",donor);}
            doGet(req,resp);
        } catch(Exception ex) {
            WebUtil.serverError(req,resp,ex);
        }
    }

    private Donor readDonor(HttpServletRequest req){
        Donor donor=new Donor();
        donor.setFullName(Validator.clean(req.getParameter("fullName")));
        donor.setUsername(Validator.clean(req.getParameter("username")).toLowerCase(java.util.Locale.ROOT));
        donor.setEmail(Validator.clean(req.getParameter("email")).toLowerCase(java.util.Locale.ROOT));
        donor.setPhone(Validator.clean(req.getParameter("phone")).replaceAll("[ -]",""));
        donor.setBloodGroup(Validator.clean(req.getParameter("bloodGroup")));
        donor.setAddress(Validator.clean(req.getParameter("address")));
        Long district=Validator.positiveId(req.getParameter("districtId"));
        donor.setDistrictId(district==null?0:district);
        donor.setUpazilaId(Validator.positiveId(req.getParameter("upazilaId")));
        String available=Validator.clean(req.getParameter("available"));
        donor.setAvailable("Y".equals(available)?"Y":"N");
        donor.setStatus(Validator.clean(req.getParameter("donorStatus")));
        String lastDonation=Validator.clean(req.getParameter("lastDonation"));
        if(!lastDonation.isEmpty())try{donor.setLastDonation(Date.valueOf(lastDonation));}catch(IllegalArgumentException ignored){}
        return donor;
    }

    private String validate(HttpServletRequest req,Donor donor)throws java.sql.SQLException{
        LocationDAO locations=new LocationDAO();
        if(!Validator.required(donor.getFullName(),120))return I18n.message(req,"validation.name");
        if(!Validator.username(donor.getUsername()))return I18n.message(req,"validation.username");
        if(!Validator.email(donor.getEmail()))return I18n.message(req,"validation.email");
        if(!Validator.phone(donor.getPhone()))return I18n.message(req,"validation.phone");
        if(!Validator.bloodGroup(donor.getBloodGroup()))return I18n.message(req,"validation.bloodGroup");
        if(donor.getDistrictId()<=0||!locations.districtExistsOrThrow(donor.getDistrictId()))return I18n.message(req,"validation.district");
        if(donor.getUpazilaId()!=null&&!locations.upazilaBelongsToOrThrow(donor.getUpazilaId(),donor.getDistrictId()))return I18n.message(req,"validation.upazila");
        if(donor.getAddress().length()>240)return I18n.message(req,"validation.addressLength");
        String donationDate=Validator.clean(req.getParameter("lastDonation"));
        if(!donationDate.isEmpty()&&donor.getLastDonation()==null)return I18n.message(req,"validation.donationDate");
        if(donor.getLastDonation()!=null&&donor.getLastDonation().after(new Date(System.currentTimeMillis())))return I18n.message(req,"validation.futureDonation");
        if(!"Y".equals(donor.getAvailable())&&!"N".equals(donor.getAvailable()))return I18n.message(req,"validation.availability");
        if(!"PENDING".equals(donor.getStatus())&&!"ACTIVE".equals(donor.getStatus())&&!"BLOCKED".equals(donor.getStatus()))return I18n.message(req,"validation.donorStatus");
        return null;
    }

    private int page(HttpServletRequest req){
        try{return Math.max(1,Integer.parseInt(req.getParameter("page")));}catch(Exception ex){return 1;}
    }
}
