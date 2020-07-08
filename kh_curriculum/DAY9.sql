-- DAY9 수업내용

/*
   <시퀀스 SEQUNCE>

   자동번호 발생기 역할을 하는 객체
   순차적으로 정수 값을 자동으로 생성해준다.

   1. SEQUNCE 생성방법

   [표현식]

   CREATE SEQUENCE 시퀀스이름
   [START WITH 숫자]            --> 처음 발생시킬 시작값지정, 생략하면 자동으로 1이 기본
   [INCREMENT BY 숫자]          --> 다음 값에 대한 증가치, 생략하면 자동 1이 기본
   [MAXVALUE 숫자 | NOMAXVALUE] --> 발생시킬 최대값 지정(10의 27승,-1)
   [MINVALUE 숫자 | NOMINVALUE] --> 최소값 지정(-10의 26승)
   [CYCLE | NOCYCLE]            --> 값 순환 여부 저장
   [CACHE 바이트크기 | NOCACHE] --> 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트

   -- > 시퀀스의 캐시메모리는 할당된 크기만큼 미리 다음값을 생성해 저장해둔다.
        시퀀스를 호출 시 미리 저장되어있는 값들을 가져와서 반환해준다. 그래서 매번 시퀀스를 생성해서
        반환하는 것보다 DB속도가 향상된다.
*/

CREATE SEQUENCE SEQ_EMPNO
START WITH 300
INCREMENT BY 5
MAXVALUE 310
NOCYCLE
NOCACHE;

-- 사용자가 생성한 시퀀스를 확인
SELECT * FROM USER_SEQUENCES;

/*
   2. SEQUENCE 사용

   시퀀스명.CURRVAL : 현재 생성된 시퀀스의 값
   시퀀스명.NEXTVAL : 시퀀스를 증가시킴
                      기존시퀀스 값에서 INCREMENT에 지정한 만큼 증가한 값
                      = 시퀀스명.CURRVAL + INCREMENT

SEQ_EMPNO   1   310   5   N   N   0   300
*/

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
-- > NEXTVAL을 실행하지 않고 방금 생성된 시퀀스의 CURRVAL 호출 하게되면 오류 발생
-- >>>>>> WHY? CURRVAL은 마지막으로 호출된 NEXTVAL의 값을 저장하고 보여주는 임시값이다.
--       즉, 생성 후 한번도 NEXTVAL을 호출하지 않았으므로 오류발생

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;      -- 300
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;      -- 300
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;      -- 305
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;      -- 305
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;      -- 310
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;      -- 310

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;      -- ERROR
--> 지정한 MAXVALUE값을 초과하였기 때문에 오류 발생

SELECT SEQ_EMPNO.CURRVAL FROM DUAL;      -- 310
--> CURRVAL은 성공적으로 호출된 마지막 NEXTVAL의 값을 저장하고 출력한다.

SELECT * FROM USER_SEQUENCES;

/*
   <CURRVAL / NEXTVAL 사용 가능여부>

   1) 사용가능
   - 서브쿼리가 아닌 SELECT문
   - INSERT문의 SELECT절
   - INSERT문의 VALUES절
   - UPDATE문의 SET절

   2) 사용불가
   - VIEW의 SELECT절
   - DISTINCT 키워드가 있는 SELECT문
   - GROUP BY, HAVING, ORDER BY 절의 SELECT문
   - SELECT, DELETE, UPDATE문의 서브쿼리
   - CREATE TABLE, ALTER TABLE명령의 DEFAULT값
*/

CREATE SEQUENCE SEQ_ENO1
START WITH 223
INCREMENT BY 1
MAXVALUE 10000
NOCYCLE
NOCACHE;

SELECT * FROM USER_SEQUENCES;

SELECT * FROM EMPLOYEE;

INSERT INTO EMPLOYEE VALUES(SEQ_ENO.NEXTVAL,'홍길동','651122-1234567','hong_gd@kh.or.kr','01012345678','D2','J7','S3',5000000,0.1,200,SYSDATE,
                            NULL,DEFAULT);

