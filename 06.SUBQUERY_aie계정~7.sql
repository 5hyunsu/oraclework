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

-- > 두개를 하나의 쿼리로 만들어야 한다. D9가 들어갈 자리에 넣어준다.
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
    * 다중행 서브쿼리 : 행이 여러개 인데 열은 하나인 것 (여러행 1열) 사람여러명
    * 다중열 서브쿼리 : 열이 여러개인데 행이 하나인 것 (1행 여러열)사람하나인데 여러개
    * 다중행 다중열 서브쿼리 : 서버쿼리의 조회 결과 값이 여러행 , 여러열일때
                       (여러행, 여러열) 여러명, 여러쿼리
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
                FROM EMPLOYEE)
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
WHERE DEPT_CODE = DEPT_ID;
    AND  --순서는 상관 없다 
        SALARY > ( SELECT SALARY
                 FROM EMPLOYEE
                 WHERE EMP_NAME ='박정보')
    
      

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
WHERE EMP_NAME IN ('조정연','전지연'); --이 중에서 하나라도 일치하는 사람 

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
WHERE JOB_NAME='대리'   --ANY : OR 그중에서 찾는 것이므로 OR와 비슷하다
    AND SALARY > ANY(SELECT SALARY
                     FROM EMPLOYEE
                    JOIN JOB USING(JOB_CODE)
                    WHERE JOB_NAME='과장');

------------------------------------------------------
--단일행 쿼리로도 가능 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='대리'
    AND SALARY >(SELECT MIN(SALARY) --220만원 최저값보다 낮은 값 다 갖고오기
                 FROM EMPLOYEE
                 JOIN JOB USING(JOB_CODE)
                 WHERE JOB_NAME='과장');


--3)차장직급임에도 과장직급의 급여보다 적게 받는 사원의 사번, 직급병, 그벼 조회 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE 
JOIN JOB USING (JOB_CODE)              
WHERE JOB_NAME='차장'
 AND SALARY < ANY(SELECT SALARY
 --AND SALARY < SELECT MAX(SALARY)  이렇게 써도 괜찮다 
                 FROM EMPLOYEE
                 JOIN JOB USING(JOB_CODE)
                 WHERE JOB_NAME='과장');  --220, 250, 376
        --2200, 2500, 3760 이것 중에서 하나라도 작으면 된다 

--4) 과장직급임에도 불구하고 차장직급인 사원들의  
--   모든 급여보다 더 많이 받는 사원, 사원명, 직급명, 급여조회
-- ANY : 차장의 가장 적게 받는 급여보다 많이 받는 과장 
--ANY 단일행 쿼리로 생각해야 
-- 비교대상이 > 값1 OR 비교대상> 값2 OR 비교대상> 값3보다 커야 함 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME='과장'  --220, 250, 376
    AND SALARY > ANY(SELECT SALARY  
                   FROM EMPLOYEE
                   JOIN JOB USING(JOB_CODE)
                   WHERE JOB_NAME='차장');  --280,155,249,248


--ALL = AND와 비슷 하다 , 가장 큰값보다 커야 한다. 
--ALL: 서브쿼리의 값들 중 가장 큰값보다 큰 값을 얻어 오고 싶을 때 사용 
-- X > ALL 1 AND 2 AND 4 
--"차장의 가장 많이 받는 급여보다 더 많이 받는 과장" 
--크다는 가장 작은 값보다 크고
--비교대상 > 값1 AND 비교대상 > 값2 AND 비교대상 > 값3
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE JOB_NAME='과장'  --220, 250, 376
    AND SALARY > ALL(SELECT SALARY  --차장그룹에서 가장 많이 
                   FROM EMPLOYEE
                   JOIN JOB USING(JOB_CODE)
                   WHERE JOB_NAME='차장'); --280,155,249,248
--MAX나 MIN이 직관적이라 ANY나ALL 보다 더 많이 사용한다.

