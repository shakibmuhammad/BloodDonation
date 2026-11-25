package com.blood.servlet.admin;

import com.blood.dao.LocationDAO;
import com.blood.dao.RequestDAO;
import com.blood.model.BloodRequest;
import com.blood.util.I18n;
import com.blood.util.Validator;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/requests")
public class AdminRequestsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        try {
            String status=Validator.clean(req.getParameter("requestStatus"));
            if(!status.matches("OPEN|FULFILLED|CLOSED"))status="";
            int page;
            try{page=Math.max(1,Integer.parseInt(req.getParameter("page")));}catch(Exception ex){page=1;}
            RequestDAO dao=new RequestDAO();
            long total=status.isEmpty()?dao.countAll():dao.countStatus(status);
            page=Math.min(page,(int)Math.min(Integer.MAX_VALUE,Math.max(1L,(total+14)/15)));
            req.setAttribute("requests",dao.listAdmin(status,page,15));
            req.setAttribute("totalRequests",total);
            req.setAttribute("status",status);
            req.setAttribute("page",page);
            req.setAttribute("districts",new LocationDAO().districts());
            Long editId=Validator.positiveId(req.getParameter("editId"));
            if(editId!=null)req.setAttribute("editRequest",dao.findById(editId));
            req.getRequestDispatcher("/admin/requests.jsp").forward(req,resp);
        } catch(Exception ex) {
            WebUtil.serverError(req,resp,ex);
        }
    }

    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        String action=req.getParameter("action");
        RequestDAO dao=new RequestDAO();
        try {
            if("create".equals(action)||"update".equals(action)){
                BloodRequest request=readRequest(req);
                Long id=Validator.positiveId(req.getParameter("requestId"));
                if("update".equals(action)){
                    if(id==null){resp.sendError(400);return;}
                    request.setRequestId(id);
                }
                String error=validate(req,request);
                if(error!=null){
                    req.setAttribute("error",error);
                    if("update".equals(action))req.setAttribute("editRequest",request);
                    else req.setAttribute("newRequest",request);
                    doGet(req,resp);return;
                }
                if("create".equals(action))dao.create(request);else dao.update(request);
            } else {
                Long id=Validator.positiveId(req.getParameter("requestId"));
                if(id==null){resp.sendError(400);return;}
                if("delete".equals(action))dao.delete(id);
                else if("fulfilled".equals(action))dao.setStatus(id,"FULFILLED");
                else if("closed".equals(action))dao.setStatus(id,"CLOSED");
                else if("reopen".equals(action))dao.setStatus(id,"OPEN");
                else {resp.sendError(400);return;}
            }
            resp.sendRedirect(req.getContextPath()+"/admin/requests?updated=1");
        } catch(Exception ex) {
            WebUtil.serverError(req,resp,ex);
        }
    }

    private BloodRequest readRequest(HttpServletRequest req){
        BloodRequest request=new BloodRequest();
        request.setPatientName(Validator.clean(req.getParameter("patientName")));
        request.setBloodGroup(Validator.clean(req.getParameter("bloodGroup")));
        request.setHospital(Validator.clean(req.getParameter("hospital")));
        request.setContactPhone(Validator.clean(req.getParameter("contactPhone")).replaceAll("[ -]",""));
        request.setDetails(Validator.clean(req.getParameter("details")));
        Long district=Validator.positiveId(req.getParameter("districtId"));
        request.setDistrictId(district==null?0:district);
        request.setUpazilaId(Validator.positiveId(req.getParameter("upazilaId")));
        try{request.setNeededDate(Date.valueOf(Validator.clean(req.getParameter("neededDate"))));}catch(IllegalArgumentException ignored){}
        String status=Validator.clean(req.getParameter("status"));
        request.setStatus(status.matches("OPEN|FULFILLED|CLOSED")?status:"OPEN");
        return request;
    }

    private String validate(HttpServletRequest req,BloodRequest request)throws java.sql.SQLException{
        LocationDAO locations=new LocationDAO();
        if(!Validator.required(request.getPatientName(),120))return I18n.message(req,"validation.patientName");
        if(!Validator.bloodGroup(request.getBloodGroup()))return I18n.message(req,"validation.bloodGroup");
        if(!Validator.required(request.getHospital(),180))return I18n.message(req,"validation.hospital");
        if(request.getDistrictId()<=0||!locations.districtExistsOrThrow(request.getDistrictId()))return I18n.message(req,"validation.district");
        if(request.getUpazilaId()!=null&&!locations.upazilaBelongsToOrThrow(request.getUpazilaId(),request.getDistrictId()))return I18n.message(req,"validation.upazila");
        if(!Validator.phone(request.getContactPhone()))return I18n.message(req,"validation.phone");
        if(request.getNeededDate()==null)return I18n.message(req,"validation.neededDate");
        if("create".equals(req.getParameter("action"))&&request.getNeededDate().toLocalDate().isBefore(java.time.LocalDate.now()))return I18n.message(req,"validation.neededDate");
        if(request.getDetails().length()>1000)return I18n.message(req,"validation.detailsLength");
        if(!"OPEN".equals(request.getStatus())&&!"FULFILLED".equals(request.getStatus())&&!"CLOSED".equals(request.getStatus()))return I18n.message(req,"validation.requestStatus");
        return null;
    }
}
