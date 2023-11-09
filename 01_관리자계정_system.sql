-- 한줄 주석 (ctrl + / ) 
/*
  여러줄 주석 (alt + shift + c)
*/

--커서가 깜빡이는 곳 
--나의 계정 보기 
show user;

--사용자 계정 조회 
select * from DBA_USERS;

--계정 만들기
--create user 사용자명 IDENTIFIED by 비밀번호;
--create user c##user1 IDENTIFIED by user1234;
create user c##user4 IDENTIFIED by "1234";

--사용자 이름에 c##붙이는 것을 회피하는 방법
ALTER SESSION set "_oracle_script" = true;
create user user5 IDENTIFIED BY user7;

--사용자 이름은 대소문자를 가리지 않는다.
--실제 사용할 계정 생성 (계정과 비번 동일하게)
CREATE user aie IDENTIFIED BY aie;
-- 테이블 만들고 권한생성 해주기 

--권한생성
--[표현법]grant 권한1, 권한2, ... to  계정명;
GRANT RESOURCE, CONNECT TO aie;

--user 삭제 
--[표현법] drop user 사용자명; => 테이블이 없는 상태 
--[표현법] drop user 사용자명 cascade ;  =>테이블까지 모두삭제 

DROP user user5;

/* 테이블 스페이스 : 유저에게 어느 정도의 테이블을 할 당 해 줄 것인지 넣어주게 되어 있다.
어느정도의 범위를 줄 것인가  1번 (1번이 2번보다 더 많이 쓰인다)
제한없이(UNLIMITED)
*/
ALTER USER aie DEFAULT TABLESPACE users quota UNLIMITED on users;

-- 테이블 스페이스의 영역을 특정 용량만큼 할당하려면 2번
ALTER USER user7 QUOTA 30M on users;

ALTER USER aie DEFAULT TABLESPACE users quota UNLIMITED on users;
/*
1)생성- 2)권한 생성 - 3)권한 얼마만큼 줄 것인가. 
1.CREATE user aie IDENTIFIED BY aie;
2.GRANT RESOURCE, CONNECT TO aie;
3.ALTER USER aie DEFAULT TABLESPACE users quota UNLIMITED on users;
저장은 c-이름-workspace에 저장 
*/




