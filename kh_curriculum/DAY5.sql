-- DAY5 수업내용
-- SUBQUERY(서브쿼리)
--    하나의 SQL문 안에 포함된 또다른 SQL문
--    메인쿼리(기존쿼리)를 위해 보조 역할을 하는 쿼리문

-- 간단한 서브쿼리 예시 1.
-- 부서코드가 노옹철 사원과 같은 부서의 직원 명단을 조회해보자

-- 1) 사원명이 노옹철인 사람의 부서코드 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철';
-- > D9인걸 찾음

-- 2) 부서코드가 D9인 직원을 조회
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

--> 위의 2개의 단계를 하나의 쿼리로
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '노옹철');

-- 서브쿼리 예시 2
-- 전 직원의 평균 급여보다 많은 급여를 받고 있는 직원의 사번,이름,직급코드, 급여조회
-- 1) 전 직원의 평균 급여 조회
SELECT AVG(SALARY)
FROM EMPLOYEE;
-- 3047663

-- 2) 직원들 중 급여가 3047663원 이상인 사원들의 사번, 이름, 직급코드,급여조회
SELECT EMP_ID
     , EMP_NAME
     , JOB_CODE
     , SALARY
FROM EMPLOYEE
WHERE SALARY >= 3047663;

--> 서브쿼리를 사용
SELECT EMP_ID
     , EMP_NAME
     , JOB_CODE
     , SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY)
                 FROM EMPLOYEE);
---------------------------------------------------------------------------------------------------
/*
    서브쿼리의 유형
    - 단일행 서브쿼리        : 서브쿼리의 조회 결과 값의 개수가 1개일 때
    - 다중행 서브쿼리        : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
    - 다중열 서브쿼리        : 서브쿼리의 SELECT절에 나열된 항목수가 여러개일때
    - 다중행 다중열 서브쿼리 : 조회결과 행 수와 열수가 여러개일때
    - 상관 서브쿼리          : 서브쿼리가 만들 결과 값을 메인 쿼리가 비교 연산할 때
                               메인 쿼리 테이블의 값이 변경되면 서브쿼리의 결과값도 바뀌는 서브쿼리
    - 스칼라 서브쿼리        : 상관 쿼리이면서 결과값이 하나인 서브쿼리

    -- > 서브쿼리 유형에 따라 서브쿼리 앞에 붙은 연산자가 다르다.
*/

-- 1. 단일행 서브쿼리(SINGLE ROW SUBQUERY)
--      서브쿼리의 조회 결과 값의 개수가 1개일 때
--      단일행 서브쿼리 앞에는 일반 연산자 사용
--      <,>,<=,>=,=,!=/^=/<>

-- 1) 전 직원의 급여 평균보다 많은 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회(급여 순으로 정렬)
SELECT EMP_NAME
     , JOB_CODE
     , DEPT_CODE
     , SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT AVG(SALARY) --> 컬럼 1개, 결과도 1개
                 FROM EMPLOYEE);

-- 2) 가장 적은 급여를 받는 직원의 사번,이름,직급,부서코드,급여,입사일을 조회
SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , DEPT_CODE
     , SALARY
     , HIRE_DATE
FROM EMPLOYEE
         JOIN JOB USING (JOB_CODE)
WHERE SALARY = (SELECT MIN(SALARY) --> 컬럼1개, 결과1개
                FROM EMPLOYEE);

-- 3) 노옹철 사원의 급여보다 많이받는 직원의 사번,이름,부서,직급,급여를 조회
SELECT EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , JOB_CODE
     , SALARY
FROM EMPLOYEE
WHERE SALARY > (SELECT SALARY
                FROM EMPLOYEE
                WHERE EMP_NAME = '노옹철');

-- * 서브쿼리는 WHERE절 뿐만 아니라 SELECT, HAVING,FROM절에서도 사용가능!
-- 4) 부서별(부서가 없는 사람포함) 급여의 합계중 가장 큰 부서의 부서명, 부서별 급여의 합계를 조회

--> 부서별 급여 합계 중 가장 큰값
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;
--> 17700000

-- > 부서별 급여 합계
SELECT DEPT_TITLE
     , SUM(SALARY)
FROM EMPLOYEE
         LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) --> 부서가 없는 사원도 있기 때문에 전직원에 대한 조회를 하기위해서는 LFET JOIN
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = 17700000;

