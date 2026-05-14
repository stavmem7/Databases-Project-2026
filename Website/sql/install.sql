-- phpMyAdmin SQL Dump
-- Server version: 10.4.32-MariaDB

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";
SET NAMES utf8mb4;

USE ygeiopolis;
SET FOREIGN_KEY_CHECKS = 0;

-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: ygeiopolis
--

-- --------------------------------------------------------

--
-- Table structure for table allergy
--

CREATE TABLE allergy (
  patient_ssn char(11) NOT NULL,
  substance_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table patient
--

CREATE TABLE patient (
  ssn char(11) NOT NULL,
  name varchar(50) NOT NULL,
  surname varchar(50) NOT NULL,
  father_name varchar(50) NOT NULL,
  age tinyint(3) UNSIGNED NOT NULL,
  gender enum('MALE','FEMALE','OTHER') NOT NULL,
  weight decimal(5,2) DEFAULT NULL CHECK (weight > 0),
  height decimal(4,2) DEFAULT NULL CHECK (height > 0),
  address varchar(200) DEFAULT NULL,
  phone varchar(15) DEFAULT NULL,
  email varchar(100) DEFAULT NULL,
  occupation varchar(100) DEFAULT NULL,
  nationality varchar(50) DEFAULT NULL,
  insurance_provider varchar(100) NOT NULL
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table doctor_review
--

CREATE TABLE doctor_review (
  review_id int(11) NOT NULL,
  hospitalization_id int(11) NOT NULL,
  doctor_ssn char(11) NOT NULL,
  medical_care_quality tinyint(4) NOT NULL CHECK (medical_care_quality between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table hospitalization_review
--

CREATE TABLE hospitalization_review (
  review_id int(11) NOT NULL,
  hospitalization_id int(11) NOT NULL,
  nursing_care_quality tinyint(4) NOT NULL CHECK (nursing_care_quality between 1 and 5),
  cleanliness tinyint(4) NOT NULL CHECK (cleanliness between 1 and 5),
  food tinyint(4) NOT NULL CHECK (food between 1 and 5),
  overall_experience tinyint(4) NOT NULL CHECK (overall_experience between 1 and 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table triage
--

CREATE TABLE triage (
  triage_id int(11) NOT NULL,
  patient_ssn char(11) NOT NULL,
  nurse_ssn char(11) NOT NULL,
  hospitalization_id int(11) DEFAULT NULL,
  arrival_time datetime NOT NULL,
  service_time datetime DEFAULT NULL,
  symptoms text DEFAULT NULL,
  urgency_level tinyint(4) NOT NULL CHECK (urgency_level between 1 and 5),
  outcome enum('DISCHARGED','ADMITTED') NOT NULL
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table administrative_staff
--

CREATE TABLE administrative_staff (
  ssn char(11) NOT NULL,
  staff_ssn char(11) NOT NULL,
  department_id int(11) NOT NULL,
  role varchar(50) NOT NULL,
  office varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table active_substance
--

CREATE TABLE active_substance (
  substance_id int(11) NOT NULL,
  name varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table image
--

CREATE TABLE image (
  image_id int(11) NOT NULL,
  entity_type varchar(50) NOT NULL,
  entity_id int(11) NOT NULL,
  url varchar(500) NOT NULL,
  description text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table lab_test
--

CREATE TABLE lab_test (
  test_id int(11) NOT NULL,
  hospitalization_id int(11) NOT NULL,
  doctor_ssn char(11) NOT NULL,
  code varchar(20) NOT NULL,
  type varchar(100) NOT NULL,
  date date NOT NULL,
  result_text text DEFAULT NULL,
  result_numeric decimal(10,4) DEFAULT NULL,
  unit varchar(30) DEFAULT NULL,
  cost decimal(8,2) NOT NULL CHECK (cost >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table medication
--

CREATE TABLE medication (
  medication_id int(11) NOT NULL,
  name varchar(200) NOT NULL,
  ema_code varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table medication_substance
--

CREATE TABLE medication_substance (
  medication_id int(11) NOT NULL,
  substance_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table medical_procedure
--

CREATE TABLE medical_procedure (
  procedure_id int(11) NOT NULL,
  hospitalization_id int(11) NOT NULL,
  room_id int(11) NOT NULL,
  chief_surgeon_ssn char(11) NOT NULL,
  code varchar(20) NOT NULL,
  name varchar(200) NOT NULL,
  category enum('SURGICAL','DIAGNOSTIC','THERAPEUTIC') NOT NULL,
  duration_minutes int(11) NOT NULL CHECK (duration_minutes > 0),
  cost decimal(10,2) NOT NULL CHECK (cost >= 0),
  start_datetime datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table doctor
--

CREATE TABLE doctor (
  ssn char(11) NOT NULL,
  staff_ssn char(11) NOT NULL,
  supervisor_ssn char(11) DEFAULT NULL,
  medical_license_no varchar(20) NOT NULL,
  specialty varchar(50) NOT NULL,
  rank enum('RESIDENT','JUNIOR_CONSULTANT','SENIOR_CONSULTANT','DIRECTOR') NOT NULL
) ;

--
--


--
-- Triggers doctor
--
DELIMITER $$
CREATE TRIGGER `trg_no_circular_supervision` BEFORE INSERT ON `doctor` FOR EACH ROW BEGIN
    DECLARE epoptis_id CHAR(11);
    DECLARE depth INT DEFAULT 0;
    SET epoptis_id = NEW.supervisor_ssn;
    WHILE epoptis_id IS NOT NULL AND depth < 100 DO
        IF epoptis_id = NEW.ssn THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Κυκλική αλυσίδα εποπτείας δεν επιτρέπεται';
        END IF;
        SELECT supervisor_ssn INTO epoptis_id FROM doctor WHERE ssn = epoptis_id;
        SET depth = depth + 1;
    END WHILE;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table doctor_department
--

CREATE TABLE doctor_department (
  doctor_ssn char(11) NOT NULL,
  department_id int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table icd10
--

CREATE TABLE icd10 (
  code varchar(10) NOT NULL,
  description varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table ken
--

CREATE TABLE ken (
  ken_code varchar(20) NOT NULL,
  description text DEFAULT NULL,
  base_cost decimal(10,2) NOT NULL CHECK (base_cost >= 0),
  avg_stay_days decimal(5,2) NOT NULL CHECK (avg_stay_days > 0),
  daily_excess_charge decimal(8,2) NOT NULL CHECK (daily_excess_charge >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table bed
--

CREATE TABLE bed (
  bed_id int(11) NOT NULL,
  department_id int(11) NOT NULL,
  unique_number varchar(20) NOT NULL,
  type enum('ICU','SINGLE','MULTI','OTHER') NOT NULL,
  status enum('AVAILABLE','OCCUPIED','MAINTENANCE') NOT NULL DEFAULT 'AVAILABLE'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table hospitalization
--

CREATE TABLE hospitalization (
  hospitalization_id int(11) NOT NULL,
  patient_ssn char(11) NOT NULL,
  bed_id int(11) NOT NULL,
  department_id int(11) NOT NULL,
  ken_code varchar(20) NOT NULL,
  admission_date date NOT NULL,
  discharge_date date DEFAULT NULL,
  admission_diagnosis_code varchar(10) NOT NULL,
  admission_diagnosis_desc text DEFAULT NULL,
  discharge_diagnosis_code varchar(10) DEFAULT NULL,
  discharge_diagnosis_desc text DEFAULT NULL,
  total_cost decimal(10,2) DEFAULT NULL CHECK (total_cost >= 0)
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table nurse
--

CREATE TABLE nurse (
  ssn char(11) NOT NULL,
  staff_ssn char(11) NOT NULL,
  department_id int(11) NOT NULL,
  rank enum('NURSE_ASSISTANT','NURSE','HEAD_NURSE') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table emergency_contact
--

CREATE TABLE emergency_contact (
  emergency_contact_id int(11) NOT NULL,
  patient_ssn char(11) NOT NULL,
  name varchar(100) NOT NULL,
  phone varchar(15) NOT NULL,
  relationship varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table staff
--

CREATE TABLE staff (
  ssn char(11) NOT NULL,
  name varchar(50) NOT NULL,
  surname varchar(50) NOT NULL,
  age tinyint(3) UNSIGNED NOT NULL CHECK (age >= 18 and age <= 80),
  email varchar(100) NOT NULL,
  phone varchar(15) NOT NULL,
  hire_date date NOT NULL,
  type enum('DOCTOR','NURSE','ADMINISTRATIVE') NOT NULL
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table shift_participation
--

CREATE TABLE shift_participation (
  shift_id int(11) NOT NULL,
  staff_ssn char(11) NOT NULL,
  role_shifts varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table prescription
--

CREATE TABLE prescription (
  prescription_id int(11) NOT NULL,
  doctor_ssn char(11) NOT NULL,
  patient_ssn char(11) NOT NULL,
  medication_id int(11) NOT NULL,
  hospitalization_id int(11) NOT NULL,
  dosage varchar(200) NOT NULL,
  frequency varchar(100) NOT NULL,
  start_date date NOT NULL,
  end_date date DEFAULT NULL
) ;

--
--


-- --------------------------------------------------------

--
-- Table structure for table department
--

CREATE TABLE department (
  department_id int(11) NOT NULL,
  director_ssn char(11) DEFAULT NULL,
  name varchar(100) NOT NULL,
  description text DEFAULT NULL,
  bed_count smallint(5) UNSIGNED NOT NULL DEFAULT 0,
  floor_building varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table shift
--

CREATE TABLE shift (
  shift_id int(11) NOT NULL,
  department_id int(11) NOT NULL,
  date date NOT NULL,
  type enum('MORNING','AFTERNOON','NIGHT') NOT NULL,
  start_time time NOT NULL,
  end_time time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table procedure_assistant
--

CREATE TABLE procedure_assistant (
  procedure_id int(11) NOT NULL,
  assistant_ssn char(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


-- --------------------------------------------------------

--
-- Table structure for table procedure_room
--

CREATE TABLE procedure_room (
  room_id int(11) NOT NULL,
  name varchar(100) NOT NULL,
  type enum('XEIROURGEIΟ','AΙTHOUSA_EPEMVASIS') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
--


--
-- Indexes for dumped tables
--

--
-- Indexes for table allergy
--
ALTER TABLE allergy
  ADD PRIMARY KEY (patient_ssn,substance_id),
  ADD KEY fk_all_ousia (substance_id);

--
-- Indexes for table patient
--
ALTER TABLE patient
  ADD PRIMARY KEY (ssn);

--
-- Indexes for table doctor_review
--
ALTER TABLE doctor_review
  ADD PRIMARY KEY (review_id),
  ADD UNIQUE KEY uq_axiolog_iat (hospitalization_id,doctor_ssn),
  ADD KEY fk_axi_doctor (doctor_ssn);

--
-- Indexes for table hospitalization_review
--
ALTER TABLE hospitalization_review
  ADD PRIMARY KEY (review_id),
  ADD UNIQUE KEY hospitalization_id (hospitalization_id);

--
-- Indexes for table triage
--
ALTER TABLE triage
  ADD PRIMARY KEY (triage_id),
  ADD KEY fk_dial_patient (patient_ssn),
  ADD KEY fk_dial_nurse (nurse_ssn),
  ADD KEY fk_dial_hospitalization (hospitalization_id);

--
-- Indexes for table administrative_staff
--
ALTER TABLE administrative_staff
  ADD PRIMARY KEY (ssn),
  ADD KEY fk_administrative_staff (staff_ssn),
  ADD KEY fk_dioikitiko_department (department_id);

--
-- Indexes for table active_substance
--
ALTER TABLE active_substance
  ADD PRIMARY KEY (substance_id),
  ADD UNIQUE KEY name (name);

--
-- Indexes for table image
--
ALTER TABLE image
  ADD PRIMARY KEY (image_id);

--
-- Indexes for table lab_test
--
ALTER TABLE lab_test
  ADD PRIMARY KEY (test_id),
  ADD KEY fk_ex_hospitalization (hospitalization_id),
  ADD KEY fk_ex_doctor (doctor_ssn);

--
-- Indexes for table medication
--
ALTER TABLE medication
  ADD PRIMARY KEY (medication_id),
  ADD UNIQUE KEY ema_code (ema_code);

--
-- Indexes for table medication_substance
--
ALTER TABLE medication_substance
  ADD PRIMARY KEY (medication_id,substance_id),
  ADD KEY fk_fo_ousia (substance_id);

--
-- Indexes for table medical_procedure
--
ALTER TABLE medical_procedure
  ADD PRIMARY KEY (procedure_id),
  ADD KEY fk_praxi_hospitalization (hospitalization_id),
  ADD KEY fk_praxi_xwros (room_id),
  ADD KEY fk_praxi_xeirourgos (chief_surgeon_ssn);

--
-- Indexes for table doctor
--
ALTER TABLE doctor
  ADD PRIMARY KEY (ssn),
  ADD UNIQUE KEY medical_license_no (medical_license_no),
  ADD KEY fk_doctor_staff (staff_ssn),
  ADD KEY fk_doctor_epoptis (supervisor_ssn);

--
-- Indexes for table doctor_department
--
ALTER TABLE doctor_department
  ADD PRIMARY KEY (doctor_ssn,department_id),
  ADD KEY fk_it_department (department_id);

--
-- Indexes for table icd10
--
ALTER TABLE icd10
  ADD PRIMARY KEY (code);

--
-- Indexes for table ken
--
ALTER TABLE ken
  ADD PRIMARY KEY (ken_code);

--
-- Indexes for table bed
--
ALTER TABLE bed
  ADD PRIMARY KEY (bed_id),
  ADD UNIQUE KEY uq_bed_department (department_id,unique_number);

--
-- Indexes for table hospitalization
--
ALTER TABLE hospitalization
  ADD PRIMARY KEY (hospitalization_id),
  ADD KEY fk_nos_patient (patient_ssn),
  ADD KEY fk_nos_bed (bed_id),
  ADD KEY fk_nos_department (department_id),
  ADD KEY fk_nos_drg (ken_code);

--
-- Indexes for table nurse
--
ALTER TABLE nurse
  ADD PRIMARY KEY (ssn),
  ADD KEY fk_nurse_staff (staff_ssn),
  ADD KEY fk_nurse_department (department_id);

--
-- Indexes for table emergency_contact
--
ALTER TABLE emergency_contact
  ADD PRIMARY KEY (emergency_contact_id),
  ADD KEY fk_emergency_contact_patient (patient_ssn);

--
-- Indexes for table staff
--
ALTER TABLE staff
  ADD PRIMARY KEY (ssn),
  ADD UNIQUE KEY email (email);

--
-- Indexes for table shift_participation
--
ALTER TABLE shift_participation
  ADD PRIMARY KEY (shift_id,staff_ssn),
  ADD KEY fk_sv_staff (staff_ssn);

--
-- Indexes for table prescription
--
ALTER TABLE prescription
  ADD PRIMARY KEY (prescription_id),
  ADD UNIQUE KEY uq_syntag (doctor_ssn,patient_ssn,medication_id,start_date),
  ADD KEY fk_syn_patient (patient_ssn),
  ADD KEY fk_syn_medication (medication_id),
  ADD KEY fk_syn_hospitalization (hospitalization_id);

--
-- Indexes for table department
--
ALTER TABLE department
  ADD PRIMARY KEY (department_id),
  ADD UNIQUE KEY name (name),
  ADD KEY fk_department_dieutintis (director_ssn);

--
-- Indexes for table shift
--
ALTER TABLE shift
  ADD PRIMARY KEY (shift_id),
  ADD UNIQUE KEY uq_shift (department_id,date,type);

--
-- Indexes for table procedure_assistant
--
ALTER TABLE procedure_assistant
  ADD PRIMARY KEY (procedure_id,assistant_ssn),
  ADD KEY fk_vp_staff (assistant_ssn);

--
-- Indexes for table procedure_room
--
ALTER TABLE procedure_room
  ADD PRIMARY KEY (room_id),
  ADD UNIQUE KEY name (name);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table doctor_review
--
ALTER TABLE doctor_review
  MODIFY review_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table hospitalization_review
--
ALTER TABLE hospitalization_review
  MODIFY review_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table triage
--
ALTER TABLE triage
  MODIFY triage_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table active_substance
--
ALTER TABLE active_substance
  MODIFY substance_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table image
--
ALTER TABLE image
  MODIFY image_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table lab_test
--
ALTER TABLE lab_test
  MODIFY test_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table medication
--
ALTER TABLE medication
  MODIFY medication_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table medical_procedure
--
ALTER TABLE medical_procedure
  MODIFY procedure_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table bed
--
ALTER TABLE bed
  MODIFY bed_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table hospitalization
--
ALTER TABLE hospitalization
  MODIFY hospitalization_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table emergency_contact
--
ALTER TABLE emergency_contact
  MODIFY emergency_contact_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table prescription
--
ALTER TABLE prescription
  MODIFY prescription_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table department
--
ALTER TABLE department
  MODIFY department_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table shift
--
ALTER TABLE shift
  MODIFY shift_id int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table procedure_room
--
ALTER TABLE procedure_room
  MODIFY room_id int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table allergy
--
ALTER TABLE allergy
  ADD CONSTRAINT fk_all_patient FOREIGN KEY (patient_ssn) REFERENCES patient (ssn) ON DELETE CASCADE,
  ADD CONSTRAINT fk_all_ousia FOREIGN KEY (substance_id) REFERENCES active_substance (substance_id) ON DELETE CASCADE;

--
-- Constraints for table doctor_review
--
ALTER TABLE doctor_review
  ADD CONSTRAINT fk_axi_doctor FOREIGN KEY (doctor_ssn) REFERENCES doctor (ssn),
  ADD CONSTRAINT fk_axi_hospitalization FOREIGN KEY (hospitalization_id) REFERENCES hospitalization (hospitalization_id) ON DELETE CASCADE;

--
-- Constraints for table hospitalization_review
--
ALTER TABLE hospitalization_review
  ADD CONSTRAINT fk_axn_hospitalization FOREIGN KEY (hospitalization_id) REFERENCES hospitalization (hospitalization_id) ON DELETE CASCADE;

--
-- Constraints for table triage
--
ALTER TABLE triage
  ADD CONSTRAINT fk_dial_patient FOREIGN KEY (patient_ssn) REFERENCES patient (ssn),
  ADD CONSTRAINT fk_dial_hospitalization FOREIGN KEY (hospitalization_id) REFERENCES hospitalization (hospitalization_id) ON DELETE SET NULL,
  ADD CONSTRAINT fk_dial_nurse FOREIGN KEY (nurse_ssn) REFERENCES nurse (ssn);

--
-- Constraints for table administrative_staff
--
ALTER TABLE administrative_staff
  ADD CONSTRAINT fk_administrative_staff FOREIGN KEY (staff_ssn) REFERENCES staff (ssn) ON DELETE CASCADE,
  ADD CONSTRAINT fk_dioikitiko_department FOREIGN KEY (department_id) REFERENCES department (department_id);

--
-- Constraints for table lab_test
--
ALTER TABLE lab_test
  ADD CONSTRAINT fk_ex_doctor FOREIGN KEY (doctor_ssn) REFERENCES doctor (ssn),
  ADD CONSTRAINT fk_ex_hospitalization FOREIGN KEY (hospitalization_id) REFERENCES hospitalization (hospitalization_id);

--
-- Constraints for table medication_substance
--
ALTER TABLE medication_substance
  ADD CONSTRAINT fk_fo_medication FOREIGN KEY (medication_id) REFERENCES medication (medication_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_fo_ousia FOREIGN KEY (substance_id) REFERENCES active_substance (substance_id) ON DELETE CASCADE;

--
-- Constraints for table medical_procedure
--
ALTER TABLE medical_procedure
  ADD CONSTRAINT fk_praxi_hospitalization FOREIGN KEY (hospitalization_id) REFERENCES hospitalization (hospitalization_id),
  ADD CONSTRAINT fk_praxi_xeirourgos FOREIGN KEY (chief_surgeon_ssn) REFERENCES doctor (ssn),
  ADD CONSTRAINT fk_praxi_xwros FOREIGN KEY (room_id) REFERENCES procedure_room (room_id);

--
-- Constraints for table doctor
--
ALTER TABLE doctor
  ADD CONSTRAINT fk_doctor_epoptis FOREIGN KEY (supervisor_ssn) REFERENCES doctor (ssn) ON DELETE SET NULL,
  ADD CONSTRAINT fk_doctor_staff FOREIGN KEY (staff_ssn) REFERENCES staff (ssn) ON DELETE CASCADE;

--
-- Constraints for table doctor_department
--
ALTER TABLE doctor_department
  ADD CONSTRAINT fk_it_doctor FOREIGN KEY (doctor_ssn) REFERENCES doctor (ssn) ON DELETE CASCADE,
  ADD CONSTRAINT fk_it_department FOREIGN KEY (department_id) REFERENCES department (department_id) ON DELETE CASCADE;

--
-- Constraints for table bed
--
ALTER TABLE bed
  ADD CONSTRAINT fk_bed_department FOREIGN KEY (department_id) REFERENCES department (department_id) ON DELETE CASCADE;

--
-- Constraints for table hospitalization
--
ALTER TABLE hospitalization
  ADD CONSTRAINT fk_nos_patient FOREIGN KEY (patient_ssn) REFERENCES patient (ssn),
  ADD CONSTRAINT fk_nos_drg FOREIGN KEY (ken_code) REFERENCES ken (ken_code),
  ADD CONSTRAINT fk_nos_bed FOREIGN KEY (bed_id) REFERENCES bed (bed_id),
  ADD CONSTRAINT fk_nos_department FOREIGN KEY (department_id) REFERENCES department (department_id);

--
-- Constraints for table nurse
--
ALTER TABLE nurse
  ADD CONSTRAINT fk_nurse_staff FOREIGN KEY (staff_ssn) REFERENCES staff (ssn) ON DELETE CASCADE,
  ADD CONSTRAINT fk_nurse_department FOREIGN KEY (department_id) REFERENCES department (department_id);

--
-- Constraints for table emergency_contact
--
ALTER TABLE emergency_contact
  ADD CONSTRAINT fk_emergency_contact_patient FOREIGN KEY (patient_ssn) REFERENCES patient (ssn) ON DELETE CASCADE;

--
-- Constraints for table shift_participation
--
ALTER TABLE shift_participation
  ADD CONSTRAINT fk_sv_staff FOREIGN KEY (staff_ssn) REFERENCES staff (ssn) ON DELETE CASCADE,
  ADD CONSTRAINT fk_sv_shift FOREIGN KEY (shift_id) REFERENCES shift (shift_id) ON DELETE CASCADE;

--
-- Constraints for table prescription
--
ALTER TABLE prescription
  ADD CONSTRAINT fk_syn_patient FOREIGN KEY (patient_ssn) REFERENCES patient (ssn),
  ADD CONSTRAINT fk_syn_medication FOREIGN KEY (medication_id) REFERENCES medication (medication_id),
  ADD CONSTRAINT fk_syn_doctor FOREIGN KEY (doctor_ssn) REFERENCES doctor (ssn),
  ADD CONSTRAINT fk_syn_hospitalization FOREIGN KEY (hospitalization_id) REFERENCES hospitalization (hospitalization_id);

--
-- Constraints for table department
--
ALTER TABLE department
  ADD CONSTRAINT fk_department_dieutintis FOREIGN KEY (director_ssn) REFERENCES doctor (ssn) ON DELETE SET NULL;

--
-- Constraints for table shift
--
ALTER TABLE shift
  ADD CONSTRAINT fk_shift_department FOREIGN KEY (department_id) REFERENCES department (department_id);

--
-- Constraints for table procedure_assistant
--
ALTER TABLE procedure_assistant
  ADD CONSTRAINT fk_vp_praxi FOREIGN KEY (procedure_id) REFERENCES medical_procedure (procedure_id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_vp_staff FOREIGN KEY (assistant_ssn) REFERENCES staff (ssn);
COMMIT;

DELIMITER //
CREATE TRIGGER trg_no_circular_supervision
BEFORE INSERT ON doctor
FOR EACH ROW
BEGIN
    DECLARE supervisor_id CHAR(11);
    DECLARE depth INT DEFAULT 0;
    SET supervisor_id = NEW.supervisor_ssn;
    WHILE supervisor_id IS NOT NULL AND depth < 100 DO
        IF supervisor_id = NEW.ssn THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Circular supervision chain is not allowed';
        END IF;
        SELECT supervisor_ssn INTO supervisor_id FROM doctor WHERE ssn = supervisor_id;
        SET depth = depth + 1;
    END WHILE;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_resident_must_have_supervisor
BEFORE INSERT ON doctor
FOR EACH ROW
BEGIN
    IF NEW.rank = 'RESIDENT' AND NEW.supervisor_ssn IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A resident must have a supervisor';
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER trg_director_no_supervisor
BEFORE INSERT ON doctor
FOR EACH ROW
BEGIN
    IF NEW.rank = 'DIRECTOR' AND NEW.supervisor_ssn IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A director cannot have a supervisor';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_no_allergy_prescription
BEFORE INSERT ON prescription
FOR EACH ROW
BEGIN
    DECLARE allergy_count INT;
    SELECT COUNT(*) INTO allergy_count
    FROM allergy al
    JOIN medication_substance ms ON al.substance_id = ms.substance_id
    WHERE al.patient_ssn = NEW.patient_ssn
    AND ms.medication_id = NEW.medication_id;
    IF allergy_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot prescribe: patient has allergy to active substance';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_max_shifts_per_month
BEFORE INSERT ON shift_participation
FOR EACH ROW
BEGIN
    DECLARE shift_count INT;
    DECLARE staff_type ENUM('DOCTOR','NURSE','ADMINISTRATIVE');
    DECLARE max_shifts INT;
    DECLARE shift_date DATE;

    SELECT s.type INTO staff_type FROM staff s WHERE s.ssn = NEW.staff_ssn;
    SELECT sh.date INTO shift_date FROM shift sh WHERE sh.shift_id = NEW.shift_id;

    SET max_shifts = CASE staff_type
        WHEN 'DOCTOR' THEN 15
        WHEN 'NURSE' THEN 20
        WHEN 'ADMINISTRATIVE' THEN 25
    END;

    SELECT COUNT(*) INTO shift_count
    FROM shift_participation sp
    JOIN shift sh ON sp.shift_id = sh.shift_id
    WHERE sp.staff_ssn = NEW.staff_ssn
    AND YEAR(sh.date) = YEAR(shift_date)
    AND MONTH(sh.date) = MONTH(shift_date);

    IF shift_count >= max_shifts THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Maximum shifts per month exceeded';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_min_rest_between_shifts
BEFORE INSERT ON shift_participation
FOR EACH ROW
BEGIN
    DECLARE last_end DATETIME;
    DECLARE new_start DATETIME;
    DECLARE hours_diff INT;

    SELECT TIMESTAMP(sh.date, sh.end_time) INTO last_end
    FROM shift_participation sp
    JOIN shift sh ON sp.shift_id = sh.shift_id
    WHERE sp.staff_ssn = NEW.staff_ssn
    ORDER BY TIMESTAMP(sh.date, sh.end_time) DESC
    LIMIT 1;

    SELECT TIMESTAMP(sh.date, sh.start_time) INTO new_start
    FROM shift sh WHERE sh.shift_id = NEW.shift_id;

    IF last_end IS NOT NULL THEN
        SET hours_diff = TIMESTAMPDIFF(HOUR, last_end, new_start);
        IF hours_diff < 8 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Minimum 8 hours rest required between shifts';
        END IF;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER trg_max_consecutive_night_shifts
BEFORE INSERT ON shift_participation
FOR EACH ROW
BEGIN
    DECLARE night_count INT DEFAULT 0;
    DECLARE shift_type ENUM('MORNING','AFTERNOON','NIGHT');

    SELECT sh.type INTO shift_type FROM shift sh WHERE sh.shift_id = NEW.shift_id;

    IF shift_type = 'NIGHT' THEN
        SELECT COUNT(*) INTO night_count
        FROM shift_participation sp
        JOIN shift sh ON sp.shift_id = sh.shift_id
        WHERE sp.staff_ssn = NEW.staff_ssn
        AND sh.type = 'NIGHT'
        AND sh.date >= DATE_SUB(
            (SELECT date FROM shift WHERE shift_id = NEW.shift_id), 
            INTERVAL 3 DAY
        );

        IF night_count >= 3 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Maximum 3 consecutive night shifts exceeded';
        END IF;
    END IF;
END //
DELIMITER ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

SET FOREIGN_KEY_CHECKS = 1;
COMMIT;