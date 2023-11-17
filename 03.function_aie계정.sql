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
    - 한글 : EE버전일 때 => 1글자당 2BYTE  EE버전은 유료버전 
    - 그외 : 1글자당 1byte 
    -
    
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
    프로그래밍과 다르다, 자바는 0부터 인덱스 시작 
    (중요) INSTR(컬럼|'문자열','찾을 문자열',[찾을 위치의 시작 값,[순번])
    - 순번: 앞에서부터는 1, 뒤에서 부터는 -1이라고 
    
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
-- -7이면 뒤에서부터 7번째 6,5,4번째 추출 
--(INDEX가 음수이면 뒤에서부터 INDEX번호를 쓴다 

--주민번호에서 성별만 추출하여 사원명,주민번호, 성별을 조회 
SELECT EMP_NAME, EMP_NO,SUBSTR(EMP_NO,8,1) "성별" 
--인덱스 번호 8번째
FROM EMPLOYEE;

--여자사원들만 사번, 사원명, 성별을 조회 
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)='2' OR SUBSTR(EMP_NO,8,1)='4';


--남자사원들만 사번, 사원명, 성별을 조회 
SELECT EMP_ID, EMP_NAME, SUBSTR(EMP_NO,8,1) 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN(1,3);
--목록으로 표현  이 목록중 하나이면 IN이 더 짧기 때문에 보통IN을 사용

--사원명, 이메일, 아이디(@표시 앞까지만) 조회 
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1,INSTR(EMAIL,'@',1,1)-1)
--인덱스번호 1부터 앳 제외하고 그 앞에 까지니까 -1을 해준다.
--@의 인댁스 번호를 ABC@ 니까 4-1=3으로 표현한다ㅏ. 
FROM EMPLOYEE;

---------------------------------------------------------

/*
 LPAD/RPAD : 문자열을 조회할 때 통일감 있게 조회하고자 할때 (CHARACTER:반환형)
 
 LPAD/RPAD('문자열', 최종적으로 반환할 문자의 길이,[덧붙이고자하는문자])
 문자열에 덧붙이고자 하는 문자를 왼쪽 혹은 오른쪽에 덧붙여서 최종길이만큼
 문자열 반환 
 문자 딱 맞춰서 출력 하고 싶을 때 사용한다. 덧붙이고자 안넣으면 공백으로 표현
*/

--20길이 만큼 EMAIL을 출력하고자 할 때 오른쪽 정렬로 출력(왼쪽으로 공백으로채워서출력)
SELECT EMP_NAME, LPAD(EMAIL,20)  -- 공백10개 이메일 10개 이런식으로 표현한다
FROM EMPLOYEE;

SELECT EMP_NAME, LPAD(EMAIL,20,'#')  -- 샾으로 공백을 대체한다. 
FROM EMPLOYEE;

SELECT EMP_NAME, RPAD(EMAIL,20,'*')  
FROM EMPLOYEE;

--사번, 사원명, 주민번호 출력(123456-7******)
SELECT EMP_ID, EMP_NAME, RPAD(SUBSTR(EMP_NO,1,8),14,'*')
--SUBSTR로 8개 갖고오기, 7까지 추출, 즉,14개 중에서 앞에 8개는 추출해서 가져오고, 나머지는 별표시
FROM EMPLOYEE;
---------------------------------------------------------
SELECT EMP_ID, EMP_NAME, SUBSTR(emp_no,1,8)|| '*******'
--더 간단하게 8자리 갖고와서 나머지는 별 찍기 
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
SELECT LTRIM(   'Ri' || '애드인에듀') from dual; -- 제거하고자 하는 문자열 
--왼쪽 공백만 제거 
SELECT LTRIM('JAVAJAVASCRIPTJAVASPRING','JAVA'  )FROM DUAL;
--왼쪽 자바만 제거, 가은데 낀 자바는 제거하지 못한다. 
SELECT LTRIM(  'Ri'  || '애드인에듀' ) FROM DUAL;
SELECT LTRIM('738319ASDASDASD','0123456789')FROM DUAL;
--왼쪽 숫자 제거하기 , 뒤에 0123456789입력

