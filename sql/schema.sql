-- Oracle Database 11g XE schema. Run as the blood schema owner.
CREATE TABLE divisions (
  division_id NUMBER(10) PRIMARY KEY,
  name VARCHAR2(50) NOT NULL UNIQUE
);
CREATE SEQUENCE seq_divisions START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_divisions_id BEFORE INSERT ON divisions FOR EACH ROW
BEGIN IF :NEW.division_id IS NULL THEN SELECT seq_divisions.NEXTVAL INTO :NEW.division_id FROM dual; END IF; END;
/

CREATE TABLE districts (
  district_id NUMBER(10) PRIMARY KEY,
  name VARCHAR2(80) NOT NULL UNIQUE,
  division_id NUMBER(10) NOT NULL REFERENCES divisions(division_id)
);
CREATE SEQUENCE seq_districts START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_districts_id BEFORE INSERT ON districts FOR EACH ROW
BEGIN IF :NEW.district_id IS NULL THEN SELECT seq_districts.NEXTVAL INTO :NEW.district_id FROM dual; END IF; END;
/

CREATE TABLE upazilas (
  upazila_id NUMBER(10) PRIMARY KEY,
  district_id NUMBER(10) NOT NULL REFERENCES districts(district_id),
  name VARCHAR2(100) NOT NULL,
  CONSTRAINT uq_upazila_district UNIQUE (upazila_id, district_id),
  CONSTRAINT uq_upazila_name UNIQUE (district_id, name)
);
CREATE SEQUENCE seq_upazilas START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_upazilas_id BEFORE INSERT ON upazilas FOR EACH ROW
BEGIN IF :NEW.upazila_id IS NULL THEN SELECT seq_upazilas.NEXTVAL INTO :NEW.upazila_id FROM dual; END IF; END;
/

CREATE TABLE donors (
  donor_id NUMBER(10) PRIMARY KEY,
  full_name VARCHAR2(120) NOT NULL,
  username VARCHAR2(60) NOT NULL UNIQUE,
  email VARCHAR2(160) NOT NULL UNIQUE,
  phone VARCHAR2(24) NOT NULL UNIQUE,
  password_hash VARCHAR2(64) NOT NULL,
  password_salt VARCHAR2(64) NOT NULL,
  blood_group VARCHAR2(3) NOT NULL CHECK (blood_group IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
  district_id NUMBER(10) NOT NULL REFERENCES districts(district_id),
  upazila_id NUMBER(10),
  address VARCHAR2(240),
  last_donation DATE,
  available CHAR(1) DEFAULT 'Y' NOT NULL CHECK (available IN ('Y','N')),
  status VARCHAR2(10) DEFAULT 'PENDING' NOT NULL CHECK (status IN ('PENDING','ACTIVE','BLOCKED')),
  created_at DATE DEFAULT SYSDATE NOT NULL,
  updated_at DATE DEFAULT SYSDATE NOT NULL,
  CONSTRAINT fk_donor_upazila_district FOREIGN KEY (upazila_id, district_id) REFERENCES upazilas(upazila_id, district_id)
);
CREATE SEQUENCE seq_donors START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_donors_id BEFORE INSERT ON donors FOR EACH ROW
BEGIN IF :NEW.donor_id IS NULL THEN SELECT seq_donors.NEXTVAL INTO :NEW.donor_id FROM dual; END IF; END;
/

CREATE TABLE blood_requests (
  request_id NUMBER(10) PRIMARY KEY,
  patient_name VARCHAR2(120) NOT NULL,
  blood_group VARCHAR2(3) NOT NULL CHECK (blood_group IN ('A+','A-','B+','B-','AB+','AB-','O+','O-')),
  hospital VARCHAR2(180) NOT NULL,
  district_id NUMBER(10) NOT NULL REFERENCES districts(district_id),
  upazila_id NUMBER(10),
  contact_phone VARCHAR2(24) NOT NULL,
  needed_date DATE NOT NULL,
  details VARCHAR2(1000),
  status VARCHAR2(12) DEFAULT 'OPEN' NOT NULL CHECK (status IN ('OPEN','FULFILLED','CLOSED')),
  created_at DATE DEFAULT SYSDATE NOT NULL,
  CONSTRAINT fk_request_upazila_district FOREIGN KEY (upazila_id, district_id) REFERENCES upazilas(upazila_id, district_id)
);
CREATE SEQUENCE seq_blood_requests START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_blood_requests_id BEFORE INSERT ON blood_requests FOR EACH ROW
BEGIN IF :NEW.request_id IS NULL THEN SELECT seq_blood_requests.NEXTVAL INTO :NEW.request_id FROM dual; END IF; END;
/

CREATE TABLE admins (
  admin_id NUMBER(10) PRIMARY KEY,
  username VARCHAR2(60) NOT NULL UNIQUE,
  email VARCHAR2(160) NOT NULL UNIQUE,
  password_hash VARCHAR2(64) NOT NULL,
  password_salt VARCHAR2(64) NOT NULL,
  created_at DATE DEFAULT SYSDATE NOT NULL
);
CREATE SEQUENCE seq_admins START WITH 1 INCREMENT BY 1 NOCACHE;
CREATE OR REPLACE TRIGGER trg_admins_id BEFORE INSERT ON admins FOR EACH ROW
BEGIN IF :NEW.admin_id IS NULL THEN SELECT seq_admins.NEXTVAL INTO :NEW.admin_id FROM dual; END IF; END;
/

CREATE INDEX idx_donors_search ON donors (blood_group, district_id, upazila_id, status, available);
CREATE INDEX idx_requests_filter ON blood_requests (status, blood_group, district_id, created_at);
