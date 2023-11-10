/*
    <함수>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환 
    
    - 단일행 함수 : N개의 값을 읽어들여 N개의 결과 값을 반환 (매 행마다 함수 실행) 
    - 그룹 함수 : N개의 값을 읽어들여 1개의 결과 값을 반환(그룹별로 함수를 실행)
    
    >>SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음 
    >>> 위에는 결과 값이 1개와 여러개가 나오기 때문에 같이 사용 못한다. 
    >>함수식을 기술할 수 있는 위치 : SELECT절, WHERE절, ORDER BY절, HAVNING절
    >>FROM, TABLE 절에는 안된다. 
*/

-----------------------단일 행 함수 ------------------------
--=========================================================

-----------------------문자 처리 함수 -----------------------
--=========================================================
/*
    LENGTH / LENGTHB => NUMBER로 반환
    
    LENGTH(컬럼|'문자열'): 해당 문자열의 글자수 반환 
    LENGTHB(컬럼|'문자열'): 해당 문자열의 BYTE수 반환
    - 한글 : XE버전일 때 => 1글자당 3BYTE(김, ㄱㄷㅏ 등도 다 1글자)
    - 한글 : EE버전일 때 => 1글자당 2BYTE
    - 그외 : 1글자당 1byte 
    
    & - 얘는 특수함 
    
*/

SELECT LENGTH('오라클'), LENGTHB('오라클')
FROM DUAL;  --DUAL이라는 오라클에서 제공하는 가상 테이블 

SELECT LENGTH('oracle'), LENGTHB('oracle')
FROM DUAL;

--보기 편하게 ||'글자' 적어주기
SELECT LENGTH('ㅇㅗㄹㅏ')|| '글자', LENGTHB('ㅇㅗㄹㅏ') ||'BYTE'
FROM DUAL;

SELECT EMP_NAME, LENGTH(EMP_NAME), LENGTHB(EMP_NAME),
       EMAIL,  LENGTH(EMAIL)||'글자' , LENGTHB(EMAIL)||'BYTE'
FROM EMPLOYEE;

------------------------------------------------------
/*
    INSTR: 문자열로부터 특정 문자의 시작위치 (INDEX)를 찾아서 반환(반환형:NUMBER)
    (중요- 오라클에서 index 번호는 1부터 시작, 찾는 문자가 없으면 0반환
    (중요) INSTR(컬럼|'문자열','찾을 문자열',[찾을 위치의 시작 값,[순번])
    
    찾을위치의 시작 값 [순번]에 들어갈 값, EX) 순번은 몇번째 A를 3번째 찾기
    1: 앞에서 부터 찾기(기본값)
    -1: 뒤에서 부터 찾기 
    
*/
          --
SELECT INSTR('JAVASCRIPTJAVAORACLE','A')FROM DUAL;  -- 결과값 2
SELECT INSTR('JAVASCRIPTJAVAORACLE','A',1)FROM DUAL; -- 결과:2
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', -1)FROM DUAL; --결과:17 
                --뒤에서 부터 검색, 인덱스 번호는 앞에서 부터 
SELECT INSTR('JAVASCRIPTJAVAORACLE','A', 1,3)FROM DUAL; --12 
                 -- 순번을 넣어줘야 앞에서 부터 뒤에서 정확히 나옴 

SELECT INSTR('JAVASCRIPTJAVAORACLE','A', -1,2)FROM DUAL; --결과:14

SELECT EMAIL, INSTR(EMAIL, '_', 1,1) "_위치", INSTR(EMAIL, '@') "@위치"
FROM EMPLOYEE;
--1,1 쓰지 않아도 맨처음 값이 나온다. 


------------------------------------------------------
/*
  SUBSTR : 문자열에서 내가 특정 문자열을 추출해서 반환하기 (CHARACTER)
          (반환형) 캐릭터 
  SUBSTR(컬럼|'문자열', POSITION, [LENGTH])
  - POSITION: 문자열을 추출할 시작 위치 INDEX번호 
  -  LENGTH :  추출할 문자 개수(생략시 맨 마지막 까지 추출)
  -자바 서브 스트링과 비슷
   
*/

SELECT SUBSTR('ORACLEHTMLCSS',7) FROM DUAL; --결과 : HTMLCSS
SELECT SUBSTR('ORACLEHTMLCSS',7,4) FROM DUAL; --결과 : HTML
SELECT SUBSTR('ORACLEHTMLCSS',1,6) FROM DUAL; --결과 : ORACLE
SELECT SUBSTR('ORACLEHTMLCSS',-7,4) FROM DUAL; --결과 : HTML
--(INDEX가 음수이면 뒤에서부터 INDEX번호를 쓴다 

--주민번호에서 성별만 추출하여 사원명,주민번호, 성별을 조회 
SELECT EMP_NAME, EMP_NO,SUBSTR(EMP_NO,8,1) "성별" 
FROM EMPLOYEE;

--여자사원들만 사번, 사원명, 성별을 조회 
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)='2' OR SUBSTR(EMP_NO,8,1)='4';

