-- DAY7 수업내용
-- INSERT, UPDATE, DELETE, SELECT
-- DML(Data Manipulation Language)
-- 데이터 조작언어 : 테이블에 값을 삽입하거나, 수정하거나, 삭제하거나,조회하는 언언
-- INSERT : 새로운 행을 추구하는 구문, 테이블의 행 갯수가 증가한다.
-- [표현식]
-- INSERT INTO 테이블명 VALUES(데이터,데이터...) : 테이블에 모든 컬럼에 대해 값을 INSERT할때 사용
-- INSERT INTO 테이블명(컬럼명,컬럼명,...) VALUES(데이터,데이터...) : 테이블의 일부컬럼에 대해서 값을 INSERT할때 사용
INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,EMAIL,PHONE,DEPT_CODE,JOB_CODE,SAL_LEVEL,SALARY,BONUS,
                     MANAGER_ID,HIRE_DATE,ENT_DATE,ENT_YN)
VALUES(900,'장채현','901122-1080503','jang_ch@kh.or.kr','01051512345','D1','J7','S3',4300000,0.2,'200',SYSDATE,NULL,DEFAULT);

SELECT * FROM EMPLOYEE;

-- INSERT시에 VALUES 대신 서브쿼리를 이용할 수 있다.
CREATE TABLE EMP_01(
   EMP_ID      NUMBER
 , EMP_NAME    VARCHAR2(30)
 , DEPT_TITLE  VARCHAR2(20)
);

INSERT INTO EMP_01(
   SELECT EMP_ID,EMP_NAME,DEPT_TITLE
   FROM EMPLOYEE
   LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
);

SELECT * FROM EMP_01;
DROP TABLE EMP_DEPT_D1;
CREATE TABLE EMP_DEPT_D1
AS SELECT EMP_ID,EMP_NAME,DEPT_CODE,HIRE_DATE
   FROM EMPLOYEE
   WHERE 1=1; -- 참을 의미하며 WHERE 1=1로 하면 구조와 내용 전부를 복사

SELECT * FROM EMP_DEPT_D1;

CREATE TABLE EMP_MANAGER
AS SELECT EMP_ID,EMP_NAME,MANAGER_ID
   FROM EMPLOYEE
   WHERE 1=0; --테이블의 구조만 복사할 때 1=0(거짓)을 부여

SELECT * FROM EMP_MANAGER;

-- INSERT ALL : INSERT시에 사용하는 서브쿼리가 같은 경우
--              두 개 이상의 테이블에 INSERT ALL을 이용하여
--              한번에 데이터를 삽입할 수 있다.
--              단, 각 서브쿼리의 조건절이 같아야한다.

-- EMP_DEPT_D1테이블에 EMPLOYEE테이블에 있는 부서코드가 D1인 직원을 조회해서
-- 사번,이름, 소속부서,입사일을 삽입하고,
-- EMP_MANAGER테이블에 EMPLOYEE테이블에 있는 부서코드가 D1인 직원을 조회해서
-- 사번, 이름,관리자 사번을 삽입하세요.
INSERT INTO EMP_DEPT_D1(
   SELECT EMP_ID,EMP_NAME,DEPT_CODE,HIRE_DATE
   FROM EMPLOYEE
   WHERE DEPT_CODE = 'D1'
);

INSERT INTO EMP_MANAGER(
   SELECT EMP_ID,EMP_NAME,MANAGER_ID
   FROM EMPLOYEE
   WHERE DEPT_CODE='D1'
);

SELECT * FROM EMP_DEPT_D1;
SELECT * FROM EMP_MANAGER;

DELETE FROM EMP_DEPT_D1;
DELETE FROM EMP_MANAGER;

INSERT ALL
INTO EMP_DEPT_D1 VALUES(EMP_ID,EMP_NAME,DEPT_CODE,HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID,EMP_NAME,MANAGER_ID)
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



INSERT ALL
WHEN HIRE_DATE < '2000/01/01'
THEN INTO EMP_OLD VALUES(EMP_ID,EMP_NAME,HIRE_DATE,SALARY)
WHEN HIRE_DATE >= '2000/01/01'
THEN INTO EMP_NEW VALUES(EMP_ID,EMP_NAME,HIRE_DATE,SALARY)
SELECT EMP_ID,EMP_NAME,HIRE_DATE,SALARY
FROM EMPLOYEE;

-- UPDATE : 테이블에 기록된 컬럼의 값을 수정하는 구문
--          테이블의 전체 행 갯수는 변화가 없다.
--  [표현식]
-- UPDATE 테이블명 SET 컬럼명=바꿀값, 컬럼명=바꿀값.....
-- [WHERE 컬럼명 비교연산자 비교값];

