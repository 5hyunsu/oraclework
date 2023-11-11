/*
  SELECT - 테이블 칼럼의 정보 조회 할 때 
  (')홑따옴표 : 문자열 일 때 
  (")쌍따옴표 : 컬럼명 일 때 (나이, 이름, 별칭)
  
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
SELECT EMP_ID || ' ' || EMP_NAME ||SALARY "사원,사원명,급여"
FROM EMPLOYEE;

SELECT EMP_ID, EMP_NAME, SALARY || '원' 
FROM EMPLOYEE;

--홍길동의 월급은 900000원 입니다  이름, 문자열, salary, 문자열
SELECT EMP_NAME ||'의 월급은 '|| SALARY || '원 입니다.'
FROM EMPLOYEE;

--홍길동의 전화번호는 PHONE이고 이메일은 EMAIL입니다.
SELECT EMP_NAME || '의 전화번호는 ' || PHONE || '이고 이메일은 ' ||EMAIL || '입니다.'
FROM EMPLOYEE;

-------------------------------------------------------------
/*
 < DISTINCT> 
 컬럼의 중복된 값들을 한번씩만 표시하고자 할 때 
*/

SELECT JOB_CODE
FROM EMPLOYEE;

-- EMPLOYEE에서 직급코드 중복 제외하고 조회 
SELECT DISTINCT JOB_CODE
FROM EMPLOYEE; 

-- EMPLOYEE에서 부서코드 중복 제외하고 조회 (null도 하나로 인식)

SELECT DISTINCT DEPT_CODE
FROM EMPLOYEE; 

--둘중에 하나는 중복 되지만 두개를 조합해서 중복 값을 안보여준다. 
SELECT DISTINCT DEPT_CODE,JOB_CODE
FROM EMPLOYEE; 
-----------------------------------------------------------
/*
    <WHERE절> 조회하고자 하는 테이블에서 특정 조건에 만족하는 데이터만 조회할 때 
     SLECT 컬럼, 컬럼, 산술 연산, ...
     FROM 테이블명
     WHERE 조건식 ;  
     
    >>비교연산자 
    >,<,>=,>- : 대소비교 
    = 같은지 비교 
    != , ^=, <>  같지 않은지 비교 
*/

--EMPLOYEE 에서 부서 코드가 'D9'인 사원들의 모든 컬럼 조회 
SELECT *
FROM EMPLOYEE
WHERE dept_code='D9';

--EMPLOYEE 에서 부서 코드가 'D1'이 아닌 사원들의 사번, 사원명, 부서코드를 조회하시오
SELECT EMP_ID, EMP_NAME, DEPT_CODE 
FROM EMPLOYEE
WHERE DEPT_CODE <>'D1';
WHERE DEPT_CODE !='D1';
WHERE DEPT_CODE ^='D1';
--안에 들어있는 데이터는 대소문자를 가린다. 방법은 위에 처럼 3가지 

--EMPLOYEE에서 급여가 400만원 이상인 사원들의 사원명, 부서코드, 급여를 조회하시오
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE 
WHERE SALARY >= 4000000;

--EMPLOYEE에서 재직중인 사원의 사번, 사원명, 입사일 조회 
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE ENT_YN='N';

--WHERE ENT_YN='n'; 소문자n의 경우 값이 나오지 않는다. 안의 데이터는 대/소문자 구분

---------------------------실습문제--------------------
/*
  1. 급여가 300만원 이상인 사원들의 사원명, 급여, 입사일, 연봉 조회
  2. 연봉이 5000만원 이상인 사원들의 사원명, 
  3. 직급코드가 'J3'이 아닌 사원들의 사번, 사원명, 직급 코드, 퇴사여부 조회 
  4. EMPLOYEE 테이블에 사원명, 이메일, 전화번호, 입사일, 급여 조회 
*/

--1
SELECT EMP_NAME, EMP_SALARY, HIRE_DATE, (EMP_SALARY*BONUS*12)
FROM EMPLOYEE
WHERE EMP_SALARY>=3000000;
--2
SELECT EMP_NAME
FROM EMPLOYEE
WHERE (SALARY+BONUS*SALARY)*12 >=50000000;
--3
SELECT EMP_ID,EMP_NAME,JOB_CODE,ENT_YN
FROM EMPLOYEE
WHERE JOB_CODE !='J3';
--WHERE JOB_CODE <>'J3';
--WHERE JOB_CODE ^='J3';