INSERT INTO EMPLOYEE VALUES(SEQ_ENO.NEXTVAL,'겅유','881122-1234567','g_yoo@kh.or.kr','01012345678','D2','J7','S3',5000000,0.1,200,SYSDATE,
                            NULL,DEFAULT);

-- 사용불가예시
CREATE TABLE TMP_EMPLOYEE(
   E_ID     NUMBER DEFAULT SEQ_ENO.CURRVAL,
   E_NAME   VARCHAR2(20)
);

/*
   3. SEQUENCE 변경

   [표현식]
   ALTER SEQUENCE 시퀀스이름
   [INCREMENT BY 숫자]
   [MAXVALUE 숫자 | NOMAXVALUE]
   [MINVALUE 숫자 | NOMINVALUE]
   [CYCLE| NOCYCLE]
   [CACHE 바이트크기 | NOCACHE]

   * START WITH는 변경 불가 --> 재설정 필요 시 기존 시퀀스 DROP후 재생성
*/

SELECT * FROM USER_SEQUENCES;
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10
MAXVALUE 400
NOCYCLE
NOCACHE;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; -- 아까 마지막값으로 310이 나왔고 거기에 +10해서 320이 조회된다.
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;


/*
   <인덱스 INDEX>
   SQL명령문의 처리속도를 향상시키기 위해서 컬럼에 대해 생성하는 오라클 객체
   인덱스 내부 구조는 B* 트리(이진트리)형식으로 구성되어있다.

   - 장점
     이진트리 형식으로 구성되어 자동정렬 및 검색 속도가 빨라진다.
     시스템에 걸리는 부하를 줄여 시스템 전체 성능 향상

    - 단점
       인덱스를 추가하기위한 별도의 저장공간이 필요
       인덱스를 생성하는데 시간이 걸린다.
       데이터 변경작업(DML(INSERT/UPDATE/DELETE))이 빈번한 경우에는 오히려 성능 저하

   1. 인덱스 생성방법
   [표현식]
   CREATE [UNIQUE] INDEX 인덱스명
   ON 테이블명(컬럼명,컬럼명,.....|함수명, 함수계산식);

*/
SELECT * FROM USER_IND_COLUMNS; -- 인덱스를 관리하는 데이터 사전

/*
   2. 인덱스 구조
   ROWID : DB내 데이터 공유 주소값, ROWID를 이용해 데이터 접근 가능

   1~6번쨰  : 데이터 오브젝트 번호
   7~9번쨰  : 파일 번호
   10~15번째: BLOCK번호
   16~18번째: ROW번호

*/
SELECT ROWID,EMP_ID,EMP_NAME FROM EMPLOYEE;

/*
   3. 인덱스 원리
   인덱스 생성 시 지정한 컬럼은 KEY, ROWID는 VALUE가 되어 MAP처럼 구성되어있다.

   SELECT시 WHERE절에 인덱스가 생성되어있는 컬럼을 추가하면
   데이터 조회 시 테이블의 모든데이터를 접근하는것이 아닌
   해당 컬럼(KEY)와 매칭되는 ROWID(VALUE)가 가리키는 ROW주소의 값을 조회해서 속도가 향상된다.

*/

-- 인덱스활용
-- 인덱스 활용 X SELECT문
SELECT EMP_ID,EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME = '윤은해';

-- 인덱스 활용 O SELECT문
SELECT EMP_ID,EMP_NAME
FROM EMPLOYEE
WHERE EMP_ID='210';

/*
   WHERE절에
   INDEX가 부여되지 않은 컬럼으로 조회시 --> 윤은해가 어느 곳에 있는지 모르기 때문에 EMPLOYEE테이블 전부를
                                             DB BUFFER 캐시로 복사한 뒤  FULL SCAN으로 찾게된다.
   INDEX가 부여되어 있는 컬럼으로 조회시 --> INDEX에 먼저 가서 210정보가 어떤 ROWID를 가지고 있는지 확인한 뒤
                                             해당 ROWID에 있는 블럭만 찾아가서 DB BUFFER캐시에 복사


*/

