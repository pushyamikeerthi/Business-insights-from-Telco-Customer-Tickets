-- Telco Customer Service Request Database Schema
-- Version 1.0

-- Copyright (c) 2018,
-- All rights reserved.

-- Redistribution and use in source and binary forms, with or without modification, are not permitted

-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
													# 03-CustomerType&Class Vs SRs
#############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###########################################################
use telco_sr;
#3(A) CUSTOMER_TYPE

 SELECT 
    a.*, 100 * a.total_sr / b.total AS percent_sr
FROM
    (SELECT 
        c2.customer_type, COUNT(sr_id) AS total_sr
    FROM
        sr_details sd
    LEFT JOIN (SELECT c.customer_id,c.last_update,ct.customer_type,c.customer_type_id
				FROM customer c
    LEFT JOIN customer_type ct ON c.customer_type_id = ct.customer_type_id) AS c2
			  ON sd.Customer_id = c2.customer_id AND sd.sr_date = c2.last_update
    GROUP BY c2.customer_type) a,
    (SELECT COUNT(*) AS total FROM sr_details) AS b
ORDER BY total_sr desc;
  
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* #3(A) CUSTOMER_TYPE
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  
# 3(B1)CUSTOMER_CLASS
  
 SELECT 
    a.*, (100 * a.total_sr / b.total) AS percent_sr
FROM
    (SELECT c2.cust_class_desc, COUNT(sr_id) AS total_sr
    FROM sr_details sd
    LEFT JOIN (SELECT c.customer_id,c.last_update,cc.cust_class_desc,c.cust_class_id
				FROM customer c
			LEFT JOIN customer_class cc ON c.cust_class_id = cc.cust_class_id) AS c2 
	ON sd.Customer_id = c2.customer_id AND sd.sr_date = c2.last_update
    GROUP BY c2.cust_class_desc) a,
    (SELECT COUNT(*) AS total FROM sr_details) AS b
ORDER BY total_sr desc;
 
 
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* # 3(B1)CUSTOMER_CLASS
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  
 #3(B2)Top Corporate - Customer Name
 
 SELECT sd.Customer_id,c2.customer_name, COUNT(sr_id) AS total_sr
    FROM sr_details sd
    LEFT JOIN 
    (SELECT c.customer_id,c.customer_name,c.last_update,cc.cust_class_desc,c.cust_class_id
	FROM customer c
	LEFT JOIN customer_class cc ON c.cust_class_id = cc.cust_class_id
    ) AS c2 
	ON sd.Customer_id = c2.customer_id AND sd.sr_date = c2.last_update
    where  c2.cust_class_desc="Corporate" and c2.customer_name = "Reliance Insurance / Energy / Capital"
    GROUP BY sd.Customer_id,c2.customer_name
    order by COUNT(sr_id) desc
    Limit 10
    ;
    
    
    select * from customer where customer_name='ICICI Bank & Life insurance';
    
    
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* ##3(B2)Top Corporate - Customer Name
  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  
 
#3(B3) Top Micro - Customer Name

 SELECT c2.customer_name, COUNT(sr_id) AS total_sr
    FROM sr_details sd
    LEFT JOIN 
    (SELECT c.customer_id,c.customer_name,c.last_update,cc.cust_class_desc,c.cust_class_id
	FROM customer c
	LEFT JOIN customer_class cc ON c.cust_class_id = cc.cust_class_id
    where  cust_class_desc="Micro" 
    ) AS c2 
	ON sd.Customer_id = c2.customer_id AND sd.sr_date = c2.last_update
    GROUP BY c2.customer_name 
    HAVING  c2.customer_name IS NOT NULL
    order by COUNT(sr_id) desc
    Limit 5
    ;
    
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* #3(B3) Top Micro - Customer Name

  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  

#3(C) SR STAUTS VS CUSTOMER TYPE

select c2.customer_type,
sum(case when sr_status = "On Hold" then 1 else 0 end) as no_hold,
sum(case when sr_status = "Open" then 1 else 0 end) as no_open,
sum(case when sr_status = "Resolved" then 1 else 0 end) as no_resolved
from sr_details sd
left join 
			(SELECT c.customer_id,c.last_update,ct.customer_type,c.customer_type_id
			 FROM customer c
			 LEFT JOIN customer_type ct ON c.customer_type_id = ct.customer_type_id) AS c2
ON sd.Customer_id = c2.customer_id AND sd.sr_date = c2.last_update
   GROUP BY c2.customer_type
   ;
   
   
##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################
  /* #3(C) SR STAUTS VS CUSTOMER TYPE

  OBSERVATION :  
  */
 ##############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################################  