-------------------------------------------------------
/*
    >>논리연산자
    여러개의 조건을 묶어서 제시하고자 할 때 
    AND (~이면서, 그리고)
    OR (~이거나, 또는)
    NOT (부정) : 컬럼명 앞 또는 BETWEEN앞에 쓸 수 있다. 
*/

--부서코드가 'D9'이면서 급여가 5000000 이상인 사원들의  사원명, 부서코드, 급여 조회 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9' AND SALARY >=5000000; 

--부서코드가 'D6'이거나 급여가 3000000 이상인 사원들의 사원명, 부서코드, 급여조회 
SELECT EMP_NAME, DEPT_CODE,SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D6' OR SALARY >3000000;

--급여가 350만원 이상 600만원 이하의 사원의 사번, 사원명, 급여 조회 
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3500000 AND SALARY <= 6000000;

-------------------------------------------------------
/*
   >> BETWEEN AND 
   ~이상 ~이하인 범위의 조건을 제시할 때 사용 
   [표현법]
   비교대상 컬럼  하한값이상 AND 상한값이하
   EX) WHERE SALARY BETWEEN 3500000 AND 6000000;
*/
--급여가 350만원 이상 600만원 이하의 사원의 사번, 사원명, 급여 조회 
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE NOT SALARY BETWEEN 3500000 AND 6000000;

--입사일이 90/01/01~ 01/12/31 사이인 사원의 사번, 사원명, 입사일 조회
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/12/31';

-------------------------------------------------------
/*
  >>LIKE 
  비교하고자 하는 컬럼의 값이 내가 제시한 특정 패턴에 만족하는 경우 조회
  
  [표현법]
  비교대상컬럼 LIKE '특정패턴'
  :특정패턴 제시시 '%','_' 와일드카드로 사용할 수 있음 
  
  % : 0글자 이상 / 글자가 하나도 안들어 와도 괜찮다. 
  EX) 비교대상컬럼 LIKE '문자%' => 비교대상 컬럼 값이 '문자'로 시작 되는 것들을 조회 
      문자 / 문자들 / 문자들의 / 문자들들들   이런식 가능 
  EX) 비교대상컬럼 LIKE '%문자' =>맨 끝에는 문자로 끝나도록 
      비교대상 컬럼값이 ' 문자로 끝나는 것들을 조회  
  EX) 비교대상컬럼 LIKE '%문자%' 앞에과 뒤가 모두 있다면  문자가 포함된 모든 것 
      문자 / 나중문자/  처음문자나중 / 문자들들  컬럼값에 문자만 들어있으면 모두 
  
  - : 언더바,  하나에 한글자 
  EX) 비교대상컬럼 LIKE '_문자' => (3글자만 가능)
      비교대상 컬럼값의 '문자' 앞에 무조건 한글자가 올 경우 
      이문자 / 아문자 /  이아문자(X : 무조건 1글자) / 이아문자들 (X)
      비교대상컬럼 LIKE '문자_'
      비교대상 컬럼값의 '문자__' 뒤에 3글자 가능 
      비교대상컬럼 LIKE '_문자_'
      비교대상 컬럼값의 '_문자_' 뒤에 4글자  가능 
      
*/

--사원들 중 성이 '전'씨인 사원들의 사번, 사원명, 조회 
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '전%';

--사원들 중 '하'가 포함되어 있는 사원들의 사번, 사원명 조회 
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

--사원들 중 가운데'하'가 들어있는 사원들(외자X)의 사번, 사원명 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '_하_';

--전화번호 3번째 숫자가 1인 
SELECT EMP_ID, EMP_NAME, PHONE
FROM EMPLOYEE
WHERE PHONE LIKE '__1%';

--이메일 중  _앞에 글자가 3글자인 사원들의 사번, 사원명, 이메일 조회 
SELECT EMP_ID, EMP_NAME, EMAIL 
FROM EMPLOYEE
WHERE EMAIL LIKE '____%';  -- 언더바가 4개 이렇게 하면 원하는 결과 안나옴 

/*
 와일드 카드로 인식이 됨 
 - 데이터와 와일드 카드를 구분지어야 됨 
  :  데이터 값으로 취급하고자 하는 값 앞에 
     나만의 와일드 카드(아무거나 문자도 되고 숫자도 가능)제시하고 
     나만의 와일드 카드를 ESCAPE로 등록 해야 함 
     일반 문자나 숫자로 하면 헷갈리기 쉽다. 
*/

