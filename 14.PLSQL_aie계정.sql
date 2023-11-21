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

--★★★★화면에 오라클 출력 ( 껏다 다시 켜도 반드시 맨처음에 켜줘야 한다. )
SET SERVEROUTPUT ON; 
--★★★★★★★★★★★★★★★★★★★★★★★★

--HELLO ORACLE 출력
--자바: SYSTEM.OUT.PRINTLN("HELLO ORACLE");

BEGIN 
    DBMS_OUTPUT.PUT_LINE('HELLO ORACLE');  --외따옴표로
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
    [표현식] 변수명 [CONSTANT] 자료형[:=값]; 콜론을 찍어준다.
    
*/
DECLARE  
    EID NUMBER;
    ENAME VARCAHR2(20);
    PI CONSTRAINT NUMBER := 3.14;
BEGIN 
    EID := 500;
    ENAME := '장남일';
    
    -- 자바: SYSTEM.OUT.PRINTLN("EID: " + EID);
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
    EID:=&번호;  --사용자로부터 입력을 받을라면 앤드& 이거 쓰면 된다.
                --안쓰면 입력하세요가 나온다. 
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
        INTO EID, ENAME, SAL  --변수에 저장하려면INTO를 사용한다. 
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
    WHERE EMP_ID=&사번;  --사번을 받을 수 있다. 사번입력으로 
    
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
  
--DBMS_OUTPUT.PUT_LINE(EID||','||ENAME||',',||JCODE||','||SAL||','||DTITLE);
    END;
    /


/*
1.3 ROW 타입 변수 선언
    테이블의 한 행에 대한 모든 컬럼값을 한꺼번에 담을 수 있는 변수 
    
    [표현식]변수명 테이블명%ROWTYPE;
*/

DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
        INTO E 
        FROM EMPLOYEE
    WHERE EMP_ID= &사번;
         

    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    --DBMS_OUTPUT.PUT_LINE('보너스 : ' || E.BONUS);
    --DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,'없음'));
    --ORA-06502: PL/SQL: 수치 또는 값 오류: 문자를 숫자로 변환하는데 오류입니다
    --E에 받아 놓으면 컬럼 이름에 해당하는 타입과 같다, 
    --보너스는 NUMBER인데 '없음'이라는 문자라 오류가 난다.(타입불일치에러)
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0));
END; 
/





DECLARE
    E EMPLOYEE%ROWTYPE;
BEGIN
    --SELECT EMP_NAME, SALARY, BONUS
    --ORA-06550: 줄 6, 열9:PL/SQL: ORA-00913: 값의 수가 너무 많습니다
    --오류발생 여기는 아스트리크 *를 사용해야함.
    SELECT *
        INTO E 
        FROM EMPLOYEE
    WHERE EMP_ID= &사번;
     
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || E.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || E.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스 : ' || NVL(E.BONUS,0));
END; 
/

--------------------------------------------------------------
/*
    2.BEGIN 실행부
        <조건문>
        1) IF 조건식 THEN 실행내용 END IF; (단일 IF문)
     
*/

-- 사번 입력받은 후 해당 사원의 사번, 이름, 급여, 보너스율(%)출력
-- 단) 보너스를 받지 않는 사원은 보너스율 출력 전 '보너스를 지급받지 않은 사원입니다' 출력

DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
        INTO EID ,ENAME, SAL, BONUS
        FROM EMPLOYEE
    WHERE EMP_ID =&사번;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID );
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ENAME);
    DBMS_OUTPUT.PUT_LINE('급여 ' || SAL);
    DBMS_OUTPUT.PUT_LINE('보너스 ' || BONUS);
     IF BONUS =0
        THEN 
           DBMS_OUTPUT.PUT_LINE( '보너스를 지급받지 않은 사원입니다');
     END IF;
     
     DBMS_OUTPUT.PUT_LINE('보너스율:'||BONUS*100||'%');
     
  END;
/
    
/*
    2.BEGIN 실행부
        <조건문>
        2) IF 조건식 THEN 실행내용 ELSE 실행내용 END IF; (IF-ELSE문)
*/ 
 DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    BONUS EMPLOYEE.BONUS%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, SALARY, NVL(BONUS,0)
        INTO EID ,ENAME, SAL, BONUS
        FROM EMPLOYEE
    WHERE EMP_ID =&사번;
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EID);
                       -- '사원명 ' || ENAME,
                        --'급여' || SAL);
                        --'보너스' || BONUS);
     IF BONUS =0
        THEN 
           DBMS_OUTPUT.PUT_LINE( '보너스를 지급받지 않은 사원입니다');
     ELSE 
        DBMS_OUTPUT.PUT_LINE('보너스율:'||BONUS*100||'%');
     END IF;
     
     
  END;
/
 
        

