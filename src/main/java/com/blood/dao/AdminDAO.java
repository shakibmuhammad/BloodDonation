package com.blood.dao;

import com.blood.model.Admin;
import com.blood.util.DBConnection;
import com.blood.util.PasswordUtil;
import java.sql.*;

public class AdminDAO {
    public Admin authenticate(String identity,String password)throws SQLException{
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("SELECT admin_id,username,password_hash,password_salt FROM admins WHERE LOWER(username)=LOWER(?) OR LOWER(email)=LOWER(?)")){ps.setString(1,identity);ps.setString(2,identity);try(ResultSet rs=ps.executeQuery()){if(!rs.next()||!PasswordUtil.verify(password,rs.getString("password_salt"),rs.getString("password_hash")))return null;Admin a=new Admin();a.setAdminId(rs.getLong("admin_id"));a.setUsername(rs.getString("username"));return a;}}
    }
}
