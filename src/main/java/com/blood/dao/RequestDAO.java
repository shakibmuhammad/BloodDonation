package com.blood.dao;

import com.blood.model.BloodRequest;
import com.blood.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RequestDAO {
    private static final String FIELDS="r.request_id,r.patient_name,r.blood_group,r.hospital,r.district_id,r.upazila_id,r.contact_phone,r.needed_date,r.details,r.status,r.created_at,d.name district_name,a.name upazila_name";
    private static final String JOINS=" FROM blood_requests r JOIN districts d ON d.district_id=r.district_id LEFT JOIN upazilas a ON a.upazila_id=r.upazila_id ";
    public void create(BloodRequest r)throws SQLException{
        String sql="INSERT INTO blood_requests(patient_name,blood_group,hospital,district_id,upazila_id,contact_phone,needed_date,details,status) VALUES(?,?,?,?,?,?,?,?,?)";
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){ps.setString(1,r.getPatientName());ps.setString(2,r.getBloodGroup());ps.setString(3,r.getHospital());ps.setLong(4,r.getDistrictId());setNullableLong(ps,5,r.getUpazilaId());ps.setString(6,r.getContactPhone());ps.setDate(7,r.getNeededDate());ps.setString(8,r.getDetails());ps.setString(9,r.getStatus()==null?"OPEN":r.getStatus());ps.executeUpdate();}
    }
    public List<BloodRequest> listOpen(String group,Long district,int page,int size)throws SQLException{
        StringBuilder where=new StringBuilder(" WHERE r.status='OPEN'");List<Object> p=new ArrayList<Object>();if(group!=null&&!group.isEmpty()){where.append(" AND r.blood_group=?");p.add(group);}if(district!=null){where.append(" AND r.district_id=?");p.add(district);}
        return page("SELECT "+FIELDS+JOINS+where+" ORDER BY r.needed_date ASC,r.created_at DESC",p,page,size);
    }
    public List<BloodRequest> listOpen(String group,Long district,Long upazila,int page,int size)throws SQLException{
        StringBuilder where=new StringBuilder(" WHERE r.status='OPEN'");List<Object> p=new ArrayList<Object>();if(group!=null&&!group.isEmpty()){where.append(" AND r.blood_group=?");p.add(group);}if(district!=null){where.append(" AND r.district_id=?");p.add(district);}if(upazila!=null){where.append(" AND r.upazila_id=?");p.add(upazila);}
        return page("SELECT "+FIELDS+JOINS+where+" ORDER BY r.needed_date ASC,r.created_at DESC",p,page,size);
    }
    public List<BloodRequest> listAdmin(String status,int page,int size)throws SQLException{
        String where="";List<Object> p=new ArrayList<Object>();if(status!=null&&!status.isEmpty()){where=" WHERE r.status=?";p.add(status);}return page("SELECT "+FIELDS+JOINS+where+" ORDER BY r.created_at DESC",p,page,size);
    }
    public BloodRequest findById(long id)throws SQLException{
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("SELECT "+FIELDS+JOINS+"WHERE r.request_id=?")){
            ps.setLong(1,id);try(ResultSet rs=ps.executeQuery()){return rs.next()?map(rs):null;}
        }
    }
    public void update(BloodRequest r)throws SQLException{
        String sql="UPDATE blood_requests SET patient_name=?,blood_group=?,hospital=?,district_id=?,upazila_id=?,contact_phone=?,needed_date=?,details=?,status=? WHERE request_id=?";
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
            ps.setString(1,r.getPatientName());ps.setString(2,r.getBloodGroup());ps.setString(3,r.getHospital());ps.setLong(4,r.getDistrictId());
            setNullableLong(ps,5,r.getUpazilaId());ps.setString(6,r.getContactPhone());ps.setDate(7,r.getNeededDate());ps.setString(8,r.getDetails());
            ps.setString(9,r.getStatus());ps.setLong(10,r.getRequestId());
            if(ps.executeUpdate()==0)throw new SQLException("Request not found");
        }
    }
    public List<BloodRequest> latestOpen(int size)throws SQLException{return page("SELECT "+FIELDS+JOINS+" WHERE r.status='OPEN' ORDER BY r.created_at DESC",new ArrayList<Object>(),1,size);}
    private List<BloodRequest> page(String inner,List<Object> p,int page,int size)throws SQLException{
        List<BloodRequest> out=new ArrayList<BloodRequest>();String sql="SELECT * FROM (SELECT q.*,ROWNUM rn FROM ("+inner+") q WHERE ROWNUM<=?) WHERE rn>?";
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){int i=1;for(Object v:p)ps.setObject(i++,v);ps.setInt(i++,page*size);ps.setInt(i,(page-1)*size);try(ResultSet rs=ps.executeQuery()){while(rs.next())out.add(map(rs));}}return out;
    }
    public long countOpen(String group,Long district)throws SQLException{StringBuilder sql=new StringBuilder("SELECT COUNT(*) FROM blood_requests r WHERE r.status='OPEN'");List<Object> p=new ArrayList<Object>();if(group!=null&&!group.isEmpty()){sql.append(" AND r.blood_group=?");p.add(group);}if(district!=null){sql.append(" AND r.district_id=?");p.add(district);}return count(sql.toString(),p);}
    public long countOpen(String group,Long district,Long upazila)throws SQLException{StringBuilder sql=new StringBuilder("SELECT COUNT(*) FROM blood_requests r WHERE r.status='OPEN'");List<Object> p=new ArrayList<Object>();if(group!=null&&!group.isEmpty()){sql.append(" AND r.blood_group=?");p.add(group);}if(district!=null){sql.append(" AND r.district_id=?");p.add(district);}if(upazila!=null){sql.append(" AND r.upazila_id=?");p.add(upazila);}return count(sql.toString(),p);}
    public long countAll()throws SQLException{return count("SELECT COUNT(*) FROM blood_requests",new ArrayList<Object>());}
    public long countStatus(String status)throws SQLException{return count("SELECT COUNT(*) FROM blood_requests WHERE status=?",java.util.Collections.<Object>singletonList(status));}
    private long count(String sql,List<Object> p)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){for(int i=0;i<p.size();i++)ps.setObject(i+1,p.get(i));try(ResultSet rs=ps.executeQuery()){rs.next();return rs.getLong(1);}}}
    public void setStatus(long id,String status)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("UPDATE blood_requests SET status=? WHERE request_id=?")){ps.setString(1,status);ps.setLong(2,id);ps.executeUpdate();}}
    public void delete(long id)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("DELETE FROM blood_requests WHERE request_id=?")){ps.setLong(1,id);ps.executeUpdate();}}
    private static void setNullableLong(PreparedStatement ps,int i,Long v)throws SQLException{if(v==null)ps.setNull(i,Types.NUMERIC);else ps.setLong(i,v);}
    private BloodRequest map(ResultSet rs)throws SQLException{BloodRequest r=new BloodRequest();r.setRequestId(rs.getLong("request_id"));r.setPatientName(rs.getString("patient_name"));r.setBloodGroup(rs.getString("blood_group"));r.setHospital(rs.getString("hospital"));r.setDistrictId(rs.getLong("district_id"));long a=rs.getLong("upazila_id");r.setUpazilaId(rs.wasNull()?null:a);r.setContactPhone(rs.getString("contact_phone"));r.setNeededDate(rs.getDate("needed_date"));r.setDetails(rs.getString("details"));r.setStatus(rs.getString("status"));r.setCreatedAt(rs.getTimestamp("created_at"));r.setDistrictName(rs.getString("district_name"));r.setUpazilaName(rs.getString("upazila_name"));return r;}
}
