/* 교사_배점 입출력.sql */



/* 2. 배점 입출력 */
-- 교사가 강의를 마친 과목에 대한 성적 처리를 위해서 배점 '입출력'을 할 수 있어야 한다.
-- 교사는 자신이 강의를 마친 과목의 목록 중에서 특정 과목을 선택하고 해당 과목의 배점 정보를 출결, 필기, 실기로 구분해서 등록할 수 있어야 한다. 
-- 출결, 필기, 실기의 배점 비중은 담당 교사가 과목별로 결정한다. (단, 출결은 최소 20점 이상이어야 하고, 출결, 필기, 실기의 합은 100점이 되도록 한다.)
-- * 과목 목록 출력시                :(과목번호, 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 출결, 필기, 실기 배점 등)
-- * 특정 과목을 과목 번호로 선택 시 : (출결 배점, 필기 배점, 실기 배점, 시험 날짜, 시험 문제) 를 입력할 수 있는 화면으로 연결된다.
-- * 배점 등록이 안된 과목인 경우    : 과목 정보 출력될 때 배점 부분은 null값으로 출력
-- 시험 날짜, 시험 문제를 추가할 수 있어야 한다.


-- 2.1 ) 교사별 > '강의종료' 과목 출력
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
where os.teacher_seq = 'T001' 
        and os.subject_progress = '강의종료'
order by ol.course_start_date, os.subject_start_date;



-- 2.2) 특정 과목번호 선택 > 배점 및 시험날짜/문제 입력 화면
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
        inner join tblTest test on os.open_subject_seq = test.open_subject_seq
where os.open_subject_seq = 'OS001';



-- 2.3) 배점 입력 / 시험날짜 / 시험문제 입력
-- 2.3.1) 출결배점 수정(입력)
update tblopensubject 
set attendance_distribution = 30
where open_subject_seq = 'OS001';


-- 2.3.2) 필기배점 수정(입력)
update tblopensubject 
set written_distribution = 30
where open_subject_seq = 'OS001';


-- 2.3.3) 실기배점 수정(입력)
update tblopensubject 
set practical_distribution = 40
where open_subject_seq = 'OS001';


-- 2.3.4.1) 시험 등록 (기존에 시험 등록을 안한 경우)
insert into tbltest values ('TEST151', current_date, '필기', 'OS001');


-- 2.3.4.2) '시험문제파일등록여부' 컬럼 변경 (해당 과목의 시험이 필기/실기 둘 다 등록 됐을 경우) 
update tblopensubject
set testfile_check = 'Y'
where open_subject_seq = 'OS001' 
    and (select count(*) from tblTest where open_subject_seq = 'OS001') >= 2;


-- 2.3.5) 시험날짜 수정(입력)
update tbltest
set test_date = current_date
where open_subject_seq = 'OS001' and type = '필기';



