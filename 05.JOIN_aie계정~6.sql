/*
    <JOIN>
    
    2개 이상의 테이블에서 데이터를 조회하고자 할 때 사용되는 구문 
    조회결과 하나의 결과물(RESULT SET)로 나옴 
    RESULTS SET
    
    관계형 데이터베이스는 최소한 데이터로 각각 테이블에 담고 있음 
    (중복을 최소화 하기 위해서 최대한 나누어서 관리)
    
    =>관계형 데이터베이스에서 SQL 문을 이용한 테이블간의 '관계'를 맺는 방법
    
    JOIN은 크기 "오라클 전용구문"과 "ANSI 구문"(ANSI=미국 국립표준 협회) 
    오라클에서는 2개 모두 사용 가능 
    
                      [용어 정리]
    오라클 전용구문         |       ANSI
-------------------------------------------------------------
    등가조인               |      내부조인(INEER JOIN) =>JOIN USING/ON
 (EQUAL JOIN)             |      자연조인(NATURAL JOIN) =>JOIN USING
-------------------------------------------------------------    
    포괄조인               |      왼쪽 외부 조인(LEFT OUTER JOIN)->JOIN USING/ON
  (LEFT OUTER)            |      오른쪽 외부 조인(RIGHT OUTER JOIN)
  (RIGHT OUTER)           |      전체 외부 조인(FULL OUTER JOIN)
-------------------------------------------------------------
  자체 조인 (SELF JOIN)    |      JOIN ON
  비등가조인( NON EQUL JOIN)|     
-------------------------------------------------------------     
 카테시안 곱(CARTESIAN PPRODUCT)|   교차 조인 (CROSS JOIN)
-------------------------------------------------------------

*/
--전체사원들의 사번, 사원명, 부서명, 부서코드. 부서명을 조회 

1번
SELECT EMP_ID, EMP_NAME, DEPT_CODE
FROM EMPLOYEE;
2번
SELECT DEPT_ID, DEPT_TITLE
FROM DEPARTMET;

1번 2번을 합쳐야 한다. 
두개 테이블을 합쳐서 사용해야 한다. 이럴 때 JOIN 사용 


-------------------------------------------------------------
/*
    1.등가조인(EQUAL JOIN)/ 내부조인(INNER JOIN)
      연결시키고자 하는 컬럼 값이 "일치하는 행"들만 조인 되어 조회
      (=일치하는 값이 없으면 조회 제외 
      
      -->>오라클 전용 구문 
      FROM에 조회하고자 하는 테이블들을 나열 (,구분자로)
      WHERE절에 매칭 시킬 컬럼(연결고리)에 대한 조건을 제시함 
       
*/
--(1) 연결할 두 컬럼명이 다른 경우(EMPLOYEE:DEPT_CODE, DEPARTMENT:DEPT_ID)
-- 전체사원들의 사번, 사원명, 부서명, 부서코드. 부서명을 조회 
-- DEPT_CODE와 DEPT_ID가 동일하나 컬럼명은 다른경우
SELECT EMP_ID, EMP_NAME, DEPT_CODE,DEPT_TITLE  
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE = DEPT_ID;
-- 일치하는 값이 없는 행은 조회에서 제외(NULL값 제외) 
--현정보,선우정보는 부서가 없어서 제외

--(2) 연결할 두 컬럼명이 같은 경우(EMPLOYEE:JOB_CODE, JOB:JOB_CODE)
--전체 사원들의 사번, 사원명, 직급코드, 직급명 조회 
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE; JOB
--WHERE JOB_CODE=JOB_CODE;  --오류남
--ORA-00918: 열의 정의가 애매합니다
--컬럼의 정의가 애매하다. 
--해결방법 
--1) 테이블 명을 이용하는 방법 
SELECT EMP_ID, EMP_NAME, EMPLOYEE.JOB_CODE, JOB_NAME
FROM EMPLOYEE, JOB
WHERE EMPLOYEE.JOB_CODE = JOB.JOB_CODE;

