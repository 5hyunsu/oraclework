
/*
4. 교수들의 이름 중 성을 제외한 이름만 출력하는 SQL 문장을 작성하시오. 출력 헤더는
"이름” 이 찍히도록 한다. (성이 2자인 경우는 교수는 없다고 가정하시오)
*/

SELECT SUBSTR(PROFESSOR_NAME,2,2)  AS "성 제외 이름만"
FROM TB_PROFESSOR;

/*
5. 춘 기술대학교의 재수생 입학자를 구하려고 한다. 어떻게 찾아낼 것인가? 이때,
19살에 입학하면 재수를 하지 않은 것으로 간주한다.
*/
SELECT STUDENT_NO , STUDENT_NAME
FROM TB_STUDENT
WHERE ABS(SUBSTR(ENTRANCE_DATE,1,4)-1900-SUBSTR(STUDENT_SSN,1,2)) > 19;

/*
6. 2020 년 크리스마스는 무슨 요일인가?
*/
SELECT TO_CHAR((SELECT TO_DATE(20201225) FROM DUAL), 'DAY')       
    FROM DUAL;  --금요일

/*
7. TO_DATE('99/10/11','YY/MM/DD'), TO_DATE('49/10/11','YY/MM/DD') 은 각각 몇 년 몇
월 몇 일을 의미할까? 또 TO_DATE('99/10/11','RR/MM/DD'),
TO_DATE('49/10/11','RR/MM/DD') 은 각각 몇 년 몇 월 몇 일을 의미할까?
*/
SELECT TO_DATE('99/10/11','YY/MM/DD') FROM DUAL;  --2099년 10월 11일
SELECT TO_DATE('49/10/11','YY/MM/DD') FROM DUAL;  --2049년 10월 11일
SELECT TO_DATE('99/10/11','RR/MM/DD') FROM DUAL;  --1999년 10월 11일
SELECT TO_DATE('49/10/11','RR/MM/DD') FROM DUAL;  --2049년 10월 11일 

/* 
8. 춘 기술대학교의 2000 년도 이후 입학자들은 학번이 A로 시작하게 되어있다. 2000 년도
이전 학번을 받은 학생들의 학번과 이름을 보여주는 SQL 문장을 작성하시오.
*/

SELECT STUDENT_NO AS 학번, STUDENT_NAME AS 이름
FROM TB_STUDENT
WHERE  NOT SUBSTR(STUDENT_NO,1,1) = 'A';

/*
9. 학번이 A517178 인 한아름 학생의 학점 총 평점을 구하는 SQL 문을 작성하시오. 단,
이때 출력 화면의 헤더는 "평점" 이라고 찍히게 하고, 점수는 반올림하여 소수점 이하
한자리까지만 표시한다.
*/

SELECT ROUND(AVG(POINT),1) 평점
FROM  TB_GRADE
WHERE STUDENT_NO='A517178';

/*
10. 학과별 학생수를 구하여 "학과번호", "학생수(명)" 의 형태로 헤더를 만들어
결과값이 출력되도록 하시오.
*/

SELECT DEPARTMENT_NO AS "학과번호", COUNT(DEPARTMENT_NO)"학생수(명)"
FROM TB_STUDENT
GROUP BY DEPARTMENT_NO 
ORDER BY DEPARTMENT_NO;

/*
11. 지도 교수를 배정받지 못한 학생의 수는 몇 명 정도 되는 알아내는 SQL 문을
작성하시오.
*/
SELECT COUNT(STUDENT_NAME)
FROM TB_STUDENT
WHERE COACH_PROFESSOR_NO IS NULL;

/*
12. 학번이 A112113 인 김고운 학생의 년도 별 평점을 구하는 SQL 문을 작성하시오. 단,
이때 출력 화면의 헤더는 "년도", "년도 별 평점" 이라고 찍히게 하고, 점수는 반올림하여
소수점 이하 한 자리까지만 표시한다.
*/
SELECT SUBSTR(TERM_NO,1,4) AS 년도, ROUND(AVG(POINT),1) "년도 별 평점"
FROM  TB_GRADE
WHERE STUDENT_NO='A112113'
GROUP BY SUBSTR(TERM_NO,1,4) 
ORDER BY SUBSTR(TERM_NO,1,4);

/*------(미완성) 0이 출력이 안됨 ---------------
13. 학과 별 휴학생 수를 파악하고자 한다. 학과 번호와 휴학생 수를 표시하는 SQL 문장을
작성하시오.
*/
-- 휴학생 수가 없는 학과는 출력이 되지 않는다. DECODE 함수의 차이 
SELECT DEPARTMENT_NO AS 학과번호, COUNT(ABSENCE_YN) AS 휴학생수
FROM TB_STUDENT
WHERE ABSENCE_YN = 'Y'
GROUP BY DEPARTMENT_NO
ORDER BY DEPARTMENT_NO;

--13. PROF  : 휴학생 수가 0이여도 출력 된다.  위와의 차이점 구분 
SELECT DEPARTMENT_NO 학과번호, COUNT(DECODE(ABSENCE_YN, 'Y',1)) "휴학생 수"
   FROM TB_STUDENT
 GROUP BY DEPARTMENT_NO
 ORDER BY 학과번호;


/* ---------------
14. 춘 대학교에 다니는 동명이인(同名異人) 학생들의 이름을 찾고자 한다. 어떤
SQL 문장을 사용하면 가능하겠는가?
*/
--SOL1
SELECT STUDENT_NAME AS 동일이름,
      COUNT(*) AS 동명인수
FROM TB_STUDENT
GROUP BY STUDENT_NAME
HAVING COUNT(STUDENT_NAME)>1
ORDER BY STUDENT_NAME;

--SOL2 
SELECT STUDENT_NAME AS 동일이름,
      COUNT(*) OVER (PARTITION BY STUDENT_NAME) AS 동명인수
FROM TB_STUDENT;
--GROUP BY STUDENT_NAME;
--HAVING COUNT(STUDENT_NO)>1
--ORDER BY STUDENT_NAME;




/* -----(미완성)--누적합 X -----------
15. 학번이 A112113 인 김고운 학생의 년도, 학기 별 평점과 년도 별 누적 평점, 총
평점을 구하는 SQL 문을 작성하시오. (단, 평점은 소수점 1자리까지만
반올림하여 표시한다.)
*/
SELECT SUBSTR(TERM_NO,1,4) AS 년도,SUBSTR(TERM_NO,5,2) AS 학기, ROUND(POINT,1) AS 평점
FROM TB_GRADE
WHERE STUDENT_NO='A112113'
CONNECT BY PRIOR 학기 = 년도;





