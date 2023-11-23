/*
    <뷰 : VIEW>- 논리적으로 테이블만 가지고 있는 상태 
    - 데이터는 디비에 저장하고 불러올 수 있는 키트 같은 느낌?
    SELECT 문을 저장해 둘 수 있는 객체
    (자주 쓰는 객체를 만들어 놓는다.) 
    (SELECT문 저장해 두면 JOIN을 여러개 해야 한다면 저장해둔다)
    (장점: 매번 다시 기술하지 않아도 된다.)
    임시테이블 같은 존재(실제 데이터가 담겨 있는 것은 아니다)
    논리적인 테이블 (물리적인 테이블X)
    실제 저장되어 있지는 않는다. 
    
*/
--한국에서 근무하는 사원들의 사번, 사원명, 부서명, 급여, 근무국가명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
FROM EMPLOYEE
    --JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID) 앞뒤 바뀌어도 값이 나온다.
    JOIN DEPARTMENT ON (DEPT_ID=DEPT_CODE)
    JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
    JOIN NATIONAL USING (NATIONAL_CODE)
WHERE NATIONAL_NAME='한국';
-------------------------------------------------------------
/*
    1.VIEW 생성 방법
    [표현식]
    CREATE VIEW 뷰명
    AS 서브쿼리문; 
    
*/
--시퀀스, 뷰, 테이블 모두 만들 수 있다.  문법은 동일 
--드롭 할 때도 동일 
CREATE VIEW VM_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
        FROM EMPLOYEE
          JOIN DEPARTMENT ON (DEPT_ID=DEPT_CODE)
          JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
          JOIN NATIONAL USING (NATIONAL_CODE);

--ORA-01031: 권한이 불충분합니다

--관리자 계정에서 VIEW를 생성있는 권한 부여 (오른쪽위에 관리자계정확인)
GRANT CREATE VIEW TO AIE;
--Grant을(를) 성공했습니다.
CREATE VIEW VM_EMPLOYEE
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
        FROM EMPLOYEE
          JOIN DEPARTMENT ON (DEPT_ID=DEPT_CODE)
          JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
          JOIN NATIONAL USING (NATIONAL_CODE);
--AIE 계정으로 다시 바꾸고 실행하면
--View VM_EMPLOYEE이(가) 생성되었습니다. 라고 뜬다. 

SELECT * FROM VM EMPLOYEE;
--관리자계정에서 VIEW를 생성있는 권한 부여 
--==아래와 같은 맥락
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, DEPT_TITLE, SALARY,NATIONAL_NAME
        FROM EMPLOYEE
          JOIN DEPARTMENT ON (DEPT_ID=DEPT_CODE)
          JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
          JOIN NATIONAL USING (NATIONAL_CODE));

--VIEW뷰는 논리적인 가상 테이블(실질적으로는 데이터를 저장하고 있지 않다)

SELECT *
    FROM VM_EMPLOYEE 
WHERE NATIONAL_NAME='한국';

SELECT *
    FROM VM_EMPLOYEE 
WHERE NATIONAL_NAME='러시아';

SELECT *
    FROM VM_EMPLOYEE 
WHERE NATIONAL_NAME='중국';

--원하는 것으로만 하면 된다.
---------------------------------------------------------------
--참고-- 만들어진 뷰 보기 
SELECT * FROM USER_VIEWS;

/*

    *뷰 컬럼에 별 칭 부여
    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
    서브쿼리의 SELECT 절에 함수식이나 산술연산식이 기술되어 있을 경우
    ★반드시 별칭을 지정★해야 된다.★★★★★★★★★★★★★★★★★★ 
    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
 */
--전체 사원의 사번, 사원명, 직급명,성별(남/여), 근무년수를 조회할 수 있는 VIEW(VM_EMP_JOB)생성
--CREATE OR REPLACE VIEW 뷰명 : 리플레이스가 붙으면 같은 명칭 있으면 덮어쓰기 하시오,갱신한다
--오류 뜨는 이유가  DOCODE에  함수식 들어가있는데  컬럼에 명칭 부여 해야한다.
CREATE VIEW VM_EMP_JOB
    AS SELECT EMP_ID AS "사번", 
             EMP_NAME AS "사원명", 
             JOB_NAME AS "직급명", 
             DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여',3,'남',4,'여') AS "성별(남/여)",
             EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM HIRE_DATE) AS "근무년수"
    FROM EMPLOYEE
            JOIN JOB USING (JOB_CODE);

