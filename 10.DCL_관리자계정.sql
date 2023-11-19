/*
    <DCL : DATA CONTROL LAGUAGE>
    데이터 제어어
    계정에게 시스템 권한 또는 객체에 접근 권한 부여(GRANT)하거나
    회수(REVOKE)하는 구문 
    
    >시스템 권한 : DB에 접근 하는 권한, 
    >객체접근 권한 : 특정객체들을 조작할 수 있는 권한
    >
*/

/*
    1.시스템 권한의 종류 
    -CREATE SESSION : 접속할 수 있는 권한 
    -CREATE TABLE : 테이블을 생성 할 수 있는 권한 
    -CREATE VIEW : VIEW를 생성할 수 있는 권한
    -CREATE SEQUENCE : 시퀀스 생성할 수 있늰 권한 
    ...
*/
--1.1.SAMPLE / sample 계정 생성
ALTER SESSION set "_oracle_script" = true; -- c## 안붙이려고
CREATE user sample IDENTIFIED BY sample;
--접속권한이 없어 접속 못함 

--1.2.접속을 위해 create session 권한 부여 
GRANT create session to sample;
-- 녹색 플러스 

--1.3.테이블을 생성할 수 있는 권한 CREATE TABLE 권한 부여 
GRANT CREATE TABLE TO SAMPLE;

--1.4.TABLESPACE 할당 데이터 삽입 안됨
ALTER USER SAMPLE QUOTA 2M ON USERS;

---------------------------------------------
/*
2. 객체 접근 권한
특정 객체에 접근하여 조작할 수 있는 권한 
권한종류
SELECT  TABLE, VIEW, SEQUENCE 
INSERT  TABLE, VIEW
UPDATE  TABLE, VIEW
DELETE  TABLE, VIEW
...

[표현식]
GRANT 권한종류 ON 특정객체 TO 계정명;
-GRANT 권한 종류 ON 권한을 ~~~
*/

--2.1SAMPLE 계정에게 AIE 계정 EMPLOYEE테이블을 SELECT 할 수 있는 권한 부여
GRANT SELECT ON AIE.EMPLOYEE TO SAMPLE;

--2.2 SAMPLE 계정에게 AIE 계정 DEPARTMENT테이블을 INSERT 할 수 있는 권한 부여
GRANT INSERT ON AIE.DEPARTMENT TO SAMPLE;

GRANT SELECT ON AIE.DEPARTMENT TO SAMPLE;
