-- > 서브쿼리를 적용해서 부서별 급여 합계 중 가장 큰 부서
SELECT DEPT_TITLE
     , SUM(SALARY)
FROM EMPLOYEE
         LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID) --> 부서가 없는 사원도 있기 때문에 전직원에 대한 조회를 하기위해서는 LFET JOIN
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE);

----------------------------------------------- 실 습 문 제 --------------------------------------------
-- 1. 전지연 사원이 속해있는 부서원들을 조회하시오(단, 전지연은 제외)
--    사번,사원명,전화번호,고용일,부서명
SELECT EMP_ID
     , EMP_NAME
     , PHONE
     , HIRE_DATE
     , DEPT_TITLE
FROM EMPLOYEE
         JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME = '전지연')
  AND EMP_NAME != '전지연';

-- 2. 고용일이 2000년도 이상인 사원들 중 급여가 가장 많은 사원의 사번, 사원명, 전화번호, 급여, 직급명을 조회하시오.
SELECT EMP_ID
     , EMP_NAME
     , PHONE
     , SALARY
     , JOB_NAME
FROM EMPLOYEE
         JOIN JOB USING (JOB_CODE)
WHERE SALARY = (SELECT MAX(SALARY)
                FROM EMPLOYEE
                WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000);

-------------------------------------------------------------------------------------------------
-- 2.  다중행 서브쿼리(MULTI ROW SUBQUERY)
--          서브쿼리의 조회 결과 값의 개수가 여러행일때
/*
    다중행 서브쿼리 앞에는 일반 비교연산자 사용 X
    - IN / NOT IN           : 여러 개의 결과값 중에서 한 개라도 일치하는 값이 있다면 혹은 없다면 이라는 의미
    - > ANY, < ANY          : 여러 개의 결과값 중에서 한개라도 큰/작은 경우
    - > ALL, < ALL          : 여러개의 결과값의 모든 값보다 큰 / 작은 경우
    - EXISTS / NOT EXISTS   : 값이 존재합니까? 존재하지 않습니까?
*/

-- 1) 부서별 최고 급여를 받는 직원의 이름, 직급코드, 부서코드, 급여 조회(부서코드 순으로 정렬)
SELECT EMP_NAME
     , JOB_CODE
     , DEPT_CODE
     , SALARY
FROM EMPLOYEE
WHERE SALARY IN (SELECT MAX(SALARY)
                 FROM EMPLOYEE
                 GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

-- 2) 사수(관리자)에 해당하는 직원에 대해 조회
--    사번, 이름,부서명,직급명,구분(사수(관리자)/직원)

--> 관리자에 해당하는 사원번호 조회
SELECT DISTINCT MANAGER_ID -->관리자가 한명이 여러명 관리할 수 있다.--> 중복제거
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- > 직원의 사번, 이름, 부서명, 직급명 조회
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , JOB_NAME
FROM EMPLOYEE
         LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN JOB USING (JOB_CODE);

--> 사수에 해당하는 직원에 대한 정보 조회(이때, 구분은 '사수'로)
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , JOB_NAME
     , '사수' 구분
FROM EMPLOYEE
         LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN JOB USING (JOB_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL);

--> 일반 사원에 해당하는 직원에 대한 정보 조회(이때, 구분은 '사원'로)
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , JOB_NAME
     , '사원' 구분
FROM EMPLOYEE
         LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN JOB USING (JOB_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                     FROM EMPLOYEE
                     WHERE MANAGER_ID IS NOT NULL);


--> 위의 결과를 하나로 합쳐주세요
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , JOB_NAME
     , '사수' 구분
FROM EMPLOYEE
         LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN JOB USING (JOB_CODE)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
                 FROM EMPLOYEE
                 WHERE MANAGER_ID IS NOT NULL)
UNION
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , JOB_NAME
     , '사원' 구분
FROM EMPLOYEE
         LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN JOB USING (JOB_CODE)
WHERE EMP_ID NOT IN (SELECT DISTINCT MANAGER_ID
                     FROM EMPLOYEE
                     WHERE MANAGER_ID IS NOT NULL)
ORDER BY 구분;

-------------------------------> 변경
--- SELECT 절에서도 서브쿼리를 사용할 수 있다.

SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , JOB_NAME
     , CASE
           WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID
                           FROM EMPLOYEE
                           WHERE MANAGER_ID IS NOT NULL) THEN '사수'
           ELSE '사원'
    END 구분
FROM EMPLOYEE
         LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN JOB USING (JOB_CODE);

