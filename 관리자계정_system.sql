-- ���� �ּ� (ctrl + / ) 
/*
  ������ �ּ� (alt + shift + c)
*/

--Ŀ���� �����̴� �� 
--���� ���� ���� 
show user;

--����� ���� ��ȸ 
select * from DBA_USERS;

--���� �����
--create user ����ڸ� IDENTIFIED by ��й�ȣ;
--create user c##user1 IDENTIFIED by user1234;
create user c##user4 IDENTIFIED by "1234";

--����� �̸��� c##���̴� ���� ȸ���ϴ� ���
ALTER SESSION set "_oracle_script" = true;
create user user5 IDENTIFIED BY user7;

--����� �̸��� ��ҹ��ڸ� ������ �ʴ´�.
--���� ����� ���� ���� (������ ��� �����ϰ�)
CREATE user aie IDENTIFIED BY aie;
-- ���̺� ����� ���ѻ��� ���ֱ� 

--���ѻ���
--[ǥ����]grant ����1, ����2, ... to  ������;
GRANT RESOURCE, CONNECT TO aie;

--user ���� 
--[ǥ����] drop user ����ڸ�; => ���̺��� ���� ���� 
--[ǥ����] drop user ����ڸ� cascade ;  =>���̺���� ��λ��� 

DROP user user5;

/* ���̺� �����̽� : �������� ��� ������ ���̺��� �� �� �� �� ������ �־��ְ� �Ǿ� �ִ�.
��������� ������ �� ���ΰ�  1�� (1���� 2������ �� ���� ���δ�)
*/
ALTER USER aie DEFAULT TABLESPACE users quota UNLIMITED on users;

-- ���̺� �����̽��� ������ Ư�� �뷮��ŭ �Ҵ��Ϸ��� 2��
ALTER USER user7 QUOTA 30M on users;

/*
1)����- 2)���� ���� - 3)���� �󸶸�ŭ �� ���ΰ�. 
1.CREATE user aie IDENTIFIED BY aie;
2.GRANT RESOURCE, CONNECT TO aie;
3.ALTER USER aie DEFAULT TABLESPACE users quota UNLIMITED on users;
*/