--2) 테이블에 별칭을 부여하여 이용하는 방법 
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE = J.JOB_CODE;

 -->> ANSI 구문 
 /*
    FROM에 기준이 되는 테이블을 하나만 기술
    JOIN절에 같이 조회하고자 하는 테이블을 기술
        + 매칭시킬 컬럼에 대한 조건도 기술
     -JOIN 테이블명 USING 컬럼, JOIN 테이블명 ON (컬럼1=컬럼2)
    WHERE절에 매칭시킬 컬럼(연결고리)에 대한 조건 제시함
  */
  
--(1) 연결할 두 컬럼명이 다른 경우(EMPLOYEE:DEPT_CODE, DEPARTMENT:DEPT_ID)
--  ★★★JOIN ON으로'만' 사용 가능
--전체사원들의 사번, 사원명, 부서명, 부서코드. 부서명을 조회 
-- DEPT_CODE와 DEPT_ID가 동일하나 컬럼명은 다른경우
SELECT EMP_ID, EMP_NAME, DEPT_CODE, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);

--(2) 연결할 두 컬럼명이 같은 경우(EMPLOYEE:JOB_CODE, JOB:JOB_CODE)
-- JOIN ON, JOIN USING 둘다 사용 가능 
--전체 사원들의 사번, 사원명, 직급코드, 직급명 조회 
--SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
--FROM EMPLOYEE
--JOIN JOB ON (JOB_CODE= JOB_CODE); 이렇게 하면 오류

--해결방법 1) 테이블 별칭 사용
SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE); --이와같이 테이브 별칭 같이 써줘야한다.

SELECT EMP_ID, EMP_NAME, E.JOB_CODE, JOB_NAME
FROM EMPLOYEE E
JOIN JOB J ON (E.JOB_CODE=J.JOB_CODE);

--해결방법 2) JOIN USING 구문을 사용하는 방법(두 컬럼명이 일치할 떄만 사용가능)
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE);

--WHERE 오라클 , JOIN ANSI

--[참고사항]
--자연조인(NATURAL JOIN): 각 테이블 마다 동일한 컬럼이 한개만 존재할 경우
SELECT EMP_ID, EMP_NAME, JOB_CODE, JOB_NAME
FROM EMPLOYEE
NATURAL JOIN JOB; 
--어떤 컬럼인지 쓰지 않아도 (이름이 어차피 한개만 동일하기


--3)추가적인 조건도 제시가능 
--직급이 ' 대리'인 사원의 사번, 사원명, 직급명, 급여 조회
-->>오라클 전용 구문 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE E, JOB J
WHERE E.JOB_CODE =J.JOB_CODE
    AND
      JOB_NAME='대리';
------------------------------------------------------------------------------------------------------------------------------------------------------------------
-->>ANSI 구문 
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME='대리'; --순서는 상관없다

--------------------<실습문제>-------------------------------------------------------------------------------------------------------------------------------------------
--1.부서가 인사관리부인 사원의 사번, 이름, 부서명, 보너스 조회
-->>오라클 구문 전용
SELECT  EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE E, DEPARTMENT D
WHERE D.DEPT_TITLE='인사관리부';
--PROF
SELECT  EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE, DEPARTMENT 
WHERE DEPT_CODE=DEPT_ID
    AND DEPT_TITLE='인사관리부';

-->>ANSI 구문
--PROF
SELECT  EMP_ID, EMP_NAME, DEPT_TITLE, BONUS
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
WHERE DEPT_TITLE='인사관리부';

--2.DEPARTMENT와 LOCATION을 참고하여 전체 부서의 부서코드, 부서명, 지역코드, 지역명 조회 
-->>오라클 구문 전용 
SELECT DEPT_ID, DEPT_TITLE, LOCAL_CODE,LOCAL_NAME
FROM DEPARTMENT 
JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE);
--오라클 PROF
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT, LOCATION
WHERE LOCATION_ID=LOCAL_CODE;
-->>ANSI 구문
--ANSI PROF
SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID, LOCAL_NAME
FROM DEPARTMENT
JOIN LOCATION ON( LOCATION_ID=LOCAL_CODE);

-- 3. 보너스를 받는 사원들의 사번, 사원명, 보너스, 부서명 조회
-- >> 오라클 구문 전용
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--오라클 PROF 9인데 DEPT가 NULL이라 8로 나온다. 
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID
    AND BONUS IS NOT NULL;
    