-- 3) 대리 직급의 직원들 중에서 과장 직급의 최소 급여보다 많이 받는 직원의
--    사번,이름,직급,급여를 조회하세요.
--    단, > ANY 혹은 < ANY 연산자를 사용하세요.

-- > 직급이 대리인 직원들 조회
SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , SALARY
FROM EMPLOYEE
         JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리';

-- > 직급이 과장인 직원들 급여 조회
SELECT SALARY
FROM EMPLOYEE
         JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장';


-- > 대리 직급의 직원들 중에서 과장직급의 최소 급여보다 많이 받는 직원
SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , SALARY
FROM EMPLOYEE
         JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '대리'
  AND SALARY > ANY (SELECT -- > ANY : 가장 작은값보다 크니?    / < ANY : 가장 큰 값 보다 작니?
                           SALARY
                    FROM EMPLOYEE
                             JOIN JOB USING (JOB_CODE)
                    WHERE JOB_NAME = '과장');

-- 4) 차장 직급의 최대 급여보다 많이 받는 과장 직급의 직원  > ALL : 가장 큰 값보다 크니? / < ALL : 가장 작은 값보다 작니?
SELECT EMP_ID
     , EMP_NAME
     , JOB_NAME
     , SALARY
FROM EMPLOYEE
         JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME = '과장'
  AND SALARY > ALL (SELECT SALARY
                    FROM EMPLOYEE
                             JOIN JOB USING (JOB_CODE)
                    WHERE JOB_NAME = '차장');


-- 중첩을 해보자

-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 LOCAL_CODE가
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가
-- EMPLOYEE테이블의 DEPT_CODE와 동일한 사원을 구하시오.

--> LOCATIO테이블을 통해 NATIONAL_CODE가 KO인 LOCAL_CODE 먼저 구해보자
SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE = 'KO';

--> 그럼 DEPARTMENT 테이블에서 위의 결과와 동일한 LOCATION_ID를 가지고있는 DEPT_ID를 구해보자
SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID = (SELECT LOCAL_CODE --> 단일행
                     FROM LOCATION
                     WHERE NATIONAL_CODE = 'KO');

-- > 최종적으로 EMPLOYEE테이블에서 위의 결과들과 동일한 DEPT_CODE를 가지는 사원들을 구해보자
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID --> 다중행
                    FROM DEPARTMENT
                    WHERE LOCATION_ID = (SELECT LOCAL_CODE --> 단일행
                                         FROM LOCATION
                                         WHERE NATIONAL_CODE = 'KO'));


------------------------------------------------------------------------------------------------------------
-- 3. 다중열 서브쿼리
--      서브쿼리 SELECT 절에 나열된 컬럼 수가 여러개일 때
-- 1) 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는 사원의 이름,직급,부서,입사일 조회

-- 퇴사한 여직원 먼저 조회해보자
SELECT EMP_NAME
     , JOB_CODE
     , DEPT_CODE
     , HIRE_DATE
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = 2
  AND ENT_YN = 'Y';

-- > 퇴사한 여직원과 같은부서,같은 직급
SELECT EMP_NAME
     , JOB_CODE
     , DEPT_CODE
     , HIRE_DATE
FROM EMPLOYEE
WHERE
  -- 같은 부서
        DEPT_CODE = (SELECT DEPT_CODE
                     FROM EMPLOYEE
                     WHERE SUBSTR(EMP_NO, 8, 1) = 2
                       AND ENT_YN = 'Y')
  -- 같은 직급
  AND JOB_CODE = (SELECT JOB_CODE
                  FROM EMPLOYEE
                  WHERE SUBSTR(EMP_NO, 8, 1) = 2
                    AND ENT_YN = 'Y');
--> 너무~ 복잡해서 ---> 간단하게 다중열서브쿼리를 적용해서 해결하자
SELECT EMP_NAME
     , JOB_CODE
     , DEPT_CODE
     , HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE
                                    , JOB_CODE
                               FROM EMPLOYEE
                               WHERE SUBSTR(EMP_NO, 8, 1) = 2
                                 AND ENT_YN = 'Y');

-------------------------------------- 실 습 문 제 ---------------------------------------
-- 1. 노옹철 사원과 같은 부서, 같은 직급인 사원을 조회하시오(단, 노옹철 사원은 제외)
--    사번, 이름, 부서코드, 직급코드, 부서명, 직급명
SELECT EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , JOB_CODE
     , DEPT_TITLE
     , JOB_NAME
