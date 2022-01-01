/* 교사_성적 입출력.sql */



/* 3. 성적 입출력 */
-- 3.1) 교사별 > 강의종료 과목 목록 출력
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
    os.score_check              as 성적등록여부
from tblopensubject os 
        inner join tblsubject sub on os.subject_seq = sub.subject_seq
        inner join tblopencourse ol on ol.open_course_seq = os.open_course_seq
        inner join tblcourse course on ol.course_seq = course.course_seq
        inner join tblclassroom room on ol.classroom_seq = room.classroom_seq
        inner join tbltextbook book on os.textbook_seq = book.textbook_seq
where os.teacher_seq = 'T001' 
        and os.subject_progress = '강의종료'
order by ol.course_start_date, os.subject_start_date;




-- 3.2) 특정 과목번호 선택 > 교육생 정보 및 성적 출력 (중도탈락생, 중도탈락 날짜 포함)
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
where os.open_subject_seq = 'OS001'
order by reg.student_seq;



-- Temp Query for checking the tblTestResult each test_seq and student.
select
    test.test_seq,
    test.test_date,
    test.open_subject_seq,
    result.student_seq,
    std.name,
    result.score,
    test.type
from tblTest test
        inner join tbltestresult result on test.test_seq = result.test_seq
        inner join tblstudent std on result.student_seq = std.student_seq
where test.open_subject_seq = 'OS001'
order by result.student_seq;




-- 3.3) 특정 교육생 선택 > 해당 교육생의 시험 점수 입력(출결, 필기, 실기 점수 구분 입력)

-- 수정.ver
-- 3.3.1) 출결점수 입력(수정)
update tblscoreinfo
set attendance_score = 15
where opensubject_seq = 'OS001' and student_seq = 'SOO4'; 


-- 3.3.2) 필기점수 입력(수정)
-- 3.3.2.1) 시험테이블 > 필기점수 입력
update tbltestresult
set score = 100
where test_seq = (select test_seq from tbltest where open_subject_seq = 'OS001' and type = '필기')
    and student_seq = 'S0004';

-- 3.3.2.2) 성적정보테이블 > 필기점수 환산 입력(수정)
update tblscoreinfo
set written_score =
    -- 점수 * 배점
    (select score from tbltestresult
        where test_seq = (select test_seq from tbltest where open_subject_seq = 'OS001' and type = '필기') and student_seq = 'S0004')
    * 
    (select written_distribution / 100 from tblopensubject 
        where open_subject_seq = 'OS001')

where opensubject_seq = 'OS001' and student_seq = 'S0004';



-- 3.3.3) 실기점수 입력(수정)
-- 3.3.3.1) 시험테이블 > 실기점수 입력
update tbltestresult
set score = 100
where test_seq = (select test_seq from tbltest where open_subject_seq = 'OS001' and type = '실기')
    and student_seq = 'S0004';
    
-- 3.3.3.2) 성적정보테이블 > 실기점수 환산 입력(수정)
update tblscoreinfo
set practical_score =
    -- 점수 * 배점
    (select score from tbltestresult
        where test_seq = (select test_seq from tbltest where open_subject_seq = 'OS001' and type = '실기') and student_seq = 'S0004')
    * 
    (select practical_distribution / 100 from tblopensubject 
        where open_subject_seq = 'OS001')

where opensubject_seq = 'OS001' and student_seq = 'S0004';


-- 3.3.4) 총점 재계산
update tblscoreinfo
set subject_score = attendance_score + written_score + practical_score
where opensubject_seq = 'OS001' and student_seq = 'S0004';

