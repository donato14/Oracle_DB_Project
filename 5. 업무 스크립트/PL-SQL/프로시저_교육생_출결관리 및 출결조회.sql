--프로시저_교육생_출결관리 및 출결조회.sql
commit;
rollback;
set serveroutput on;


select * from tblstudent where student_seq = fnlogin_st('김조하', '1770114');  --학생번호 'S0038'의 학생 정보

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
--현재 날짜로 자동입력한다.
--근태 시간은 교육생이 직접 입력할 수 있도록 한다.


-- *** 학생번호를 넣으면 현재 이 학생이 듣고 있는 과정번호를 반환해주는 함수 ***
create or replace function fnGetcourseSeq_ST(
    pseq varchar2
) return varchar2
is 
    vseq tblregister.open_course_seq%type;
begin
  
    select r.open_course_seq into vseq
        from tblregister r inner join tblstudent s on r.student_seq = s.student_seq
            inner join tblopencourse oc on r.open_course_seq = oc.open_course_seq
                where r.student_seq = pseq
                    and sysdate between oc.course_start_date and oc.course_end_date;
    
    return vseq;

end fnGetcourseSeq_ST;


select fnGetcourseSeq_ST('S0038') from dual;    --과정번호 함수 실행 확인용
select fnGetcourseSeq_ST(fnlogin_st('김조하', '1770114')) from dual;    --과정번호 함수 실행 확인용





-- *** 오늘자 출근 시간 입력 + 지각 근태유형 입력 저장 프로시저 ***
create or replace procedure procAddDayAttendanceStart_ST(
    ptime varchar2,
    pstudent_seq varchar2,
    presult out number  --성공(1) or 실패(0)
)
is 
    vcntda number;
