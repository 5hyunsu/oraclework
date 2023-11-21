/*
    < 트리거 TRIGGER >
    내가 지정한 테이블에 INSERT, UPDATE, DELETE 등의 DML문에 의해 변경사항이 생길때
    (테이블에 이벤트가 발생했을 때)
    자동으로 매번 실행할 내용을 미리 정의해둘 수 있는 객체
    
    EX)
    회원탈퇴시 기존의 회원테이블에 데이터 DELETE 후 곧바로 탈퇴된 회원들만 따로보관하는 테이블에 자동으로 INSERT처리해야된다!
    신고횟수가 일정 수를 넘었을때 묵시적으로 해당 회원을 블랙리스트로 처리되게끔
    입출고에 대한 데이터가 기록(INSERT) 될때마다 해당 상품에 대한 재고수량을 매번 수정(UPDATE) 해야될때
    
    * 트리거 종류
    - SQL문의 실행시기에 따른 분류
        > BEFORE TRIGGER : 명시한 테이블에 이벤트가 발생되기 전에 트리거 실행
        > AFTER TRIGGER : 명시한 테이블에 이벤트가 발생한 후에 트리거 실행
        
    - SQL문에 의해 영향을 받는 각 행에 따른 분류
        > STATEMENT TRIGGER (문장트리거) : 이벤트가 발생한 SQL문에 대해 딱 한번만 트리거 실행
        > ROW TRIGGER (행 트리거) : 해당 SQL문 실행할 때 마다 매번 트리거 실행
                                  (FOR EACH ROW 옵션 기술해야됨)        
                              > :OLD - 기존컬럼에 들어 있던 데이터
                              > :NEW - 새로 들어온 데이터

    * 트리거 생성 구문
    
    [표현식]
    CREATE [OR REPLACE] TRIGGER 트리거명  (뷰 생성할 때와 비슷하다) 
    BEFORE|AFTER INSERT|UPDATE|DELETE  ON 테이블명 (명시한 것 후, 전에할 것인지)
    [FOR EACH ROW]  (행위 때 마다 각각 돌 것인지)
    [DECLARE
        변수선언 ;]
    BEGIN
        실행내용 (해당 위에 지정된 이벤트 발생시 묵시적으로 (자동으로) 실행할 구문)
    [EXCEPTION      
        예외처리 구문; ]
    END;
    /
    
    트리거 삭제시 : DROP TRIGGER 트리거이름;
*/

--EMPLOYEE 테이블에서 새로운 행이 INSERT 될 때마다 자동으로 메시지 출력되는 트리거 정의
SET SERVEROUTPUT ON;

CREATE OR REPLACE TRIGGER TRG_01
AFTER INSERT ON EMPLOYEE 
BEGIN 
    DBMS_OUTPUT.PUT_LINE('신입사원님 환영합니다.');
    --INSERT 되기 전에 출력이 된다. 

END;
/

INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES('600','이순열','021123-1234567','J4', SYSDATE);
    
INSERT INTO EMPLOYEE(EMP_ID, EMP_NAME, EMP_NO, JOB_CODE, HIRE_DATE)
VALUES('601','박순열','221323-1232567','J3', SYSDATE);



--★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★-
--상품입고 및 출고가 되면 재고수량이 변경되도록 
-->> 필요한 테이블, 시퀀스 생성 

--1.상품 테이블 (TB_PRODUCT)
CREATE TABLE TB_PRODUCT (
    PCODE NUMBER PRIMARY KEY,
    PNAME VARCHAR2(50) NOT NULL,
    BRAND VARCHAR2(50) NOT NULL,
    STOCK_QUANT NUMBER DEFAULT 0 -- 재고수량 
 );   
--2.시퀀스 생성 
CREATE SEQUENCE SEQ_PCODE
START WITH 200;

INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '갤럭시 폴드5','삼성',DEFAULT);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '아이폰15','애플',10);
INSERT INTO TB_PRODUCT VALUES(SEQ_PCODE.NEXTVAL, '흥미노트2','샤오미',20);

COMMIT;

--3. 상품 입고 테이블 (TB_PROSTOCK)
CREATE TABLE TB_PROSTOCK (
    TCODE NUMBER PRIMARY KEY,
    PCODE NUMBER REFERENCES TB_PRODUCT,
    TDATE DATE,
    STOCK_COUNT NUMBER NOT NULL,
    STOCK_PRICE NUMBER NOT NULL
);

--4.시퀀스 생성 
CREATE SEQUENCE SEQ_TCODE;