------------------------------------------------------------
/*
    3. 다중열 서브쿼리 
        결과값이 한행이면서 여러 컬럼일 때 
        
*/

--1) 장정보 사원과 같은 부서코드, 같은 직급코드에 해당하는 
--  사원들의 사번, 사원명, 부서코드, 직급코드 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
--2개 나뉜 버전 
--WHERE DEPT_CODE=(SELECT DEPT_CODE 
--                 FROM EMPLOYEE
--                 WHERE EMP_NAME='장정보')
--    AND
--      JOB_CODE=(SELECT JOB_CODE 
--                 FROM EMPLOYEE
--                 WHERE EMP_NAME='장정보');

--다중열 서브쿼리로 (위에 하나로 합친다) 
WHERE (DEPT_CODE, JOB_CODE)=(SELECT DEPT_CODE, JOB_CODE 
                            FROM EMPLOYEE
                             WHERE EMP_NAME='장정보')
    AND EMP_NAME !='장정보';

--지정보 사원과 같은 직급코드, 같은 사수를 가지고 있는 
--사원들의 사번, 사원명, 직급코드, 사수번호 조회
SELECT EMP_ID, EMP_NAME, JOB_CODE, MANAGER_ID
FROM EMPLOYEE 
WHERE EMP_NAME !='지정보'
    AND
     (JOB_CODE, MANAGER_ID) =(SELECT JOB_CODE, MANAGER_ID
                                FROM EMPLOYEE
                                WHERE EMP_NAME='지정보');

------------------------------------------------------------
/*
    4. 다중행 다중열 서브쿼리 
    서브쿼리 결과 여러행,여러열일 경우
        
*/
--1) 각 직급별 최소급여를 받는 사원의 사번, 이름, 직급코드, 급여조회
--  1.1 각 직급별로 최소급여를 받는 사원의 직급코드, 최소급여 조회
    SELECT JOB_CODE, MIN(SALARY)
    FROM EMPLOYEE
    GROUP BY JOB_CODE;

--아래와 같이 계속 써줘야 한다. 
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    GROUP BY JOB_CODE = 'J5' AND SALARY =2200000
          OR JOB_CODE = 'J6' AND SALARY =2000000;
    
    SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    WHERE(JOB_CODE, SALARY) = ('J5', 2200000);
            --7번 수행 
*/

--다중행 다중열 서브쿼리, 7번 써줄 필요 없이 
--IN 안에 있는 값을 가져오면 된다. 
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE(JOB_CODE, SALARY) IN (SELECT JOB_CODE, MIN(SALARY) --최소값
                            FROM EMPLOYEE
                            GROUP BY JOB_CODE)
ORDER BY JOB_CODE;            

