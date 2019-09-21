-- Telco Customer Service Request Database Schema
-- Version 1.0

-- Copyright (c) 2018,
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are not permitted

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
													# 02-Location Vs SRs
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###########################################################
use telco_sr;

#2(A)SR Status Vs Locations
create or replace view vw_loc_srs as
SELECT sr_loc_id,
sum(case when sr_status = "On Hold" then 1 else 0 end) as no_hold,
sum(case when sr_status = "Open" then 1 else 0 end) as no_open,
sum(case when sr_status = "Resolved" then 1 else 0 end) as no_resolved,
count(sr_id) as no_sr,
sum(case when sr_status = "Resolved" then 1 else 0 end)/count(sr_id) as per_resolved,
0 as rank_resolved,
sum(case when sr_status = "Open" then 1 else 0 end)/count(sr_id) as per_open,
0 as rank_open,
sum(case when sr_status = "On Hold" then 1 else 0 end)/count(sr_id) as per_hold,
0 as rank_hold,
sum(case when sr_status in ("Open","On Hold") then 1 else 0 end)/count(sr_id) as per_not_resolved,
0 as rank_not_resolved,
sum(case when issue_id = 1 then 1 else 0 end)/count(sr_id) as per_it_voice,
sum(case when issue_id = 2 then 1 else 0 end)/count(sr_id) as per_it_data
from sr_details
where sr_loc_id != 30
group by sr_loc_id
order by sr_loc_id;
 

SELECT a1.sr_loc_id,sr_location,
no_hold, no_open, no_resolved, no_sr, per_resolved,
rank() over (order by per_resolved desc) as rank_resolved,
per_open, rank() over (order by per_open desc) as rank_open,
per_hold, rank() over (order by per_hold desc) as rank_hold,
per_not_resolved, rank() over (order by per_not_resolved desc) as rank_not_resolved,
per_it_voice,per_it_data
from vw_loc_srs as a1 
left join sr_location as a2 on a1.sr_loc_id = a2.sr_loc_id
order by a1.sr_loc_id;

##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* ## 2(A)SR Status Vs Locations
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################

#2(B) Not Resolved SRs[Open+On-Hold] Month On Month

SELECT a1.sr_loc_id,a2.sr_location,
sum(case when year(sr_date)*100+month(sr_date) = 201804 then 1 else 0 end) as Apr2018,
sum(case when year(sr_date)*100+month(sr_date) = 201805 then 1 else 0 end) as May2018,
sum(case when year(sr_date)*100+month(sr_date) = 201806 then 1 else 0 end) as Jun2018,
sum(case when year(sr_date)*100+month(sr_date) = 201807 then 1 else 0 end) as Jul2018,
sum(case when year(sr_date)*100+month(sr_date) = 201808 then 1 else 0 end) as Aug2018,
sum(case when year(sr_date)*100+month(sr_date) = 201809 then 1 else 0 end) as Sep2018,
sum(case when year(sr_date)*100+month(sr_date) = 201810 then 1 else 0 end) as Oct2018,
count(sr_id) as Total
from sr_details as a1 left join sr_location as a2 using (sr_loc_id) 
where sr_status in ("Open", "On Hold") and year(sr_date)*100+month(sr_date) <= 201810 
group by a1.sr_loc_id,a2.sr_location
order by a1.sr_loc_id;

##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* #2(B) Not Resolved SRs[Open+On-Hold] Month On Month
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
 
#2(C) Resolved SRs Month On Month
SELECT a1.sr_loc_id,a2.sr_location,
sum(case when year(sr_date)*100+month(sr_date) = 201804 then 1 else 0 end) as  Apr2018,
sum(case when year(sr_date)*100+month(sr_date) = 201805 then 1 else 0 end) as  May2018,
sum(case when year(sr_date)*100+month(sr_date) = 201806 then 1 else 0 end) as  Jun2018,
sum(case when year(sr_date)*100+month(sr_date) = 201807 then 1 else 0 end) as  Jul2018,
sum(case when year(sr_date)*100+month(sr_date) = 201808 then 1 else 0 end) as  Aug2018,
sum(case when year(sr_date)*100+month(sr_date) = 201809 then 1 else 0 end) as  Sep2018,
sum(case when year(sr_date)*100+month(sr_date) = 201810 then 1 else 0 end) as  Oct2018,
count(sr_id) as Total
from sr_details as a1 left join sr_location as a2 using (sr_loc_id) 
where sr_status in ("Resolved") and year(sr_date)*100+month(sr_date) <= 201810 
group by a1.sr_loc_id,a2.sr_location
order by Total desc;    


##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* #2(C) Resolved SRs Month On Month
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################