begin
            
    select count(*) into vcntda from tblDayAttendance     --일일출결 테이블
        where to_char(day_attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd')
            and student_seq = pstudent_seq 
            and open_course_seq = fnGetcourseSeq_ST(pstudent_seq)
            and is_attendance = '출근';       --오늘자 출결 '출근' 행이 있는지 확인하기 위함 (중복 레코드 방지)
    
    if vcntda = 0 and to_date(ptime, 'hh24:mi:ss') < to_date('09:05:01', 'hh24:mi:ss') then
        insert into tblDayAttendance (day_attendance_date, time, student_seq, open_course_seq, is_attendance) values (
            current_date,
            to_date(ptime, 'hh24:mi:ss'),
            pstudent_seq, 
            fnGetcourseSeq_ST(pstudent_seq),   
            '출근'
        );    
    
    presult := 1;
    
    elsif vcntda = 0 and to_date(ptime, 'hh24:mi:ss') between to_date('09:05:01', 'hh24:mi:ss') and to_date('12:50:59', 'hh24:mi:ss') then   --점심시간 전까지 오면 지각 처리
 
         insert into tblDayAttendance (day_attendance_date, time, student_seq, open_course_seq, is_attendance) values (
            current_date,
            to_date(ptime, 'hh24:mi:ss'),
            pstudent_seq, 
            fnGetcourseSeq_ST(pstudent_seq),   
            '출근'
        );    
    
        insert into tblattendance (attendance_date, student_seq, open_course_seq, attendance_type_seq) values (
            current_date,
            pstudent_seq,
            fnGetcourseSeq_ST(pstudent_seq),   
            'TA02'  --지각
        );
    
    presult := 2;

    end if;
    
exception
    when others then
        presult := 0;

end procAddDayAttendanceStart_ST;



-- ***** (출근 시간, 학생번호) -> 오늘자 출근 시간 입력 실행 익명 프로시저 *****
declare
    vresult number;
begin
    procAddDayAttendanceStart_ST('09:00:55','S0038', vresult);
        
    if vresult = 1 then
        dbms_output.put_line('출근시간 입력 완료');
    elsif vresult = 2 then
        dbms_output.put_line('출근시간 입력 완료. 근태유형 지각 처리 되었습니다.');
    else
        dbms_output.put_line('이미 출근시간을 입력하셨습니다.');    --중복레코드 / 입력값 오류..?
    end if;
end;



-- *** 지각 트리거 만들 수 있나 ...? 실패 ***
create or replace trigger trgAddLate_ST
    after
    insert on tblDayAttendance
    for each row
declare
    vcntda number;
begin
    select count(*) into vcntda from tblDayAttendance     --일일출결 테이블
        where to_char(day_attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd')
            and student_seq = pstudent_seq 
            and open_course_seq = fnGetcourseSeq_ST(pstudent_seq)
            and is_attendance = '출근';       --오늘자 출결 '출근' 행이 있는지 확인하기 위함 (중복 레코드 방지)
end;





insert into tblDayAttendance (day_attendance_date, time, student_seq, open_course_seq, is_attendance) values (
    current_date,
    to_date('18:03:33', 'hh24:mi:ss'),
    'S0038', 
    'OL001',
    '퇴근'
);  
--날짜를 지정하여 입력하고싶을 경우 : to_date('2021-12-02', 'YYYY-MM-DD')




-- *** 오늘자 퇴근 시간 입력 + 정상 근태유형 입력 저장 프로시저 ***
create or replace procedure procAddDayAttendanceEnd_ST(
    ptime varchar2,
    pstudent_seq varchar2,
    presult out number  --성공(1) or 실패(0)
)
is 
    vcntda number;
    vcnta number;
    
begin

    select count(*) into vcntda from tblDayAttendance   --일일출결 테이블
        where to_char(day_attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd')
            and student_seq = pstudent_seq 
            and open_course_seq = fnGetcourseSeq_ST(pstudent_seq)
            and is_attendance = '퇴근';       --오늘자 출결 '퇴근'행이 있는지 확인하기 위함 (중복 레코드 방지)
            
    select count(*) into vcnta from tblattendance       --근태 테이블
        where to_char(attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd')
            and student_seq = pstudent_seq 
            and open_course_seq = fnGetcourseSeq_ST(pstudent_seq);  --근태 유형이 지각(TA02)으로 찍힌 행이 있는지 확인하기 위함 (1인 2레코드 방지)
    
    if vcntda = 0 and vcnta <> 0 and to_date(ptime, 'hh24:mi:ss') > to_date('09:50:59', 'hh24:mi:ss') then  --1교시 끝나고부터 외출/조퇴/병가 퇴근 가능
    
        insert into tblDayAttendance (day_attendance_date, time, student_seq, open_course_seq, is_attendance) values (
            current_date,
            to_date(ptime, 'hh24:mi:ss'),
            pstudent_seq, 
            fnGetcourseSeq_ST(pstudent_seq),
            '퇴근'
        );    
        
        presult := 1;
    
    elsif vcntda = 0 and vcnta = 0 and to_date(ptime, 'hh24:mi:ss') > to_date('17:45:00', 'hh24:mi:ss') then    --수업 끝나기 5분 전부터 정상 처리 허용
    
        insert into tblDayAttendance (day_attendance_date, time, student_seq, open_course_seq, is_attendance) values (
            current_date,
            to_date(ptime, 'hh24:mi:ss'),
            pstudent_seq, 
            fnGetcourseSeq_ST(pstudent_seq),
            '퇴근'
        );   
    
        insert into tblattendance (attendance_date, student_seq, open_course_seq, attendance_type_seq) values (
            current_date,
            pstudent_seq,
            fnGetcourseSeq_ST(pstudent_seq),
            'TA01'  --정상
        );
    
        presult := 2;
        
    end if;    

exception
    when others then
        presult := 0;

end procAddDayAttendanceEnd_ST;




-- ***** (퇴근 시간, 학생번호) -> 오늘자 퇴근 시간 입력 실행 익명 프로시저 *****
declare
    vresult number;
begin
    procAddDayAttendanceEnd_ST('18:03:33','S0038', vresult);
        
    if vresult = 1 then
        dbms_output.put_line('퇴근시간 입력 완료.');
    elsif vresult = 2 then
        dbms_output.put_line('퇴근시간 입력 완료. 근태유형 정상 처리 되었습니다.');
    else
        dbms_output.put_line('이미 퇴근시간을 입력하셨습니다.');    --중복레코드 / 입력값 오류..?
    end if;
end;




select * from tbldayattendance where student_seq = 'S0038' order by day_attendance_date desc;     --출퇴근 잘 입력됐나 간단 확인

delete from tbldayattendance where student_seq = 'S0038' and to_char(day_attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd') and is_attendance = '출근';    --방금 입력한 오늘자 출근 레코드 삭제 

delete from tbldayattendance where student_seq = 'S0038' and to_char(day_attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd') and is_attendance = '퇴근';    --방금 입력한 오늘자 퇴근 레코드 삭제


select * from tblattendance where student_seq = 'S0038' order by attendance_date desc;    --근태유형 잘 입력됐나 간단 확인

delete from tblattendance where student_seq = 'S0038' and to_char(attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd');    --방금 입력한 오늘자 근태 레코드 삭제




-- + 관리자 요구사항에 추가해야할 필요 있어 보이는 것 : 근태 추가/수정하기 
-- 관리자 혹은 교육생이 근태를 추가 입력해야 함

--TA03	조퇴
--TA04	외출
--TA05	병가
--TA06	기타
 

-- *** 오늘자 나머지 근태유형(조퇴, 외출, 병가, 기타) 입력/수정 저장 프로시저 ***
create or replace procedure procAddAttendance_ST (
    pstudent_seq varchar2,
    ptype varchar2,
    presult out number  --성공(1) or 실패(0)
)
is 
    vcnta number;   
begin

    select count(*) into vcnta from tblattendance       --근태 테이블
        where to_char(attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd')
            and student_seq = pstudent_seq 
            and open_course_seq = fnGetcourseSeq_ST(pstudent_seq);  --근태 유형 행이 있는지 확인하기 위함 (중복 레코드 방지)
    
    if vcnta = 0 then    
        insert into tblattendance (attendance_date, student_seq, open_course_seq, attendance_type_seq) values (
            current_date,
            pstudent_seq, 
            fnGetcourseSeq_ST(pstudent_seq),
            ptype
        );
    
        presult := 1;
        
    else
        update tblattendance set 
            attendance_type_seq = ptype
        where student_seq = pstudent_seq
            and open_course_seq = fnGetcourseSeq_ST(pstudent_seq)
            and to_char(attendance_date, 'yyyy-mm-dd') = to_char(current_date, 'yyyy-mm-dd');
    
        presult := 2;
        
    end if;
    

exception
    when others then
        presult := 0;

end procAddAttendance_ST;



-- ***** (학생번호, 근태유형번호) -> 오늘자 근태유형 입력/수정 실행 익명 프로시저 *****
declare
    vresult number;
begin
    procAddAttendance_ST('S0038', 'TA03', vresult);
        
    if vresult = 1 then
        dbms_output.put_line('근태유형 입력 완료.');
    elsif vresult = 2 then
        dbms_output.put_line('근태유형 수정 완료.');
    else
        dbms_output.put_line('근태유형 입력/수정에 실패했습니다.');    --입력값 오류,..? 될 일이 없나
    end if;
end;





-- *** 원하는날짜 나머지 근태유형(조퇴, 외출, 병가, 기타) 수정 저장 프로시저 ***
create or replace procedure procWantUpdateAttendance_ST (
    pdate varchar2,
    pstudent_seq varchar2,
    ptype varchar2,
    presult out number  --성공(1) or 실패(0)
)
is 
    vcnta number;   
begin

    select count(*) into vcnta from tblattendance 
        where to_char(attendance_date, 'yyyy-mm-dd') = to_date(pdate, 'yyyy-mm-dd')
            and student_seq = pstudent_seq 
            and open_course_seq = fnGetcourseSeq_ST(pstudent_seq);  --바꾸고 싶은 날짜의 근태 행이 존재하는지 확인하기 위함
    
    if vcnta = 1 then    
        update tblattendance set 
            attendance_type_seq = ptype
        where student_seq = pstudent_seq
            and open_course_seq = fnGetcourseSeq_ST(pstudent_seq)
            and to_char(attendance_date, 'yyyy-mm-dd') = to_date(pdate, 'yyyy-mm-dd');
    
        presult := 1;
        
    end if;
    

exception
    when others then
        presult := 0;

end procWantUpdateAttendance_ST;



--1)
-- *** (날짜, 학생번호, 근태유형번호) -> 원하는 날짜 근태유형 수정 실행 저장 프로시저 *** 

--   -> 해당 날짜, 수정된 유형까지 스크립트 출력하기 위한 저장 프로시저
create or replace procedure procWantUpdateAttendanceAct_ST(
    pdate varchar2,
    pstudent_seq varchar2,
    ptype varchar2
)
is
    vresult number;
begin
    procWantUpdateAttendance_ST(pdate, pstudent_seq, ptype, vresult);
        
    if vresult = 1 then
        dbms_output.put_line(pdate || '일자 근태유형 ' || ptype || '으로 수정 완료.');
    else
        dbms_output.put_line('다시 입력해주세요.');
    end if;
end procWantUpdateAttendanceAct_ST;


-- ***** (날짜, 학생번호, 근태유형번호) -> 원하는 날짜 근태유형 수정 실행 익명 프로시저 *****

execute procWantUpdateAttendanceAct_ST('2021-12-06', fnlogin_st('김조하', '1770114'), 'TA04');



--2)
-- ***** (날짜, 학생번호, 근태유형번호) -> 원하는 날짜 근태유형 수정 실행 익명 프로시저 ***** 

--  -> 수정 내용 없이 수정 성공 여부만 스크립트 출력
declare
    vresult number;
begin
    procWantUpdateAttendance_ST('2021-12-06', 'S0038', 'TA05', vresult);
        
    if vresult = 1 then
        dbms_output.put_line('근태유형 수정 완료.');
    else
        dbms_output.put_line('다시 입력해주세요.');
    end if;
end;





-- *** 트리거 전용 테이블 생성 ***
create table tblLogAttendance (
    seq number primary key,
    message varchar2(1000) not null,
    regdate date default sysdate not null
);

select * from tblLogAttendance;

drop sequence seqLogAttendance;
create sequence seqLogAttendance;


--실패 원인.....?
--근태 테이블 데이터가 수정될 경우 트리거를 발생시켜 트리거 전용 테이블에 인서트 하고싶었는데 트리거 생성이 안되네요 ,,,,,..

-- *** (근태 테이블 수정 후) 트리거 생성 ***
create or replace trigger trgUpdateAttendance_ST
    after
    update on tblattendance
    for each row
declare
    vstudent tblattendance.student_seq%type;
    vseq1 tblattendance.attendance_type_seq%type;
    vseq2 tblattendance.attendance_type_seq%type;
    vdate1 tblattendance.attendance_date%type;
    vdate2 tblattendance.attendance_date%type;
begin
    
    select attendance_type_seq, attendance_date, student_seq into vseq1, vdate1, vstudent
    from tblattendance 
        where attendance_type_seq = :old.attendance_type_seq 
            and attendance_date = :old.attendance_date
            and :old.student_seq = :new.student_seq
            and :old.open_course_seq = :new.open_course_seq;     --수정 전
        
    select attendance_type_seq, attendance_date, student_seq into vseq2, vdate2, vstudent 
    from tblattendance
        where attendance_type_seq = :new.attendance_type_seq
            and attendance_date = :new.attendance_date
            and :old.student_seq = :new.student_seq
            and :old.open_course_seq = :new.open_course_seq;     --수정 후
        
    if vdate1 <> vdate2 then
        insert into tblLogAttendance (seq, message, regdate) values (seqLogAttendance.nextval, '학생번호가 ' || vstudent || '인 학생의 근태유형번호를 ' || vseq1 || '에서 ' || vseq2 || '로 수정했습니다.', default);
        insert into tblLogAttendance (seq, message, regdate) values (seqLogAttendance.nextval, '학생번호가 ' || vstudent || '인 학생의 날짜를 ' || vdate1 || '에서 ' || vdate2 || '로 수정했습니다.', default);
    else
        insert into tblLogAttendance (seq, message, regdate) values (seqLogAttendance.nextval, '학생번호가 ' || vstudent || '인 학생의 근태유형번호를 ' || vseq1 || '에서 ' || vseq2 || '로 수정했습니다.', default);
    end if;
    
--    dbms_output.put_line('[' || to_char(sysdate, 'HH24:MI:SS') || '] 수정 전 : ' || vseq1 || '/ 수정 후 : ' || vseq2);
--    dbms_output.put_line('수정 전 ' || :old.attendance_type_seq || ', ' ||  :old.attendance_date || ', 수정 후 ' || :new.attendance_type_seq || ', ' || :new.attendance_date);
--    dbms_output.put_line(:old.attendance_type_seq, :old.attendance_dat, :new.attendance_type_seq, :new.attendance_date);
    dbms_output.put_line('트리거 입력 완료');

exception
    when others then
       dbms_output.put_line('트리거 입력 실패');  

end trgUpdateAttendance_ST;


drop trigger trgUpdateAttendance_ST;





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
where s.student_seq = fnlogin_st('김조하', '1770114')
order by a.attendance_date desc;
--교육생 로그인 시 자동으로 where 조건에 학생 번호가 붙어 해당 교육생의 전체 출결이 조회된다.
--fnlogin_st('김조하', '1770114');  --학생번호 'S0038'



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
where s.student_seq = fnlogin_st('김조하', '1770114')
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
where s.student_seq = fnlogin_st('김조하', '1770114')
    and to_char(a.attendance_date, 'YYYY-MM-DD') = '2021-10-05'
--    and a.attendance_date = to_date('2021-10-05', 'YYYY-MM-DD')
order by a.attendance_date;
--원하는 날짜의 출퇴근 현황을 조회할 수 있다

    and to_char(day_attendance_date, 'YYYY-MM-DD') = to_char(current_date, 'YYYY-MM-DD')
--오늘자의 출퇴근 현황을 조회할 수 있다