/*
    레퍼런스 변수 : EID, ENAME, DTITLE, NCODE
    참조 컬럼 : EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    일반변수 : TEAM(소속)
    
    실행 :  사용자가 입력한 사번의 사번, 이름, 부서면, 근무국가코드를 변수에 대입
        단) NCODE 값이 K0일 경우 =>TEAM 변수에 '국내팀'
               NCODE 값이 K0가 아니면 =>TEAM 변수에 '해외팀'
           
    출력 : 사번, 이름, 부서명, 소속 출력 
    
*/
--ME: 밑에 교수님 비교하고 수정하기 
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE NATIONAL.NATIONAL_NAME%TYPE;
    --TEAM TEAM%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_NAME
        INTO EID,ENAME,DTITLE,NCODE
        FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
        JOIN LOCATION ON (LOCAL_CODE=LOCATION_ID)
        JOIN NATIONAL USING(NATIONAL_CODE)
    WHERE EMP_ID=&사번;
    DBMS_OUTPUT.PUT_LINE('사번 : ' ||EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' ||DTITLE);
    DBMS_OUTPUT.PUT_LINE('국가코드 : ' ||NCODE);
    --DBMS_OUTPUT.PUT_LINE('TEAM변수 : ' ||TEAM);
--    IF
--        NCODE=K0
--        THEN
--          TEAM :='국내팀';
--        ELSE
--          TEAM := '해외팀';
--    END IF;
    
    END;
/


--PROF
DECLARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    NCODE LOCATION.NATIONAL_CODE%TYPE;
    TEAM VARCHAR2(10);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
        INTO EID,ENAME,DTITLE,NCODE
        FROM EMPLOYEE
        JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
        JOIN LOCATION ON (LOCAL_CODE=LOCATION_ID)
        --JOIN NATIONAL USING(NATIONAL_CODE)
    WHERE EMP_ID=&사번;
    
    IF
        NCODE='KO'
        THEN
          TEAM :='국내팀';
        ELSE
          TEAM := '해외팀';
    END IF;
    DBMS_OUTPUT.PUT_LINE('사번 : ' ||EID);
    DBMS_OUTPUT.PUT_LINE('사원명 : ' ||ENAME);
    DBMS_OUTPUT.PUT_LINE('부서명 : ' ||DTITLE);
    DBMS_OUTPUT.PUT_LINE('국가코드 : ' ||NCODE);
    DBMS_OUTPUT.PUT_LINE('TEAM : ' ||TEAM);
    END;
/

--------------------------------------------------------------
/*
    3) IF-ELSE IF문
    IF 조건식 1
        THEN 실행내용1
    ELSIF 조건식2
        THEN 실행내용2
    ELSIF 조건식3
        THEN 실행내용3
    ELSE   
        실행내용4
    END IF;
*/
      
-- 사용자로부터 점수를 입력받아 점수와 학점을 출력
DECLARE 
    SCORE NUMBER;
    GRADE VARCHAR2(1);  --A,B,C,D,F, 이렇게만이라서 
BEGIN
    SCORE := &점수;
    IF SCORE >=90
        THEN GRADE :='A';
    ELSIF   SCORE>=80
        THEN GRADE :='B';
    ELSIF   SCORE>=70
        THEN GRADE :='C';
    ELSIF   SCORE>=60
        THEN GRADE :='D';
    ELSE
        GRADE :='F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('점수는 ' ||SCORE||'점이고, 학점은 '||GRADE|| '입니다');
    
END;
/
       

-------------------------실습문제------------------
/*
    사용자에게 입력받은 사번의 사원의 급여를 조회해서 SAL변수에 대입
    500만원 이상이면 '고급'
    500미만~300만원이상이면 '중급'
    300만원 미만이면 ' 초급'
    '해당 사원의 급여 등급은 XX입니다."
*/

DECLARE
    EID EMPLOYEE.EMP_ID%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
    GRADE VARCHAR2(20);  
--ORA-06502: PL/SQL: 수치 또는 값 오류: 문자열 버퍼가 너무 작습니다
--값을 너무 작게 넣어주면 안된다. 

BEGIN
    SELECT EMP_ID, SALARY
        INTO EID, SAL
        FROM EMPLOYEE
    WHERE EMP_ID = &사번;
    
    IF SAL >=5000000
        THEN GRADE := '고급';
    ELSIF 
        SAL >=3000000
        THEN GRADE := '중급';
    ELSE
        GRADE := '초급';
    END IF;
    DBMS_OUTPUT.PUT_LINE('해당 사원의 급여 등급은 ' || GRADE || '입니다.');
END;
/

/*
    4) CASE 비교대상자
        WHEN 비교할 값1 THEN 실행내용1
        WHEN 비교할 값2 THEN 실행내용2
        WHEN 비교할 값3 THEN 실행내용3
        ELSE 실행내용4
    END;
    
    SWITCH(변수) {    ->CASE 
        CASE? :       ->WHEN
           실행내용    ->THEN
        DEFAULT:      ->ELSE
    }
*/

DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR(30);
BEGIN
    SELECT *
        INTO EMP
        FROM EMPLOYEE
    WHERE EMP_ID=&사번;
    
    DNAME := CASE EMP.DEPT_CODE
        WHEN 'D1' THEN '인사관리부'
        WHEN 'D2' THEN '회계관리부'
        WHEN 'D3' THEN '마케팅부'
        WHEN 'D4' THEN '국내영업부'
        WHEN 'D8' THEN '기술지원부'
        WHEN 'D9' THEN '총무부'
        ELSE '해외영업부'
      END;
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_NAME || '는 ' ||
                           DNAME      || ' 입니다');
