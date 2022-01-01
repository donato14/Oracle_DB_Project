/*
2.3) 배점 입력 / 시험날짜 / 시험문제 입력 ●
    - procUpdateAtPoint_T
    - procUpdateWtPoint_T
    - procUpdatePtPoint_T

2.3.4.1) 시험 등록 (기존에 시험 등록을 안한 경우) ●
    - procAddTest_T
    - procUpdateTestFileCheck_T

2.3.5) 시험날짜 수정(입력) ●
    - procUpdateTestDate_T
*/


----------- 2.3.1) 출결배점 수정(입력)_프로시저
create or replace procedure procUpdateAtPoint_T(
    popen_subject_seq           varchar2,
    pattendance_distribution    number,
    presult                     out number
)
is
    vtotal number;
begin
    
    -- 1) Check the total distribution
    select sum(pattendance_distribution + written_distribution + practical_distribution) 
        into vtotal from tblopensubject
    where open_subject_seq = popen_subject_seq;
   
    -- 2) Update at_distribution
    if vtotal <= 100 then  
        update tblopensubject 
        set attendance_distribution = pattendance_distribution
        where open_subject_seq  = popen_subject_seq;
    
        presult := 1;
    else 
        presult := 0;
        dbms_output.put_line('배점의 총점은 100을 넘을 수 없습니다.');
    end if;
    
exception
    when others then
        presult := 0;
    
end procUpdateAtPoint_T;


-- 프로시저_실행
declare
    vopen_subject_seq           tblopensubject.open_subject_seq%type    := 'OS001'; 
    vattendance_distribution    number                                  := 40;
    vresult                     number;
begin
    procUpdateAtPoint_T(vopen_subject_seq, vattendance_distribution, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('출결배점 입력 성공');
        dbms_output.put_line('(과목 : ' || vopen_subject_seq || ', ' || '출결배점 : ' || vattendance_distribution || ')');
    else 
        dbms_output.put_line('출결배점 입력 실패');
    end if;
end;


-- 1. 변경 전/후 확인
select * from tblopensubject where open_subject_seq = 'OS001';
-- 2. 프로시저 실행



----------- 2.3.2) 필기배점 수정(입력)_프로시저
create or replace procedure procUpdateWtPoint_T(
    popen_subject_seq       varchar2,
    pwritten_distribution   number,
    presult                 out number
)
is
    vtotal number;
begin
    
    -- 1) Check the total distribution
    select sum(attendance_distribution + pwritten_distribution + practical_distribution) 
        into vtotal from tblopensubject
    where open_subject_seq = popen_subject_seq;
    
    -- 2) Update wt_distribution
    if vtotal <= 100 then
        update tblopensubject 
        set written_distribution = pwritten_distribution
        where open_subject_seq = popen_subject_seq;
    
        presult := 1;
    else
        presult := 0;
        dbms_output.put_line('배점의 총점은 100을 넘을 수 없습니다.');
    end if;

exception
    when others then
        presult := 0;

end procUpdateWtPoint_T;


-- 프로시저_실행
declare
    vopen_subject_seq       tblopensubject.open_subject_seq%type := 'OS001'; 
    vwritten_distribution   number                               := 30;
    vresult                 number;
begin
    procUpdateWtPoint_T(vopen_subject_seq, vwritten_distribution, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('필기배점 입력 성공');
        dbms_output.put_line('(과목 : ' || vopen_subject_seq || ', ' || '필기배점 : ' || vwritten_distribution || ')');
    else 
        dbms_output.put_line('필기배점 입력 실패');
    end if;
end;



-- 1. 변경 전/후 확인
select * from tblopensubject where open_subject_seq = 'OS001';
-- 2. 프로시저 실행


----------- 2.3.3) 실기배점 수정(입력)
create or replace procedure procUpdatePtPoint_T(
    popen_subject_seq           varchar2,
    ppractical_distribution     number,
    presult                     out number
)
is
    vtotal number;
begin
    
    -- Check the total distribution
    select sum(attendance_distribution + written_distribution + ppractical_distribution) 
        into vtotal from tblopensubject
    where open_subject_seq = popen_subject_seq;
    
    -- Update pt_distribution
    if vtotal <= 100 then
        update tblopensubject 
        set practical_distribution = ppractical_distribution
        where open_subject_seq = popen_subject_seq;
        
        presult := 1;
    else
        presult := 0;
        dbms_output.put_line('배점의 총점은 100을 넘을 수 없습니다.');
    end if;


exception
    when others then
        presult := 0;    
        
end procUpdatePtPoint_T;


-- 프로시저_실행
declare
    vopen_subject_seq           tblopensubject.open_subject_seq%type := 'OS001'; 
    vpractical_distribution     number                               := 30;
    vresult                     number;
