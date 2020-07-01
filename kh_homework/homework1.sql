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
WHERE MOD(TO_NUMBER(EMP_ID),2)=1;





-- 4. 직원 테이블에서 사원번호가 201인 사원의
--    이름, 주민번호 앞자리, 주민번호 뒷자리,
--    주민번호 앞자리와 뒷자리의 합을 조회하세요
--    단, 자동 형변환 사용하지 않고 조회

SELECT
    EMP_NAME
,   SUBSTR(EMP_NO,1,6)
,   SUBSTR(EMP_NO,8)
,   TO_NUMBER(SUBSTR(EMP_NO,1,6)) + TO_NUMBER(SUBSTR(EMP_NO,8))
FROM EMPLOYEE
WHERE EMP_ID = '201';

-- 5. 사번, 사원명, 급여를 EMPLOYEE 테이블에서 조회하고 급여가 500만원 초과이면 '고급'
-- 급여가 300~500만원이면 '중급'
-- 그 이하는 '초급'으로 출력 처리하고 별칭은 '구분'으로 한다.

SELECT
    EMP_ID
,   EMP_NAME
,   SALARY
,   CASE WHEN SALARY>5000000 THEN '고급'
--         WHEN SALARY <= 5000000 AND SALARY >=3000000 THEN '중급'
    WHEN SALARY BETWEEN 3000000 AND 5000000 THEN '중급'
        ELSE '초급'
        END AS 구분
FROM EMPLOYEE;




-- 함수 연습 문제
-- 1. 직원명과 주민번호를 조회함
-- 단, 주민번호 9번째 자리부터 끝까지는 '*'문자로 채움 예 : 홍길동 771120-1******

SELECT
    EMP_NAME AS 사원명
,   SUBSTR(EMP_NO,1,8) || '******' AS 주민번호
FROM EMPLOYEE;

-- 2. 직원명, 직급코드, 연봉(원) 조회
-- 단, 연봉은 ₩57,000,000 으로 표시되게 함 연봉은 보너스포인트가 적용된 1년치 급여이다

SELECT
    EMP_NAME
,   JOB_CODE
,   TO_CHAR((SALARY + SALARY*NVL(BONUS,0))* 12 ,'L999,999,999') AS "1년치급여"
FROM EMPLOYEE;
-- 3. 부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의 사번 사원명 부서코드 입사일 조회
SELECT
    EMP_ID
,   EMP_NAME
,   DEPT_CODE
,   HIRE_DATE
FROM EMPLOYEE
WHERE

-- 3-1부서코드가 D5, D9인 직원들 중에서 2004년도에 입사한 직원의 사번 사원명 부서코드 입사일 조회

SELECT
    EMP_ID
,   EMP_NAME
,   DEPT_CODE
,   HIRE_DATE
FROM EMPLOYEE
WHERE
    DEPT_CODE IN ('D5','D9')
  AND EXTRACT(YEAR FROM HIRE_DATE) = '2014';

SELECT

EMP_NAME
, JOB_CODE
, COUNT(*) AS 사원

FROM
EMPLOYEE

WHERE

BONUS IS NOT NULL
GROUP BY JOB_CODE,EMP_NAME
ORDER BY JOB_CODE;

SELECT

DEPT_CODE AS 부서명
, SUM(SALARY) AS 급여합
FROM
EMPLOYEE
GROUP BY
DEPT_CODE
HAVING SUM(SALARY)>9000000;
ORDER BY DEPT_CODE ASC;


SELECT