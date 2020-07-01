SELECT DEPT_CODE,JOB_CODE,SUM(SALARY),
       GROUPING(DEPT_CODE) "부서별그룹묶인상태"
,       GROUPING(JOB_CODE) "직급별그룹묶인상태"
FROM

     EMPLOYEE
GROUP BY CUBE(DEPT_CODE,JOB_CODE)
ORDER BY DEPT_CODE;


SELECT DEPT_CODE,JOB_CODE,SUM(SALARY),
       CASE WHEN GROUPING(DEPT_CODE) = 0
            AND GROUPING(JOB_CODE) = 1
    THEN '부서별합계'
    WHEN GROUPING (DEPT_CODE) = 1
            AND GROUPING(JOB_CODE) = 0