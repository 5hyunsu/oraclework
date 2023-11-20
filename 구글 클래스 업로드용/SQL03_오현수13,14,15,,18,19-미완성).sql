/*
    1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고, 
정렬은 이름으로 오름차순 표시하도록 한다. 
*/
    SELECT STUDENT_NAME AS "학생 이름" , STUDENT_ADDRESS AS "주소지"
    FROM TB_STUDENT
    ORDER BY STUDENT_NAME ASC;

/*
    2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오. 
*/
    SELECT STUDENT_NAME, STUDENT_SSN
    FROM TB_STUDENT
    WHERE ABSENCE_YN='Y'
    --★ ORDER BY EXTRACT(YEAR FROM SYSDATE)-(19||SUBSTR(STUDENT_SSN,1,2)); 년은 되는데 월이 안됨
    ORDER BY SUBSTR(STUDENT_SSN,1,6) DESC;

/*
    3.주소지가 강원도나 경기도인 학생들 중 1900 년대 학번을 가진 학생들의 이름과 학번, 
    주소를 이름의 오름차순으로 화면에 출력하시오. 단, 출력헤더에는 "학생이름","학번", 
    "거주지 주소" 가 출력되도록 한다. 
*/
    SELECT STUDENT_NAME AS "학생이름" ,STUDENT_NO AS "학번" , STUDENT_ADDRESS AS "거주지 주소" 
    FROM TB_STUDENT
    WHERE 
        SUBSTR(STUDENT_ADDRESS,1,3) IN ('경기도','강원도')
        AND
        SUBSTR(STUDENT_NO,1,1)='9'
    ORDER BY STUDENT_ADDRESS ASC; --★ PDF 결과 화면이 오름차순이 안되어 있어서 결과 값이 다르게 나옴

/*
    4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인할 수 있는 SQL 문장을 
    작성하시오. (법학과의 '학과코드'는 학과 테이블(TB_DEPARTMENT)을 조회해서 찾아 
    내도록 하자)
*/
    SELECT PROFESSOR_NAME, PROFESSOR_SSN
    FROM TB_PROFESSOR
    WHERE DEPARTMENT_NO
        =(SELECT DEPARTMENT_NO FROM TB_DEPARTMENT WHERE DEPARTMENT_NAME='법학과')
    ORDER BY EXTRACT(YEAR FROM SYSDATE)-(19||SUBSTR(PROFESSOR_SSN,1,2)) DESC;
         
/*
    5. 2004 년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다. 학점이 
    높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는 구문을 
    작성해보시오. 
*/
    SELECT STUDENT_NO, TO_CHAR((POINT),'FM9.00') AS POINT
    FROM TB_GRADE 
    WHERE 
        CLASS_NO='C3118100'
      AND 
        TERM_NO='200402'
    ORDER BY POINT DESC,    
             SUBSTR(STUDENT_NO,2,6) ASC;

/*
    6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는 SQL 
    문을 작성하시오. (컬럼명 동일할 때)
*/  --(1)
    SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
    FROM TB_STUDENT T
    JOIN TB_DEPARTMENT ON (T.DEPARTMENT_NO=TB_DEPARTMENT.DEPARTMENT_NO)
    ORDER BY STUDENT_NAME ASC;
    --(2)
    SELECT STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
    FROM TB_STUDENT T
    JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    ORDER BY STUDENT_NAME ASC;

/*
    7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오. 
*/
    SELECT CLASS_NAME, DEPARTMENT_NAME
    FROM TB_DEPARTMENT
    JOIN TB_CLASS USING (DEPARTMENT_NO)
    ORDER BY DEPARTMENT_NAME ASC;

/*
    8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는 SQL 문을 
    작성하시오.  -3개 테이블 2개씩 컬럼명 동일할 경우 
*/
    SELECT CLASS_NAME, PROFESSOR_NAME
    FROM TB_PROFESSOR
    JOIN TB_CLASS_PROFESSOR USING (PROFESSOR_NO)
    JOIN TB_CLASS USING (CLASS_NO);
        