--2) 각 부서별 최고급여를 받는 사원들의 
--  사번, 사원명, 코드, 급여 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE (DEPT_CODE, SALARY) IN (SELECT DEPT_CODE, MAX(SALARY) --MAX는 값이 1개
                              FROM EMPLOYEE
                              GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE; 
------------------------------------------------------------
/*
    5.인라인 뷰 (INLINE VIEW)
      --FROM 다음에 테이블이 나오는데, 가공해서 갖고올 때 
      --가짜 테이블 하나 만들어서 마치 테이블 처럼 사용
      --순위를 매긴다던지, 정렬은 제일 마지막에하니까
      
*/
--사원들의 사번, 사원명, 보너스 포함 연봉, 부서코드 조회 
--  조건 1. 보너스 포함 연봉이 NULL이 나오지 않도록 
--  조건 2. 보너스 포함 연봉이 3000만원 이상인 사원들만 조회 

--SELECT 연봉  
--FROM 내가 만든 테이블 (보너스 포함 연봉) 
--WHERE 조건2
--
--1.FROM
--2.WHERE  SELECT 연봉을 갖고 올 수 없다.  
--          조건2를 쓸라면 모든 사원의 값을 갖고 와야 한다. 
--          순서가 더 높은 FROM에 가짜 테이블을 만들어 준다. 
--          내가 만든 테이블 (보너스 포함 연봉) 
--3.SELECT

SELECT EMP_ID, EMP_NAME, 
    12*SALARY*(1+NVL(BONUS,0)) AS "연봉",
    DEPT_CODE
FROM EMPLOYEE;
--WHERE 연봉 >=30000000;  "연봉": 부적합한 식별자 
--순서상 SELECT가 뒤에 있어서  연봉을 갖고 올 수 없다. 
--WHERE절로도 가능은 하다. 

SELECT EMP_ID, EMP_NAME, 
    12*SALARY*(1+NVL(BONUS,0)) AS "연봉",
    DEPT_CODE
FROM EMPLOYEE
WHERE 12*SALARY*(1+NVL(BONUS,0)) >= 30000000;

--연봉 나오는 서브쿼리 
SELECT *
FROM (SELECT EMP_ID, EMP_NAME, 
            12*SALARY*(1+NVL(BONUS,0)) AS "연봉",
             DEPT_CODE  --컬럼 이름들 중에 하나를 갖고와야 한다. 
      FROM EMPLOYEE)  --여기까지는 전체직원의 연봉 
WHERE 연봉 >= 30000000;
    
SELECT EMP_ID, EMP_NAME  -- 인라인뷰 컬럼 4개중에 2개만 갖고오는 것 가능 
FROM (SELECT EMP_ID, EMP_NAME, 
            12*SALARY*(1+NVL(BONUS,0)) AS "연봉",
             DEPT_CODE  --컬럼 이름들 중에 하나를 갖고와야 한다. 
      FROM EMPLOYEE)  --여기까지는 전체직원의 연봉 
WHERE 연봉 >= 30000000;

--인라인뷰에 없는 컬럼은 가져올 수 없다. 

SELECT EMP_ID, EMP_NAME  , JOB_CODE -- 잡코드는 인라인뷰가 만든 것이 아니기 때문에 
FROM (SELECT EMP_ID, EMP_NAME, 
            12*SALARY*(1+NVL(BONUS,0)) AS "연봉",
             DEPT_CODE  --컬럼 이름들 중에 하나를 갖고와야 한다. 
      FROM EMPLOYEE)  --여기까지는 전체직원의 연봉 
WHERE 연봉 >= 30000000;

--인라인뷰 : 순위, 상위 몇개만 갖고 오시요 할 때 사용함 
--TOP-N 분석 상위에서 몇위만 갖고 오기 

--전직원중 급여가장 높은 상위 5명만 조회 
--ROWNUM :오라클에서 제공해주는 컬럼, 조회된 순서대로 1부터 부여해줌 
--       : WHERE 절에서 사용한다. 
--

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE;  --순서,  출력;

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY;

SELECT ROWNUM, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE ROWNUM <=5
ORDER BY SALARY;-- 순서대로는 나오지 않는다. 


--순서 하려면
--먼저 정렬을 (ORDER BY)한 테이블을 만드고 
--그 테이블에서 ROWNUM을 부여 하면 된다. 
SELECT *
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
      FROM EMPLOYEE
      ORDER BY SALARY DESC);


-------여기 위에 아래 체크 하기 ----------
--인라인 뷰의 모든 컬럼과 다른 컬럼(오라클에서 제공해 주는 컬럼)을 가져올 때 테이블에 별칭 부여 
SELECT ROWNUM,T.*
FROM (SELECT EMP_NAME, SALARY, DEPT_CODE
     FROM EMPLOYEE
     ORDER BY SALARY DESC) T
WHERE ROWNUM <-5;

--가장 최근에 입사한 사원 5명의 rownum, 사번, 사원명, 입사일 조회 
SELECT EMP_ID, EMP_NAME, HIRE_DATE
FROM (SELECT EMP_ID, EMP_NAME, HIRE_DATE
       FROM  EMPLOYEE
       ORDER BY HIRE_DATE DESC)