--갖고오기
SELECT * FROM VM_EMP_JOB;
    
--별칭 부여를 아래와 같은 방식으로도 가능 ★★★★★★★★★★★ 이방법이 편하긴 하다. 
--덮어쓰기 OR REPLACE
CREATE OR REPLACE VIEW  VM_EMP_JOB(사번2, 사원명2, 직급명, 성별, 근무년수)
    AS SELECT EMP_ID  , 
             EMP_NAME  , 
             JOB_NAME , 
             DECODE(SUBSTR(EMP_NO,8,1),1,'남',2,'여',3,'남',4,'여') ,
             EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM HIRE_DATE) 
    FROM EMPLOYEE
            JOIN JOB USING (JOB_CODE);

SELECT 사원명, 직급명
    FROM VM_EMP_JOB
WHERE 성별 = '여';

SELECT *
FROM VM_EMP_JOB
WHERE 근무년수 >=20;

--뷰삭제

DROP VIEW VM_EMP_JOB;

-------------------------------------------------------
--생성된 뷰를 이용하여 DML(INSERT, UPDATE, DELETE)가능
--뷰를 통해 조작하면 실제 데이터가 담겨있는 
--데이터 베이스 테이블에 반영됨 

CREATE OR REPLACE VIEW VM_JOB
AS SELECT JOB_CODE, JOB_NAME
    FROM JOB;

SELECT * FROM VM_JOB;
SELECT * FROM JOB;

--뷰를 통해서 INSERT 
INSERT INTO VM_JOB VALUES('J8','인턴');

--뷰를 통해서 UPDATE
UPDATE VM_JOB
    SET JOB_NAME = '알바'
    WHERE JOB_CODE='J8';

--뷰를 통해 DELETE
DELETE 
    FROM VM_JOB
    WHERE JOB_CODE='J8';

--다 되는 것은 아니다 안되는 것도 있다 
/*
    *단, DML 명령어로 조작이 불가능한 경우가 더 많은
    1) 뷰에 정의 되어 있지 않은 컬럼을 조작 하려는 경우
    2) 뷰에 정의 되어 있지 않은  컬럼 중에 베이스 테이블 상에
       NOT NULL 제약조건이 지정되어 있는 경우 
    3) 산술 연산식이나 함수식으로 정의 되어 있는 경우 
    -혼자서 알아서는 안된다. 
    EX) EXTRACT(YEAR FROM SYSDATE)- EXTRACT(YEAR FROM HIRE_DATE) 
    4) 그룹함수나 GROUP BY절이 포함되어 있는 경우 
    -합계나 코드별로 되어있다고 한다면 1명인지 10명인지 모르므로 
    어떤 사람이 얼마만큼 구하는지를 모른다. 
    5) DISTINCT 구문이 포함된 경우 
    하나씩만 갖고왔기 때문에 그룹이랑 비슷한 느낌이다. 
    5명중에 누구를 업데이트 할 지를 모르기 때문에 모른다. 
    6) JOIN을 이용하여 여러 테이블 연결시켜 놓은 경우 
    
*/
--뷰
CREATE OR REPLACE VIEW VM_JOB
AS SELECT JOB_CODE
    FROM JOB; 
--뷰에 정의 되어 있지 않은 컬럼을 조작할 경우 
--뷰를 통해 INSERT
INSERT INTO VM_JOB(JOB_CODE, JOB_NAME) VALUES('J8','인턴');
--SQL 오류: ORA-00904: "JOB_NAME": 부적합한 식별자

--뷰를 통해 UPDATE 
UPDATE VM_JOB
    SET JOB_NAME = '알바'
WHERE JOB_CODE='J8';
--SQL 오류: ORA-00904: "JOB_NAME": 부적합한 식별자

--뷰를 통해 DELETE
DELETE
    FROM VM_job
WHERE JOB_NAME='사원'
--SQL 오류: ORA-00904: "JOB_NAME": 부적합한 식별자... 오류남
--있는 컬럼으로해야 오류 안난다. 

--2) 뷰에 정의 되어 있지 않은 컬럼 중에 베이스테이블 상에 NOT NULL제약조건이 지장되어 있는 경우
CREATE OR REPLACE VIEW VM_JOB
AS SELECT JOB_NAME
    FROM  JOB;
