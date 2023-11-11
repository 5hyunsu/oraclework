--15. EMPLOYEE테이블에서 사원 명과 직원의 주민번호를 이용하여 생년, 생월, 생일 조회
SELECT EMP_NAME 사원명, SUBSTR(EMP_NO,1,2) 생년, SUBSTR(EMP_NO,3,2) 생월, SUBSTR(EMP_NO,5,2) 생일
FROM EMPLOYEE;

--16. EMPLOYEE테이블에서 사원명, 주민번호 조회 (단, 주민번호는 생년월일만 보이게 하고, '-'다음 값은 '*'로 바꾸기)
SELECT EMP_NAME 사원명, RPAD(SUBSTR(EMP_NO,1,8),14,'*') 주민번호
FROM EMPLOYEE;

--17. EMPLOYEE테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
--(단, 각 별칭은 근무일수1, 근무일수2가 되도록 하고 모두 정수(내림), 양수가 되도록 처리)
SELECT EMP_NAME 사원명 , FLOOR(ABS(HIRE_DATE-SYSDATE)) 근무일수1,FLOOR(ABS(SYSDATE-HIRE_DATE)) 근무일수2
FROM EMPLOYEE; 

--18. EMPLOYEE테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT *
FROM EMPLOYEE
WHERE MOD(EMP_ID , 2)=1;

--19. EMPLOYEE테이블에서 근무 년수가 20년 이상인 직원 정보 조회
SELECT *
FROM  EMPLOYEE
WHERE EXTRACT(YEAR FROM SYSDATE)-EXTRACT(YEAR FROM HIRE_DATE) >=20;

--20. EMPLOYEE 테이블에서 사원명, 급여 조회 (단, 급여는 '\9,000,000' 형식으로 표시)
SELECT EMP_NAME 사원명 , TO_CHAR(SALARY,'L999,999,999,999')급여
FROM EMPLOYEE;

--21. EMPLOYEE테이블에서 직원 명, 부서코드, 생년월일, 나이(만) 조회
--(단, 생년월일은 주민번호에서 추출해서 00년 00월 00일로 출력되게 하며 
--나이는 주민번호에서 출력해서 날짜데이터로 변환한 다음 계산)
SELECT EMP_NAME 직원명, DEPT_CODE 부서코드 , SUBSTR(EMP_NO,1,2)||'년 ' ||SUBSTR(EMP_NO,3,2)||'월 ' ||SUBSTR(EMP_NO,5,2)||'일' 생년월일
,SUBSTR(EMP_NO,1,2)-SUBSTR(SYSDATE,1,2) AS 만나이
FROM EMPLOYEE;

--23. EMPLOYEE테이블에서 사번이 201번인 사원명, 주민번호 앞자리, 주민번호 뒷자리, 
--주민번호 앞자리와 뒷자리의 합 조회
SELECT EMP_NAME 사원명, 
       SUBSTR(EMP_NO,1,1) 주민번호앞자리 ,
       SUBSTR(EMP_NO,13,1) 주민번호뒷자리, 
       SUBSTR(EMP_NO,1,1)+SUBSTR(EMP_NO,13,1) 주민번호앞자리와뒷자리의합조회 
FROM EMPLOYEE;