-- Telco Customer Service Request Database Schema
-- Version 1.0

-- Copyright (c) 2018,
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are not permitted

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
													# 04-SLAdays Vs SRs-Issue Type
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###########################################################
use telco_sr;

# (4A)Total SRs ,Resolved_Srs(hold and not hold) VS month by month

 create or replace view vw_count_all as 
 select 0 as issue_id, sr_month,
 count(sr_id) as Total_Srs,
 sum(case when sr_status = "Resolved" then 1 else 0 end) as Resolved_Srs,
 sum(case when sr_status = "Resolved" then 1 else 0 end)/count(sr_id) *100 as Resolved_srs_percent,
 sum(case when sr_status = "Resolved" and on_holddate > 0 then 1 else 0 end) as Resolved_with_hold_Srs,
 sum(case when sr_status = "Resolved" and on_holddate > 0 then 1 else 0 end)/count(sr_id) *100
																			as Resolved_with_hold_Srs_percent,
 (sum(case when sr_status = "Resolved" then 1 else 0 end))
 - (sum(case when sr_status = "Resolved" and on_holddate > 0 then 1 else 0 end)) as Resolved_with_no_hold_Srs,
 ((sum(case when sr_status = "Resolved" then 1 else 0 end))
 - (sum(case when sr_status = "Resolved" and on_holddate > 0 then 1 else 0 end)))/count(sr_id) *100 
																			as Resolved_with_no_hold_Srs_percent
                                                                            
 from sr_details
 group by sr_month
 order by sr_month;
 
 select * from vw_count_all;
 
  ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* (4A)Total SRs ,Resolved_Srs(hold and not hold) VS month by month
  OBSERVATION :  
  Note :For resolved SRs , SLA days is ranging from 1 to 200+ days.
		Observed that high SLA days are due to long holds (which is captured by hold_date >0)
		Noted that there is no activity during hold date ,however unable to calculate the hold period 
        for each SR id from given data .
        Hence we assumed that SLA days should be capped to 14 days for these resolved and hold cases

Avg SRs resolved is showing a high decrease in value from Apr 2108 to Oct 2018 . 
The reason for high decrease in Sla days is due to the proportion of resolved cases with hold are relative high 
in April and trending to 0 in oct 2018 .
 Most of these resolved with hold cases are with Sla=14 impacting resolved cases.
Hence the analysis is segmented into resolved cases with hold and resolved cases with no hold 
*/
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  
  
 #(4B) COUNT OF RESOLVED SRs AND AVERAGE SLA DAYS Vs ISSUE_TYPE BY MONTH ON MONTH
 
 create or replace view vw_count_by_issuetype as 
 select issue_desc, sr_month,
 count(sr_id) as Total_Srs,
  sum(case when sr_status = "Resolved" then 1 else 0 end) as Resolved_Srs,
 sum(case when sr_status = "Resolved" then sla_days else 0 end) as SLAdays_Res
 from sr_details
 left join  issue_type using(issue_id)
 group by issue_id, sr_month
 order by issue_desc, sr_month
 ;
 
 select *,
 (SLAdays_Res/Resolved_srs ) as avg_SLAdays_Res
 from vw_count_by_issuetype
  group by issue_desc, sr_month
 order by issue_desc, sr_month
 ;
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* (4B) COUNT OF RESOLVED SRs AND AVERAGE SLA DAYS Vs ISSUE_TYPE BY MONTH ON MONTH
  OBSERVATION :  
Avg SLA days is showing a high decrease in value from Apr 2108 to Oct 2018 compared with number of SRs resolved
for each issue type .
The reason for high decrease in Sla days is due to the proportion of resolved cases with hold are relative high 
in April and trending to 0 in oct 2018 for each Issue type.
 Most of these resolved with hold cases are with Sla=14 impacting the avg sla for resolved cases.
Hence the analysis is segmented into resolved cases with hold and resolved cases with no hold 
*/
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  
  

# (4C) AVERAGE SLA DAYS SPENT ON RESOLVED SRs WITH NO HOLD AND HOLD Vs SLA DAYS BY MONTH ON MONTH