--TRIM은 기본적으로 양쪽 모두 문자를(기본값: 공백) 제거 
SELECT TRIM('  A  E  ') || '애드인에듀' FROM DUAL; --TRIM 양쪽모두 공뱆ㄱ제거
--앞뒤 공백제거만 한다. 
SELECT TRIM('A' FROM 'AAAABDKD342AAAA') FROM DUAL;
--LTRIM, RTRIM과 다르게 제거하고자 하는 문자열이 앞으로 나온다.


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
-- 3개이상도 가능, OR을 사용하면 더 편하다. 
SELECT 'ORACLE'||'(오라클)'||'02-313-0470' FROM DUAL; 

---------------------------------------------------------------
/*
   REPLACE : 기존문자열을 새로운 문자열로 바꿈 
   [표현법]
   REPLACE('문자열','기존문자열','바꿀문자열')
   
*/
SELECT EMP_NAME, EMAIL, REPLACE(EMAIL, 'kh.or.kr','aie.or.kr')
FROM EMPLOYEE; 

--=========================================================
-----------------------숫자 처리 함수 -----------------------
--=========================================================

/*
   ABS : 절대값을 구하는 함수 
   
   [표현법]
   ABS(NUMBER)
*/
SELECT ABS(-10) FROM DUAL;
SELECT ABS(-3.1415) FROM DUAL;

----------------------------------------------------------
/*
  MOD : 두 수를 나눈 나머지값 반환 
  [표현법]
  MOD(NUMBER, NUMBER)주민번호 앞자리와 뒷자리의 합 조회
*/
SELECT MOD(10,3) FROM DUAL;
SELECT MOD(10.9 , 2) FROM DUAL; --(중요) 추천하지 않는 방법 , 비추천

----------------------------------------------------------
/*
  ROUND : 반올림 ,위치를 넣지 않으면 0이된다. 
  [표현법]
  ROUND(NUMBER,[위치]) 

*/
SELECT ROUND(1234.56)FROM DUAL; -- 위치생략시 0 / 정수로 반올림해서 1235 출력 
SELECT ROUND(12.34)FROM DUAL;
SELECT ROUND(1234.5678,2)FROM DUAL; -- 소숫점 둘째자리까지 표시 1234.57로 표현
SELECT ROUND(1234.56,4) FROM DUAL;  -- 숫자 자체가 둘째자리 까지만 있어서 소용 없다. 
SELECT ROUND(1234.56,-2) FROM DUAL;  --1200으로  -2 십의 자리에서 반올림 

----------------------------------------------------------
/*
    CEIL : 올림한 결과 반환
             !!!!주의 - 마이너스일때 조심!!! 
    
    [표현법]
    CEIL(NUMBER)
*/
SELECT CEIL(123.456) FROM DUAL;   --일의자리수 까지 표현
SELECT CEIL(-123.456) FROM DUAL;   

----------------------------------------------------------
/*
    FLOOR : 무조건 내림 내림한 결과 반환 
    
    [표현법]
    FLOOR(NUMBER)
*/   
SELECT FLOOR(123.456) FROM DUAL;   --일의자리수 까지 표현
SELECT FLOOR(-123.456) FROM DUAL;    
----------------------------------------------------------
/*
    TRUNC : 위치 지정가능한 버림 처리 함수 
    
    [표현법]
    TRUNC(NUMBER,[위치])
*/   
SELECT TRUNC(123.456) FROM DUAL;   --일의자리수 까지 표현
SELECT TRUNC(-123.456546,-1)FROM DUAL;

