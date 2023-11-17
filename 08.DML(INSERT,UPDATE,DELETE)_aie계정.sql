/*
    *DML(DATE MANIPULATION)
    데이터 조작언어
    테이블에 값을 삽입(INSERT)하거나, 수정(UPDATE),삭제(DELETE),
    검색(SELECT)하는 구문 
    - 
*/

--========================================================

/*
    1.INSERT 
        테이블에 새로운 행을 추가하는 구문 
    [표현식]
    1) INSERT INTO 테이블명 VALUES(값1, 값2, 값3,,)
       테이블의 모든 컬럼에 값을 직접 넣어 한 행을 넣고자 할 때 
       컬럼의 순서대로 VALUES에 값을 넣는다 
    
       부족하게 값을 넣었을 때 => NOT ENOUGH VALUE 오류가 뜬다.
       값을 더 많이 넣었을 때 => TOO MANY VALUES 오류가 뜬다. 
   
*/

--EMPLOYEE 테이블에 300번대 추가 작업

INSERT INTO EMPLOYEE VALUES(300, 
                        '이시영',
                        '051117-1234567',
                        'lee@gmail.com',
                        '01012345678',
                        'D1',
                        'J3',
                        3500000,
                        0.2,
                        200,
                        SYSDATE,
                        NULL,
                        DEFAULT);
                        
INSERT INTO EMPLOYEE VALUES(301, 
                        '이시영',
                        '051117-1234567',
                        'lee@gmail.com',
                        '01012345678',
                        'D1',
                        'J3',
                        3500000,
                        0.2,
                        200,
                        SYSDATE,
                        NULL,
                        DEFAULT,NULL);                        
--값의 수가 많거나 적으면 오류 

SELECT * FROM EMPLOYEE;
------------------------------------------------------

/*
    2) INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명...) VALUES(값, 값, 값..)
    테이블에 내가 선택한 컬럼에 값을 넣을 때 사용 
    10개인데 5개만 넣어도 한 행이 추가 
    행 단위로 추가 되기 때문에 선택 되지 않은 컬럼은 기본적으로 NULL이 들어감
    ★반드시 넣어줘야 하는 경우 발생 
    언제? 기본키,NOT NULL인 컬럼
    단, 기본값(DEFAULT)가 지정되어 있는 컬럼은 NULL이 
    NULLABLE이 NO로 되어있는 것은 
*/
INSERT INTO EMPLOYEE(EMP_ID,EMP_NAME,EMP_NO,JOB_CODE,HIRE_DATE) 
                 VALUES(301,'김지창','031017-1234567','J1',SYSDATE);
                 
INSERT INTO EMPLOYEE(HIRE_DATE,EMP_ID,JOB_CODE,EMP_NAME,EMP_NO)
                VALUES(SYSDATE,302,'J1','손지창','111017-1234567');

SELECT * FROM EMPLOYEE;
------------------------------------------------------------
/*
    3) 서브쿼리를 이용한 INSERT 
    VALUES의 값을 직접 명시하는 대신 서브쿼리로 조회된 결과값을 모두
    -INSERT가능(여러행도 가능)
*/
--테이블 생성
CREATE TABLE EMP_01 (
    EMP_ID NUMBER, 
    EMP_NAME VARCHAR2(20),
    DEPT_NAME VARCHAR2(35) --서브쿼리 너무 작으면 안들어감,똑같이 하던지 크게 하던지
);

--전체 사원의 사번, 사원명, 부서명 조회 
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--NULL인 사람(DEPARTMENT가 NULL인 ) 조회를 위해서 
INSERT INTO EMP_01 (
            SELECT EMP_ID, EMP_NAME, DEPT_TITLE
            FROM EMPLOYEE
            LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID));
--추천하지는 않는다. 기본적으로 잘게 나누어 놓은 상태인데 
--중복되어있는 상태의 값이 많이 들어가기 때문에 피하는 것이 좋다 

