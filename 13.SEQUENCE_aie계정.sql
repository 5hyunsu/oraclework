/*
    <시퀀스 : SEQUENCE>
    자동으로 번호를 발생시켜주는 역할을 하는 객체
    정수 값을 순차적으로 일정값 씩 증가시키면서 새성
    
    EX) 회원번호, 사원번호, 게시글 번호 
*/

/*
    1. 시퀀스 객체 생성
    
    [표현식]
    CREATE SEQUENCE 시퀀스명
    [START WITH 시작 숫자] ->처음 발생시킬 시작값 지정(기본값1)
    [INCREMENT BY 숫자]    ->몇 씩 증가 시킬것인지(기본값1)
    [MAXVALUE 숫자]       -> 최대값 지정
    [MINVALUE 숫자]       -> 최소값 지정(기본값1)
    [CYCLE | NOCYCLE]    -> 값 순환 여부 지정( 기본값 NOCYCLE)
    [CACHE | NOCACHE]    ->캐시 메모리 할당(기본값 CACHE20)
    
    *캐시 메모리 : 프린터 전송시 캐시메모리 저장, 중간정도 속도
    미리 발생될 값 들을 생성해서 저장해 두는 공간 
    매번 호출할 때 마다 새롭게 번호를 생성 하는 게 아니라 
    캐시메모리 공간에 미리 생성된 값들을 가져다 쓸 수 있음
    (속도가 빨라짐)
    접속이 해제 되면 -> 캐시 메모리에 미리 만들어 둔 번호 다 날라감
    
    테이블명: TB_시퀀스이름
    뷰 : VW_   VM
    시퀀스명 : SEQ_
    트리거명 : TRG_ 
    
*/   
    
-- 시퀀스 생성 
CREATE SEQUENCE SEQ_TEST;

--[참고] 현재 계정이 소유하고 있는 SEQUENCE들의 구조를 보고자 할 때 
SELECT * FROM USER_SEQUENCES;
-- 구조 옆으로 보기  가로로 길게

CREATE SEQUENCE SEQ_EMPNO
START WITH 400
INCREMENT BY 5  --감소도 가능 증가도 가능 
MAXVALUE 410 
NOCYCLE
NOCACHE;

SELECT SEQ_EMPNO.CURRVAL FROM DUAL; 
--하나를 써야 한다. 
-- CURRVAL은 마지막에 성공적으로 수행된 NEXTVAL의 값을 저장해서 보여주는 임시값

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; --400
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; --405
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; --410
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; --410
SELECT SEQ_EMPNO.NEXTVAL FROM DUAL; --410
--ORA-08004: 시퀀스 SEQ_EMPNO.NEXTVAL exceeds MAXVALUE은 사례로 될 수 없습니다
--지정한 MAXVALUE 값을 초과했기 때문에 오류 
SELECT SEQ_EMPNO.CURRVAL FROM DUAL; --410  지금 상태는 커런트는 410



/*
    2. 시퀀스 사용
    
    시퀀스명. CURRVAL : 현재 시퀀스 값( 마지막으로 성공한 NEXTVAL의 값)
    시퀀스명. NEXTVALUE : 시퀀스 값에 일정값을 증가시켜서 발생된 값
                        현재 시퀀스 값에서 INCREMENT BY 값 만큼 증가된 값 
                    == 시퀀스명. CURRVAL + INCREMENT BY 값
     
*/

SELECT SEQ_TEST.CURRVAL FROM DUAL; 
--ORA-08002: 시퀀스 SEQ_TEST.CURRVAL은 이 세션에서는 정의 되어 있지 않습니다
--NEXTVAL를 단 한번도 수행하지 않는 이상 CURRVAL 할 수 없음 
--라스트 값이 1 
--마지막 값이 1이고 사용안했으면 벨류 갖고 올 수 없다.



/*
    3. 시퀀스 구조 변경 
    ALTER SEQUENCE 시퀀스명
    [INCREMENT BY 숫자]
    [MAXVALUE 숫자]
    [MINVALUE 숫자]
    [CYCLE|NOCYCLE]
    [CACHE|NOCACHE]
    
*/
ALTER SEQUENCE SEQ_EMPNO
INCREMENT BY 10 
MAXVALUE 1000;

SELECT * FROM USER_SEQUENCES ;

SELECT SEQ_EMPNO.NEXTVAL FROM DUAL;
SELECT SEQ_EMPNO.CURRVAL FROM DUAL;
--시퀀스 불러오기 

/*
    4.시퀀스 삭제 (테이블 삭제와 비슷)
*/
DROP SEQUENCE SEQ_EMPNO;
SELECT * FROM USER_SEQUENCES;

-----------------------------------------------
--사원 번호로 활용할 경우 
CREATE SEQUENCE SEQ_EID 
START WITH 303;

INSERT INTO EMPLOYEE ( EMP_ID,
                       EMP_NAME, 
                       EMP_NO, 
                       JOB_CODE, 
                       HIRE_DATE)
VALUES(SEQ_EID.NEXTVAL,'홍길동','123456-1234567','J2','2003-12-21')    

--회사에서는 이렇게 더 많이 쓴다. 
INSERT
  INTO EMPLOYEE
    (
        EMP_ID
       ,EMP_NAME
       ,EMP_NO
       ,JOP_CODE
       ,HIRE_DATE
    )
VALUES 
    (   SEQ_EID.NEXTVAL
      ,'홍길동'
      ,'071120-1233455'
      ,'J7'
      ,SYSDATE
    );
    
       















    
    
    
    
    
    
    
    
    
    
    
    
    