SELECT TRUNC(-123.456234) FROM DUAL; 
SELECT TRUNC(-123.456234,-2) FROM DUAL; --무조건 버림 
SELECT TRUNC(-123.456234) FROM DUAL;

--=========================================================
-----------------------날짜 처리 함수 -----------------------
--=========================================================
----------------------------------------------------------
/*
    SYSDATE : 시스템 날짜와 시간 반환 
*/
SELECT SYSDATE FROM DUAL; 

----------------------------------------------------------
/*
    MONTHS_BETWEEN(DATE1, DATE2) 두 날짜 사이에 개월수 반환 
    찾아서 쓸 수 있을 정도..
*/

--소수점 이하 자리 까지 나온다. ceil 붙여서 근무일수로 바꾼다. 
SELECT EMP_NAME , HIRE_DATE, CEIl(SYSDATE-HIRE_DATE) "근무일수"
FROM EMPLOYEE;
-- 넣을 때는 시분초가 다 0으로 들어가는데 오늘 시간이 초까지 들어가므로 계산결과가 소숫점으로 표시된다
-- 따라서 CEIL로 올림을 한다. 

--소수점 이하 자리 까지 나온다. ceil 붙여서 근무개월수로 바꾼다.
SELECT EMP_NAME , HIRE_DATE, CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)) || '개월차' "근무개월수"
FROM EMPLOYEE;
--함수 매개변수는 컴마 

--CONCAT으로 연결하기 
SELECT EMP_NAME , HIRE_DATE, CONCAT(CEIL(MONTHS_BETWEEN(SYSDATE,HIRE_DATE)) , '개월차') "근무개월수"
FROM EMPLOYEE;

----------------------------------------------------------
/*
    ADD_MONTHS(DATE, NUMBER) : 특정날짜에 해당 숫자만큼의 개월수를 더해 그 날짜를 반환 
*/

SELECT ADD_MONTH(SYSDATE,1)FROM DUAL; 
--오늘 날짜에 1개월 후 

--★★★ 개월수 더하기 
--사원명, 입사일, 입사후 정직원이 된 날짜(6개월 후) 조회
SELECT EMP_NAME, HIRE_DATE, ADD_MONTHS(HIRE_DATE ,6) "정직원이된 날짜"
FROM EMPLOYEE;
----------------------------------------------------------
/*
    NEXT_DAY(DATE, 요일(문자|숫자)): 특정 날짜 이후에 가까운 해당 요일의 날짜 반환
    
*/
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월요일') FROM DUAL;
--오늘을 기준으로 다음주 월요일이니까 11.20
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월') FROM DUAL; --결과 값은 동일

--1부터 : 일요일,월,화
SELECT SYSDATE, NEXT_DAY(SYSDATE, 1) FROM DUAL; 
--SELECT SYSDATE, NEXT_DAY(SYSDATE, monday) FROM DUAL; 언어가 한글이라 영어는 오류남
-- 영어로 쓰고 싶다면 Alter
ALTER SESSION SET NLS_LANGUAGE=AMERICAN;  --세션변경으로 언어변환
SELECT SYSDATE, NEXT_DAY(SYSDATE, 'monday') FROM DUAL;
SELECT SYSDATE, NEXT_DAY(SYSDATE, '월') FROM DUAL;
ALTER SESSION SET NLS_LANGUAGE=KOREAN;  --한국어로 변경 "세션이 변경되었습니다."
----------------------------------------------------------
/*
    LAST_DAY(DATE) : 해당 월의 마지막 일자의 날짜 반환 
*/
SELECT LAST_DAY(SYSDATE)FROM DUAL;

