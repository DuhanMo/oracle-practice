-- DAY2 수업내용
-- LOWER /UPPER ? INICAP : 대소문자 변경해주는 함수
-- LOWER (문자열 | 컬럼) : 소문자로 변경해주는 함수
SELECT LOWER('Welcome To My World!')
FROM DUAL;

-- UPPER (문자열 | 컬럼) : 대소문자로 변경해주는 함수
SELECT UPPER('Welcom To My World!')
FROM DUAL;

-- INITCAP : 앞글자만 대문자로 변경해주는 함수
SELECT INITCAP('welcome to my world')
FROM DUAL;

-- CONCAT : 문자열 혹은 컬럼 두개를 입력받아 하나로 합친 후 리턴
-- CONCAT 과 || 별차이는 없지만 세개 이상일 때는 || 가 더 편하게 사용할 수 있다.
SELECT
    CONCAT('가나다라', 'ABCD')
FROM
    DUAL;

-- REPLACE : 컬럼 혹은 문자열을 입력받아 변경하고자 하는 문자열을 변경하려고 하는 문자열로 바꾼 후 리턴
SELECT
    REPLACE('서울시 강남구 역삼동','역삼동','삼성동')
FROM
    DUAL;

SELECT
    *
FROM
    EMPLOYEE
WHERE
    SALARY > AVG(SALARY); -- WHERE 절에는 단일행 함수만 들어올 수 있다.

-- SUBSTRB : 바이트 단위로 추출하는 함수
SELECT
    SUBSTR('ORACLE',3,2)
,   SUBSTRB('ORACLE',3,2)
,   SUBSTR('마우스',2,2)
,   SUBSTRB('마우스',4,6)
FROM
    DUAL;

-- 숫자 처리 함수 : ABS,MOD,ROUND,FLOOR,TRUNC,CEIL
-- ABS(숫자|숫자로된 컬럼명) : 절대값 구하는 함수
SELECT
    ABS(-10)
,   ABS(10)
FROM
    DUAL;

-- MOD (숫자|숫자로 된 컬럼명)
-- 두 수를 나누어서 나머지를 구하는 함수
-- 처음 인자는 나누어지는 수, 두 번째 인자는 나눌 수
SELECT
    MOD(10,5)
,   MOD(10,3)
FROM
    DUAL;

-- ROUND (숫자 | 숫자로 된 컬럼명,[위치])
-- 반올림해서 리턴하는 함수
SELECT ROUND(123.456) FROM DUAL;
SELECT ROUND(123.456,0) FROM DUAL;
SELECT ROUND(123.456,1) FROM DUAL;
SELECT ROUND(123.456,2) FROM DUAL;
SELECT ROUND(123.456,-2) FROM DUAL;
SELECT ROUND(523.456,-3) FROM DUAL;

-- FLOOR(숫자|숫자로 된 컬럼명) : 내림처리하는 함수
SELECT FLOOR(123.456) FROM dual;

-- TRUNC (숫자 | 숫자로 된 컬럼명, [위치]): 내림처리(절삭) 함수
SELECT TRUNC(123.456) FROM dual;
SELECT TRUNC(123.678) FROM dual;
SELECT TRUNC(123.678,1) FROM dual;
SELECT TRUNC(123.678,2) FROM dual;

-- CEIL (올림처리 하는 함수)
SELECT CEIL(123.345) FROM dual;
SELECT CEIL(123.567) FROM dual;

-- 날짜처리 함수 : SYSDATE, MONTHS_BETWEEN, ADD_MONTH, NEXT_DAY, LAST_DAY, EXTRACT
-- SYSDATE: 시스템에 저장되어있는 날짜를 반환하는 함수
SELECT
    SYSDATE
FROM
    DUAL;
-- 두 날짜의 개월 수 차이를 숫자로 리턴하는 함수
SELECT
    EMP_NAME
,   HIRE_DATE
,   CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE))
FROM
    EMPLOYEE;

-- ADD_MONTHS(날짜, 숫자)
-- 날짜에 숫자만큼 개월 수 더해서 리턴
SELECT
    ADD_MONTHS(SYSDATE,6)
FROM
    DUAL;

-- EMPLOYEE 테이블에서 사원의 이름, 입사일, 입사후 6개월이 되는날짜를 조회
SELECT
    EMP_NAME
,   HIRE_DATE
,   ADD_MONTHS(HIRE_DATE,6)
FROM
    EMPLOYEE;

-- EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 조회
SELECT
    *
FROM
    EMPLOYEE
WHERE
--     ADD_MONTHS(HIRE_DATE,240) <= SYSDATE;
    MONTHS_BETWEEN(SYSDATE,HIRE_DATE) >=240;

-- NEXT_DAY(기준날짜,. 요일(문자|숫자)
-- 기준날짜에서 구하려는 요일에 가장 가까운 날짜 리턴
SELECT
    SYSDATE, NEXT_DAY(SYSDATE,'금')
FROM
    DUAL;

ALTER SESSION SET NLS_LANGUAGE = KOREAN; --AMERICAN 하면 영어로도 thursDay 검색가능

-- LAST_DAY(날짜) : 해당 월의 마지막 날짜를 구하여 리턴
SELECT
    SYSDATE
,   LAST_DAY(SYSDATE)
FROM
    DUAL;

-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴하는 함수
-- 년도만 추출 : EXTRACT(YEAR FROM 날짜)
-- 월만 추출 : EXTRACT(MONTH FROM 날짜)
-- 일만 추출 : EXTRACT(DAY FROM 날짜)
SELECT
    EXTRACT(YEAR FROM SYSDATE) 년
,   EXTRACT(MONTH FROM SYSDATE) 월
,   EXTRACT(DAY FROM SYSDATE) 일
FROM
    DUAL;

-- EMPLOYEE 테이블에서 직원의 이름, 입사일, 근무년수를 조회
-- 단, 근무년수는 현재년도 - 입사년도로 조회
SELECT
    EMP_NAME
,   EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE)
FROM
    EMPLOYEE;

