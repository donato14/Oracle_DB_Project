--채용공고정보입력 -구직자찾기
CREATE OR REPLACE PROCEDURE procSelectJOBSEEKER_A(
    v_recruiter_seq VARCHAR2,
    SelectJOBSEEKER_cursor OUT SYS_REFCURSOR
)
IS
begin
    open SelectJOBSEEKER_cursor for
    select TBLJOBSEEKER.student_seq as "교육생번호",
    TBLJOBSEEKER.open_course_seq as "개강과정번호",
    TBLJOBSEEKER.desired_place as "희망근무지",
    TBLJOBSEEKER.min_salary as "희망최저연봉",
    tbltask.name as "희망직무명"
    from TBLJOBSEEKER join tbltask
    on(TBLJOBSEEKER.task_seq = tbltask.task_seq)
    where TBLJOBSEEKER.desired_place like concat(concat('%',REGEXP_SUBSTR((select work_place from TBLJOBPOSTING where recruiter_seq= v_recruiter_seq),'\w+',1,1)),'%')
    and min_salary <= (select salary from TBLJOBPOSTING where recruiter_seq= v_recruiter_seq)
    and TBLJOBSEEKER.TASK_SEQ = (select TASK_SEQ from TBLJOBPOSTING where recruiter_seq= v_recruiter_seq);
end;

VAR SelectJOBSEEKER_cursor REFCURSOR
exec procSelectJOBSEEKER_A('RE0059',:SelectJOBSEEKER_cursor)
print SelectJOBSEEKER_cursor


--교육생 정보입력 -기업찾기
CREATE OR REPLACE PROCEDURE procSelectcompany_A(
    v_student_seq VARCHAR2,
    v_open_course_seq VARCHAR2,
    Selectcompany_cursor OUT SYS_REFCURSOR
)
IS
begin
    open Selectcompany_cursor for
    select 
    TBLJOBPOSTING.recruiter_seq as "모집번호",
    tblcompany.name as "기업명",
    TBLJOBPOSTING.work_place as "근무지",
    TBLJOBPOSTING.salary as "급여",
    TBLJOBPOSTING.education_level as "필요학력",
    TBLJOBPOSTING.employee_number as "채용인원",
    tbltask.name as "직무명"
    from tbltask join TBLJOBPOSTING
    on(tbltask.TASK_SEQ = TBLJOBPOSTING.TASK_SEQ)
    join tblcompany
    on(TBLJOBPOSTING.company_seq = tblcompany.company_seq)
    where WORK_PLACE like concat(concat('%',(select desired_place from TBLJOBSEEKER where student_seq = v_student_seq and open_course_seq = v_open_course_seq)),'%')
    and SALARY >= (select min_salary from TBLJOBSEEKER where student_seq = v_student_seq and open_course_seq = v_open_course_seq)
    and TO_CHAR(SYSDATE, 'YYYY-MM-DD') >= TO_CHAR(START_DATE, 'YYYY-MM-DD') 
    and TO_CHAR(SYSDATE, 'YYYY-MM-DD') <= TO_CHAR(END_DATE, 'YYYY-MM-DD') 
    and tblJobPosting.task_seq = (select TBLJOBSEEKER.task_seq from TBLJOBSEEKER where student_seq = v_student_seq and open_course_seq = v_open_course_seq);
end;

VAR Selectcompany_cursor REFCURSOR
exec procSelectcompany_A('S0250','OL007',:Selectcompany_cursor)
print Selectcompany_cursor
