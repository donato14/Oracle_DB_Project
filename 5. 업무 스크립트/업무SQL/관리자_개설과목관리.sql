/*
[개설과목 관리]
- 관리자는 개설 과정에 대해서 종속적으로 여러 개의 개설 과목을 등록 및 관리할 수 있어야 한다.
 */

-- 전체 내용 확인
SELECT *
FROM TBLOPENSUBJECT;

------------------------------------------------------------------------------------------------------------------------
--2.특정 개설 과정 선택시 개설 과목 정보 출력
SELECT OPEN_COURSE_SEQ
FROM TBLOPENCOURSE
WHERE SYSDATE BETWEEN COURSE_START_DATE AND COURSE_END_DATE;
-- 현재 개설 과정 OL001 ~ OL006 까지 있음


SELECT OPEN_COURSE_SEQ         AS 개설과정번호,
       OPEN_SUBJECT_SEQ        AS 개설과목번호,
       SUBJECT_SEQ             AS 과목번호,
       TEACHER_SEQ             AS 교사번호,
       TEXTBOOK_SEQ            AS 교재번호,
       SUBJECT_START_DATE      AS 과목시작일,
       SUBJECT_END_DATE        AS 과목종료일,
       SUBJECT_PROGRESS        AS 강의진행여부,
       SCORE_CHECK             AS 성적등록여부,
       TESTFILE_CHECK          AS 시험문제파일등록여부,
       ATTENDANCE_DISTRIBUTION AS 출결배점,
       WRITTEN_DISTRIBUTION    AS 필기배점,
       PRACTICAL_DISTRIBUTION  AS 실기배점
FROM TBLOPENSUBJECT
WHERE OPEN_COURSE_SEQ = 'OL006';
--OL006 과정선택시 출력되는 정보들

------------------------------------------------------------------------------------------------------------------------
--2-1.특정 개설 과정 선택시 개설 과목 신규 등록
-- 특정과정 OL006 에 새로운 과목 정보 입력시
-- 과목명, 과목기간(시작, 끝), 교재명, 교사명 입력 가능해야함
-- 교재명은 기초 정보 교재명에서 선택적으로 추가할 수 있다.

-- 추가사항
-- 개설과목번호[OS081], 과목명[UI디자인], 교사명[정성훈], 교재명[모바일 UI/UX 디자인 실무], 과목시작날짜[2022-07-04], 과목종료날짜[2022-08-03]
INSERT INTO TBLOPENSUBJECT (OPEN_SUBJECT_SEQ, SUBJECT_SEQ, TEACHER_SEQ, TEXTBOOK_SEQ, SUBJECT_START_DATE,
                            SUBJECT_END_DATE, SUBJECT_PROGRESS, SCORE_CHECK, TESTFILE_CHECK, ATTENDANCE_DISTRIBUTION,
                            WRITTEN_DISTRIBUTION, PRACTICAL_DISTRIBUTION, OPEN_COURSE_SEQ)
VALUES ('OS081',
           --(SELECT CONCAT('OS',LPAD(MAX(SUBSTR(OPEN_SUBJECT_SEQ,4,2))+1,3,'0')) FROM TBLOPENSUBJECT),
        (SELECT SUBJECT_SEQ FROM TBLSUBJECT WHERE NAME = 'UI디자인'),
        (SELECT TEACHER_SEQ FROM TBLTEACHER WHERE NAME = '정성훈'),
        (SELECT TEXTBOOK_SEQ FROM TBLTEXTBOOK WHERE NAME = '모바일 UI/UX 디자인 실무'),
        '2022-07-04',
        '2022-08-03',
        CASE
            WHEN (SYSDATE BETWEEN TO_DATE('2022-07-04', 'YYYY-MM-DD') AND TO_DATE('2022-08-03', 'YYYY-MM-DD'))
                THEN '강의중'
            WHEN (SYSDATE < TO_DATE('2022-07-04', 'YYYY-MM-DD')) THEN '강의예정'
            WHEN (SYSDATE > TO_DATE('2022-08-03', 'YYYY-MM-DD')) THEN '강의종료'
            ELSE '폐강'
            END,
        'N',
        'N',
        '', '', '',
        'OL006');

