--요약───────────────────────────────────────────────────────────────────
-- ① 기초 정보 추가
-- 기초 과정 정보 추가
EXECUTE procCourseIstAct_M('테스트과정명2', '테스트 과정목표2', '테스트 과정설명2');
-- 기초 과목 정보 추가
EXECUTE procSubjectIstAct_M('테스트과목명', '공통');
-- 기초 교재 정보 추가
EXECUTE procTextbookIstAct_M('테스트교재명', '테스트출판사');
-- 기초 강의실 정보 추가
EXECUTE procClassroomIstAct_M('10강의실', 20);



-- ②기초 정보 출력
-- 기초 과정 정보 조회
select course_seq as "과정코드", name as "과정명", goal as "강의목표", detail as "강의설명" from tblCourse;
-- 기초 과목 정보 조회
select subject_seq as "과목코드", name as "과목명", type as "과목분류" from tblSubject;
-- 기초 교재 정보 조회
select textbook_seq as "교재코드", name as "교재명", publisher as "출판사" from tbltextbook;
-- 기초 강의실 정보 조회
select classroom_seq as "강의실코드", name as "강의실명", capacity as "강의실 정원" from tblClassroom;



-- ③기초 정보 수정
-- 3-1)기초 과정 정보 수정
-- 타겟 1: 과정이름 수정 > '과정명 수정'
EXECUTE procCourseSltAct_M('L018', '1', '과정명 수정');
-- 타겟 2: 과정목표 수정 > '과정목표 수정'
EXECUTE procCourseSltAct_M('L018', '2', '과정목표 수정');
-- 타겟 3: 과정이름 수정 > '과정설명 수정'
EXECUTE procCourseSltAct_M('L018', '3', '과정설명 수정');

-- 3-2)기초 과목 정보 수정
-- 타겟 1: 과정이름 수정 > '과목명 수정'
EXECUTE procUpdateSubjectAct_M('SUB041', '1', '수정과목명');
-- 타겟 1: 과정이름 수정 > '과목분류 수정'
EXECUTE procUpdateSubjectAct_M('SUB041', '2', '수정과목분류');

-- 3-3)기초 교재 정보 수정
-- 1:타겟 > 교재명 수정
EXECUTE procUpdateTextbookAct_M('B122', '1', '수정 교재명');
-- 2:타겟 > 교재 출판사 수정
EXECUTE procUpdateTextbookAct_M('B122', '2', '수정 출판사');

-- 3-4)기초 강의실 정보 수정
-- 1:타겟 > 강의실 명 수정
EXECUTE procUpdateClassroomAct_M('R007', '1', '강의실10');
-- 2:타겟 > 강의실 정원 수정
EXECUTE procUpdateClassroomAct_M('R007', '2', '21');



-- ④*****기초 정보 삭제*****
-- 4-1)기초 과정 정보 삭제
-- 1:타겟 > 과정코드로 찾아서 삭제
EXECUTE procCourseDltAct_M('1', 'L018');
-- 2:타겟 > 과정명으로 찾아서 삭제
EXECUTE procCourseDltAct_M('2', '테스트과정명2');

-- 4-2)기초 과목 정보 삭제
-- 1:타겟 > 과목코드로 찾아서 삭제
EXECUTE procSubjectDltAct_M('1', 'SUB041');
-- 2:타겟 > 과목명으로 찾아서 삭제
EXECUTE procSubjectDltAct_M('2', '테스트과목명');

-- 4-3)기초 교재 정보 삭제
-- 1:타겟 > 교재코드로 찾아서 삭제
EXECUTE procTextbookDltAct_M('1', 'B122');
-- 2:타겟 > 교재명으로 찾아서 삭제
EXECUTE procTextbookDltAct_M('2', '교재명');

-- 4-4)기초 강의실 정보 삭제
-- 1:타겟 > 강의실코드로 찾아서 삭제
EXECUTE procClassroomDltAct_M('1', 'R007');
-- 2:타겟 > 강의실명으로 찾아서 삭제
EXECUTE procClassroomDltAct_M('2', '강의실9');






--───────────────────────────────────────────────────────────────────