SELECT EMP_ID, EMP_NAME, EMAIL 
FROM EMPLOYEE
WHERE EMAIL LIKE '___$_%' ESCAPE '$';
-- WHERE EMAIL LIKE '___#_%' ESCAPE '#'; -- 뒤에 나오는 것은 문자로 

--이메일 중  _앞에 글자가 3글자인 사원들을 제외한 사번, 사원명, 이메일 조회 
SELECT EMP_ID, EMP_NAME, EMAIL 
FROM EMPLOYEE
WHERE NOT EMAIL LIKE '___e_%' ESCAPE 'e';
WHERE  EMAIL NOT LIKE '___e_%' ESCAPE 'e';
--WHERE NOT EMAIL LIKE '___&_%' ESCAPE '&';  앤드는 입력값을 대체 받아서 

------------------------실습문제-----------------------------
--1. 이름이 '연'으로 끝나는 사원의 사번, 사원명, 입사일 조회 
--2. 전화 번호 처음 3자리가 010이 아닌 사원들의 사원명, 전화번호 조회
--3. 이름이 '하'가 포함 되어 급여가 250만원 이상인 사원들의 사원명, 급여조회
--여기까지 EMPLOYEE
--4. DEPARTMENT 테이블에서 해외 영업부인 부서들의 부서코드, 부서명 조회

SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%연';

SELECT EMP_NAME,PHONE
FROM EMPLOYEE
WHERE PHONE NOT LIKE '010%';
--WHERE NOT PHONE LIKE '010%';

SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%' AND SALARY >= 2500000;

--해외영업 1부 , 2부 , 3부 모두 나와야 한다. 
SELECT DEPT_ID, DEPT_TITLE 
FROM DEPARTMENT
WHERE DEPT_TITLE LIKE '해외영업%부';

-------------------------------------------------------
/*
    >> IS NULL / IS NOT NULL 
    컬럼 값에 NULL이 있는 경우 NULL값 비교에 사용 되는 연산자
*/

--보너스를 받지 않는(BONUS컬럼이 NULL) 사원의 사번, 사원명, 급여, 보너스 조회 
SELECT EMP_ID , EMP_NAME, SALARY, BONUS 
FROM EMPLOYEE
-- WHERE BONUS = NULL; 아무것도 나오지 않는다. 조회가 되지 않는다. 
-- NULL 값은 IS NULL , IS NOT NULL을 사용해야 한다.  
WHERE BONUS IS NULL;

SELECT EMP_ID , EMP_NAME, SALARY, BONUS 
FROM EMPLOYEE
WHERE BONUS IS NOT NULL;  널이 아닌 값 
--WHERE NOT BONUS IS NULL;  널값을 갖고왔는데 그것에 반대 되는 
--WHERE NOT BONUS IS NOT NULL;  널값이 아닌데 그것이 아닌것= 널값


--사수가 없는 사원들의 사번, 사원명, 사수번호조회 
--매니저아이디가 NULL인 사람 
SELECT EMP_ID, EMP_NAME,MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL;

--부서배치를 받지 않았지만(DEPT_CODE가 NULL)
--보너스는 받는 사원들의 사원명, 보너스, 부서코드(DEPT_ID) 조회 
SELECT EMP_NAME, BONUS, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IS NULL AND BONUS IS NOT NULL;

--NULL값 제외는 함수 할 때 

-------------------------------------------------------
/*
   >> IN / NOT IN 
   IN ; 컬럼값이 내가 제시한 목록중에 일치하는 값이 있는 것만 
   NOT IN :컬럼값이 내가 제시한 목록중에 일치하는 값을 제외한 나머지만 조회
   
   [표현법]
   비교대상컬럼 IN('값','값2,'값3'...)
  
*/
 
--부서코드가 D5, D6, D8인 사원의 사원명, 부서코드, 급여조회 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
--WHERE DEPT_CODE='D5' OR DEPT_CODE='D6' OR DEPT_CODE='D8';
WHERE DEPT_CODE IN ('D5','D6','D8');


--부서코드가 D5, D6, D8이 아닌 사원의 사원명, 부서코드, 급여조회
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE NOT IN ('D5','D6','D8');

-------------------------------------------------------