--********** 개설 과목 추가 정의 프로시저 *********--
--특정과정(OL006)에 새로운 과목을 개설 할 수 있다.
--프로시저 정의
CREATE OR REPLACE PROCEDURE procAddOpenSubject_M(
    P_SUBJECT_SEQ VARCHAR2,
    P_TEACHER_SEQ VARCHAR2,
    P_TEXTBOOK_SEQ VARCHAR2,
    P_SUBJECT_START_DATE VARCHAR2,
    P_SUBJECT_END_DATE VARCHAR2,
    P_SUBJECT_PROGRESS VARCHAR2,
    P_SCORE_CHECK CHAR,
    P_TESTFILE_CHECK CHAR,
    P_ATTENDANCE_DISTRIBUTION NUMBER,
    P_WRITTEN_DISTRIBUTION NUMBER,
    P_PRACTICAL_DISTRIBUTION NUMBER,
    P_OPEN_CUORSE_SEQ VARCHAR2,
    P_RESULT OUT NUMBER --성공(1) or 실패(0)
)
    IS
    -- pseq 변수 하나 만들어서 SELECT 문에 INTO 사용해야함
    PSEQ VARCHAR2(10);
BEGIN
    --1.
    SELECT CONCAT('OS', LPAD(MAX(SUBSTR(OPEN_SUBJECT_SEQ, 4, 2)) + 1, 3, '0')) INTO PSEQ FROM TBLOPENSUBJECT;
    INSERT INTO TBLOPENSUBJECT (OPEN_SUBJECT_SEQ, SUBJECT_SEQ, TEACHER_SEQ, TEXTBOOK_SEQ, SUBJECT_START_DATE,
                                SUBJECT_END_DATE, SUBJECT_PROGRESS, SCORE_CHECK, TESTFILE_CHECK,
                                ATTENDANCE_DISTRIBUTION,
                                WRITTEN_DISTRIBUTION, PRACTICAL_DISTRIBUTION, OPEN_COURSE_SEQ)
    VALUES (PSEQ,
            P_SUBJECT_SEQ,
            P_TEACHER_SEQ,
            P_TEXTBOOK_SEQ,
            P_SUBJECT_START_DATE,
            P_SUBJECT_END_DATE,
            P_SUBJECT_PROGRESS,
            P_SCORE_CHECK,
            P_TESTFILE_CHECK,
            P_ATTENDANCE_DISTRIBUTION,
            P_WRITTEN_DISTRIBUTION,
            P_PRACTICAL_DISTRIBUTION,
            P_OPEN_CUORSE_SEQ);
    P_RESULT := 1;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULT := 0;
END procAddOpenSubject_M;

--********** 개설과목 추가 프로시저 테스트 **********--
DECLARE
    VRESULT NUMBER;
BEGIN
    procAddOpenSubject_M
        ('SUB019',
         'T010',
         'B057',
         '2022-07-04',
         '2022-08-03',
         (CASE
              WHEN (SYSDATE BETWEEN TO_DATE('2022-07-04', 'YYYY-MM-DD') AND TO_DATE('2022-08-03', 'YYYY-MM-DD'))
                  THEN '강의중'
              WHEN (SYSDATE < TO_DATE('2022-07-04', 'YYYY-MM-DD')) THEN '강의예정'
              WHEN (SYSDATE > TO_DATE('2022-08-03', 'YYYY-MM-DD')) THEN '강의종료'
              ELSE '폐강'
             END),
         'N',
         'N',
         '',
         '',
         '',
         'OL006',
         VRESULT
        );
    if VRESULT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('입력성공');
    else
        DBMS_OUTPUT.PUT_LINE('입력실패');
    end if;
end ;

--********** 확인용 **********--
SELECT OPEN_COURSE_SEQ         AS 개설과정번호,
       OPEN_SUBJECT_SEQ        AS 개설과목번호,
       SUBJECT_SEQ             AS 과목번호,
       TEACHER_SEQ             AS 교사번호,
       TEXTBOOK_SEQ            AS 교재번호,
       SUBJECT_START_DATE      AS 과목시작일,
       SUBJECT_END_DATE        AS 과목종료일,
       SUBJECT_PROGRESS        AS 강의진행여부,
       SCORE_CHECK             AS 성적등록여부,
       TESTFILE_CHECK          AS 시험문제파일등록여부,
       ATTENDANCE_DISTRIBUTION AS 출결배점,
       WRITTEN_DISTRIBUTION    AS 필기배점,
       PRACTICAL_DISTRIBUTION  AS 실기배점
