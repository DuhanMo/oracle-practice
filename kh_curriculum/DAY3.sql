-- DAY3 수업내용
-- NULL 처리 함수
-- NVL함수
-- NVL함수는 NULL을 0또는 다른 값으로 변환하기 위해서 사용하는 함수
-- NULL을 실제 값으로 변환하기 위해서 사용하는 데이터 유형은 날짜,문자,숫자 -> 주의할점 두 값의 데이터 타입은 일치해야한다.
-- NVL(NULL을 포함하는 컬럼 또는 표현식, NULL을 대체하는 값)
SELECT
    EMP_NAME
  , BONUS
  , NVL(BONUS,'0')
FROM EMPLOYEE;

-- NVL2함수
-- NVL2(컬럼명,바꿀값1,바꿀값2)
-- 해당 컬럼이 값이 있으면 바꿀값1로 변경,
-- 해당 컬럼이 NULL이면 바꿀값2로변경

-- 직원정보에서 보너스포인트가 NULL인 직원은 0.5로
-- 보너스 포인트가 NULL이 아닌 경우 0.7로 변경하여 조회
SELECT
    EMP_NAME
  , BONUS
  , NVL2(BONUS,0.7,0.5)
FROM
    EMPLOYEE;

-- 선택함수
-- 여러가지 경우에 선택할 수 있는 기능을 제공한다
-- DECODE(계산식|컬럼명,조건값1,선택값1,조건값2,선택값2,.....)
SELECT
    EMP_ID
  , EMP_NAME
  , EMP_NO
  , DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여')
FROM
    EMPLOYEE;
-- 마지막 인자로 조건값 없이 선택값을 작성하면
-- 아무것도 해당하지 않을 때 마지막에 작성한 선택값을 무조건 선택한다.
SELECT
    EMP_ID
  , EMP_NAME
  , EMP_NO
  , DECODE(SUBSTR(EMP_NO,8,1),'1','남','여')
FROM
    EMPLOYEE;

-- CASE WEHN THEN
-- CASE WHEN 조건식 THEN 결과값
--      WHEN 조건식 THEN 결과값
--      ELSE 결과값
-- END


SELECT
    EMP_NAME
  , JOB_CODE
  , SALARY
  , CASE WHEN JOB_CODE ='J7' THEN SALARY *1.1
         WHEN JOB_CODE ='J6' THEN SALARY *1.15
         WHEN JOB_CODE ='J5' THEN SALARY *1.2
         ELSE SALARY * 1.05
    END AS 인상급여
FROM EMPLOYEE;

-- ORDER BY 절 : SELECT한 컬럼을 가지고 정렬을 할 떄 사용함
-- ORDER BY 컬럼명 | 컬럼별칭| 컬럼나열 순번 [ASC]|DESC
-- ORDER BY 컬럼명 정렬방식, 컬럼명 정렬방식, 컬럼명, 정렬방식....
-- 첫번째 기준으로 하는 컬럼에 대해 정렬하고,
-- 같은 값들에 대해 두번 쨰 기준으로 하는 컬럼에 대해 다시 정렬
-- SELECT 구문 맨 마지막에 위치한다.
-- 실행순서도 맨마지막에 실행된다.
SELECT
    EMP_NAME
  , JOB_CODE
  , SALARY
  , CASE WHEN JOB_CODE ='J7' THEN SALARY *1.1
         WHEN JOB_CODE ='J6' THEN SALARY *1.15
         WHEN JOB_CODE ='J5' THEN SALARY *1.2
         ELSE SALARY * 1.05
    END AS 인상급여
FROM EMPLOYEE
ORDER BY 1 DESC;

-- GROUP BY 절 : 같은 값들이 여러개 기록된 컬럼을 가지고
--               같은 값들을 하나의 그룹으로 묶는다.
-- GROUP BY 컬럼명 | 함수식...
-- 여러 개의 값을 묶어서 하나의 그룹으로 처리할 목적으로 사용한다.
-- 그룹으로 묶은 값에 대해서 SELECT 절에서 그룹함수를 사용한다.
-- HAVING절 : 그룹함수로 구해올 그룹에 대해 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값

