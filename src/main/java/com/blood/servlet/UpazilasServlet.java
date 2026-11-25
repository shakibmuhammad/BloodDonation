package com.blood.servlet;

import com.blood.dao.LocationDAO;
import com.blood.model.Upazila;
import com.blood.util.Validator;
import com.blood.util.WebUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/upazilas")
public class UpazilasServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req,HttpServletResponse resp)throws IOException,ServletException{
        try{Long district=Validator.positiveId(req.getParameter("districtId"));resp.setContentType("application/json;charset=UTF-8");StringBuilder json=new StringBuilder("[");List<Upazila> upazilas=new LocationDAO().upazilas(district);for(int i=0;i<upazilas.size();i++){Upazila upazila=upazilas.get(i);if(i>0)json.append(',');json.append("{\"id\":").append(upazila.getUpazilaId()).append(",\"name\":").append(jsonString(upazila.getName())).append('}');}json.append(']');resp.getWriter().write(json.toString());}catch(Exception ex){WebUtil.serverError(req,resp,ex);}
    }
    private String jsonString(String value){StringBuilder out=new StringBuilder("\"");for(int i=0;i<value.length();i++){char ch=value.charAt(i);switch(ch){case '"':out.append("\\\"");break;case '\\':out.append("\\\\");break;case '\b':out.append("\\b");break;case '\f':out.append("\\f");break;case '\n':out.append("\\n");break;case '\r':out.append("\\r");break;case '\t':out.append("\\t");break;default:if(ch<0x20)out.append(String.format("\\u%04x",(int)ch));else out.append(ch);}}return out.append('"').toString();}
}
