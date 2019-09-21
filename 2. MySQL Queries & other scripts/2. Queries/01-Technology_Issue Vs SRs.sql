-- Telco Customer Service Request Database Schema
-- Version 1.0

-- Copyright (c) 2018,
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are not permitted

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
													# 01-Technology&Issue Vs SRs
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###########################################################
use telco_sr;

# 1(a) TECHONOLY & ISSUES Vs NUMBER of SRs


SELECT 
    a.*, 100 * a.total_sr / b.total AS percent_sr
FROM
    (SELECT 
        t.technology_desc,
            it.issue_desc,
            COUNT(sd.sr_id) AS total_sr
    FROM
        sr_details sd
    LEFT JOIN technology t ON sd.technology_id = t.technology_id
    LEFT JOIN issue_type it ON sd.issue_id = it.issue_id
    GROUP BY t.technology_desc , it.issue_desc) AS a,
    (SELECT 
        COUNT(*) AS total
    FROM
        sr_details) AS b
ORDER BY technology_desc , issue_desc,total_sr	;
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* ## 1(a) TECHONOLY & ISSUES Vs NUMBER of SRs
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
#1(b)Issue Type/Technology vs No. of SR's


SELECT 
    a.*, 100 * a.total_sr / b.total AS percent_sr
FROM
    (SELECT 
        concat(t.technology_desc,"-" ,it.issue_desc) as Issue_type,
            COUNT(sd.sr_id) AS total_sr
    FROM
        sr_details sd
    LEFT JOIN technology t ON sd.technology_id = t.technology_id
    LEFT JOIN issue_type it ON sd.issue_id = it.issue_id
    GROUP BY t.technology_desc , it.issue_desc) AS a,
    (SELECT 
        COUNT(*) AS total
    FROM
        sr_details) AS b
ORDER BY total_sr desc	
;


 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* #1(b)Issue Type/Technology vs No. of SR's
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
 ## 1(c)  ISSUES Vs no of SRs
 
SELECT t.technology_desc,
    sum(case when  it.issue_desc like "Vo%" then 1 else 0 end) as Voice_issue,
     sum(case when  it.issue_desc = "Data_Issues" then 1 else 0 end) as Data_Issues,
     sum(case when  it.issue_desc in("Roaming_issues", "Other_issues") then 1 else 0 end) as Other_Issues,
	COUNT(sd.sr_id) AS total_sr
    FROM
        sr_details sd
       LEFT JOIN technology t ON sd.technology_id = t.technology_id
    LEFT JOIN issue_type it ON sd.issue_id = it.issue_id
   GROUP BY  t.technology_desc
   
ORDER BY  total_sr	desc;

##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* ## 1(c)  ISSUES Vs no of SRs
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
 