/*  
    9. 8번의 결과 중 ‘인문사회' 계열에 속한 과목의 교수 이름을 찾으려고 한다. 이에 
    해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오. 
*/
    SELECT CLASS_NAME, PROFESSOR_NAME
    FROM TB_PROFESSOR P,
         TB_CLASS C,
         TB_DEPARTMENT D
    WHERE 
        P.DEPARTMENT_NO = D.DEPARTMENT_NO
        AND
        D.DEPARTMENT_NO = C.DEPARTMENT_NO 
        AND
        D.CATEGORY = '인문사회';
    -- ★ ORDER BY C.CLASS_NAME, P.PROFESSOR_NAME;  숫자가 들어가서 오름차순적용시 숫자가 먼저온다

/*  
    10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름", 
    "전체 평점"을 출력하는 SQL 문장을 작성하시오. (단, 평점은 소수점 1자리까지만 
    반올림하여 표시한다.)
*/
    SELECT S.STUDENT_NO AS "학번", S.STUDENT_NAME AS "학생이름", ROUND(AVG(G.POINT),1) AS "전체 평점"
    FROM TB_STUDENT S,
        TB_GRADE G,
        TB_DEPARTMENT D
    WHERE 
        S.DEPARTMENT_NO=D.DEPARTMENT_NO
        AND
        S.STUDENT_NO=G.STUDENT_NO
        AND
        D.DEPARTMENT_NAME='음악학과'
    GROUP BY (S.STUDENT_NO,S.STUDENT_NAME)
    ORDER BY S.STUDENT_NO;
        
/*  
    11. 학번이 A313047 인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기 
    위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용할 SQL 문을 
    작성하시오. 단, 출력헤더는 “학과이름”, “학생이름”, “지도교수이름”으로 
    출력되도록 한다. 
*/
    SELECT D.DEPARTMENT_NAME AS "학과이름", S.STUDENT_NAME AS "학생이름" , P.PROFESSOR_NAME AS "지도교수이름"
    FROM TB_PROFESSOR P,
         TB_STUDENT S,
         TB_DEPARTMENT D
    WHERE 
        P.PROFESSOR_NO=S.COACH_PROFESSOR_NO
        AND
        S.DEPARTMENT_NO=D.DEPARTMENT_NO
        AND
        S.STUDENT_NO='A313047';
                        
/*  
    12. 2007 년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생이름과 수강학기름 표시하는 
    SQL 문장을 작성하시오. 
*/
    SELECT S.STUDENT_NAME, G.TERM_NO AS "TERM_NAME" 
    FROM TB_STUDENT S,
        TB_CLASS C,
        TB_GRADE G
    WHERE 
        G.STUDENT_NO=S.STUDENT_NO
        AND
        G.CLASS_NO=C.CLASS_NO
        AND    
        SUBSTR(G.TERM_NO,1,4)='2007'
        AND
        C.CLASS_NAME='인간관계론'
    ORDER BY S.STUDENT_NAME ASC;

