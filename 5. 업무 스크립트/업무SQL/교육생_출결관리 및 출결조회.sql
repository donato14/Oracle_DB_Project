--교육생_출결관리 및 출결조회.sql
rollback;
/*

출결관리 및 출결 조회

*/

--[ 매일의 근태를(출근 1회, 퇴근1회)를 기록할 수 있다. ]

insert into tblDayAttendance (day_attendance_date, time, student_seq, open_course_seq, is_attendance) values (
    current_date,
    to_date('08:57:55', 'hh24:mi:ss'),
    'S0038', 
    'OL001',
    '출근'
);  
--현재 날짜를 자동입력 하고싶을 경우 current_date를 인서트한다.
--근태 시간은 교육생이 직접 입력할 수 있도록 한다.


insert into tblDayAttendance (day_attendance_date, time, student_seq, open_course_seq, is_attendance) values (
    current_date,
    to_date('18:03:33', 'hh24:mi:ss'),
    'S0038', 
    'OL001',
    '퇴근'
);  
--날짜를 지정하여 입력하고싶을 경우 : to_date('2021-12-02', 'YYYY-MM-DD')

select * from tbldayattendance where student_seq = 'S0038' order by day_attendance_date desc;     --잘 입력됐나 확인



-- + 관리자 요구사항에 추가해야할 필요 있어 보이는 것 : 근태 추가하기 => trigger 이용
-- 관리자 혹은 교육생이 근태를 추가 입력해야 함

select 
    r.open_course_seq
from tblregister r
    inner join tblstudent s
        on r.student_seq = s.student_seq
    inner join tblopencourse oc
        on r.open_course_seq = oc.open_course_seq
where r.student_seq = 'S0038'
    and sysdate between oc.course_start_date and oc.course_end_date;
--1) 교육생이 수강 중인 개설과정 번호


insert into tblattendance (attendance_date, student_seq, open_course_seq, attendance_type_seq) values (
    current_date,
    'S0038',
    (select r.open_course_seq 
        from tblregister r inner join tblstudent s on r.student_seq = s.student_seq
            inner join tblopencourse oc on r.open_course_seq = oc.open_course_seq
                where r.student_seq = 'S0038' 
                    and sysdate between oc.course_start_date and oc.course_end_date),
    'TA02'
);
--날짜를 지정하여 입력하고싶을 경우에는 to_date('2021-12-02', 'YYYY-MM-DD')

select * from tblattendance where student_seq = 'S0038' order by attendance_date desc;    --잘 입력됐나 확인




--[ 모든 출결 조회는 근태 상황을 구분할 수 있다.(정상, 지각, 조퇴, 외출, 병가, 기타) ]

--[ 다른 교육생의 현황은 조회할 수 없다. ]

--[ 본인의 출결 현황을 기간별(전체, 월, 일)로 조회할 수 있다. ]

select 
distinct 
    s.student_seq as "교육생 번호",
    s.name as "교육생 이름", 
    a.attendance_date as "날짜",
    att.attendance_type as "근태 상황", 
    to_char(da.time, 'hh24:mi:ss') as "시간", 
    da.is_attendance as "출/퇴근"
from tblattendance a
    inner join tblattendancetype att
        on a.attendance_type_seq = att.attendance_type_seq
    inner join tbldayattendance da 
        on a.student_seq = da.student_seq 
            and a.open_course_seq = da.open_course_seq 
            and a.attendance_date = da.day_attendance_date
    inner join tblstudent s 
        on s.student_seq = a.student_seq
where s.student_seq = 'S0038'
order by a.attendance_date desc;
--교육생 로그인 시 자동으로 where 조건에 학생 번호가 붙어 해당 교육생의 전체 출결이 조회된다.


select to_char(attendance_date, 'yyyy-mm-dd'), student_seq from tblattendance WHERE student_seq='S0038' order by attendance_date;


select 
distinct 
    s.student_seq as "교육생 번호",
    s.name as "교육생 이름", 
    a.attendance_date as "날짜",
    att.attendance_type as "근태 상황", 
    to_char(da.time, 'hh24:mi:ss') as "시간", 
    da.is_attendance as "출/퇴근"
from tblattendance a
    inner join tblattendancetype att
        on a.attendance_type_seq = att.attendance_type_seq
    inner join tbldayattendance da 
        on a.student_seq = da.student_seq 
            and a.open_course_seq = da.open_course_seq 
            and a.attendance_date = da.day_attendance_date
    inner join tblstudent s 
        on s.student_seq = a.student_seq
where s.student_seq = 'S0038'
    and a.attendance_date between to_date('2021-09-01', 'YYYY-MM-DD') and to_date('2021-09-30', 'YYYY-MM-DD')
order by a.attendance_date desc;
--원하는 기간별로 조회가 가능하다

    and to_char(a.attendance_date, 'mm') = '09'
--원하는 '월'의 출결 조회가 가능하다




select 
distinct 
    s.student_seq as "교육생 번호",
    s.name as "교육생 이름", 
    a.attendance_date as "날짜",
    att.attendance_type as "근태 상황", 
    to_char(da.time, 'hh24:mi:ss') as "시간", 
    da.is_attendance as "출/퇴근"
from tblattendance a
    inner join tblattendancetype att
        on a.attendance_type_seq = att.attendance_type_seq
    inner join tbldayattendance da 
        on a.student_seq = da.student_seq 
            and a.open_course_seq = da.open_course_seq 
            and a.attendance_date = da.day_attendance_date
    inner join tblstudent s 
        on s.student_seq = a.student_seq
where s.student_seq = 'S0038'
    and to_char(a.attendance_date, 'YYYY-MM-DD') = '2021-10-05'
--    and a.attendance_date = to_date('2021-10-05', 'YYYY-MM-DD')
order by a.attendance_date;
--원하는 날짜의 출퇴근 현황을 조회할 수 있다

    and to_char(day_attendance_date, 'YYYY-MM-DD') = to_char(current_date, 'YYYY-MM-DD')
--오늘자의 출퇴근 현황을 조회할 수 있다
        

