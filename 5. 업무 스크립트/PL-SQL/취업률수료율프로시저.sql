--취업율
CREATE OR REPLACE PROCEDURE procEmploymentRate_A
IS
    v_jobseeker number;
    v_getjob number;
BEGIN
    select count(*)into v_getjob
    from TBLJOBSEEKER
    WHERE employment_state = 'Y';
    select count(*) into v_jobseeker
    from TBLJOBSEEKER;
    
    dbms_output.put_line('구직자 취업률 :' || round(v_getjob/v_jobseeker*100,1) || '%');

END;

--수료율
CREATE OR REPLACE PROCEDURE procCompletionRate_A
IS
    v_Num number;
    v_name varchar2(300);
    type varray_type is varray(99) of varchar(20);
    type varray_type_n is varray(99) of number;
    v_Course varray_type := varray_type();
    v_Completion varray_type_n := varray_type_n();
    v_Register varray_type_n := varray_type_n();
    CURSOR OpenCourse IS
    SELECT distinct open_course_seq FROM tblOpenCourse;

BEGIN
    v_Num := 1;
    for getOpenCourse in OpenCourse
    loop
        v_Course.EXTEND;
        v_Course(v_Num) := getOpenCourse.open_course_seq;
        v_Num := v_Num+1;
    end loop;
   for i in 1..v_Course.count
   loop
   v_Register.EXTEND;
   select count(*) into v_Register(i) from tblRegister
   where open_course_seq = v_Course(i);
   v_Completion.EXTEND;
   select count(*) into v_Completion(i) from tblRegister
   where open_course_seq = v_Course(i) 
   and tblRegister.completion_status = 'Y';
   
   select tblCourse.name into v_name
   from tblOpenCourse join tblCourse
   on(tblOpenCourse.course_seq = tblCourse.course_seq)
   where tblOpenCourse.open_course_seq = v_Course(i);
   
   if v_Register(i) = 0
   then dbms_output.put_line(v_name);
   dbms_output.put_line('수료율 : '|| 0);
   else
    dbms_output.put_line(v_name);
    dbms_output.put_line('수료율 : '|| round(v_Completion(i)/v_Register(i),3) * 100 || '%');
    end if;
   end loop;
   
END;