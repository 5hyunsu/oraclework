--07.DDL 실습문제
--도서관리 프로그램을 만들기 위한 테이블들 만들기
--이때, 제약조건에 이름을 부여할 것.
--       각 컬럼에 주석달기
--
--1. 출판사들에 대한 데이터를 담기위한 출판사 테이블(TB_PUBLISHER)
--   컬럼  :  PUB_NO(출판사번호) NUMBER -- 기본키(PUBLISHER_PK) 
--	PUB_NAME(출판사명) VARCHAR2(50) -- NOT NULL(PUBLISHER_NN)
--	PHONE(출판사전화번호) VARCHAR2(13) - 제약조건 없음
--
--   - 3개 정도의 샘플 데이터 추가하기
    DROP TABLE TB_PUBLISHER;
    
    CREATE TABLE TB_PUBLISHER(
        PUB_NO NUMBER CONSTRAINT PUBLISHER_PK PRIMARY KEY ,
        PUB_NAME VARCHAR2(50) CONSTRAINT PUBLISHER_NN NOT NULL,
        PHONE VARCHAR2(13)
    );
       
    COMMENT ON COLUMN TB_PUBLISHER.PUB_NO IS '출판사번호';
    COMMENT ON COLUMN TB_PUBLISHER.PUB_NAME IS '출판사명';
    COMMENT ON COLUMN TB_PUBLISHER.PHONE IS '출판사전화번호';
    
    INSERT INTO TB_PUBLISHER VALUES(1, '가나다','1234123');
    INSERT INTO TB_PUBLISHER VALUES(2, '라마사','2134123');
    INSERT INTO TB_PUBLISHER VALUES(3, '아자차','5786123');
    
    DELETE FROM TB_PUBLISHER WHERE PUB_NO=2;
    
--2. 도서들에 대한 데이터를 담기위한 도서 테이블(TB_BOOK)
--   컬럼  :  BK_NO (도서번호) NUMBER -- 기본키(BOOK_PK)
--	BK_TITLE (도서명) VARCHAR2(50) -- NOT NULL(BOOK_NN_TITLE)
--	BK_AUTHOR(저자명) VARCHAR2(20) -- NOT NULL(BOOK_NN_AUTHOR)
--	BK_PRICE(가격) NUMBER
--	BK_PUB_NO(출판사번호) NUMBER -- 외래키(BOOK_FK) (TB_PUBLISHER 테이블을 참조하도록)
--			         이때 참조하고 있는 부모데이터 삭제 시 자식 데이터도 삭제 되도록 옵션 지정
--   - 5개 정도의 샘플 데이터 추가하기

    CREATE TABLE TB_BOOK (
        BK_NO NUMBER CONSTRAINT BOOK_PK PRIMARY KEY,
        BK_TITLE VARCHAR2(50) CONSTRAINT BOOK_NN_TITLE NOT NULL, 
        BK_AUTHOR VARCHAR2(20) CONSTRAINT BOOK_NN_AUTHOR NOT NULL,
        BK_PRICE NUMBER,
        BK_PUB_NO NUMBER REFERENCES TB_PUBLISHER(PUB_NO)ON DELETE CASCADE
    );
    
    INSERT INTO TB_BOOK VALUES(1,'삼국지','나관중',10000,1);
    INSERT INTO TB_BOOK VALUES(2, '삼국유사','자아나',20000,2 );
    INSERT INTO TB_BOOK VALUES(3, '삼국사기', '나감독',30000,3);
    INSERT INTO TB_BOOK VALUES(4, '삼국시대','몰라요',40000,1);
    INSERT INTO TB_BOOK VALUES(5, '고려사','누구',50000,2);
    
    DELETE FROM TB_BOOK WHERE BK_PUB_NO=1;


