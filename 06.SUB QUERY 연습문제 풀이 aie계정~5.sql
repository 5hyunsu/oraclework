------------------------------------------------------
--06 연습문제 풀이 
-- 1. 70년대 생(1970~1979) 중 여자이면서 전씨인 사원의 이름과, 주민번호, 부서명, 직급명 조회    
    SELECT E.EMP_NAME, E.EMP_NO, D.DEPT_TITLE, J.JOB_NAME
    FROM EMPLOYEE E,
         DEPARTMENT D,
         JOB J
    WHERE 
        E.DEPT_CODE = D.DEPT_ID
        AND
        E.JOB_CODE = J.JOB_CODE
        AND
        SUBSTR(E.EMP_NO,1,2) BETWEEN '70' AND '79'
        AND 
        SUBSTR(E.EMP_NAME,1,1) = '전';
-- 1.PROF (ANSI버젼)
    SELECT EMP_NAME, EMP_NO, DEPT_TITLE, JOB_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
    JOIN JOB USING(JOB_CODE)
    WHERE 
        SUBSTR(EMP_NO,1,2)>=70 AND  SUBSTR(EMP_NO,1,2) <=79
        AND SUBSTR(EMP_NO,8,1)=2
        AND EMP_NAME LIKE '전%';
     
-- 2. 나이가 가장 막내의 사원 코드, 사원 명, 나이, 부서 명, 직급 명 조회
    SELECT EMP_NO, EMP_NAME, DEPT_TITLE, JOB_NAME
    FROM EMPLOYEE E,
         DEPARTMENT D,
         JOB J
    WHERE 
        E.DEPT_CODE = D.DEPT_ID
        AND
        E.JOB_CODE = J.JOB_CODE;
        AND
        MAX(SUBSTR(EMP_NO,1,2));
-- ★★★ 2.PROF ★★★
SELECT EMP_ID, 
       EMP_NAME, 
       EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))) AS "나이" ,
       DEPT_TITLE,
       JOB_NAME 
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
JOIN JOB USING(JOB_CODE)
WHERE EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR'))) =
    (SELECT MIN(EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO,1,2),'RR')))) FROM EMPLOYEE);

-- 나이
-- 올해의 년도 추출
-- EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(EXTO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
-- 주민번호 년도 추출  SUBSTR 문자에서 TODATE 숫자로
-- EXTRACT(YEAR FROM(EXTO_DATE(SUBSTR(EMP_NO,1,2),'RR')))
-- 나이 
--EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM(EXTO_DATE(SUBSTR(EMP_NO,1,2),'RR')))


-- 3. 이름에 ‘하’가 들어가는 사원의 사원 코드, 사원 명, 직급 조회
    SELECT EMP_NO, EMP_NAME, JOB_NAME
    FROM EMPLOYEE E,
         DEPARTMENT D,
         JOB J
    WHERE 
        E.DEPT_CODE = D.DEPT_ID
        AND
        E.JOB_CODE = J.JOB_CODE
        AND
        SUBSTR(EMP_NAME,1,1) = '하';
-- 3.PROF
    SELECT EMP_ID, EMP_NAME, JOB_NAME
    FROM EMPLOYEE E, JOB J
    WHERE   E.JOB_CODE = J.JOB_CODE
        AND EMP_NAME LIKE '%하%';
        
-- 4. 부서 코드가 D5이거나 D6인 사원의 사원 명, 직급, 부서 코드, 부서 명 조회
    SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
    FROM EMPLOYEE E,
         DEPARTMENT D,
         JOB J
    WHERE 
        E.DEPT_CODE = D.DEPT_ID
        AND
        E.JOB_CODE = J.JOB_CODE
        AND
        DEPT_CODE IN ('D5','D6');    
-- 4.PROF     
    SELECT EMP_NAME, JOB_NAME, DEPT_CODE, DEPT_TITLE
    FROM EMPLOYEE E,
         DEPARTMENT D,
         JOB J
    WHERE 
        E.DEPT_CODE = D.DEPT_ID
        AND
        E.JOB_CODE = J.JOB_CODE
        AND
        DEPT_CODE IN ('D5','D6'); 

-- 5. 보너스를 받는 사원의 사원 명, 보너스, 부서 명, 지역 명 조회
    SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
    FROM EMPLOYEE E,
         DEPARTMENT D,
         LOCATION L
    WHERE 
        E.DEPT_CODE = D.DEPT_ID
        AND
        D.LOCATION_ID = L.LOCAL_CODE
        AND
        BONUS IS NOT NULL;