-- >> ANSI 구문
--ANSI PROF
SELECT EMP_ID, EMP_NAME, BONUS, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
WHERE BONUS IS NOT NULL;

-- 4. 부서가 총무부가 아닌 사원들의 사원명, 급여, 부서명 조회
-- >> 오라클 구문 전용
--오라클 PROF
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE=DEPT_ID
    AND DEPT_TITLE !='총무부';

-- >> ANSI 구문
--ANSI PROF
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_TITLE
FROM EMPLOYEE
JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
WHERE DEPT_TITLE !='총무부';

------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
    2.포괄조인/ 외부조인(OUTER JOIN)
    두 테이블간의 JOIN시 일치하지 않는 행도 포함시켜 조회
    NULL값도 나온다. 
    단, 반드시 LEFT/RIGHT 를 지정 해야 됨(기준이 되는 테이블 지정)
    
*/
--사원명, 부서명, 급여, 연봉 
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--내부조인시 부서가 없는 2명은 나오지 않음 -- 21명
--BUT,나는 전체 23명 나오게 하고 싶음

--1) LEFT[OUTER] JOIN : 두 테이블 중 왼쪽에 기술된 테이블이 기준으로 JOIN
-->>ANSI 구문 
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
LEFT OUTER JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--부서배치가 안된 사원도 조회된다.
--OUTER는 안써도 되고 써도 되고 안쓰는게 일반적

-->>오라클 전용 구문 
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE(+)= DEPT_ID;  --이 경우 부서가 EMP_NAME이 NULL값으로 이름없이 부서명만 나오기도 한다.
--기준이 아닌 테이블의 컬럼명 뒤에 (+)를 붙여준다. 
--EMPLOYEE가 기준인데 그거 반대편인 DEPT_ID(DEPARTMENT)플러스표시
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE= DEPT_ID(+); --이 경우 EMPLOYEE가 기준이 되서 EMP_NAME이 NULL값으로 나오지 않는다.


--1) RIGHT[OUTER] JOIN : 두 테이블 중 오른쪽에 기술된 테이블이 기준으로 JOIN
-->>ANSI 구문 
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
RIGHT JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--국내영업부, 마케팅 사람 없는데도 나옴 
-인원수 보다 더 나온다

-->>오라클 전용 구문 
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE(+)=DEPT_ID;--이름 샐러리 안뜨는것

SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE,DEPARTMENT
WHERE DEPT_CODE=DEPT_ID(+); --부서명 안뜨는것


--3) FULL[OUTER] JOIN : 두 테이블에 기술된 모든 행을 조회(오라클 전용 없음)

SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID);
--DEPT_CODE=DEPT_ID 두개 자리를 뒤바뀌어도 값이 똑같이 나온다. 
SELECT EMP_NAME, DEPT_TITLE, SALARY, SALARY*12
FROM EMPLOYEE
FULL JOIN DEPARTMENT ON (DEPT_ID=DEPT_CODE);
------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
    3.비등가 조인 (NON EQUAL JOIN)
    매칭시킬 컬럼에 대한 조건 작성시 '='(등호)를 사용하지 않는 JOIN문
    ANSI구문으로는 JOIN ON으로만 가능 
   
*/
--사원명, 급여, 급여레벨 조회 
-->>오라클 주문 
    SELECT EMP_NAME, SALARY, SAL_LEVEL
    FROM EMPLOYEE, SAL_GRADE
--1번방법 :WHERE SALARY >=MIN_SAL AND SALARY <=MAX_SAL;
    WHERE SALARY BETWEEN MIN_SAL AND MAX_SAL; --2번방법 : 등호 쓰지않고 

-->>ANSI 구문
    SELECT EMP_NAME, SALARY, SAL_LEVEL
    FROM EMPLOYEE
    JOIN SAL_GRADE ON (SALARY BETWEEN MIN_SAL AND MAX_SAL);