begin
    procUpdatePtPoint_T(vopen_subject_seq, vpractical_distribution, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('실기배점 입력 성공');
        dbms_output.put_line('(과목 : ' || vopen_subject_seq || ', ' || '실기배점 : ' || vpractical_distribution || ')');
    else 
        dbms_output.put_line('실기배점 입력 실패');
    end if;
end;



-- 1. 변경 전/후 확인
select * from tblopensubject where open_subject_seq = 'OS001';
-- 2. 프로시저 실행


select count(*) from tbltest
where open_subject_seq = 'OS001' and type = '필기';



----------- 2.3.4.1) 시험 등록 (기존에 시험 등록을 안한 경우)
create or replace PROCEDURE procAddTest_T(
    ptest_date          date,
    ptest_type          varchar2,
    popen_subject_seq   varchar2,
    presult             out number
)
is
    vcount number;
begin

    -- 1) Counting test records
    select count(*) into vcount 
    from tbltest 
    where open_subject_seq = popen_subject_seq and type = ptest_type;
    
    
    -- 2) if there's no test record > insert query
    if vcount = 0 then         
        insert into tbltest (test_seq, test_date, type, open_subject_seq) values (
            (select concat('TEST', lpad(max(to_number(substr(test_seq, 5)))+1, 4, '0')) from tbltest),
            ptest_date, 
            ptest_type, 
            popen_subject_seq
        );
        
        -- Update testfile_check column
        procUpdateTestFileCheck_T(popen_subject_seq);
        presult := 1;
    
    else
        presult := 0;
        dbms_output.put_line('이미 시험이 등록 되어있습니다.');
    end if;

exception
    when others then
        presult := 0;

end procAddTest_T;


-- 2.3.4.2) '시험문제파일등록여부' 컬럼 변경 (해당 과목의 시험이 필기/실기 둘 다 등록 됐을 경우) 
create or replace PROCEDURE procUpdateTestFileCheck_T (
    popen_subject_seq varchar2
)
is
    vcount number;
begin
    -- 1) Counting test records
    select count(*) into vcount from tblTest where open_subject_seq = popen_subject_seq;
    
    
    -- 2) if there are both test records(writting/practical) then update testfile_check column
    if vcount = 2 then
        update tblopensubject
        set testfile_check = 'Y'
        where open_subject_seq = popen_subject_seq;
    end if;

end procUpdateTestFileCheck_T;


-- 프로시저_실행
declare
    vtest_date          date                := current_date;
    vtest_type          tbltest.type%type   := '필기';
    vopen_subject_seq   tblopensubject.open_subject_seq%type := 'OS075';
    vresult             number;
begin
    procAddTest_T(vtest_date, vtest_type, vopen_subject_seq, vresult);
    
    if vresult = 1 then 
        dbms_output.put_line('시험 등록 성공');
        dbms_output.put_line('(' || vtest_date || ', ' || vtest_type || ', ' || vopen_subject_seq || ')');
    else 
        dbms_output.put_line('시험 등록 실패');
    end if;
end;



-- 프로시저 작동_예시 1
-- ex) 이미 등록된 시험 > 프로시저 실행시 '시험 등록 실패'
select * from tbltest
where open_subject_seq = 'OS001';


-- 프로시저 작동_예시 2
-- ex) 'OS075' 필기 시험 삭제 > 시험등록 프로시저 'procAddTest_T' 실행 > 시험 등록 확인 > '시험문제등록여부' 확인 


-- 1. 변경 전/후 확인
select * from tbltest
where open_subject_seq = 'OS075';

-- 2. 기존 시험 삭제
delete from tbltest
where open_subject_seq = 'OS075' and type = '필기';

-- 3. 프로시저 실행

-- 4. 시험문제등록여부 확인
select * from tblopensubject
where open_subject_seq = 'OS075';



----------- 2.3.5) 시험날짜 수정(입력)
create or replace procedure procUpdateTestDate_T(
    popen_subject_seq   varchar2,
    ptest_type          varchar2,
    pupdate_date        date,
    presult             out number
)
is
begin
    update tbltest
    set test_date = pupdate_date
    where open_subject_seq = popen_subject_seq and type = ptest_type;
    
    presult := 1;
    
exception
    when others then
        presult := 0;
        
end procUpdateTestDate_T;


-- 프로시저 실행
declare
    vopen_subject_seq   tblopensubject.open_subject_seq%type := 'OS001'; 
    vtest_type          tbltest.type%type := '필기';
    vupdate_date        date := current_date;
    vresult             number;
begin
    procUpdateTestDate_T(vopen_subject_seq, vtest_type, vupdate_date, vresult);
    
    if vresult = 1 then 
        dbms_output.put_line('시험날짜 변경 성공');
        dbms_output.put_line('(' || vopen_subject_seq || ', ' || vtest_type || ', ' || vupdate_date || ')');
    else 
        dbms_output.put_line('시험날짜 변경 실패');
    end if;
    
end;

-- 1. 변경 전/후 확인
select * from tbltest where open_subject_seq = 'OS001';
-- 2. 프로시저 실행