-- *****기초 정보 입력*****
-- 시퀀스 추출+1
    -- tblTest Seq
    select * from tbltest;
    select concat('TEST', lpad(max(to_number(substr(test_seq, 5)))+1, 4, '0')) from tbltest;
    -- tblCourse Seq
    select * from tblCourse;
    select concat('L', lpad(max(to_number(substr(course_seq, 2)))+1, 3, '0')) from tblCourse;
    -- tblSubject Seq
    select * from tblSubject;
    select concat('SUB', lpad(max(to_number(substr(subject_seq, 4)))+1, 3, '0')) from tblSubject;
    -- tblTextbook Seq
    select * from tblTextbook ORDER BY textbook_seq desc;
    select concat('B', lpad(max(to_number(substr(textbook_seq, 2)))+1, 3, '0')) from tblTextbook;
    -- tblClassroom Seq
    select * from tblClassroom ORDER BY classroom_seq desc;
    SELECT CONCAT('R', lpad(MAX(to_number(substr(classroom_seq, 2)))+1, 3, '0')) FROM tblClassroom;
    -- tblTeacher Seq
    select * from tblTeacher ORDER BY teacher_seq desc;
    SELECT CONCAT('T', lpad(MAX(to_number(substr(teacher_seq, 2)))+1, 3, '0')) FROM tblTeacher;


-- 1. 기초 과정 정보 추가하기
INSERT INTO tblCourse (course_seq, name, goal, detail) VALUES ('L018', '과정명', '과정목표', '과정설명');
    -- 프로시저
    CREATE OR REPLACE PROCEDURE procCourseIst_M(
        pName VARCHAR2,
        pGoal VARCHAR2,
        pDetail VARCHAR2,
        pResult out number
    )
    IS
        pSeq VARCHAR2(10);
    BEGIN
        SELECT CONCAT('L', lpad(MAX(to_number(substr(course_seq, 2)))+1, 3, '0')) INTO pSeq FROM tblCourse;
        INSERT INTO tblCourse (course_seq, name, goal, detail)
        VALUES (pSeq, pName, pGoal, pDetail);
        pResult := 1;
    exception
        when others then
            pResult := 0;
    END procCourseIst_M;
    -----------------
    -- 실행 프로시저 --
    -----------------
    CREATE OR REPLACE PROCEDURE procCourseIstAct_M(
        pName VARCHAR2,
        pGoal VARCHAR2,
        pDetail VARCHAR2
    )
    IS
        vResult number;
    begin
        procCourseIst_M(pName, pGoal, pDetail, vResult);

        if vResult = 1 then
            dbms_output.put_line('기초 과정 정보 추가에 성공했습니다.('||pName||', '||pGoal||', '||pDetail||')');
        else
            dbms_output.put_line('기초 과정 정보 추가에 실패했습니다.('||pName||', '||pGoal||', '||pDetail||')');
        end if;
    end procCourseIstAct_M;

-- 기초 과정 정보 추가 테스트
set serverout on;
EXECUTE procCourseIstAct_M('테스트과정명2', '테스트 과정목표2', '테스트 과정설명2');
select * from tblCourse;
rollback;
DROP PROCEDURE procCourseIst_M;
DROP PROCEDURE procCourseIstAct_M;


-- 2. 기초 과목 정보 추가하기
INSERT INTO tblSubject (subject_seq, name, type) VALUES ('SUB041', '과목명', '과목분류');
    -- 프로시저
    CREATE OR REPLACE PROCEDURE procSubjectIst_M(
        pName VARCHAR2,
        pType VARCHAR2,
        pResult out number
    )
    IS
        pSeq VARCHAR2(10);
    BEGIN
        SELECT CONCAT('SUB', lpad(MAX(to_number(substr(subject_seq, 4)))+1, 3, '0')) INTO pSeq FROM tblSubject;
        INSERT INTO tblSubject (subject_seq, name, type) VALUES (pSeq, pName, pType);
        pResult := 1;
    exception
        when others then
            pResult := 0;
    END procSubjectIst_M;
    -----------------
    -- 실행 프로시저 --
    -----------------
    CREATE OR REPLACE PROCEDURE procSubjectIstAct_M(
        pName VARCHAR2,
        pType VARCHAR2
    )
    IS
        vResult number;
    begin
        procSubjectIst_M(pName, pType, vResult);

        if vResult = 1 then
            dbms_output.put_line('기초 과목 정보 추가에 성공했습니다.('||pName||', '||pType||')');
        else
            dbms_output.put_line('기초 과목 정보 추가에 실패했습니다.('||pName||', '||pType||')');
        end if;
    end procSubjectIstAct_M;

