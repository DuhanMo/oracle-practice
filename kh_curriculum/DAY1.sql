--DAY1

-- 단일주석
/*여러줄 주석*/

-- EMPLOYEE 테이블에서 모든 정보 조회
SELECT * FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 이름 정보 조회
SELECT 
    EMP_ID,
    EMP_NAME
FROM

    EMPLOYEE;


-- EMPLOYEE 테이블에서 부서코드가 D4인 사원 조회
SELECT *
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- EMPLOYEE 테이블에서 직급코드가 J1인 사원 조회
SELECT *
FROM EMPLOYEE
WHERE JOB_CODE = 'J1';

-- EMPLOYEE 테이블에서 급여가 300만원 이상인 사람의 
-- 사번, 이름. 부서코드, 급여를 조회
SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

-- 컬럼에 별칭 짓기
-- AS 별칭 을 기술하여 별칭을 지을 수 있다.

SELECT 
    EMP_NAME AS "이름"
    ,SALARY * 12 "1년 급여(원)" 
    ,(SALARY + (SALARY * NVL(BONUS,0))) * 12 AS "총 소득(원)"
FROM EMPLOYEE;

-- 임의의 지정한 문자열을 SELECT절에서 사용할 수 있다.
SELECT EMP_ID
      ,EMP_NAME
      ,SALARY 
      ,'원' AS 단위
FROM  EMPLOYEE; 

-- 연결연산자(||) : 여러 컬럼을 하나의 컬럼인것처럼 연결할 수 있다.
-- 컬럼과 컬럼을 연결해보자
SELECT
    EMP_ID || EMP_NAME || SALARY
FROM
    EMPLOYEE;
    
-- 컬럼과 리터럴 연결
SELECT
    EMP_NAME || '의 월급은 ' || SALARY || '원 입니다.' 
FROM
    EMPLOYEE;
    
-- 비교연산자
-- = 같다, >크다, <작다, >= 크거나 같다, <= 작거나같다
-- !=,^=,<> 같지않다.
SELECT
    EMP_ID
   ,EMP_NAME
   ,DEPT_CODE
FROM
    EMPLOYEE
WHERE
--    DEPT_CODE != 'D9';
    DEPT_CODE <> 'D9';
    
SELECT
    EMP_ID
   ,EMP_NAME
   ,HIRE_DATE
   ,'재직중' 근무여부
FROM
    EMPLOYEE
WHERE
    ENT_YN = 'N';
    
    
-- EMPLOYEE 테이블에서 급여를 350만원 이상
-- 550 만원 이하를 받는
-- 직원의 사번,이름,급여,부서코드,직급코드를 조회

SELECT
    EMP_ID
   ,EMP_NAME
   ,SALARY
   ,DEPT_CODE
   ,JOB_CODE
FROM
    EMPLOYEE
WHERE
    salary >= 3500000
    AND salary <=5500000;
    
--BETWEEN AND 사용
--컬렴명 BEWEEN 하한값 AND 상한값
--하한값 이상, 상한값 이하의 값

SELECT
    EMP_ID
   ,EMP_NAME
   ,SALARY
   ,DEPT_CODE
   ,JOB_CODE

FROM
    EMPLOYEE
WHERE
--    SALARY BETWEEN 3500000 AND 5500000;
-- NOT SALARY BETWEEN 3500000 AND 5500000;
SALARY NOT BETWEEN 3500000 AND 5500000; 


-- LIKE 연산자 : 문자패턴이 일치하는 값을 조회할 때 사용
-- 컬럼명 LIKE '문자패턴'
-- 문자패턴
--      : '글자%'


-- EMPLOYEE 테이블에서 성이 김씨인 직원의 사번,이름,입사일 조회
SELECT 
    EMP_ID
   ,EMP_NAME
   ,HIRE_DATE
FROM
    EMPLOYEE
WHERE
    EMP_NAME NOT LIKE '김%';
    
-- EMPLOYEE 테이블에서 '하'가 이름에 포함된 직원의 이름,주민번호,부서코em

SELECT 
    EMP_ID
   ,EMP_NAME
   ,HIRE_DATE
FROM 
    EMPLOYEE
WHERE
     EMP_NAME LIKE '%하%';

--와일드카드 사용 : _(글자 한자리), %(0개 이상의 글자)
SELECT
    EMP_ID
   ,EMP_NAME
   ,PHONE
FROM
    EMPLOYEE
