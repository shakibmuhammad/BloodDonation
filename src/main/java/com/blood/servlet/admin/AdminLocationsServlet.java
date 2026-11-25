package com.blood.servlet.admin;

import com.blood.dao.LocationDAO;
import com.blood.model.District;
import com.blood.model.Division;
import com.blood.model.Upazila;
import com.blood.util.I18n;
import com.blood.util.Validator;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/locations")
public class AdminLocationsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        try {
            LocationDAO dao=new LocationDAO();
            req.setAttribute("divisions",dao.divisions());
            req.setAttribute("districts",dao.districts());
            req.setAttribute("upazilas",dao.upazilas(null));
            Long divisionId=Validator.positiveId(req.getParameter("editDivision"));
            Long districtId=Validator.positiveId(req.getParameter("editDistrict"));
            Long upazilaId=Validator.positiveId(req.getParameter("editUpazila"));
            if(divisionId!=null)req.setAttribute("editDivisionRecord",dao.findDivision(divisionId));
            if(districtId!=null)req.setAttribute("editDistrictRecord",dao.findDistrict(districtId));
            if(upazilaId!=null)req.setAttribute("editUpazilaRecord",dao.findUpazila(upazilaId));
            req.getRequestDispatcher("/admin/locations.jsp").forward(req,resp);
        } catch(Exception ex) {
            WebUtil.serverError(req,resp,ex);
        }
    }

    protected void doPost(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        String action=req.getParameter("action");
        try {
            LocationDAO dao=new LocationDAO();
            if("addDivision".equals(action)||"updateDivision".equals(action)){
                String name=Validator.clean(req.getParameter("name"));
                Long id=Validator.positiveId(req.getParameter("divisionId"));
                if(!Validator.required(name,50)||("updateDivision".equals(action)&&id==null)){
                    req.setAttribute("error",I18n.message(req,"validation.locationName"));
                    preserveEdit(req,action);
                    doGet(req,resp);return;
                }
                if("addDivision".equals(action))dao.addDivision(name);else dao.updateDivision(id,name);
            } else if("addDistrict".equals(action)||"updateDistrict".equals(action)){
                String name=Validator.clean(req.getParameter("name"));
                Long id=Validator.positiveId(req.getParameter("districtId"));
                Long divisionId=Validator.positiveId(req.getParameter("divisionId"));
                if(!Validator.required(name,80)||divisionId==null||("updateDistrict".equals(action)&&id==null)){
                    req.setAttribute("error",I18n.message(req,"validation.locationDetails"));
                    preserveEdit(req,action);
                    doGet(req,resp);return;
                }
                if("addDistrict".equals(action))dao.addDistrict(name,divisionId);else dao.updateDistrict(id,name,divisionId);
            } else if("addUpazila".equals(action)||"updateUpazila".equals(action)){
                String name=Validator.clean(req.getParameter("name"));
                Long id=Validator.positiveId(req.getParameter("upazilaId"));
                Long districtId=Validator.positiveId(req.getParameter("districtId"));
                if(!Validator.required(name,100)||districtId==null||("updateUpazila".equals(action)&&id==null)){
                    req.setAttribute("error",I18n.message(req,"validation.locationSelection"));
                    preserveEdit(req,action);
                    doGet(req,resp);return;
                }
                if("addUpazila".equals(action))dao.addUpazila(districtId,name);else dao.updateUpazila(id,districtId,name);
            } else if("deleteDivision".equals(action)){
                Long id=Validator.positiveId(req.getParameter("divisionId"));
                if(id==null){resp.sendError(400);return;}
                dao.deleteDivision(id);
            } else if("deleteDistrict".equals(action)){
                Long id=Validator.positiveId(req.getParameter("districtId"));
                if(id==null){resp.sendError(400);return;}
                dao.deleteDistrict(id);
            } else if("deleteUpazila".equals(action)){
                Long id=Validator.positiveId(req.getParameter("upazilaId"));
                if(id==null){resp.sendError(400);return;}
                dao.deleteUpazila(id);
            } else {
                resp.sendError(400);return;
            }
            resp.sendRedirect(req.getContextPath()+"/admin/locations?updated=1");
        } catch(java.sql.SQLException ex) {
            if(ex.getErrorCode()!=1&&ex.getErrorCode()!=2291&&ex.getErrorCode()!=2292){WebUtil.serverError(req,resp,ex);return;}
            req.setAttribute("error",I18n.message(req,"validation.duplicateLocation"));
            preserveEdit(req,action);
            doGet(req,resp);
        } catch(Exception ex) {
            WebUtil.serverError(req,resp,ex);
        }
    }

    private void preserveEdit(HttpServletRequest req,String action){
        if("updateDivision".equals(action)){
            Long id=Validator.positiveId(req.getParameter("divisionId"));
            if(id!=null){Division value=new Division();value.setDivisionId(id);value.setName(Validator.clean(req.getParameter("name")));req.setAttribute("editDivisionRecord",value);}
        }else if("updateDistrict".equals(action)){
            Long id=Validator.positiveId(req.getParameter("districtId")),divisionId=Validator.positiveId(req.getParameter("divisionId"));
            if(id!=null&&divisionId!=null){District value=new District();value.setDistrictId(id);value.setDivisionId(divisionId);value.setName(Validator.clean(req.getParameter("name")));req.setAttribute("editDistrictRecord",value);}
        }else if("updateUpazila".equals(action)){
            Long id=Validator.positiveId(req.getParameter("upazilaId")),districtId=Validator.positiveId(req.getParameter("districtId"));
            if(id!=null&&districtId!=null){Upazila value=new Upazila();value.setUpazilaId(id);value.setDistrictId(districtId);value.setName(Validator.clean(req.getParameter("name")));req.setAttribute("editUpazilaRecord",value);}
        }
    }
}
