package com.blood.servlet;

import com.blood.dao.DonorDAO;
import com.blood.dao.LocationDAO;
import com.blood.dao.RequestDAO;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/index")
public class HomeServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws ServletException,IOException{
        try {
            DonorDAO donors = new DonorDAO();
            RequestDAO requests = new RequestDAO();
            LocationDAO locations = new LocationDAO();
            req.setAttribute("approvedDonors", donors.countStatus("ACTIVE"));
            req.setAttribute("openRequests", requests.countStatus("OPEN"));
            req.setAttribute("latestRequests", requests.latestOpen(4));
            req.setAttribute("districts", locations.districts());
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } catch (Exception ex) {
            WebUtil.serverError(req, resp, ex);
        }
    }
}
