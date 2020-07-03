-- DAY4 수업내용

-- JOIN : 두개의 테이블을 하나로 합쳐서 결과를 조회

/*
    하나 이상의 테이블에서 데이터를 조회하기 위해 사용하고 결과는 하나의 RESULT SET으로 나온다.
    관계형 데이터베이스에서 SQL을 이용해 테이블간 '관계'를 맺는 방법
    관계형 데이터베이스는 최소한의 데이터를 테이블에 담고 있어(중복을 최소화해서)
    원하는 정보를 테이블에서 조회하려면 한 개 이상의 테이블에서 데이터를 읽어와야 되는 경우가 많다.
    
    이때, 무작정 데이터르 가져오는게 아닌 테이블간 연결고리로 관계를 맺어진 데이터를 추출해야한다.
    --> JOIN을 통해 이를 구현가능하다.

    JOIN은 크게 오라클 구문과 ANSI 구문
    ANSI는 미국국립표준협희(American National Standards Institute)를 뜻한다.
    ANSI 구문 같은 경우 오라클 DBMS외의 다른 DBMS에서 똑같이 사용된다.

        오라클 구문          |           SQL:1999년표준(ANSI)구문
----------------------------------------------------------------------------
          등가 조인          |      내부조인(INNER JOIN)  --> JOIN  USING/ON
                             |      자연조인(NATURAL JOIN)--> JOIN USING 구문과 비슷
------------------------------------------------------------------------------------
          포괄조인           |      왼쪽 외부 조인 (LEFT OUTER JOIN)
        (LEFT OUTER)         |      오른쪽 외부 조인(RIGHT OUTER JOIN)
        (RIGHT OUTER)        |      전체 외부 조인(FULL OUTER JOIN)--> 오라클 구문으로 사용 못함
*/

-- 오라클 전용 구문
-- FROM절에 ','로 구분하여 합치게 될 테이블명을 기술하고
-- WHERE절에 합치기에 사용할 컬럼명을 명시한다.
-- 연결에 사용할 두 컬럼명이 다른 경우
SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;

-- 연결에 사용할 두 컬럼명이 같은 경우
SELECT EMP_ID,EMP_NAME,EMPLOYEE.JOB_CODE,JOB_NAME
FROM EMPLOYEE,JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

-- 테이블에 별칭 사용
SELECT EMP_ID,EMP_NAME,E.JOB_CODE,JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

-- ANSI표준 구문
-- 연결에 사용할 컬럼명이 같은 경우 USING(컬럼명)을 사용
SELECT EMP_ID,EMP_NAME,JOB_CODE,JOB_NAME
FROM EMPLOYEE 
JOIN JOB USING(JOB_CODE);

-- 연결에 사용할 컬럼명이 다른 경우 ON()을 사용
SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE
FROM EMPLOYEE 
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 연결에 사용할 컬럼명이 같은 경우 ON()을 사용할 수 있다.
SELECT EMP_ID,EMP_NAME,E.JOB_CODE,JOB_NAME
FROM EMPLOYEE E 
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE);

-- 부서테이블과 지역테이블을 조인하여 테이블에 모든 데이터를 조회
-- ANSI 표준
SELECT *
FROM DEPARTMENT
JOIN LOCATION ON(LOCATION_ID= LOCAL_CODE);

-- 오라클 전용
SELECT *
FROM DEPARTMENT D,LOCATION L
WHERE D.LOCATION_ID = L.LOCAL_CODE;

-- 조인은 기본이 EQUAL JOIN : 연결되는 컬럼의 값이 일치하는 행들만 조인된다.
-- 일치하는 값이 없는 행은 조인에서 제외되는 것을 INNER JOIN이라고한다.
-- JOIN의 기본은 INNER JOIN & EQAUL JOIN이다.

-- OUTER JOIN : 두 테이블의 지정하는 컬럼 값이 일치하지 않는 행도 조인에 포함을 시킨다.
--              반드시 OUTER JOIN임을 명시해야한다.

-- 1. LEFT OUTER JOIN : 합치기에 사용한 두 테이블 중 왼쪽편에 기술된 테이블의 행의 수를 기준으로 JOIN
-- 2. RIGHT OUTER JOIN : 합치기에 사용한 두 테이블 중 오른편에 기술된 테이블의 행의 수를 기준으로 JOIN
-- 3. FULL OUTER JOIN