create or replace view vw_resolved_by_issuetype as 
 select issue_desc,issue_id, sr_month,
 count(sr_id) as Total_Srs,
 sum(case when sr_status = "Resolved" and on_holddate > 0 then 1 else 0 end) as Res_with_hold_sr,
 (sum(case when sr_status = "Resolved" then 1 else 0 end))
 -  (sum(case when sr_status = "Resolved" and on_holddate > 0 then 1 else 0 end)) as Res_with_no_hold_sr,
 sum(case when sr_status = "Resolved" and on_holddate > 0 then sla_days else 0 end) as SLAdays_Res_with_hold,
 (sum(case when sr_status = "Resolved" then sla_days else 0 end))
 - (sum(case when sr_status = "Resolved" and on_holddate > 0 then sla_days else 0 end)) as SLAdays_Res_with_no_hold
  from sr_details
  left join  issue_type using(issue_id)
 group by issue_id, sr_month
 order by issue_id, sr_month
 ;
 
 select *,
 (SLAdays_Res_with_hold/Res_with_hold_sr) as avg_SLAdays_Res_with_hold,
 (SLAdays_Res_with_no_hold/Res_with_no_hold_sr) as avg_SLAdays_Res_with_no_hold
  from vw_resolved_by_issuetype
  group by issue_desc, sr_month
 order by issue_desc, sr_month
 ;

##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
/*
(4C) AVERAGE SLA DAYS SPENT ON RESOLVED SRs WITH NO HOLD AND HOLD BY MONTH ON MONTH:
  OBSERVATION : 
  Resolved cases with hold :
	Observed that avg sla time of Resolved cases with hold for each issue type over the period is around 14 .
	This is due to capping of sla days at 14. 
  Resolved cases with no hold :
	Noted the avg sla time is increasing from apr to oct for all issue types
*/
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################

# (4D) RESOLVED CASES WITH NO HOLD Vs SLA DAYS

 create or replace view vw_nohold_summary as
 select a.issue_desc,
 sum(case when a.sr_month <= 201809 then a.Total_Srs else 0 end) as obs_total_srs,
 sum(case when a.sr_month <= 201809 then a.Resolved_srs else 0 end) as obs_Resolved_Srs,
 sum(case when b.sr_month <= 201809 then Res_with_hold_sr else 0 end) as obs_Resolved_with_hold_Srs,
 sum(case when b.sr_month <= 201809 then Res_with_no_hold_sr else 0 end) as obs_Resolved_with_no_hold_Srs,
 sum(case when b.sr_month <= 201809 then SLAdays_Res_with_no_hold else 0 end) as obs_Resolved_with_no_hold_Srs_sla,
  
 sum(case when a.sr_month = 201810 then a.Total_Srs else 0 end) as tst_total_srs,
 sum(case when a.sr_month = 201810 then Resolved_srs else 0 end) as tst_Resolved_Srs,
 sum(case when b.sr_month = 201810 then Res_with_hold_sr else 0 end) as tst_Resolved_with_hold_Srs,
 sum(case when b.sr_month = 201810 then Res_with_no_hold_sr else 0 end) as tst_Resolved_with_no_hold_Srs,
 sum(case when b.sr_month = 201810 then SLAdays_Res_with_no_hold else 0 end) as tst_Resolved_with_no_hold_Srs_sla
 
 from vw_count_by_issuetype a,vw_resolved_by_issuetype b
 where a.issue_desc = b.issue_desc
 and a.sr_month =b.sr_month
 group by a.issue_desc
 order by a.issue_desc;
 select  * from vw_nohold_summary;
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
 /*
    (4D) RESOLVED SRs WITH NO HOLD Vs SLA DAYS
  OBSERVATION : 
  To examine the actual increase in sla days in recent times, 
		1) A sample of observation is prepared against the six months sample from April to September 
		2) A test sample is prepared against October data .
*/
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################

#(4E)CALCULATING SLA TIME BY EACH SCENARIO FOR PERIOD APR-SEPT AS OBSERVATION SAMPLE

create or replace view vw_nohold_summary_obs as
select issue_desc,
obs_total_srs,
obs_Resolved_Srs,
obs_Resolved_with_no_hold_Srs,
obs_Resolved_with_no_hold_Srs/obs_total_srs as obs_Resolved_with_no_hold_Srs_per,
obs_Resolved_with_no_hold_Srs_sla,
obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs as obs_Resolved_with_no_hold_Srs_sla_avg,

0.80 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S01,
0.85 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S02,
0.90 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S03,
0.95 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S04,
1.00 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S05,
1.05 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S06,
1.10 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S07,
1.15 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S08,
1.20 * (obs_Resolved_with_no_hold_Srs_sla/obs_Resolved_with_no_hold_Srs) as obs_S09,

