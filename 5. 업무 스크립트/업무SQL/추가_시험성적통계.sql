--시험점수
select opensubject_seq as "과목번호", 
round(avg(SUBJECT_SCORE),1) as "과목평균점수"
from tblScoreInfo 
where SUBJECT_SCORE is not null
group by opensubject_seq
order by avg(SUBJECT_SCORE) desc;--각과목별 평균점수

select tblScoreInfo.student_seq as "교육생번호", 
tblScoreInfo.open_course_seq as "과정번호",
round(avg(SUBJECT_SCORE),0) as "과정평점"
from tblScoreInfo join tblRegister
on(tblScoreInfo.student_seq = tblRegister.student_seq and tblScoreInfo.open_course_seq = tblRegister.open_course_seq)
where tblRegister.completion_status = 'Y'
group by tblScoreInfo.student_seq, tblScoreInfo.open_course_seq;--수료생의 과정 최종평점

select open_course_seq as "과정번호",
round(avg(SUBJECT_SCORE),0) as "과정평균점수",
max(SUBJECT_SCORE) as "최고점수",
min(SUBJECT_SCORE) as "최저점수"
from tblScoreInfo
group by open_course_seq; --각 과정 교육생들의 평균 점수, 최고 점수, 최저 점수를 조회

UPDATE tblRegister SET evalution_score = 
(select round(avg(SUBJECT_SCORE),0) from tblScoreInfo WHERE STUDENT_SEQ = 'S0354' and OPEN_COURSE_SEQ = 'OL007')
where tblRegister.STUDENT_SEQ = 'S0354' and tblRegister.OPEN_COURSE_SEQ = 'OL007'; --교육생 점수입력
