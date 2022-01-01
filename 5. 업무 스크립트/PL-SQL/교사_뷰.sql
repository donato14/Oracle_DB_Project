/*
-- 1. 강의 스케줄 조회
1.1) 교사별 > 강의스케줄 출력
    - vwTeacherSchedul_T
    
1.2) 특정 과목번호 선택 > 해당 과정 교육생 정보 출력
    - vwOpenSubjectStudent_T



-- 2. 배점 입출력
2.1 ) 교사별 > '강의종료' 과목 출력
    - vwOpenSubjectPoint_T

2.2) 특정 과목번호 선택 > 배점 및 시험날짜/문제 입력 화면
    - vwOpenSubjectPoint_T



-- 3. 성적 입출력
3.1) 교사별 > 강의종료 과목 목록 출력
    - vwOpenSubjectScore_t

3.2) 특정 과목번호 선택 > 교육생 정보 및 성적 출력 (중도탈락생, 중도탈락 날짜 포함)
    - vwOpenSubjectStudentScore_T

*/



----------- 1.1) 교사별 > 강의스케줄 출력__뷰
create or replace view vwTeacherSchedul_T
as
select
    os.open_subject_seq         as 개설과목번호,
    os.teacher_seq              as 교사번호,        -- *추가 컬럼
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
order by ol.course_start_date, os.subject_start_date;


-- 뷰 실행
-- 단점, 테이블 목록에 교사번호 추가해서 필터링
select * 
from vwteacherschedul_t 
where 교사번호 = 'T001';






----------- 1.2) 특정 과목번호 선택 > 해당 과정 교육생 정보 출력_뷰
create or replace view vwOpenSubjectStudent_T
as
select
    os.open_subject_seq         as 개설과목번호,
    student.name                as "교육생 이름",
    student.tel                 as 전화번호,
    student.registration_date   as 등록일,
    case
        when reg.completion_status = 'Y' then '수료'
        when reg.completion_status = 'N' then '중도탈락'
        when current_date < ol.course_start_date then '과정미시작'
        else '과정진행중'
    end                         as 수료여부
from tblopensubject os
        inner join tblregister reg on os.open_course_seq = reg.open_course_seq
        inner join tblopencourse ol on reg.open_course_seq = ol.open_course_seq
        inner join tblstudent student on reg.student_seq = student.student_seq
--where os.open_subject_seq = 'OS032'
order by student.student_seq;


-- 뷰 실행
select * 
from vwopensubjectstudent_t
where 개설과목번호 = 'OS007';






----------- 2.1 ) 교사별 > '강의종료' 과목 출력_뷰
create or replace view vwOpenSubjectPointList_T
as
select
    os.open_subject_seq         as 개설과목번호,
    os.teacher_seq              as 교사번호,        -- *추가 컬럼
    course.name                 as 과정명,
    ol.course_start_date        as 과정시작일,
    ol.course_end_date          as 과정종료일,
    room.name                   as 강의실명,
    sub.name                    as 과목명,
    os.subject_start_date       as 과목시작일,
    os.subject_end_date         as 과목종료일,
    os.subject_progress         as 과목강의상태,
    book.name                   as 교재명,
    os.attendance_distribution  as 출결배점,
    os.written_distribution     as 필기배점,
    os.practical_distribution   as 실기배점,
    os.testfile_check           as 시험문제등록여부
from tblopensubject os 
        inner join tblsubject sub on os.subject_seq = sub.subject_seq
        inner join tblopencourse ol on ol.open_course_seq = os.open_course_seq
        inner join tblcourse course on ol.course_seq = course.course_seq
        inner join tblclassroom room on ol.classroom_seq = room.classroom_seq
        inner join tbltextbook book on os.textbook_seq = book.textbook_seq
--where os.teacher_seq = 'T001' 
--        and os.subject_progress = '강의종료'
where os.subject_progress = '강의종료'
order by ol.course_start_date, os.subject_start_date;


