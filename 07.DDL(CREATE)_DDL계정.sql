/*
    DDL : 데이터 정의어 
    오라클에서 제공하는 객체를 만들고(CREATE),
    구조를 변경하고 (ALTER)하고, 
    구조를 삭제(DROP)하는 언어 
    즉, 실제 데이터 값이 아닌 구조 자체를 정의하는 언어
    주로 DB관리자, 설계자가 사용함 
    
    오라클 객체: 테이블(TABLE), 뷰(VIEW),
              시퀀스(SEQUENCE), 인덱스(INDEX),
              패키지(PACKAGE), 프로시저(PROCEDURE),
              함수(FUNCTION), 동의어(SYNONM),
    
*/

--===================================================
/*
<CREATE>
객체를 생성하는 구문 
*/
--------------------------------------------------------
/*
테이블 생성 
-테이블 이란: 행(ROW) 열(COLUMN)로 구성되는 가장 기본적인 데이터베이스 객체
             모든 데이터들은 테이블을 통해 저장 됨 
             (DBMS용어 중 하나로, 데이터를 일종의 표 형태로 표현한 것))
    [표현법}
     CREATE TABLE 테이블명(   --테이블 명은 변수 선언 
        컬럼명 자료형 (크기 ),
        컬럼명 자료형 (크기 ),
        컬럼명 자료형 (크기 ),
        ...
    );
    
    *자료형
    -문자(CHAR(바이터크기)VARVHAR2(바이터크기)) => 반드시 크기 지정 해야 됨
    - CHAR : 최대 2000BYTE 까지 지정 가능
             고정길이( 고정해놓으면 무조건 글자수에 상관없이 자리 차지한다)
             작은 값이 들어와도 공백으로라도 채워서 처음 지저한 크기 만큼 고정
             주민등록번호와 같이 고정 되어있는 형태에 좋다. 
             고정된 데이터를 넣을 때 사용 
    - VARVHAR2 : 최대 4000BYTE 까지 지정 가능
             가변길이( 담긴 값에 따라 공간의 크기가 맞춰짐)
             몇글자가 들어올지 모를 경우 사용 
             자리 차지 하는 만큼 가변 크기 , 주소 넣을 때 넉넉하게 넣어줘야 함. 100바이트
    - 숫자(NUMBER)
    - 날짜(DATE)
*/
--회원 테이블 MEMBER 생성
CREATE TABLE MEMBER(
    MEM_NO NUMBER,
    MEM_ID VARCHAR2(20),
    MEM_PW VARCHAR2(20),
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3), --'여','남' 둘중에 하나
    PHONE VARCHAR2(13),
    --0이 넘버로 바뀌어서 문자로 해줘야 한다. 
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);
SELECT * FROM MEMBER;
--------------------------------------------------------
/*
    2. 컬럼에 주석 달기 (컬럼에 대한 설명) 
    
    [표현법]
    COMMENT ON COLUMN 테이블명, 컬럼명 IS '주석내용';
    
    >>잘못 작성시 다시 실행하면 됨. 

*/
--수정할 때 사용 
COMMENT  ON COLUMN MEMBER.MEM_NO IS '주석내용';  --순서 바뀌어도 괜찮다
COMMENT ON COLUMN MEMBER.MEM_ID IS '회원아이디';
COMMENT ON COLUMN MEMBER.MEM_PASSWORD IS '비밀번호';
COMMENT ON COLUMN MEMBER.MEM_NAME IS '회원이름';
COMMENT ON COLUMN MEMBER.GENDER IS '성별(남,여)'; --수정하고 다시 실행 3바이트라 2글자 안된다 
COMMENT ON COLUMN MEMBER.PHONE IS '전화번호';
COMMENT ON COLUMN MEMBER.EMAIL IS '이메일';
COMMENT ON COLUMN MEMBER.MEM_DATE IS '회원가입일';

--테이블에 데이터 추가하기
--INSERT INTO 테이블명 VALUES();  순서대로 모두 다 넣어야 한다 
                              --user는 대소문자 가리고, null NULL은 안가린다