/*  -----★★★미완성★★----
    13. 예체능 계열 과목 중 과목 담당교수를 한 명도 배정받지 못한 과목을 찾아 그 과목 
    이름과 학과 이름을 출력하는 SQL 문장을 작성하시오. 
*/  SELECT C.CLASS_NAME, D.DEPARTMENT_NAME
    FROM TB_DEPARTMENT D,
         TB_CLASS C,
         TB_CLASS_PROFESSOR R
    WHERE 
        D.DEPARTMENT_NO = C.CLASS_NO
        AND
        R.CLASS_NO = C.CLASS_NO
        AND 
        D.CATEGORY='예체능'
        AND
        C.CLASS_NO (SELECT  R.CLASS_NO;
   --13.prof
   SELECT CLASS_NAME, DEPARTMENT_NAME
    FROM TB_CLASS
    LEFT JOIN TB_CLASS_PROFESSOR USING(CLASS_NO)
    LEFT JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
    WHERE CATEGORY = '예체능'
    AND PROFESSOR_NO IS NULL;
        
        
/*  ★ NVL 적용했는데 지도교수 미지정이 안나옴
    14. 춘 기술대학교 서반아어학과 학생들의 지도교수를 게시하고자 한다. 학생이름과 
    지도교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도교수 미지정”으로 
    표시하도록 하는 SQL 문을 작성하시오. 단, 출력헤더는 “학생이름” 지도교수"로 
    표시하며 고학번 학생이 먼저 표시되도록 한다. 
*/
    SELECT STUDENT_NAME AS "학생이름", NVL(PROFESSOR_NAME,'지도교수없음')AS "지도교수"
    FROM TB_STUDENT S,
         TB_DEPARTMENT D,
         TB_PROFESSOR P
    WHERE 
        S.DEPARTMENT_NO = D.DEPARTMENT_NO
        AND
        S.COACH_PROFESSOR_NO = P.PROFESSOR_NO
        AND
        D.DEPARTMENT_NAME='서반아어학과';
 
/*  ★ 따로는 나오는데 안에 넣으면 작동 안됨 
    15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름, 학과 
    이름, 평점을 출력하는 SQL 문을 작성하시오. 
*/
    SELECT S.STUDENT_NO AS "학번",
           S.STUDENT_NAME AS "이름",
           D.DEPARTMENT_NAME AS "학과이름", 
           ROUND(AVG(G.POINT),1) AS "평점"
    FROM 
        TB_STUDENT S,
        TB_DEPARTMENT D,
        TB_GRADE G
    WHERE
        S.DEPARTMENT_NO=D.DEPARTMENT_NO
        AND
        S.STUDENT_NO=G.STUDENT_NO
        AND
        S.ABSENCE_YN='N'
        AND
        S.STUDENT_NO=( SELECT G.STUDENT_NO
                        FROM TB_GRADE
                        GROUP BY G.STUDENT_NO
                        HAVING ROUND(AVG(G.POINT),1) >=4.0);
                        
/*  
    16. 환경조경학과 전공과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오. 
*/
    SELECT C.CLASS_NO, C.CLASS_NAME, ROUND(AVG(G.POINT),7)
    FROM TB_CLASS C,
         TB_GRADE G,
         TB_DEPARTMENT D
    WHERE 
        C.CLASS_NO = G.CLASS_NO
        AND
        D.DEPARTMENT_NO=C.DEPARTMENT_NO
        AND
        D.DEPARTMENT_NAME='환경조경학과'
        AND
        C.CLASS_TYPE='전공선택'
    GROUP BY C.CLASS_NO, C.CLASS_NAME
    ORDER BY C.CLASS_NO;
    

/*
    17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를 출력하는 
    SQL 문을 작성하시오. 
*/
    SELECT STUDENT_NAME, STUDENT_ADDRESS
    FROM TB_STUDENT
    WHERE 
        DEPARTMENT_NO = (SELECT DEPARTMENT_NO
                         FROM TB_STUDENT
                         WHERE STUDENT_NAME='최경희');

/*  ★ 작동안됨
    18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을 
    작성하시오. 
*/
    SELECT S.STUDENT_NO, S.STUDENT_NAME
    FROM TB_STUDENT S,
         TB_GRADE G,
         TB_DEPARTMENT D
    WHERE
        G.STUDENT_NO=S.STUDENT_NO
        AND
        D.DEPARTMENT_NO=S.DEPARTMENT_NO
        AND
        D.DEPARTMENT_NAME='국어국문학과'
    GROUP BY S.STUDENT_NO, S.STUDENT_NAME
    HAVING AVG(G.POINT)>3.5;
        
    
        
     
/*  ★ 작동안됨
    19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을 
    파악하기 위한 적절한 SQL 문을 찾아내시오. 단, 출력헤더는 "계열 학과명", 
    "전공평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여 표시되도록 
    한다.
*/
    SELECT DEPARTMENT_NAME AS "계열 학과명" , ROUND(AVG(POINT),1) AS "전공 평점"
    FROM TB_DEPARTMENT,
         TB_GRADE
    WHERE 
    
    -- 19.prof
    SELECT DEPARTMENT_NAME "계열 학과명", ROUND(AVG(POINT),1) 전공평점
    FROM TB_DEPARTMENT
    JOIN TB_STUDENT USING(DEPARTMENT_NO)
    JOIN TB_GRADE USING(STUDENT_NO)
    WHERE CATEGORY = (SELECT CATEGORY
                                        FROM TB_DEPARTMENT
                                        WHERE DEPARTMENT_NAME='환경조경학과')
    GROUP BY DEPARTMENT_NAME;



