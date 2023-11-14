/*
    서브쿼리(SUBQUERY)
    하나의 SQL문 안에 포함된 또 다른 SELECT문
    메인 SQL문의 보조역할을 하는 쿼리문 
  
*/

--"박정보"와 같은 부서에 속한 사람들을 조회 하고 싶다 
--1. 박정보 사원의 부서코드를 조회 
SELECT DEPT_CODE 
FROM EMPLOYEE
WHERE EMP_NAME='박정보';

--2. 부서 코드가 'D9'인 사원의 정보를 조회 
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE='D9';

-- > 두개를 하나의 쿼리로 만들어야 한다. 
SELECT EMP_NAME
FROM EMPLOYEE
WHERE DEPT_CODE=(SELECT DEPT_CODE 
                FROM EMPLOYEE
                WHERE EMP_NAME='박정보');
                
--전 직원의 평균 급여 보다 더 많이 받는 사원의 사번, 사원명, 급여, 직급코드를 조회하시오
SELECT EMP_ID,
       EMP_NAME,
       SALARY,
       JOB_CODE
FROM EMPLOYEE
WHERE SALARY >=(SELECT AVG(SALARY)
                    FROM EMPLOYEE);

--SELECT AVG(SALARY)FROM EMPLOYEE;  평균급여

------------------------------------------------------
/*
    - 서브쿼리의 구분
      서브쿼리를 수행한 결과 값이 몇행 몇열 이냐에 따라 분류
    * 단일행 서브쿼리 : 서브쿼리의 조회 결과값이 오로지 1개일 때 (1행 1열)
    * 다중행 서브쿼리 : 행이 여러개 인데 열은 하나인 것 (여러행 1열)
    * 다중열 서브쿼리 : 열이 여러개인데 행이 하나인 것 (1행 여러열)
    * 다중행 다중열 서브쿼리 : 서버쿼리의 조회 결과 값이 여러행 , 여러열일때
                       (여러행, 여러열)
    >> 서브쿼리의 종류가 무엇이냐에 따라 서브쿼리의 앞에 붙는 연산자가 달라짐
*/

/*
    ★1.단일행 서브쿼리(SINGLE ROW SUBQUERY)
    서브쿼리의 조회 결과값이 오로지 1개일 때 (1행 1열)

    일반 비교 연산자 사용
    =, !=, >, < ...
    
*/
--1) 전 직원의 평균 급여보다 급여를 적게 받는 사원의 사원명, 급여 조회
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY < (SELECT  AVG(SALARY)
                FROM EMPLOYEE);
ORDER BY SALARY; 

--2) 최저 급여를 받는 사원의 사원명, 급여 조회 
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY = (SELECT MIN(SALARY)
                FROM EMPLOYEE);

--3) 박정보 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 급여 조회 
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY > ( SELECT SALARY
                 FROM EMPLOYEE
                 WHERE EMP_NAME ='박정보');

--JOIN + SUBQUERY
--4) 박정보 사원의 급여보다 더 많이 받는 사원의 사번, 사원명, 부서코드, 부서이름, 급여 조회
-->> 오라클 전용구문 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY
FROM EMPLOYEE, DEPARTMENT
WHERE SALARY > ( SELECT SALARY
                 FROM EMPLOYEE
                 WHERE EMP_NAME ='박정보')
    AND
      DEPT_CODE = DEPT_ID;

-->>ANSI구문 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > ( SELECT SALARY
                 FROM EMPLOYEE
                 WHERE EMP_NAME ='박정보');
                 
--5) 왕정보 사원과 같은 부서원들의 사번, 사원명, 전화번호, 부서명 조회 
--   단, 왕정보는 제외
SELECT EMP_ID, EMP_NAME,PHONE, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID
  AND DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME ='왕정보')
  AND EMP_NAME !='왕정보';
-->>ANSI구문
SELECT EMP_ID, EMP_NAME,PHONE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE DEPT_CODE = DEPT_ID
  AND DEPT_CODE = (SELECT DEPT_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME ='왕정보')
  AND EMP_NAME !='왕정보';

-- GROUP + SUBQUERY
--6) 부서별 급여의 합이 가장 큰 부서의 부서 코드, 급여합 조회
--  6.1.부서별 급여합 중 가장 큰 값 조회 

--SELECT DEPT_CODE,SUM(SALARY) 급여합 --부서별 합계
--FROM EMPLOYEE
--GROUP BY DEPT_CODE
--ORDER BY 급여합 DESC;

SELECT MAX(SUM(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 6.2 부서별 급여합이 17,700,000인 부서 조회 
/*   
SELECT DEPT_CODE, SUM(SALARY) 급여합
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING 급여합=17700000;   --순서 때문에 이부분은 급여합이 참고가 안된다. 
                         --SELECT가 더 나중에 실행 되기 때문에
*/
SELECT DEPT_CODE, SUM(SALARY) 급여합
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY)=17700000;  --급여합 대신에 SUM(SALARY)입력해 줘야 한다

-->> 위에 2개를 합치면 , 똑같이 나온다. 
SELECT DEPT_CODE, SUM(SALARY) 급여합
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY)=(SELECT MAX(SUM(SALARY))
                    FROM EMPLOYEE
                    GROUP BY DEPT_CODE);

------------------------------------------------------
/*
    ★2.다중행 서브쿼리(MULTI ROW SUBQUERY)
        다중행 서브쿼리 : 행이 여러개 인데 열은 하나인 것 (여러행 1열)
        - IN 서브쿼리 : 여러개의 결과값 중 한개라도 일치하는 값이 있다면 
        - > ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 클 경우  
        - 여러개의 결과값 중 가장 작은 값 보다 클 경우 
        - < ANY 서브쿼리 : 여러개의 결과값 중 "한개라도" 작은  경우  
        - 여러개의 결과값 중 가장 큰 값 보다 작을 경우 
    
    비교대상 > ANY(값1, 값2, 값3)  --값1,2,3중에서 값1이 제일 작다면 값1보다 큰경우를 말한다
    비교대상 > 값1 OR 비교대상 > 값2 OR 비교대상> 값3 

*/

--1)조정연 또는 전지연과 같은 직급인 사원들의 사번, 사원명, 직급코드, 급여
-- 1.1 조정연 또는 전지연이 어떤 직급인지 조회
SELECT JOB_CODE
FROM EMPLOYEE
--WHERE EMP_NAME='조정연' EMP_NAME='전지연';
WHERE EMP_NAME IN ('조정연','전지연');

--1.2 ;직급코드가 (JOB_CODE)가 J3,J7인 사원의 사번, 사원명, 직급토드, 급여조회
SELECT EMP_ID, EMP_NAME, JOB_CODE,SALARY
FROM EMPLOYEE
WHERE JOB_CODE IN (SELECT JOB_CODE
                   FROM EMPLOYEE
                   WHERE EMP_NAME IN ('조정연','전지연'));

--대표. 부사장 . 부장. 차장 과장 대리 사원
--2) 대리 직급임에도 불구하고 과장직급의 급여들 중 최소 금여보다 많이 받는 
--빅원의 사번, 사원명, 직급, 급여조회

--2.1 과장직급인 사원들의 급여 조회
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='과장';   --2200,2500,3760

--2.2 대리이면서 급여가 위의 목록값 중에 하나라도 크 사원
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='대리'
    AND SALARY > ANY(2200000,2500000,37600000);
--

SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='대리'
    AND SALARY > ANY(SELECT SALARY
                     FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE));
-






























