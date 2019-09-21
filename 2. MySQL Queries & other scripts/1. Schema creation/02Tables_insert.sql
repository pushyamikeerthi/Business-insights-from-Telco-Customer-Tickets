-- Telco Customer Service Request Database Schema
-- Version 1.0

-- Copyright (c) 2018,
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are not permitted

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
													# DATA CREATION
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################

INSERT customer_class values
(1,'Corporate'),
(2,'Gold'),
(3,'Individual'),
(4,'Key'),
(5,'Medium Enterprise'),
(6,'Micro'),
(7,'Small Enterprise'),
(8,'Test Card'),
(9,'Platinum'),
(10,'Solitaire');

INSERT sr_location values 
(1,'Colaba, Nariman Point'),
(2,'Marine Lines'),
(3,'Grant Road, Mumbai Central, Tardeo'),
(4,'Bhyculla, Dockward'),
(5,'Lower Parel, Worli'),
(6,'Wadala, Dadar, Sewri, Matunga'),
(7,'Bandra, Khar'),
(8,'Dharavi, Sion'),
(9,'Santacruz'),
(10,'Kurla, Chunnabhatti'),
(11,'Juhu, Vile Parle, Andheri East'),
(12,'Jogeshwari, Andheri MIDC, Saki Naka'),
(13,'Goregaon East &  West'),
(14,'Malad East & West'),
(15,'Kandivli East & West'),
(16,'Mira Road,  Bhayander'),
(17,'Chembur, Mankhur, Trombay'),
(18,'Powai, Chandivali'),
(19,'Bhandup, Mulund'),
(20,'Thane /  Ghodbandar'),
(21,'Thane, Kalwa'),
(22,'Mumbar, Diva, Dombivli'),
(23,'Gansoli, Airoli, Koparkhairane'),
(24,'Vashi, Turbe, Sanpada, Nerul'),
(25,'Belapur, Uran, Panvel'),
(26,'Thakurli, Kalyan, Titwala'),
(27,'Turbe, Kalamboli'),
(28,'Dahisar, Borivali'),
(29,'Ghatkopar, Vikroli, Vidhyavihar'),
(30,'Rest of locations');

INSERT  resolution_category VALUES
('1','Other_Issue'),
('2','Network_issue'),
('3','Restiction/Limitations'),
('4','No_Issue_Diagnosed'),
('5','Device_issues'),
('6','Customer_Denial');


INSERT issue_type VALUES
('1','Voice_issue'),
('2','Data_Issues'),
('3','VoLTE_issue'),
('4','Roaming_issues'),
('5','Other_issues');

INSERT technology VALUES
('1','2G'),
('2','3G'),
('3','4G'),
('4','Roaming_issues'),
('5','Other_issues');


INSERT sr_source VALUES
('1','Telco_Road_Survey'),
('2','Telco_Toll_Free_Call_Center'),
('3','Corporate_Account_issue'),
('4','Telco_Stores'),
('5','3rd_Party_Retail_Stores'),
('6','Social_Media'),
('7','Port_Out_Threat-retention_desk'),
('8','VIP_escalation');




INSERT customer_type VALUES
(1,'Platinum',4),
(2,'Gold',5),
(3,'Solitaire',3);