WHERE
    PHONE LIKE '___9%';
    
-- IN연산자 : 비교하려는 값 목록에 일치하는 값이 있는지 확인

SELECT
    EMP_NAME
   ,DEPT_CODE
   ,SALARY
FROM
    EMPLOYEE
WHERE
--    DEPT_CODE ='D6'
--    OR DEPT_CODE = 'D8';
    DEPT_CODE IN ('D6','D8');

-- 널값 조희
SELECT
    EMP_ID
   ,EMP_NAME
   ,SALARY
   ,BONUS
FROM
    employee
WHERE
    bonus IS NULL;


-- DISTINT 키워드 : 중복된 컬럼값을 제거하여 조회

SELECT
    DISTINCT job_code
FROM
    employee;

SELECT job_code FROM employee;

-- DISTINCT 키워드는 SELECT 절에 딱한번만 쓸 수 있다
-- 여러개의 컬럼을 묶어서 중복을 제외시킨다
SELECT
    DISTINCT job_code, dept_code
FROM
    employee;



-- 연산자 우선순위
-- 1. 산술연산자
-- 2. 연결연산자
-- 3. 비교연산자
-- 4. IS NULL / IS NOT NULL, LIKE / NOT LIKE, IN / NOT IN
-- 5. BETWEEM AND / NOT BETWEEN AND
-- 6. NOT(논리연산자)
-- 7. AND
-- 8. OR




SELECT
    EMP_NAME
   ,SALARY
   ,JOB_CODE
FROM
    EMPLOYEE
WHERE
    (job_code = 'J2' AND salary >= 2000000)
  OR(job_code = 'J7');  


SELECT
    EMP_NAME
   ,SALARY
   ,JOB_CODE
FROM
    EMPLOYEE
WHERE
--    (job_code='J7' OR job_code='J2') 
    job_code IN ('J2','J7')
    AND salary >=2000000;


-- 함수 : 컬럼 값을 읽어서 계산한 결과를 리턴한다
-- 단일행(single row) 함수 : 컬럼에 기록된 n개의 값을 읽어서 n개의 결과를 리턴
-- 그룹(group)함수 : 컬럼에 기록된 n개의 값을 읽어서 한개의 결과를 리턴

-- SELECT 절에 단일행 함수와 그룹함수를 함께 사용 못한다. why? 결과 행의 갯수가 다르기 때문에
-- 함수를 사용할 수 있는 위치 : SELECT절, WHERE절, GROUP BY 절, HAVING절, ORDER BY절

-- 그룹함수 : SUM,AVG,MAX,MIN,COUNT
-- SUM(숫자가 기록된 컬럼명) : 합계를 구하여 리턴
SELECT
    SUM(salary)
FROM
    employee;
    
-- AVG(숫자가 기록된 컬럼명) : 평균을 구하며 리턴
SELECT AVG(salary)
FROM employee;

SELECT 
    AVG(bonus) 기본평균
   ,AVG(DISTINCT bonus) 중복제거평균 
   ,AVG(NVL(bonus,0))  NULL포함평균
FROM employee;

-- 특수문자 < 숫자 < 숫자(특) < 영문 < 영문(특) < 한글 < 한글(특)
-- 취급하는 자료형은 ANY TYPE

SELECT
    MAX(EMAIL)
   ,MAX(HIRE_DATE)
   ,MAX(SALARY)
FROM EMPLOYEE;

-- COUNT(*|컬럼명) : 행의 갯수를 헤아려서 리턴
-- COUNT(*) : NULL 을 포함한 전체 행 갯수 리턴

SELECT
    COUNT(*)
 ,   COUNT(dept_code)
 ,  COUNT(DISTINCT dept_code)
FROM EMPLOYEE;

