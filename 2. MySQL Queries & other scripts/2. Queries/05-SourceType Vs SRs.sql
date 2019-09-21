
-- Telco Customer Service Request Database Schema
-- Version 1.0

-- Copyright (c) 2018,
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are not permitted

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
													# (05)Source Vs SRs
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###########################################################
    
# 5(A)SR_SOURCE , SR_MONTH
 SELECT 
        ss.source_desc, sd.sr_month, COUNT(sd.sr_id) AS total_sr
 FROM
        sr_details sd
 LEFT JOIN sr_source ss ON sd.source_id = ss.source_id
 GROUP BY ss.source_id , sd.sr_month
 ORDER BY ss.source_id , sd.sr_month;
 
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* 5(A)
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  

 # 5(B)COUNT OF SRs BY SOURCE TYPE
SELECT 
    source_desc, COUNT(source_id)
FROM
    sr_details
        LEFT JOIN
    sr_source USING (source_id)
GROUP BY source_id
ORDER BY source_id;
 
 #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* 5(B)
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  

        

 # 5(C)SR_SOURCE , SR_STATUS
 
SELECT 
        ss.source_desc, sd.sr_status as Status, COUNT(sd.sr_id) AS total_SRs
    FROM
	sr_details sd
    LEFT JOIN sr_source ss ON sd.source_id = ss.source_id
    GROUP BY ss.source_id , sd.sr_status
    ORDER BY ss.source_desc ,total_SRs desc, sd.sr_status ;
	
  #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /*5(C)
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  

 
 #5(D) SR_SOURCE , SLA DAYS ,# OF SRs
 
SELECT 
        ss.source_desc, sla_days
        , COUNT(sd.sr_id) AS total_sr
    FROM
        sr_details sd
    LEFT JOIN sr_source ss ON sd.source_id = ss.source_id
    where sr_status="Resolved"
    GROUP BY ss.source_id , sd.sla_days
    ORDER BY ss.source_id , sd.sla_days;
    #############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* 5(D)
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  
