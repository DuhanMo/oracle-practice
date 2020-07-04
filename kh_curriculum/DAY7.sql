-- DAY7 수업내용
-- INSERT, UPDATE, DELETE, SELECT
-- DML(Data Multipulation Language)
-- 데이터 조작언어 : 테이블에 값을 삽입하거나, 수정하거나, 삭제하거나, 조회하는 언어
-- INSERT : 새로운 행을 추구하는 구문, 테이블의 행 갯수가 증가한다
-- [표현식]
-- INSERT INTO 테이블명 VALUES (데이터, 데이터 ,...) : 테이블에 모든 컬럼에 대해 값을 INSERT 할 때 사용
-- INSERT INTO 테이블명(컬럼명, 컬럼명,...)VALUES(데이터, 데이터,...) : 테이블의 일부컬럼에 대해서 값을 INSERT할 때 사용
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, EMAIL, PHONE, DEPT_CODE, JOB_CODE, SAL_LEVEL, SALARY, BONUS,
                     MANAGER_ID, HIRE_DATE, ENT_DATE, ENT_YN)
VALUES (900, '장채현', '901122-1080503', 'jang_ch@kh.or.kr', '01051512345', 'D1', 'J7', 'S3', 4300000, 0.2, '200', SYSDATE,
        NULL, DEFAULT);
SELECT *
FROM EMPLOYEE;

-- INSERT 시에 VALUES 대신에 서브쿼리를 이용할 수 있다.
CREATE TABLE EMP_01
(
    EMP_ID     NUMBER,
    EMP_NAME   VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);
INSERT INTO EMP_01 (
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
             LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID));
SELECT *
FROM EMP_01;

DROP TABLE EMP_DEPT_D1;
CREATE TABLE EMP_DEPT_D1
AS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE 1 = 1; -- 참을 의미하며 WHERE 1=1로하면 구조와 내용 전부를 복사
SELECT *
FROM EMP_DEPT_D1;
-- 테이블의 구조만 복샇랄 때 WHERE 1 = 0 (거짓)을 부여

CREATE TABLE EMP_MANAGER
AS
SELECT EMP_ID, EMP_NAME, MANAGER_ID
FROM EMPLOYEE
WHERE 1 = 0;
SELECT *
FROM EMP_MANAGER;

-- INSERT ALL : INSERT 시에 사용하는 서브쿼리가 같은경우
--              두 개 이상의 테이블에 INSERT ALL을 이용하여
--              한 번에 데이터를 삽입할 수 있다.
--              단, 각 서브쿼리의 조건절이 같아야한다.

-- EMP_DEPT_D1 테이블에 EMPLOYEE 테이블에 있는 부서코드가 D1인 직원을 조회해서
-- 사번, 이름, 소속부서, 입사일을 삽입하고,
-- EMP_MANAGER 테이블에 EMPLOYEE 테이블에 있는 부서코드가 D1인 직원을 조회해서
-- 사번, 이름, 관리자 사번을 삽입하세요.
INSERT INTO EMP_DEPT_D1(
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1'
);

INSERT INTO EMP_MANAGER(
    SELECT EMP_ID,EMP_NAME,MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1'
);

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

INSERT ALL
INTO EMP_DEPT_D1 VALUES (EMP_ID,EMP_NAME,DEPT_CODE,HIRE_DATE)
INTO EMP_MANAGER VALUES (EMP_ID,EMP_NAME,MANAGER_ID)
SELECT EMP_ID,EMP_NAME,DEPT_CODE,HIRE_DATE,MANAGER_ID
    FROM EMPLOYEE
    WHERE DEPT_CODE = 'D1';
-- EMPLOYEE테이블에서 입사일 기준으로 2000년 1월 1일 이전에 입사한
-- 사원의 사번, 이름, 입사일, 급여를 조회하여
-- EMP_OLD 테이블에 삽입하고
-- 그 이후에 입사한 사원은 EMP_NEW 테이블에 삽입하세요.
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0;

CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1 = 0;

commit;