--요약───────────────────────────────────────────────────────────────────
-- ① 로그인 기능 프로시저
EXECUTE procLogin_All('아이디(이름)','비밀번호','교사or학생or관리자');
-- ex) 교사 로그인하기
EXECUTE procLogin_All('이윤후','2482932','교사');
-- ex) 학생 로그인하기
EXECUTE procLogin_All('정하하','2654210','학생');
-- ex) 관리자 로그인하기
EXECUTE procLogin_All('qkcu5302','adlj8683','관리자');

-- ② 교사 등록하기
EXECUTE procTeacherIstAct_M('이름', '주민번호 뒷자리', '연락처');
-- ex
EXECUTE procTeacherIstAct_M('김연중', '1111111', '010-1234-5678');

-- ③ 교사 정보 조회하기
SELECT teacher_seq as "강사코드", name as "이름", idcard_number as "주민번호 뒷자리", tel as "연락처" FROM tblTeacher;

-- ④ 교사 정보 수정하기
EXECUTE procUpdateTeacherAct_M('바꿀 타겟 시퀀스', '1 or 2 or 3', '값');
-- ex) 이름 바꾸기
EXECUTE procUpdateTeacherAct_M('T011', '1', '이연중');
-- ex) 주민번호 뒷자리 바꾸기
EXECUTE procUpdateTeacherAct_M('T011', '2', '1234567');
-- ex) 연락처 바꾸기
EXECUTE procUpdateTeacherAct_M('T011', '3', '010-0000-0000');

-- ⑤ 교사 정보 삭제하기
EXECUTE procTeacherDltAct_M('1 or 2', '목표값');
-- ex) 시퀀스로 검색 후 삭제하기
EXECUTE procTeacherDltAct_M('1', 'T011');
-- ex) 이름으로 검색 후 삭제하기
EXECUTE procTeacherDltAct_M('2', '김연중');

-- ⑥ 전체 교사 목록 출력하기 (강의 가능 과목까지 전부)
SELECT * FROM vwAllTeacher;
-- ⑦ 단일 교사 정보 출력하기
SELECT
    b.name AS "교사명",
    c.name AS "과목명",
    a.subject_start_date AS "과목시작날짜",
    a.subject_end_date AS "과목종료날짜",
    f.name AS "과정명",
    d.course_start_date AS "과정시작일",
    d.course_end_date AS "과정종료일",
    g.name AS "교재명", e.name AS "강의실",
    d.course_progress AS "강의진행여부"
FROM tblOpenSubject a
    INNER JOIN tblTeacher b ON a.teacher_seq=b.teacher_seq
    INNER JOIN tblSubject c ON a.subject_seq=c.subject_seq
    INNER JOIN tblOpenCourse d ON a.open_course_seq=d.open_course_seq
    INNER JOIN tblClassroom e ON d.classroom_seq=e.classroom_seq
    INNER JOIN tblcourse f ON d.course_seq=f.course_seq
    INNER JOIN tblTextbook g ON a.textbook_seq=g.textbook_seq
        WHERE b.teacher_seq='T001';--교사코드 입력

--───────────────────────────────────────────────────────────────────




-- 1. 로그인 기능 프로시저
-- 교사 로그인하기
SELECT COUNT(*) FROM tblTeacher WHERE name='이윤후' AND idcard_number='2482932';
-- 학생 로그인하기
SELECT COUNT(*) FROM tblstudent WHERE name='정하하' AND idcard_number='2654210';
-- 관리자 로그인하기
SELECT COUNT(*) FROM tblmanager WHERE id='qkcu5302' AND pw='adlj8683';

-- 프로시저
CREATE OR REPLACE PROCEDURE procLogin_All(
    pId VARCHAR2,
    pPw VARCHAR2,
    pType VARCHAR2
)
IS
    loginValid NUMBER;
    name VARCHAR(30);