FROM EMPLOYEE
         JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
         JOIN JOB USING (JOB_CODE)
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE
                                    , JOB_CODE
                               FROM EMPLOYEE
                               WHERE EMP_NAME = '노옹철')
  AND EMP_NAME != '노옹철';
-- 2. 2000년도에 입사한 사원의 부서와 직급이 같은 사원을 조회하시오.
--    사번, 이름, 부서코드, 직급코드, 고용일
SELECT EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , JOB_CODE
     , HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE
                                    , JOB_CODE
                               FROM EMPLOYEE
                               WHERE EXTRACT(YEAR FROM HIRE_DATE) = 2000);


-- 3. 77년생 여자 사원과 동일한 부서이면서 동일한 사수를 가지고 있는 사원을 조회하시오.
--    사번, 이름, 부서코드, 사수번호, 주민번호, 고용일
SELECT EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , MANAGER_ID
     , EMP_NO
     , HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE
                                      , MANAGER_ID
                                 FROM EMPLOYEE
                                 WHERE SUBSTR(EMP_NO, 1, 2) = 77
                                   AND SUBSTR(EMP_NO, 8, 1) = 2);
----------------------------------------------------------------------------------------------
-- 4. 다중행 다중열 서브쿼리
--     서브쿼리 조회 결과 행 수와 열 수가 여러개 일때

-- 1) 본인 직급의 평균 급여를 받고 있는 직원의
--    사번,이름,직급코드, 급여를 조회하세요
--    단, 급여와 급여 평균은 만원 단위로 계산하세요 TRUNC(컬럼명,-5)

-- > 직급별 평균 급여구하기
SELECT JOB_CODE
     , TRUNC(AVG(SALARY), -5)
FROM EMPLOYEE
GROUP BY JOB_CODE;
--> 본인 직급별 평균 급여를 받고 있는 직원
SELECT EMP_ID
     , EMP_NAME
     , JOB_CODE
     , SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE
                                  , TRUNC(AVG(SALARY), -5)
                             FROM EMPLOYEE
                             GROUP BY JOB_CODE);

-- 각 부서별 최고 급여를 받는 사원을 조회하시오(단, 부서별 오름차순 정렬하시오)
-- 사번, 사원명, 부서코드, 급여
SELECT EMP_ID
     , EMP_NAME
     , DEPT_CODE
     , SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE
                                   , MAX(SALARY)
                              FROM EMPLOYEE
                              GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;

--------------------------------------------------------------------------------
-- 5. 상관[호연] 서브쿼리
--      일반적으로 서브쿼리가 만든 결과값을 메인쿼리가 비교 연산하는 구조
--      상관 쿼리는 메인쿼리가 사용하는 테이블값을 서브쿼리가 이용해서 결과를 만든다.
--      메인쿼리의 테이블값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조이다.


-- 1) 사수가 있는 직원의 사번,이름,부서명,사수사번 조회
SELECT EMP_ID
     , EMP_NAME
     , DEPT_TITLE
     , MANAGER_ID
FROM EMPLOYEE E
         JOIN DEPARTMENT D
              ON (E.DEPT_CODE = D.DEPT_ID)
WHERE EXISTS(SELECT -- EXISTS : 서브쿼리에 해당하는 행이 적어도 한 개 이상 존재할 경우 충족되는 SELECT가 실행된다.
                    EMP_ID
             FROM EMPLOYEE M
             WHERE E.MANAGER_ID = M.EMP_ID);
-- 서브쿼리에서 메인쿼리의 테이블값인 E.MANAGER_ID를 이용하여 결과를 만든다 --> 상관쿼리

-- 2) 직급별 급여 평균보다 급여를 많이 받는 직원의 이름, 직급코드, 급여 조회
SELECT EMP_NAME
     , JOB_CODE
     , SALARY
FROM EMPLOYEE E
WHERE SALARY > (SELECT TRUNC(AVG(SALARY), -5)
                FROM EMPLOYEE M
                WHERE E.JOB_CODE = M.JOB_CODE);


-- 6. 스칼라 서브쿼리
--       SELECT절에 사용되는 서브쿼리 결과로 1행만 반환
--       SQL에서 단일 값을 가리켜서 '스칼라'라고한다

