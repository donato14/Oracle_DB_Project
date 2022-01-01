/*
3.3) 특정 교육생 선택 > 해당 교육생의 시험 점수 입력(출결, 필기, 실기 점수 구분 입력)
     3.3.1) 출결점수 입력(수정) ●
        - procUpdateAtScore_T
        
     3.3.2) 필기점수 입력(수정)
         3.3.2.1) 시험테이블 > 필기점수 입력 ●
         3.3.2.2) 성적정보테이블 > 필기점수 환산 입력(수정) ●
            - procAddWtScore_T
            - procUpdateWtScore_T
         
     3.3.3) 실기점수 입력(수정)    
         3.3.3.1) 시험테이블 > 실기점수 입력 ●
         3.3.3.2) 성적정보테이블 > 실기점수 환산 입력(수정) ●
            - procAddPtScore_T
            - procUpdatePtScore_T
    
    3.3.4) 총점 재계산 ●
        - procUpdateSubScore_T
*/


----------- 3.3.1) 출결점수 입력(수정)_프로시저
create or replace PROCEDURE procUpdateAtScore_T (
    popen_subject_seq   varchar2,
    pstudent_seq        varchar2,
    pattendance_score   number,
    presult             out number
)
is
begin
    -- 1) Update attendance score
    update tblscoreinfo
    set attendance_score = pattendance_score
    where opensubject_seq = popen_subject_seq
            and student_seq = pstudent_seq;
    
    -- 2) Update subject_score tblScoreInfo
    procUpdateSubScore_T(popen_subject_seq, pstudent_seq);
    presult := 1;

Exception
    when others then
        presult := 0;
            
end procUpdateAtScore_T;



-- 프로시저_실행
declare
    vopen_subject_seq   tblscoreinfo.opensubject_seq%type   := 'OS001';
    vstudent_seq        tblscoreinfo.student_seq%type       := 'S0004';
    pattendance_score   number                              := 15;
    vresult number;
begin
    procUpdateAtScore_T(vopen_subject_seq, vstudent_seq, pattendance_score, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('출결점수 입력 성공');
        dbms_output.put_line('(과목 : ' || vopen_subject_seq || ', 학생 : ' || vstudent_seq ||', 출결점수 : ' || pattendance_score || ')');
    else 
        dbms_output.put_line('출결점수 입력 실패');
    end if;
    
end;


-- 1. 변경 전/후 확인
select * from tblscoreinfo
where opensubject_seq = 'OS001' and student_seq = 'S0004';

-- 2. 프로시저 실행



----------- 3.3.2) 필기점수 입력(수정)
-- if there is no record in testresult > insert
-- if a record exists in testresult > update

create or replace PROCEDURE procAddWtScore_T(
    popen_subject_seq   varchar2,   -- 개설과목번호
    ptest_type          varchar2,   -- 시험타입
    pstudent_seq        varchar2,   -- 학생번호
    pwritten_score      number,     -- 점수
    presult             out number
)
is
    vcount              number;
    vtest_seq           tbltest.test_seq%type;
    vopen_course_seq    tblregister.open_course_seq%type;
begin
    
    -- Found the 'test_seq'
    select test_seq into vtest_seq 
    from tbltest where open_subject_seq = popen_subject_seq and type = ptest_type;
    
    
    -------- 1) Counting testResult record for 'open_subject_seq' and 'type' and 'student_seq'
    select count(*) into vcount 
    from tbltestresult
    where test_seq = vtest_seq and student_seq = pstudent_seq;
       
        
    -------- 2) Insert or Update Score
    -- 2.1) if there is no record > insert
    if vcount = 0 then
        
        -- Found the 'open_course_seq'
        select open_course_seq into vopen_course_seq 
        from tblopensubject where open_subject_seq = popen_subject_seq;
        
        -- insert score
        insert into tbltestresult (student_seq, test_seq, score, open_course_seq)
            values(pstudent_seq, vtest_seq, pwritten_score, vopen_course_seq);
        
    
    -- 2.2) if there is record > update
    elsif vcount = 1 then
        update tbltestresult
        set score = pwritten_score
        where test_seq = vtest_seq and student_seq = pstudent_seq;
    
    end if;
    
    
    -------- 3) Update written_score in tblscoreinfo
    procUpdateWtScore_T(popen_subject_seq, pstudent_seq, vtest_seq);
    
    
    -------- 4) Update subject_score in tblscoreinfo
    procUpdateSubScore_T(popen_subject_seq, pstudent_seq);
    
    presult := 1;
    