-- 뷰 실행 
select * 
from vwopensubjectpointlist_t
where "교사번호" = 'T001';



----------- 2.2) 특정 과목번호 선택 > 배점 및 시험날짜/문제 입력 화면
create or replace view vwOpenSubjectPoint_T
as
select
    os.open_subject_seq             as 개설과목번호,
    os.attendance_distribution      as 출결배점,
    os.written_distribution         as 필기배점,
    os.practical_distribution       as 실기배점,
    os.testfile_check               as 시험문제등록여부,
    test.test_seq                   as 시험번호,
    test.test_date                  as 시험날짜,
    test.type                       as 시험유형
from tblopensubject os
        inner join tblTest test on os.open_subject_seq = test.open_subject_seq;
--where os.open_subject_seq = 'OS001';


-- 뷰 실행
select *
from vwopensubjectpoint_t
where "개설과목번호" = 'OS001';







----------- 3.1) 교사별 > 강의종료 과목 목록 출력
create or replace view vwOpenSubjectScore_t
as
select
    os.open_subject_seq         as 개설과목번호,
    os.teacher_seq              as 교사번호,        -- *추가 컬럼
    course.name                 as 과정명,
    ol.course_start_date        as 과정시작일,
    ol.course_end_date          as 과정종료일,
    room.name                   as 강의실명,
    sub.name                    as 과목명,
    os.subject_start_date       as 과목시작일,
    os.subject_end_date         as 과목종료일,
    os.subject_progress         as 과목강의상태,
    book.name                   as 교재명,
    os.attendance_distribution  as 출결배점,
    os.written_distribution     as 필기배점,
    os.practical_distribution   as 실기배점,
    os.score_check              as 성적등록여부
from tblopensubject os 
        inner join tblsubject sub on os.subject_seq = sub.subject_seq
        inner join tblopencourse ol on ol.open_course_seq = os.open_course_seq
        inner join tblcourse course on ol.course_seq = course.course_seq
        inner join tblclassroom room on ol.classroom_seq = room.classroom_seq
        inner join tbltextbook book on os.textbook_seq = book.textbook_seq
--where os.teacher_seq = 'T001' 
--        and os.subject_progress = '강의종료'
where os.subject_progress = '강의종료'        
order by ol.course_start_date, os.subject_start_date;



-- 뷰 실행
select *
from vwopensubjectscore_t
where "교사번호" = 'T001';



----------- 3.2) 특정 과목번호 선택 > 교육생 정보 및 성적 출력 (중도탈락생, 중도탈락 날짜 포함)
create or replace view vwOpenSubjectStudentScore_T
as
select
    os.open_subject_seq             as 수강과목번호,
    std.student_seq                 as 학생번호,
    std.name                        as 이름,
    std.tel                         as 전화번호,
    case
        when reg.completion_status = 'Y'
            or (reg.completion_status is null and reg.dropout_date is null) then '수료'
        when reg.completion_status = 'N' then '중도탈락'
    end                             as 수료여부,
    score.attendance_score          as 출결점수,
    round(score.written_score, 1)   as 필기점수,
    round(score.practical_score, 1) as 실기점수,
    round(score.subject_score, 1)   as 총점,
    reg.dropout_date                as 중도탈락날짜
from tblregister reg 
        inner join tblopencourse course on reg.open_course_seq = course.open_course_seq
        inner join tblopensubject os on course.open_course_seq = os.open_course_seq
        left outer join tblscoreinfo score on os.open_subject_seq = score.opensubject_seq 
                                        and reg.student_seq = score.student_seq 
                                        and reg.open_course_seq = score.open_course_seq
        inner join tblstudent std on reg.student_seq = std.student_seq
--where os.open_subject_seq = 'OS001'
order by reg.student_seq;


-- 뷰 실행
select *
from vwopensubjectstudentscore_t
where "수강과목번호" = 'OS001';
