-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Regions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Regions` (
   `region_id` INT NOT NULL AUTO_INCREMENT,
   `region_name` VARCHAR(255) NOT NULL,
   PRIMARY KEY (`region_id`)
) ENGINE = InnoDB;
-- Inserting data into Regions

INSERT INTO Regions (region_name) VALUES
('Northern Region'),
('Capital City'),
('Eastern Region');


-- -----------------------------------------------------
-- Table `mydb`.`patients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`patients` (
  `patient_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `age` INT NOT NULL,
  `gender` ENUM('M', 'F') NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `region_id` INT NOT NULL,
  PRIMARY KEY (`patient_id`),
  INDEX `fk_patients_Regions_idx` (`region_id` ASC) VISIBLE,
  CONSTRAINT `fk_patients_Regions`
    FOREIGN KEY (`region_id`)
    REFERENCES `mydb`.`Regions` (`region_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Inserting data into Patients
INSERT INTO patients (name, age, address, region_id) VALUES
('Alice Johnson', 28, '123 Rural Lane', 1),
('Maria Gonzales', 34, '456 City Center', 2),
('Nina Patel', 22, '789 Countryside Blvd', 3);


-- -----------------------------------------------------
-- Table `mydb`.`Healthcare_Facilities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Healthcare_Facilities` (
  `facility_id` INT NULL AUTO_INCREMENT,
  `facility_name` VARCHAR(255) NOT NULL,
  `facility_type` VARCHAR(100) NOT NULL,
  `region_id` INT NULL,
  `Regions_region_id` INT NOT NULL,
  PRIMARY KEY (`facility_id`, `Regions_region_id`),
  INDEX `fk_Healthcare_Facilities_Regions1_idx` (`Regions_region_id` ASC, `region_id` ASC) VISIBLE,
  CONSTRAINT `fk_Healthcare_Facilities_Regions1`
    FOREIGN KEY (`Regions_region_id` , `region_id`)
    REFERENCES `mydb`.`Regions` (`region_id` , `region_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Inserting data into Healthcare_Facilities
INSERT INTO Healthcare_Facilities (facility_name, facility_type, region_id) VALUES 
('Rural Hospital', 'Hospital', 1), 
('City Clinic', 'Clinic', 2), 
('Eastern Health Center', 'Health Center', 3);

-- -----------------------------------------------------
-- Table `mydb`.`Healthcare_providers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Healthcare_providers` (
  `provider_id` INT NOT NULL AUTO_INCREMENT,
  `provider_name` VARCHAR(255) NOT NULL,
  `specialty` VARCHAR(255) NOT NULL,
  `facility_id` INT NOT NULL,
  PRIMARY KEY (`provider_id`),
  INDEX `fk_Healthcare_providers_Healthcare_Facilities1_idx` (`facility_id` ASC),
  CONSTRAINT `fk_Healthcare_providers_Healthcare_Facilities1`
    FOREIGN KEY (`facility_id`)
    REFERENCES `mydb`.`Healthcare_Facilities` (`facility_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Inserting data into Healthcare_Providers
INSERT INTO Healthcare_providers (provider_name, specialty, facility_id) VALUES
('Dr. Smith', 'Obstetrics', 1),
('Nurse Kelly', 'Midwifery', 2),
('Dr. Lee', 'Gynecology', 3);


-- -----------------------------------------------------
-- Table `mydb`.`Visits`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Visits` (
  `visit_id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `facility_id` INT NOT NULL,
  `provider_id` INT NOT NULL,
  `visit_date` DATE NOT NULL,
  `reason_for_visit` TEXT NOT NULL,
  PRIMARY KEY (`visit_id`, `patient_id`, `facility_id`, `provider_id`),
  INDEX `fk_Visits_patients1_idx` (`patient_id` ASC),
  INDEX `fk_Visits_Healthcare_Facilities1_idx` (`facility_id` ASC),
  INDEX `fk_Visits_Healthcare_providers1_idx` (`provider_id` ASC),
  CONSTRAINT `fk_Visits_patients1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `mydb`.`Patients` (`patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Visits_Healthcare_Facilities1`
    FOREIGN KEY (`facility_id`)
    REFERENCES `mydb`.`Healthcare_Facilities` (`facility_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Visits_Healthcare_providers1`
    FOREIGN KEY (`provider_id`)
    REFERENCES `mydb`.`Healthcare_Providers` (`provider_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

INSERT INTO Visits (patient_id, facility_id, provider_id, visit_date, reason_for_visit) 
VALUES 
(1, 1, 1, '2023-08-01', 'Prenatal Checkup'), 
(2, 2, 2, '2023-08-02', 'Ultrasound'), 
(3, 3, 3, '2023-08-03', 'Blood Test');


-- -----------------------------------------------------
-- Table `mydb`.`Treatments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Treatments` (
  `treatment_id` INT NOT NULL AUTO_INCREMENT,
  `visit_id` INT NOT NULL,
  `treatment_name` VARCHAR(255) NOT NULL,
  `treatment_cost` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`treatment_id`),
  INDEX `fk_Treatments_Visits_idx` (`visit_id`),
  CONSTRAINT `fk_Treatments_Visits`
    FOREIGN KEY (`visit_id`)
    REFERENCES `mydb`.`Visits` (`visit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Inserting data into Treatments
INSERT INTO Treatments (visit_id, treatment_name, treatment_cost) VALUES
(1, 'Prenatal Checkup', 100.00),
(2, 'Ultrasound', 150.00),
(3, 'Blood Test', 50.00);


-- -----------------------------------------------------
-- Table `mydb`.`Complications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Complications` (
   `complication_id` INT NOT NULL AUTO_INCREMENT,
   `patient_id` INT NULL,
   `complication_name` VARCHAR(255) NOT NULL,
   `complication_date` DATE NOT NULL,
   `visit_id` INT NULL,
   PRIMARY KEY (`complication_id`),
   CONSTRAINT `fk_Complications_Patient`
       FOREIGN KEY (`patient_id`)
       REFERENCES `mydb`.`Patients` (`patient_id`)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION,
   CONSTRAINT `fk_Complications_Visit`
       FOREIGN KEY (`visit_id`)
       REFERENCES `mydb`.`Visits` (`visit_id`)
       ON DELETE NO ACTION
       ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- Inserting data into Complications
INSERT INTO Complications (patient_id, complication_name,  complication_date) VALUES
(1, 'Gestational Diabetes',  '2023-08-05'),
(2, 'High Blood Pressure',  '2023-08-06'),
(3, 'Preterm Labor',  '2023-08-07');

-- SQL programming
-- Retrieve All Patients with Their Regions
SELECT 
    p.patient_id,
    p.name AS patient_name,
    p.age,
    p.address,
    r.region_name AS region
FROM 
    patients p
JOIN 
    Regions r ON p.region_id = r.region_id;
-- Total Number of Patients per Region
SELECT 
    r.region_name,
    COUNT(p.patient_id) AS total_patients
FROM 
    patients p
JOIN 
    Regions r ON p.region_id = r.region_id
GROUP BY 
    r.region_name;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
