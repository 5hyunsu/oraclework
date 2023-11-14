--GROUP, HAVING 절 

/*
    <GROUP BY 절>
    그룹을 기준으로 제시할 수 있는 구문(여러 그룹 기준별로, 여러그룹으로 
    묶을 수 있음, 여러개의 값들을 하나의 그룹으로 묶어서 처리할 목적으로 사용)
   
*/

SELECT SUM(SALARY)
FROM EMPLOYEE;  --전체 사원을 하나의 그룹을 묶어서 총합을 구함 

--각 부서별 총 급여의 합 조회를 하시오 
SELECT DEPT_CODE, SUM(SALARY) 
FROM EMPLOYEE
GROUP BY DEPT_CODE; --그룹별로 합계가 나옴// 보통 그룹바이 한 것을 셀렉트에 넣는다. 
--WHERE BY은 해당하는 것만 나오고 
--GROUP BY는 그룹별로 합계가 나온다

-- 각 부서별 사원수 조회 
SELECT DEPT_CODE , COUNT(*) AS "사원수"
FROM EMPLOYEE
GROUP BY DEPT_CODE; 

--각 부서별 급여합계와 사원수 조회 
SELECT DEPT_CODE, SUM(SALARY), COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;

-- 각 직급별 사원수, 급여합계 조회, 직급별 내림차순으로 정렬 
SELECT JOB_CODE ,SUM(SALARY) ,AS "급여합계", COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE DESC;

--각 직급별 총 사원수, 보너스를 받는 사원수, 급여합, 평균급여, 최저급여, 최고급여 조회

SELECT JOB_CODE AS "총사원수", 
    COUNT(*) 사원수,
    COUNT(BONUS),
    SUM(SALARY) 급여합 ,
    ROUND(AVG(SALARY))평균급여 ,
    MIN(SALARY) 최저급여,
    MAX(SALARY)최고급여
FROM EMPLOYEE
GROUP BY JOB_CODE
--ORDER BY시  컬럼의 번호를 사용해도 된다. 
--그리고 뒤에 오름, 내림차순 표시 
ORDER BY 4 DESC;

--GROUP BY 절에 함수식도 기술 가능 

--여성별 남성별 사원의 수 
SELECT 
    COUNT(EMP_NO) AS 성별
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1); --그룹이 나눠진자 1,2로 (3,4도 있어야 한다)

--1번 방법
SELECT 
    DECODE(SUBSTR(EMP_NO,8,1),'1','남','2','여'),COUNT(*)
    FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

--2번 방법  
SELECT 
    SUBSTR(EMP_NO,8,1), COUNT(*)
    FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO,8,1);

--GROUP BY에 2개 가능?  서브쿼리 이용
--부서코드, 직급코드 별 사원수, 급여 합 
SELECT
    DEPT_CODE, JOB_CODE, COUNT(*),SUM(SALARY)
    FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY 1;

---------------------------------------------------------------
/*
    <HAVING절>
    그룹에 대한 조건을 제시할 때 사용되는 구문
    (주로 그룹함수식을 가지고 조건을 제시할 때 사용)
  
*/
-- 각 부서별 평균 급여 조회 (부서코드, 평균 급여)
SELECT DEPT_CODE AS 부서코드, ROUND(AVG(SALARY)) AS "평균 급여"
    FROM EMPLOYEE
GROUP BY DEPT_CODE;

--각 부서별 평균 급여가 300만원 이상인 부서만 조회 
SELECT DEPT_CODE AS 부서코드, ROUND(AVG(SALARY)) AS "평균 급여"
    FROM EMPLOYEE
--WHERE ROUND(AVG(SALARY)) >=3000000  오류 뜬다, 그룹에는 해빙
--ORA-00934: 그룹 함수는 허가되지 않습니다
--00934. 00000 -  "group function is not allowed here"
--그룹함수 조건시 WHERE 안된다, HAVING 사용하자 

GROUP BY DEPT_CODE
HAVING AVG(SALARY)>=3000000;
--결과 값은 2개만 나온다. 

---------------------------------------------------------------
/*
    <SELECT 문 순서>  F-W-G-H-S-O
    FROM
    WHERE
    GROUP BY  (WHERE 와는 상극이다, 서로 같이 나오면 안된다)
    HAVING
    SELECT
    ORDER BY 
*/
-----------------------<실습문제>-------------------------------
--1.직급별 총 급여액(단, 직급별 급여합이 1000만원 이상인 직급만 조회) 
--조회되는 컬럼: 직급코드, 급여합 

--내가 한 것 
SELECT 
    JOB_CODE AS "직급코드", 12*SALARY*(1+NVL(BONUS,0)) AS 급여합
