package com.blood.servlet;

import com.blood.dao.LocationDAO;
import com.blood.dao.RequestDAO;
import com.blood.util.Validator;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/requests")
public class RequestListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        try{String group=Validator.clean(req.getParameter("bloodGroup"));if(!group.isEmpty()&&!Validator.bloodGroup(group))group="";Long district=Validator.positiveId(req.getParameter("districtId"));Long upazila=district==null?null:Validator.positiveId(req.getParameter("upazilaId"));int page=1;try{page=Math.max(1,Integer.parseInt(req.getParameter("page")));}catch(Exception ignored){}RequestDAO dao=new RequestDAO();LocationDAO locations=new LocationDAO();req.setAttribute("requests",dao.listOpen(group,district,upazila,page,10));req.setAttribute("totalResults",dao.countOpen(group,district,upazila));req.setAttribute("bloodGroup",group);req.setAttribute("selectedDistrict",district);req.setAttribute("selectedUpazila",upazila);req.setAttribute("page",page);req.setAttribute("districts",locations.districts());req.setAttribute("divisions",locations.divisions());req.getRequestDispatcher("/requests.jsp").forward(req,resp);}catch(Exception ex){WebUtil.serverError(req,resp,ex);}
    }
}
