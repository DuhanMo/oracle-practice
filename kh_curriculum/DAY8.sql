SELECT * FROM USER_SYS_PRIVS;

SELECT * FROM USER_ROLE_PRIVS;

SELECT * FROM USER_VIEWS;

GRANT CREATE VIEW TO EMPLOYEE;

CREATE OR REPLACE VIEW V_EMP(사번,이름,부서)
AS SELECT EMP_ID,EMP_NAME,DEPT_CODE
FROM EMPLOYEE;

SELECT * FROM V_EMP;

-- view (뷰)
-- SELECT 쿼리문을 저장한 객체이다.
-- 실징적인 데이터를 저장하고 있지 않는다.(단순히 쿼리가 저장되어있다고 생각)
-- 테이블을 사용하는 것과 동일하게 사용할 수 있다.
-- [표현식]
-- CREATE VIEW 뷰 이름 AS 서브쿼리 --> 기본구조
-- CREATE [OR REPLACE ] VIEW 뷰 이름 AS 서브쿼리

-->> [OR REPLACE] : 뷰 생성 시 기존에 같은 이름의 뷰가 있다면 해당 뷰를 변경한다.
--      --> OR REPLACE 를 사용하지 않고 같은 이름의 뷰 생성시 이미 다른 객체가 사용중인 이름이라고 에러 발생

-- 사번, 이름, 직급명, 부서명, 근무지역을 조회하고
-- 그 결과를 V_RESULT_EMP라는 뷰를 생성해서 저장하세요.
CREATE  OR REPLACE VIEW V_RESULT_EMP
AS SELECT EMP_ID,
          EMP_NAME,
          JOB_NAME,
          DEPT_TITLE,
          LOCAL_NAME
FROM EMPLOYEE -- 베이스 테이블
LEFT JOIN JOB USING (JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
LEFT JOIN LOCATION L ON (LOCATION_ID = LOCAL_CODE);

SELECT * FROM V_RESULT_EMP;


CREATE OR REPLACE VIEW V_EMPLOYEE(사번,이름,부서,지역)
AS SELECT EMP_ID,EMP_NAME,DEPT_TITLE,NATIONAL_NAME
   FROM EMPLOYEE
   LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
   LEFT JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
   LEFT JOIN NATIONAL USING(NATIONAL_CODE);

SELECT * FROM V_EMPLOYEE;