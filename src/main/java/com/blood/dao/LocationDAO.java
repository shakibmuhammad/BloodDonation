package com.blood.dao;

import com.blood.model.District;
import com.blood.model.Division;
import com.blood.model.Upazila;
import com.blood.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class LocationDAO {
    public long countDivisions() throws SQLException { return countRows("divisions"); }
    public long countDistricts() throws SQLException { return countRows("districts"); }
    public long countUpazilas() throws SQLException { return countRows("upazilas"); }

    private long countRows(String table) throws SQLException {
        if(!"divisions".equals(table)&&!"districts".equals(table)&&!"upazilas".equals(table)){
            throw new IllegalArgumentException("Unsupported location table");
        }
        try(Connection c=DBConnection.getConnection();
            PreparedStatement ps=c.prepareStatement("SELECT COUNT(*) FROM "+table);
            ResultSet rs=ps.executeQuery()){
            rs.next();
            return rs.getLong(1);
        }
    }

    public List<Division> divisions() throws SQLException {
        List<Division> out=new ArrayList<Division>();
        try(Connection c=DBConnection.getConnection();
            PreparedStatement ps=c.prepareStatement("SELECT division_id,name FROM divisions ORDER BY name");
            ResultSet rs=ps.executeQuery()){
            while(rs.next()){
                Division division=new Division();
                division.setDivisionId(rs.getLong("division_id"));
                division.setName(rs.getString("name"));
                out.add(division);
            }
        }
        return out;
    }

    public Division findDivision(long id) throws SQLException {
        try(Connection c=DBConnection.getConnection();
            PreparedStatement ps=c.prepareStatement("SELECT division_id,name FROM divisions WHERE division_id=?")){
            ps.setLong(1,id);
            try(ResultSet rs=ps.executeQuery()){
                if(!rs.next())return null;
                Division division=new Division();
                division.setDivisionId(rs.getLong("division_id"));
                division.setName(rs.getString("name"));
                return division;
            }
        }
    }

    public List<District> districts() throws SQLException {
        List<District> out=new ArrayList<District>();
        String sql="SELECT d.district_id,d.name,d.division_id,v.name division FROM districts d JOIN divisions v ON v.division_id=d.division_id ORDER BY d.name";
        try(Connection c=DBConnection.getConnection();
            PreparedStatement ps=c.prepareStatement(sql);
            ResultSet rs=ps.executeQuery()){
            while(rs.next()){
                District district=new District();
                district.setDistrictId(rs.getLong("district_id"));
                district.setName(rs.getString("name"));
                district.setDivisionId(rs.getLong("division_id"));
                district.setDivision(rs.getString("division"));
                out.add(district);
            }
        }
        return out;
    }

    public District findDistrict(long id) throws SQLException {
        String sql="SELECT d.district_id,d.name,d.division_id,v.name division FROM districts d JOIN divisions v ON v.division_id=d.division_id WHERE d.district_id=?";
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
            ps.setLong(1,id);
            try(ResultSet rs=ps.executeQuery()){
                if(!rs.next())return null;
                District district=new District();
                district.setDistrictId(rs.getLong("district_id"));
                district.setName(rs.getString("name"));
                district.setDivisionId(rs.getLong("division_id"));
                district.setDivision(rs.getString("division"));
                return district;
            }
        }
    }

    public List<Upazila> upazilas(Long districtId) throws SQLException {
        List<Upazila> out=new ArrayList<Upazila>();
        String sql="SELECT u.upazila_id,u.district_id,u.name,d.name district_name FROM upazilas u JOIN districts d ON d.district_id=u.district_id"
                +(districtId==null?"":" WHERE u.district_id=?")+" ORDER BY d.name,u.name";
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
            if(districtId!=null)ps.setLong(1,districtId);
            try(ResultSet rs=ps.executeQuery()){
                while(rs.next()){
                    Upazila upazila=new Upazila();
                    upazila.setUpazilaId(rs.getLong("upazila_id"));
                    upazila.setDistrictId(rs.getLong("district_id"));
                    upazila.setName(rs.getString("name"));
                    upazila.setDistrictName(rs.getString("district_name"));
                    out.add(upazila);
                }
            }
        }
        return out;
    }

    public Upazila findUpazila(long id) throws SQLException {
        String sql="SELECT u.upazila_id,u.district_id,u.name,d.name district_name FROM upazilas u JOIN districts d ON d.district_id=u.district_id WHERE u.upazila_id=?";
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
            ps.setLong(1,id);
            try(ResultSet rs=ps.executeQuery()){
                if(!rs.next())return null;
                Upazila upazila=new Upazila();
                upazila.setUpazilaId(rs.getLong("upazila_id"));
                upazila.setDistrictId(rs.getLong("district_id"));
                upazila.setName(rs.getString("name"));
                upazila.setDistrictName(rs.getString("district_name"));
                return upazila;
            }
        }
    }

    public void addDivision(String name) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("INSERT INTO divisions(name) VALUES(?)")){
            ps.setString(1,name);
            ps.executeUpdate();
        }
    }

    public void updateDivision(long id,String name) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("UPDATE divisions SET name=? WHERE division_id=?")){
            ps.setString(1,name);
            ps.setLong(2,id);
            if(ps.executeUpdate()==0)throw new SQLException("Division not found");
        }
    }

    public void deleteDivision(long id) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("DELETE FROM divisions WHERE division_id=?")){
            ps.setLong(1,id);
            ps.executeUpdate();
        }
    }

    public void addDistrict(String name,long divisionId) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("INSERT INTO districts(name,division_id) VALUES(?,?)")){
            ps.setString(1,name);
            ps.setLong(2,divisionId);
            ps.executeUpdate();
        }
    }

    public void updateDistrict(long id,String name,long divisionId) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("UPDATE districts SET name=?,division_id=? WHERE district_id=?")){
            ps.setString(1,name);
            ps.setLong(2,divisionId);
            ps.setLong(3,id);
            if(ps.executeUpdate()==0)throw new SQLException("District not found");
        }
    }

    public boolean districtExists(long districtId) {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("SELECT 1 FROM districts WHERE district_id=?")){
            ps.setLong(1,districtId);
            try(ResultSet rs=ps.executeQuery()){return rs.next();}
        }catch(SQLException ex){
            return false;
        }
    }

    public boolean districtExistsOrThrow(long districtId) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("SELECT 1 FROM districts WHERE district_id=?")){
            ps.setLong(1,districtId);
            try(ResultSet rs=ps.executeQuery()){return rs.next();}
        }
    }

    public void addUpazila(long districtId,String name) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("INSERT INTO upazilas(district_id,name) VALUES(?,?)")){
            ps.setLong(1,districtId);
            ps.setString(2,name);
            ps.executeUpdate();
        }
    }

    public void updateUpazila(long id,long districtId,String name) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("UPDATE upazilas SET district_id=?,name=? WHERE upazila_id=?")){
            ps.setLong(1,districtId);
            ps.setString(2,name);
            ps.setLong(3,id);
            if(ps.executeUpdate()==0)throw new SQLException("Upazila not found");
        }
    }

    public boolean upazilaBelongsTo(long upazilaId,long districtId) {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("SELECT 1 FROM upazilas WHERE upazila_id=? AND district_id=?")){
            ps.setLong(1,upazilaId);
            ps.setLong(2,districtId);
            try(ResultSet rs=ps.executeQuery()){return rs.next();}
        }catch(SQLException ex){
            return false;
        }
    }

    public boolean upazilaBelongsToOrThrow(long upazilaId,long districtId) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("SELECT 1 FROM upazilas WHERE upazila_id=? AND district_id=?")){
            ps.setLong(1,upazilaId);
            ps.setLong(2,districtId);
            try(ResultSet rs=ps.executeQuery()){return rs.next();}
        }
    }

    public void deleteUpazila(long id) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("DELETE FROM upazilas WHERE upazila_id=?")){
            ps.setLong(1,id);
            ps.executeUpdate();
        }
    }

    public void deleteDistrict(long id) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("DELETE FROM districts WHERE district_id=?")){
            ps.setLong(1,id);
            ps.executeUpdate();
        }
    }
}
