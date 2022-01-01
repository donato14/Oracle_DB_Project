------------------------------------------------------------------------------------------------------------------------
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
    PSEQ VARCHAR2(10);
BEGIN
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
--********** 수정 되었는지 확인용 **********--
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------------
--********** 프로시저 삭제 **********--
DROP PROCEDURE procAddOpenSubject_M;
DROP PROCEDURE ProcDeleteOpenSubject_M;
DROP PROCEDURE ProcUpdateOpenSubject_M;
------------------------------------------------------------------------------------------------------------------------