--5. 상품  판매 테이블  (TB_PROSALE)
CREATE TABLE TB_PROSALE(
    SCODE NUMBER PRIMARY KEY,
    PCODE NUMBER REFERENCES TB_PRODUCT,
    SDATE DATE,
    SALE_COUNT NUMBER NOT NULL,
    SALE_PRICE NUMBER NOT NULL
);

--6.판매할 시퀀스 생성
CREATE SEQUENCE SEQ_SCODE;

--EX) 상품이 오늘 날짜로 10개 입고 
INSERT INTO TB_PROSTOCK
VALUES(SEQ_TCODE.NEXTVAL, 200, SYSDATE,5, 2000000);
UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT + 5
    WHERE PCODE =200;
    
--EX) 상품이 오늘 날짜로 5개 출고
--업데이트를 트리거로 정의한다. 
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 202, SYSDATE,5, 1200000);
UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT - 5
    WHERE PCODE =202;
    
COMMIT;

--TB_PRODUCT 테이블에 매번 자동으로 재고수량 UPDATE 되는 트리거 정의

--1. TB_PROSTOCK 입고테이블에 INSERT 이벤트 발생시
/*
    UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT + 현재 입고된 수량 (INSERT된 자료의 STOCK자료)
    WHERE PCODE = 입고된 상품의 번호 (INSERT 된 자료의 PCODE값);
    
*/

CREATE OR REPLACE TRIGGER TRG_STOCK
AFTER INSERT ON TB_PROSTOCK
FOR EACH ROW 
BEGIN
    UPDATE TB_PRODUCT
    SET STOCK_QUANT = STOCK_QUANT + :NEW.STOCK_COUNT
    WHERE PCODE = :NEW.PCODE;
END;
/

--201번 상품 5개 입고
INSERT INTO TB_PROSTOCK
VALUES(SEQ_TCODE.NEXTVAL,201,SYSDATE,5, 1600000);

--201번 상품 7개 입고
INSERT INTO TB_PROSTOCK
VALUES(SEQ_TCODE.NEXTVAL,200,SYSDATE,7, 2000000);

--

--2. TB_PROSALE 출고테이블에 INSERT 이벤트 발생시
CREATE OR REPLACE TRIGGER TRG_SALE
AFTER INSERT ON TB_PROSALE
FOR EACH ROW 
BEGIN
    UPDATE TB_PRODUCT  --재고테이블 업데이트
    SET STOCK_QUANT = STOCK_QUANT - :NEW.SALE_COUNT
    WHERE PCODE = :NEW.PCODE;
    --출고시 재고가 적으면 사용자 메시지 에러코드가 숫자로 되어있는데
    -- 숫자를 구현해 주면 된다. 
END;
/
--출고
INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 201, SYSDATE,2, 1600000);

INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 200, SYSDATE,1, 2000000);

--출고시 재고가 적으면 사용자 메시지 에러코드가 숫자로 되어있는데 숫자를 구현해 주면 된다. 
/*
    * 사용자 함수 예외 처리 
    RAISE_APPLICATION_ERROR([에러코드],[에러메시지])
    -에러코드 : -20000 ~ -20999사이에 코드 사용 가능 
    -출고하기 전에 해줘야 한다. 
    -안에는 IF문을 집어 넣는다. 
    -하기 전에 인서트하는 수량보다는 더 커야 된다. 
    -IF ELSE 로 해줘도 되고 엘스에 에러코드 넣어줘도 된다. 
    
*/

CREATE OR REPLACE TRIGGER TRG_SALE 
BEFORE INSERT ON TB_PROSALE
FOR EACH ROW
DECLARE
    SCOUNT NUMBER;
BEGIN --STOCK COUNT를 가져와야 한다. 
    SELECT STOCK_QUANT
        INTO SCOUNT
        FROM TB_PRODUCT 
    WHERE PCODE = :NEW.PCODE;   --인서트 일어나는 재고 피코드

    IF(SCOUNT >=: NEW.SALE_COUNT)
        THEN
            UPDATE TB_PRODUCT  --재고테이블 업데이트
            SET STOCK_QUANT = STOCK_QUANT - :NEW.SALE_COUNT
            WHERE PCODE = :NEW.PCODE;
    ELSE
        RAISE_APPLICATION_ERROR(-20001,'재고수량부족');
    END IF;
END;
/

INSERT INTO TB_PROSALE
VALUES(SEQ_SCODE.NEXTVAL, 201, SYSDATE,15, 1600000);
--재고 넘치게 넣으면 PRODUCT 바뀌지 않고 실행 되지 않는다.
--재고수량부족이라고 에러 메시지 뜬다.