/*
   4. 인덱스 종류
   1) 고유인덱스(UNIQUE INDEX)
   2) 비고유인덱스(NONUNIQUE INDEX)
   3) 단일인덱스(SINGLE INDEX)
   4) 결합인덱스(COMPOSITE INDEX)
   5) 함수기반인덱스(FUNCTION BASED INDEX)

*/

/*
   1) 고유 인덱스(UNIQUE INDEX)
   - UNIQUE INDEX에 생성된 컬럼에는 중복값 포함 불가
    (UNIQUE INDEX로 설정한 컬럼에는 중복되는 컬럼값 포함 불가 == UNIQUE 제약조건)
   - 오라클 PRIMARY KEY, UNIQUE KEY 제약조건 설정 시 해당 컬럼에 대한 INDEX가 존재하지 않으면
      자동으로 해당 컬럼에 UNIQUE INDEX가 생성된다.
   - PRIMARY KEY를 이용하여 ACCESS하는 경우 성능 향상에 효과가 있따.
*/
-- * EMPLOYEE테이블의 EMP_NAME 컬럼 UNIQUE INDEX생성하기

-- UNIQUE INDEX 생성
CREATE UNIQUE INDEX IDX_EMP
ON EMPLOYEE(EMP_NAME);

-- 사용자가 생성한 인덱스 조회
SELECT * FROM USER_INDEXES WHERE TABLE_NAME='EMPLOYEE';

-- 인덱스의 키가되는 컬럼조회
SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME='EMPLOYEE';

-- 인덱스로 지정한 EMP_NAME컬럼을 이용한 조회
SELECT * FROM EMPLOYEE
WHERE EMP_NAME ='하이유';

INSERT INTO EMPLOYEE
VALUES(100,'하이유','111111-1234567','rdf@naver.com','01011112222','D1','J7','S5',3000000,0.3,201,SYSDATE,NULL,DEFAULT);

-- * EMPLOYEE테이블의 DEPT_CODE컬럼 UNIQUE INDEX생성하기
-- 인덱스의 키가되는 컬럼조회
SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME='EMPLOYEE';

SELECT * FROM EMPLOYEE;
-- UNIQUE 인덱스 생성
CREATE UNIQUE INDEX IDX_DEPTCODE
ON EMPLOYEE(DEPT_CODE);
--> 컬럼값들 중에 중복되는 값이 있는 경우 UNIQUE INDEX 생성 불가


/*
   2) 비고유 인덱스(NONUNIQUE INDEX)
   - 빈번하게 사용되는 일반컬럼을 대상으로 생성, 주로 성능향을 목적으로생성

   3) 단일 인덱스(SINGLE  INDEX)
   - 한개의 컬럼으로 구성된 인덱스

*/

-- * EMPLOYEE 테이블의 DEPT_CODE컬럼에 인덱스 생성
CREATE INDEX IDS_DEPTCODE
ON EMPLOYEE(DEPT_CODE);
--> 비고유(중복값 포함 가능)이면서 단일(컬럼이 한개)인덱스

-- [참고] : 인덱스 이름 수정
ALTER INDEX IDS_DEPTCODE
RENAME TO IDX_DEPTCODE;
-- [참고] : 인덱스 삭제
DROP INDEX IDX_DEPTCODE;

/*
   4) 결합인덱스(COMPOSITE INDEX)
    - 두 개 이상의 컬럼으로 구성된 인덱스
*/
-- DEPARTMENT 테이블의 DEPT_ID,DEPT_TITLE결합 인덱스 생성
CREATE INDEX IDX_DEPT
ON DEPARTMENT(DEPT_ID,DEPT_TITLE);

-- 인덱스의 키가되는 컬럼조회
SELECT * FROM USER_IND_COLUMNS WHERE TABLE_NAME='DEPARTMENT';
-- IDX_DEPT라는 하나의 인덱스 이름으로 두 컬럼이 생성된다.

SELECT * FROM DEPARTMENT
WHERE DEPT_ID='D4'AND DEPT_TITLE='국내영업부';



