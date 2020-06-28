-- DAY3 수업내용
-- NULL 처리함수
-- NVL 함수
-- NVL 함수는 NULL을 0 또는 다른 값으로 변환하기 위해 사용하는 함수
-- NULL을 실제 값으로 변환하기 위해서 사용하는 데이터 유형은 날짜, 문자, 숫자 -> 주의할 점 두 값의 데이터 타입은 일치해야한다
-- NVL(NULL을 포함하는 컬럼 또는 표현식 , NULL을 대체하는 값)
SELECT
    EMP_NAME
,   BONUS
,   NVL(BONUS, 0)
FROM
    EMPLOYEE;

-- NVL2함수
-- NVL2(컬럼명, 바꿀값1,바꿀값2)
-- 해당 컬럼이 값이 있으면 바꿀값1 로 변경
-- 해당 컬럼이 NULL이면 바꿀값 2 로 변경

-- 직원정보에서 보너스포인트가 NULL인 직원은 0.5로
-- 보너스 포인트가 NULL이 아닌 경우 0.7로 변경하여 조회

SELECT
    EMP_NAME
,   BONUS
,   NVL2(BONUS,0.7,0.5)
FROM
    EMPLOYEE;

-- 선택함수
-- ㅇ러가지 경우에 선택할 수 있는 기능을 제공한다
-- DECODE(계산식|컬럼명,조건값1,선택값1,조건값2,선택값2,...)
SELECT
    EMP_ID
,   EMP_NAME
,   EMP_ID
,   DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여')
FROM
    EMPLOYEE;

SELECT
    EMP_ID
,   EMP_NAME
,   EMP_ID
,   DECODE(SUBSTR(EMP_NO,8,1),'1','남','여')
FROM
    EMPLOYEE;

-- CASE WHEN THEN
-- CASE WHEN 조건식 THEN 결과값
--      WHEN 조건식 THEN 결과값
--      ELSE 결과값
-- END

SELECT
    EMP_NAME
,   JOB_CODE
,   SALARY
,   CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1
         WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
        WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
        ELSE SALARY * 1.05
    END AS "인상급여"
FROM EMPLOYEE;

-- OEDER BY 절 : SELECT 한 컬럼을 가지고 정렬을 할 때 사용함
-- ORDER BY 컬럼명| 컬럼별칭 | 컬럼나열 순번 [ASC]|DESC
-- ORDER BY 컬럼명 정렬방식, 컬럼명 정렬방식, 컬럼명, 정렬방식
-- 첫번째 기준으로 하는 컬럼에 대해 정렬하고,
-- 같은 값들에 대해 뚜번 째 기준으로 하는 컬럼에 대해 다시 정렬
-- SELECT 구문 맨 마지막에 위치한다.
-- 실행순서도 맨 마지막에 실행된다.

SELECT
    EMP_NAME
,   JOB_CODE
,   SALARY
,   CASE WHEN JOB_CODE = 'J7' THEN SALARY * 1.1
         WHEN JOB_CODE = 'J6' THEN SALARY * 1.15
        WHEN JOB_CODE = 'J5' THEN SALARY * 1.2
        ELSE SALARY * 1.05
    END AS "인상급여"
FROM EMPLOYEE
ORDER BY 1 DESC;

-- GROUP BY 절 : 같은 값들이 여러개 기록된 컬럼을 가지고
--                 같은 값들을 하나의 그룹으로 묶는다.
-- GROUP BY 컬럼명 | 함수식..
-- 여러개의 값을 묶어서 하나의 그룹으로 처리할 목적으로 사용한다.
-- 그룹으로 묶은 값에 대해서 SELECT 절에서 그룹함수를 사용한다.
-- HAVING절 : 그룹함수로 구해올 그룹에 대해 조건을 설정할 때 사용
-- HAVING 컬럼명 | 함수식 비교연산자 비교값
/*

    5.SELECT 컬럼명 AS 별칭, 계산식, 함수식
    1.FROM 참조할 테이블명
    2.WHERE 컬럼명 : 함수식 비교연산자 비교값
    3.GROUP BY 그룹을 묶을 컬럼명
    4.HAVING 그룹함수식 비교연산자 비교값
    6.ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식
*/

SELECT
    COUNT(*) 사원수
,   DEPT_CODE
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;