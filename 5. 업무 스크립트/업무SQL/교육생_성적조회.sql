--1201

/*

성적 조회

*/

--[ 교육생이 로그인에 성공하면 ]

select * from tblstudent where student_seq = 'S0038';

select
    case
        when count(*) > 0 then '로그인 성공'
        else '로그인 실패'
    end as "교육생 로그인"
from tblstudent where student_seq = 'S0038' and idcard_number = '1770114';
--S0038번 교육생으로 로그인한다.


--[ 교육생 개인의 정보와 교육생이 수강한 과정명, 과정기간(시작 년월일, 끝 년월일), 강의실이 타이틀로 출력된다. ]

--[ 교육생은 한개의 과정만을 등록해서 수강한다. ]
select 
    st.student_seq as "교육생 번호",
    st.name as "교육생 이름",
    st.tel as "전화번호",
    st.registration_date as "등록일자",
    c.name as "수강한 과정 이름",
    oc.course_start_date as "과정 시작일",
    oc.course_end_date as "과정 종료일",
    cr.name as "강의실 이름"
from tblregister r
    inner join tblstudent st
        on r.student_seq = st.student_seq
    inner join tblopencourse oc
        on r.open_course_seq = oc.open_course_seq
    inner join tblclassroom cr
        on oc.classroom_seq = cr.classroom_seq
    inner join tblcourse c
        on oc.course_seq = c.course_seq
where st.student_seq = 'S0038';
--로그인할 경우 자동으로 로그인한 교육생의 '교육생번호'를 통해 해당하는 정보들을 보여준다.
--교육생은 '겹치지 않는' 한 개의 과정만을 등록해서 수강한다.



select 
s.student_seq,
count(*)
from tblstudent s
    inner join tblregister r
        on s.student_seq = r.student_seq
    inner join tblopencourse oc
        on oc.open_course_seq = r.open_course_seq
group by s.student_seq
order by s.student_seq;
--교육생은 수료 후에도 다른 과정을 수강할 수 있다. (교육생 별 수강 횟수 출력)
       
        
        
--[ 과목번호, 과목명, 과목기간(시작 년월일, 끝 년월일), 교재명, 교사명, 과목별 배점정보 (출결, 필기, 실기 배점), 
    --과목별 성적 정보( 출결, 필기, 실기 점수), 과목별 시험날짜가 목록형태로 출력된다. ]

--[ 성적이 등록되지 않은 과목이 있는 경우 과목 정보는 출력되고 점수는 null값으로 출력되도록 한다. ]
select
    st.name as "교육생 이름",
    os.open_subject_seq as "개설과목번호",
    os.subject_seq as "과목번호",
    s.name as "과목명",
    os.subject_start_date as "과목 시작일",
    os.subject_end_date as "과목 종료일",
    tb.name as "교재명",
    t.name as "교사명",
    os.attendance_distribution as "출결 배점",
    os.written_distribution as "필기 배점",
    os.practical_distribution as "실기 배점",
    sc.attendance_score as "출결 점수",
    round(sc.written_score, 1) as "필기 점수",
    round(sc.practical_score, 1) as "실기 점수",
    ts.test_date as "시험 날짜"
from tblopensubject os
    inner join tblteacher t
        on os.teacher_seq = t.teacher_seq
    inner join tbltextbook tb
        on os.textbook_seq = tb.textbook_seq
    inner join tblsubject s
        on os.subject_seq = s.subject_seq
    inner join tbltest ts
        on os.open_subject_seq = ts.open_subject_seq
    inner join tblscoreinfo sc
        on os.open_subject_seq = sc.opensubject_seq
    inner join tblregister r
        on r.student_seq = sc.student_seq and r.open_course_seq = sc.open_course_seq
    inner join tblstudent st
        on st.student_seq = r.student_seq
where st.student_seq = 'S0038';
--로그인할 경우 자동으로 로그인한 교육생의 '교육생번호'를 통해 해당하는 정보들을 보여준다.



--[ 한 개의 과정 내에는 여러 개의 과목을 수강한다 ]
select
    os.open_course_seq as "개설과정 번호",
    c.name as "개설과정 이름",
    os.open_subject_seq as "개설과목 번호",
    s.name as "개설과목 이름"
from tblopensubject os
    inner join tblsubject s
        on s.subject_seq = os.subject_seq
    inner join tblopencourse oc
        on os.open_course_seq = oc.open_course_seq
    inner join tblcourse c
        on oc.course_seq = c.course_seq;




--[ 과정기간이 끝나지 않은 교육생 또는 중도 탈락 처리된 교육생인 경우 일부 과목만 수강한다. ]

select * from tblregister
where completion_status = 'N' or dropout_date is not null;
--1) 과정 기간이 끝나지 않은 (수료하지 않은) 또는 중도 탈락 처리된 교육생의 목록 확인

select 
    student_seq
from tblregister
where (completion_status = 'N' 
    or dropout_date is not null) 
    and open_course_seq = 'OL001';  
--2) 그 교육생들 중 현재 강의 중인 과정번호가 OL001인 개설과정의 학생 한명 (의 학생번호) : S0106


select 
    st.student_seq as "학생 번호",
    st.name as "학생 이름",
    r.completion_status as "수료여부",
    r.completion_date as "수료날짜",
    r.dropout_date as "중도탈락날짜",
    s.name as "과목 이름",
    os.subject_start_date as "과목 시작일",
    os.subject_end_date as "과목 종료일",
    a.attendance_date as "출결 날짜",
    at.attendance_type as "근태 유형",
    oc.open_course_seq as "개설과정 번호",
    c.name as "과정 이름"
from tblregister r
    inner join tblattendance a
        on r.student_seq = a.student_seq and r.open_course_seq = a.open_course_seq
    inner join tblattendancetype at
        on a.attendance_type_seq = at.attendance_type_seq
    inner join tblstudent st
        on st.student_seq = r.student_seq
    inner join tblopencourse oc
        on oc.open_course_seq = r.open_course_seq
    inner join tblcourse c
        on oc.course_seq = c.course_seq
    inner join tblopensubject os
        on oc.open_course_seq = os.open_course_seq
    inner join tblsubject s
        on os.subject_seq = s.subject_seq
where (r.completion_status = 'N' or r.dropout_date is not null)
    and r.student_seq = (select student_seq from tblregister
                            where (completion_status = 'N' or dropout_date is not null) and open_course_seq = 'OL001')
    and r.dropout_date between os.subject_start_date and os.subject_end_date
order by os.subject_start_date, a.attendance_date;
--3) 결과셋 : 과정 기간이 끝나지 않은 (수료하지 않은) 또는 중도 탈락 처리된 교육생들 중 개설과정번호가 OL001인 과정을 들은 학생의
--          중도탈락 이전 날짜별 근태상황과 해당 과정의 일부 개설과목의 과목 시작일, 종료일을 보여준다