INSERT INTO MEMBER VALUES(1,'user01','1234','김나영','여','010-1234-5678','kim@naver.com','23/11/16');
INSERT INTO MEMBER VALUES(2,'user02','1234','박나래','남',null,NULL , SYSDATE);
INSERT INTO MEMBER VALUES(NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

-- NULL 값이 들어가면 안되고 키가 들어가게 하고 싶음 
-- 프라이머리 키로 지정 하겠다, 한글자만 지정하겠다 같은 = 제약조건 
--------------------------------------------------------
/*
    <제약조건 CONTRAINTS>
    - 원하는 데이터 값(유효한 형식의 값)만 유지하기 위해 특정 컬럼에 설정하는 제약
    - 데이터 무결성 보장을 목적으로 한다 
    : 데이터에 결함이 없는 상태, 즉 데이터가 정확하고 유효하게 유지된 상태
    1. 개체 무결성 제약 조건 : NOT NULL,UNIQUE ,CHECK ,PRIMARY KEY 조건위배
    2. 참조 무결성 제약 조건 : FOREIGN KEY(외래키)조건 위배 
     
    * 종류 : NOT NULL(널 값을 가지면 안된다.)
            UNIQUE  (테이블에서 유일한 값)
            CHECK (조건)
            PRIMARY KEY = NOT NULL + UNIQUE  , 테이블 1개당 1개씩 
                안넣는다고 생성 안되는 것은 아니지만, 대표할 만한 유일한 키 
                프라이머리 키를 2개로 할 수도 있다. 
            FOREIGN KEY = 외래키 , 다른 테이블하고 조인시 외래키를 걸어 놓을 때 
                -만약에 부서번호가 한정되어서 적용되어야 하는데 부서 테이블에서 갖고와서 
                - 제약을 걸어 버려서 부서 10까지 넘어가지 않도록 한다. 
 
*/

/*
    *NOT NULL 제약조건 
    해당컬럼에 반드시 값이 존재해야만 할 경우(즉, 컬럼에 절대 NULL이 들어오면 안되는 경우)
    삽입/수정시 NULL값을 허용하지 않도록 제한 
    
    제약조건의 부여 방식은 크게 2가지로 나눔(컬럼레벨 방식, 테이블 레벨방식)
    -NOT NULL 제약 조건은 오로지 컬럼 레벨 방식 밖에 안됨 
    -다른 조건은 둘다 사용 가능
    -NOT NULL은 테이블 레벨방식 안된다.
*/

--컬럼 레벨 방식 : 컬럼명 자료형 옆에 제약조건을 넣어주면 된다. 
CREATE TABLE MEM_NOTNULL (
    MEM_NO NUMBER NOT NULL,  --제약조건은 한칸 띄고 작성, NOT NULL 다 안 넣어 줘도 된다
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3), --'여','남' 둘중에 하나
    PHONE VARCHAR2(13),
    --0이 넘버로 바뀌어서 문자로 해줘야 한다. 
    EMAIL VARCHAR2(50),
    MEM_DATE DATE
);

SELECT * FROM  MEM_NOTNULL; 
INSERT INTO MEM_NOTNULL VALUES(1,'user01','1234','김나영','여','010-1234-5678','kim@naver.com','23/11/16');
INSERT INTO MEM_NOTNULL VALUES(2,'user02',NULL,'박나래','남',null,NULL , SYSDATE);
-- NOT NULL 제약조건에 위배되는 오류 발생

INSERT INTO MEM_NOTNULL VALUES(1, 'USER01','PASS01','이영순','여',NULL, NULL, SYSDATE);
--테이블 이름은 대, 소문자 모두 괜찮다 
--앞에 멤버아이디 유니크 했으면 좋겠다 

--------------------------------------------------------
/*
    *UNIQUE  제약 조건
    해당 컬럼에 중복된 값이 들어가면 안되는 경우
    컬럼값에 중복값 제한을 하는 제약 조건 
    삽입/ 수정시 기존에 있는 데이터값이 중복되었을 때 오류 발생

*/
--컬럼 레벨 방식 : 컬럼 옆에서 직접 따로 따로 제약적용
CREATE TABLE MEM_UNIQUE(
    MEM_NO NUMBER NOT NULL UNIQUE, 
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50)
); 