END;
/

--------------------------------------------------------------
/*
    <LOOP>
    1) BASIC LOOP문
    
    [표현식]
    LOOP
        반복적으로 실해할 구문;
        * 반복문을 빠져나갈수 있는 구문;
    END LOOP;
    
    *반복문을 빠져나갈 수 있는 조건문 2가지 
    1) IF 조건식 이용 
        IF 조건식 THEN EXIT; END IF;
    2) EXIT 
        EXIT WHEN 조건식; 
*/

--1부터 5까지 5번 반복하는 반복문 
-- 1) IF조건식 
DECLARE
    I NUMBER :=1;
BEGIN
    LOOP 
        DBMS_OUTPUT.PUT_LINE(I);
        I := I +1 ;  -- I++ 이런거 안된다.
        
        
        IF I=6
            THEN EXIT;
        END IF;
           
    END LOOP;  --잊어 버릴까봐 미리 써 넣어줘야 한다. 
END;  --잊어 버릴까봐 미리 써 넣어줘야 한다. 
/
-- 2) EXIT 로
DECLARE 
    I NUMBER :=1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I:=I+1;
        
        EXIT WHEN I=6;
    END LOOP;
END;
/

/*
    2) FOR LOOP문
     [표현식]
    FOR 변수 IN [REVERSE] 초기값.. 최종값
    LOOP
        반복적으로 실행할 구문;
    END LOOP; 
        
*/
    
BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;

END;
/  
    
BEGIN
    FOR I IN REVERSE 1..5  --거꾸로 출력하기
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;

END;
/      
    

DROP TABLE TEST;

DROP SEQUENCE SEQ_TEST;    
    
CREATE TABLE TEST(
    TNO NUMBER PRIMARY KEY,
    TDATE DATE 
);

CREATE SEQUENCE SEQ_TNO
INCREMENT BY 2;
    
BEGIN
    FOR I IN 1..100
    LOOP 
        INSERT INTO TEST VALUES(SEQ_TNO.NEXTVAL,SYSDATE);
    END LOOP;
END;
/
    
SELECT * FROM TEST;
    
--------------------------------------------------------------
/* 
    3)WHILE LOOP문
    
    [표현식]
    WHILE 반복문이 수행될 조건 
    LOOP
        반복적으로 실행할 구문;
    END LOOP;
*/

DECLARE
    I NUMBER :=1;
BEGIN
    WHILE I <6
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
        I := I+1;
       
    END LOOP; 
END;
/
---------------------------------------------------
/*
    3. 예외처리부
        예외(EXCEPTION) : 실행 중 발생하는 오류 
        
    [표현식]
    EXCEPTION
        WHEN 예외명1 THEN 예외처리 구문1; 
        WHEN 예외명2 THEN 예외처리 구문2; 
        WHEN OTHERS THEN 예외처리 구문;
                
    *시스템 예외 (오라클에서 미리 정의해둔 예외)
     -NO_DATA_FOUND : SELECT 한 결과 한 행도 없을 경우 
     -TOO_MANY_ROWS : SELECT 한 결과 여러행일 경우
     -ZERO_DIVIDE : 0으로 나누었을 경우 
     -DUP_VAL_ON_INDEX : UNIQUE 제약조건 위배 
     ... 
       
*/
--사용자가 입력한 수로 나눗셈 연산 
DECLARE
    RESULT NUMBER;
BEGIN
    RESULT := 10/&숫자;
    DBMS_OUTPUT.PUT_LINE('결과 : ' || RESULT);

    --ORA-01476: 제수가 0 입니다
    --ORA-06512:  4행
    --01476. 00000 -  "divisor is equal to zero"

    EXCEPTION  --오류 처리 
    --WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('0으로 나눌 수 없습니다.');
    
END;
/

