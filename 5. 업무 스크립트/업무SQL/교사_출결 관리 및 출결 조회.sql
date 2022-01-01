/* 교사_출결 관리 및 출결 조회.sql */



/* 4. 출결 관리 및 출결 조회 */
-- 교사가 강의한 과정에 한해 선택하는 경우 모든 교육생의 출결을 조회할 수 있어야 한다.
-- 출결 현황을 기간별(년, 월, 일) 조회할 수 있어야 한다.
-- 특정(특정 과정, 특정 인원) 출결 현황을 조회할 수 있어야 한다.
-- 모든 출결 조회는 근태 상황을 구분할 수 있어야 한다.(정상, 지각, 조퇴, 외출, 병가, 기타)


-- 4.1) 교사별 > 강의 과목 목록 출력(강의 스케줄)
select
    os.open_subject_seq         as 개설과목번호,
    sub.subject_seq             as 과목번호,
    course.name                 as 과정명,
    ol.course_start_date        as 과정시작일,
    ol.course_end_date          as 과정종료일,
    room.name                   as 강의실명,
    sub.name                    as 과목명,
    os.subject_start_date       as 과목시작일,
    os.subject_end_date         as 과목종료일,
    os.subject_progress         as 과목강의상태,
    book.name                   as 교재명,
    (select count(*) from tblregister where open_course_seq = os.open_course_seq and dropout_date is null) || '명' as "교육생 등록 인원"
from tblopensubject os 
        inner join tblsubject sub on os.subject_seq = sub.subject_seq
        inner join tblopencourse ol on ol.open_course_seq = os.open_course_seq
        inner join tblcourse course on ol.course_seq = course.course_seq
        inner join tblclassroom room on ol.classroom_seq = room.classroom_seq
        inner join tbltextbook book on os.textbook_seq = book.textbook_seq
where os.teacher_seq = 'T001'
order by ol.course_start_date, os.subject_start_date;




-- 4.2.1) 특정 과목번호 선택 > 교육생 출결 출력(과목별)
select 
    at.attendance_date          as 날짜,
    reg.open_course_seq         as 과정번호,
    os.open_subject_seq         as 과목번호,
    std.name                    as 학생이름,
    attype.attendance_type      as 근태
    
from tblopensubject os
        inner join tblopencourse ol on os.open_course_seq = ol.open_course_seq
        inner join tblregister reg on ol.open_course_seq = reg.open_course_seq
        inner join tblattendance at on reg.student_seq = at.student_seq and reg.open_course_seq = at.open_course_seq
        inner join tblattendancetype attype on at.attendance_type_seq = attype.attendance_type_seq
        inner join tblstudent std on reg.student_seq = std.student_seq
where 
    os.open_subject_seq = 'OS001'
    and at.attendance_date >= (select subject_start_date from tblopensubject where open_subject_seq = 'OS001')
    and at.attendance_date <= (select subject_end_date from tblopensubject where open_subject_seq = 'OS001')
    
order by at.attendance_date, at.student_seq;    





-- 4.2.2) 교육생 출결 출력(연도별)
select 
    at.attendance_date          as 날짜,
    reg.open_course_seq         as 과정번호,
    os.open_subject_seq         as 과목번호,
    std.name                    as 학생이름,
    attype.attendance_type      as 근태
    
from tblopensubject os
        inner join tblopencourse ol on os.open_course_seq = ol.open_course_seq
        inner join tblregister reg on ol.open_course_seq = reg.open_course_seq
        inner join tblattendance at on reg.student_seq = at.student_seq and reg.open_course_seq = at.open_course_seq
        inner join tblattendancetype attype on at.attendance_type_seq = attype.attendance_type_seq
        inner join tblstudent std on reg.student_seq = std.student_seq
where 
    os.open_subject_seq = 'OS001'
    and at.attendance_date >= (select subject_start_date from tblopensubject where open_subject_seq = 'OS001')
    and at.attendance_date <= (select subject_end_date from tblopensubject where open_subject_seq = 'OS001')
    and to_char(at.attendance_date,'YYYY') like '2021'
    
order by at.attendance_date, at.student_seq;




-- 4.2.3) 교육생 출결 출력(월별)
select 
    at.attendance_date          as 날짜,
    reg.open_course_seq         as 과정번호,
    os.open_subject_seq         as 과목번호,
    std.name                    as 학생이름,
    attype.attendance_type      as 근태
    
from tblopensubject os
        inner join tblopencourse ol on os.open_course_seq = ol.open_course_seq
        inner join tblregister reg on ol.open_course_seq = reg.open_course_seq
        inner join tblattendance at on reg.student_seq = at.student_seq and reg.open_course_seq = at.open_course_seq
        inner join tblattendancetype attype on at.attendance_type_seq = attype.attendance_type_seq
        inner join tblstudent std on reg.student_seq = std.student_seq
where 
    os.open_subject_seq = 'OS003'
    and at.attendance_date >= (select subject_start_date from tblopensubject where open_subject_seq = 'OS003')
    and at.attendance_date <= (select subject_end_date from tblopensubject where open_subject_seq = 'OS003')
    and to_char(at.attendance_date,'YYYY-MM') like '2021-11'    
    
order by at.attendance_date, at.student_seq;





-- 4.2.4) 교육생 출결 출력(일별)
select 
    at.attendance_date          as 날짜,
    reg.open_course_seq         as 과정번호,
    os.open_subject_seq         as 과목번호,
    std.name                    as 학생이름,
    attype.attendance_type      as 근태
    
from tblopensubject os
        inner join tblopencourse ol on os.open_course_seq = ol.open_course_seq
        inner join tblregister reg on ol.open_course_seq = reg.open_course_seq
        inner join tblattendance at on reg.student_seq = at.student_seq and reg.open_course_seq = at.open_course_seq
        inner join tblattendancetype attype on at.attendance_type_seq = attype.attendance_type_seq
        inner join tblstudent std on reg.student_seq = std.student_seq
where 
    os.open_subject_seq = 'OS001'
    and at.attendance_date >= (select subject_start_date from tblopensubject where open_subject_seq = 'OS001')
    and at.attendance_date <= (select subject_end_date from tblopensubject where open_subject_seq = 'OS001')
    and at.attendance_date = '2021-10-01'    
    
order by at.attendance_date, at.student_seq;

