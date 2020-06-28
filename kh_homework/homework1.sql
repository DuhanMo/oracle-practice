-- 1. 부서코드가 D6이고 급여를 200만원보다 많이 받는 직원의 이름, 부서코드, 급여 조회

SELECT
    EMP_NAME
,   DEPT_CODE
,   SALARY
FROM
    EMPLOYEE
WHERE
    DEPT_CODE = 'D6' AND SALARY > 2000000;

-- 2. EMPLOYEE 테이블에서 직원들의 주민번호를 조회하여 사원명, 생년, 생월, 생일을 각각 분리하여 조회
-- 단, 컬럼의 별칭은 사원명, 생년, 생월, 생일로 한다.

SELECT
    EMP_NAME AS 사원명
,   SUBSTR(EMP_NO,1,2) AS 생년
,   SUBSTR(EMP_NO,3,2) AS 생월
,   SUBSTR(EMP_NO,5,2) AS 생일
FROM EMPLOYEE;


-- 3. EMPLOYEE 테이블에서 사번이 홀수인 직원들의 정보 모두 조회

SELECT *
FROM EMPLOYEE
WHERE