/*
  <연산자우선순위> 
  1. ()
  2. 산술연산자
  3. 연결연산자
  4. 비교연산자
  5. IS NULL/ LIKE'패턴' / IN
  6. BETWEEN AND
  7. NOT(논리연산자)
  8. AND(논리연산자)
  9. OR(논리연산자) 
*/ 

--직급코드가 J7이거나 J2인 사원들 중 급여가 200만원 이상인 사원들의 모든 컬럼 조회 
SELECT EMP_NAME,JOB_CODE, SALARY
FROM EMPLOYEE
--WHERE (JOB_CODE= 'J7' OR JOB_CODE= 'J2') AND SALARY >=2000000;
--아래와 같이 가로를 사용하지 않으면 조건을 2번 각각 써줘야 한다. 
WHERE JOB_CODE= 'J7' AND SALARY >=2000000; OR JOB_CODE= 'J2' AND SALARY >=2000000;

-------------------------------------------------------
/*1. 사수가 없고 부서배치도 받지 않은 사원들의 사원명, 사수사번, 부서코드 조회

  2. 연봉(보너스 포함X)이 3000만원 이사이고 보너스를 받지 않은 사원들의 
     사번, 사원명, 보너스, 연봉 조회
  3. 입사일이 95/01/01이상이고 부서배치를 받은 사원들의 
     사번, 사원명, 입사일, 부서코드 조회
  4. 급여가 200만원 이상 500만원 이하고 입사일이 01/01/01 이상이고 보너스를 받지 않는
     사원들의 사번, 사원명, 급여, 입사일, 보너스 조회 
  5. 보너스 포함 연봉이 NULL이 아니고 이름에 '하'가 포함되어 있는 사원들의 
     사번, 사원명, 급여, 보너스 포함 연봉 조회(별칭부여)
     
*/

SELECT EMP_NAME, EMP_ID, DEPT_CODE
FROM EMPLOYEE
WHERE MANAGER_ID IS NULL AND DEPT_CODE IS NULL;

SELECT EMP_ID,EMP_NAME, SALARY, SALARY*12 AS "연봉"
FROM EMPLOYEE
WHERE SALARY*12>=30000000 AND BONUS IS NULL;

SELECT EMP_ID,EMP_NAME, HIRE_DATE, DEPT_CODE
FROM EMPLOYEE
WHERE HIRE_DATE>'1995/01/01' AND DEPT_CODE IS NOT NULL;
--날짜 형식이 달라도 표현 가능 

SELECT EMP_ID, EMP_NAME, SALARY, HIRE_DATE, BONUS
FROM EMPLOYEE
WHERE (SALARY BETWEEN 2000000 AND 5000000) 
      AND HIRE_DATE > '01/01/01' 
      AND BONUS IS NULL;

SELECT EMP_ID, EMP_NAME, SALARY, 12*SALARY*(1+BONUS) AS "보너스 포함 연봉"
FROM EMPLOYEE
WHERE BONUS IS NOT NULL AND EMP_NAME LIKE'%하%';

-----------------------------------------------------
/*
 <ORDER BY 절>
 -정렬
 -SELECT문 가장 마지막 줄에 작성, 실행순서 또한 맨 마지막에 실행 
 
 [표현법]
 SELECT 컬럼, 컬럼, ....
 FROM 테이블명
 WHERE 조건식
 (중요)ORDER BY 정렬 기준이 되는 컬럼명 | 별칭 | 컬럼순번[ASC|DESC]|[NULLS FIRST |NULLS LAST]
 
 *ASC : 오름차순 정렬
 *DESC : 내림차순 정렬 
 
 *NULLS FIRST : 정렬하고자 하는 컬럼값에 NULL이 있는 경우 해당 데이터를 맨 앞에 배치 
               (생략시 DESC일때)
 *NULLS LAST :  정렬하고자 하는 컬럼값에 NULL이 있는 경우 해당 데이터를 맨 뒤에 배치 
               (생략시 ASC일때)
 
*/

--보너스로 정렬 
SELECT EMP_NAME,BONUS, SALARY
FROM EMPLOYEE
--ORDER BY BONUS;  --오름차순 기본값 NULL이 맨 끝에 온다. 
--ORDER BY BONUS ASC; 
--ORDER BY BONUS NULLS FIRST;  -NULL 마지막에  나머지 오름차순 
--ORDER BY BONUS DESC;  --내림차순은 반드시 DESC기술, NULL이 맨 앞에 온다. 
ORDER BY BONUS DESC, SALARY ASC; --보너스는 내림, 급여 오름 --기준 여러개 가능 