--5. PROF
    SELECT EMP_NAME, BONUS, DEPT_TITLE, LOCAL_NAME
    FROM EMPLOYEE,
         DEPARTMENT,
         LOCATION
    WHERE DEPT_CODE=DEPT_ID
        AND 
          LOCAL_CODE=LOCATION_ID
        AND 
          BONUS IS NOT NULL;
    
-- 6. 사원 명, 직급, 부서 명, 지역 명 조회
    SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
    FROM EMPLOYEE E,
         JOB J,
         DEPARTMENT D,
         LOCATION L
    WHERE 
        E.DEPT_CODE = D.DEPT_ID
        AND
        D.LOCATION_ID = L.LOCAL_CODE
        AND
        E.JOB_CODE = J.JOB_CODE;
--6. PROF
SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, LOCAL_NAME
    FROM EMPLOYEE E,
         JOB J,
         DEPARTMENT D,
         LOCATION L
    WHERE 
        DEPT_CODE = DEPT_ID
        AND
        LOCATION_ID = LOCAL_CODE
        AND
        E.JOB_CODE = J.JOB_CODE;
-- 7. 한국이나 일본에서 근무 중인 사원의 사원 명, 부서 명, 지역 명, 국가 명 조회 
    SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
     FROM EMPLOYEE E,
          DEPARTMENT D,
          LOCATION L,
          NATIONAL N
    WHERE 
          E.DEPT_CODE = D.DEPT_ID
          AND
          D.LOCATION_ID = L.LOCAL_CODE
          AND
          L.NATIONAL_CODE = N.NATIONAL_CODE
          AND 
          N.NATIONAL_NAME IN ('한국','일본');
-- 7. PROF
    SELECT EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE)
    WHERE NATIONAL_NAME IN ('한국','일본');
    
-- 8. 하정연 사원과 같은 부서에서 일하는 사원의 이름 조회
    SELECT EMP_NAME
    FROM EMPLOYEE
    WHERE DEPT_CODE=(SELECT DEPT_CODE 
                FROM EMPLOYEE
                WHERE EMP_NAME='하정연')
        AND 
          EMP_NAME !='하정연';
-- 8. PROF    
    SELECT EMP_NAME, DEPT_CODE
    FROM EMPLOYEE
    WHERE DEPT_CODE = (SELECT DEPT_CODE
                        FROM EMPLOYEE
                        WHERE EMP_NAME = '하정연');
    
    
-- 9. 보너스가 없고 직급 코드가 J4이거나 J7인 사원의 이름, 직급, 급여 조회 (NVL 이용)
    SELECT EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE E 
    WHERE 
        BONUS IS NULL
        AND
        JOB_CODE IN ('J4','J7');
-- 9. PROF  NVL사용해서 완성해 보도록 하자. 
    SELECT EMP_NAME, JOB_CODE, SALARY
    FROM EMPLOYEE
    JOIN JOB USING(JOB_CODE)
    WHERE NVL(BONUS,0)=0
        AND JOB_CODE IN ('J4','J7');

   
-- 10. 퇴사 하지 않은 사람과 퇴사한 사람의 수 조회
    SELECT COUNT(ENT_YN) AS 퇴사하지 않은 사람 , COUNT(*)-
    COUNT(ENT_YN)
    FROM EMPLOYEE E
    WHERE
        ENT_YN ='N'; 
-- 10. PROF -- 그루핑 방법, 위에 컬럼 이름 짓기 주의 
    SELECT ENT_YN, COUNT(*)
    FROM EMPLOYEE
    GROUP BY ENT_YN;
        
-- 11. 보너스 포함한 연봉이 높은 5명의 사번, 이름, 부서 명, 직급, 입사일, 순위 조회
    SELECT *
    FROM  (SELECT EMP_ID, EMP_NAME, DEPT_CODE, HIRE_DATE, RANK()OVER(ORDER BY 12*SALARY*(1+NVL(BONUS,0)) DESC) AS "순위"
        FROM EMPLOYEE)
    WHERE 순위 <6;
SELECT *
FROM (SELECT DEPT_CODE, ROUND(AVG(SALARY))평균급여
      FROM EMPLOYEE
      GROUP BY DEPT_CODE 
      ORDER BY 평균급여 DESC)
     WHERE ROWNUM <=5;
     