FROM TBLOPENSUBJECT
WHERE OPEN_COURSE_SEQ = 'OL006';

--********** 추가한 개설과목번호 삭제 정의 프로시저 **********--

CREATE OR REPLACE PROCEDURE ProcDeleteOpenSubject_M(
    P_SUBJECT_SEQ VARCHAR2,
    P_RESULT OUT NUMBER
)
    IS
BEGIN
    DELETE FROM TBLOPENSUBJECT WHERE OPEN_SUBJECT_SEQ = P_SUBJECT_SEQ;
    P_RESULT := 1;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULT := 0;
end ProcDeleteOpenSubject_M;
--********** 프로시저 테스트 **********--
DECLARE
    V_RESULT NUMBER;
BEGIN
    ProcDeleteOpenSubject_M('OS081', V_RESULT);
    IF V_RESULT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('삭제완료');
    else
        DBMS_OUTPUT.PUT_LINE('삭제실패');
    end if;
end;

--********** 개설과목 정보(교사번호) 변경 정의 **********--
CREATE OR REPLACE PROCEDURE ProcUpdateOpenSubject_M(
    P_TEACHER_SEQ VARCHAR2,
    P_OPEN_SUBJECT_SEQ VARCHAR2,
    P_RESULT OUT NUMBER
)
    IS
BEGIN
    UPDATE TBLOPENSUBJECT
    SET TEACHER_SEQ=P_TEACHER_SEQ
    WHERE OPEN_SUBJECT_SEQ = P_OPEN_SUBJECT_SEQ;
    P_RESULT := 1;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULT := 0;
end ProcUpdateOpenSubject_M;

--********** 교사 변경 프로시저 테스트 **********--
DECLARE
    V_RESULT NUMBER;
BEGIN
    ProcUpdateOpenSubject_M('T009', 'OS081', V_RESULT);
    IF V_RESULT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('수정성공');
    ELSE
        DBMS_OUTPUT.PUT_LINE('수정실패');
    end if;
end;

--********** 프로시저 삭제 **********--
DROP PROCEDURE procAddOpenSubject_M;
DROP PROCEDURE ProcDeleteOpenSubject_M;
DROP PROCEDURE ProcUpdateOpenSubject_M;

------------------------------------------------------------------------------------------------------------------------
-- 2-2. 교사 명단은 현재 과목과 강의 가능 과목이 일치하는 교사 명단만 보여야 한다.
-- 교재명은 기초 정보 교재명에서 선택적으로 추가할 수 있어야 한다
-- 교사명은 교사 명단에서 선택적으로 추가할 수 있어야한다.
-- 교사 명단은 현재 과목과 강의 가능 과목이 일치하는 교사 명단만 보여야한다
SELECT TC.TEACHER_SEQ  AS 강사번호,
       TC.NAME         AS 강사이름,
       SUB.SUBJECT_SEQ AS 강의가능과목번호,
       SUB.NAME        AS 강의가능과목이름

FROM TBLTEACHERSUBJECT
         INNER JOIN TBLTEACHER TC on TBLTEACHERSUBJECT.TEACHER_SEQ = TC.TEACHER_SEQ
         INNER JOIN TBLSUBJECT SUB on SUB.SUBJECT_SEQ = TBLTEACHERSUBJECT.SUBJECT_SEQ;
------------------------------------------------------------------------------------------------------------------------
-- 2-3. 개설과목 출력시 개설 과정 정보(과정명, 과정기간(시작,끝) 강의실), 과목명, 과목기간(시작,끝),교재명,교사명


SELECT COUR.NAME                  AS 과정명,
       OPENCOUR.COURSE_START_DATE AS 과정시작기간,
       OPENCOUR.COURSE_END_DATE   AS 과정종료기간,
       ROOM.NAME                  AS 강의실명,
       SUB.NAME                   AS 과목명,
       OPENSUB.SUBJECT_START_DATE AS 과목시작기간,
       OPENSUB.SUBJECT_END_DATE   AS 과목종료기간,
       TXT.NAME                   AS 교재명,
       TC.NAME                    AS 교사명
