--요약───────────────────────────────────────────────────────────────────
--① <개설 과정 입력>
EXECUTE procNewCourseIst_M('자바 기술자 과정', '자바 전문가가 된다.', '자바 전문가가 되는 과정입니다.', '과정시작일', '과정종료일', '과목등록여부', '강의진행여부', '강의실Seq');
-- ex
EXECUTE procNewCourseIst_M('테스트 과정명', '테스트 과정 목표', '테스트 과정 설명', '2021-12-05', '2022-03-20', 'Y', '강의예정', 'R006');

--② 모든 개설 과정 정보 출력
select * from vwAllCourse;

--③ 특정 개설 과정 정보 출력
--4-1) 등록된 개설 과목 정보
SELECT b.name AS "과목명", a.subject_start_date AS "과목시작일", a.subject_end_date AS "과목종료일", d.name AS "교재명", c.name AS "교사명"
FROM tblOpenSubject a
INNER JOIN tblSubject b ON a.subject_seq=b.subject_seq
INNER JOIN tblTeacher c ON a.teacher_seq=c.teacher_seq
INNER JOIN tblTextbook d ON a.textbook_seq=d.textbook_seq
WHERE a.open_course_seq='OL007';--과정코드 입력

--4-2) 등록된 교육생 정보
SELECT b.name AS "교육생 이름", b.idcard_number AS "주민번호 뒷자리", b.tel AS "전화번호", b.registration_date AS "등록일", a.completion_status AS "수료여부", a.completion_date AS "수료날짜", a.dropout_date AS "중도탈락날짜"
FROM tblRegister a
INNER JOIN tblStudent b ON a.student_seq=b.student_seq
WHERE a.open_course_seq='OL007';--과정코드 입력

--───────────────────────────────────────────────────────────────────



/*
<개설 과정 입력>
- 과정 정보는 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실 정보를 입력한다.
- 강의실 정보는 기초 정보 강의실명에서 선택적으로 추가할 수 있어야 한다.
*/
--1. 기초 과정 정보 입력
INSERT INTO tblcourse (course_seq, name, goal, detail) VALUES ('L018', '과정명', '과정목표', '과정설명');
--2. 동적 과정 정보 입력
INSERT INTO tblOpenCourse (open_course_seq, course_start_date, course_end_date, reg_open_subject, course_progress, classroom_seq, course_seq)
    VALUES ('OL017', TO_DATE('2021-12-01', 'yyyy-mm-dd'), TO_DATE('2021-12-01', 'yyyy-mm-dd'), 'Y', '과정진행여부', '강의실코드', '과정코드');

-- 프로시저
CREATE OR REPLACE PROCEDURE procNewCourseIst_M(
    pName VARCHAR2,
    pGoal VARCHAR2,
    pDetail VARCHAR2,
    pCourse_start_date VARCHAR2,
    pCourse_end_date VARCHAR2,
    pReg_open_subject CHAR,
    pCourse_progress VARCHAR2,
    pClassroom_seq VARCHAR2
)
IS
    pCourse_seq VARCHAR(30);
    pOpen_course_seq VARCHAR(30);
BEGIN
    select concat('L', lpad(max(to_number(substr(course_seq, 2)))+1, 3, '0')) INTO pCourse_seq from tblCourse;
    select concat('OL', lpad(max(to_number(substr(open_course_seq, 3)))+1, 3, '0')) INTO pOpen_course_seq from tblOpenCourse;

    INSERT INTO tblcourse (course_seq, name, goal, detail)
    VALUES (pCourse_seq, pName, pGoal, pDetail);

    INSERT INTO tblOpenCourse (
        open_course_seq,
        course_start_date,
        course_end_date,
        reg_open_subject,
        course_progress,
        classroom_seq,
        course_seq)
    VALUES (
        pOpen_course_seq,
        TO_DATE(pCourse_start_date, 'yyyy-mm-dd'),
        TO_DATE(pCourse_end_date, 'yyyy-mm-dd'),
        pReg_open_subject,
        pCourse_progress,
        pClassroom_seq,
        pCourse_seq);
END procNewCourseIst_M;

-- 테스트
EXECUTE procNewCourseIst_M('테스트 과정명', '테스트 과정 목표', '테스트 과정 설명', '2021-12-05', '2022-03-20', 'Y', '강의예정', 'R006');
select * from tblopencourse;
select * from tblcourse;
rollback;


/*
<개설 과정 출력>
- 개설 과정 정보 출력시 개설 과정명, 개설 과정기간(시작 년월일, 끝 년월일), 강의 설명, 개설 과목 등록 여부, 교육생 등록 인원을 출력한다.
- 특정 개설 과정 선택시 개설 과정에 등록된 개설 과목 정보(과목명, 과목시간(시작 년월일, 끝 년월일), 교재명, 교사명) 및 등록된 교육생 정보(교육생 이름, 주민번호 뒷자리, 전화번호, 등록일, 수료 및 중도탈락)을 확인할 수 있어야 한다.
*/
--3. 모든 개설 과정 정보 출력
CREATE OR replace VIEW vwAllCourse
AS
SELECT b.name AS "개설 과정명", a.course_start_date AS "과정 시작일", a.course_end_date AS "과정 종료일", b.detail AS "강의설명", a.reg_open_subject AS "개설 과목 등록 여부",
    (SELECT COUNT(d.student_seq) FROM tblRegister d WHERE d.open_course_seq=a.open_course_seq) AS "교육생 등록 인원"
FROM tblOpenCourse a
INNER JOIN tblCourse b ON a.course_seq=b.course_seq
INNER JOIN tblClassroom c ON a.classroom_seq=c.classroom_seq;

-- 4. 특정 개설 과정 정보 출력
--4-1) 등록된 개설 과목 정보
SELECT b.name AS "과목명", a.subject_start_date AS "과목시작일", a.subject_end_date AS "과목종료일", d.name AS "교재명", c.name AS "교사명"
FROM tblOpenSubject a
INNER JOIN tblSubject b ON a.subject_seq=b.subject_seq
INNER JOIN tblTeacher c ON a.teacher_seq=c.teacher_seq
INNER JOIN tblTextbook d ON a.textbook_seq=d.textbook_seq
WHERE a.open_course_seq='OL007';--과정코드 입력

--4-2) 등록된 교육생 정보
SELECT b.name AS "교육생 이름", b.idcard_number AS "주민번호 뒷자리", b.tel AS "전화번호", b.registration_date AS "등록일", a.completion_status AS "수료여부", a.completion_date AS "수료날짜", a.dropout_date AS "중도탈락날짜"
FROM tblRegister a
INNER JOIN tblStudent b ON a.student_seq=b.student_seq
WHERE a.open_course_seq='OL007';--과정코드 입력











