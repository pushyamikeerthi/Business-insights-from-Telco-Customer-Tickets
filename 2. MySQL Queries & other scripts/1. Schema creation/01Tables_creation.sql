-- Telco Customer Service Request Database Schema
-- Version 1.0

-- Copyright (c) 2018,
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are not permitted

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
													# SCHEMA CREATION
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';
DROP DATABASE telco_sr;
CREATE DATABASE IF NOT EXISTS telco_sr;
CREATE SCHEMA telco_sr;
USE telco_sr;
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
													# TABLES CREATION
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
DROP TABLE IF EXISTS customer_type;
CREATE TABLE customer_type (
    customer_type_id SMALLINT(15) UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_type VARCHAR(45) NOT NULL,
    sla_days SMALLINT(15) UNSIGNED,
    PRIMARY KEY (customer_type_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS sr_source;
CREATE TABLE sr_source (
    source_id SMALLINT(15) UNSIGNED NOT NULL,
    source_desc VARCHAR(100),
    PRIMARY KEY (source_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS technology;
CREATE TABLE technology (
    technology_id SMALLINT(15) UNSIGNED NOT NULL AUTO_INCREMENT,
    technology_desc VARCHAR(45) NOT NULL,
    PRIMARY KEY (technology_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;



DROP TABLE IF EXISTS issue_type;
CREATE TABLE issue_type (
    issue_id SMALLINT(15) UNSIGNED NOT NULL AUTO_INCREMENT,
    issue_desc VARCHAR(45) NOT NULL,
    PRIMARY KEY (issue_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;

DROP TABLE IF EXISTS resolution_category;
CREATE TABLE resolution_category (
    resolution_id SMALLINT(15) UNSIGNED NOT NULL AUTO_INCREMENT,
    resolution_desc VARCHAR(45) NOT NULL,
    PRIMARY KEY (resolution_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;



DROP TABLE IF EXISTS sr_location;
CREATE TABLE sr_location (
sr_loc_id SMALLINT(15) UNSIGNED NOT NULL AUTO_INCREMENT ,
sr_location VARCHAR(100) NOT NULL,
PRIMARY KEY (sr_loc_id)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;




DROP TABLE IF EXISTS customer_class;
CREATE TABLE customer_class (
cust_class_id SMALLINT(15) UNSIGNED NOT NULL AUTO_INCREMENT ,
cust_class_desc VARCHAR(100) NOT NULL,
PRIMARY KEY (cust_class_id)
)ENGINE=INNODB DEFAULT CHARSET=UTF8;



DROP TABLE IF EXISTS customer;

CREATE TABLE customer (
    customer_id INT(15) UNSIGNED NOT NULL AUTO_INCREMENT,
    customer_name VARCHAR(250) NOT NULL,
    customer_type_id SMALLINT(15) UNSIGNED NOT NULL,
    cust_class_id SMALLINT(15) UNSIGNED NOT NULL,
    last_update DATE,
    PRIMARY KEY (customer_id , last_update),
    CONSTRAINT fk_cust_class_id FOREIGN KEY (cust_class_id)
        REFERENCES customer_class (cust_class_id),
    CONSTRAINT fk_customer_type FOREIGN KEY (customer_type_id)
        REFERENCES customer_type (customer_type_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;


DROP TABLE IF EXISTS sr_details;

CREATE TABLE sr_details (
    sr_id INT(45) UNSIGNED NOT NULL AUTO_INCREMENT,
    sr_status VARCHAR(45) NOT NULL,
    customer_id INT(15) UNSIGNED NOT NULL,
    sr_date DATE,
    sr_month VARCHAR(50),
    resolution_date DATE,
    estimated_resolution_date DATE,
    source_id SMALLINT(15) UNSIGNED,
    resolution_id SMALLINT(15) UNSIGNED,
    technology_id SMALLINT(15) UNSIGNED,
    issue_id SMALLINT(15) UNSIGNED,
    sr_loc_id SMALLINT(15) UNSIGNED,
    sla_days SMALLINT(4),
    actual_sla_days SMALLINT(15),
    on_holddate DATE,
    PRIMARY KEY (sr_id),
    CONSTRAINT fk_source_id FOREIGN KEY (source_id)
        REFERENCES sr_source (source_id),
    CONSTRAINT fk_resolution_category FOREIGN KEY (resolution_id)
        REFERENCES resolution_category (resolution_id),
    CONSTRAINT fk_technology_id FOREIGN KEY (technology_id)
        REFERENCES technology (technology_id),
    CONSTRAINT fk_issue_id FOREIGN KEY (issue_id)
        REFERENCES issue_type (issue_id),
    CONSTRAINT fk_customer_id FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id),
    CONSTRAINT fk_sr_loc_id FOREIGN KEY (sr_loc_id)
        REFERENCES sr_location (sr_loc_id)
)  ENGINE=INNODB DEFAULT CHARSET=UTF8;