Exception
    when others then
        presult := 0;
         
end procAddWtScore_T;



----------- 3.3.2.2) 성적정보테이블 > 필기점수 환산 입력(수정)
create or replace PROCEDURE procUpdateWtScore_T(
    popen_subject_seq   varchar2,   -- 개설과목번호
    pstudent_seq        varchar2,   -- 학생번호
    ptest_seq           varchar2    -- 시험번호
)
is 
begin
    update tblscoreinfo
    set written_score =
        -- 점수 * 배점
        (select score from tbltestresult
            where test_seq =  ptest_seq and student_seq = pstudent_seq)
        * 
        (select written_distribution / 100 from tblopensubject 
            where open_subject_seq = popen_subject_seq)

    where opensubject_seq = popen_subject_seq and student_seq = pstudent_seq;

end procUpdateWtScore_T;


-- 프로시저_실행
declare 
    vopen_subject_seq   tblscoreinfo.opensubject_seq%type   := 'OS001';   -- 개설과목번호
    vtest_type          tbltest.type%type                   := '필기';    -- 시험타입
    vstudent_seq        tblstudent.student_seq%type         := 'S0004';   -- 학생번호
    pscore              number                              := 80;       -- 점수
    vresult             number;
begin   
    procAddWtScore_T(vopen_subject_seq, vtest_type , vstudent_seq , pscore, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('필기점수 입력 성공');
        dbms_output.put_line('(과목 : ' || vopen_subject_seq || ', 타입 : ' || vtest_type ||', 학생 : ' || vstudent_seq ||', 필기점수 : ' || pscore || ')');
    else 
        dbms_output.put_line('필기점수 입력 실패');
    end if;
    
end; 

rollback;

-- 프로시저 작동_예시 1 
-- ex) 시험 결과 O ) 'OS001' 과목, 'S0004' 학생 필기점수 수정 > 'procAddWtScore_T' 실행  

-- 1. 변경 전/후 필기점수 + 환산점수 확인
select * from tbltestresult
where test_seq = 'TEST0001' and student_seq = 'S0004';

select * from tblscoreinfo
where opensubject_seq = 'OS001' and student_seq = 'S0004';

-- 2. 프로시저 실행



-- 프로시저 작동_예시 2
-- ex) 시험 결과 X ) 'OS075' 과목, 'S0042' 학생 필기점수 입력 > 'procAddWtScore_T' 실행 

-- 시험점수를 입력하면 [시험결과] 테이블에 레코드가 새로 추가 되긴 하나,
-- [성적정보] 테이블에 해당 학생 레코드가 존재하지 않아서 환산점수가 들어가지는 않습니다.
-- 시연하실 때는 [성적정보]에 레코드가 있는 학생의 시험점수를 수정하는 방향으로 가셔야 시험점수가 수정되고, 환산점수가 변경된 결과 확인이 가능합니다. 


--1. 변경 전/후 필기점수 + 환산점수 확인
select * from tbltestresult
where test_seq = 'TEST0150' and student_seq = 'S0042';

select * from tblscoreinfo
where opensubject_seq = 'OS075' and student_seq = 'S0042';

-- 2. 프로시저 실행




----------- 3.3.3) 실기점수 입력(수정)
-- if there is no record in testresult > insert
-- if a record exists in testresult > update

create or replace PROCEDURE procAddPtScore_T(
    popen_subject_seq   varchar2,   -- 개설과목번호
    ptest_type          varchar2,   -- 시험타입
    pstudent_seq        varchar2,   -- 학생번호
    ppractical_score    number,     -- 점수
    presult             out number
)
is
    vcount              number;
    vtest_seq           tbltest.test_seq%type;
    vopen_course_seq    tblregister.open_course_seq%type;
