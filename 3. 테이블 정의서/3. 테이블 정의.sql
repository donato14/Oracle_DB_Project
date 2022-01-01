--테이블 정의.sql


-- [ 기초 테이블 ]



--기초_과목(정적)
CREATE TABLE tblSubject (
	subject_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(300) NOT NULL,
	type VARCHAR2(10) NOT NULL
);

ALTER TABLE tblSubject ADD CONSTRAINT PK_TBLSUBJECT PRIMARY KEY (
	subject_seq
);

ALTER TABLE tblSubject ADD CONSTRAINT CK_tblSubject_type CHECK (type in (‘공통’, ‘선택’));


--기초_교재
CREATE TABLE tblTextbook (
	textbook_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(300) NOT NULL,
	publisher VARCHAR2(100) NOT NULL
);

ALTER TABLE tblTextbook ADD CONSTRAINT PK_TBLTEXTBOOK PRIMARY KEY (
	textbook_seq
);


--기초_과정(정적)
CREATE TABLE tblCourse (
	course_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(300) NOT NULL,
	goal VARCHAR2(300) NULL,
	detail VARCHAR2(300) NULL
);

ALTER TABLE tblCourse ADD CONSTRAINT PK_TBLCOURSE PRIMARY KEY (
	course_seq
);


--기초_교사
CREATE TABLE tblTeacher (
	teacher_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(15) NOT NULL,
	IDcard_number VARCHAR2 NOT NULL,
	tel VARCHAR2 NULL
);

ALTER TABLE tblTeacher ADD CONSTRAINT PK_TBLTEACHER PRIMARY KEY (
	teacher_seq
);


--기초_강의실
CREATE TABLE tblClassroom (
	classroom_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(20) NOT NULL,
	capacity NUMBER NOT NULL
);

ALTER TABLE tblClassroom ADD CONSTRAINT PK_TBLCLASSROOM PRIMARY KEY (
	classroom_seq
);


--교사 강의 가능 과목
CREATE TABLE tblTeacherSubject (
	subject_seq VARCHAR2(10) NOT NULL,
	teacher_seq VARCHAR2(10) NOT NULL
);

ALTER TABLE tblTeacherSubject ADD CONSTRAINT PK_TBLTEACHERSUBJECT PRIMARY KEY (
	subject_seq,
	teacher_seq
);

ALTER TABLE tblTeacherSubject ADD CONSTRAINT FK_tblSubject_TO_tblTeacherSubject_1 FOREIGN KEY (
	subject_seq
)
REFERENCES tblSubject (
	subject_seq
);

ALTER TABLE tblTeacherSubject ADD CONSTRAINT FK_tblTeacher_TO_tblTeacherSubject_1 FOREIGN KEY (
	teacher_seq
)
REFERENCES tblTeacher (
	teacher_seq
);



--[ 과정, 과목 관련 테이블 ]



--개설과정(동적)
CREATE TABLE tblOpenCourse (
	open_course_seq VARCHAR2(20) NOT NULL,
	course_start_date DATE	NULL,
	course_end_date DATE	NULL,
	reg_open_subject CHAR(1) NOT NULL,
	course_progress VARCHAR2(20)	 NOT NULL,
	classroom_seq VARCHAR2(10) NOT NULL,
	course_seq VARCHAR2(10) NOT NULL
);

ALTER TABLE tblOpenCourse ADD CONSTRAINT PK_TBLOPENCOURSE PRIMARY KEY (
	open_course_seq
);

ALTER TABLE tblOpenCourse ADD CONSTRAINT FK_tblClassroom_TO_tblOpenCourse_1 FOREIGN KEY (
	classroom_seq
)
REFERENCES tblClassroom (
	classroom_seq
);

ALTER TABLE tblOpenCourse ADD CONSTRAINT FK_tblCourse_TO_tblOpenCourse_1 FOREIGN KEY (
	course_seq
)
REFERENCES tblCourse (
	course_seq
);


ALTER TABLE tblOpenCourse ADD CONSTRAINT CK_tblOpenCourse_reg_open_subject CHECK(
	reg_open_subject IN(‘Y’, ‘N’)
);
ALTER TABLE tblOpenCourse ADD CONSTRAINT CK_tblOpenCourse_course_progress CHECK(
	course_progress IN(‘강의예정’, ‘강의중’, ‘강의종료’, ‘폐강’)
);



