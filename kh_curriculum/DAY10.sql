-- DAY10 수업내용

-- PL/SQL (PROCEDURE LANGUAGE EXTENSION TO SQL)
-- 오라클 자체에 내장된 절차적 언어
-- SQL의 단점을 보완하여 SQL문장 내에서
-- 변수의 정의, 조건처리, 반복처리, 예외처리 등을 지원한다.

-- PL/SQL구조
-- 선언부,실행부,예외처리부로 구성되어있다.
-- 선언부    : DECLARE로 시작, 변수나 상수를 선언하는 부분
-- 실행부    : BEGIN으로 시작, 제어문,반복문,함수의 정의 등의 로직 작성해서 END로 마무리
-- 예외처리부: EXCEPTION으로 시작, 예외처리 내용작성

/*
   [DECLARE] : 선언부
   BEGIN : 실행부
   EXCEPTION : 예외처리부
   END;
   /  <-- 현재 PL/SQL 스크립트를 즉시 실행 후 결과 확인까지 하겠다.
*/

BEGIN
   DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/

SET SERVEROUTPUT ON;

-- 변수의 선언과 초기화,변수 값 출력
DECLARE
   EMP_ID      NUMBER;
   EMP_NAME    VARCHAR2(30);
BEGIN
   EMP_ID   := 888;
   EMP_NAME := '배장남';

   DBMS_OUTPUT.PUT_LINE('EMP_ID : '|| EMP_ID);
   DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/

DESC EMPLOYEE;

-- 레퍼런스 변수의 선언과 초기화, 변수값 출력
DECLARE
   EMP_ID      EMPLOYEE.EMP_ID%TYPE;
   EMP_NAME    EMPLOYEE.EMP_NAME%TYPE;
BEGIN
   SELECT EMP_ID,EMP_NAME
   INTO EMP_ID,EMP_NAME
   FROM EMPLOYEE
   WHERE EMP_ID = '&사원번호';

   DBMS_OUTPUT.PUT_LINE('EMP_ID : '|| EMP_ID);
   DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
END;
/

-- 레퍼런스 변수로 EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE,SALARY를
-- 선언하고, EMPLOYEE테이블에서 사번,이름,직급코드,부서코드,급여를 조회하여
-- 선언한 레퍼런스 변수에 담아 출력하세요.
-- 단, 입력받은 이름과 일치하는 조건의 직원을 조회하세요.
DECLARE
   EMP_ID       EMPLOYEE.EMP_ID%TYPE;
   EMP_NAME     EMPLOYEE.EMP_NAME%TYPE;
   DEPT_CODE    EMPLOYEE.DEPT_CODE%TYPE;
   JOB_CODE     EMPLOYEE.JOB_CODE%TYPE;
   SALARY       EMPLOYEE.SALARY%TYPE;
BEGIN
   SELECT EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE,SALARY
   INTO EMP_ID,EMP_NAME,DEPT_CODE,JOB_CODE,SALARY
   FROM EMPLOYEE
   WHERE EMP_NAME ='&사원이름';

   DBMS_OUTPUT.PUT_LINE('EMP_ID : '|| EMP_ID);
   DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP_NAME);
   DBMS_OUTPUT.PUT_LINE('DEPT_CODE : '|| DEPT_CODE);
   DBMS_OUTPUT.PUT_LINE('JOB_CODE : '|| JOB_CODE);
   DBMS_OUTPUT.PUT_LINE('SALARY : ' || SALARY);
END;
/


-- %ROWTYPE
--  : 테이블의 한 행의 모든 컬럼과 자료형을 참조하는 경우 사용

DECLARE
   E     EMPLOYEE%ROWTYPE;
BEGIN
   SELECT *
   INTO E
   FROM EMPLOYEE
   WHERE EMP_ID = '&EMP_ID';

   DBMS_OUTPUT.PUT_LINE('EMP_ID : '|| E.EMP_ID);
   DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || E.EMP_NAME);
   DBMS_OUTPUT.PUT_LINE('DEPT_CODE : '|| E.DEPT_CODE);
   DBMS_OUTPUT.PUT_LINE('JOB_CODE : '|| E.JOB_CODE);
   DBMS_OUTPUT.PUT_LINE('SALARY : ' || E.SALARY);
END;
/

-- 연봉을 구하는 PL/SQL 블럭 작성
DECLARE
     VEMP      EMPLOYEE%ROWTYPE;
     YSALARY   NUMBER;
BEGIN
   SELECT *
   INTO VEMP
   FROM EMPLOYEE
   WHERE EMP_NAME = '&사원명';

   IF(VEMP.BONUS IS NULL) THEN YSALARY := VEMP.SALARY * 12;
   ELSIF(VEMP.BONUS IS NOT NULL) THEN YSALARY := (VEMP.SALARY + (VEMP.SALARY*VEMP.BONUS))* 12;
   END IF;

   DBMS_OUTPUT.PUT_LINE(VEMP.EMP_ID || '     '|| VEMP.EMP_NAME || '     '|| TO_CHAR(YSALARY,'L999,999,999'));
END;
/

-- 점수를 입력받아 SCORE변수에 저장하고
-- 90점 이상은 'A', 80점 이상은 'B', 70점 이상은 'C'
-- 60점 이상은 'D' 60점 미만은 'F'로 조건 처리하여
-- GRADE변수에 저장하여
-- '당신의 점수는 90점이고, 학점은 A학점입니다.' 형태로 출력하세요.
DECLARE
   SCORE    NUMBER;
   GRADE    VARCHAR2(2);