-- 1) 모든 사원의 사번,이름,사수사번, 사수명을 조회
--    단, 사수가 없는 경우 '없음'으로 표시
SELECT EMP_ID
     , EMP_NAME
     , MANAGER_ID
     , NVL((SELECT EMP_NAME
            FROM EMPLOYEE M
            WHERE E.MANAGER_ID = M.EMP_ID), '없음') AS 사수명
FROM EMPLOYEE E
ORDER BY EMP_ID;

-- 7. 인라인 뷰(INLINE-VIEW)
--      FROM절에서 서브쿼리를 사용하는 경우로
--      서브쿼리가 만든 결과의 집합(RESULT SET)을 테이블 대신에 사용한다.

-- 1) 인라인뷰를 활용한 TOP-N분석
--       전 직원 중 급여가 높은 상위 5명 순위, 이름, 급여 조회
-- ROWNUM : 조회된 순서대로 1부터 번호를 매길 수 있는 컬럼
SELECT ROWNUM
     , EMP_NAME
     , SALARY
FROM EMPLOYEE;

SELECT ROWNUM
     , EMP_NAME
     , SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;

-- 위의 ROWNUM을 이용해서 단순히 정렬 후 상위 5명 뽑기
SELECT ROWNUM
     , EMP_NAME
     , SALARY
FROM EMPLOYEE
WHERE ROWNUM <= 5 --> 상위 5명을 뽑겠다는 의미의 조건식
ORDER BY SALARY DESC;
-- 하지만 해석 순서상 ORDER BY 절 전에 (즉, 정렬되기 전에) 상위 5명을 뽑기 때문에 원하는 결과대로 안나온다.
--1   선동일   8000000
--2   송종기   6000000
--6   정중하   3900000
--16   대북혼   3760000
--3   노옹철   3700000

-- > 해결방법 - ORDER BY 한 다음에 ROWNum을 붙이려면 인라인뷰를 통해 이용해야한다.
SELECT ROWNUM
     , EMP_NAME
     , SALARY
FROM (SELECT *
      FROM EMPLOYEE
      ORDER BY SALARY DESC)
WHERE ROWNUM <= 5;

-- 2) 급여 평균 3위 안에 드는 부서의 부서코드와 부서명, 평균급여를 조회하세요.

SELECT *
FROM (SELECT DEPT_CODE
           , DEPT_TITLE
           , FLOOR(AVG(SALARY)) 평균급여
      FROM EMPLOYEE
               JOIN DEPARTMENT
                    ON (DEPT_CODE = DEPT_ID)
      GROUP BY DEPT_CODE, DEPT_TITLE
      ORDER BY 평균급여 DESC)
WHERE ROWNUM <= 3;

-- 8. WITH
--      서브쿼리에 이름을 붙여주고 사용 시 이름을 사용하게된다
--      인라인뷰로 사용될 서브쿼리에 주로 사용한다.
--      이점은 실행 속도도 빨라진다는 장점이 있다

-- 1) 전 직원의 급여 순위, 이름, 급여 조회
WITH TOPN_SAL AS (SELECT EMP_ID
                       , EMP_NAME
                       , SALARY
                  FROM EMPLOYEE
                  ORDER BY SALARY DESC)

SELECT ROWNUM, EMP_NAME, SALARY
FROM TOPN_SAL;

-- 9. RANK() OVER / DENSE_RANK() OVER

-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원수만큼 건너뛰고 순위 계산
--               ex) 공동 1위가 2명이면 다음 순위는 2위가 아니라 3위이다.
SELECT EMP_NAME
     , SALARY
     , RANK() OVER (ORDER BY SALARY DESC) AS 순위
FROM EMPLOYEE;
-- > 공동 19등 후 21등으로 조회

-- DENSE_RANK() OVER : 동일한 순위 이후의 등수를 이후의 순위로 계산
--                      ex) 공동 1위가 2명이어도 다음 순위는 2위
SELECT EMP_NAME
     , SALARY
     , DENSE_RANK() OVER (ORDER BY SALARY DESC) AS 순위
FROM EMPLOYEE;
--> 공동 19등 후 20등으로 조회