--사원명, 입사일, 입사한 달의 마지막 날짜를 조회 
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE)
FROM EMPLOYEE;
--사원명, 입사일, 입사한 달의 마지막 날짜, 입사한 달의 근무일수 조회 
SELECT EMP_NAME, HIRE_DATE, LAST_DAY(HIRE_DATE),LAST_DAY(HIRE_DATE)-HIRE_DATE+1
FROM EMPLOYEE;
----------------------------------------------------------
/*
    EXTRACT : 특정 날짜로부터 년,월, 일 값을 추출하여 반환하는 함수
    (NUMBER:반환형)

    [표현법]
    EXTRACT(YEAR FROM DATE); 년도만 추출 
    EXTRACT(MONTH FROM DATE); 월만 추출
    EXTRACT(DAY FROM DATE); 일만 추출
*/

--사원명, 입사년도, 입사월, 입사일 조회 
SELECT EMP_NAME,
       EXTRACT(YEAR FROM HIRE_DATE) 입사년도, 
       EXTRACT(MONTH FROM HIRE_DATE) 입사월,
       EXTRACT(DAY FROM HIRE_DATE) 입사일
FROM EMPLOYEE
ORDER BY 입사년도, 입사월, 입사일;
--=========================================================
----★★★★★----형 변환 함수 ----------------------
--=========================================================
----------------------------------------------------------
/*
    TO_CHAR : 숫자 또는 날짜의 값을 문자타입으로 변환 
    
    [표현법]
    TO_CHAR(숫자|날짜, [포맷])
          포맷 : 반환결과를 특정형식에 맞게 출력하도록 함 
*/

----------------------------숫자 => 문자 ------------------------------
/*
    9 : 해당자리의 숫자를 의미 
        -값이 없을 경우 소수점 이상은 공백. 소수점 이하는 0으로 표시
    0 : 해당 자리의 숫자를 의미 
     - 값이 없을 경우 0표시, 숫자의 길이를 고정적으로 표시할 때 주로 사용 
    FM: 좌우 9로 치환된 소수점 이상의 공백 및 소수점 이하의 0을 제거 
        -해당 자리에 값이 없을 경우 자리차지 하지 않음 
        (9-위의 설명과 같음
        (0-위의 설명과 같음 

*/
SELECT TO_CHAR(1234) FROM DUAL;  
--숫자나 문자 똑같이 보임 , 그러나  왼족정렬은 문자, 오른쪽 정렬은 숫자
SELECT TO_CHAR(1234,'999999')자리 FROM DUAL;
--(9가6개)6자리를 차지하고 앞에 2자리가 없으니 앞에 2자리가 공백임 

SELECT TO_CHAR(1234,'000000')자리 FROM DUAL; 
--6자리 공간 차지, 왼쪽 정렬, 앞에 2자리 빈칸을 0으로 

SELECT TO_CHAR(1234,'L9999999')자리 FROM DUAL;
--L은 로컬, 설정된 나라의 화폐단위, 왼쪽보다 큰 단위를 오른쪽에 넣어준다.
SELECT TO_CHAR(1234,'$99999')자리 FROM DUAL;--$는 문자의 의미 

SELECT TO_CHAR(123456789,'$999,999,999')자리 FROM DUAL;
--자릿수 맞춰서 콤마 찍어줘야 한다. 
SELECT TO_CHAR(123456789,'L999,999,999,999')자리 FROM DUAL;

--★★★★★★★★★★★★★★★★★★★★★★★★★★
-- 사번, 이름, 급여(\11,111,111), 연봉(|123.232.232)조회
--연봉 급여 중요함. 표시하는것 중요 
SELECT EMP_ID, EMP_NAME, 
     TO_CHAR(SALARY,'L999,999,999,999')급여,
     TO_CHAR(SALARY*12, 'L999,999,999,999') 연봉
FROM EMPLOYEE;