--남자사원들만 사번, 사원명, 성별을 조회 
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN(1,3);

--사원명, 이메일, 아이디(@표시 앞까지만) 조회 
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1,INSTR(EMAIL,'@',1,1)-1)
FROM EMPLOYEE;

---------------------------------------------------------

/*
 LPAD/RPAD : 문자열을 조회할 때 통일감 있게 조회하고자 할때 (CHARACTER:반환형)
 sssssssssssssssssss
 LPAD/RPAD('문자열', 최종적으로 반환할 문자의 길이,[덧붙이고자하는문자])
 문자열에 덧붙이고자 하는 문자를 왼쪽 혹은 오른쪽에 덧붙여서 최종길이만큼
 문자열 반환 

*/

--20길이 만큼 EMAIL을 출력하고자 할 때 오른쪽 정렬로 출력(왼쪽으로 공백으로채워서출력)
SELECT EMP_NAME, LPAD(EMAIL,20)
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL,20,'#')
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL,20,'*')
FROM EMPLOYEE;

--사번, 사원명, 주민번호 출력(123456-7******)
SELECT EMP_ID, EMP_NAME, RPAD(sSUBSTR(EMP_NO,1,8),14,'*')
FROM EMPLOYEE;
---------------------------------------------------------
SELECT EMP_ID, EMP_NAME, substr(emp_no,1,80|| "*******")
FROM EMPLOYEE;

------------------------------------------------------------
/*
  LTRIM / RTRIM 문자열에서 특정 문자를 제거한 나머지 문자  반환(CHARCTER:반환형)
   TRIM 문자열의 앞/뒤 양쪽에 있는 지정한 문자를 제거한 나머지 문자 반환 
   
   [표현법]
   LTRIM / RTRIM '문자열', [제시하고자 하는 문자열])
   TRIM /([LEADING|TRAILING\BOTH] 제거하고자 하는 문자열 FROM '문자열'
                         생략하면 

*/
SELECT LTRIM('Ri' ||" '애드인에듀') from dual -- 제거하고자 하는 문자열 
SELECCT LTRIM('JAVAJAVASCRIPTSPRING','JAVA'  )FROM DUAL;
SELECT LTRIM(",",0.12341231431231434,1012344565) FROM DUAL;
SELECT LTRIM('Ri' 0s||" '애드인에듀' ) FROM DUAL;
SELECT RTRIM('738319')FROM DUAL;

--TRIM은 기본적으로 양쪽 모두 문자를(기본값: 공백) 제거 
SELECT TRIM('  A  E  ') || '애드인에듀' FROM DUAL; --TRIM 양쪽모두 공뱆ㄱ제거
SELECT TRIM('A' FROM 'AAAABDKD342AAAA') FROM DUAL;

--LEADING: 앞의 문자 제거 
SELECT TRIM(LEADING 'A' FROM 'AAAAKDJDIAAA') FROM DUAL;
--TRAILING : 뒤의 문자 제거 
SELECT TRIM(TRAILING 'A' FROM 'AAAAKDJDIAAA') FROM DUAL;
--BOTH : 양쪽 앞과 뒤 제거 => 기본값: 생략 가능 
SELECT TRIM(BOTH 'A' FROM 'AAAAKDJDIAAA') FROM DUAL;

---------------------------------------------------------------
/*
LOWER / UPPER / INITCAP : 문자열을 대문자 혹은 소문자 단어의 앞글자만 대문자로 변환
   [표현법]
LOWER / UPPER / INITCAP('영문자열') 
*/
SELECT LOWER('Java JavaScript Oracle') FROM DUAL;
SELECT UPPER('Java JavaScript Oracle') FROM DUAL;
SELECT INITCAP('Java JavaScript oRacle') FROM DUAL; --앞글자만 대문자 

/*
  CONCAT : 문자열 두개를 하나로 합친 결과 반환 
  
  [표현법]
  CONCAT('문자열','문자열')
  
*/
SELECT CONCAT('ORACLE','(오라클)')FROM DUAL;
SELECT 'ORACLE'||'(오라클)'FROM DUAL;   --위 아래가 같다 
--인수의 개수가 부적합(2개만 가능)
SELECT CONCAT('ORACLE','(오라클)','02-313-0470')FROM DUAL; 
-- 3개이상도 가능 
SELECT 'ORACLE'||'(오라클)'||'02-313-0470' FROM DUAL; 

---------------------------------------------------------------
/*
   REPLACE : 기존문자열을 새로운 문자열로 바꿈 
   [표현법]
   REPLACE('문자열','기존문자열','바꿀문자열')
   
*/
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'kh.or.kr','aie.or.kr')
FROM EMPLOYEE; 
















---------------------------------------------------------------