--INSERT ALL 2개이상의 테이블에 INSERT 하고 싶을 때 사용 
/*
    4) INSERT ALL  : 2개 이상의 테이브에 각각 INSERT 할 때 
    단, 이때 사용되는 서브 쿼리가 동일한 경우 
    
    [표현식]
    INSERT ALL
    INTO 테이블명1 VALUES(컬럼명, 컬럼명,..)
    INTO 테이블명2 VALUES(컬럼명, 컬럼명,..)
        서브쿼리;
    
*/
--테이블 2개 생성
CREATE TABLE EMP_DEPT 
    AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE
    FROM EMPLOYEE
    WHERE 1=0;
    
CREATE TABLE EMP_MANAGER 
AS SELECT EMP_ID, EMP_NAME, MANAGER_ID
    FROM EMPLOYEE
    WHERE 1=0;

--부서코드가 D1인 사원들의 사번, 사원명, 부서코드, 입사일, 사수번호 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID
    FROM EMPLOYEE
WHERE DEPT_CODE='D1';

INSERT ALL --2개이상의 테이블에 값을 넣을 수 있다 
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_JOB VALUES(EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)
INTO EMP_MANAGER VALUES(EMP_ID, EMP_NAME, MANAGER_ID)
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, MANAGER_ID,JOB_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE='D1';

INSERT INTO EMP_DEPT (EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE)VALUES(1,1,1,1);
            --갖고 올때 컬럼 제시하고 지정해주고 갖고 오기 가능

---------------------------------------------------
/*
    5) 조건을 제시하여 각 테이블에 INSERT 가능 
    
    [표현식]
    INDERT ALL 
    WHEN 조건1 THEN 
    INTO 테이블명1 VALUES(컬럼명, 컬럼명...)
    WHEN 조건2 THEN 
    INTO 테이블명2 VALUES(컬럼명, 컬럼명...)
*/
--2000년도 이전에 입사한 사원들의 대한 정보를 담을 테이블 생성
    CREATE TABLE EMP_OLD
    AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
        FROM EMPLOYEE
        WHERE 1=0;

--2000년도 이후에 입사한 사원들의 대한 정보를 담을 테이블 생성
    CREATE TABLE EMP_NEW
    AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
        FROM EMPLOYEE
        WHERE 1=0;

INSERT ALL
    WHEN HIRE_DATE < '2000/01/01' THEN 
        INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    WHEN HIRE_DATE >= '2000/01/01' THEN 
        INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
    SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;
            
--=======================================================
/*
    2.UPDATE
    테이블에 저장되어 있는 기존의 데이터를 수정하는 구문 
    
    [표현식]
    UPDATE 테이블명 
    SET 컬럼명 = 바꿀 값,  --어차피 덮어쓰기가 되니까 바꾸기 된다.
    --컬럼 여러가지 
    SET 컬럼명 = 바꿀값, 
        컬럼명 = 바꿀값,
        컬럼명 = 바꿀값,
        ...
    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
    ★주의★employee 테이블에  컬럼명을 바꿀값으로 바꿀때  누구만 바꾸시오 
    조건을 넣지 않으면 전체 컬럼의 값이 바뀐다. 
    delete도 where 제대로 안쓰면 싹다 날라감 
    ※ 주의할 점 
    where 절이 없으면 모든행의 데이터가 변경됨 
    ★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
  
*/

-- 테이블 생성
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;
--DEPT_COPY 바꾸기 : D3부서의 부서명을 '전략기획팀으로 수정'
UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀';

ROLLBACK; --다시 되돌리기 , 아무때나 막 하면 롤백 지맘대로

UPDATE DEPT_COPY
SET DEPT_TITLE = '전략기획팀'
WHERE DEPT_ID ='D3';

--복사 테이블 생성
CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS
    FROM EMPLOYEE; 
    
--박정보 사원의 급여를 400만원으로 변경 
UPDATE EMP_SALARY
SET SALARY=4000000
WHERE EMP_NAME='박정보';

--조정연 사원의 급여를 410만원, 보너스를 0.25로 변경
UPDATE EMP_SALARY
SET SALARY=4100000
    ,BONUS=0.25
WHERE EMP_NAME='조정연';
    
