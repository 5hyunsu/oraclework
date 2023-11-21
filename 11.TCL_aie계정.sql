/*
    트랜잭션 제어 
    <TCL :  TRASACTION CONTROL LANGUAGE >
    *트랜 잭션 
    -데이터베이스의 논리적 연산단위
    -데이터의 변경사항(DML) 들을 하나의 트랜잭션에 묶어서 처리
    -DML문 한개를 수행할 때 트랜잭션이 존재하면 해당 트랜잭션에 같이 묶어서 처리 
     (트랜 잭션이 존재하지 않으면 트랜잭션을 만들어서 묶음
    -COMMIT하기 전까지의 변경 사항을 하나의 트랜잭션에 담게됨
     -트랜잭션의 대상이 되는  SQL: INSERT, UDATEE, DELETE 
    
    COMMIT(트랜잭션 종료 처리 후 확정)
    ROLLBACK (트랜잭션 취소) COMMIT 전까지는 가능 
    SAVEPOINT(임시저장) 
    
    -COMMIT 진행 : 
    한 트랜잭션에 담겨있는 변경사항 들을 실제 DB에 반경시키겠다는 의미 
    = 후에 트랜젝션은 사라짐 
    
    -ROLLBACK 진행:
    한 트랜잭션에 담겨있는 변경사항 들을 삭제(취소)한 후 COMMI 시점으로 돌아감 
    자동 커밋이 되기도 하고,  안 될 때도 있고 , 다르다. 
    
    -SAVEPOINT 진행:
    현재 이 시점에 해당 포인트 명으로 임시저장점으로 정의해 두는 것 
    ROLLBACK 진행시 전체 변경사항들을 다 삭제하는게 아니라 일부만 롤백 가능
  
*/
SELECT * FROM EMP_01;
ALTER TABLE EMP_01 DROP COLUMN EMAIL;
ALTER TABLE EMP_01 DROP COLUMN PHONE;
ALTER TABLE EMP_01 DROP COLUMN DEPT_CODE;
ALTER TABLE EMP_01 DROP COLUMN JOB_CODE;
ALTER TABLE EMP_01 DROP COLUMN SALARY;
ALTER TABLE EMP_01 DROP COLUMN BONUS;
ALTER TABLE EMP_01 DROP COLUMN MANAGER_ID;
ALTER TABLE EMP_01 DROP COLUMN END_DATE;
ALTER TABLE EMP_01 DROP COLUMN EMP_NO;
ALTER TABLE EMP_01 DROP COLUMN HIRE_DATE;
ALTER TABLE EMP_01 DROP COLUMN ENT_YN;

--사번이 300인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID=300;
--새로운 트랜잭션을 만들어서 DELETE 3000드러감 
--ㅣ실제 DB에 반영 안됨 
ROLLBACK; -- 300,301번이 되살아남

--사번이 301인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID=300;
--사번이 200인 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID=200;

SELECT * FROM EMP_01;

INSERT INTO EMP_01 VALUES(500,'남길동','기술지원부');

COMMIT;

ROLLBACK;
--------------------------------------------------------------
--216,217, 214 사원 삭제
DELETE FROM EMP_01
WHERE EMP_ID IN (216,217,214);  --트랜잭션에 남아있는 상태


--임시 저장 점 만들기
SAVEPOINT SP;
SELECT * FROM EMP_01; 

--501번 추가 
INSERT INTO EMP_01 VALUES(501,'이세종');

--218번 삭제 
DELETE FROM EMP_01;

--임시저장점 SP까지만 롤

ROLLBACK TO SP;

SELECT * FROM EMP_01; 

COMMIT;

---------------------------------------------------------------
/*
   *자동 COMMIT 되는 경우
    -정상 종료
    -DCL(GRANT REVOK)과 DDL(CREATE, ALTER, ROLLBACK, DROP)명령문이 수행된 경우
    
    *자동 ROLLBACK 되는 경우
    -비정상종료
    -전원꺼짐, 정전, 컴퓨터 꺼짐 (DOWN)
     
*/
--사번이 301번 501번 삭제 
DELETE FROM EMP_01
WHERE EMP_ID IN (301,501);

--사번이 301번 501번 삭제 
DELETE FROM EMP_01
WHERE EMP_ID =200;

--DDL문
CREATE TABLE TEST(
    T_ID NUMBER 
);
--이부분에 인서트, 딜리트 했다하면 여기는 롤백 가능 (0)

--DDL구문을 실행하는 순간 COMMIT이 된다. 
ROLLBACK;
--커밋 하면 위에 딜리트도 모두 소용이 없다.  

-->DDL문 (CREATE, ALTER, ROLLBACK,  DROP)

--트랜잭션에 쌓여만 있고 , 실제 DB에 저장 되어있어야 되서 
--커밋해야 한다. 안하면 반영이 안됨