/*
   5: SELECT 컬럼명 AS 별칭, 계산식, 함수식
   1: FROM 참조할 테이블명
   2: WHERE 컬럼명 | 함수식 비교연산자 비교값
   3: GROUP BY 그룹을 묶을 컬럼명
   4: HAVING 그룹함수식 비교연산자 비교값
   6: ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식
*/

SELECT
    COUNT(*) 사원수
 , DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

----------------------------------------------------------------
-- 급여가 300만원이상인 직원이 속한 부서를 고를때
SELECT DEPT_CODE,FLOOR(AVG(SALARY)) 평균
FROM EMPLOYEE
WHERE SALARY > 3000000
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 급여 평균이 300만원 이상인 부서를 고르느냐
SELECT DEPT_CODE,FLOOR(AVG(SALARY)) 평균
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >3000000
ORDER BY DEPT_CODE;

-- 집계함수
-- ROLLUP 함수 : 그룹별로 중간 집계 처리를 하는 함수
-- GROUP BY 절에서만 사용하는 함수
-- 그룹별로 묶여진 값에 대한 중간 집계와 총 집계를 구할 때 사용한다.
-- 그룹별로 계산된 결과값들에 대한 총집계가 자동으로 추가된다.
SELECT JOB_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY JOB_CODE;

-- CUBE 함수 : 그룹별 산출한 결과를 집계하는 함수
SELECT JOB_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY JOB_CODE;

SELECT JOB_CODE,DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE,DEPT_CODE)
ORDER BY DEPT_CODE;
SELECT * FROM EMPLOYEE;
SELECT JOB_CODE,DEPT_CODE,SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE,DEPT_CODE)
ORDER BY DEPT_CODE;


-- GROUPING함수 : ROLLUP이나 CUBE에 의한 산출물이
-- 인자로 전달받은 컬럼 집합의 산출물이면 0을 반환하고
-- 아니면 1을 반환하는 함수
SELECT DEPT_CODE,JOB_CODE,SUM(SALARY),
       GROUPING(DEPT_CODE) "부서별그룹묶인상태"
     , GROUPING(JOB_CODE) "직급별그룹묶인상태"
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE,JOB_CODE)
ORDER BY DEPT_CODE;


SELECT DEPT_CODE,JOB_CODE,SUM(SALARY),
       CASE WHEN GROUPING(DEPT_CODE) = 0
                  AND GROUPING(JOB_CODE) = 1
            THEN '부서별합계'
            WHEN GROUPING(DEPT_CODE) = 1
                 AND GROUPING(JOB_CODE) = 0
            THEN '직급별합계'
            WHEN GROUPING(DEPT_CODE) =0
                 AND GROUPING(JOB_CODE) =0
            THEN '그룹별합계'
            ELSE '총합계'
        END AS 구분
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE,JOB_CODE)
ORDER BY DEPT_CODE;

--SET OPERATION(집합연산)
-- UNION : 여러개의 쿼리 결과를 하나로 합치는 연산자
--          중복된 영역을 제외하여 하나로 합친다.
SELECT EMP_ID, EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'
UNION
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- UNIONALL : 여러개의 쿼리를 하나로 합치는 연산자
--          UNION과의 차이점은 중복영역을 모두 포함시킨다.
SELECT EMP_ID, EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

-- INTERSECT : 여러개의 SELECT 한 결과에서 공통부분만 결과로 추출, 교집합과 비슷하다.

SELECT EMP_ID, EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;


-- MINUS : 선행 SELECT결과에서 다음 SELECT결과와 겹치는 부분을 제외한 나머지 부분만 추출, 차집합과 비슷

SELECT EMP_ID, EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;