-- 11. PROF
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, HIRE_DATE, 순위
        FROM(SELECT EMP_ID,
                    EMP_NAME, 
                    DEPT_TITLE, 
                    JOB_NAME, 
                    HIRE_DATE, 
                  --SALARY*(1+NVL(BONUS,0))*12
                    RANK()OVER(ORDER BY(SALARY*(1+NVL(BONUS,0))*12)DESC) 순위
            FROM EMPLOYEE E
            JOIN DEPARTMENT D ON (DEPT_CODE=DEPT_ID)
            JOIN JOB USING(JOB_CODE))
    WHERE  순위 <=5;            
        
-- 12. 부서 별 급여 합계가 전체 급여 총 합의 20%보다 많은 부서의 부서 명, 부서 별 급여 합계 조회
    SELECT  DEPT_CODE ,SUM(SALARY) AS "급여합"
    FROM EMPLOYEE E,
         DEPARTMENT D
    WHERE 
        DEPT_CODE=DEPT_ID
        AND 
        SUM(SALARY) 
   GROUP BY DEPT_CODE;
    
-- 12-1. JOIN과 HAVING 사용                
    SELECT D.DEPT_TITLE, SUM(SALARY) AS "급여합"
    FROM EMPLOYEE E,
         DEPARTMENT D
    HAVING 
         SUM(SALARY)*120 <= SUM(SALARY);
-- 12-1 PROF  그룹이 총합의 20% 넘느냐 
    SELECT DEPT_TITLE, SUM(SALARY)
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    GROUP BY DEPT_TITLE
    HAVING SUM(SALARY) > (SELECT SUM(SALARY)*0.2
                          FROM EMPLOYEE);
         
--12-2. 인라인 뷰 사용    
-- 12-2. PROF
    SELECT *
    FROM ( SELECT DEPT_TITLE, SUM(SALARY)부서급여합
          FROM EMPLOYEE
          JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
          GROUP BY DEPT_TITLE)  --위에와 비교해보면 여기까지는 동일 
    WHERE 부서급여합  > (SELECT SUM(SALARY)*0.2
                          FROM EMPLOYEE);
      

--	    12-3. WITH 사용
    WITH DEPT_TITLE  AS (SELECT SUM(SALARY), AVG(SALARY)
                         FROM EMPLOYEE)
    SELECT 
    FROM 
    WHERE ;
--  12-3. PROF
    WITH DEPTSUM AS ( SELECT DEPT_TITLE, SUM(SALARY) AS "부서급여합"
          FROM EMPLOYEE
          JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
          GROUP BY DEPT_TITLE)
    SELECT *   
    FROM DEPTSUM
    WHERE 부서급여합  > (SELECT SUM(SALARY)*0.2
                          FROM EMPLOYEE);
--유니온이나 마이너스 교집합 할때 셀렉트 2개씩 들어갈 때 
--WITH는 세미콜론 사용 전까지 사용 가능, 그 안에서만 재사용 가능 
      
          
-- 13. 부서명과 부서별 급여 합계 조회
    SELECT  DEPT_ID ,SUM(SALARY) AS "급여합"
    FROM EMPLOYEE E,
         DEPARTMENT D
    WHERE 
        DEPT_CODE=DEPT_ID
   GROUP BY DEPT_CODE;
-- 13. PROF
    SELECT DEPT_TITLE, SUM(SALARY)
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID) 
    --LEFT JOIN 까지 쓰면 NULL까지 나온다 
    GROUP BY DEPT_TITLE;
   
-- 14. WITH를 이용하여 급여 합과 급여 평균 조회
    WITH  SUM_SALARY, AVG_SALARY(SELECT SALARY)
    SELECT (SUM(SALARY), AVG(SALARY) FROM)
    WHERE; 
-- 14. PROF (합, 평균 테이블 2개)
--  1)
    WITH SUM_SAL AS(SELECT SUM(SALARY) 
                    FROM EMPLOYEE),
         AVG_SAL AS(SELECT CEIL(AVG(SALARY)) 
                    FROM EMPLOYEE)
    SELECT *
    FROM SUM_SAL,AVG_SAL;
-- 2) 
    WITH SUM_SAL AS(SELECT SUM(SALARY) 
                    FROM EMPLOYEE),
         AVG_SAL AS(SELECT CEIL(AVG(SALARY)) 
                    FROM EMPLOYEE)
    SELECT * FROM SUM_SAL
    UNION
    SELECT * FROM AVG_SAL;

