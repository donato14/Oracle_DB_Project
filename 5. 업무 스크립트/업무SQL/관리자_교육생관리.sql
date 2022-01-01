/*
 [교육생 관리]
 관리자는 여러명의 교육생 정보를 등록 및 관리 할 수 있어야 한다.
 */

--전체 수강생정보 출력
SELECT *
FROM TBLSTUDENT;


------------------------------------------------------------------------------------------------------------------------
-- 교육생 정보 입력시 교육생이름, 주민번호 뒷자리, 전화번호를 기본으로 등록하고
-- 주민번호 뒷자리는 교육생 패스워드로 사용, 등록일은 자동으로 입력되도록 한다
INSERT INTO TBLSTUDENT (STUDENT_SEQ, NAME, IDCARD_NUMBER, TEL, REGISTRATION_DATE)
VALUES ('S0501',
           --(SELECT CONCAT('S',LPAD(MAX(SUBSTR(STUDENT_SEQ,3,3))+1,4,'0')) FROM TBLSTUDENT),
        '강규준',
        '1234567',
        '010-5671-0790',
        TO_CHAR(SYSDATE, 'RRRR-MM-DD'));

--(SELECT CONCAT('S0',MAX(SUBSTR(STUDENT_SEQ,3,3))+1) FROM TBLSTUDENT)

--********** 교육생 추가 정의 프로시저 *********--
--교육생을 등록 할 수 있다.
CREATE OR REPLACE PROCEDURE ProcAddStudent_M(
    P_NAME VARCHAR2,
    P_IDCARD_NUMBER VARCHAR2,
    P_TEL VARCHAR2,
    P_RESULT OUT NUMBER
)
    IS
    PSEQ VARCHAR2(10);
BEGIN
    SELECT CONCAT('S', LPAD(MAX(SUBSTR(STUDENT_SEQ, 3, 3)) + 1, 4, '0')) INTO PSEQ FROM TBLSTUDENT;
    INSERT INTO TBLSTUDENT (STUDENT_SEQ, NAME, IDCARD_NUMBER, TEL, REGISTRATION_DATE)
    VALUES (PSEQ,
            P_NAME,
            P_IDCARD_NUMBER,
            P_TEL,
            TO_CHAR(SYSDATE, 'RRRR-MM-DD'));
    P_RESULT := 1;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULT := 0;
END ProcAddStudent_M;

--********** 교육생 추가 프로시저 테스트 **********--
DECLARE
    VRESULT NUMBER;
BEGIN
    ProcAddStudent_M(
            '강규준',
            '1234567',
            '010-5671-0790',
            VRESULT
        );
    IF VRESULT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('등록성공');
    ELSE
        DBMS_OUTPUT.PUT_LINE('등록실패');
    end if;
end;

--********** 교육생 추가 프로시저 확인용 **********--
SELECT *
FROM TBLSTUDENT;

--********** 교육생 중도탈락 시 입력 프로시저 정의 **********--
-- 중도탈락시
CREATE OR REPLACE PROCEDURE ProcUpdateStudentDropoutDate_M(
    P_STUDENT_SEQ VARCHAR2,
    P_OPEN_COURSE_SEQ VARCHAR2,
    P_COMPLETION_STATUS CHAR,
    P_DROPOUT_DATE VARCHAR2,
    P_RESULT OUT NUMBER
)
    IS
BEGIN
    UPDATE TBLREGISTER
    SET COMPLETION_STATUS= P_COMPLETION_STATUS
    WHERE STUDENT_SEQ = P_STUDENT_SEQ AND OPEN_COURSE_SEQ = P_OPEN_COURSE_SEQ;

    UPDATE TBLREGISTER
    SET DROPOUT_DATE = P_DROPOUT_DATE
    WHERE STUDENT_SEQ = P_STUDENT_SEQ AND OPEN_COURSE_SEQ = P_OPEN_COURSE_SEQ;

    P_RESULT := 1;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULT := 0;
END ProcUpdateStudentDropoutDate_M;

--********** 중도탈락 프로시저 테스트 **********--
DECLARE
    V_RESULT NUMBER;
BEGIN
    ProcUpdateStudentDropoutDate_M('S0126','OL003', 'N', '2021-12-03', V_RESULT);
    IF V_RESULT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('중도탈락 처리 완료');
    ELSE
        DBMS_OUTPUT.PUT_LINE('중도탈락 처리 실패');
    end if;
