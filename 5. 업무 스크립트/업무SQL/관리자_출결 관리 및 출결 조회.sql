
-- 출결관리 및 출결조회
/*
- 특정 개설 과정을 선택하는 경우 모든 교육생의 출결을 조회할 수 있어야 한다.
- 출결 현황을 기간별(년, 월, 일)로 조회할 수 있어야 한다.
- 특정(과정, 인원) 출결 현황을 조회할 수 있어야 한다.
- 모든 출결 조회는 근태 상황을 구분할 수 있어야 한다. (정상, 지각, 조퇴, 외출, 병가, 기타)
*/
-- 특정 개설 과정 선택
SELECT DISTINCT d.attendance_date AS "날짜", c.name AS "교육생 이름", e.attendance_type AS "근태 상황"
FROM tblOpenSubject a
INNER JOIN tblRegister b ON a.open_course_seq = b.open_course_seq
INNER JOIN tblStudent c ON b.student_seq = c.student_seq
INNER JOIN tblAttendance d ON a.open_course_seq = d.open_course_seq AND b.student_seq = d.student_seq
INNER JOIN tblAttendanceType e ON d.attendance_type_seq = e.attendance_type_seq
WHERE a.open_course_seq='OL007'--과정코드 입력
ORDER BY d.attendance_date;

-- 출결 현황을 기간별(년, 월, 일)로 조회
SELECT DISTINCT d.attendance_date AS "날짜", c.name AS "교육생 이름", e.attendance_type AS "근태 상황"
FROM tblOpenSubject a
INNER JOIN tblRegister b ON a.open_course_seq = b.open_course_seq
INNER JOIN tblStudent c ON b.student_seq = c.student_seq
INNER JOIN tblAttendance d ON a.open_course_seq = d.open_course_seq AND b.student_seq = d.student_seq
INNER JOIN tblAttendanceType e ON d.attendance_type_seq = e.attendance_type_seq
WHERE a.open_course_seq='OL007' AND d.attendance_date BETWEEN TO_DATE('2021-01-01', 'YYYY-MM-DD') AND TO_DATE('2021-02-01', 'YYYY-MM-DD')--과정코드, 기간 입력
ORDER BY d.attendance_date;

-- 특정(과정, 인원) 출결 현황 조회
SELECT DISTINCT d.attendance_date AS "날짜", c.name AS "교육생 이름", e.attendance_type AS "근태 상황"
FROM tblOpenSubject a
INNER JOIN tblRegister b ON a.open_course_seq = b.open_course_seq
INNER JOIN tblStudent c ON b.student_seq = c.student_seq
INNER JOIN tblAttendance d ON a.open_course_seq = d.open_course_seq AND b.student_seq = d.student_seq
INNER JOIN tblAttendanceType e ON d.attendance_type_seq = e.attendance_type_seq
WHERE a.open_course_seq='OL007' AND c.name='박현문' --과정코드, 이름 입력
ORDER BY d.attendance_date;