--FM
SELECT TO_CHAR(123.456, 'FM99990.99999'), 
    --자리차지하지 않고 나옴, 끝에 0이면 값이 없어도 출력하시오, 
    --9는 있으면 출력 없으면 출력 ㄴㄴ 
       TO_CHAR(1234.56, 'FM9990.99'),
       TO_CHAR(0.1000, 'FM9990.999'), 
    --한자리는 무조건 나와야 된다.
    --뒤에 세자리는 없으면 출력하지 마시오 
    --0.1만 나옴, 
       TO_CHAR(0.1000, 'FM9990.00'), 
    -- 없어도 소수점 이하 2자리 나와야 한다.
    -- 소수점 2자리 까지는 나와야 한다. 
       TO_CHAR(0.1000, 'FM9999.999') --9는 0이 안나옴 안채워줌 
    FROM DUAL;
    
--FM 안 붙은 것 : 자리차리 하냐 안하냐 차이,  0을 넣으면 0으로 채워지냐 없으면 안나옴 
SELECT TO_CHAR(123.456, '99990.999'), 
       --자리차지하지 않고 나옴 , 2자리만큼 공백 만들고 나옴 
       TO_CHAR(1234.56, '9990.99'), --보통 사용하는 형식 (소숫점 몇째 자리, 일의 자리 0)
       TO_CHAR(1234.56, '9990.00'), -- 보통형식
       TO_CHAR(0.1000, '9990.999'), --세자리 자리차지.
       TO_CHAR(0.1, '9990.000'), -- 없어도 소수점 이하 3자리 나와야 한다.
       TO_CHAR(0.1000, '9999.999') --9는 0이 안나옴 안채워줌 
       
       --소수점 이하는 자리차리는 한다. 
       --0.100과 같이 소수점이하 자리 까지 나온다.
    FROM DUAL;