--3. 회원에 대한 데이터를 담기위한 회원 테이블 (TB_MEMBER)
--   컬럼명 : MEMBER_NO(회원번호) NUMBER -- 기본키(MEMBER_PK)
--   MEMBER_ID(아이디) VARCHAR2(30) -- 중복금지(MEMBER_UQ)
--   MEMBER_PWD(비밀번호)  VARCHAR2(30) -- NOT NULL(MEMBER_NN_PWD)
--   MEMBER_NAME(회원명) VARCHAR2(20) -- NOT NULL(MEMBER_NN_NAME)
--   GENDER(성별)  CHAR(1)-- 'M' 또는 'F'로 입력되도록 제한(MEMBER_CK_GEN)
--   ADDRESS(주소) VARCHAR2(70)
--   PHONE(연락처) VARCHAR2(13)
--   STATUS(탈퇴여부) CHAR(1) - 기본값으로 'N' 으로 지정, 그리고 'Y' 혹은 'N'으로만 입력되도록 제약조건(MEMBER_CK_STA)
--   ENROLL_DATE(가입일) DATE -- 기본값으로 SYSDATE, NOT NULL 제약조건(MEMBER_NN_EN)
--
--   - 5개 정도의 샘플 데이터 추가하기
    CREATE TABLE TB_MEMBER (
        MEMBER_NO NUMBER CONSTRAINT MEMBER_PK PRIMARY KEY,
        MEMBER_ID VARCHAR2(30) CONSTRAINT MEMBER_UQ UNIQUE,
        MEMBER_PWD VARCHAR2(30) CONSTRAINT MEMBER_NN_PWD NOT NULL,
        MEMBER_NAME VARCHAR2(20) CONSTRAINT MEMBER_NN_NAME NOT NULL,
        GENDER CHAR(1) CONSTRAINT MEMBER_CK_GEN CHECK(GENDER IN('M','F')),
        ADDRESS VARCHAR2(70),
        PHONE VARCHAR2(13),
        STATUS VARCHAR2(1) DEFAULT'N' CONSTRAINT MEMBER_CK_STA CHECK(STATUS IN ('Y','N')),
        ENROLL_DATE DATE DEFAULT SYSDATE CONSTRAINT MEMBER_NN_EN NOT NULL
    
    );
    
    INSERT INTO TB_MEMBER VALUES(1,'ABCD','1234','홍길동','F','가산','010-1234-5678','N','2023/11/11');
    INSERT INTO TB_MEMBER VALUES(2,'EFGH','1234','이길동','M','구로','010-2214-4448','Y','2022/01/11');
    INSERT INTO TB_MEMBER VALUES(3,'HIJK','1234','김길동','M','용산','010-6785-1234','N','2021/07/11');
    INSERT INTO TB_MEMBER VALUES(4,'LMNO','1234','라길동','M','안양','010-2238-9654','Y','2020/03/11');
    INSERT INTO TB_MEMBER VALUES(5,'POIU','1234','박길동','F','광명','010-4536-4536','N','2019/02/11');
    
    DELETE FROM TB_MEMBER WHERE MEMBER_NO =2; --렌트테이블에 RENT_MEM_NO가 NULL로만 바뀜

--4. 어떤 회원이 어떤 도서를 대여했는지에 대한 대여목록 테이블(TB_RENT)
--   컬럼  :  RENT_NO(대여번호) NUMBER -- 기본키(RENT_PK)
--	RENT_MEM_NO(대여회원번호) NUMBER -- 외래키(RENT_FK_MEM) TB_MEMBER와 참조하도록
--			이때 부모 데이터 삭제시 자식 데이터 값이 NULL이 되도록 옵션 설정
--	RENT_BOOK_NO(대여도서번호) NUMBER -- 외래키(RENT_FK_BOOK) TB_BOOK와 참조하도록
--			이때 부모 데이터 삭제시 자식 데이터 값이 NULL값이 되도록 옵션 설정
--	RENT_DATE(대여일) DATE -- 기본값 SYSDATE
--
--   - 3개 정도 샘플데이터 추가하기

    CREATE TABLE TB_RENT (
        RENT_NO NUMBER CONSTRAINT RENT_PK PRIMARY KEY,
        RENT_MEM_NO NUMBER CONSTRAINT RENT_FK_MEM REFERENCES TB_MEMBER (MEMBER_NO)ON DELETE SET NULL,
        RENT_BOOK_NO NUMBER CONSTRAINT RENT_FK_BOOK REFERENCES TB_BOOK (BK_NO)ON DELETE SET NULL,
        RENT_DATE DATE DEFAULT SYSDATE
    );
    INSERT INTO TB_RENT VALUES(1,'1','1','2023/11/12');
    INSERT INTO TB_RENT VALUES(2,'2','3','2023/10/12');
    INSERT INTO TB_RENT VALUES(3,'3','4','2019/11/12');
    
    DELETE FROM TB_RENT WHERE RENT_MEM_NO='3';
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    