FROM EMPLOYEE
GROUP BY JOB_CODE;
--HAVING 12*SALARY*(1+NVL(BONUS,0))>=10000000;

--PROF
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING SUM(SALARY) >=10000000;


--2. 부서별 보너스를 받는 사원이 없는 부서만 부서코드 조회-부서코드
--ME
SELECT
    DEPT_CODE AS "부서코드" 
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING BONUS IS NULL
ORDER BY DEPT_CODE;

--PROF
SELECT
    DEPT_CODE,
    COUNT(BONUS)
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING COUNT(BONUS=0);
---------------------------------------------------------------
/*
    <집계함수>
    그룹별 산출된 결과 값에 중간집계를 계산해 주는 함수 
    
    ROLLUP, CUBE
    => GROUP BY절에 기술하는 함수 
    - ROLLUP(컬럼1, 컬럼2); 컬럼1을 가지고 다시 중간집계를 내는 함수
    -CUBE(컬럼1, 컬럼2): 컬럼1을 가지고 다시 중간집계를 내고 
                        컬럼2를 가지고 다시 중간집계를 내는 함수
                        
*/

--각 직급별 급여합 
SELECT JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY JOB_CODE;
ORDER BY 1;
--컬럼 1개시 
--1.큐브
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(JOB_CODE)
ORDER BY 1:;
--2.롤업
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(JOB_CODE)
ORDER BY 1:;
-- 중간집계 1개시 ROLLUP과 CUBE가 동일하다 

--컬럼이 2개일 때
--CUBE, ROLLUP(컬럼1, 컬럼2)
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE
ORDER BY 1;
--ROLLUP: 중간집계를 다시 해준다. 
---DEPT_CODE 정렬하고 D1마지막에 합 추가, 두번째 그룹의 합 추가, 전체 합 추가 
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE) --2번의 그룹화 
ORDER BY 1;
--CUBE :  첫번째 중간집계 
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) -- 두버째 그룹 모두 합정리
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE) --2번의 그룹화 
ORDER BY 1;

---------------------------------------------------------------
/*
    <집합연산자== SET OPERATION>
    여러개의 쿼리문을 가지고 하나의 쿼리문으로 만드는 연산자
    -UNION: OR | 합집합 (두 쿼리문을 수행한 결과 값을 더한 후 
            중복되는     값은 한번만 더해 준다. 
            
    -INTERSECT : AND | 교집합 (두 쿼리문을 수행한 결과값의 
    중복된 결과값)
    
    -UNION ALL: 합집합+교집합 (중복되는 값은 두번 표현됨)
    -MINUS :차집합(첫번째 집합에서 두번째 집합의 값을 뺀 나머지)
       A에서 B를 빼는 것과 B에서A를 빼는 것이 다르다. 
    
*/

----------------------1. UNION---------------------------------
--부서코드가 D5인 사원 또는 급여가 300만원 초과인 사원을 조회 
--부서코드가 D5인 사원 
SELECT EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE IN 'D5'; --6명
--급여가 300만원 초과인 사원 
SELECT EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY>3000000;  --8명

--UNION으로 
SELECT  EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE IN 'D5'
UNION
SELECT EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY>3000000;  --12명 (중복되는 값은 1번만 나왔다) 

--OR절로도 가능 
SELECT  EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE DEPT_CODE IN 'D5'
    or SALARY>3000000;    --or로도 가능, 간결하다. 

----------------------2. intersect---------------------------------
--부서코드가 D5인 사원 이면서 급여가 300만원 초과인 사원을 조회 
--부서코드가 D5인 사원 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN 'D5'
INTERSECT
SELECT  EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY>3000000;

--AND도 가능 
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN 'D5'
INTERSECT  
--SELECT 이름은 둘이 같아야 한다. 컬럼의 이름과 숫자가 같아야 한다. 
SELECT  EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY>3000000;

-- 주의사항
-- 집합연산자를 사용할 경우, 컬럼의 갯수와 컬럼명이 동일해야함. 

----------------------3. UNION ALL---------------------------------
--부서코드가 D5인 사원과 급여가 300만원 초과인 사원을 조회(중복값도 모두출력)
SELECT EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN 'D5'
UNION ALL --14명 (강정보 , 유하보 2번씩 나옴)
SELECT  EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE
WHERE SALARY>3000000;

----------------------4. MINUS---------------------------------
--부서코드가 D5인 사원에서  300만원 초과인 사원을 제외한 나머지 사원 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE IN 'D5'
MINUS  --4명 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY>3000000;