--테이블 레벨 방식 : 모든 컬럼을 나열한 후 마지막에 기술 
--                 다 정의 해주고 맨 마지막에 처리 
--  [표현법]       제약조건 (컬럼명)
CREATE TABLE MEM_UNIQUE2(
    MEM_NO NUMBER NOT NULL , 
    MEM_ID VARCHAR2(20) NOT NULL ,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(50),
    UNIQUE (MEM_NO),  --어느 컬럼에 할지 가로로 표현 한다. 
    UNIQUE (MEM_ID) -- 하나씩 따로따로 제약조건을 본다
    
    --UNIQUE (MEM_NO, MEM_ID) - 중복조건으로 사용 
    --조합해서 제약조건 
    --같은 곳 컴마시 둘이 동시에 본다 
    --두개의 조합값이 안에 있는가 본다.
    -- 1A 1B 이처럼 만들 수 있다. 조합한 결과값으로 중복을 체크
    --1,A
    --2,B
    --3,C
    --1,D 위배되지 않고 새로운 값 삽입시 삽입됨
 
);

INSERT INTO MEM_UNIQUE VALUES(1,'user01','pass01','김남길','남',null, null);
INSERT INTO MEM_UNIQUE VALUES(1,'user02','pass02','김남이','남',null, null);

INSERT INTO MEM_UNIQUE2 VALUES(1,'user01','pass01','김남길','남',null, null);
INSERT INTO MEM_UNIQUE2 VALUES(2,'user01','pass02','김남이','남',null, null);

/*
    제약조건 부여시 제약조건명까지 부여할 수 있다. 
    >>컬럼 레벨 방식 
    CREATE TABLE 테이블명(
        컬럼명 자료형()[CONSTRAINT 제약조건명 ]제약조건,
    
    );
    >>테이블 레벨 방식 (
     CREATE TABLE 테이블명(
        컬럼명 자료형(),
    ...,
     [CONSTAINT 제약조건명] 제약조건(컬럼명)
  
*/

CREATE TABLE MEM_UNIQUE3(
    MEM_NO NUMBER CONSTRAINT MEMNO_NN NOT NULL CONSTRAINT NOUNIQUE UNIQUE,
    MEM_ID VARCHAR2(20) NOT NULL ,
    MEM_PW VARCHAR2(20) CONSTRAINT PW_NN NOT NULL, 
    MEM_NAME VARCHAR2(20),
    GENDER CHAR(3),
    CONSTRAINT NAME_UNIQUE UNIQUE(MEM_ID) --테이블 레벨 방식 
);
INSERT INTO MEM_UNIQUE3 VALUES(1,'uid','upw','김길동',null);
INSERT INTO MEM_UNIQUE3 VALUES(1,'uid2','upw2','김길',null); --바뀐 이름을 볼 수 있음 
INSERT INTO MEM_UNIQUE3 VALUES(2,'uid2','upw2','ㄱ',NULL);
INSERT INTO MEM_UNIQUE3 VALUES(3,'uid3','upw3','이임','M');
--성별: 남, 여 
--CHECK 조건식을 걸어준다. 
--------------------------------------------------------
/*
    *CHECK(조건식) 제약조건 
    해당 컬럼에 들어올 수 없는 값에 대한 조건을 제시해 둘 수 있다
    해당 조건에 만족하는 데이터 값만 입력하도록 할 수 있다 
    
*/
CREATE TABLE MEM_CHECK ( 
    MEM_NO NUMBER NOT NULL UNIQUE,  
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, 
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    --GENDER CHAR(3) CHECK(GENDER IN('남','여')), --컬럼 레벨 방식
    --남, 여만 들어 가게끔 하는 방식 = CHECK 활용, F넣으면 오류남 
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    CHECK(GENDER IN ('남','여'))  --테이블 레벨 방식 
    --이름 넣고 싶다면 CONSTRAINTS 이름 부여 하자.
);