BEGIN
    loginValid:=0;

    IF pType='학생' THEN
        SELECT COUNT(*) INTO loginValid FROM tblstudent WHERE name=pId AND idcard_number=pPw;
        IF loginValid=1 THEN
            dbms_output.put_line(pType||' 로그인에 성공하였습니다.');
            dbms_output.put_line('안녕하세요. '||pId||'님');
        ELSE
            dbms_output.put_line('로그인에 실패하였습니다.');
            dbms_output.put_line('아이디와 비밀번호를 확인하세요.');
        END IF;

    ELSIF pType='교사' THEN
        SELECT COUNT(*) INTO loginValid FROM tblTeacher WHERE name=pId AND idcard_number=pPw;
        IF loginValid=1 THEN
            dbms_output.put_line(pType||' 로그인에 성공하였습니다.');
            dbms_output.put_line('안녕하세요. '||pId||'님');
        ELSE
            dbms_output.put_line('로그인에 실패하였습니다.');
            dbms_output.put_line('아이디와 비밀번호를 확인하세요.');
        END IF;
    ELSIF pType='관리자' THEN
        SELECT COUNT(*) INTO loginValid FROM tblmanager WHERE id=pId AND pw=pPw;
        IF loginValid=1 THEN
            dbms_output.put_line(pType||' 로그인에 성공하였습니다.');
            dbms_output.put_line('안녕하세요. '||pId||'님');
        ELSE
            dbms_output.put_line('로그인에 실패하였습니다.');
            dbms_output.put_line('아이디와 비밀번호를 확인하세요.');
        END IF;
    ELSE
        dbms_output.put_line('로그인 유형 "학생", "교사", "관리자" 중 하나를 골라 세 번째 값에 입력하시오.');
    END IF;
END procLogin_All;

-- 로그인 기능 테스트
-- 교사 로그인하기
SELECT COUNT(*) FROM tblTeacher WHERE name='이윤후' AND idcard_number='2482932';
EXECUTE procLogin_All('이윤후','2482932','교사');
-- 학생 로그인하기
SELECT COUNT(*) FROM tblstudent WHERE name='정하하' AND idcard_number='2654210';
EXECUTE procLogin_All('정하하','2654210','학생');
-- 관리자 로그인하기
SELECT COUNT(*) FROM tblmanager WHERE id='qkcu5302' AND pw='adlj8683';
EXECUTE procLogin_All('qkcu5302','adlj8683','관리자');







-- 2. 교사 정보 입력하기
INSERT INTO tblteacher (teacher_seq, name, idcard_number, tel) VALUES ('T011', '이름', '주민번호 뒷자리', '연락처');
SELECT CONCAT('T', lpad(MAX(to_number(substr(teacher_seq, 2)))+1, 3, '0')) FROM tblTeacher;

-- 프로시저
CREATE OR REPLACE PROCEDURE procTeacherIst_M(
    pName VARCHAR2,
    pIdcard_number VARCHAR2,
    pTel VARCHAR2,
    pResult out number
)
IS
    pSeq VARCHAR2(10);
BEGIN
    SELECT CONCAT('T', lpad(MAX(to_number(substr(teacher_seq, 2)))+1, 3, '0')) INTO pSeq FROM tblTeacher;
    INSERT INTO tblteacher (teacher_seq, name, idcard_number, tel)
    VALUES (pSeq, pName, pIdcard_number, pTel);
    pResult := 1;
exception
    when others then
        pResult := 0;
END procTeacherIst_M;

-- 실행 프로시저
create or replace PROCEDURE procTeacherIstAct_M(
    pName VARCHAR2,
    pIdcard_number VARCHAR2,
    pTel VARCHAR2
)
IS
    vResult number;
BEGIN
    procTeacherIst_M(pName, pIdcard_number, pTel, vResult);

    if vResult = 1 then
        dbms_output.put_line('교사 정보 추가 성공');
    else
        dbms_output.put_line('교사 정보 추가 실패');
    end if;
