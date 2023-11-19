--1.3의 권한부여전에 실행하면 오류, 권한부여후에 생성 가능 
CREATE TABLE TEST (
    ID VARCHAR(30), 
    NAME VARCHAR(20)
);
--오류 보고 -
--ORA-01031: 권한이 불충분합니다
--01031. 00000 -  "insufficient privileges"

----10.DCL에서 다시 권한 주고 돌리기 -->TEST 생김
CREATE TABLE TEST (
    ID VARCHAR(30), 
    NAME VARCHAR(20)
);
--1.4의 권한 부여 전과 후 비교 
INSERT INTO TEST VALUES('USER01','홍길동');
--SQL 오류: ORA-01950: 테이블스페이스 'USERS'에 대한 권한이 없습니다.
--01950. 00000 -  "no privileges on tablespace '%s'"

--테이블만 생성하는 권한을 줬기 때문에 TABLE 스페이스 만드는 권한이 있어야 함

---10.DCL에서 스페이스 권한인 
--4.TABLESPACE 할당 데이터 삽입 안됨
--ALTER USER SAMPLE QUOTA 2M ON USERS;
INSERT INTO TEST VALUES('USER01','홍길동');

------------------------------------------------------
--2.1의 권한 부여 전과 후 비교
SELECT * FROM AIE.EMPLOYEE;
--ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
--00942. 00000 -  "table or view does not exist"
--AIE 계정에 접근 할 수 없다. 
--DCL 관리자 계정에서 접근 권한을 준다

SELECT * FROM AIE.EMPLOYEE;


--2.2의 권한 부여 후 
SELECT * FROM AIE.DEPARTMENT;
INSERT INTO AIE.DEPARTMENT  VALUES('D0','관리부','L2');

SELECT * FROM AIE.DEPARTMENT;
COMMIT;
--관리자계정은 커밋 안해줘도 된다. 










