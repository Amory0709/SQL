--2019/07/04 Work log

/* Step 1. Import Mapping table */

-- Check the icd-10 mapping data
SELECT * FROM hk_mapping_icd_10;
SELECT DISTINCT strleft(icd10code,3) FROM disease;

-- Check active treatment mapping data
ALTER TABLE hk_mapping_active_treatment_ RENAME TO hk_mapping_active_treatment;
SELECT * FROM hk_mapping_active_treatment;

-- Check Cancer Stage mapping data
SELECT * FROM hk_mapping_cancer_stage;
/*problems with cancer stage:
Row 1 cacerstage = blank   Should it be changed to a real blank like this "" or a space like this " "?
Row 3 cancerstage = //"" in original data. Should it be changed to ""?
*/

-- Check Endoscopy mapping data
SELECT count(*) FROM hk_mapping_endoscopy; --2030

-- Drug for Active Treatment not upload yet


/* Step 2. Working Steps - Mapping */

--A100_Get Diagnosis Date

CREATE TABLE A100_Get_DiagnosisDate AS
(SELECT patientid, MIN(fromdate) AS DiagnosisDate, utagaiflg
 FROM disease 
 GROUP BY patientid, utagaiflg
 HAVING utagaiflg=0
);
--Inserted 831706 row(s)
--QA TEST:
SELECT * FROM A100_Get_DiagnosisDate 
WHERE patientid IN (134196, 136283, 138250,138391);
-- Compare with Access Result, PASS TEST
ALTER TABLE A100_Get_DiagnosisDate RENAME TO DiagnosisDate; 
ALTER TABLE DiagnosisDate RENAME TO Diagnosis_Date;



