package com.blood.model;

import java.sql.Date;
import java.sql.Timestamp;

public class BloodRequest {
    private long requestId, districtId;
    private Long upazilaId;
    private String patientName, bloodGroup, hospital, contactPhone, details, status, districtName, upazilaName;
    private Date neededDate;
    private Timestamp createdAt;
    public long getRequestId() { return requestId; }
    public void setRequestId(long requestId) { this.requestId = requestId; }
    public long getDistrictId() { return districtId; }
    public void setDistrictId(long districtId) { this.districtId = districtId; }
    public Long getUpazilaId() { return upazilaId; }
    public void setUpazilaId(Long upazilaId) { this.upazilaId = upazilaId; }
    public String getPatientName() { return patientName; }
    public void setPatientName(String patientName) { this.patientName = patientName; }
    public String getBloodGroup() { return bloodGroup; }
    public void setBloodGroup(String bloodGroup) { this.bloodGroup = bloodGroup; }
    public String getHospital() { return hospital; }
    public void setHospital(String hospital) { this.hospital = hospital; }
    public String getContactPhone() { return contactPhone; }
    public void setContactPhone(String contactPhone) { this.contactPhone = contactPhone; }
    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Date getNeededDate() { return neededDate; }
    public void setNeededDate(Date neededDate) { this.neededDate = neededDate; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public String getDistrictName() { return districtName; }
    public void setDistrictName(String districtName) { this.districtName = districtName; }
    public String getUpazilaName() { return upazilaName; }
    public void setUpazilaName(String upazilaName) { this.upazilaName = upazilaName; }
}