--전체 사원의 급여를 기존급여의 10% 이상한 금액으로 변경(기존급여*1.1)=(기존급여+기존급여*0.1)
UPDATE EMP_SALARY
SET SALARY=SALARY*1.1;

------------------------------------------------------
/*
    2.1 UPDATE시 서브쿼리 사용
    
    [표현식]
    UPDATE테이블명
    SET 컬럼명=(서브쿼리)
    [WHERE 조건];
    
*/
--왕정보 사원의 급여와 보너스 값을 조졍연 사원의 급여와 보너스값으로 변경 
UPDATE EMP_SALARY
SET SALARY = (SELECT SALARY
            FROM EMPLOYEE
            WHERE EMP_NAME='조정연'),
    BONUS = (SELECT BONUS
            FROM EMPLOYEE
            WHERE EMP_NAME='조정연')
WHERE EMP_NAME='왕정보';

--다중열 서브쿼리도 가능 
UPDATE EMP_SALARY
SET (SALARY,BONUS) = (SELECT SALARY, BONUS
                        FROM EMPLOYEE
                        WHERE EMP_NAME='조정연')
WHERE EMP_NAME='장정보';              

--여러사람 바꾸려면? 

--이시영, 김지창, 허수연, 현정보, 선우정보 사원들의 급여와 보너스를 조정연 사원과 같도록 변경
UPDATE EMP_SALARY
SET (SALARY,BONUS) = (SELECT SALARY, BONUS
                        FROM EMPLOYEE
                        WHERE EMP_NAME='조정연')
WHERE EMP_NAME IN ('이시영',
                '김지창',
                '허수연',
                '현정보',
                '선우정보');
--EMP_NAME='이시영' OR EMP_NAME ='김지창'

--==JOIN으로 데이터 변경
-- ASIA 지역에서 근무하는 사원들의 보너스를 0.3으로 변경 
--3개 테이블 연동 해야 함 

--(1)ASISA지역서 근무하는 사원들 조회 
SELECT EMP_ID
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
JOIN LOCATION ON (LOCAL_CODE=LOCATION_ID)
WHERE LOCAL_NAME LIKE 'ASIA%';
--(2) 업데이트 해주기 
UPDATE EMP_SALARY
SET BONUS = 0.3
WHERE EMP_ID IN (SELECT EMP_ID
                FROM EMPLOYEE
                JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
                JOIN LOCATION ON (LOCAL_CODE=LOCATION_ID)
                WHERE LOCAL_NAME LIKE 'ASIA%');
-----------------------------------------------------------               
--UPDATE시에도 해당 칼럼에 대한 제약조건에 
--사번이 200번인 사원의 이름  NULL 변경

UPDATE EMPLOYEE
SET EMP_NAME=NULL

WHERE EMP_NAME='왕정보';        -- 외래키 제약조건 위해 
ALTER TABLE EMPLOYEE ADD FOREIGN KEY(JOB_CODE) REFERENCES JOB;                

-----------------------------------------------------
/*
    3.  DELETE
         테이블에 저장된 데이터를 삭제하는 구문(행단위로 삭제)
         
         [표현식]
         DELETE FROM 테이블명
         [WHERE 조건];
         
         * 주의사항
         WHERE절의 조건을 넣지않으면 모든행 삭제
*/

-- '지정보'사원을 삭제
DELETE FROM EMPLOYEE;

ROLLBACK;

DELETE FROM EMPLOYEE
WHERE EMP_NAME = '지정보';

ROLLBACK;

DELETE FROM EMPLOYEE
WHERE EMP_ID = 300;

-- JOB_CODE가 J1인 부서 삭제
DELETE FROM JOB
WHERE JOB_CODE = 'J1';
-- 제약조건에 위배되는 삭제는 안됨
----------------------------------------------------------
/*
    *TRUNCATE: 테이블의 전체 데이터를 삭제할 때 사용하는 구문 
               DELETE 보다 실행 속도가 빠르다. 
               별도의 조건 제시 불가 ,
               ROLLBACK불가 
    [표현식]
    TRUNCATE TABLE 테이블명; 
*/
TRUNCATE TABLE EMP_SALARY;
ROLLBACK; --롤백 안됨 