--수강
CREATE TABLE tblRegister (
	student_seq VARCHAR2(10) NOT NULL,
	open_course_seq VARCHAR2(20) NOT NULL,
	completion_status CHAR(1) NULL,
	completion_date DATE NULL,
	dropout_date DATE NULL,
	evalution_score	NUMBER NULL
);

ALTER TABLE tblRegister ADD CONSTRAINT PK_TBLREGISTER PRIMARY KEY (
	student_seq,
	open_course_seq
);

ALTER TABLE tblRegister ADD CONSTRAINT FK_tblStudent_TO_tblRegister_1 FOREIGN KEY (
	student_seq
)
REFERENCES tblStudent (
	student_seq
);

ALTER TABLE tblRegister ADD CONSTRAINT FK_tblOpenCourse_TO_tblRegister_1 FOREIGN KEY (
	open_course_seq
)
REFERENCES tblOpenCourse (
	open_course_seq
);

ALTER TABLE tblRegister ADD CONSTRAINT CK_tblRegister_completion_status CHECK (
	completion_status in (‘Y’, ‘N’)
);



--개설과목(동적)
CREATE TABLE tblOpenSubject (
	open_subject_seq VARCHAR2(10) NOT NULL,
	subject_seq VARCHAR2(10) NOT NULL,
	teacher_seq VARCHAR2(10) NOT NULL,
	textbook_seq VARCHAR2(10) NOT NULL,
	subject_start_date DATE NOT NULL,
	subject_end_date DATE NOT NULL,
	subject_in_progress VARCHAR2(15) NOT NULL,
	score_check CHAR(1) NOT NULL,
	testfile_check CHAR(1) NOT NULL,
	attendance_distribution NUMBER NULL,
	written_distribution NUMBER NULL,
	practical_distribution NUMBER NULL,
	open_course_seq VARCHAR2(20) NOT NULL
);

ALTER TABLE tblOpenSubject ADD CONSTRAINT PK_TBLOPENSUBJECT PRIMARY KEY (
	open_subject_seq
);

ALTER TABLE tblOpenSubject ADD CONSTRAINT FK_tblSubject_TO_tblOpenSubject_1 FOREIGN KEY (
	subject_seq
)
REFERENCES tblSubject (
	subject_seq
);

ALTER TABLE tblOpenSubject ADD CONSTRAINT FK_tblTeacher_TO_tblOpenSubject_1 FOREIGN KEY (
	teacher_seq
)
REFERENCES tblTeacher (
	teacher_seq
);

ALTER TABLE tblOpenSubject ADD CONSTRAINT FK_tblTextbook_TO_tblOpenSubject_1 FOREIGN KEY (
	textbook_seq
)
REFERENCES tblTextbook (
	textbook_seq
);

ALTER TABLE tblOpenSubject ADD CONSTRAINT FK_tblOpenCourse_TO_tblOpenSubject_1 FOREIGN KEY (
	open_course_seq
)
REFERENCES tblOpenCourse (
	open_course_seq
);

ALTER TABLE tblOpenSubject ADD CONSTRAINT CK_tblOpenSubject_score_check CHECK 
	(score_check in (‘Y’, ‘N’)
);
ALTER TABLE tblOpenSubject ADD CONSTRAINT CK_tblOpenSubject_testfile_check CHECK (
	testfile_check in (‘Y’, ‘N’)
);
ALTER TABLE tblOpenSubject ADD CONSTRAINT CK_tblOpenSubject_subject_progress CHECK (subject_progress in (
	‘강의예정’, ‘강의중’, ‘강의종료’, ‘폐강’)
);



--[ 시험 관련 테이블 ]



--시험
CREATE TABLE tblTest (
	test_seq VARCHAR2(10) NOT NULL,
	test_date DATE NULL,
	type VARCHAR2(10) NOT NULL,
	open_subject_seq VARCHAR2(10) NOT NULL
);

ALTER TABLE tblTest ADD CONSTRAINT PK_TBLTEST PRIMARY KEY (
	test_seq
);

ALTER TABLE tblTest ADD CONSTRAINT FK_tblOpenSubject_TO_tblTest_1 FOREIGN KEY (
	open_subject_seq
)
REFERENCES tblOpenSubject (
	open_subject_seq
);

ALTER TABLE tblTest ADD CONSTRAINT CK_tblTest_type CHECK type in (
	‘필기’, ‘실기’)
);



