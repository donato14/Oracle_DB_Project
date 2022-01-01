------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
--********** 교육생 추가 프로시저 확인용 **********--
SELECT *
FROM TBLSTUDENT;
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
--********** 프로시저 삭제 **********--
DROP PROCEDURE ProcAddStudent_M;
DROP PROCEDURE ProcUpdateStudentDropoutDate_M;
DROP PROCEDURE ProcUpdateStudentCompletionDate_M;
DROP PROCEDURE ProcDeleteStudent_M;
------------------------------------------------------------------------------------------------------------------------