END procTeacherIstAct_M;

-- 테스트
EXECUTE procTeacherIstAct_M('김연중', '1111111', '010-1234-5678');
rollback;
SELECT teacher_seq as "강사코드", name as "이름", idcard_number as "주민번호 뒷자리", tel as "연락처" FROM tblTeacher;






-- 3. 교사 정보 조회하기
SELECT teacher_seq as "강사코드", name as "이름", idcard_number as "주민번호 뒷자리", tel as "연락처" FROM tblTeacher;

-- 4. 교사 정보 수정하기
UPDATE tblTeacher SET name='이름 수정' WHERE teacher_seq='강사코드';
UPDATE tblTeacher SET idcard_number='주민번호 뒷자리 수정' WHERE teacher_seq='강사코드';
UPDATE tblTeacher SET tel='연락처 수정' WHERE teacher_seq='강사코드';

-- 프로시저
CREATE OR REPLACE PROCEDURE procUpdateTeacher_M(
    pTargetSeq VARCHAR2,
    pTargetColumn VARCHAR2,
    pValue VARCHAR2,
    pResult out number
)
IS
BEGIN
    IF pTargetColumn='1' THEN
        UPDATE tblTeacher SET name=pValue WHERE teacher_seq=pTargetSeq;
        pResult:=1;
    elsif pTargetColumn = '2' THEN
        UPDATE tblTeacher SET idcard_number=pValue WHERE teacher_seq=pTargetSeq;
        pResult:=2;
    elsif pTargetColumn = '3' THEN
        UPDATE tblTeacher SET tel=pValue WHERE teacher_seq=pTargetSeq;
        pResult:=3;
    else
        pResult := -1;
    end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 이름 수정
    -- 2:타겟 > 주민번호 뒷자리 수정
    -- 3:타겟 > 연락처 수정
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
END procUpdateTeacher_M;

-- 실행 프로시저
CREATE OR REPLACE PROCEDURE procUpdateTeacherAct_M(
    pTargetSeq VARCHAR2,
    pTargetColumn VARCHAR2,
    pValue VARCHAR2
)
IS
    vResult number;
BEGIN
    procUpdateTeacher_M(pTargetSeq, pTargetColumn, pValue, vResult);
    if vResult = 1 THEN
        dbms_output.put_line('이름이 수정되었습니다.');
    ELSIF vResult = 2 THEN
        dbms_output.put_line('주민번호 뒷자리가 수정되었습니다. ');
    ELSIF vResult = 3 THEN
        dbms_output.put_line('연락처가 수정되었습니다. ');
    ELSIF vResult = -1 THEN
        dbms_output.put_line('1:타겟 > 이름 수정');
        dbms_output.put_line('2:타겟 > 주민번호 뒷자리 수정');
        dbms_output.put_line('2:타겟 > 연락처 수정');
        dbms_output.put_line('1, 2, 3의 타겟 컬럼 중 하나를 선택하세요.');
    ELSE
        dbms_output.put_line('알 수 없는 오류');
    END if;
END procUpdateTeacherAct_M;

-- 테스트
EXECUTE procTeacherIstAct_M('김연중', '1111111', '010-1234-5678');
SELECT * FROM tblTeacher;
EXECUTE procUpdateTeacherAct_M('T011', '1', '이연중');
SELECT * FROM tblTeacher;
EXECUTE procUpdateTeacherAct_M('T011', '2', '1234567');
SELECT * FROM tblTeacher;
EXECUTE procUpdateTeacherAct_M('T011', '3', '010-0000-0000');
SELECT * FROM tblTeacher;
rollback;








-- 5. 교사 정보 삭제하기
DELETE FROM tblTeacher WHERE teacher_seq='강사코드';
DELETE FROM tblTeacher WHERE name='이름';