--시험 결과
CREATE TABLE tblTestResult (
	student_seq VARCHAR2(10) NOT NULL,
	test_seq VARCHAR2(10) NOT NULL,
	score NUMBER NOT NULL,
	open_course_seq VARCHAR2(20) NOT NULL
);

ALTER TABLE tblTestResult ADD CONSTRAINT PK_TBLTESTRESULT PRIMARY KEY (
	student_seq,
	test_seq
);

ALTER TABLE tblTestResult ADD CONSTRAINT FK_tblTest_TO_tblTestResult_1 FOREIGN KEY (
	test_seq
)
REFERENCES tblTest (
	test_seq
);

ALTER TABLE tblTestResult ADD CONSTRAINT FK_tblRegister_TO_tblTestResult_1 FOREIGN KEY (
	open_course_seq,, student_seq

)
REFERENCES tblRegister (
	open_course_seq, student_seq
);

ALTER TABLE tblTestResult ADD CONSTRAINT CK_tblTestResult_score CHECK (
	score >= 0 and score <= 100
);



--성적
CREATE TABLE tblScoreInfo (
	student_seq VARCHAR2(10) NOT NULL,
	opensubject_seq VARCHAR2(10) NOT NULL,
	open_course_seq VARCHAR2(20) NOT NULL,
	attendance_score NUMBER NULL,
	written_score NUMBER NULL,
	practical_score NUMBER NULL,
	subject_score NUMBER NULL
);

ALTER TABLE tblScoreInfo ADD CONSTRAINT PK_TBLSCOREINFO PRIMARY KEY (
	student_seq,
	opensubject_seq
);

ALTER TABLE tblScoreInfo ADD CONSTRAINT FK_tblOpenSubject_TO_tblScoreInfo_1 FOREIGN KEY (
	opensubject_seq
)
REFERENCES tblOpenSubject (
	open_subject_seq
);

ALTER TABLE tblScoreInfo ADD CONSTRAINT FK_tblRegister_TO_tblScoreInfo_1 FOREIGN KEY (
	open_course_seq,, student_seq
)
REFERENCES tblRegister (
	open_course_seq, student_seq
);



--[ 교육생 관련 테이블 ]



--교육생
CREATE TABLE tblStudent (
	student_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(15) NOT NULL,
	IDcard_number	VARCHAR2(10) NOT NULL,
	tel VARCHAR2(15) NOT NULL,
	registration_date DATE NOT NULL
);

ALTER TABLE tblStudent ADD CONSTRAINT PK_TBLSTUDENT PRIMARY KEY (
	student_seq
);


--지원제도 해당 여부
CREATE TABLE tblSupportSystem (
	student_seq VARCHAR2(10) NOT NULL,
	open_course_seq VARCHAR2(20) NOT NULL,
	training_insentive CHAR(1) NOT NULL,
	employee_support CHAR(1) NOT NULL
);

ALTER TABLE tblSupportSystem ADD CONSTRAINT PK_TBLSUPPORTSYSTEM PRIMARY KEY (
	student_seq,
	open_course_seq
);

ALTER TABLE tblSupportSystem ADD CONSTRAINT FK_tblRegister_TO_tblSupportSystem_1 FOREIGN KEY (
	student_seq
)
REFERENCES tblRegister (
	student_seq
);

ALTER TABLE tblSupportSystem ADD CONSTRAINT FK_tblRegister_TO_tblSupportSystem_2 FOREIGN KEY (
	open_course_seq
)
REFERENCES tblRegister (
	open_course_seq
);

ALTER TABLE tblSupportSystem ADD CONSTRAINT CK_tblSupportSystem_training_insentive CHECK(
	training_insentive IN (‘Y’, ‘N’)
);
ALTER TABLE tblSupportSystem ADD CONSTRAINT CK_tblSupportSystem_employee_support CHECK(
	employee_support IN (‘Y’, ‘N’)
);


--자격증
CREATE TABLE tbllicense (
	license_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(100) NOT NULL
);

ALTER TABLE tbllicense ADD CONSTRAINT pk_tbllicense PRIMARY KEY (
	license_seq
);



--교육생 자격증 현황
CREATE TABLE tblStudentLicense (
	student_seq VARCHAR2(10) NOT NULL,
	license_seq VARCHAR2(10) NOT NULL,
	registration_date DATE NOT NULL
);