----------------------------문자 =>숫자-----------------------------
--시간 
SELECT TO_CHAR(SYSDATE, 'AM HH:MI;SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'AM HH:MI;SS')  FROM DUAL;

--HH24 24시간제 ㅍ시 

--날짜
ALTER SESESSION SEL NLS_LANGUAGE = KOREAN;
SELECT TO CHAR(SYSDATE, 'YYYY-MM-DD') FROM DUAL;
--SELECT TO CHAR(SYSDATE, 'DL') FROM DUAL;
--SELECT TO_CHAR(SYSDATE, '"YYYY년" "MM"월 "DD일"DAY') FORM DUAL;

사원명 일사일23-0202, 입사일 (2023,2,2 금요일)조회 
SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YY-MM-DD') 입사일, TO_CHAR(HIRE_DATE, 'DL')입사년월일요일
FROM EMPLOYEE; 

SELECT EMP_NAME, TO_CHAR(HIRE_DATE, 'YY-MM-DD') 입사일, 
       TO_CHAR(HIRE_DATE, 'YYYY"년 "MM"월 "DD"일"DAY')입사년월일요일
       --그냥 따옴표 YYYY, 쌍따옴표 년,월,일 표시 

FROM EMPLOYEE; 

--년도
/*
  YY:무조건 앞에 '20'이 붙는다
  RR:절반으로 나누어서( 50년을 기준으로 50보다 작으면 앞에 '20' 붙이고
     50보다 크면 앞에 '19'를 붙인다. 
     60이면 1960년 77 이면 1977 
*/
SELECT TO_CHAR(SYSDATE,'YYYY'),
      TO_CHAR(SYSDATE,'YY'),
      TO_CHAR(SYSDATE,'RRRR'),
      TO_CHAR(SYSDATE,'YEAR')
    FROM DUAL;

SELECT TO_CHAR(HIRE_DATE,'YYYY')
      ,TO_CHAR(HIRE_DATE, 'RRRR')
      ,TO_CHAR(HIRE_DATE, 'RR') --뒤에 자르고 표시 
      ,TO_CHAR(HIRE_DATE, 'CC') --세기 표시 20세기 21세기
FROM EMPLOYEE;
--입력데이터가 그대로라 RRRR 해도 그대로 나온다 

--월 
SELECT TO_CHAR(SYSDATE,'MM'),
       TO_CHAR(SYSDATE, 'MON'),
       TO_CHAR(SYSDATE, 'MONTH'),
       TO_CHAR(SYSDATE, 'RM')  --로마기호
    FROM DUAL;

--일 
SELECT TO_CHAR(SYSDATE, 'DD'),   --월 기준으로 몇일 째 
       TO_CHAR(SYSDATE, 'DDD'),  --년도를 기준으로 몇일 째 
       TO_CHAR(SYSDATE, 'D')   --주 기준(일요일)으로 몇일째 
    FROM DUAL;

--요일에 대한 포맷
SELECT TO_CHAR(SYSDATE, 'DAY'),
       TO_CHAR(SYSDATE, 'DY')
    FROM DUAL;

----------------------------------------------------------
/*
    TO_DATE : 숫자 또는 문자 타입을 날짜타입으로 변환 
    
    [표현법]
    TO_DATE(숫자|문자,[포맷])
    
*/
SELECT TO_DATE(20231110) FROM DUAL; 
SELECT TO_DATE(231110) FROM DUAL; 

--SELECT TO_DATE(011110) FROM DUAL;  
/* 위에 에러 ---오류:숫자 형태로 넣을때 0일때 오류
ORA-01861: 리터럴이 형식 문자열과 일치하지 않음
01861. 00000 -  "literal does not match format string"
*/

SELECT TO_DATE('011110') FROM DUAL;  SELECT TO_DATE(011110) FROM DUAL;

SELECT TO_CHAR(TO_DATE('070407 020830', 'YYMMDDHHMISS'),'YY-MM-DD HH:MI:SS') FROM DUAL;
SELECT TO_CHAR(TO_DATE('070407 020830', 'YYMMDDHHMISS')) FROM DUAL; --년월일만 출력

SELECT TO_DATE('041110','YYMMDD'),  TO_DATE('041110','RRMMDD')FROM DUAL;



SELECT TO_DATE('20041110','YYYYMMDD'),  TO_DATE('981110','YYMMDD')FROM DUAL;
--YY는 앞에 무조건 '20'이 붙는다. 
SELECT TO_DATE('20041110','RRRRMMDD'),  TO_DATE('981110','RRMMDD')FROM DUAL;
--RR이 기본 값으로 표현된다.  위에와 차이 점이 있다. 



SELECT TO_DATE('981110','RRMMDD'), 
      TO_DATE('981110','YYMMDD')FROM DUAL;
--98년을 출력시 RR과 YY의 출력범위가 다름 
----------------------------------------------------------
/*
    TO_NUMBER : 문자타입을 숫자 타입으로 변경 
    
    TO_NUMBER (문자, [포맷])
*/

SELECT TO_NUMBER('0212341234')FROM DUAL; 
SELECT '1000'+'5500' FROM DUAL; 
--데이터베이스에서는 연산기호가 있으면 붙어있어도 계산해줌 
--자바는 문자처리 해서 10005500이런식으로 출력됨 

--SELECT '1,000'+'5,500' FROM DUAL; 
--콤마 있으면 오류처리 된다. 

SELECT TO_NUMBER('1,000','9,999,999') FROM DUAL; 

SELECT TO_NUMBER('1,000','9,999,999') + TO_NUMBER('1,000,000','9,999,999')FROM DUAL; 
-연산 처리한다. 

--=========================================================
-----------------------<NULL 처리 함수>-----------------------
--=========================================================

/*
★★★★★★★★★★★★★★★★★★★★★★★★★★★★★
 NVL(컬럼, 해당컬럼이 NULL일 경우 반환될 값) 
*/

SELECT EMP_NAME, NVL(BONUS, 0) --보통 숫자는 0으로 대체 
FROM EMPLOYEE; 

--사원명, 보너스포함한 연봉 조회
SELECT EMP_NAME, (SALARY*BONUS+SALARY)*12
--SELECT EMP_NAME (SALARY*(1+BONUS))*12
FROM EMPLOYEE; 

SELECT EMP_NAME, SALARY*(1+NVL(BONUS,0))*12
FROM EMPLOYEE; 

SELECT EMP_NAME, NVL(DEPT_CODE,'부서 없음')
FROM EMPLOYEE; 

----------------------------------------------------------
/*
  NVL2(컬럼, 반환값1, 반환값2)
  - 컬럼값이 존재할 경우 반환값 1
  - 컬럼값이 NULL일때 반환값 2 
*/
--보너스를 받는 사람은 50%의 성과급을, 보너스를 받지 않는 사람은 10%의 성과급을 준다.
SELECT EMP_NAME, SALARY, BONUS, SALARY*NVL2(BONUS, 0.5, 0.1) AS 성과급
FROM EMPLOYEE;

SELECT EMP_NAME, SALARY, NVL2(DEPT_CODE, '부서있음', '부서없음') AS 부서유무
FROM EMPLOYEE;

----------------------------------------------------------
/*
    NULLIF(비교대상1, 비교대상2)
    -두개의 값이 일치하면 NULL반환
    -두개의 값이 일치하지 않으면 비교대강1을 반환 
    
*/

SELECT NULLIF('1234','1234')FROM DUAL;
SELECT NULLIF('1234','5678')FROM DUAL;

--=========================================================
-----------------------<선택 함수>-----------------------
--=========================================================
/*   CASE와 DECODE의 차이점이 있다면 
    DECODE함수는 조건 일치     하는 경우에만 적용 
    CASE 함수는 범위 지정 할 수 있음 IF ELSE IF ELSE 와 비슷 
  
    DECODE(비교하고자 하는 대상(컬럼|산술연산|함수식), 
           비교값1,결과값1, 비교값2, 결과값2...)
        
    
    SWITCH(비교대상){
        CASE 비교값1:
        결과값1;
        CASE 비교값2:
        결과값2;
        ...
        
    }
*/

--사원명, 성별
SELECT EMP_NAME, DECODE(SUBSTR(EMP_NO,8,1),'1'OR'3','남자','2'OR '4','여자') 성별
FROM EMPLOYEE;

--직원의 급여를 직급별로 인상해서 조회
--J5이면 급여의 20% 인상
--J6이면 급여의 15% 인상
--J7이면 급여의 10% 인상
-- 그외이면 급여의 5% 인상

--사원명, 직급코드, 기존급여, 인상된 급여 

SELECT EMP_NAME, JOB_CODE, SALARY 기존급여 --여기서 인상된 급여 안만들어줘도 된다.
    ,DECODE (JOB_CODE,'J5', SALARY*1.2,
                      'J6', SALARY*1.15,
                      'J7', SALARY*1.1,
                            SALARY*1.05) AS 인상된급여
                            --1.05는 마지막에 디폴트 값으로 보여준다.
FROM EMPLOYEE;

--SWITCH(JOB_CODE){
--        CASE 'J5':
--        RAISE_MONEY = SALARY*1.1
--        CASE J6: 
--        RAISE_MONEY = SALARY*1.15
--        OTHER :
--        RAISE_MONEY = SALARY*1.05}



----------------------------------------------------------
/*  CASE 표현식 
    CASE WHEN THEN 
    END
    CASE WHEN 조건식1 THEN 결과값1
         WHEN 조건식2 THEN 결과값 2 
         ...
         ELSE 결과값 N
    END 
 */     
--사원명, 급여가 5백만원 이상이면 '고급' , 350만원 이상이면 '중급', 나머지는 '초급'

SELECT EMP_NAME, SALARY
      ,CASE WHEN SALARY >=5000000 THEN '고급'
            WHEN SALARY >=3500000 THEN '중급'
            ELSE '초급' 
        END AS "급수"
FROM EMPLOYEE;
        
--=========================================================
-----------------------<그룹 함수>-----------------------
--=========================================================

/*
    SUM(숫자타입의 컬럼) : 해당컬럼값들의 합계를 구해서 반환 
*/
--전 사원의 총 급여액 조회 
--그룹함수, 단일행 함수 같이 못함, 사원명은 100명이면 100명 다나온다
--SUM은 1개 나오므로 사원명을 누구로 해야하나 문제가 생긴다.

SELECT SUM(SALARY) AS "총급여액"
FROM EMPLOYEE;

--남자 사원의 총 급여액 조회 
SELECT SUM(SALARY) AS "남자사원의 총급여액"
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1)IN ('1','3');