SELECT EMP_NAME,DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- LEFT OUTER JOIN
-- ANSI 표준
SELECT EMP_NAME,DEPT_TITLE
FROM EMPLOYEE
-- LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 오라클 전용 구문
SELECT EMP_NAME,DEPT_TITLE
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

-- RIGHT OUTER JOIN
-- ANSI 표준
SELECT EMP_NAME,DEPT_TITLE ,J.JOB_NAME
FROM EMPLOYEE E
-- RIGHT OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);
JOIN JOB J ON (J.JOB_CODE = E.JOB_CODE)
RIGHT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 오라클 전용
SELECT EMP_NAME,DEPT_TITLE
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID;

-- FULL OUTER JOIN
-- ANSI 표준
SELECT EMP_NAME,DEPT_TITLE
FROM EMPLOYEE
FULL OUTER JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 오라클 전용구문
-- 오라클 전용 구문으로는 FULL OUTER JOIN을 하지 못한다.
SELECT EMP_NAME,DEPT_TITLE
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE(+) = DEPT_ID(+);

-- CROSS JOIN : 카테이션곱이라고도 한다.
--              조인되는 테이블의 각 행들이 모두 매핑된 데이터가 검색되는 방법
SELECT EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
CROSS JOIN DEPARTMENT;

-- NON EQUAL JOIN
-- 지정한 컬럼의 값이 일치하는 경우가 아닌, 값의 범위에 포함되는 행들을 연결하는 방식
-- ANSI표준
SELECT EMP_NAME,SALARY,E.SAL_LEVEL,S.SAL_LEVEL
FROM EMPLOYEE E
JOIN SAL_GRADE S ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);
-- 오라클 전용
SELECT EMP_NAME,SALARY,E.SAL_LEVEL,S.SAL_LEVEL
FROM EMPLOYEE E,SAL_GRADE S
WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL;

-- SELF JOIN : 같은 테이블을 조인하는 경우
--             자기 자신과 조인을 맺는 것
-- 오라클 전용
SELECT 
    E1.EMP_ID
 ,  E1.EMP_NAME 사원이름
 ,  E1.DEPT_CODE
 ,  E1.MANAGER_ID
 ,  E2.EMP_NAME 관리자이름
FROM EMPLOYEE E1,EMPLOYEE E2
WHERE E1.MANAGER_ID = E2.EMP_ID;


-- ANSI 표준
SELECT 
    E1.EMP_ID
 ,  E1.EMP_NAME 사원이름
 ,  E1.DEPT_CODE
 ,  E1.MANAGER_ID
 ,  E2.EMP_NAME 관리자이름
FROM EMPLOYEE E1
JOIN EMPLOYEE E2 ON(E1.MANAGER_ID = E2.EMP_ID);

-- 다중 JOIN : N개의 테이블을 조회할 때 사용
-- ANSI 표준
-- 조인 순서 중요함
SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE,LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE);

-- 오라클 전용
-- 조인 순서 상관없음
SELECT EMP_ID,EMP_NAME,DEPT_CODE,DEPT_TITLE,LOCAL_NAME
FROM EMPLOYEE,DEPARTMENT,LOCATION
WHERE 
LOCATION_ID = LOCAL_CODE AND DEPT_CODE = DEPT_ID;


-- 직급이 대리이면서 아시아 지역에 근무하는 직원 조회
-- 사번, 이름, 직급명,부서명,근무지역명,급여를 조회하세요.
SELECT 
    EMP_ID
  , EMP_NAME
  , JOB_NAME
  , DEPT_TITLE
  , LOCAL_NAME
  , SALARY
FROM 
    EMPLOYEE E
  JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
  JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
  JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE  JOB_NAME = '대리'
  --E.JOB_CODE = 'J6'
--AND LOCAL_NAME = 'ASIA1';
AND LOCAL_NAME LIKE 'ASIA%';

-- 오라클 전용
SELECT 
    EMP_ID
  , EMP_NAME
  , JOB_NAME
  , DEPT_TITLE
  , LOCAL_NAME
  , SALARY
FROM 
    EMPLOYEE E,JOB J,DEPARTMENT,LOCATION
WHERE 
    E.JOB_CODE = J.JOB_CODE
AND DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND JOB_NAME = '대리'
AND LOCAL_NAME LIKE 'ASIA%';