INSERT INTO MEM_CHECK VALUES(1,'user01','pass01','홍길동','남',null,null,sysdate);
INSERT INTO MEM_CHECK VALUES(2,'user02','pass02','이길동','f',null,null,sysdate);
--체크제약조건은 이름 정해 줘야지 편하게 볼 수 있다. 
INSERT INTO MEM_CHECK VALUES(2,'user02','pass02','이길동','여',null,null,sysdate);

--프라이머리키는 컬럼 방식으로 딱 하나, 테이블당 하나, 조합해서 넣을 수 있다.
--보통 넘버를 프라이머리 키로 쓴다. 

--------------------------------------------------------
/*
    *PRIMARY KEY(기본키) 제약 조건
    테이블에서 각 행들을 식별하기 위해 사용될 컬럼에 부여하는 제약조건(식별자역할)
    
    EX) 회원번호, 학번, 사번, 예약번호 , 운송장 번호 ..
    
    PRIMARY KEY 제약 조건을 부여하면 그 컬럼에 자동으로 NOT NULL+UNIQUE 제약조건을 의미
    >>대체적으로 검색, 수정, 삭제 등에서 기본키의 컬럼값을 이용함 
    
    --한 테이블당 오로지 한개만 설정 가능 
   
*/

CREATE TABLE MEM_PRIMARY(
    MEM_NO NUMBER PRIMARY KEY, --컬럼 레벨 방식  
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE, 
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    --GENDER CHAR(3) CHECK(GENDER IN('남','여')), --컬럼 레벨 방식
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    CHECK(GENDER IN ('남','여'))  --테이블 레벨 방식 
    --이름 넣고 싶다면 CONSTRAINTS 이름 부여 하자.
    --PRIMARY KEY(MEM_NO) --테이블 레벨 방식 , 어떤 키인지 컬럼에 넣어준다
    
);

INSERT INTO MEM_PRIMARY VALUES(1,'user01','1234','김나영','여','010-1234-5678','kim@naver.com','23/11/16');
INSERT INTO MEM_PRIMARY VALUES(1,'user02','1234','이나영','여','010-1234-1278','lee@naver.com' , SYSDATE);
--ORA-00001: 무결성 제약 조건(DDL.SYS_C008448)에 위배됩니다

--------------------------------------------------------



CREATE TABLE MEM_PRIMARY2(
    MEM_NO NUMBER PRIMARY KEY, --컬럼 레벨 방식  
    MEM_ID VARCHAR2(20) PRIMARY KEY, -- primary key 한개반 가능 (오류)
    --NOT NULL UNIQUE, --NOT NULL UNIQUE =프라이머리키로?
    --안된다. ORA-02260: 테이블에는 하나의 기본 키만 가질 수 있습니다.
    --02260. 00000 -  "table can have only one primary key"
    --*Cause:    Self-evident.
    --*Action:   Remove the extra primary key.
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    --GENDER CHAR(3) CHECK(GENDER IN('남','여')), --컬럼 레벨 방식
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    CHECK(GENDER IN ('남','여'))  --테이블 레벨 방식 
    --이름 넣고 싶다면 CONSTRAINTS 이름 부여 하자.
    --PRIMARY KEY(MEM_NO) --테이블 레벨 방식 
    --아래 참고 
);




CREATE TABLE MEM_PRIMARY3(
    MEM_NO NUMBER NOT NULL, --컬럼 레벨 방식  
    MEM_ID VARCHAR2(20) , 
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3),
    PHONE VARCHAR2(13),
    EMAIL VARCHAR2(50),
    MEM_DATE DATE,
    CHECK(GENDER IN ('남','여')),  
    PRIMARY KEY(MEM_NO, MEM_ID)  
    -- 두개 묶어서 PRIMARY KEY 복합키 제약조건 ★★★복합키★★★
    --하나하나 넣지말고, 2개를 한꺼번에 프라이머리키로 넣을 때 사용한다.
);

