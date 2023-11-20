/*
    <PL/SQL>
    PROCEDURAL LANGUAGE EXTENSTION TO SQL
    
    오라클 자체 내장 되어 있는 절차적 언어
    SQL 문장 내에서 변수의 정의, 조건처리(IF),반복처리(LOOP,FOR,WHILE)등을 지원하여 
    SQL단점 보안, 다수의 SQL문을 한번에 실행 가능(BLOCK구조)
    
    *PL/SQL 구조 
    -[선언부(DECLARE SECTION)] : DECLARE로시작, 변수나, 상수를 선언 및 초기화 하는 부분
    -실행부(EXECUTABLE SECTION): BEGIN으로 시작, SQL문 또는 제어문 (조건문, 반복문) 등의 로직을 기술하는 부분 
    -[예외 처리 부분 (EXCEPTION SECTION)] : EXCEPTION으로 시작, 
                        예외 발생시 해결하기 위한 구문을 미리 기술해 둘 수 있는 부분 
  
*/

--*★★★★화면에 오라클 출력 ( 껏다 다시 켜도 반드시 맨처음에 켜줘야 한다. )
SET SERVEROUTPUT ON; 

--HELLO ORACLE 출력
--자바: SYSTEM.OUT.PRINTLN("HELLO ORACLE");

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');
END;
/ 
--END도 해주고 / 슬래시도 넣어줘야한다. 

--------------------------------------------------------------
/*
    1.DECLARE (선언부)
    변수 및 사우 선언하는 공간(선언과 동시에 초기화도 가능)
    일반 타입 변수, 레퍼런스 타입 변수, ROW타입의 변수 
    
*/

/*

1.1 일반타입 변수 선언 및 초기화 
    [표현식] 변수명 [CONSTANT] 자료형[:=값];
    
*/
DECLARE  
    EID NUMBER;
    ENAME VARCAHR2(20);
    PI CONSTRAINT NUMBER := 3.14;
BEGIN 
    EID := 500;
    ENAME := '장남일';
    
    --SYSTEM.OUT.PRINTLN("EID: " + EID);
    DBMS_OUTPUT.PUT_LINE('EID: ' || EID);
    DBMS_OUTPUT.PUT_LINE('ENAME: '|| ENAME);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
    END;
    /
    
DECLARE
    EID NUMBER;
    ENAME VARCHAR2(20);
    PI CONSTANT NUMBER :=3.14;
BEGIN
    EID:=&번호;
    ENAME :='&이름';
    
    DBMS_OUTPUT.PUT_LINE('EID:' ||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME: ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('PI: ' || PI);
END;
/  
    --작동이 스캐너랑 똑같다. 



/*

1.2 레퍼런스타입 변수 선언 및 초기화 
    : 어떤 테이블의 어떤 컬럼의 데이터 타입을 참조해서 그 타입으로 지정
    [표현식] 변수명 테이블명. 컬럼명%TYPE; 
       
    
*/
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    EID := 300;
    ENAME:= '유재석';
    SAL :=3000000;
    
    DBMS_OUTPUT.PUT_LINE('EID :' ||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME :'||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여:'||SAL);
    END;
    /

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    --1.사번이 200번인 사원의 사번, 사원명, 급여 조회하여 변수에 저장 
    SELECT EMP_ID, EMP_NAME, SALARY
        INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID=200;
    
    DBMS_OUTPUT.PUT_LINE('EID :' ||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME :'||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여:'||SAL);
    END;
    /

--2.입력받아 검색하여 변수에 저장 
DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    
    SELECT EMP_ID, EMP_NAME, SALARY
        INTO EID, ENAME, SAL
    FROM EMPLOYEE
    WHERE EMP_ID=&사번;
    
    DBMS_OUTPUT.PUT_LINE('EID :' ||EID);
    DBMS_OUTPUT.PUT_LINE('ENAME :'||ENAME);
    DBMS_OUTPUT.PUT_LINE('급여:'||SAL);
    END;
    /




-------------------------실습문제------------------
/*

    레퍼런스타입 변수로 EID, ENAME, JCOD,SAL,DTITLE를 선언하고
    각 자료형 EMPLOYEE(EMP_ID, EMP_NAME, JOB_CODE, SALARY),
    DEPARTMENT(DEPT_TITLE)들을 참조하도록 
    
    사용자가 입력한 사번의 사번, 사원명, 직급코드, 급여,부서명, 조회 한 후
    각 변수에 담아 출력 
*/    
SET SERVEROUTPUT ON;

DECLARE 
        EID EMPLOYEE.EMP_ID%TYPE;
        ENAME EMPLOYEE.EMP_NAME%TYPE;
        JCOD EMPLOYEE.JOB_CODE%TYPE;
        SAL EMPLOYEE.SALARY%TYPE;
        DTITLE DEPARTMENT.DEPT_TITLE%TYPE; 
BEGIN
    SELECT EMP_ID, EMP_NAME,JOB_CODE, SALARY ,DEPT_TITLE
        INTO EID, ENAME, JCOD, SAL ,DTITLE
    FROM EMPLOYEE         
    JOIN DEPARTMENT ON(DEPT_ID=DEPT_CODE)  
    WHERE EMP_ID=&사번;
    DBMS_OUTPUT.PUT_LINE('사번: ' ||EID);
    DBMS_OUTPUT.PUT_LINE('사원명: ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('직급코드 : ' ||JCOD);
    DBMS_OUTPUT.PUT_LINE('급여 : ' ||SAL);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' || DTITLE);
  
    END;
    /