--INSERT 
INSERT INTO VM_JOB VALURE('사원');
--JOB코드가 반드시 들어가야 함, 프라이머리 키 ,
--뷰에는 들어있지만 원래테이블에 낫널 값이 안들어가게 되면 오류가 뜬다. 
--실제 테이블에 INSERT할 때는 VALUES(NULL,'사원')추가
            JOB_CODE는 PK라 NULL 을 넣을 수 없음 
            
--DELETE 
DELETE 
    FROM VM_JOB
WHERE JOB_CODE='7';
      
--3) 산술연산식이나 함수식으로 정의 되어 있는 경우 
CREATE OR REPLACE VIEW VM_EMP_SAL
AS SELECT EMP_ID, EMP_NAME, SALARY, SALARY*12 연봉
FROM EMPLOYEE;

--INSERT 
INSERT INTO VM_EMP_SAL VALUES(600,'김상진',3000000,360000000);
--SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다
--실제 테이블에는 연봉이라는 컬럼이 없다. 
--따라서 가상으로 사용할 수 없다고 나온다. 

INSERT INTO VM_EMP_SAL (EMP_ID, EMP_NAME, SALARY) VALUES (600,'김상진',3000000);
--INSERT INTO VM_EMP_SAL (EMP_ID, EMP_NAME, SALARY) VALUES (600,'김상진',3000000)
--오류 보고 ORA-01400: NULL을 ("AIE"."EMPLOYEE"."EMP_NO") 안에 삽입할 수 없습니다
--이유: NOT NULL 부분을 채워줘야 함 

--UPDATE(오류)
UPDATE VM_EMP_SAL
    SET 연봉 = 40000000
  WHERE EMP_ID='301';
--오류 보고 -
--SQL 오류: ORA-01733: 가상 열은 사용할 수 없습니다

--UPDATE  ( 위에 연봉을 SALARY로 바꾼것 기존 컬럼은 가능)
UPDATE VM_EMP_SAL
    SET SALARY = 40000000
  WHERE EMP_ID='301';

SELECT*FROM VM_EMP_SAL
ORDER BY 연봉;

--DELETE(성공) 
DELETE
    FROM VM_EMP_SAL
    WHERE 연봉 = 16560000;
--한개 삭제 

ROLLBACK;

--4) 그룹함수나 GROUP BY절이 포함되어 있는 경우 
CREATE OR REPLACE VIEW VM_GROUP_DEPT
AS SELECT DEPT_CODE, SUM(SALARY) AS "합계",
                   ROUNDE(AVG(SALARY),1) 
        FROM EMPLOYEE
                  GROUUP BY DEPT_CODE;
 
--INSERT
INSERT INTO VM_GROUP_DEPT VALUES('D3','80000000',300000000000000000);
--오류 그룹으로 되어안된다. 

--UPDATE 
INSERT INTO VM_GROUP_DEPT
 SET 6 합계 = 6000000
 WHERE DEPT_COPE="D2";
 
 -DELET(오류)
 DELETE FROM VM_GROUPDE[T
 

-- 5) DISTINCT 구문이 포함된 경우 
CREATE OR REPLACE VIEW, VM_JOB
AS SELSECT DISTINCR JOB_CODE
        FROM FROM EMPLUUUQSSSSSSSS;
--6)INSERT (오류) : 이유 , 낫널, 낫널이 아니여도 오류
    INSERT IN VM_JOB VALUES('J8');
    
--UPDATE (오류)
UPDATE VM_JOB
    SET JOB_CODE='J8'
    WHERE  JOB_CODE='J1';
    
--DELETE(오류)
DELETE FROM VM_JOB
WHERE  JOB_CODE='J1';
    
-- 6)JOIN을 이용하여 여러테이블을 연결 시켜 놓은 경우 
CREATE OR REPLACE VIEW VM_JOIN
AS SELECT EMP_ID, EMP_NAME, DEPT_TITLE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID);
    
SELECT * FROM VM_JOIN;

--INSERT
INSERT INTO VM_JOIN VALUES(700,'황미정','총무부');
--SQL 오류: ORA-01776: 조인 뷰에 의하여 하나 이상의 기본 테이블을 수정할 수 없습니다.

--UPDATE    이름만 업데이트 
UPDATE VM_JOIN
    SET EMP_NAME = '김새로이'