/*
    4. 자체 조인(SELF JOIN)
    EMPLOYEE 테이블에서 사수의 아이디를 다시 EMPLOYEE자체에서 갖고와야 하기 때문
    같은 테이블을 다시 한번 조인하는 경우 
    
    사수가 있는 사원의 사번, 사원명, 직급코드 =>EMPLOYEE
              사수의 사번, 사원명, 직급코드 =>EMPLOYEE
        
*/
-->>오라클 주문 
    SELECT E.EMP_ID,E.EMP_NAME,E.DEPT_CODE,
           M.EMP_ID,M.EMP_NAME,M.DEPT_CODE
    FROM EMPLOYEE E, EMPLOYEE M --똑같은 테이블이 2개라 구분되게 별칭 써준다.
    WHERE E.MANAGER_ID=M.EMP_ID;
--원래직원E, 사수는M

-->>ANSI 구문
    SELECT E.EMP_ID,E.EMP_NAME,E.DEPT_CODE,
           M.EMP_ID,M.EMP_NAME,M.DEPT_CODE
    FROM EMPLOYEE E
    JOIN EMPLOYEE M  ON (E.MANAGER_ID=M.EMP_ID);

--모든 사원의 사원, 사원명, 직급코드 정보를 갖고 오고 싶다. =>EMPLOYEE
--           사수의 사번, 사원명, 직급코드 =>EMPLOYEE
-->>오라클 주문 
    SELECT E.EMP_ID,E.EMP_NAME,E.DEPT_CODE,
           M.EMP_ID,M.EMP_NAME,M.DEPT_CODE
    FROM EMPLOYEE E, EMPLOYEE M
    WHERE E.MANAGER_ID= M.EMP_ID(+);  --사수가 없어도 출력

-->>ANSI 구문
    SELECT E.EMP_ID,E.EMP_NAME,E.DEPT_CODE,
           M.EMP_ID,M.EMP_NAME,M.DEPT_CODE
    FROM EMPLOYEE E
    LEFT JOIN EMPLOYEE M  ON (E.MANAGER_ID=M.EMP_ID); --사수가 없어도 출력



------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
    <다중 JOIN>
    2개 이상의 테이블을 JOIN 
    3개 테이블을 조인 , 

*/
--모든 사원의 사번, 사원명, 부서명, 직급명 조회 

/*                  가져올 컬럼명            조인될 컬럼명
    EMPLOYEE => EMP_ID,  EMP_NAME  |   DEPT_CODE    JOB_CODE
    DEPARTMENT =>      DEPT_TITLE  |   DEPT_ID 
    JOB =>             JOB_NAME    |                JOB_CODE
                                      컬럼명 다름 /   컬럼명 같음  (1) 어느테이블 컬럼인지 명시 OR (2)별칭 이용
*/
-->>오라클 주문
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME
    FROM EMPLOYEE E, 
        DEPARTMENT D,
        JOB J
    WHERE DEPT_CODE=DEPT_ID
          AND
        E.JOB_CODE=J.JOB_CODE;

-->>ANSI 구문
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
    FROM EMPLOYEE 
    JOIN DEPARTMENT  ON(DEPT_CODE=DEPT_ID) --ON: 테이블 별칭 써줘야
    JOIN JOB  USING(JOB_CODE);
    
    SELECT E.EMP_ID, E.EMP_NAME, D.DEPT_TITLE, J.JOB_NAME
    FROM EMPLOYEE E
    JOIN DEPARTMENT D ON(DEPT_CODE=DEPT_ID) --ON: 테이블 별칭 써줘야
    JOIN JOB J USING(JOB_CODE);

--사원의 사번, 사원명, 부서명,지역명 조회 
-->>오라클 주문
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L   --다 다르기 때문에 별칭 붙여넣으면 된다.
    WHERE E.DEPT_CODE =D.DEPT_ID
        AND
        D.LOCATION_ID=L.LOCAL_CODE;
/*                  가져올 컬럼명            조인될 컬럼명
    EMPLOYEE => EMP_ID,  EMP_NAME  |    E.DEPT_CODE    
    DEPARTMENT =>      DEPT_TITLE  |    D.DEPT_ID    D.LOCATION_ID
    LOCATION =>      LOCAL_NAME    |                 L.LOCAL_CODE
                                     컬럼명 다름 /   컬럼명 같음  (1) 어느테이블 컬럼인지 명시 OR (2)별칭 이용
*/

-->>ANSI 구문
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME
    FROM EMPLOYEE
    JOIN DEPARTMENT ON(DEPT_CODE=DEPT_ID)
    JOIN LOCATION ON(LOCATION_ID=LOCAL_CODE);