-- MONTH_BETWEEN 으로 근무년수 조회
SELECT
    EMP_NAME
,   HIRE_DATE
,   CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)/12) 근무년수
FROM
    EMPLOYEE;

-- 형변환 함수
-- TO_CHAR(숫자,[포맷]) : 숫자형 데이터를 문자형 데이터로 변경
-- TO_CHAR(날짜,[포맷]) : 날짜형 데이터를 문자형 데이터로 변경

SELECT TO_CHAR(1234) FROM DUAL;
SELECT TO_CHAR(1234,'99999') FROM DUAL; --자릿수를 5자리로 만듦(9가 다섯개), 다섯자리를 만드는데 맨앞 비는 곳을 공백으로 채움
SELECT TO_CHAR(1234,'00000') FROM DUAL; -- 자릿수를 5자리로 만듦(0이 다섯개), 다섯자리를 만드는데 맨 앞 비는 곳을 0으로 채움
SELECT TO_CHAR(1234,'999') FROM DUAL; -- 표시할 수 없다 1234는 네자리 수인데 999 세자리로 표현하려고 해서.
SELECT TO_CHAR(1234,'L00000') FROM DUAL; -- L 그나라의 통화화폐 모양으로 나타내줌
SELECT TO_CHAR(1234,'$00000') FROM DUAL; -- $ $로 나타내줌
SELECT TO_CHAR(1234,'0,000') FROM DUAL; -- 8,000,000 포맷으로 나타내줌
SELECT TO_CHAR(1234,'99,999') FROM DUAL; -- 8,000,000 포맷으로 나타내줌

SELECT
    EMP_NAME
,   TO_CHAR(HIRE_DATE,'YYYY=MM-DD')입사일
FROM
    EMPLOYEE;

SELECT
    EMP_NAME
,   TO_CHAR(HIRE_DATE,'YYYY"년"=MM"월"-DD"일"')입사일
FROM
    EMPLOYEE;

-- 오늘 날짜에 대해 년도 4자리 , 년도 2자리, 년도 이름으로 출력
SELECT
    TO_CHAR(SYSDATE,'YYYY')
,   TO_CHAR(SYSDATE,'RRRR')
,   TO_CHAR(SYSDATE,'YY')
,   TO_CHAR(SYSDATE,'RR')
FROM
    DUAL;

SELECT -- YY는 현재 세기 기준이라 2098로 나옴
    TO_CHAR(TO_DATE('980625','YYMMDD'),'YYYY-MM-DD')
FROM
    DUAL;

SELECT
    TO_CHAR(TO_DATE('980625','RRMMDD'),'RRRR-MM-DD')
FROM
    DUAL;

-- RR과 YY의 차이
-- RR은 두자리 년도를 네자리로 바꿀때
-- 바꿀 년도가 50년 미만 2000년을 적용
-- 50년 이상이면 1900년 적용
-- YY 현재 세기(2000년) 적용

-- 년도 바꿀 때 (TO_DATE사용시) Y를 적용하면 현재 세기(2000년)가 적용된다.

-- 오늘 날짜에서 월만 출력
SELECT
    TO_CHAR(SYSDATE,'MM')
,   TO_CHAR(SYSDATE,'MONTH')
,   TO_CHAR(SYSDATE,'MON')
,   TO_CHAR(SYSDATE,'RM')
FROM
    DUAL;

-- 오늘 날짜에서 일만 출력(DDDD/DD/D)
SELECT
    TO_CHAR(SYSDATE,'"1년 기준"DDD"일 쨰"')
,   TO_CHAR(SYSDATE,'"달 기준"DD"일 쩨"')
,   TO_CHAR(SYSDATE,'"주 기준"D"일 쩨"')
FROM
    DUAL;

-- 오늘 날짜에서 분기와 요일 출력
SELECT
    TO_CHAR(SYSDATE,'Q"분기"')
,   TO_CHAR(SYSDATE,'DAY')
,   TO_CHAR(SYSDATE,'DY')
FROM
    DUAL;

-- TO_DATE : 문자형 데이터를 날짜형 데이터로 변환하여 리턴
-- TO_DATE(문자형데이터,[포맷])
-- 문자형 데이터를 날짜로 변경한다.
-- TO_DATE(숫자,[포맷])
SELECT TO_DATE('20200625','RRRRMMDD') FROM DUAL;
SELECT TO_CHAR(TO_DATE('20200625','RRRRMMDD'),'RRRR,MON') FROM DUAL;
SELECT TO_CHAR(TO_DATE('20200625','RRRRMMDD'),'RRRR-MM-DD') FROM DUAL;

SELECT TO_DATE('20200625 191620','RRMMDD HH24MISS') FROM DUAL;
SELECT TO_CHAR( TO_DATE('20200625 191620','RRMMDD HH24MISS'), 'RRRR-MM-DD-HH:MI:SS PM') FROM DUAL;

SELECT
EMP_NAME
,HIRE_DATE
from EMPLOYEE
where hire_date > '20000101';

-- TO_NUMBER(문자데이터, [포맷]) : 문자 데이터를 숫자로 리턴
SELECT TO_NUMBER('12345678') FROM DUAL;
-- 자동형변환
SELECT  '123'+'456' FROM DUAL;
--숫자로된 문자열만 가능하다.
SELECT '123'+'456A' FROM DUAL;