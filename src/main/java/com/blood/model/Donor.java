package com.blood.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Donor {
    private long donorId;
    private String fullName, username, email, phone, bloodGroup, address, available, status, districtName, upazilaName;
    private long districtId;
    private Long upazilaId;
    private Date lastDonation;
    private Timestamp createdAt;
    public long getDonorId() { return donorId; }
    public void setDonorId(long donorId) { this.donorId = donorId; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getAvailable() { return available; }
    public void setAvailable(String available) { this.available = available; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public long getDistrictId() { return districtId; }
    public void setDistrictId(long districtId) { this.districtId = districtId; }
    public Long getUpazilaId() { return upazilaId; }
    public void setUpazilaId(Long upazilaId) { this.upazilaId = upazilaId; }
    public Date getLastDonation() { return lastDonation; }
    public void setLastDonation(Date lastDonation) { this.lastDonation = lastDonation; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getDistrictName() { return districtName; }
    public void setDistrictName(String districtName) { this.districtName = districtName; }
    public String getUpazilaName() { return upazilaName; }
    public void setUpazilaName(String upazilaName) { this.upazilaName = upazilaName; }
}