-- JOIN 연습문제
--1. 주민번호가 70년대 생이면서 성별이 여자이고,
--   성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하시오.
--   ANSI 표준
SELECT
     EMP_NAME
  ,  EMP_NO
  ,  DEPT_TITLE
  ,  JOB_NAME
FROM
     EMPLOYEE E
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE SUBSTR(EMP_NO,1,2) >= 70
AND SUBSTR(EMP_NO,1,2) < 80
AND SUBSTR(EMP_NO,8,1) = 2
AND EMP_NAME LIKE '전%';

--   오라클 전용
SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID
AND J.JOB_CODE = E.JOB_CODE
AND SUBSTR(EMP_NO, 1,2) >= 70
AND SUBSTR(EMP_NO, 1,2) <80
AND SUBSTR(EMP_NO, 8,1) = 2
AND EMP_NAME LIKE '전%';

--2. 가장 나이가 적은 직원의 사번, 사원명,
--   나이, 부서명, 직급명을 조회하시오.
--   ANSI 표준
SELECT
     EMP_ID
 ,   EMP_NAME
 ,   EXTRACT(YEAR FROM SYSDATE)
     - EXTRACT(YEAR FROM (TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))) + 1 AS 나이
 ,   DEPT_TITLE
 ,   JOB_NAME
FROM
     EMPLOYEE E
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB J ON (E.JOB_CODE = J.JOB_CODE)
WHERE
     EXTRACT(YEAR FROM SYSDATE)
     - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))) + 1
     = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE)
                   - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))) + 1)
        FROM EMPLOYEE);

--  오라클전용
SELECT EMP_ID, EMP_NAME,
       EXTRACT(YEAR FROM SYSDATE)
       - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1 AS 나이,
       DEPT_TITLE, JOB_NAME
FROM EMPLOYEE E, DEPARTMENT, JOB J
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND EXTRACT(YEAR FROM SYSDATE)
     - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1
     = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE)
              - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2), 'RR'))) + 1)
        FROM EMPLOYEE);

--3. 이름에 '형'자가 들어가는 직원들의
--   사번, 사원명, 부서명을 조회하시오.
--   ANSI 표준
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
WHERE EMP_NAME LIKE '%형%';
--   오라클전용
SELECT EMP_ID, EMP_NAME, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE
AND EMP_NAME LIKE '%형%';
--4. 해외영업팀에 근무하는 사원명,
--   직급명, 부서코드, 부서명을 조회하시오.
--   ANSI표준
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E
JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE DEPT_ID IN('D5', 'D6');
--   오라클전용
SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE E, JOB J, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
AND E.JOB_CODE = J.JOB_CODE
AND DEPT_ID IN('D5', 'D6');
--5. 보너스포인트를 받는 직원들의 사원명,
--   보너스포인트, 부서명, 근무지역명을 조회하시오.
--   ANSI표준
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
JOIN LOCATION ON(LOCATION_ID = LOCAL_CODE)
WHERE BONUS IS NOT NULL;

--   오라클전용
SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
FROM EMPLOYEE, DEPARTMENT, LOCATION
WHERE DEPT_CODE = DEPT_ID
AND LOCATION_ID = LOCAL_CODE
AND BONUS IS NOT NULL;

--6. 부서코드가 D2인 직원들의 사원명, 직급명,부서명, 근무지역명을 조회하시오.
-- ANSI 표준

-- 오라클 전용


--7. 연봉의 최소급여(MIN_SAL)보다 많이 받는 직원들의
--   사원명, 직급명, 급여, 연봉을 조회하시오.
--   연봉에 보너스포인트를 적용하시오.
-- ANSI 표준

-- 오라클 전용

-- 8. 한국(KO)과 일본(JP)에 근무하는 직원들의
--    사원명, 부서명,지역명, 국가명을 조회하시오
-- ANSI 표준

-- 오라클 전용

-- 9. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 동료이름을 조회하시오(단 SELF JOIN 사용)
--   ANSI 표준
SELECT D.EMP_NAME,
       E.DEPT_CODE,
       E.EMP_NAME
FROM EMPLOYEE E
        JOIN EMPLOYEE D ON (E.DEPT_CODE = D.DEPT_CODE)
WHERE E.EMP_NAME != D.DEPT_NAME
ORDER BY D.EMP_NAME;
--   오라클 전용

-- 10. 보너스포인트가 없는 직원들 중에서 직급코드가 J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하시오.
--     단, JOIN과 IN 사용할것
--   ANSI 표준


--  오라클 전용