end;
--********** 교육생 수료 시 입력 프로시저 정의 **********--
-- 수료시
CREATE OR REPLACE PROCEDURE ProcUpdateStudentCompletionDate_M(
    P_STUDENT_SEQ VARCHAR2,
    P_OPEN_COURSE_SEQ VARCHAR2,
    P_COMPLETION_STATUS VARCHAR2,
    P_COMPLETION_DATE VARCHAR2,
    P_RESULT OUT NUMBER
)
IS
BEGIN
    UPDATE TBLREGISTER
    SET COMPLETION_STATUS = P_COMPLETION_STATUS
    WHERE STUDENT_SEQ = P_STUDENT_SEQ AND OPEN_COURSE_SEQ = P_OPEN_COURSE_SEQ;

    UPDATE TBLREGISTER
    SET COMPLETION_DATE = P_COMPLETION_DATE
    WHERE STUDENT_SEQ = P_STUDENT_SEQ AND OPEN_COURSE_SEQ = P_OPEN_COURSE_SEQ;

    P_RESULT := 1;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULT :=0;
END ProcUpdateStudentCompletionDate_M;
--********** 수료 프로시저 테스트 **********--
DECLARE
    V_RESULT NUMBER;
BEGIN
    ProcUpdateStudentCompletionDate_M('S0126','OL003','Y','2021-12-03',V_RESULT);
    IF V_RESULT = 1 THEN
        DBMS_OUTPUT.PUT_LINE('수료처리 완료');
    ELSE
        DBMS_OUTPUT.PUT_LINE('수료처리 실패');
    end if;
END;

--********** 교육색 삭제 프로시저 정의 **********--
CREATE OR REPLACE PROCEDURE ProcDeleteStudent_M(
    P_STUDENT_SEQ VARCHAR2,
    P_RESULT OUT NUMBER
)
IS
BEGIN
   DELETE FROM TBLSTUDENT WHERE STUDENT_SEQ = P_STUDENT_SEQ;
   P_RESULT := 1;
EXCEPTION
    WHEN OTHERS THEN
        P_RESULT := 0;
END ProcDeleteStudent_M;

--********** 교육색 삭제 프로시저 테스트 **********--
DECLARE
    V_RESULT NUMBER;
BEGIN
    ProcDeleteStudent_M('S0501',V_RESULT);
    IF V_RESULT =1 THEN
        DBMS_OUTPUT.PUT_LINE('삭제완료');
    ELSE
        DBMS_OUTPUT.PUT_LINE('삭제실패');
    end if;
END;

--********** 프로시저 삭제 **********--
DROP PROCEDURE ProcAddStudent_M;
DROP PROCEDURE ProcUpdateStudentDropoutDate_M;
DROP PROCEDURE ProcUpdateStudentCompletionDate_M;
DROP PROCEDURE ProcDeleteStudent_M;
------------------------------------------------------------------------------------------------------------------------

DELETE
FROM TBLSTUDENT
WHERE NAME = '강규준';
------------------------------------------------------------------------------------------------------------------------
-- 교육생 정보 출력시 교육생 이름, 주민번호 뒷자리, 전화번호, 등록일, 수강(신청)횟수를 출력한다
SELECT DISTINCT STU.NAME                                                                               AS 교육생이름,
                STU.IDCARD_NUMBER                                                                      AS 주민번호뒷자리,
                STU.TEL                                                                                AS 전화번호,
                STU.REGISTRATION_DATE                                                                  AS 등록일,
                (SELECT COUNT(COMPLETION_STATUS) FROM TBLREGISTER WHERE STUDENT_SEQ = STU.STUDENT_SEQ) AS 수강신청횟수
FROM TBLSTUDENT STU
         INNER JOIN TBLREGISTER REG on STU.STUDENT_SEQ = REG.STUDENT_SEQ;


------------------------------------------------------------------------------------------------------------------------
--특정 교육생 선택시 교육생이 수강 신청한 또는 수강중인, 수강했던
--개설 과정 정보(과정명, 과정기간(시작,끝),강의실, 수료 및 중도탈락 여부, 수료 및 중도탈락 날짜) 출력
SELECT COUR.NAME                  AS 과정명,
       OPENCOUR.COURSE_START_DATE AS 과정시작날짜,
       OPENCOUR.COURSE_END_DATE   AS 과정종료날짜,
       ROOM.NAME                  AS 강의실,
       REG.COMPLETION_STATUS      AS 수료여부,
       REG.COMPLETION_DATE        AS 수료날짜,
       REG.DROPOUT_DATE           AS 중도탈락날짜