INSERT INTO MEM_PRIMARY3 VALUES(1,'uid','upw','나길동','남',null, null, sysdate);
INSERT INTO MEM_PRIMARY3 VALUES(2,'uid','upw','나길동','남',null, null, sysdate);
INSERT INTO MEM_PRIMARY3 VALUES(1,'uid2','upw','나길동','남',null, null, sysdate); --컬럼값 2개를 조합해서 유일해야 
INSERT INTO MEM_PRIMARY3 VALUES(1,'uid','upw','나길동','남',null, null, sysdate); --NOT NULL 오류 (NOT NULL 값은 안됨 
--기본키는 각 컬럼에는 절대 NULL을 허용하지 않는다. 


/* 

복합기 사용 예(어떤 사용자가 어떤 물품을 찜했는지 데이터를 보관할 때 
1 A
1 B 
1 C
2 A
2 B 
2 C
2 B (부적합)



1을 A,B,D가 찜을 할 때 사람이 다르니까 중복을 허용해랴 한다. 

*/

--------------------------------------------------------
--회원정보를 저장하는 테이블(MEM)
CREATE TABLE MEM_GRADE(
    GRADE_CODE NUMBER PRIMARY KEY,
    GRADE_NAME VARCHAR2(30) NOT NULL
);
INSERT INTO MEM_GRADE VALUES(10, '일반회원');
INSERT INTO MEM_GRADE VALUES(20, '우수회원');
INSERT INTO MEM_GRADE VALUES(30, '특별회원');
--회원의 등급을 저장하는 테이블(MEM_GRADE)
CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20)NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(20),
    MEM_DATE DATE,
    GRADE_ID NUMBER  --회원 등급을 보관 
);

INSERT INTO MEM VALUES(1,'user01','pass01','홍길동','남',NULLL,NULL,SYSDATE,NULL);
INSERT INTO MEM VALUES(2, ' user02','pass02','김길똥','여',NULL,NULL,SYSDATE, 10);
INSERT INTO MEM VALUES(3, ' user03','pass02','김길똥','여',NULL,NULL,SYSDATE, 10);
--유효한 회원 등급 번호가 아님에도 입력 됨 

----------------------------------------------------------
/*
    *FOREIGN KEY (외래키)제약조건 
    다른 테이블에 좋재하는 값만 들어와야되는 특정 칼럼에 부여하는 제약조건
    --주로 다르 테이블을 참조한다고 표현
    -- 주로 FOREIGNKEY
     >> 컬럼 레벨 방식
    --컬럼명 자료형 REFERENCES 참조할 테이블 명(참조할 컬럼명)
    컬럼명 자료형[CONSTRAINT 제약조건명] REFERENCES 참조할테이블명[(참조할 컬럼명)]  -- 안써줄 경우도 있다. 프라이머리키로 되어있으면 컬럼명 넣지 않아도 된다.
    
     >>데이터 에벨 방식 
     --FOREIGNKEY(컬럼명) REFERENCES 참조할테이블명(참조할 컬럼명)
     [CONSTRAINT 제약조건명] FOREIGNKEY(컬럼명) REFERENCES 참조할테이블명(참조할 컬럼명)
     
     -->참조할 컬럼이 PRIMARY KEY이면 생략가능 (자동으로 PRIMARY KEY와 외래키를 맺음)
     --레퍼런스가 있는데 프라이머리가 없으면 외래키 
     
     
*/

CREATE TABLE MEM2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(20),
    MEM_DATE DATE,
    GRADE_ID NUMBER,
    --GRADE_ID NUMBER REFERENCES MEM_GRADE(GRADE_CODE)  -- 컬럼레벨방식
    FOREIGN KEY(GRADE_ID) REFERENCES MEM_GRADE(GRADE_CODE) -- 테이블 레벨 방식
);

INSERT INTO MEM2 VALUES(1,'user01','pass01','홍길동','남',NULLL,NULL,SYSDATE,NULL);
INSERT INTO MEM2 VALUES(2, ' user02','pass02','김길똥','여',NULL,NULL,SYSDATE, 10);
INSERT INTO MEM2 VALUES(3, ' user03','pass02','김길똥','여',NULL,NULL,SYSDATE, 10);

--MEM_GRADE (부모테이블)-------------<-MEM2(자식테이블) 

-->이때 부모테이블에서 데이터 값을 삭제할 경우 문제가 발생?
    --데이터 삭제 : DELETE FROM 테이블명 WHERE 조건;
    
