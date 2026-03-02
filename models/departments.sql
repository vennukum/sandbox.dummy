{{
    config
    (
        materialized ='table',
        transient = FALSE,
        database = 'DEV_GOLD',
        alias='DEPARTMENTS'
    )
}}
with DEPARTMENTS_prep_01 as(
select 
0 as DEPARTMENTS_KEY 
,0 as DEPARTMENTS_SNKEY
,0 as DEPARTMENT_ID_snkey
,0 as LOCATION_ID_snkey
,DEPARTMENT_ID
,DEPARTMENT_NAME
,LOCATION_ID
,EXTRACTED_TIMESTAMP
,0                                      as EDH_ROW_HASH_NBR
,'I'                                    as EDH_DML_IND
,CURRENT_TIMESTAMP::TIMESTAMP_NTZ  as EDH_CREAT_TS
,CURRENT_TIMESTAMP::TIMESTAMP_NTZ  as EDH_UPDT_TS
,'2002-02-21'::timestamp_ntz           as EDH_STRT_EFF_TS
,'2002-02-21'::timestamp_ntz           as EDH_END_EFF_TS
,'1'::boolean                           as EDH_IS_C_FLG
,1                                      as EDH_IS_ACT_FLG
,0                                      as EDH_IS_SOFT_DEL_FLG
,0                                      as EDH_IS_TST_DATA_FLG
,''                                     as EDH_REPLICATION_SEQ_NBR
,''                                    as EDH_SRCE_VERS_ID
,'EDH_LINEAGE_ID'                    as EDH_LINEAGE_ID
,CURRENT_USER()                         as EDH_MOD_BY_USR_NAM
,''                                     as EDH_MOD_BY_SCM_TASK_ID
,''                                     as EDH_MOD_BY_SCM_CASE_NBR
,UUID_STRING()                          as EDH_GLBL_ID
from {{source('hr_global','DEPARTMENTS')}} 
),
 DEPARTMENTS_PREP_02 as (
                    select   
                       CAST (HASH(prep_01.DEPARTMENT_ID,prep_01.LOCATION_ID,TO_CHAR(EXTRACTED_TIMESTAMP,'YYYYMMDDHH24MISS')) AS NUMBER(28,0)) as DEPARTMENTS_KEY 
                        ,HASH(prep_01.DEPARTMENT_ID,prep_01.LOCATION_ID) as DEPARTMENTS_SNKEY
                        
						,HASH(prep_01.DEPARTMENT_ID)	as DEPARTMENTS_id_SNKEY
						
                        ,HASH(prep_01.DEPARTMENT_ID)  AS LOCATION_ID_snkey
						
						
						,prep_01.DEPARTMENT_ID             as  DEPARTMENT_ID
                        ,prep_01.DEPARTMENT_NAME        as  DEPARTMENT_NAME
                        ,prep_01.LOCATION_ID        as  LOCATION_ID
                        ,prep_01.EXTRACTED_TIMESTAMP        as  EXTRACTED_TIMESTAMP
						
           
                        ,HASH(
                            TO_CHAR(prep_01.DEPARTMENT_ID),
                            TO_CHAR(prep_01.DEPARTMENT_NAME),
                            TO_CHAR(prep_01.LOCATION_ID),
                            TO_CHAR(prep_01.EXTRACTED_TIMESTAMP)
                            )                                   as EDH_ROW_HASH_NBR
                        ,prep_01.EDH_DML_IND                    as EDH_DML_IND
                        ,prep_01.EDH_CREAT_TS                   as EDH_CREAT_TS
                        ,prep_01.EDH_UPDT_TS                    as EDH_UPDT_TS
                        ,prep_01.EDH_STRT_EFF_TS                as EDH_STRT_EFF_TS
                        ,prep_01.EDH_END_EFF_TS                 as EDH_END_EFF_TS
                        ,prep_01.EDH_IS_C_FLG                   as EDH_IS_C_FLG
                        ,prep_01.EDH_IS_ACT_FLG                 as EDH_IS_ACT_FLG
                        ,prep_01.EDH_IS_SOFT_DEL_FLG            as EDH_IS_SOFT_DEL_FLG
                        ,prep_01.EDH_IS_TST_DATA_FLG            as EDH_IS_TST_DATA_FLG
                        ,prep_01.EDH_REPLICATION_SEQ_NBR        as EDH_REPLICATION_SEQ_NBR
                        ,prep_01.EDH_SRCE_VERS_ID               as EDH_SRCE_VERS_ID
                        ,prep_01.EDH_LINEAGE_ID                 as EDH_LINEAGE_ID
                        ,prep_01.EDH_MOD_BY_USR_NAM             as EDH_MOD_BY_USR_NAM
                        ,prep_01.EDH_MOD_BY_SCM_TASK_ID         as EDH_MOD_BY_SCM_TASK_ID
                        ,prep_01.EDH_MOD_BY_SCM_CASE_NBR        as EDH_MOD_BY_SCM_CASE_NBR
                        ,prep_01.EDH_GLBL_ID                    as EDH_GLBL_ID
                    from
                        DEPARTMENTS_prep_01 prep_01
                )
				select * from DEPARTMENTS_PREP_02