FROM TBLSTUDENT STU
         INNER JOIN TBLREGISTER REG
                    on STU.STUDENT_SEQ = REG.STUDENT_SEQ
         INNER JOIN TBLOPENCOURSE OPENCOUR
                    on REG.OPEN_COURSE_SEQ = OPENCOUR.OPEN_COURSE_SEQ
         INNER JOIN TBLCOURSE COUR
                    on OPENCOUR.COURSE_SEQ = COUR.COURSE_SEQ
         INNER JOIN TBLCLASSROOM ROOM
                    on OPENCOUR.CLASSROOM_SEQ = ROOM.CLASSROOM_SEQ
WHERE STU.STUDENT_SEQ = 'S0106';
--김주혁, 주혁시
------------------------------------------------------------------------------------------------------------------------
-- 교육생 정보를 쉽게 확인하기 위한 검색 기능을 사용할 수 있어야 한다
SELECT DISTINCT STU.NAME                                                                               AS 교육생이름,
                STU.IDCARD_NUMBER                                                                      AS 주민번호뒷자리,
                STU.TEL                                                                                AS 전화번호,
                STU.REGISTRATION_DATE                                                                  AS 등록일,
                (SELECT COUNT(COMPLETION_STATUS) FROM TBLREGISTER WHERE STUDENT_SEQ = STU.STUDENT_SEQ) AS 수강신청횟수
FROM TBLSTUDENT STU
         INNER JOIN TBLREGISTER REG on STU.STUDENT_SEQ = REG.STUDENT_SEQ
WHERE STU.STUDENT_SEQ = 'S0373';
--김주혁,

------------------------------------------------------------------------------------------------------------------------
--교육생에 대한 수료 및 중도탈락처리를 할 수 있어야 한다. 수료 또는 중도탈락 날짜를 입력할 수 있어야한다.

SELECT COUR.NAME                  AS 과정명,
       OPENCOUR.COURSE_START_DATE AS 과정시작날짜,
       OPENCOUR.COURSE_END_DATE   AS 과정종료날짜,
       ROOM.NAME                  AS 강의실,
       REG.COMPLETION_STATUS      AS 수료여부,
       REG.COMPLETION_DATE        AS 수료날짜,
       REG.DROPOUT_DATE           AS 중도탈락날짜,
       REG.STUDENT_SEQ            AS 교육생번호

FROM TBLSTUDENT STU
         INNER JOIN TBLREGISTER REG
                    on STU.STUDENT_SEQ = REG.STUDENT_SEQ
         INNER JOIN TBLOPENCOURSE OPENCOUR
                    on REG.OPEN_COURSE_SEQ = OPENCOUR.OPEN_COURSE_SEQ
         INNER JOIN TBLCOURSE COUR
                    on OPENCOUR.COURSE_SEQ = COUR.COURSE_SEQ
         INNER JOIN TBLCLASSROOM ROOM
                    on OPENCOUR.CLASSROOM_SEQ = ROOM.CLASSROOM_SEQ
WHERE STU.STUDENT_SEQ = 'S0126';

--초기화용
UPDATE TBLREGISTER
SET COMPLETION_STATUS='',
    COMPLETION_DATE='',
    DROPOUT_DATE=''
WHERE STUDENT_SEQ = 'S0126'
  AND OPEN_COURSE_SEQ = 'OL003';
--중도탈락시
UPDATE TBLREGISTER
SET COMPLETION_STATUS='N',
    DROPOUT_DATE=TO_DATE(SYSDATE, 'RRRR-MM-DD')
WHERE STUDENT_SEQ = 'S0126'
  AND OPEN_COURSE_SEQ = 'OL003';
--수료시
UPDATE TBLREGISTER
SET COMPLETION_STATUS='Y',
    COMPLETION_DATE=TO_DATE(SYSDATE, 'RRRR-MM-DD')
WHERE STUDENT_SEQ = 'S0126'
  AND OPEN_COURSE_SEQ = 'OL003';



ALTER SESSION SET TIME_ZONE ='Asia/Seoul';

select to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'), to_char(current_date, 'yyyy-mm-dd hh24:mi:ss')
from dual;


SELECT SYSDATE
FROM DUAL;