WHERE EMP_ID=200;

-- UPDATE  
-- 인사관리부는 DEPT_TITLE에 있다. 
UPDATE VM_JOB
    SET DEPT_TITLE = '인사관리부'
WHERE EMP_ID=200;

UPDATE VM_JOIN
    SET DEPT_TITLE = '인사관리부'
WHERE EMP_ID=200;
--JOIN을 통해 부서를 가져왔기 때문에 EMPLOYEE테이블의 DEPT_CODE수정안됨

--DELETE 
DELETE FROM VM_JOIN
WHERE EMP_ID=200;

ROLLBACK;

------------------------------------------------------

/*
    *VIEW 옵션
    [표현식]
    CREATE [OR REPLACE][FORCE|NOFORCE] VIEW 뷰명 AS 서브쿼리
    2개 옵션 가능 
    [WITH CHECK OPTION]
    [WITH READ ONLY];
    
    1)OR REPLACE: 기존에 동일 뷰가 있으면 갱신 시키고, 없으면 새로 생성
    2) FORCE|NOFORCE (잘 사용하지 않는 것) 
       > FORCE   :  서브 쿼리에 기술된 테이블이 존재하지 않아도 뷰가 생성됨
(기본값)> NOFORCE :  서브 쿼리에 기술된 테이블이 존재 해야만 뷰를 생성할 수 있다.
     3) WITH CHECK OPTION : 
        DML시 서브쿼리에 기술된 조건에 부합하는 값으로만 DML이 가능하도록함. 
     4) WITH READ ONLY :
      뷰에 대해 조회만 가능(DML문 (SELECT는 제외 / INSERT 불가) 
    
*/
--2 )FORCE|NOFORCE
--      NOFORCE
CREATE OR REPLACE/*NOFORCE*/ VIEW VM_EMP
AS SELECT TCODE, TNAME, TCOUNT
    FROM TT;

--      FORCE
CREATE OR REPLACE FORCE VIEW VM_EMP
AS SELECT TCODE, TNAME, TCOUNT
    FROM TT;
--경고: 컴파일 오류와 함께 뷰가 생성되었습니다.

SELECT * FROM VM_EMP;
--엑박 뜬다. 컴파일 오류 

-- TT테이블을 생성해야만 그때부터 VIEW를 활용
CREATE TABLE TT (
    TCODE NUMBER, 
    TNAME VARCHAR2(20), 
    TCOUNT NUMBER
);

SELECT * FROM VM_EMP;

-- 3) WITH CHECK OPTION
CREATE OR REPLACE VIEW VM_EMP
AS SELECT *
    FROM EMPLOYEE
    WHERE SALARY >=3000000;
    
-- 200번 사원의 급여를 200만원으로 변경 
UPDATE VM_EMP  -----8명
    SET SALARY = 2000000 -- 위에 조건이 들어가서 7명 나옴
WHERE EMP_ID=200;

ROLLBACK;
-- 3) WITH CHECK OPTION
-- 옵션없이 그냥 VIEW 생성 

CREATE OR REPLACE VIEW VM_EMP_CHECK 
AS SELECT *
   FROM EMPLOYEE
   WHERE SALARY >= 3000000
   WITH CHECK OPTION;

UPDATE VM_EMP_CHECK
    SET SALARY = 2000000
WHERE EMP_ID = 201; 
--SQL 오류: ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
--300만원 이상이라 보여줬는데 200으로 바꾸면 조건 위배 되서 안된다. 
--서브쿼리에 기술된 조건에 부합되지 않기 때문에 변경 불가 

UPDATE VM_EMP_CHECK
    SET SALARY = 4000000
WHERE EMP_ID = 202; 
--위배되지 않으면 변경 가능 


--4) WITH READ ONLY 
CREATE OR REPLACE VIEW VM_EMP_READ 
AS SELECT EMP_ID, EMP_NAME, BONUS
    FROM EMPLOYEE
    WHERE BONUS IS NOT NULL
WITH READ ONLY; 

SELECT * FROM VM_EMP_READ;

DELETE FROM VM_EMP_READ WHERE EMP_ID=200;
--SQL 오류: ORA-42399: 읽기 전용 뷰에서는 DML 작업을 수행할 수 없습니다.
--INSERT, DELETE, UPDATE 불가하다. 