--부서코드가 'D5'인 사원의 총 급여액 조회 
SELECT SUM(SALARY) "D5사원 총 급여액 "
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--부서코드가 'D5'인 사원의 연봉(보너스 포함)의 총 합계액 조회 
SELECT SUM(12*SALARY*(1+NVL(BONUS,0))) "D5'인 사원의 연봉(보너스 포함)"
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5';

--전사원의 총급여액 조회 
SELECT TO_CHAR(SUM(SALARY),'L999,999,999')"총 급여액"
FROM EMPLOYEE;

----------------------------------------------------------

/*
    AVG(숫자타입컬럼) :  해당컬럼 값들의 평균을 반환 
*/

SELECT AVG(SALARY) AS "평균 급여액"
FROM EMPLOYEE;

--반올림
SELECT ROUND(AVG(SALARY)) AS "평균 급여액"
FROM EMPLOYEE; --3047663

SELECT ROUND(AVG(SALARY), 1) AS "평균 급여액"
FROM EMPLOYEE; --3047662.6

SELECT ROUND(AVG(SALARY), -1) AS "평균 급여액"
FROM EMPLOYEE; --3047660

----------------------------------------------------------
/*
    MIN (모든 타입컬럼-문자도 가능) 해당 컬럼 값들 중에 가장 작은 값 반환  
    MAX (모든 타입 컬럼) : 해당 컬럼 값들 중에 가장 큰 값 반환 
*/