begin
    
    -- Found the 'test_seq'
    select test_seq into vtest_seq 
    from tbltest where open_subject_seq = popen_subject_seq and type = ptest_type;
    
    
    -------- 1) Counting testResult record for 'open_subject_seq' and 'type' and 'student_seq'
    select count(*) into vcount 
    from tbltestresult
    where test_seq = vtest_seq and student_seq = pstudent_seq;
       
        
    -------- 2) Insert or Update Score
    -- 2.1) if there is no record > insert
    if vcount = 0 then
        
        -- Found the 'open_course_seq'
        select open_course_seq into vopen_course_seq 
        from tblopensubject where open_subject_seq = popen_subject_seq;
        
        -- insert score
        insert into tbltestresult (student_seq, test_seq, score, open_course_seq)
            values(pstudent_seq, vtest_seq, ppractical_score, vopen_course_seq);
        
    
    -- 2.2) if there is record > update
    elsif vcount = 1 then
        update tbltestresult
        set score = ppractical_score
        where test_seq = vtest_seq and student_seq = pstudent_seq;
    
    end if;
    
    
    -------- 3) Update practical_score in tblscoreinfo
    procUpdatePtScore_T(popen_subject_seq, pstudent_seq, vtest_seq);
    
    -------- 4) Update subject_score in tblscoreinfo
    procUpdateSubScore_T(popen_subject_seq, pstudent_seq);
    
    presult := 1;
    
Exception
    when others then
        presult := 0;
         
end procAddPtScore_T;



----------- 3.3.3.2) 성적정보테이블 > 실기점수 환산 입력(수정)
create or replace PROCEDURE procUpdatePtScore_T(
    popen_subject_seq   varchar2,   -- 개설과목번호
    pstudent_seq        varchar2,   -- 학생번호
    ptest_seq           varchar2    -- 시험번호
)
is 
begin
    update tblscoreinfo
    set practical_score =
        -- 점수 * 배점
        (select score from tbltestresult
            where test_seq =  ptest_seq and student_seq = pstudent_seq)
        * 
        (select practical_distribution / 100 from tblopensubject 
            where open_subject_seq = popen_subject_seq)

    where opensubject_seq = popen_subject_seq and student_seq = pstudent_seq;

end procUpdatePtScore_T;


--> 이거 작동 안함 다시 확인하기.
-- 프로시저_실행
declare 
    vopen_subject_seq   tblscoreinfo.opensubject_seq%type   := 'OS001';   -- 개설과목번호
    vtest_type          tbltest.type%type                   := '실기';    -- 시험타입
    vstudent_seq        tblstudent.student_seq%type         := 'S0004';   -- 학생번호
    pscore              number                              := 89;       -- 점수
    vresult             number;
begin   
    procAddPtScore_T(vopen_subject_seq, vtest_type , vstudent_seq , pscore, vresult);
    
    if vresult = 1 then
        dbms_output.put_line('실기점수 입력 성공');
        dbms_output.put_line('(과목 : ' || vopen_subject_seq || ', 타입 : ' || vtest_type ||', 학생 : ' || vstudent_seq ||', 실기점수 : ' || pscore || ')');
    else 
        dbms_output.put_line('실기점수 입력 실패');
    end if;
    
end; 


-- 프로시저 작동_예시 1 
-- ex) 시험 결과 O ) 'OS001' 과목, 'S0004' 학생 필기점수 수정 > 'procAddPtScore_T' 실행  

-- 1. 변경 전/후 필기점수 + 환산점수 확인
select * from tbltestresult
where test_seq = 'TEST0002' and student_seq = 'S0004';

select * from tblscoreinfo
where opensubject_seq = 'OS001' and student_seq = 'S0004';

-- 2. 프로시저 실행




----------- 3.3.4) 총점 재계산
create or replace PROCEDURE procUpdateSubScore_T(
    popen_subject_seq   varchar2,
    pstudent_seq        varchar2
)
is
begin
    update tblscoreinfo
    set subject_score = attendance_score + written_score + practical_score
    where opensubject_seq = popen_subject_seq 
            and student_seq = pstudent_seq;

end procUpdateSubScore_T;