BEGIN
   SCORE := '&SCORE';

   IF SCORE >= 90 THEN GRADE := 'A';
   ELSIF SCORE >= 80 THEN GRADE := 'B';
   ELSIF SCORE >= 70 THEN GRADE := 'C';
   ELSIF SCORE >= 60 THEN GRADE := 'D';
   ELSE GRADE := 'F';
   END IF;

   DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은' || GRADE || '학점 입니다.');
END;
/
DECLARE
   VEMPNO         EMPLOYEE.EMP_ID%TYPE;
   VENAME         EMPLOYEE.EMP_NAME%TYPE;
   VDEPTNO        EMPLOYEE.DEPT_CODE%TYPE;
   VDNAME         VARCHAR2(20) := NULL;
BEGIN
   SELECT EMP_ID,EMP_NAME,DEPT_CODE
   INTO VEMPNO,VENAME,VDEPTNO
   FROM EMPLOYEE
   WHERE EMP_ID = '&사번';


   IF(VDEPTNO = 'D1') THEN VDNAME :='인사관리부';
   END IF;
   IF(VDEPTNO = 'D2') THEN VDNAME :='회계관리부';
   END IF;
   IF(VDEPTNO = 'D3') THEN VDNAME :='마케팅부';
   END IF;
   IF(VDEPTNO = 'D4') THEN VDNAME :='국내영업부';
   END IF;
   IF(VDEPTNO = 'D5') THEN VDNAME :='해외영업1부';
   END IF;
   IF(VDEPTNO = 'D6') THEN VDNAME :='해외영업2부';
   END IF;
   IF(VDEPTNO = 'D7') THEN VDNAME :='해외영업3부';
   END IF;
   IF(VDEPTNO = 'D8') THEN VDNAME :='기술지원부';
   END IF;
   IF(VDEPTNO = 'D9') THEN VDNAME :='총무부';
   END IF;

   DBMS_OUTPUT.PUT_LINE('사번         이름        부서명');
   DBMS_OUTPUT.PUT_LINE('-------------------------------');
   DBMS_OUTPUT.PUT_LINE(VEMPNO || '         ' || VENAME || '       '|| VDNAME);
END;
/

DECLARE
   VEMPNO         EMPLOYEE.EMP_ID%TYPE;
   VENAME         EMPLOYEE.EMP_NAME%TYPE;
   VDEPTNO        EMPLOYEE.DEPT_CODE%TYPE;
   VDNAME         VARCHAR2(20) := NULL;
BEGIN
   SELECT EMP_ID,EMP_NAME,DEPT_CODE
   INTO VEMPNO,VENAME,VDEPTNO
   FROM EMPLOYEE
   WHERE EMP_ID = '&사번';

   VDNAME := CASE VDEPTNO
                 WHEN 'D1' THEN '인사관리부'
                 WHEN 'D2' THEN '회계관리부'
                 WHEN 'D3' THEN '마케팅부'
                 WHEN 'D4' THEN '국내영업부'
                 WHEN 'D5' THEN '해외영업1부'
                 WHEN 'D6' THEN '해외영업2부'
                 WHEN 'D7' THEN '해외영업3부'
                 WHEN 'D8' THEN '기술지원부'
                 WHEN 'D9' THEN '총무부'
             END;
   DBMS_OUTPUT.PUT_LINE('사번         이름        부서명');
   DBMS_OUTPUT.PUT_LINE('-------------------------------');
   DBMS_OUTPUT.PUT_LINE(VEMPNO || '         ' || VENAME || '       '|| VDNAME);
END;
/

DECLARE
    N   NUMBER := 1;
BEGIN
   LOOP
      DBMS_OUTPUT.PUT_LINE(N);
      N := N + 1;
      IF N > 5 THEN EXIT;
      END IF;
   END LOOP;
END;
/

CREATE TABLE TEST1(
   BUNHO    NUMBER(3)
 , NALJJA   DATE
);

BEGIN
   FOR I IN 1..10
      LOOP
         INSERT INTO TEST1 VALUES(I,SYSDATE);
      END LOOP;
END;
/

SELECT * FROM TEST1;

-- 구구단 짝수단 출력하기
DECLARE
      RESULT  NUMBER;
BEGIN
   FOR DAN IN 2..9
      LOOP
         IF MOD(DAN,2) =0
            THEN FOR SU IN 1..9
            LOOP
               RESULT := DAN * SU;
               DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || RESULT);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(' ');
         END IF;
      END LOOP;
END;
/

DECLARE
    RESULT     NUMBER;
    DAN        NUMBER :=2;
    SU         NUMBER;
BEGIN
   WHILE DAN <=9
   LOOP
      SU := 1;
      IF MOD(DAN,2) =0
         THEN WHILE SU <= 9
         LOOP
            RESULT := DAN * SU;
            DBMS_OUTPUT.PUT_LINE(DAN || ' * ' || SU || ' = ' || RESULT);
            SU := SU + 1;
         END LOOP;
         DBMS_OUTPUT.PUT_LINE(' ');
      END IF;
      DAN := DAN +1;
   END LOOP;
END;
/

