ALTER TABLE tblStudentLicense ADD CONSTRAINT PK_TBLSTUDENTLICENSE PRIMARY KEY (
	student_seq,
	license_seq
);

ALTER TABLE tblStudentLicense ADD CONSTRAINT FK_tblStudent_TO_tblStudentLicense_1 FOREIGN KEY (
	student_seq
)
REFERENCES tblStudent (
	student_seq
);

ALTER TABLE tblStudentLicense ADD CONSTRAINT FK_tblLicense_TO_tblStudentLicense_1 FOREIGN KEY (
	license_seq
)
REFERENCES tblLicense (
	license_seq
);


--기념품
CREATE TABLE tblGift (
	gift_seq	 VARCHAR2(10)	 NOT NULL,
	name VARCHAR2(300) NOT NULL,
	price NUMBER NOT NULL
);

ALTER TABLE tblGift ADD CONSTRAINT PK_TBLGIFT PRIMARY KEY (
	gift_seq
);


--기념품 수령
CREATE TABLE tblGetGift (
	get_gift_seq VARCHAR2(10) NOT NULL,
	get_date DATE NOT NULL,
	gift_seq	VARCHAR2(10) NOT NULL,
	student_seq VARCHAR2(10) NOT NULL,
	open_course_seq VARCHAR2(20) NOT NULL
);

ALTER TABLE tblGetGift ADD CONSTRAINT PK_TBLGETGIFT PRIMARY KEY (
	get_gift_seq
);


--일일출결
CREATE TABLE tblDayAttendance (
	day_attendance_date DATE NOT NULL,
	time DATE NOT NULL,
	student_seq VARCHAR2(10) NOT NULL,
	open_course_seq VARCHAR2(20) NOT NULL,
	is_attendance VARCHAR2(10) NULL
);

ALTER TABLE tblDayAttendance ADD CONSTRAINT PK_TBLDAYATTENDANCE PRIMARY KEY (
	day_attendance_date,
	time,
	student_seq,
	open_course_seq
);

ALTER TABLE tblDayAttendance ADD CONSTRAINT FK_tblRegister_TO_tblDayAttendance_1 FOREIGN KEY (
	student_seq, open_course_seq
)
REFERENCES tblRegister (
	student_seq, open_course_seq
);

ALTER TABLE tblDayAttendance ADD CONSTRAINT CK_tblDayAttendance_is_attendance CHECK(
	is_attendance IN(‘출근’, ‘퇴근’)
);


--출결
CREATE TABLE tblAttendance (
	attendance_date DATE NOT NULL,
	student_seq VARCHAR2(10) NOT NULL,
	open_course_seq VARCHAR2(20) NOT NULL,
	attendance_type_seq VARCHAR2(10) NOT NULL
);

ALTER TABLE tblAttendance ADD CONSTRAINT PK_TBLATTENDANCE PRIMARY KEY (
	attendance_date,
	student_seq,
	open_course_seq
);

ALTER TABLE tblAttendance ADD CONSTRAINT FK_tblRegister_TO_tblAttendance FOREIGN KEY (
	student_seq, open_course_seq
)
REFERENCES tblRegister (
	student_seq, open_course_seq
);


--근태유형
CREATE TABLE tblAttendanceType (
	attendance_type_seq VARCHAR2(10) NOT NULL,
	attendance_type VARCHAR2(10) NOT NULL
);

ALTER TABLE tblAttendanceType ADD CONSTRAINT PK_TBLATTENDANCETYPE PRIMARY KEY (
	attendance_type_seq
);

ALTER TABLE tblAttendanceType ADD CONSTRAINT CK_tblAttendanceType_attendance_type CHECK (
	attendance_type in (‘정상’, ‘지각’, ’조퇴’, ’외출’, ’병가’, ’기타’)
);



--[ 추가 요구사항 테이블 (구직, 채용) ]



--구인 의뢰 기업
CREATE TABLE tblCompany (
	company_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(200) NOT NULL,
	business_number VARCHAR2(20) NOT NULL,
	postcode NUMBER NOT NULL,
	address	 VARCHAR2(200) NOT NULL,
	tel VARCHAR2(15) NOT NULL
);

ALTER TABLE tblCompany ADD CONSTRAINT PK_TBLCOMPANY PRIMARY KEY (
	company_seq
);