-- MEM_GRADE 테이블에서 10번등급을 삭제 하고자 함 
DELETE FROM MEM_GRADE WHERE GRADE_CODE=10;
-- 자식테이블에서 10이라는 값을 사용하고 있기 때문에 삭제가 안됨 

-- MEM_GRADE 테이블에서 30번등급을 삭제 하고자 함 
DELETE FROM MEM_GRADE WHERE GRADE_CODE=30;
--자식테이블에서 30이라는 값을 사용하고 있지 않기 때문에 삭제됨

-->자식테이블에서 이미 사용되고 있는 값이 있을 경우 
-- 부모테이블로부터 무조건 삭제가 안되는 삭제 제한 옵션이 걸려있음(DEFAULT)


----------------------------------------------------------
/*
    자식테이블 생성시 외래키 제약조건 부여할 때 삭제 옵션 지정 가능 
    *삭제 옵션: 부모테이블의 데이터 삭제시 그 데이터를 사용하고 있는 자식테이블 값을 어떻게 처리할지??
    - ON DELETE RESTRICTED(기본값) : 삭제 제한 옵션으로, 자식 테이블에서 쓰이는 값은 부모테이블에서 삭제 못함 
    - ON DELETE SET NULL; 부모 테이블에서 삭제시 자식 테이블의 값은 NULL로 변경하고 부모테이블의 행삭제 가능 
    - 0N DELETE CASSCADE : 부모 테이블에서 삭제하면 자식 테이블도 삭제(행 전체 삭제) 
    보통 RESTRICTED,SET NULL 두개를 많이 쓴다. 

*/

--테이블 삭제 DROP
DROP TABLE MEM;
DROP TABLE MEM2; 
    --만들다가 처음부터 하고 싶으면 똑같은 이름으로 생성할 수 없다.
    --부분적으로 안들어가면 테이블을 드롭해주고, 있으면 삭제 없으면 안하고 
    -- 돌리고 수정하고 처음부터 다시 돌리고 

CREATE TABLE MEM(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(20),
    MEM_DATE DATE,
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE SET NULL
);

INSERT INTO MEM VALUES(1, 'user01','pass01','홍길동','남',NULL,NULL,SYSDATE,NULL);
INSERT INTO MEM VALUES(2, ' user02','pass02','김길똥','여',NULL,NULL,SYSDATE, 10);
INSERT INTO MEM VALUES(3, ' user03','pass03','뚱길똥','여',NULL,NULL,SYSDATE, 20);
INSERT INTO MEM VALUES(4, ' user04','pass04','여길녀','여',NULL,NULL,SYSDATE, 30);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE=10;



--자식 테이블은 NULL이 됨

CREATE TABLE MEM2(
    MEM_NO NUMBER PRIMARY KEY,
    MEM_ID VARCHAR2(20) NOT NULL UNIQUE,
    MEM_PW VARCHAR2(20) NOT NULL,
    MEM_NAME VARCHAR2(20) NOT NULL,
    GENDER CHAR(3) CHECK(GENDER IN('남','여')),
    PHONE VARCHAR2(20),
    EMAIL VARCHAR2(20),
    MEM_DATE DATE,
    GRADE_ID NUMBER REFERENCES MEM_GRADE ON DELETE CASCADE --자식까지 삭제 , 행 통째로 다 사라짐 
);

INSERT INTO MEM2 VALUES(1, 'user01','pass01','홍길동','남',NULL,NULL,SYSDATE,NULL);
INSERT INTO MEM2 VALUES(2, ' user02','pass02','김길똥','여',NULL,NULL,SYSDATE, 10);
INSERT INTO MEM2 VALUES(3, ' user03','pass03','뚱길똥','여',NULL,NULL,SYSDATE, 20);
INSERT INTO MEM2 VALUES(4, ' user04','pass04','여길녀','여',NULL,NULL,SYSDATE, 30);

DELETE FROM MEM_GRADE
WHERE GRADE_CODE = 10;

----------------------------------------------------------
/*
    <DEFAULT 기본값> 제약조건 아님 
    데이터 삽입시 데이터를 넣지 않을 경우 DAFAULT 값으로 들어가게 한다. 
    넣을 때 디폴트라고 하면 된다. 
*/