WHERE ROWNUM <=5;

--각 부서별 평균 급여가 높은 3개의 부서의 부서코드 , 평균급여 조회
SELECT *
FROM (SELECT DEPT_CODE, ROUND(AVG(SALARY))평균급여
      FROM EMPLOYEE
      GROUP BY DEPT_CODE 
      ORDER BY 평균급여 DESC)
      --ORDER BY 2 DESC  평균급여 대신에 2 넣어도 됨 
WHERE ROWNUM <=3;
------------------------------------------------------
/*
   6. WITH 
      서브쿼리에 이름을 붙여주고 인라인 뷰로 사용시 서브쿼리의 이름으로 
      FROM절에 기술을 해준다. 
      -장점: 
       1. 같은 서브 쿼리가 여러번 사용될 경우 중복 작성을 피할 수 있다
       2. 실행 속도도 빨라짐
   
*/  --테이블 이름은 내맘대로, FROM에 들어갈 것을 위로 땡겨서 기술
    --쓸일이 많지는 않다. 단점은. 여러번 쓸 수가 없다
    WITH TOPN_SAL1 AS(SELECT DEPT_CODE ,CEIL(AVG(SALARY)) AS "평균급여"
                      FROM EMPLOYEE
                      GROUP BY DEPT_CODE
                      ORDER BY 평균급여 DESC)
    
    SELECT*
    FROM TOPN_SAL1
    WHERE ROWNUM <=5;

------------------------------------------------------
/*
    7. 순위 매기는 함수(WINDOW FUNCTION)
    RANK() OVER(정렬기준) | DENSE_RAK() OVER(정렬기준) 
    -RANK() OVER(정렬기준): 동일한 순위 이후의 등수를 동일한 인원 수 만큼 건너뛰고 순위를 계산한다. 
                            EX) 공동  1순위가 3명이면 그 다음 순위는 4위
                            일반적으로는 RANK를 많이 쓴다. 
    -DENSE_RANK() OVER  (정렬기준)  : 동일한 순위가 있어도 다음 등수는 무조건 1씩 증가 
                            EX) 공동 1순위가 3명이면 그 다음 순위는 2위 
    >>두 함수는 SELECT 절에서만 사용 한다.                         
    
*/

--급여가 높은 순서대로 순위를 매겨서 사원명, 급여, 순위 조회
SELECT EMP_NAME, SALARY, RANK()OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE; --19위가 2개 그다음 21이 나온다. 

SELECT EMP_NAME, SALARY,DENSE_RANK()OVER(ORDER BY SALARY DESC) 순위
FROM EMPLOYEE; --19위가 2개지만 그다음 순위가 20위로 나온다.

--급여가 상위 5위까지 사원의 사원명, 급여, 순위 조회 
SELECT EMP_NAME, SALARY, RANK()OVER(ORDER BY SALARY DESC) AS "순위"
FROM EMPLOYEE;
-- (1) WHERE 순위 <=5;   해석 순서가 밀려서 안되서 에러 
-- (2) WHERE RANK()OVER(ORDER BY SALARY DESC);   셀렉트에서만 쓰 수 있어서 에러 , 윈도우 함수를 여기에 사용 불가  
-- ★★★ 이럴 때는 인라인 뷰가 답이다. 
-- ★★★ 인라인 뷰를 쓸 수 밖에 없다 
-- 해결 (1) 인라인뷰 사용시
SELECT *
FROM (SELECT EMP_NAME, SALARY, RANK()OVER(ORDER BY SALARY DESC) AS "순위"
      FROM EMPLOYEE)
WHERE 순위 <=5;
--해결 (2) WITH
WITH TOPN_SAL5 AS (SELECT EMP_NAME, SALARY, RANK()OVER(ORDER BY SALARY DESC) AS "순위"
      FROM EMPLOYEE)
SELECT 순위, EMP_NAME, SALARY
FROM TOPN_SAL5
WHERE 순위 <=5;
------------------------------------------------------







































