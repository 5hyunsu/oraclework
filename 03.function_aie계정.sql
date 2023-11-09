/*
    <함수>
    전달된 컬럼값을 읽어들여 함수를 실행한 결과 반환 
    
    - 단일행 함수 : N개의 값을 읽어들여 N개의 결과 값을 반환 (매 행마다 함수 실행) 
    - 그룹 함수 : N개의 값을 읽어들여 1개의 결과 값을 반환(그룹별로 함수를 실행)
    
    >>SELECT절에 단일행 함수와 그룹함수를 함께 사용할 수 없음 
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
    INSTR(컬럼|'문자열','찾을 문자열',[찾을 위치의 시작 값,[순번])
    
    찾을위치의 시작 값 [순번]에 들어갈 값
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




