--전 사원의 사원명, 연봉조회(연봉의 내림차순 정렬 조회) 

SELECT EMP_NAME, 12*SALARY*(SALARY+BONUS) AS 연봉
FROM EMPLOYEE
ORDER BY 연봉 DESC;

---------------------연습문제1------------------------
--1. JOB 테이블의 모든 정보 조회
    SELECT *
    FROM JOB;
--2. JOB 테이블의 직급 이름 조회
    SELECT JOB_NAME
    FROM JOB;
--3. DEPARTMENT 테이블의 모든 정보 조회
    SELECT *
    FROM DEPARTMENT;
--4. EMPLOYEE테이블의 직원명, 이메일, 전화번호, 고용일 조회
    SELECT EMP_NAME AS 직원명, EMAIL AS 이메일, PHONE AS 전화번호, HIRE_DATE AS 고용일
    FROM EMPLOYEE;
--5. EMPLOYEE테이블의 고용일, 사원 이름, 월급 조회
    SELECT HIRE_DATE AS 고용일, EMP_NAME AS 사원 이름 , SALARY AS 월급
    FROM EMPLOYEE;
--6. EMPLOYEE테이블에서 이름, 연봉, 총수령액(보너스포함), 실수령액(총수령액 - (연봉*세금 3%)) 조회
    SELECT EMP_NAME AS 이름, SALARY*12 AS 연봉, 12*SALARY*(1+BONUS) AS 총수령액 , 12*SALARY*(1+BONUS)-SALARY*12*0.03 AS 실수령액
    FROM EMPLOYEE;
--7. EMPLOYEE테이블에서 JOB_CODE가 J1인 사원의 이름, 월급, 고용일, 연락처 조회
    SELECT EMP_NAME AS 이름, SALARY AS 월급, HIRE_DATE AS 고용일, PHONE AS 연락처
    FROM EMPLOYEE
    WHERE JOB_CODE IN 'J1';
--8. EMPLOYEE테이블에서 실수령액(6번 참고)이 5천만원 이상인 사원의 이름, 월급, 실수령액, 고용일 조회
    SELECT  EMP_NAME AS 이름, SALARY AS 월급, 12*SALARY*(1+BONUS)-SALARY*12*0.03 AS 실수령액, HIRE_DATE AS 고용일
    FROM EMPLOYEE
    WHERE 12*SALARY*(1+BONUS)-(SALARY*12*0.03) >= 50000000;
--9. EMPLOYEE테이블에 월급이 4000000이상이고 JOB_CODE가 J2인 사원의 전체 내용 조회
    SELECT *
    FROM EMPLOYEE 
    WHERE SALARY>=4000000 AND JOB_CODE='J2';
--10. EMPLOYEE테이블에 DEPT_CODE가 D9이거나 D5인 사원 중 
--고용일이 02년 1월 1일보다 빠른 사원의 이름, 부서코드, 고용일 조회
    SELECT EMP_NAME AS 이름, DEPT_CODE AS 부서코드 , HIRE_DATE AS 고용일
    FROM EMPLOYEE
    WHERE HIRE_DATE <='02/01/01';
--11. EMPLOYEE테이블에 고용일이 90/01/01 ~ 01/01/01인 사원의 전체 내용을 조회
    SELECT *
    FROM EMPLOYEE
    WHERE HIRE_DATE BETWEEN '90/01/01' AND '01/01/01';
--12. EMPLOYEE테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
    SELECT EMP_NAME
    FROM EMPLOYEE
    WHERE EMP_NAME LIKE '%연';
--13. EMPLOYEE테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
    SELECT EMP_NAME AS 이름, PHONE AS 전화번호
    FROM EMPLOYEE
    WHERE PHONE NOT LIKE '010%';
--14. EMPLOYEE테이블에서 메일주소 '_'의 앞이 4자이면서 DEPT_CODE가 D9 또는 D6이고 
--고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
    SELECT  *
    FROM EMPLOYEE
    WHERE EMAIL LIKE '____%' 
            AND DEPT_CODE IN ('D9','D6') 
            AND HIRE_DATE BETWEEN '90/01/01' AND '00/12/01'
            AND SALARY >=2700000;

-------------------------------------------------------



