--관리자 - 취업연계
INSERT INTO TBLJOBSEEKER (STUDENT_SEQ, OPEN_COURSE_SEQ, DESIRED_PLACE, MIN_SALARY, MAX_SALARY, ACADEMIC, EMPLOYMENT_STATE, EMPLOYMENT_DATE, RECRUITER_SEQ, TASK_SEQ) 
VALUES ((SELECT tblregister.student_seq FROM tblRegister WHERE STUDENT_SEQ = 'S0381' AND open_course_seq = 'OL001'),
(SELECT tblregister.open_course_seq FROM tblRegister WHERE STUDENT_SEQ = 'S0381' AND open_course_seq = 'OL001'),
'부산광역시', 2000, 3000, '고졸', 'N', NULL,
(select tbljobposting.RECRUITER_SEQ from TBLJOBPOSTING WHERE tbljobposting.salary >= 2000 AND tbljobposting.EDUCATION_LEVEL LIKE '고졸' AND work_place LIKE '%부산광역시%' AND rownum = 1),
(select tbltask.task_seq from tblTask where tbltask.name LIKE '웹개발')); -- 교육생의 취업지원

INSERT INTO TBLLICENSE (LICENSE_SEQ, NAME) 
VALUES ('SP111', 'ITQ'); --자격증 등록
UPDATE TBLLICENSE SET NAME = 'ITQA'
WHERE LICENSE_SEQ = 'SP111'; --자격증 정보수정
DELETE FROM TBLLICENSE
WHERE LICENSE_SEQ = 'SP111'; --자격증삭제

INSERT INTO TBLSTUDENTLICENSE (STUDENT_SEQ, LICENSE_SEQ, REGISTRATION_DATE) 
VALUES ((SELECT tblregister.student_seq FROM tblRegister WHERE STUDENT_SEQ = 'S0381' AND open_course_seq = 'OL001'), 
(SELECT LICENSE_SEQ from tblLicense where name = '네트워크관리사'), to_date('12/01/2019', 'MM/DD/YYYY')); --교육생자격증입력

INSERT INTO TBLCOMPANY (COMPANY_SEQ, NAME, BUSINESS_NUMBER, POSTCODE, ADDRESS, TEL) 
VALUES ('COM0051', '네오위즈', '229-12-76696', 32624, '경기도 남양주시 오장로1길 6', '031-428-3246');  --기업등록

INSERT INTO TBLJOBPOSTING (RECRUITER_SEQ, COMPANY_SEQ, WORK_PLACE, SALARY, EDUCATION_LEVEL, EMPLOYEE_NUMBER, START_DATE, END_DATE, STATE, TASK_SEQ) 
VALUES ('RE0061',
(select tblcompany.company_seq from tblCompany where tblcompany.name LIKE '네오위즈'),
(select regexp_substr((select tblcompany.address from tblcompany where tblcompany.name like '네오위즈'),'[^ ]+ \w+',1) from dual),
2600, '무관', 8, to_date('2022-03-01', 'YYYY-MM-DD'), to_date('2022-11-26', 'YYYY-MM-DD'), '채용예정',
(select tbltask.task_seq from tblTask where tbltask.name LIKE '웹개발'));  --기업의 구인의뢰 등록

INSERT INTO TBLRECRUITER (RECRUITER_SEQ, NAME, POSITION, TEL, EMAIL) 
VALUES ('RE0061', '김현규', '대리', '010-3389-2084', 'srhkras@gmail.com'); --기업의 채용담당자 등록
UPDATE TBLRECRUITER SET POSITION = '과장'
WHERE RECRUITER_SEQ = 'RE0061'; --기업의 채용담당자 수정

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
where WORK_PLACE like concat(concat('%',(select desired_place from TBLJOBSEEKER where student_seq = 'S0250' and open_course_seq = 'OL007')),'%')
and SALARY >= (select min_salary from TBLJOBSEEKER where student_seq = 'S0250' and open_course_seq = 'OL007')
and TO_CHAR(SYSDATE, 'YYYY-MM-DD') >= TO_CHAR(START_DATE, 'YYYY-MM-DD') 
and TO_CHAR(SYSDATE, 'YYYY-MM-DD') <= TO_CHAR(END_DATE, 'YYYY-MM-DD') 
and TBLTASK.name = '웹개발'; --수료생- 구직공고 찾기

select TBLJOBSEEKER.student_seq as "교육생번호",
TBLJOBSEEKER.open_course_seq as "개강과정번호",
TBLJOBSEEKER.desired_place as "희망근무지",
TBLJOBSEEKER.min_salary as "희망최저연봉",
tbltask.name as "희망직무명"
from TBLJOBSEEKER join tbltask
on(TBLJOBSEEKER.task_seq = tbltask.task_seq)
where TBLJOBSEEKER.desired_place like concat(concat('%',REGEXP_SUBSTR((select work_place from TBLJOBPOSTING where recruiter_seq= 'RE0059'),'\w+',1,1)),'%')
and min_salary <= (select salary from TBLJOBPOSTING where recruiter_seq= 'RE0059')
and TBLJOBSEEKER.TASK_SEQ = (select TASK_SEQ from TBLJOBPOSTING where recruiter_seq= 'RE0059'); --기업 - 요건에 맞는 수료생찾기