/*
   데이터 사전(딕셔너리)란?
      자원을 효율적으로 관리하기 위한 다양한 정보를 저장하는 시스템 테이블
      데이터 사전은 사용자가 테이블을 생성하거나 사용자를 변경하는 등의
      작업을 할 때 데이터베이스 서버에 의해 자동으로 갱신되는 테이블

   USER_TABLES : 자신의 계정이 소유한 객체 등에 관한 정보를 조회 할 수 있는 딕셔너리 뷰
   USER_TAB_COLUMNS : 테이블,뷰,컬럼과 관련된 정보 조회

   DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어

   객체(OBJECT)를 만들고(CREATE), 수정(ALTER)하고, 삭제(DROP) ㄷ으등
   데이터의 전체 구조를 정의하는 언어로 주로 DB관라자, 설계자가 사용한다.

   오라클에서의 객체 : 테이블(TABLE),뷰(VIEW), 시퀀스(SEQUENCE),
                       인덱스(INDEX),패키지(PACKAGE),트리거(TRIGGER),프로시져(PROCEDURE),함수(FUNCTION)
                       동의어(SYSNONYN),사용자(USER)

   CREATE
   테이블이나 인덱스, 뷰 등 다양한 데이터베이스 객체를 생성하는 구문
   테이블로 생성된 객체는 DROP구분을 통해서 제거할 수있다.


   1. 테이블 만들기
      테이블이란?  행(ROW)과 열(COLUMN)으로 구성되는 가장 기본적인 데이터베이스 객체
                  데이터 베이스 내에서 모든 데이터는 테이블을 통해서 저장된다.

     * 표현식
     CREATE 테이블명(
         컬럼명    자료형(크기)
      ,  컬럼명    자료형(크기) ....
     );
*/
CREATE TABLE MEMBER
(
    MEMBER_ID   VARCHAR2(20),
    MEMBER_PWD  VARCHAR2(20),
    MEMBER_NAME VARCHAR2(20),
    MEMBER_DATE DATE DEFAULT SYSDATE
);
-- DEFAULT 를 통해서 기본값을 지정할 수 있다.
SELECT *
FROM MEMBER;


-- 컬럼에 주석달기
-- [표현식]
-- COMMENT ON COLUMN 테이블명.컬럼명 IS '주석내용';

COMMENT ON COLUMN MEMBER.MEMBER_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEMBER_PWD IS '비밀번호';
COMMENT ON COLUMN MEMBER.MEMBER_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.MEMBER_DATE IS '회원가입일';

-- USER_TABLES : 사용자가 작성한 테이블을 확인하는 뷰
SELECT *
FROM USER_TABLES;

-- DML -- > INSERT구문
-- INSERT INTO 테이블명 VALUES('값','값'....);
INSERT INTO MEMBER
VALUES ('MEM1', '1234ACV', '홍길동', '2020-07-01');
SELECT *
FROM MEMBER;

INSERT INTO MEMBER
VALUES ('MEM2', 'QWER1234', '김영희', SYSDATE);
INSERT INTO MEMBER
VALUES ('MEM3', 'Z1231231', '박철수', DEFAULT);
INSERT INTO MEMBER
VALUES ('MEM4', 'ADSFSDF', '이순신', SYSDATE);

/*
   제약조건 - CONSTRAINTS
      사용자가 원하는 조건의 데이터만 유지하기 위해서 특정 컬럼에 설정하는 제약

      테이블 작성 시 각 컬럼에 대해 값 기록에 대한 제약조건 설정 가능
      --> 데이터 무결성 보장하기 위해서
      입력데이터에 문제가 없는지 자동으로 검사하는 목적
      데이터의 수정/삭제 가능 여부 검사등을 목적으로한다.

      PRIMARY KEY, NOT NULL, UNIQUE, CHECK, FOREIGN KEY
*/

-- 제약조건확인
-- USER_CONSTRAINTS : 사용자가 작성한 제약조건을 확인하는 뷰테이블
SELECT *
FROM USER_CONSTRAINTS;
DESC USER_CONSTRAINTS;

-- USER_CONS_COLUMNS : 제약조건이 걸려있는 컬럼을 확인하는 뷰 테이블
SELECT *
FROM USER_CONS_COLUMNS;

-- * NOT NULL 제약조건
--     해당 컬럼에 반드시 값이 기록되어야 하는 경우 사용
--     삽입/수정 시 NULL값을 허용하지 않도록 컬럼레벨에서 제한

-- NOT NULL 제약 조건설정을 딱히 안한 일반 테이블을 만들자
DROP TABLE MEM_NOCONST;
CREATE TABLE MEM_NOCONST
(
    MEM_NO   NUMBER,
    MEM_ID   VARCHAR2(20),
    MEM_PWD  VARCHAR2(30),
    MEM_NAME VARCHAR2(30),
    GENDER   VARCHAR2(3),
    PHONE    VARCHAR2(30),
    EMAIL    VARCHAR2(50)
);

