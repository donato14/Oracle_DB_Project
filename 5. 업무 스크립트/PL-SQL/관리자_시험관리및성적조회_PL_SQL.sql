
CREATE VIEW VWOpenSubjectScore_M
AS
SELECT DISTINCT COUR.NAME                    AS 개설과정명,
                OPENCOUR.COURSE_START_DATE   AS 과정시작날짜,
                OPENCOUR.COURSE_END_DATE     AS 과정종료날짜,
                ROOM.NAME                    AS 강의실명,
                SUB.NAME                     AS 개설과목명,
                TC.NAME                      AS 교사명,
                TXT.NAME                     AS 교재명,
                STU.NAME                     AS 교육생이름,
                STU.IDCARD_NUMBER            AS 주민번호뒷자리,
                SC.ATTENDANCE_SCORE          AS 출결점수,
                ROUND(SC.WRITTEN_SCORE, 1)   AS 필기점수,
                ROUND(SC.PRACTICAL_SCORE, 1) AS 실기점수,
                ROUND(SC.SUBJECT_SCORE, 1)   AS 과목점수
FROM TBLSCOREINFO SC
         INNER JOIN TBLOPENSUBJECT OPENSUB
                    on SC.OPENSUBJECT_SEQ = OPENSUB.OPEN_SUBJECT_SEQ
         INNER JOIN TBLREGISTER REG
                    on SC.STUDENT_SEQ = REG.STUDENT_SEQ
         INNER JOIN TBLOPENCOURSE OPENCOUR
                    on OPENSUB.OPEN_COURSE_SEQ = OPENCOUR.OPEN_COURSE_SEQ
         INNER JOIN TBLSTUDENT STU
                    on REG.STUDENT_SEQ = STU.STUDENT_SEQ
         INNER JOIN TBLCOURSE COUR
                    on OPENCOUR.COURSE_SEQ = COUR.COURSE_SEQ
         INNER JOIN TBLSUBJECT SUB
                    on OPENSUB.SUBJECT_SEQ = SUB.SUBJECT_SEQ
         INNER JOIN TBLCLASSROOM ROOM
                    on OPENCOUR.CLASSROOM_SEQ = ROOM.CLASSROOM_SEQ
         INNER JOIN TBLTEXTBOOK TXT
                    on OPENSUB.TEXTBOOK_SEQ = TXT.TEXTBOOK_SEQ
         INNER JOIN TBLTEACHER TC
                    on OPENSUB.TEACHER_SEQ = TC.TEACHER_SEQ
WHERE SC.OPENSUBJECT_SEQ = 'OS001';
--*************** 과목별 출력시 출력 정보 ***************--
SELECT * FROM VWOpenSubjectScore_M;

--교육생개인별

--개설과정명, 개설과정기간, 강의실명, 개설과목명, 교사명, 교재명
--개설 과목을 수강한 모든 교육생의 성적정보(교육생이름, 주민번호뒷자리,필기,실기)

CREATE VIEW VWOpenSubjectStudentScore_M
AS
    SELECT DISTINCT COUR.NAME                    AS 개설과정명,
                OPENCOUR.COURSE_START_DATE   AS 과정시작날짜,
                OPENCOUR.COURSE_END_DATE     AS 과정종료날짜,
                ROOM.NAME                    AS 강의실명,
                SUB.NAME                     AS 개설과목명,
                TC.NAME                      AS 교사명,
                TXT.NAME                     AS 교재명,
                STU.NAME                     AS 교육생이름,
                STU.IDCARD_NUMBER            AS 주민번호뒷자리,
                SC.ATTENDANCE_SCORE          AS 출결점수,
                ROUND(SC.WRITTEN_SCORE, 1)   AS 필기점수,
                ROUND(SC.PRACTICAL_SCORE, 1) AS 실기점수,
                ROUND(SC.SUBJECT_SCORE, 1)   AS 과목점수
FROM TBLSCOREINFO SC
         INNER JOIN TBLOPENSUBJECT OPENSUB
                    on SC.OPENSUBJECT_SEQ = OPENSUB.OPEN_SUBJECT_SEQ
         INNER JOIN TBLREGISTER REG
                    on SC.STUDENT_SEQ = REG.STUDENT_SEQ
         INNER JOIN TBLOPENCOURSE OPENCOUR
                    on OPENSUB.OPEN_COURSE_SEQ = OPENCOUR.OPEN_COURSE_SEQ
         INNER JOIN TBLSTUDENT STU
                    on REG.STUDENT_SEQ = STU.STUDENT_SEQ
         INNER JOIN TBLCOURSE COUR
                    on OPENCOUR.COURSE_SEQ = COUR.COURSE_SEQ
         INNER JOIN TBLSUBJECT SUB
                    on OPENSUB.SUBJECT_SEQ = SUB.SUBJECT_SEQ
         INNER JOIN TBLCLASSROOM ROOM
                    on OPENCOUR.CLASSROOM_SEQ = ROOM.CLASSROOM_SEQ
         INNER JOIN TBLTEACHER TC
                    on OPENSUB.TEACHER_SEQ = TC.TEACHER_SEQ
         INNER JOIN TBLTEXTBOOK TXT
                    on OPENSUB.TEXTBOOK_SEQ = TXT.TEXTBOOK_SEQ
WHERE SC.STUDENT_SEQ = 'S0381';

--*************** 교육생 개인별 출력시 출력 정보 ***************--
SELECT * FROM VWOpenSubjectStudentScore_M;

DROP VIEW VWOpenSubjectScore_M;
DROP VIEW VWOpenSubjectStudentScore_M;