--이름다르면 USING 사용 못한다. 
--지금 처럼 다 다르면 온 사용해서 표현한다. 

---------------------실습 문제---------------------------------------------------------------------------------------------------------------------------------------------
--1. 사번, 사원명, 부서명,지역명, 국가명 조회 (EMPLOYEE, DEPARTMENT, LOCATION, NATIONAL조인
-->>오라클 구문 
    SELECT EMP_ID 사번 , EMP_NAME 사원명, DEPT_TITLE 부서명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명
    FROM EMPLOYEE E, DEPARTMENT D, LOCATION L, NATIONAL N
    WHERE E.DEPT_CODE = D.DEPT_ID
        AND --이름이 다르면 명칭 붙인 걸로 표시 안해도 괜찮다.
          D.LOCATION_ID = L.LOCAL_CODE
        AND --이름 동일하면 명칭 붙여서 구분 표시 
          L.NATIONAL_CODE = N.NATIONAL_CODE;

/*                  가져올 컬럼명            조인될 컬럼명
    EMPLOYEE => EMP_ID,  EMP_NAME  |    E.DEPT_CODE    
    DEPARTMENT =>      DEPT_TITLE  |    D.DEPT_ID    D.LOCATION_ID
    LOCATION => LOCAL_NAME,        |                 L.LOCAL_CODE    L.NATIONAL_CODE
    NATIONAL => NATIONAL_NAME      |                                 N.NATIONAL_CODE
                                     컬럼명 다름 /   컬럼명 같음  (1) 어느테이블 컬럼인지 명시 OR (2)별칭 이용
*/  
    
-->>ANSI 구문
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, LOCAL_NAME, NATIONAL_NAME
        FROM EMPLOYEE
    JOIN DEPARTMENT ON DEPT_CODE=DEPT_ID
    JOIN LOCATION ON LOCATION_ID=LOCAL_CODE
    JOIN NATIONAL USING(NATIONAL_CODE);  --컬럼명 같으면 유징사용

--2. 사번, 사원명, 부서명, 직급명, 지역명, 국가명, 급여등급 조회 (모든 테이블 다 조인)
-->>오라클 구문 
/*                  가져올 컬럼명            조인될 컬럼명
    EMPLOYEE => EMP_ID,  EMP_NAME  |    E.DEPT_CODE                                     E.JOB_CODE   E.SALARY
    DEPARTMENT =>      DEPT_TITLE  |    D.DEPT_ID    D.LOCATION_ID
    LOCATION => LOCAL_NAME,        |                 L.LOCAL_CODE    L.NATIONAL_CODE
    NATIONAL => NATIONAL_NAME      |                                 N.NATIONAL_CODE
    JOB      => JOB_NAME           |                                                   J.JOB_CODE
    SALARY   => SAL_LEVEL          |                                                              MIN_SAL/MAX_SAL
                                     컬럼명 다름 /   컬럼명 같음  (1) 어느테이블 컬럼인지 명시 OR (2)별칭 이용
*/ 
    SELECT EMP_ID 사번, EMP_NAME 사원명, DEPT_TITLE 부서명, JOB_NAME 직급명, LOCAL_NAME 지역명, NATIONAL_NAME 국가명, SAL_LEVEL 급여내역
    FROM EMPLOYEE E, 
         DEPARTMENT D,
         LOCATION L, 
         NATIONAL N, 
         JOB J, 
         SAL_GRADE S
    WHERE E.DEPT_CODE = D.DEPT_ID
    AND
      D.LOCATION_ID = L.LOCAL_CODE
    AND
           
    AND
      E.JOB_CODE = J.JOB_CODE
    AND
      E.SALARY BETWEEN MIN_SAL AND MAX_SAL;
*/
-->>ANSI 구문
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME, LOCAL_NAME, NATIONAL_NAME, SAL_LEVEL
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE=DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID=LOCAL_CODE)
    JOIN NATIONAL USING(NATIONAL_CODE)
    JOIN JOB USING (JOB_CODE)
    JOIN SAL_GRADE ON(SALARY BETWEEN MIN_SAL AND MAX_SAL);
    






