--급여 중에서 가장 적게 받는 값
--SELECT EMP_NAME, MIN(SALARY) AS "급여중 최저"
--단일행 함수인 네임이 그룹 이름이 아니다 
--따라서 아래와 같이 네임 앞에도 MIN을 붙여준다 

SELECT MIN(EMP_NAME), MIN(SALARY)
FROM EMPLOYEE;
--네임중에서 가장 낮은 값 김정복, 맨처음 나오는 글자 (사전순)
-- 급여 최저 값과 일치 하지 않음 

SELECT MIN(HIRE_DATE), MIN(SALARY) 
FROM EMPLOYEE;
--가장 먼저 입사한 사람이 나온다,  두개가 따로 따로 들어간다. 

SELECT MAX(HIRE_DATE), MAX(SALARY) 
FROM EMPLOYEE;
--따로 따로  최고치 값


----------------------------------------------------------
/*
    COUNT 행의 갯수, 
    COUNT(* | 전체 행
    COUNT(|컬럼|DISTINCT 컬럼) : 행의 갯수 반환
    COUNT(*) : 조회된 결과의 모든 행의 갯수를 반환한다. 
    COUNT(컬럼): 제시한 컬럼의 NULL값을 제외한 행의 갯수를 반환 
    COUNT(DISTINCT 컬럼) : 해당 컬럼값 중에서 중복을 제거한 후의 행의 갯수
    
*/
--전체 사원 수 조회 
SELECT COUNT(*)
FROM EMPLOYEE;

--여사원 조회 
SELECT COUNT(*)
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO,8,1) IN ('2','4');

--보너스를 받는 사원 수 
SELECT COUNT(BONUS)
FROM EMPLOYEE;

--부서 배치를 받은 사원
SELECT COUNT(DISTINCT DEPT_CODE)
FROM EMPLOYEE;























