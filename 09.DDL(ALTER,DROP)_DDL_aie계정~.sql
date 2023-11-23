/*
    <ALTER>
    객체를 변경하는 구문 
    
    [표현식]
    ALT TABLE 테이블명 변경할 내용; 
    
    *변경할 내용에 해당 하는 것 
     1) 컬럼 추가 / 수정 / 삭제
     2) 제약조건 추가 / 삭제 ->수정 불가
     (수정하고자 하면 삭제 후 새로 추가) 
     3) 컬럼명 / 제약조건명/ 테이블명 변경
     
*/

--====1) 컬럼 추가/ 수정/ 삭제 
--1.컬럼 추가 (ADD): ADD 컬럼명 데이터타입 [DEFAULT 기본값]

--DEPT_COPY 테이블에 CNAME 이라는 컬럼을 추가 
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
-->새로운 컬럼이 만들어지고 기본적으로 NULL로 채워짐

--DEPT_COPY테이블에 LNAME 컬럼추가, 기본 값은 한국으로 추가 
ALTER TABLE DEPT_COPY ADD LNAME VARCHAR2(20) DEFAULT '한국';
-->새로운 컬럼이 만들어지고 내가지정한 기본값으로 채워짐 

--2. 컬럼 수정(MODIFY):
--> 데이터 타입 수정: MODIFY 컬럼명 바꾸고자 하는 데이터 타입 
-->DEFAULT 값 수정 : MODIFY 컬럼명 DEFAULT 바꾸고자 하는 데이터 타입
                              --바이트 바꾸기  D10, D11로 넣기위해서 바꿈

--DEPT_COPY 테이블의 DEPT_ID의 데이터 타입을 CHAR(3)으로 수정 
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

--DEPT_COPY 테이블의 DEPT_ID의 데이터 타입을 NUMBER 으로 수정

--ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;
--ORA-01439: 데이터 유형을 변경할 열은 비어 있어야 합니다
--★컬럼값에 문자, 영문이 있어서 오류가 발생한다. 
--또한 컬럼의 데이터 타입을 변경하기 위해서는 해당 컬럼의 값을 모두 지워야
--변경이 가능하다. 

--DEPT_COPY 테이블의 DEPT_TITLE의 데이터 타입을 VARCHAR2(10)수정
--ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(10);
--ORA-01441: 일부 값이 너무 커서 열 길이를 줄일 수 없음
--01441. 00000 -  "cannot decrease column length because some value is too big"
--★컬럼 값이 10바이트가 넘어가서 변경이 되지 않음. 크게 하는 것은 상관 없는데 
--작게하는 것은 데이터 확인 해봐야함 

--DEPT_TITLE : VARCHAR2(40)
ALTER TABLE DEPT_COPY MODIFY DEPT_TITLE VARCHAR2(40);
--LOCATION_ID : VARCHAR2(2)
ALTER TABLE DEPT_COPY MODIFY LOCATION_ID VARCHARD2(2);
--LNAME: '미국'
ALTER TABLE DEPT_COPY MODIFY LNAME DEFAULT '미국';

--다중변경
ALTER TABLE DEPT_COPY
    MODIFY DEPT_TITLE VARCHAR2(40)
    MODIFY LOCATION_ID VARCHAR2(2)
    MODIFY LNAME DEFAULT '미국';

------------------------------------------------------

--3.컬럼 삭제(DROP COLUMN): 삭제하고자 하는 컬럼 
/*
    [표현법] 
    ALTER TABLE 테이블명 DROP COLUMN 컬럼명;
    
*/
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

--DEPT_COPY2 테이블에서 LNAME 컬럼삭제
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;

--컬럼 삭제는 다중 안됨 
--ALTER TABLE DEPT_COPY2
--    DROP COLUMN DEPT_TITLE
--    DROP COLUMN LNAME;
--ORA-00933: SQL 명령어가 올바르게 종료되지 않았습니다
--00933. 00000 -  "SQL command not properly ended"
--여러개 한꺼번에 삭제 안된다. 

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
--ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
--ORA-12983: 테이블에 모든 열들을 삭제할 수 없습니다
--12983. 00000 -  "cannot drop all columns in a table"
--컬럼 모두 지울 수 없다. 최고 1개는 있어야 한다. 

--------------------------------------------
/*
    2) 제약 조건 추가/ 삭제
*/
--===== 1. 제약조건 추가 
/*
    ALTER 테이블을 다 생성한 후에 제약조건 추가 
    ALTER TABLE 테이블명 변경할 내용;
    DELETE UPDATE는 아니다 
    -PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명); --뒤에 부분은 테이블 레벨 방식으로 뒤에 넣어주면된다 
    -FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(참조할 테이블명)];
    -UNIQUE      : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
    -CHECK       : ALTER TABLE 테이블명 ADD CHECK (컬럼명);
    -NOT NULL    : ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;  --NOT NULL은 ADD 사용하지 않고 MODIFY 사용 
);
*/
--===== 2. 제약조건 삭제 
 /*[표현법] 
    ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건;
    --NULL값일 때는 사제는 없다. 
    --NOT NULL일때만 MODIFY 사용
    ALTER TABLE 테이블명 MODIFY 컬럼명 NULL;
    -->NULL일때는 수정 
 */
 ALTER TABLE DEPT_COPY DROP CONSTRAINT F_JOB;
 
 ALTER TABLE EMP_DEPT MODIFY EMP_NAME NULL;

----------------------------------------------------
/*
    3) 컬럼명/ 제약 조건 명 / 테이블명 변경 (RENAME)
*/
--====1.컬럼명 변경 : RENAME COLUMN 기존컬럼명 TO 바꿀 컬럼명
--DEPT_COPY테이브의  DEPT_TITLE를 DEPT_NAME으로 컬럼명 변경
ALTER TABLE DEPT_COPY
RENAME COLUMN DEPT_TITLE TO DEPT_NAME;


--====2. 제약조건명 변경 : RENAME CONSTRAINT 기존컬럼조건명 TO 바꿀계약 컬럼명
----EMPLOYEE_COPY 테이블의 기본키의 제약조건의 이름변경
ALTER TABLE EMPLOYEE_COPY
RENAME CONSTRAINT SYS_C008493 TO EC_PK;

--====3. 테이블명 변경 : 기존테이블명 RENAME  TO 바꿀테이블명 
--DEPT_COPY => DEPT_TEST 
ALTER TABLE DEPT_COPY
RENAME TO DEPT_TEST;
--DEPT_COPY2 => DEPT_TEST 2
ALTER TABLE DEPT_COPY2
RENAME TO DEPT_TEST2;

----------------------------------------------------
--테이블 삭제
--DROP TABLE 테이블명; 
/*
    조건
    어딘가에서 참조되고 있는 부모테이블은 함부로 삭제 안된다.
    삭제를 하고 싶다면 
    방법1. 자식테이브을 먼저 삭제 후 부모테이블 삭제 
    방법2. 부모 테이블만 삭제를 하느데 제약조건 까지 같이 삭제하는 방법 
    --            DROP TABLE 테이블명 CASCADE CONSTRAINT ;
    
*/
--DROP TABLE DEPT_TEST; 
--안에 데이터 있어도 통째로 삭제 된다.










