package com.blood.servlet.admin;

import com.blood.dao.DonorDAO;
import com.blood.dao.LocationDAO;
import com.blood.dao.RequestDAO;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        try {
            DonorDAO donors=new DonorDAO();
            RequestDAO requests=new RequestDAO();
            LocationDAO locations=new LocationDAO();
            req.setAttribute("donorCount",donors.countAll());
            req.setAttribute("activeDonorCount",donors.countStatus("ACTIVE"));
            req.setAttribute("availableDonorCount",donors.countAvailable());
            req.setAttribute("pendingDonorCount",donors.countStatus("PENDING"));
            req.setAttribute("blockedDonorCount",donors.countStatus("BLOCKED"));
            req.setAttribute("openRequestCount",requests.countStatus("OPEN"));
            req.setAttribute("fulfilledRequestCount",requests.countStatus("FULFILLED"));
            req.setAttribute("closedRequestCount",requests.countStatus("CLOSED"));
            req.setAttribute("requestCount",requests.countAll());
            req.setAttribute("divisionCount",locations.countDivisions());
            req.setAttribute("districtCount",locations.countDistricts());
            req.setAttribute("upazilaCount",locations.countUpazilas());
            req.setAttribute("latestDonors",donors.listAdmin("",1,5));
            req.setAttribute("latestRequests",requests.listAdmin("",1,5));
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req,resp);
        } catch(Exception ex) {
            WebUtil.serverError(req,resp,ex);
        }
    }
}
