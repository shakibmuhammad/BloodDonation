package com.blood.dao;

import com.blood.model.Donor;
import com.blood.util.DBConnection;
import com.blood.util.PasswordUtil;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DonorDAO {
    private static final String FIELDS = "d.donor_id,d.full_name,d.username,d.email,d.phone,d.blood_group,d.district_id,d.upazila_id,d.address,d.last_donation,d.available,d.status,d.created_at,di.name district_name,a.name upazila_name";
    private static final String JOINS = " FROM donors d JOIN districts di ON di.district_id=d.district_id LEFT JOIN upazilas a ON a.upazila_id=d.upazila_id ";

    public void register(Donor d, String password) throws SQLException {
        String salt = PasswordUtil.newSalt();
        String sql = "INSERT INTO donors(full_name,username,email,phone,password_hash,password_salt,blood_group,district_id,upazila_id,address,status,available) VALUES(?,?,?,?,?,?,?,?,?,?,'PENDING','Y')";
        try (Connection c = DBConnection.getConnection(); PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1,d.getFullName()); ps.setString(2,d.getUsername()); ps.setString(3,d.getEmail()); ps.setString(4,d.getPhone()); ps.setString(5,PasswordUtil.hash(password,salt)); ps.setString(6,salt);
            ps.setString(7,d.getBloodGroup()); ps.setLong(8,d.getDistrictId()); setNullableLong(ps,9,d.getUpazilaId()); ps.setString(10,d.getAddress()); ps.executeUpdate();
        }
    }
    public Donor authenticate(String identity, String password) throws SQLException {
        String sql = "SELECT " + FIELDS + ",d.password_hash,d.password_salt" + JOINS + "WHERE (LOWER(d.email)=LOWER(?) OR LOWER(d.username)=LOWER(?)) AND d.status='ACTIVE'";
        try (Connection c=DBConnection.getConnection(); PreparedStatement ps=c.prepareStatement(sql)) {
            ps.setString(1,identity); ps.setString(2,identity);
            try (ResultSet rs=ps.executeQuery()) {
                if (!rs.next() || !PasswordUtil.verify(password,rs.getString("password_salt"),rs.getString("password_hash"))) return null;
                return map(rs);
            }
        }
    }
    public Donor findById(long id) throws SQLException {
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("SELECT "+FIELDS+JOINS+"WHERE d.donor_id=?")) {
            ps.setLong(1,id); try(ResultSet rs=ps.executeQuery()){return rs.next()?map(rs):null;}
        }
    }
    public List<Donor> search(String bloodGroup, Long districtId, Long upazilaId, int page, int pageSize) throws SQLException {
        StringBuilder where=new StringBuilder(" WHERE d.status='ACTIVE' AND d.available='Y' AND (d.last_donation IS NULL OR d.last_donation<=ADD_MONTHS(TRUNC(SYSDATE),-3)) ");
        List<Object> params=new ArrayList<Object>();
        if(bloodGroup!=null&&!bloodGroup.isEmpty()){where.append(" AND d.blood_group=?");params.add(bloodGroup);}
        if(districtId!=null){where.append(" AND d.district_id=?");params.add(districtId);}
        if(upazilaId!=null){where.append(" AND d.upazila_id=?");params.add(upazilaId);}
        String inner="SELECT "+FIELDS+JOINS+where+" ORDER BY d.created_at DESC";
        return pagedDonors(inner,params,page,pageSize);
    }
    public List<Donor> listAdmin(String status, int page, int pageSize) throws SQLException {
        String where=""; List<Object> params=new ArrayList<Object>();
        if(status!=null&&!status.isEmpty()){where=" WHERE d.status=?";params.add(status);}
        return pagedDonors("SELECT "+FIELDS+JOINS+where+" ORDER BY d.created_at DESC",params,page,pageSize);
    }
    private List<Donor> pagedDonors(String inner,List<Object> params,int page,int pageSize)throws SQLException{
        int start=(page-1)*pageSize, end=start+pageSize;
        String sql="SELECT * FROM (SELECT q.*,ROWNUM rn FROM ("+inner+") q WHERE ROWNUM<=?) WHERE rn>?";
        List<Donor> out=new ArrayList<Donor>();
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
            int i=1;for(Object p:params)ps.setObject(i++,p);ps.setInt(i++,end);ps.setInt(i,start);
            try(ResultSet rs=ps.executeQuery()){while(rs.next())out.add(map(rs));}
        }return out;
    }
    public long countSearch(String bloodGroup,Long districtId,Long upazilaId)throws SQLException{
        StringBuilder sql=new StringBuilder("SELECT COUNT(*) FROM donors d WHERE d.status='ACTIVE' AND d.available='Y' AND (d.last_donation IS NULL OR d.last_donation<=ADD_MONTHS(TRUNC(SYSDATE),-3))");
        List<Object> p=new ArrayList<Object>(); if(bloodGroup!=null&&!bloodGroup.isEmpty()){sql.append(" AND d.blood_group=?");p.add(bloodGroup);}if(districtId!=null){sql.append(" AND d.district_id=?");p.add(districtId);}if(upazilaId!=null){sql.append(" AND d.upazila_id=?");p.add(upazilaId);}
        return count(sql.toString(),p);
    }
    public long countAll() throws SQLException { return count("SELECT COUNT(*) FROM donors",new ArrayList<Object>()); }
    public long countStatus(String status)throws SQLException{return count("SELECT COUNT(*) FROM donors WHERE status=?",java.util.Collections.<Object>singletonList(status));}
    public long countAvailable() throws SQLException {
        return count("SELECT COUNT(*) FROM donors WHERE status='ACTIVE' AND available='Y' AND (last_donation IS NULL OR last_donation<=ADD_MONTHS(TRUNC(SYSDATE),-3))",new ArrayList<Object>());
    }
    public void updateProfile(Donor d)throws SQLException{
        String sql="UPDATE donors SET full_name=?,phone=?,blood_group=?,district_id=?,upazila_id=?,address=?,updated_at=SYSDATE WHERE donor_id=?";
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){ps.setString(1,d.getFullName());ps.setString(2,d.getPhone());ps.setString(3,d.getBloodGroup());ps.setLong(4,d.getDistrictId());setNullableLong(ps,5,d.getUpazilaId());ps.setString(6,d.getAddress());ps.setLong(7,d.getDonorId());ps.executeUpdate();}
    }
    public void updateAdmin(Donor d)throws SQLException{
        String sql="UPDATE donors SET full_name=?,username=?,email=?,phone=?,blood_group=?,district_id=?,upazila_id=?,address=?,last_donation=?,available=?,status=?,updated_at=SYSDATE WHERE donor_id=?";
        try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){
            ps.setString(1,d.getFullName());ps.setString(2,d.getUsername());ps.setString(3,d.getEmail());ps.setString(4,d.getPhone());ps.setString(5,d.getBloodGroup());
            ps.setLong(6,d.getDistrictId());setNullableLong(ps,7,d.getUpazilaId());ps.setString(8,d.getAddress());
            if(d.getLastDonation()==null)ps.setNull(9,Types.DATE);else ps.setDate(9,d.getLastDonation());
            ps.setString(10,d.getAvailable());ps.setString(11,d.getStatus());ps.setLong(12,d.getDonorId());
            if(ps.executeUpdate()==0)throw new SQLException("Donor not found");
        }
    }
    public void updateAvailability(long id,boolean available)throws SQLException{update("UPDATE donors SET available=?,updated_at=SYSDATE WHERE donor_id=?",available?"Y":"N",id);}
    public void updateLastDonation(long id,Date date)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("UPDATE donors SET last_donation=?,available='N',updated_at=SYSDATE WHERE donor_id=?")){ps.setDate(1,date);ps.setLong(2,id);ps.executeUpdate();}}
    public void setStatus(long id,String status)throws SQLException{update("UPDATE donors SET status=?,updated_at=SYSDATE WHERE donor_id=?",status,id);}
    public void delete(long id)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement("DELETE FROM donors WHERE donor_id=?")){ps.setLong(1,id);ps.executeUpdate();}}
    private void update(String sql,String value,long id)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){ps.setString(1,value);ps.setLong(2,id);ps.executeUpdate();}}
    private long count(String sql,List<Object> p)throws SQLException{try(Connection c=DBConnection.getConnection();PreparedStatement ps=c.prepareStatement(sql)){for(int i=0;i<p.size();i++)ps.setObject(i+1,p.get(i));try(ResultSet rs=ps.executeQuery()){rs.next();return rs.getLong(1);}}}
    private static void setNullableLong(PreparedStatement ps,int index,Long value)throws SQLException{if(value==null)ps.setNull(index,Types.NUMERIC);else ps.setLong(index,value);}
    private Donor map(ResultSet rs)throws SQLException{
        Donor d=new Donor();d.setDonorId(rs.getLong("donor_id"));d.setFullName(rs.getString("full_name"));d.setUsername(rs.getString("username"));d.setEmail(rs.getString("email"));d.setPhone(rs.getString("phone"));d.setBloodGroup(rs.getString("blood_group"));d.setDistrictId(rs.getLong("district_id"));long a=rs.getLong("upazila_id");d.setUpazilaId(rs.wasNull()?null:a);d.setAddress(rs.getString("address"));d.setLastDonation(rs.getDate("last_donation"));d.setAvailable(rs.getString("available"));d.setStatus(rs.getString("status"));d.setCreatedAt(rs.getTimestamp("created_at"));d.setDistrictName(rs.getString("district_name"));d.setUpazilaName(rs.getString("upazila_name"));return d;
    }
}