-- 프로시저
CREATE OR REPLACE PROCEDURE procTeacherDlt_M(
    pTargetColumn VARCHAR2,
    pValue VARCHAR2,
    pResult out number
)
IS
BEGIN
   if pTargetColumn = '1' THEN
        DELETE FROM tblTeacher WHERE teacher_seq=pValue;
        pResult := 1;
    elsif pTargetColumn = '2' THEN
        DELETE FROM tblTeacher WHERE name=pValue;
        pResult := 2;
    else
        pResult := -1;
    end if;
    EXCEPTION
        WHEN OTHERS THEN
            pResult := 0;
    -- 1:타겟 > 교사코드로 찾아서 삭제
    -- 2:타겟 > 이름으로 찾아서 삭제
    -- -1: 1~3 외에 다른 값을 입력 (오류)
    -- 0: -1오류를 제외한 알 수 없는 오류
END procTeacherDlt_M;

-- 실행 프로시저
create or replace PROCEDURE procTeacherDltAct_M(
    pTargetColumn VARCHAR2,
    pValue VARCHAR2
)
IS
    vResult number;
BEGIN
    procTeacherDlt_M(pTargetColumn, pValue, vResult);

    if vResult = 1 THEN
        dbms_output.put_line('교사코드 "'||pValue||'" 레코드가 삭제되었습니다.');
    ELSIF vResult = 2 THEN
        dbms_output.put_line('교사이름 "'||pValue||'" 레코드가 삭제되었습니다.');
    ELSIF vResult = -1 THEN
        dbms_output.put_line('1:타겟 > 교사코드로 찾아서 삭제');
        dbms_output.put_line('2:타겟 > 교사이름으로 찾아서 삭제');
        dbms_output.put_line('1, 2의 타겟 컬럼 중 하나를 선택하세요.');
    ELSE
        dbms_output.put_line('알 수 없는 오류');
    END if;
END procTeacherDltAct_M;

-- 테스트
EXECUTE procTeacherIstAct_M('김연중', '1111111', '010-1234-5678');
EXECUTE procTeacherDltAct_M('1', 'T011');
EXECUTE procTeacherDltAct_M('2', '김연중');
select * from tblTeacher;






-- 6. 전체 교사 목록 출력하기
SELECT * FROM vwAllTeacher;

create or replace view vwAllTeacher
as
SELECT a.teacher_seq AS "강사코드", a.name AS "이름", a.idcard_number AS "주민번호 뒷자리", a.tel AS "연락처",
LISTAGG(c.name, ',') AS "강의 가능 과목"
FROM tblteacher a
    INNER JOIN tblteachersubject b
    ON b.teacher_seq = a.teacher_seq
    INNER JOIN tblSubject c
    ON b.subject_seq = c.subject_seq
        GROUP BY a.teacher_seq, a.name, a.idcard_number, a.tel;




-- 7. 단일 교사 정보 출력하기
SELECT
    b.name AS "교사명",
    c.name AS "과목명",
    a.subject_start_date AS "과목시작날짜",
    a.subject_end_date AS "과목종료날짜",
    f.name AS "과정명",
    d.course_start_date AS "과정시작일",
    d.course_end_date AS "과정종료일",
    g.name AS "교재명", e.name AS "강의실",
    d.course_progress AS "강의진행여부"
FROM tblOpenSubject a
    INNER JOIN tblTeacher b ON a.teacher_seq=b.teacher_seq
    INNER JOIN tblSubject c ON a.subject_seq=c.subject_seq
    INNER JOIN tblOpenCourse d ON a.open_course_seq=d.open_course_seq
    INNER JOIN tblClassroom e ON d.classroom_seq=e.classroom_seq
    INNER JOIN tblcourse f ON d.course_seq=f.course_seq
    INNER JOIN tblTextbook g ON a.textbook_seq=g.textbook_seq
        WHERE b.teacher_seq='T001';--교사코드 입력




















































