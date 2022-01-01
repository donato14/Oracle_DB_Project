-- *****교사 계정 관리*****
SELECT * FROM tblteacher;
Select * from tblStudent;
-- 교사 로그인하기
SELECT COUNT(*) FROM tblTeacher WHERE name='이윤후' AND idcard_number='2482932';
-- 학생 로그인하기
SELECT COUNT(*) FROM tblstudent WHERE name='정하하' AND idcard_number='2654210';

-- 교사 정보 입력하기
INSERT INTO tblteacher (teacher_seq, name, idcard_number, tel) VALUES ('T011', '이름', '주민번호 뒷자리', '연락처');
-- 교사 정보 조회하기
SELECT teacher_seq as "강사코드", name as "이름", idcard_number as "주민번호 뒷자리", tel as "연락처" FROM tblTeacher;
-- 교사 정보 수정하기
UPDATE tblTeacher SET name='이름 수정' WHERE teacher_seq='강사코드';
UPDATE tblTeacher SET idcard_number='주민번호 뒷자리 수정' WHERE teacher_seq='강사코드';
UPDATE tblTeacher SET tel='연락처 수정' WHERE teacher_seq='강사코드';
-- 교사 정보 삭제하기
DELETE FROM tblTeacher WHERE teacher_seq='강사코드';
DELETE FROM tblTeacher WHERE name='이름';


-- 전체 교사 목록 출력하기
SELECT a.teacher_seq AS "강사코드", a.name AS "이름", a.idcard_number AS "주민번호 뒷자리", a.tel AS "연락처",
LISTAGG(c.name, ',') AS "강의 가능 과목"
FROM tblteacher a
    INNER JOIN tblteachersubject b
    ON b.teacher_seq = a.teacher_seq
    INNER JOIN tblSubject c
    ON b.subject_seq = c.subject_seq
        GROUP BY a.teacher_seq, a.name, a.idcard_number, a.tel;


-- 단일 교사 정보 출력하기
SELECT
    b.name AS "교사명",
    c.name AS "과목명",
    a.subject_start_date AS "과목시작날짜",
    a.subject_end_date AS "과목종료날짜",
    f.name AS "과정명",
    d.course_start_date AS "과정시작일",
    d.course_end_date AS "과정종료일",
    g.name AS "교재명", e.name AS "강의실",
    d.course_progress AS "강의진행여부"
FROM tblOpenSubject a
    INNER JOIN tblTeacher b ON a.teacher_seq=b.teacher_seq
    INNER JOIN tblSubject c ON a.subject_seq=c.subject_seq
    INNER JOIN tblOpenCourse d ON a.open_course_seq=d.open_course_seq
    INNER JOIN tblClassroom e ON d.classroom_seq=e.classroom_seq
    INNER JOIN tblcourse f ON d.course_seq=f.course_seq
    INNER JOIN tblTextbook g ON a.textbook_seq=g.textbook_seq
        WHERE b.teacher_seq='T001';--교사코드 입력































