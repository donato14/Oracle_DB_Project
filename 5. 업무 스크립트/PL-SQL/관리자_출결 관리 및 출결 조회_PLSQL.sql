--요약───────────────────────────────────────────────────────────────────
-- procAttendanceManagementAct('과정코드', '0', '0')                  > 전체검색
-- procAttendanceManagementAct('과정코드', '이름', '0')                > 이름검색
-- procAttendanceManagementAct('과정코드', '시작날짜', '종료날짜')       > 날짜검색
-- ex 전체검색
EXECUTE procAttendanceManagementAct('OL007', '0', '0');
-- ex 이름검색
EXECUTE procAttendanceManagementAct('OL007', '이시조', '0');
-- ex 날짜검색
EXECUTE procAttendanceManagementAct('OL007', '2021-01-01', '2021-01-31');
--──────────────────────────────────────────────────────────────────────
-- 출결관리 및 출결조회
/*
- 특정 개설 과정을 선택하는 경우 모든 교육생의 출결을 조회할 수 있어야 한다.
- 출결 현황을 기간별(년, 월, 일)로 조회할 수 있어야 한다.
- 특정(과정, 인원) 출결 현황을 조회할 수 있어야 한다.
- 모든 출결 조회는 근태 상황을 구분할 수 있어야 한다. (정상, 지각, 조퇴, 외출, 병가, 기타)
*/

-- 포멧용 뷰
CREATE OR REPLACE VIEW vwAttendanceFormat as
SELECT DISTINCT d.attendance_date AS "날짜", c.name AS "교육생 이름", e.attendance_type AS "근태 상황"
FROM tblOpenSubject a
INNER JOIN tblRegister b ON a.open_course_seq = b.open_course_seq
INNER JOIN tblStudent c ON b.student_seq = c.student_seq
INNER JOIN tblAttendance d ON a.open_course_seq = d.open_course_seq AND b.student_seq = d.student_seq
INNER JOIN tblAttendanceType e ON d.attendance_type_seq = e.attendance_type_seq
WHERE a.open_course_seq='OL007'--과정코드 입력
ORDER BY d.attendance_date;



-- 프로시저
create or replace procedure procAttendanceManagement(
    pOpen_course_seq varchar2,
    pValue1 VARCHAR2,
    pValue2 VARCHAR2,
    presult out sys_refcursor
)
is
begin
    IF pValue1='0' AND pValue2='0' THEN
        open presult for
            SELECT DISTINCT d.attendance_date AS "날짜", c.name AS "교육생 이름", e.attendance_type AS "근태 상황"
            FROM tblOpenSubject a
            INNER JOIN tblRegister b ON a.open_course_seq = b.open_course_seq
            INNER JOIN tblStudent c ON b.student_seq = c.student_seq
            INNER JOIN tblAttendance d ON a.open_course_seq = d.open_course_seq AND b.student_seq = d.student_seq
            INNER JOIN tblAttendanceType e ON d.attendance_type_seq = e.attendance_type_seq
            WHERE a.open_course_seq=pOpen_course_seq    -- 과정코드만 입력
            ORDER BY d.attendance_date;
    ELSIF pValue2='0' THEN
        open presult for
            SELECT DISTINCT d.attendance_date AS "날짜", c.name AS "교육생 이름", e.attendance_type AS "근태 상황"
            FROM tblOpenSubject a
            INNER JOIN tblRegister b ON a.open_course_seq = b.open_course_seq
            INNER JOIN tblStudent c ON b.student_seq = c.student_seq
            INNER JOIN tblAttendance d ON a.open_course_seq = d.open_course_seq AND b.student_seq = d.student_seq
            INNER JOIN tblAttendanceType e ON d.attendance_type_seq = e.attendance_type_seq
            WHERE a.open_course_seq=pOpen_course_seq AND c.name=pValue1 --과정코드, 이름 입력
            ORDER BY d.attendance_date;
    ELSE
        open presult for
                SELECT DISTINCT d.attendance_date AS "날짜", c.name AS "교육생 이름", e.attendance_type AS "근태 상황"
                FROM tblOpenSubject a
                INNER JOIN tblRegister b ON a.open_course_seq = b.open_course_seq
                INNER JOIN tblStudent c ON b.student_seq = c.student_seq
                INNER JOIN tblAttendance d ON a.open_course_seq = d.open_course_seq AND b.student_seq = d.student_seq
                INNER JOIN tblAttendanceType e ON d.attendance_type_seq = e.attendance_type_seq
                WHERE a.open_course_seq=pOpen_course_seq AND d.attendance_date BETWEEN TO_DATE(pValue1, 'YYYY-MM-DD') AND TO_DATE(pValue2, 'YYYY-MM-DD')--과정코드, 기간 입력
                ORDER BY d.attendance_date; --과정코드, 날짜 입력
    END IF;
end procAttendanceManagement;




-- 실행 프로시저
create or replace procedure procAttendanceManagementAct(
    pOpen_course_seq varchar2,
    pValue1 VARCHAR2,
    pValue2 VARCHAR2
)
is
    vresult sys_refcursor;
    vrow vwAttendanceFormat%rowtype;
begin
    dbms_output.put_line('날짜       교육생 이름       근태 상황');
    dbms_output.put_line('───────────────────────────────────────────────────────────────────');

    IF pValue1='0' AND pValue2='0' THEN -- 과정코드만 입력
        procAttendanceManagement(pOpen_course_seq, pValue1, pValue2, vresult);
        loop
            fetch vresult into vrow;
            exit when vresult%notfound;
                DBMS_OUTPUT.PUT_LINE(vrow."날짜" || '       ' || vrow."교육생 이름" || '       ' || vrow."근태 상황");
        end loop;
        dbms_output.put_line('과정코드 '||pOpen_course_seq||'의 출결을 출력했습니다.');
    ELSIF pValue2='0' THEN --과정코드, 이름 입력
        procAttendanceManagement(pOpen_course_seq, pValue1, pValue2, vresult);
        loop
            fetch vresult into vrow;
            exit when vresult%notfound;
                DBMS_OUTPUT.PUT_LINE(vrow."날짜" || '       ' || vrow."교육생 이름" || '       ' || vrow."근태 상황");
        end loop;
        dbms_output.put_line('과정코드 '||pOpen_course_seq||'의 '||pValue1||'교육생 출결을 출력했습니다.');
    ELSE --과정코드, 날짜 입력
        procAttendanceManagement(pOpen_course_seq, pValue1, pValue2, vresult);
        loop
            fetch vresult into vrow;
            exit when vresult%notfound;
                DBMS_OUTPUT.PUT_LINE(vrow."날짜" || '       ' || vrow."교육생 이름" || '       ' || vrow."근태 상황");
        end loop;
        dbms_output.put_line('과정코드 '||pOpen_course_seq||'의 '||pValue1||'부터 '||pValue2||'사이의 출결을 출력했습니다.');
    END IF;
end procAttendanceManagementAct;