--채용 모집 분야
CREATE TABLE tblJobPosting (
	recruiter_seq VARCHAR2(10) NOT NULL,
	company_seq VARCHAR2(10) NOT NULL,
	work_place VARCHAR2(50) NOT NULL,
	salary NUMBER NOT NULL,
	education_level VARCHAR2(10) NOT NULL,
	employee_number NUMBER NOT NULL,
	start_date DATE	NOT NULL,
	end_date DATE	NOT NULL,
	state VARCHAR2(20) NOT NULL,
	task_seq VARCHAR2(10) NOT NULL
);

ALTER TABLE tblJobPosting ADD CONSTRAINT PK_TBLJOBPOSTING PRIMARY KEY (
	recruiter_seq
);

ALTER TABLE tblJobPosting ADD CONSTRAINT FK_tblCompany_TO_tblJobPosting_1 FOREIGN KEY (
	company_seq
)
REFERENCES tblCompany (
	company_seq
);

ALTER TABLE tblJobPosting ADD CONSTRAINT FK_tblTask_TO_tblJobPosting_1 FOREIGN KEY (
	task_seq
)
REFERENCES tblTask (
	task_seq
);

ALTER TABLE tblJopPosting ADD CONSTRAINT CK_tblJobPosting_state CHECK (
	state IN (‘완료’, ‘진행중’, ‘채용예정’)
);


--채용 담당자
CREATE TABLE tblRecruiter (
	recruiter_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(30) NOT NULL,
	position VARCHAR2(50)	DEFAULT 인사담당자 NULL,
	tel VARCHAR2(15) NOT NULL,
	email VARCHAR2(100) NOT NULL
);

ALTER TABLE tblRecruiter ADD CONSTRAINT PK_TBLRECRUITER PRIMARY KEY (
	recruiter_seq
);

ALTER TABLE tblRecruiter ADD CONSTRAINT FK_tblJobPosting_TO_tblRecruiter_1 FOREIGN KEY (
	recruiter_seq
)
REFERENCES tblJobPosting (
	recruiter_seq
);


--직무
CREATE TABLE tblTask (
	task_seq VARCHAR2(10) NOT NULL,
	name VARCHAR2(100) NOT NULL
);

ALTER TABLE tblTask ADD CONSTRAINT PK_TBLTASK PRIMARY KEY (
	task_seq
);


--구직자
CREATE TABLE tblJobSeeker (
	student_seq VARCHAR2(10) NOT NULL,
	open_course_seq VARCHAR2(20) NOT NULL,
	desired_place VARCHAR2(50) NOT NULL,
	max_salary NUMBER NOT NULL,
	min_salary NUMBER NOT NULL,
	academic VARCHAR2(10) NOT NULL,
	employment_state CHAR(1) NOT NULL,
	employment_date DATE	 NULL,
	recruiter_seq VARCHAR2(10) NOT NULL,
	task_seq VARCHAR2(10) NOT NULL
);

ALTER TABLE tblJobSeeker ADD CONSTRAINT PK_TBLJOBSEEKER PRIMARY KEY (
	student_seq,
	open_course_seq
);

ALTER TABLE tblJobSeeker ADD CONSTRAINT FK_tblRegister_TO_tblJobSeeker_1 FOREIGN KEY (
	student_seq, open_course_seq
)
REFERENCES tblRegister (
	student_seq, open_course_seq
);

ALTER TABLE tblJobSeeker ADD CONSTRAINT FK_tblJobPosting_TO_tblJobSeeker_1 FOREIGN KEY (
	recruiter_seq
)
REFERENCES tblJobPosting (
	recruiter_seq
);

ALTER TABLE tblJobSeeker ADD CONSTRAINT FK_tblTask_TO_tblJobSeeker_1 FOREIGN KEY (
	task_seq
)
REFERENCES tblTask (
	task_seq
);
ALTER TABLE tblJobSeeker ADD CONSTRAINT CK_tblJobSeeker_employment_state CHECK(
	employment_state IN ('Y','N')
);




--[ 관리자 테이블 ]



CREATE TABLE tblManager (
	manager_seq VARCHAR2(10) NOT NULL,
	id VARCHAR2(20) NOT NULL,
	pw VARCHAR2(40) NOT NULL
);

ALTER TABLE tblManager ADD CONSTRAINT PK_TBLMANAGER PRIMARY KEY (
	manager_seq
);