--UNIQUE 제약조건 위배 
BEGIN
    UPDATE EMPLOYEE
        SET EMP_ID = '&변경할 사번' 
        -- = 이것과 같다
        -- := 조건
        WHERE EMP_NAME='김정보';
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN DBMS_OUTPUT.PUT_LINE('이미존재하는 사번입니다.');
     END;   
 /   
--사수 200번은 6명, 202하나도 없고, 201번은 1명
DELCARE 
    EID EMPLOYEE.EMP_ID%TYPE;
    ENAME EMPLOYEE.EMP_NAME%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME
     INTO EID, ENAME
     FORM EMPLOYEE
   WHERE MANAGER_ID=&사수번호;
   
   DBMS_OUTPUT.PUT_LINE('사번 : '||EID); 
   --사수 200번은 6명, 202하나도 없고, 201번은 1명
   --너무 많으면 너무 많아도 문제 
   DBMS_OUTPUT.PUT_LINE('이름 : '||ENAME);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN DBMS_OUTPUT.PUT_LINE ('조회된 행이 너무 많습니다.');
    WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE ('조회된 결과가 없습니다.');
    --WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE ('조회된 결과가 너무 많거나 하나도 없습니다')
END;
/
-----------------------연습문제----------------------------
/*
1. 사원의 연봉을 구하는  PL/SQL 불럭 작성, 보너스가 있는 사원은 보너스도 포함해서 계산
2. 구구단 짝수단 출력
    2-1) FOR LOOP
    2-2) WHILE LOOP 
*/

--1. PROF
DECLARE 
    E EMPLOYEE%ROWTYPE;
    YSAL NUMBER;
BEGIN
    SELECT * INTO E 
        FROM EMPLOYEE
    WHERE EMP_ID=&EMP_ID;
    
    IF E.BONUS IS NULL  
        THEN YSAL :=E.SALARY*12;
    ELSE
        YSAL :=E.SALARY*(1+E.BONUS)*12;
        --YSAL :=(E.SALARY + E.SALARY*E.BONUS)*12;
    END IF;
    DBMS_OUTPUT.PUT_LINE(E.EMP_NAME || '사원의 연봉은 ' || TO_CHAR(YSAL,'L999,999,999') || '입니다.');
END;
/
--2.ME
BEGIN 
    FOR I IN 2..9;
        FOR J IN 1..9;
         LOOP 
            DBMS_OUTPUT.PUT_LINE(I*J);
            J = J+1;
            IF J>9
             THEN I = I+1;
         END LOOP;
    END;
/
--2.PROF 
DECLARE
    RESULT NUMBER;
BEGIN 
    FOR DAN IN 2..9
    LOOP
        IF MOD(DAN,2)=0
            THEN
            FOR SU IN 1..9
            LOOP
                RESULT :=DAN * SU;
                DBMS_OUTPUT.PUT_LINE(DAN ||'*'||SU||'='||RESULT);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;        
 END;
/
  --2.PROF  다른 해결
BEGIN 
    FOR DAN IN 2..9
    LOOP
        IF MOD(DAN,2)=0
            THEN
            FOR SU IN 1..9
            LOOP
                DBMS_OUTPUT.PUT_LINE(DAN ||'*'||SU||'='||DAN * SU);
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
    END LOOP;        
 END;
/          



--2-2WHILE LOOP로 
--2-2 ME
BEGIN
    FOR I IN 2..9
    FOR J IN 1..9
    
    LOOP
        DBMS_OUTPUT.PUT_LINE(I*J);
        J:= J+1;
     
    END LOOP; 
END;
/  

DECLARE
    I NUMBER :=2;
    J NUMBER :=1;
BEGIN
    WHILE I <10
    LOOP
        IF J <10
            THEN DBMS_OUTPUT.PUT_LINE(I*J);
            J := J+1;
        ELSE    
            THEN I = I+1;
                 J=1;       
    END LOOP; 
END;
/
--2-2 PROF  (WHILE문) 
DECLARE
    DAN NUMBER :=2;
    SU NUMBER;
BEGIN 
    WHILE DAN <=9
    LOOP
        SU:=1;
       IF MOD(DAN,2)=0
            THEN
            WHILE SU <=9
            LOOP
                DBMS_OUTPUT.PUT_LINE(DAN ||'*'||SU||'='||DAN * SU);
                SU := SU +1;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('');
        END IF;
        DAN := DAN +1;
    END LOOP;        
 END;
/        

--짝수단만 
DECLARE
    DAN NUMBER :=2;
    SU NUMBER;
BEGIN 
    WHILE DAN <=9
    LOOP
        SU:=1;
        WHILE SU <=9
        LOOP
            DBMS_OUTPUT.PUT_LINE(DAN ||'*'||SU||'='||DAN * SU);
            SU := SU +1;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('');
        DAN := DAN +2;
    END LOOP;        
 END;
/        