tst_total_srs,
tst_Resolved_Srs,
tst_Resolved_with_no_hold_Srs,
tst_Resolved_with_no_hold_Srs/tst_total_srs as tst_Resolved_with_no_hold_Srs_per,
tst_Resolved_with_no_hold_Srs_sla,
tst_Resolved_with_no_hold_Srs_sla/tst_Resolved_with_no_hold_Srs as tst_Resolved_with_no_hold_Srs_avg
from vw_nohold_summary;
select  * from vw_nohold_summary_obs;
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
/*(4E)CALCULATING SLA TIME BY EACH SCENARIO FOR PERIOD APR-SEPT AS OBSERVATION SAMPLE
OBSERVATION : 
Preparing Average SLA time for each issue type with each scenario defined based on avg sla time of observation 
period(Apr-Sept) with an increment on avg sla ranging from -20% to 20% by 5% 
*/
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################

#(4F)CALCULATING SLA TIME BY EACH SCENARIO FOR PERIOD OCTOBER AS TEST SAMPLE
create or replace view vw_nohold_summary_test as
select *,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S01) as tst_S01,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S02) as tst_S02,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S03) as tst_S03,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S04) as tst_S04,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S05) as tst_S05,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S06) as tst_S06,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S07) as tst_S07,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S08) as tst_S08,
tst_Resolved_with_no_hold_Srs_sla - (tst_Resolved_with_no_hold_Srs * obs_S09) as tst_S09
from vw_nohold_summary_obs;

select  * from vw_nohold_summary_test;
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
/*(4F)CALCULATING SLA TIME BY EACH SCENARIO FOR PERIOD OCTOBER AS TEST SAMPLE
OBSERVATION : 
Preparing Average SLA time for each issue type with each scenario defined based on avg sla time of testing 
period(OCTOBER) with an increment on avg sla ranging from -20% to 20% by 5% 
*/
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
 
 #(4G) PERFORMACE BASED ON SLA DAYS ON TEST SAMPLE

 create or replace view vw_summary_avgsladays as 
 select * from vw_nohold_summary_test
 union
 (select 0 as issue_desc,
 sum(obs_total_srs), 
sum(obs_Resolved_Srs),
sum(obs_Resolved_with_no_hold_Srs),
sum(obs_Resolved_with_no_hold_Srs)/sum(obs_total_srs) as obs_Resolved_with_no_hold_Srs_per,
sum(obs_Resolved_with_no_hold_Srs_sla),
sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs) as obs_Resolved_with_no_hold_Srs_sla_avg,

0.80 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S01,
0.85 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S02,
0.90 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S03,
0.95 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S04,
1.00 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S05,
1.05 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S06,
1.10 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S07,
1.15 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S08,
1.20 * (sum(obs_Resolved_with_no_hold_Srs_sla)/sum(obs_Resolved_with_no_hold_Srs)) as obs_S09,

sum(tst_total_srs),
sum(tst_Resolved_Srs),
sum(tst_Resolved_with_no_hold_Srs),
sum(tst_Resolved_with_no_hold_Srs)/sum(tst_total_srs) as tst_Resolved_with_no_hold_Srs_per,
sum(tst_Resolved_with_no_hold_Srs_sla),
sum(tst_Resolved_with_no_hold_Srs_sla)/sum(tst_Resolved_with_no_hold_Srs) as tst_Resolved_with_no_hold_Srs_sla_avg,

sum(tst_S01) as tst_S01,
sum(tst_S02) as tst_S02,
sum(tst_S03) as tst_S03,
sum(tst_S04) as tst_S04,
sum(tst_S05) as tst_S05,
sum(tst_S06) as tst_S06,
sum(tst_S07) as tst_S07,
sum(tst_S08) as tst_S08,
sum(tst_S09) as tst_S09

from vw_nohold_summary_test
);

select * from vw_summary_avgsladays;
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
 
 #(4G) PERFORMACE BASED ON SLA DAYS ON TEST SAMPLE
 /*
 OBSERVATION:
 Noted saving in sla times for the month of oct 2018 for each scenario 1 to 4 in the range from 
 3390 to 708 days .
 */
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
 #(4H) SLA days vs no of SRs

select distinct sla_days , count(sr_id)
from sr_details
group by sla_days
having sla_days is not null
order by sla_days 

#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
 
 #(4H) SLA days vs no of SRs
 /*
 OBSERVATION:
 Maximum SLa days taken for is 2-4 days.
 */
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################