--탈퇴회원을 별도로 관리한다. 1년정도로 따로 보관 
--탈퇴한 회원인지 아닌지 컬럼을 추가해서 파악한다. 
--완전 탈퇴시 그때서야 없앤다. 

CREATE TABLE MEMBER2(
    MEM_NO NUMBER PRIMARY KEY, 
    MEM_ID VARCHAR2(20) NOT NULL, 
    MEM_PW VARCHAR(20) NOT NULL, 
    MEM_AGE NUMBER, 
    HOBBY VARCHAR(20) DEFAULT '없음', --열에 data_dafault에 들어가면 '없음'이라고 나온다 
    MEM_DATE DATE DEFAULT SYSDATE 
);
INSERT INTO MEMBER2 values (1,'user01','p01',24,'공부','23/11/16');
INSERT INTO MEMBER2 values (2,'user02','p02',null,null,null);
INSERT INTO MEMBER2 values (3,'user02','p02',null,default,default);


/*
===========오른쪽 위에 바꿔준다 aie계정으로 돌려야 한다.=====================

    <subquery를 이용한 테이블 생성>
    테이블 복사하는 개념
    
    [표현식]
    CREATE TABLE 테이블명 
    AS 서버쿼리; 
*/
--EMPLOYEE테이블을 복제한 새로운 테이블 생성
CREATE TABLE EMPLOYEE_COPY
AS SELECT * 
FROM EMPLOYEE;
--컬럼, 데이터값, 제약조건 같은 경우, NOT NULL만 복사됨 
--제약 조건 같은 경우 NOT NULL만 복사됨 
--프라이머리키, 외래키 복사 안됨 
--DEFAULT, COMMENT는 복사 안됨. 
--복사해도 되고안되고 차이가 있다. 

CREATE TABLE EMPLOYEE_COPY2
    AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
        FROM EMPLOYEE; 
        
--
CREATE TABLE EMPLOYEE_COPY3
    AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS
        FROM EMPLOYEE
        WHERE 1=0; --구조만 복사하고자 할 때 쓰이는 구문 (데이터 값이 필요 없을 때) 올때는 이렇게 쓴다 

CREATE TABLE EMPLOYEE_COPY4
    --AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS,SALARY*12
    --ORA-00998: 이 식은 열의 별명과 함께 지정해야 합니다
    --컬럼의 별칭을 반드시 줘야한다. 
    AS SELECT EMP_ID, EMP_NAME, SALARY, BONUS,SALARY*12 AS"연봉"
        FROM EMPLOYEE;
    --서브쿼리 SELECT 절에 산술식 또는 함수식이 기술된 경우는 반드시 별칭을 부여해 줘야 한다. 
    --★★★ 연산식에서  별칭 "연봉"처럼 써줘야 한다. 

/*
    *ALTER 테이블을 다 생성한 후에 제약조건 추가 
    ALTER TABLE 테이블명 변경할 내용;
    DELETE UPDATE는 아니다 
    -PRIMARY KEY : ALTER TABLE 테이블명 ADD PRIMARY KEY(컬럼명); --뒤에 부분은 테이블 레벨 방식으로 뒤에 넣어주면된다 
    -FOREIGN KEY : ALTER TABLE 테이블명 ADD FOREIGN KEY(컬럼명) REFERENCES 참조할 테이블명 [(참조할 테이블명)];
    -UNIQUE      : ALTER TABLE 테이블명 ADD UNIQUE(컬럼명);
    -CHECK       : ALTER TABLE 테이블명 ADD CHECK (컬럼명);
    -NOT NULL    :ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;  --NOT NULL은 ADD 사용하지 않고 MODIFY 사용 

);
-- EMPLOYEE_COPY 테이블에 PRIMARY KEY 제약조건 추가 

ALTER TABLE EMPLOYEE_COPY AND PRIMARY KEY(EMP_ID);











CREATE TABLE TEST(
    COL1 CHAR,
    COL2  CHAR 
    
    
INSERT INTO TEST VALUES(1,'');