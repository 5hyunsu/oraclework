/*
  SELECT - 테이블 칼럼의 정보 조회 할 때 
  (')홑따옴표 : 문자열 일 때 
  (")쌍따옴표 : 컬럼명 일 때 (나이, 이름)
  
  <SELECT> 데이터 조회 할 때 사용
  
  >>RESULT SET : SELECT문을 통해 조회된 결과물(조회된 행들의 집합)
  
  [표현법]
  
  SELECT 조회하려는 컬럼명, 조회하려는 컬럼명... 여러개 가능 
  FROM 테이블명 
  
*/

SELECT * FROM employee;

SELECT * FROM department;

SELECT EMP_ID, EMP_Name,PHONE
FROM employee;

/*
실습문제
1.JOB테이블에 직급명만 조회
2.department 테이블의 모든 컬럼 조회
3.department 테이블의 부서코드, 부서명만 조회
4.employee 테이블에 사원명, 이메일, 전화번호, 입사일, 급여조회

*/


SELECT JOB_NAME FROM job;

SELECT * FROM department;

SELECT DEPT_ID, DEPT_TITLE FROM department;

SELECT EMP_NAME,EMAIL,PHONE,HIRE_DATE,SALARY FROM employee;
-----------------------------------------------------
/*
 <컬럼값을 통한 산술 연산>
 SELECT절 컬럼명 작성 부분에 산술 연산 기술 가능 (이때 산술연산된 결과조회)
*/

--EMPLOYEE에서 사원명, 사원의 연봉(급여*12)조회
SELECT EMP_NAME, SALARY*12 FROM employee;

--EMPLOYEE에서 사원명, 급여, 보너스 
SELECT EMP_NAME, SALARY, BONUS FROM EMPLOYEE;

--EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉(급여+(보너스*급여)*12)
SELECT EMP_NAME,SALARY, BONUS, SALARY*12, (SALARY+BONUS*SALARY)*12
FROM EMPLOYEE;
--산술 연산 중 null이 존재하면 결과는 무조건 null이 된다. 
--null 처리 별도로 하는 방법 있다. 

--날짜를 갖고 산술연산 가능하다. 
--EMPLOYEE에서 사원명, 입사일, 근무일수(오늘날짜-입사일) 
--DATE형 끼리도 연산 가능: 결과 값은 일단위 
--오늘날짜: SYSDATE 
SELECT EMP_NAME,HIRE_DATE,SYSDATE-HIRE_DATE
FROM EMPLOYEE;
--함수 사용해서 초단위를 관리할 수 있음 
--컬럼명(SYSDATE-HIRE_DATE) 바꾸기 

--------------------------------------------------------

/*
  <컬럼명에 별칭 지정하기>
  산술연산시 컬럼명이 산술에 들어간 수식 그대로 컬럼명이 됨.
  이때 별칭을 부여하면 깔끔하게 처리. 
  [표현법]  1번 3번을 많이 쓴다. 
  컬럼명 별칭 / 컬럼명 AS(알리안스) 별칭 / 컬럼명 "별칭" / 컬럼명 AS "별칭"
  별칭에 띄어쓰기나 특수문자 포함되면 반드시 쌍따옴표 넣어줘야한다.(")
  
*/

--EMPLOYEE에서 사원명, 급여, 보너스, 연봉, 보너스를 포함한 연봉(급여+(보너스*급여)*12)
SELECT EMP_NAME 사원명 ,SALARY AS 급여, BONUS "보너스", 
       SALARY*12 "연봉(원)", (SALARY+BONUS*SALARY)*12 AS "총 소득"
FROM EMPLOYEE;


--오늘날짜: SYSDATE 
SELECT EMP_NAME as 사원명, HIRE_DATE,SYSDATE-HIRE_DATE as 근속일
FROM EMPLOYEE;

--------------------------------------------------------

/*
  <리터럴>
  임의로 지정된 문자열(')
  SELECT 절에 리터럴을 제시하면 마치 테이블 상에 존재하는 데이터 처럼 조회가능 
  조회된 RESULT SET 모든 행에 반복적으로 출력할 수 있다. 
  
  ex) EMPLOYEE에서 사번, 사원명, 급여(원)조회하고, 
      원표시 하고, AS 별칭은 단위조회 원이 문자열, 단위가 컬럼명
      숫자는 오른쪽 정렬, 문자는 왼쪽정렬 
*/

SELECT EMP_ID, EMP_NAME, SALARY, '원' AS "단위"
FROM EMPLOYEE;

------------------------------------------------------------
/*
   <연결 연산자: ||>
   여러 컬럼값들을 마치 하나의 컬럼값인 것처럼 연결하거나, 컬럼값과 리터럴을
   연결할 수 있음 
   
*/

--EMPLOYEE에서 사번,사원명, 급여를 하나의 컬럼으로 붙어서  조회 
SELECT EMP_ID || EMP_NAME ||SALARY "사원,사원명,급여"
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY || '원' 
FROM EMPLOYEE;

--홍길동의 월급은 900000원 입니다  이름, 문자열, salary, 문자열
SELECT EMP_NAME ||'의 월급은 '|| SALARY || '원 입니다.'
FROM EMPLOYEE;

--홍길동의 전화번호는 PHONE이고 이메일은 EMAIL입니다.

SELECT EMP_NAME || '의 전화번호는 ' || PHONE || '이고 이메일은 ' ||EMAIL || '입니다.'
FROM EMPLOYEE;











