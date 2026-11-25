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

@WebServlet("/search")
public class SearchDonorServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        try{String group=Validator.clean(req.getParameter("bloodGroup"));if(!group.isEmpty()&&!Validator.bloodGroup(group)){req.setAttribute("error",I18n.message(req,"validation.bloodGroup"));group="";}String ds=req.getParameter("districtId"),as=req.getParameter("upazilaId");Long district=Validator.positiveId(ds),upazila=Validator.positiveId(as);int page=1;try{page=Math.max(1,Integer.parseInt(req.getParameter("page")));}catch(Exception ignored){}
            DonorDAO dao=new DonorDAO();LocationDAO locations=new LocationDAO();req.setAttribute("donors",dao.search(group,district,upazila,page,12));req.setAttribute("totalResults",dao.countSearch(group,district,upazila));req.setAttribute("page",page);req.setAttribute("bloodGroup",group);req.setAttribute("selectedDistrict",district);req.setAttribute("selectedUpazila",upazila);req.setAttribute("districts",locations.districts());req.setAttribute("divisions",locations.divisions());if(district!=null)req.setAttribute("upazilas",locations.upazilas(district));
            HttpSession session=req.getSession(false);if(session!=null&&session.getAttribute("donorId") instanceof Long){Donor current=dao.findById((Long)session.getAttribute("donorId"));req.setAttribute("canViewPhones",current!=null&&"ACTIVE".equals(current.getStatus()));}req.getRequestDispatcher("/search-result.jsp").forward(req,resp);
        }catch(Exception ex){WebUtil.serverError(req,resp,ex);}
    }
}
