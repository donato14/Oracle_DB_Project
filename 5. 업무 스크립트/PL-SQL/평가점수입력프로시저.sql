--평가점수입력

CREATE OR REPLACE PROCEDURE procUpdateEvalScore_A
IS
    v_Num number;
    v_score number;
    type varray_type is varray(999) of varchar(20);
    type varray_type_n is varray(99) of number;
    v_Course varray_type := varray_type();
    v_Student varray_type := varray_type();
    CURSOR CourseStudent IS
    select open_course_seq, student_seq
   from tblRegister;

BEGIN
    v_Num := 1;
    for getOpenCourse in CourseStudent
    loop
        v_Course.EXTEND;
        v_Student.EXTEND;
        v_Course(v_num) := getOpenCourse.open_course_seq;
        v_Student(v_num):= getOpenCourse.student_seq;
        v_Num := v_Num+1;
    end loop;
    select count(*) into v_num from tblRegister;
   for i in 1..v_num
   loop
   v_score := 0;
   select round(avg(subject_score),1) into v_score 
   from tblScoreInfo
   where student_seq = v_Student(i) and open_course_seq = v_Course(i);
   if not(v_score = 0) then
   update tblRegister
    set evalution_score = v_score
   where student_seq = v_Student(i) and open_course_seq = v_Course(i);
   end if;
   end loop;
   
END;