CREATE TABLE DEPT_COPY1
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY1;

UPDATE DEPT_COPY1
SET DEPT_TITLE='전략기획팀'
WHERE DEPT_ID = 'D9';

DROP TABLE DEPT_COPY1;

-- UPDATE 시에도 서브쿼리르 이용할 수 있다.
-- UPDATE 테이블명
-- SET 컬럼명 = (서브쿼리)
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID,EMP_NAME,DEPT_CODE,SALARY,BONUS
   FROM EMPLOYEE;

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('유재식','방명수');

-- 평상시 유재식 사원을 부러워하던 방명수 사원의
-- 급여와 보너스율을 유재식 사원과 동일하게 변경해 주기로 했다.
-- 이를 반영하는 UPDATE문을 작성해보세요.
UPDATE EMP_SALARY
SET SALARY = (SELECT
                  SALARY
               FROM
                   EMPLOYEE
               WHERE EMP_NAME='유재식')
    , BONUS = (SELECT
                  BONUS
               FROM
                   EMPLOYEE
               WHERE EMP_NAME='유재식')
WHERE EMP_NAME = '방명수';

-- 다중행 다중열 서브쿼리를 이용한 UPDATE문
-- 방명수 사원의 급여 인상 소식을 전해들은 다른 사원들이
-- 단체로 파업을 진행했다.
-- 노옹철,전형돈,정중하,하동운 사원의 급여와 보너스를
-- 유재식 사원의 급여와 보너스와 같게 변경하는 UPDATE문 작성
UPDATE EMP_SALARY
SET (SALARY,BONUS) = (SELECT SALARY,BONUS
                      FROM EMPLOYEE
                      WHERE EMP_NAME='유재식')
WHERE EMP_NAME IN('노옹철','전형돈','정중하','하동운');

SELECT * FROM EMP_SALARY
WHERE EMP_NAME IN ('유재식','방명수','노옹철','전형돈','정중하','하동운');

-- UPDATE시 변경할 값은 해당 컬럼에 대한 제약조건에 위배되지 않아야한다.
UPDATE EMPLOYEE
SET DEPT_CODE='65' --> FOREIGN KEY 제약조건 위배
WHERE DEPT_CODE='D6';



UPDATE EMPLOYEE
SET EMP_NAME = NULL --> NOT NULL 제약조건 위배WHERE EMP_ID = 200;

-- DELETE : 테이블의 행을 삭제하는 구문이다.
--          테이블의 행의 갯수가 줄어든다.
-- [표현식]
-- DELETE FROM 테이블명 WHERE 조건설정
-- 만약 WHERE 조건을 설정하지 않으면 모든 행이 다 삭제된다.
COMMIT;

DELETE FROM EMPLOYEE;
SELECT * FROM EMPLOYEE;
ROLLBACK ;

DELETE FROM EMPLOYEE WHERE EMP_ID = 900;
-- FROREIGN HEY 제약조건이 설정되어있는 경우
-- 참조되고 있는 값에 대해서는 삭제할 수 없다.
DELETE FROM DEPARTMENT WHERE DEPT_ID = 'D1';

-- 삭제 시 FOREIGN KEY 제약 조건이 설정되어있어도
-- 참조되고 있지 않는 값에 대해서는 삭제 가능
DELETE FROM DEPARTMENT WHERE DEPT_ID = 'D3';
SELECT * FROM DEPARTMENT;

-- SYS_C007122
-- 삭제 시 FOREIGN KEY 제약 조건으로 컬럼 삭제가 불가능한 경우
-- 제약 조건을 비활성화 할 수 있다.
SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME = 'EMPLOYEE';

ALTER TABLE EMPLOYEE
DISABLE CONSTRAINT SYS_C007122 CASCADE ;

ROLLBACK ;

-- 비활성화 된 제약 조건을 다시 활성화
ALTER TABLE EMPLOYEE
ENABLE CONSTRAINT SYS_C007122;

-- TRUNCATE : 테이블의 전체 행을 삭제할 시 사용한다.
--              DELETE 보다 수행 속도가 더 빠르다.
--              ROLLBACK을 통해 복구할 수 없다.
SELECT * FROM EMP_SALARY;
COMMIT;
DELETE FROM EMP_SALARY;
ROLLBACK ;

TRUNCATE TABLE EMP_SALARY;
ROLLBACK ;




-- TCL (Transaction Controll Language)
-- 트랜젝션 제어 언어
-- COMMIT과 ROLLBACK 이 있다

-- 트랜잭션이란?
-- 한꺼번에 수행되어야 할 최소의 작업단위를 말한다.
-- 하나의 트랜잭션으로
