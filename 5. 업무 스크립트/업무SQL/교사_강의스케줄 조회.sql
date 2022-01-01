/* 교사_강의스케줄 조회.sql */



/* 1. 강의 스케줄 조회 */
-- 교사는 자신의 강의 스케줄을 확인할 수 있어야 한다.
-- 강의 스케줄은 (강의예정, 강의중, 강의 종료)로 구분해서 확인할 수 있어야 한다.
-- 강의 진행 상태는 날짜를 기준으로 확인한다.
-- * 강의 스케줄 정보 출력 시        : (과목번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실명, 과목명, 과목 기간(시작 년월일, 끝 년월일), 교재명, 교육생 등록 인원) 확인할 수 있다.
-- * 특정 과목을 과목 번호로 선택 시 : 해당 과정에 등록된 교육생 정보(교육생 이름, 전화번호, 등록일, 수료 또는 중도탈락)을 확인할 수 있다.


-- 1.1) 교사별 > 강의스케줄 출력
select
    os.open_subject_seq         as 개설과목번호,
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



-- 1.2) 특정 과목번호 선택 > 해당 과정 교육생 정보 출력
select
    os.open_subject_seq         as 개설과목번호,
    student.name                as "교육생 이름",
    student.tel                 as 전화번호,
    student.registration_date   as 등록일,
    case
        when reg.completion_status = 'Y' then '수료'
        when reg.completion_status = 'N' then '중도탈락'
        else '과정진행중'
    end                         as 수료여부
from tblopensubject os
        inner join tblregister reg on os.open_course_seq = reg.open_course_seq
        inner join tblstudent student on reg.student_seq = student.student_seq
where os.open_subject_seq = 'OS001';





