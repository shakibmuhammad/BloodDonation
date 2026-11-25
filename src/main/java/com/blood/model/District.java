package com.blood.model;

public class District {
    private long districtId;
    private long divisionId;
    private String name, division;
    public long getDistrictId() { return districtId; }
    public void setDistrictId(long districtId) { this.districtId = districtId; }
    public long getDivisionId() { return divisionId; }
    public void setDivisionId(long divisionId) { this.divisionId = divisionId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDivision() { return division; }
    public void setDivision(String division) { this.division = division; }
}