INSERT INTO MEM_NOCONST
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or');
INSERT INTO MEM_NOCONST
VALUES (2, NULL, NULL, NULL, NULL, '010-1234-5678', 'hong123@kh.or');
-- > 값에 NULL이 있어도 삽입 성공
SELECT *
FROM MEM_NOCONST;

-- NOT NULL 제약조건설정을 한 테이블 만들기

--   >> 테이블 생성 시 제약조건을 설정하는 방식은 두가지가 존재한다. (컬럼레벨,테이블레벨)
--  ******* NOT NULL 제약조건은 컬럼레벨 방식밖에 안된다.
--  컬럼레벨 방식 : 단순히 컬럼을 기입하는데 뒤에 제약조건을 붙이는 방식
--  [표현식] : 컬럼명   자료형(크기) 제약조건

CREATE TABLE MEM_NOTNULL
(
    MEM_NO   NUMBER       NOT NULL,
    MEM_ID   VARCHAR2(20) NOT NULL,
    MEM_PWD  VARCHAR2(30) NOT NULL,
    MEM_NAME VARCHAR2(30) NOT NULL,
    GENDER   VARCHAR2(3),
    PHONE    VARCHAR2(30),
    EMAIL    VARCHAR2(50)
);

INSERT INTO MEM_NOTNULL
VALUES (1, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or');
INSERT INTO MEM_NOTNULL
VALUES (2, NULL, NULL, NULL, NULL, '010-1234-5678', 'hong123@kh.or');
--> NOT NULL 제약조건에 위배되어 오류 발생
--> NOT NULL 제약조건이 걸려있는 컬럼에는 값이 반드시 있어야 된다.
/*
[오류발생]
INSERT INTO MEM_NOTNULL VALUES(2,NULL,NULL,NULL,NULL,'010-1234-5678','hong123@kh.or')
오류 보고 -
ORA-01400: cannot insert NULL into ("EMPLOYEE"."MEM_NOTNULL"."MEM_ID")
*/
SELECT *
FROM MEM_NOTNULL;
--------------------------------------------------------------------------------------------------------------------
-- * UNIQUE 제약조건
--     컬럼에 입력 값에 대해서 중복을 제한하는 제약조건
--     기존에 있는 데이터 중에 중복이 있으면 안된다.
--     (제약조건 지정방식 : 컬럼레벨, 테이블레벨 방식)

INSERT INTO MEM_NOTNULL
VALUES (2, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or');

CREATE TABLE MEM_UNIQUE
(
    MEM_NO   NUMBER       NOT NULL,
    MEM_ID   VARCHAR2(20) NOT NULL UNIQUE -->컬럼레벨 지정, 여러개의 제약조건도 지정이 가능하다.
    ,
    MEM_PWD  VARCHAR2(30) NOT NULL,
    MEM_NAME VARCHAR2(30) NOT NULL,
    GENDER   VARCHAR2(3),
    PHONE    VARCHAR2(30),
    EMAIL    VARCHAR2(50)
);

INSERT INTO MEM_UNIQUE
VALUES (2, 'user01', 'pass01', '홍길동', '남', '010-1234-5678', 'hong123@kh.or');
-- 같은 아이디인 데이터가 이미 테이블에 있으므로 UNIQUE제약조건에 위배된다.
SELECT *
FROM MEM_UNIQUE;

-- 오류 보고에 나타나는 SYS_C00XXXX 같은 제약 조건명으로
-- 해당 제약 조건이 설정된 테이블명, 컬럼, 제약 조건 타입 조회
SELECT UCC.TABLE_NAME, UCC.COLUMN_NAME, UC.CONSTRAINT_TYPE
FROM USER_CONSTRAINTS UC,
     USER_CONS_COLUMNS UCC
WHERE UCC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME
  AND UCC.CONSTRAINT_NAME = 'SYS_C007059';

CREATE TABLE MEM_UNIQUE2
(
    MEM_NO   NUMBER       NOT NULL,
    MEM_ID   VARCHAR2(20) NOT NULL,
    MEM_PWD  VARCHAR2(30) NOT NULL,
    MEM_NAME VARCHAR2(30) NOT NULL,
    GENDER   VARCHAR2(3),
    PHONE    VARCHAR2(30),
    EMAIL    VARCHAR2(50)
);
























