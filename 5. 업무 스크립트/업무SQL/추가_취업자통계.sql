--취업자 통계
select 
TBLJOBSEEKER.student_seq as "교육생번호",
TBLJOBSEEKER.OPEN_COURSE_SEQ as "개강과정번호",
TBLJOBSEEKER.employment_date as "취업날짜",
tblCompany.name as "취업기업명"
from TBLJOBSEEKER join tblJobPosting
on(TBLJOBSEEKER.recruiter_seq = tblJobPosting.recruiter_seq)
join tblCompany
on(tblJobPosting.company_seq = tblCompany.company_seq)
WHERE TBLJOBSEEKER.employment_state = 'Y'; -- 취업연계된 구직자

select count(*) as 취업자수
from TBLJOBSEEKER
WHERE employment_state = 'Y'; -- 취업자수

select STUDENT_SEQ as "취업자번호", 
    OPEN_COURSE_SEQ as "과정번호",
    avg(SALARY) as "평균급여" 
from TBLJOBSEEKER join TBLJOBPOSTING
on(TBLJOBSEEKER.RECRUITER_SEQ = TBLJOBPOSTING.RECRUITER_SEQ)
WHERE employment_state = 'Y'
GROUP by rollup(OPEN_COURSE_SEQ, STUDENT_SEQ);  --취업자 평균급여

select tblJobSeeker.OPEN_COURSE_SEQ as "과정번호", 
REGEXP_REPLACE(LISTAGG(tblCompany.name, ',') within group (order by tblCompany.name), '([^,]+)(,\1)*(,|$)', '\1\3') as "취업기업"
from TBLJOBSEEKER join TBLJOBPOSTING
on(TBLJOBSEEKER.RECRUITER_SEQ = TBLJOBPOSTING.RECRUITER_SEQ) 
join tblCompany on(TBLJOBPOSTING.company_seq = tblCompany.company_seq)
WHERE employment_state = 'Y'
group by tblJobSeeker.OPEN_COURSE_SEQ; --과정별 취업기업