-- 단일행 함수
-- 문자 관련 함수
-- LERNGTH, LENGTHB, SUBSTR, UPPER, LOWER,INSTR..
-- LENGTH : 문자열 길이
-- LENGTHB : 문자열의 바이트를 전환
-- 영문자(1바이트, 공백(1바이트), 한글(3바이트)


-- INSTR('문자열'|컬럼명,'문자',찾을 위치의 시작값,[빈도])
SELECT
    INSTR('HELLO WORLD','O') STR1 --문자열의 앞에서부터 찾기(기본사용)
,   INSTR('HELLO WORLD','O',1) STR2 --문자열의 앞에서부터 찾기
,   INSTR('HELLO WORLD','O',-1) STR3 --문자열의 뒤에서부터 찾기 숫자는 왼쪽에서부터 셈
,   INSTR('HELLO WORLD','O',-1,1) STR4 --문자열의 뒤에서부터 찾기 숫자는 왼쪽에서부터 셈, 한번만 찾기(빈도)
,   INSTR('HELLO WORLD','O',-1,2) STR5 --문자열의 뒤에서부터 찾기 숫자는 왼쪽에서부터 셈, 두번째거 찾기(빈도2)
FROM dual;

SELECT INSTR('AABAACAABBAA','B') FROM DUAL; --3
SELECT INSTR('AABAACAABBAA','B',1) FROM DUAL; --3
SELECT INSTR('AABAACAABBAA','B',-1) FROM DUAL; --10
SELECT INSTR('AABAACAABBAA','B',1,2) FROM DUAL; --9
SELECT INSTR('AABAACAABBAA','B',-1,2) FROM DUAL; --9


-- EMPLOYEE 테이블에서 사원명, 이메일 , @ 이후를 제외한 아이디 조회
SELECT
    emp_name
,   email
,   SUBSTR(email,1,INSTR(email,'@')-1)
FROM employee;



-- LPAD / RPAD : 주어진 컬럼 문자열에 임의의 문자열을 덧붙여 길이 n의 문자열을 반환하는 함수
-- LPAD는 왼쪽부터 채움, RPAD는 오른쪽부터 채움(주민등록번호 할때 유리)
SELECT
    LPAD(email,10,'*')
FROM employee;
SELECT
    RPAD(email,10)
FROM employee;

-- 함수의 중첩사용 가능
SELECT
    emp_name 사원명
,   RPAD(SUBSTR(emp_no,1,7),14,'*') 주민번호
FROM
    employee;
    
-- LTRIM/RTRIM : 주어진 컬럼이나 문자열 왼쪽/오른쪽에서 지정한 문자 혹은 문자열을 제거한 나머지를 반환하는 함수
SELECT LTRIM('    KH')FROM dual; -- 디폴트는 공백을 짜름 밑에거랑 같은결과
SELECT LTRIM('    KH',' ') FROM dual;
SELECT LTRIM('AAAKHA','A')FROM dual;
SELECT LTRIM('000123456','0')FROM dual;
SELECT LTRIM('123123KH','123')FROM dual;
SELECT LTRIM('123321KH','123')FROM dual;
SELECT LTRIM('ACABACLCKH','ABC')FROM dual; --순서가 달라도 A,B,C 있으면 그냥 다 잘라버리고 L 이라는 새로운게 있으면 거기부턴 안짜름.
SELECT LTRIM('5782KH','0123456789')FROM dual;


SELECT RTRIM('KH   ')FROM dual; -- 디폴트는 공백을 짜름 밑에거랑 같은결과
SELECT RTRIM('KH   ',' ') FROM dual;
SELECT RTRIM('KHAAAA','A')FROM dual;
SELECT RTRIM('123456000','0')FROM dual;
SELECT RTRIM('KH123123','123')FROM dual;
SELECT RTRIM('KH1233212','123')FROM dual;
SELECT RTRIM('KHACABACLC','ABC')FROM dual; --순서가 달라도 A,B,C 있으면 그냥 다 잘라버리고 L 이라는 새로운게 있으면 거기부턴 안짜름.
SELECT RTRIM('KH5782','0123456789')FROM dual;


--TRIM : 주어진 컬럼이나 문자열의 앞/뒤에 지정한 문자를 제거
SELECT TRIM('    KH   ')FROM DUAL;
SELECT TRIM('Z'FROM 'ZZZKHZZZ') FROM DUAL;
SELECT TRIM(LEADING 'Z' FROM 'ZZZ123456ZZZ') FROM dual; 
SELECT TRIM(TRAILING 'Z' FROM 'ZZZ123456ZZZ') FROM dual; 
SELECT TRIM(BOTH '3' FROM '333KH333') FROM dual;

-- SUBSTR : 컬럼이나 문자열에서 지정한 위치로부터 지정한 갯수의 문자열을 잘라서 리턴하는 함수
SELECT SUBSTR('SHOWMETHEMONEY',7,3) FROM dual;
SELECT SUBSTR('SHOWMETHEMONEY',7) FROM dual;
SELECT SUBSTR('SHOWMETHEMONEY',-5,5) FROM dual;