-- 기초 과목 정보 추가 테스트
set serverout on;
EXECUTE procSubjectIstAct_M('테스트과목명', '공통');
select * from tblSubject;
rollback;
DROP PROCEDURE procSubjectIst_M;
DROP PROCEDURE procSubjectIstAct_M;





-- 3. 기초 교재 정보 추가하기
INSERT INTO tblTextbook (textbook_seq, name, publisher) VALUES ('B122', '교재명', '출판사');
    -- 프로시저
    CREATE OR REPLACE PROCEDURE procTextbookIst_M(
        pName VARCHAR2,
        pPublisher VARCHAR2,
        pResult out number
    )
    IS
        pSeq VARCHAR2(10);
    BEGIN
        SELECT concat('B', lpad(max(to_number(substr(textbook_seq, 2)))+1, 3, '0')) INTO pSeq FROM tblTextbook;
        INSERT INTO tblTextbook (textbook_seq, name, publisher) VALUES (pSeq, pName, pPublisher);
        pResult := 1;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    END procTextbookIst_M;
    -----------------
    -- 실행 프로시저 --
    -----------------
    CREATE OR REPLACE PROCEDURE procTextbookIstAct_M(
        pName VARCHAR2,
        pPublisher VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procTextbookIst_M(pName, pPublisher, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('기초 교재 정보 추가에 성공했습니다.('||pName||', '||pPublisher||')');
        ELSE
            dbms_output.put_line('기초 교재 정보 추가에 실패했습니다.('||pName||', '||pPublisher||')');
        END if;
    END procTextbookIstAct_M;
-- 기초 교재 정보 추가 테스트
set serverout on;
EXECUTE procTextbookIstAct_M('테스트교재명', '테스트출판사');
select * from tblTextbook;
rollback;
DROP PROCEDURE procTextbook_M;
DROP PROCEDURE procTextbookIstAct_M;








-- 4. 기초 강의실 정보 추가하기
INSERT INTO tblClassroom (classroom_seq, name, capacity) VALUES ('R007', '강의실 명', '강의실 정원');
    -- 프로시저
    CREATE OR REPLACE PROCEDURE procClassroomIst_M(
        pName VARCHAR2,
        pCapacity VARCHAR2,
        pResult out number
    )
    IS
        pSeq VARCHAR2(10);
    BEGIN
        SELECT CONCAT('R', lpad(MAX(to_number(substr(classroom_seq, 2)))+1, 3, '0')) INTO pSeq FROM tblClassroom;
        INSERT INTO tblClassroom (classroom_seq, name, capacity) VALUES (pSeq, pName, pCapacity);
        pResult := 1;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    END procClassroomIst_M;
    -----------------
    -- 실행 프로시저 --
    -----------------
    CREATE OR REPLACE PROCEDURE procClassroomIstAct_M(
        pName VARCHAR2,
        pCapacity VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procClassroomIst_M(pName, pCapacity, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('기초 강의실 정보 추가에 성공했습니다.('||pName||', '||pCapacity||')');
        ELSE
            DBMS_OUTPUT.PUT_LINE(SYS.dbms_utility.format_error_backtrace);
            dbms_output.put_line('기초 강의실 정보 추가에 실패했습니다.('||pName||', '||pCapacity||')');
        END if;
    END procClassroomIstAct_M;

-- 기초 강의실 정보 추가 테스트
set serverout on;
EXECUTE procClassroomIstAct_M('10강의실', 20);
select * from tblClassroom;
rollback;
DROP PROCEDURE procClassroomIst_M;
DROP PROCEDURE procClassroomIstAct_M;



-- *****기초 정보 출력*****
-- 기초 과정 정보 조회
select course_seq as "과정코드", name as "과정명", goal as "강의목표", detail as "강의설명" from tblCourse;
-- 기초 과목 정보 조회
select subject_seq as "과목코드", name as "과목명", type as "과목분류" from tblSubject;
-- 기초 교재 정보 조회
select textbook_seq as "교재코드", name as "교재명", publisher as "출판사" from tbltextbook;
-- 기초 강의실 정보 조회
select classroom_seq as "강의실코드", name as "강의실명", capacity as "강의실 정원" from tblClassroom;





-- *****기초 정보 수정*****
-- 기초 과정 정보 수정하기
UPDATE tblCourse SET name='과정명 수정' WHERE course_seq='과정코드';
UPDATE tblCourse SET goal='과정목표 수정' WHERE course_seq='과정코드';
UPDATE tblCourse SET detail='과정설명 수정' WHERE course_seq='과정코드';
    -- 프로시저
    -- 1. 타겟인자 2. 컬럼인자 3. 값인자
    -- 1:타겟 > 과정명 수정
    -- 2:타겟 > 과정목표 수정
    -- 3:타겟 > 과정설명 수정
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
    CREATE OR REPLACE PROCEDURE procUpdateCourse_M(
        pTargetSeq VARCHAR2,
        pTargetColumn VARCHAR2,
        pValue VARCHAR2,
        pResult out number
    )
    IS
    BEGIN
        if pTargetColumn = '1' THEN
            UPDATE tblCourse SET name=pValue WHERE course_seq=pTargetSeq;
            pResult := 1;
        elsif pTargetColumn = '2' THEN
            UPDATE tblCourse SET goal=pValue WHERE course_seq=pTargetSeq;
            pResult := 2;
        elsif pTargetColumn = '3' THEN
            UPDATE tblCourse SET detail=pValue WHERE course_seq=pTargetSeq;
            pResult := 3;
        else
            pResult := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    END procUpdateCourse_M;
    -----------------
    -- 실행 프로시저 --
    -----------------
    CREATE OR REPLACE PROCEDURE procUpdateCourseAct_M(
        pTargetSeq VARCHAR2,
        pTargetColumn VARCHAR2,
        pValue VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procCourseSlt_M(pTargetSeq, pTargetColumn, pValue, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('');
        ELSIF vResult = 2 THEN
            dbms_output.put_line('');
        ELSIF vResult = 3 THEN
            dbms_output.put_line('');
        ELSIF vResult = -1 THEN
            dbms_output.put_line('1:타겟 > 과정명 수정');
            dbms_output.put_line('2:타겟 > 과정목표 수정');
            dbms_output.put_line('3:타겟 > 과정설명 수정');
            dbms_output.put_line('1, 2, 3의 타겟 중 하나를 선택하세요.');
        ELSE
            dbms_output.put_line('알 수 없는 오류');
        END if;
    END procUpdateCourseAct_M;

-- 기초 과정 정보 수정 테스트
set serverout on;
-- 임의 테스트 데이터 생성
EXECUTE procCourseIstAct_M('테스트과정명2', '테스트 과정목표2', '테스트 과정설명2');
select * from tblCourse;
-- 타겟 1: 과정이름 수정 > '과정명 수정'
EXECUTE procCourseSltAct_M('L018', '1', '과정명 수정');
select * from tblCourse;
-- 타겟 2: 과정목표 수정 > '과정목표 수정'
EXECUTE procCourseSltAct_M('L018', '2', '과정목표 수정');
select * from tblCourse;
-- 타겟 3: 과정이름 수정 > '과정설명 수정'
EXECUTE procCourseSltAct_M('L018', '3', '과정설명 수정');
select * from tblCourse;
-- 타겟 오류 > 1, 2, 3 중 하나 선택하라는 문구 출력
EXECUTE procCourseSltAct_M('L018', '4', '과정설명 수정');
rollback;
DROP PROCEDURE procUpdateCourse_M;
DROP PROCEDURE procUpdateCourseAct_M;









-- 기초 과정 정보 수정하기
UPDATE tblSubject SET name='과목명 수정' WHERE subject_seq='과목코드';
UPDATE tblSubject SET type='과목분류 수정' WHERE subject_seq='과목코드';
select * from tblsubject;
    -- 프로시저
    -- 1. 타겟인자 2. 컬럼인자 3. 값인자
    CREATE OR REPLACE PROCEDURE procUpdateSubject_M(
        pTargetSeq VARCHAR2,
        pTargetColumn VARCHAR2,
        pValue VARCHAR2,
        pResult out number
    )
    IS
    BEGIN
        if pTargetColumn = '1' THEN
            UPDATE tblSubject SET name=pValue WHERE subject_seq=pTargetSeq;
            pResult := 1;
        elsif pTargetColumn = '2' THEN
            IF pValue IN ('공통','선택') THEN
                UPDATE tblSubject SET type=pValue WHERE subject_seq=pTargetSeq;
                pResult := 2;
            ELSE
                pResult := -2;
            end if;
        else
            pResult := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 과목명 수정
    -- 2:타겟 > 과목타입 수정 (공통, 선택)
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
    END procUpdateSubject_M;



    -- 실행 프로시저
    CREATE OR REPLACE PROCEDURE procUpdateSubjectAct_M(
        pTargetSeq VARCHAR2,
        pTargetColumn VARCHAR2,
        pValue VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procUpdateSubject_M(pTargetSeq, pTargetColumn, pValue, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('과목명이 수정되었습니다.');
        ELSIF vResult = 2 THEN
            dbms_output.put_line('과목분류가 수정되었습니다. ');
        ELSIF vResult = -1 THEN
            dbms_output.put_line('1:타겟 > 과목명 수정');
            dbms_output.put_line('2:타겟 > 과목분류 수정(공통 or 선택)');
            dbms_output.put_line('1, 2의 타겟 컬럼 중 하나를 선택하세요.');
        ELSIF vResult = -2 THEN
            dbms_output.put_line('과목분류를 "공통" 또는 "선택"을 입력하세요.');
        ELSE
            dbms_output.put_line('알 수 없는 오류');
        END if;
    END procUpdateSubjectAct_M;

-- 기초 과목 정보 수정 테스트
set serverout on;
EXECUTE procSubjectIstAct_M('테스트과목명', '공통');
select * from tblSubject;
EXECUTE procUpdateSubjectAct_M('SUB041', '1', '수정과목명');
select * from tblSubject;
EXECUTE procUpdateSubjectAct_M('SUB041', '2', '수정과목분류');
EXECUTE procUpdateSubjectAct_M('SUB041', '2', '선택');
select * from tblSubject;
rollback;
DROP PROCEDURE procUpdateSubject_M;
DROP PROCEDURE procUpdateSubjectAct_M;









-- 기초 교재 정보 수정하기
select * from tblTextbook;
UPDATE tblTextbook SET name='교재명 수정' WHERE textbook_seq='교재코드';
UPDATE tblTextbook SET publisher='출판사 수정' WHERE textbook_seq='교재코드';

    -- 프로시저
    -- 1. 타겟인자 2. 컬럼인자 3. 값인자
    CREATE OR REPLACE PROCEDURE procUpdateTextbook_M(
        pTargetSeq VARCHAR2,
        pTargetColumn VARCHAR2,
        pValue VARCHAR2,
        pResult out number
    )
    IS
    BEGIN
        if pTargetColumn = '1' THEN
            UPDATE tblTextbook SET name=pValue WHERE textbook_seq=pTargetSeq;
            pResult := 1;
        elsif pTargetColumn = '2' THEN
            UPDATE tblTextbook SET publisher=pValue WHERE textbook_seq=pTargetSeq;
            pResult := 2;
        else
            pResult := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 교재명 수정
    -- 2:타겟 > 출판사 수정
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
    END procUpdateTextbook_M;

    -- 실행 프로시저
    CREATE OR REPLACE PROCEDURE procUpdateTextbookAct_M(
        pTargetSeq VARCHAR2,
        pTargetColumn VARCHAR2,
        pValue VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procUpdateTextbook_M(pTargetSeq, pTargetColumn, pValue, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('교재명이 수정되었습니다.');
        ELSIF vResult = 2 THEN
            dbms_output.put_line('교재 출판사가 수정되었습니다. ');
        ELSIF vResult = -1 THEN
            dbms_output.put_line('1:타겟 > 교재명 수정');
            dbms_output.put_line('2:타겟 > 교재 출판사 수정');
            dbms_output.put_line('1, 2의 타겟 컬럼 중 하나를 선택하세요.');
        ELSE
            dbms_output.put_line('알 수 없는 오류');
        END if;
    END procUpdateTextbookAct_M;

-- 기초 교재 정보 수정 테스트
set serverout on;
EXECUTE procTextbookIstAct_M('테스트 교재명', '테스트 출판사');
select * from tblTextbook;
EXECUTE procUpdateTextbookAct_M('B122', '1', '수정 교재명');
select * from tblTextbook;
EXECUTE procUpdateTextbookAct_M('B122', '2', '수정 출판사');
EXECUTE procUpdateTextbookAct_M('B122', '3', '테스트');
select * from tblTextbook;
rollback;
DROP PROCEDURE procUpdateTextbook_M;
DROP PROCEDURE procUpdateTextbookAct_M;









-- 기초 강의실 정보 수정하기
UPDATE tblClassroom SET name='강의실명 수정' WHERE classroom_seq='강의실코드';
UPDATE tblClassroom SET capacity='강의실정원 수정' WHERE classroom_seq='강의실코드';

    -- 프로시저
    -- 1. 타겟인자 2. 컬럼인자 3. 값인자
    CREATE OR REPLACE PROCEDURE procUpdateClassroom_M(
        pTargetSeq VARCHAR2,
        pTargetColumn VARCHAR2,
        pValue VARCHAR2,
        pResult out number
    )
    IS
    BEGIN
        if pTargetColumn = '1' THEN
            UPDATE tblClassroom SET name=pValue WHERE classroom_seq=pTargetSeq;
            pResult := 1;
        elsif pTargetColumn = '2' THEN
            UPDATE tblClassroom SET capacity=pValue WHERE classroom_seq=pTargetSeq;
            pResult := 2;
        else
            pResult := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 강의실 명 수정
    -- 2:타겟 > 강의실 정원 수정
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
    END procUpdateClassroom_M;



    -- 실행 프로시저
    CREATE OR REPLACE PROCEDURE procUpdateClassroomAct_M(
        pTargetSeq VARCHAR2,
        pTargetColumn VARCHAR2,
        pValue VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procUpdateClassroom_M(pTargetSeq, pTargetColumn, pValue, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('강의실 명이 수정되었습니다.');
        ELSIF vResult = 2 THEN
            dbms_output.put_line('강의실 정원이 수정되었습니다. ');
        ELSIF vResult = -1 THEN
            dbms_output.put_line('1:타겟 > 강의실 명 수정');
            dbms_output.put_line('2:타겟 > 강의실 정원 수정');
            dbms_output.put_line('1, 2의 타겟 컬럼 중 하나를 선택하세요.');
        ELSE
            dbms_output.put_line('알 수 없는 오류');
        END if;
    END procUpdateClassroomAct_M;

-- 기초 강의실 정보 수정 테스트
set serverout on;
EXECUTE procClassroomIstAct_M('강의실9', '20');
select * from tblClassroom;
EXECUTE procUpdateClassroomAct_M('R007', '1', '강의실10');
select * from tblClassroom;
EXECUTE procUpdateClassroomAct_M('R007', '2', '21');
EXECUTE procUpdateClassroomAct_M('R007', '3', '테스트');
select * from tblTextbook;
rollback;
DROP PROCEDURE procUpdateClassroom_M;
DROP PROCEDURE procUpdateClassroomAct_M;












-- *****기초 정보 삭제*****

-- 기초 과정 정보 삭제
DELETE FROM tblCourse WHERE course_seq='과정코드';
DELETE FROM tblCourse WHERE name='과정명';

    -- 프로시저
    -- 1. 타겟컬럼 2. 타겟컬럼의 값
    CREATE OR REPLACE PROCEDURE procCourseDlt_M(
        pTargetColumn VARCHAR2,
        pValue VARCHAR2,
        pResult out number
    )
    IS
    BEGIN
        if pTargetColumn = '1' THEN
            DELETE FROM tblCourse WHERE course_seq=pValue;
            pResult := 1;
        elsif pTargetColumn = '2' THEN
            DELETE FROM tblCourse WHERE name=pValue;
            pResult := 2;
        else
            pResult := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 과정코드로 찾아서 삭제
    -- 2:타겟 > 과정명으로 찾아서 삭제
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
    END procCourseDlt_M;



    -- 실행 프로시저
    CREATE OR REPLACE PROCEDURE procCourseDltAct_M(
        pTargetColumn VARCHAR2,
        pValue VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procCourseDlt_M(pTargetColumn, pValue, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('과정코드가 "'||pValue||'" 레코드가 삭제되었습니다.');
        ELSIF vResult = 2 THEN
            dbms_output.put_line('과정명이 "'||pValue||'" 레코드가 삭제되었습니다.');
        ELSIF vResult = -1 THEN
            dbms_output.put_line('1:타겟 > 과정코드로 찾아서 삭제');
            dbms_output.put_line('2:타겟 > 과정명으로 찾아서 삭제');
            dbms_output.put_line('1, 2의 타겟 컬럼 중 하나를 선택하세요.');
        ELSE
            dbms_output.put_line('알 수 없는 오류');
        END if;
    END procCourseDltAct_M;

-- 기초 과정 정보 삭제 테스트
set serverout on;
EXECUTE procCourseIstAct_M('테스트과정명2', '테스트 과정목표2', '테스트 과정설명2');
select * from tblCourse;
EXECUTE procCourseDltAct_M('1', 'L018');
EXECUTE procCourseDltAct_M('2', '테스트과정명2');
EXECUTE procCourseDltAct_M('R007', '3', '테스트');
select * from tblCourse;
rollback;
DROP PROCEDURE procCourseDlt_M;
DROP PROCEDURE procCourseDltAct_M;









-- 기초 과목 정보 삭제
DELETE FROM tblSubject WHERE subject_seq='과목코드';
DELETE FROM tblSubject WHERE name='과목명';

    -- 프로시저
    -- 1. 타겟컬럼 2. 타겟컬럼의 값
    CREATE OR REPLACE PROCEDURE procSubjectDlt_M(
        pTargetColumn VARCHAR2,
        pValue VARCHAR2,
        pResult out number
    )
    IS
    BEGIN
        if pTargetColumn = '1' THEN
            DELETE FROM tblSubject WHERE subject_seq=pValue;
            pResult := 1;
        elsif pTargetColumn = '2' THEN
            DELETE FROM tblSubject WHERE name=pValue;
            pResult := 2;
        else
            pResult := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 과목코드로 찾아서 삭제
    -- 2:타겟 > 과목명으로 찾아서 삭제
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
    END procSubjectDlt_M;



    -- 실행 프로시저
    CREATE OR REPLACE PROCEDURE procSubjectDltAct_M(
        pTargetColumn VARCHAR2,
        pValue VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procSubjectDlt_M(pTargetColumn, pValue, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('과목코드가 "'||pValue||'" 레코드가 삭제되었습니다.');
        ELSIF vResult = 2 THEN
            dbms_output.put_line('과목명이 "'||pValue||'" 레코드가 삭제되었습니다.');
        ELSIF vResult = -1 THEN
            dbms_output.put_line('1:타겟 > 과목코드로 찾아서 삭제');
            dbms_output.put_line('2:타겟 > 과목명으로 찾아서 삭제');
            dbms_output.put_line('1, 2의 타겟 컬럼 중 하나를 선택하세요.');
        ELSE
            dbms_output.put_line('알 수 없는 오류');
        END if;
    END procSubjectDltAct_M;

-- 기초 과목 정보 삭제 테스트
set serverout on;
EXECUTE procSubjectIstAct_M('테스트과목명', '공통');
select * from tblSubject order by subject_seq desc;
EXECUTE procSubjectDltAct_M('1', 'SUB041');
EXECUTE procSubjectIstAct_M('테스트과목명', '공통');
EXECUTE procSubjectDltAct_M('2', '테스트과목명');
select * from tblSubject order by subject_seq desc;
rollback;
DROP PROCEDURE procSubjectDlt_M;
DROP PROCEDURE procSubjectDltAct_M;









-- 기초 교재 정보 삭제
DELETE FROM tblTextbook WHERE textbook_seq='교재코드';
DELETE FROM tblTextbook WHERE name='교재명';

    -- 프로시저
    -- 1. 타겟컬럼 2. 타겟컬럼의 값
    CREATE OR REPLACE PROCEDURE procTextbookDlt_M(
        pTargetColumn VARCHAR2,
        pValue VARCHAR2,
        pResult out number
    )
    IS
    BEGIN
        if pTargetColumn = '1' THEN
            DELETE FROM tblTextbook WHERE textbook_seq=pValue;
            pResult := 1;
        elsif pTargetColumn = '2' THEN
            DELETE FROM tblTextbook WHERE name=pValue;
            pResult := 2;
        else
            pResult := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 교재코드로 찾아서 삭제
    -- 2:타겟 > 교재명으로 찾아서 삭제
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
    END procTextbookDlt_M;



    -- 실행 프로시저
    CREATE OR REPLACE PROCEDURE procTextbookDltAct_M(
        pTargetColumn VARCHAR2,
        pValue VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procTextbookDlt_M(pTargetColumn, pValue, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('교재코드가 "'||pValue||'" 레코드가 삭제되었습니다.');
        ELSIF vResult = 2 THEN
            dbms_output.put_line('교재명이 "'||pValue||'" 레코드가 삭제되었습니다.');
        ELSIF vResult = -1 THEN
            dbms_output.put_line('1:타겟 > 교재코드로 찾아서 삭제');
            dbms_output.put_line('2:타겟 > 교재명으로 찾아서 삭제');
            dbms_output.put_line('1, 2의 타겟 컬럼 중 하나를 선택하세요.');
        ELSE
            dbms_output.put_line('알 수 없는 오류');
        END if;
    END procTextbookDltAct_M;

-- 기초 교재 정보 삭제 테스트
set serverout on;
EXECUTE procTextbookIstAct_M('테스트 교재명', '테스트 출판사');
select * from tblTextbook order by textbook_seq desc;
EXECUTE procTextbookDltAct_M('1', 'B122');
select * from tblTextbook order by textbook_seq desc;
EXECUTE procTextbookIstAct_M('테스트 교재명', '테스트 출판사');
select * from tblTextbook order by textbook_seq desc;
EXECUTE procTextbookDltAct_M('2', '교재명');
select * from tblTextbook order by textbook_seq desc;
rollback;
DROP PROCEDURE procTextbookIst_M;
DROP PROCEDURE procTextbookIstAct_M;









-- 기초 강의실 정보 삭제
DELETE FROM tblClassroom WHERE classroom_seq='강의실코드';
DELETE FROM tblClassroom WHERE name='강의실명';

    -- 프로시저
    -- 1. 타겟컬럼 2. 타겟컬럼의 값
    CREATE OR REPLACE PROCEDURE procClassroomDlt_M(
        pTargetColumn VARCHAR2,
        pValue VARCHAR2,
        pResult out number
    )
    IS
    BEGIN
        if pTargetColumn = '1' THEN
            DELETE FROM tblClassroom WHERE classroom_seq=pValue;
            pResult := 1;
        elsif pTargetColumn = '2' THEN
            DELETE FROM tblClassroom WHERE name=pValue;
            pResult := 2;
        else
            pResult := -1;
        end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 강의실코드로 찾아서 삭제
    -- 2:타겟 > 강의실명으로 찾아서 삭제
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
    END procClassroomDlt_M;



    -- 실행 프로시저
    CREATE OR REPLACE PROCEDURE procClassroomDltAct_M(
        pTargetColumn VARCHAR2,
        pValue VARCHAR2
    )
    IS
        vResult number;
    BEGIN
        procClassroomDlt_M(pTargetColumn, pValue, vResult);

        if vResult = 1 THEN
            dbms_output.put_line('강의실코드가 "'||pValue||'" 레코드가 삭제되었습니다.');
        ELSIF vResult = 2 THEN
            dbms_output.put_line('강의실명이 "'||pValue||'" 레코드가 삭제되었습니다.');
        ELSIF vResult = -1 THEN
            dbms_output.put_line('1:타겟 > 강의실코드로 찾아서 삭제');
            dbms_output.put_line('2:타겟 > 강의실명으로 찾아서 삭제');
            dbms_output.put_line('1, 2의 타겟 컬럼 중 하나를 선택하세요.');
        ELSE
            dbms_output.put_line('알 수 없는 오류');
        END if;
    END procClassroomDltAct_M;

-- 기초 교재 정보 수정 테스트
set serverout on;
EXECUTE procClassroomIstAct_M('강의실9', '20');
select * from tblClassroom order by Classroom_seq desc;
EXECUTE procClassroomDltAct_M('1', 'R007');
select * from tblClassroom order by Classroom_seq desc;
EXECUTE procClassroomIstAct_M('강의실9', '20');
select * from tblClassroom order by Classroom_seq desc;
EXECUTE procClassroomDltAct_M('2', '강의실9');
select * from tblClassroom order by Classroom_seq desc;
rollback;
DROP PROCEDURE procSubjectDlt_M;
DROP PROCEDURE procSubjectDltAct_M;