FROM TBLOPENSUBJECT OPENSUB
         INNER JOIN TBLOPENCOURSE OPENCOUR
                    on OPENCOUR.OPEN_COURSE_SEQ = OPENSUB.OPEN_COURSE_SEQ
         INNER JOIN TBLCOURSE COUR
                    on COUR.COURSE_SEQ = OPENCOUR.COURSE_SEQ
         INNER JOIN TBLCLASSROOM ROOM
                    on ROOM.CLASSROOM_SEQ = OPENCOUR.CLASSROOM_SEQ
         INNER JOIN TBLSUBJECT SUB
                    on SUB.SUBJECT_SEQ = OPENSUB.SUBJECT_SEQ
         INNER JOIN TBLTEXTBOOK TXT
                    on OPENSUB.TEXTBOOK_SEQ = TXT.TEXTBOOK_SEQ
         INNER JOIN TBLTEACHER TC on OPENSUB.TEACHER_SEQ = TC.TEACHER_SEQ;
------------------------------------------------------------------------------------------------------------------------

--1. 개설 과목 정보 출력
-- (1.1)개설과목 출력
SELECT OPEN_COURSE_SEQ  AS 개설과정번호,
       OPEN_SUBJECT_SEQ AS 개설과목번호,
       SUBJECT_SEQ      AS 과목번호,
       TEACHER_SEQ      AS 교사번호,
       TEXTBOOK_SEQ     AS 력과목시작일,
       SUBJECT_END_DATE AS 과목종료일,
       SUBJECT_PROGRESS AS 강의진행여부,
       SCORE_CHECK      AS 성적등록여부,
       TESTFILE_CHECK   AS 시험문제파일등록여부
FROM TBLOPENSUBJECT;

-- (1.2)개설과목 입력
INSERT INTO TBLOPENSUBJECT (OPEN_SUBJECT_SEQ, SUBJECT_SEQ, TEACHER_SEQ, TEXTBOOK_SEQ, SUBJECT_START_DATE,
                            SUBJECT_END_DATE, SUBJECT_PROGRESS, SCORE_CHECK, TESTFILE_CHECK, ATTENDANCE_DISTRIBUTION,
                            WRITTEN_DISTRIBUTION, PRACTICAL_DISTRIBUTION, OPEN_COURSE_SEQ)
VALUES ('OS081',
           --(SELECT CONCAT('OS',LPAD(MAX(SUBSTR(OPEN_SUBJECT_SEQ,4,2))+1,3,'0')) FROM TBLOPENSUBJECT),
        (SELECT SUBJECT_SEQ FROM TBLSUBJECT WHERE NAME = 'UI디자인'),
        (SELECT TEACHER_SEQ FROM TBLTEACHER WHERE NAME = '정성훈'),
        (SELECT TEXTBOOK_SEQ FROM TBLTEXTBOOK WHERE NAME = '모바일 UI/UX 디자인 실무'), '2022-07-04', '2022-08-03', '강의예정', 'N',
        'N', '', '', '', 'OL016');

-- (1.3)개설과목 삭제
-- 삭제하고자 하는 행의 개설과목번호(OPEN_SUBJECT_SEQ)를 선택하면 된다.
-- *** WHERE문 꼭 사용
DELETE
FROM TBLOPENSUBJECT
WHERE OPEN_SUBJECT_SEQ = 'OS081';

-- (1.4)개설과목 수정
-- 수정하고자 하는 행의 컬럼을 선택하고 수정값을 넣고, 수정하고자하는 PK키를 넣은 뒤 실행하면 수정이 진행된다.
-- *** WHERE문 꼭 사용
UPDATE TBLOPENSUBJECT
SET TEACHER_SEQ='T009'
WHERE OPEN_SUBJECT_SEQ = 'OS081';


------------------------------------------------------------------------------------------------------------------------

SELECT SYSDATE, CURRENT_DATE, DBTIMEZONE, SESSIONTIMEZONE
FROM DUAL;

select to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'), to_char(current_date, 'yyyy-mm-dd hh24:mi:ss')
from dual;

ALTER SESSION SET TIME_ZONE ='Asia/Seoul';


