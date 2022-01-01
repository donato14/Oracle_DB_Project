--각 과정 교육생들의 평균 점수, 최고 점수, 최저 점수를 조회
select open_course_seq as "과정번호",
round(avg(SUBJECT_SCORE),0) as "과정평균점수",
max(SUBJECT_SCORE) as "최고점수",
min(SUBJECT_SCORE) as "최저점수"
from tblScoreInfo
group by open_course_seq; 

--각과목별 평균점수
select opensubject_seq as "과목번호", 
round(avg(SUBJECT_SCORE),1) as "과목평균점수"
from tblScoreInfo 
where SUBJECT_SCORE is not null
group by opensubject_seq
order by avg(SUBJECT_SCORE) desc;

--취업율
exec procEmploymentRate_A;

--수료율
exec procCompletionRate_A;

--채용공고정보입력 -구직자찾기
VAR SelectJOBSEEKER_cursor REFCURSOR
exec procSelectJOBSEEKER_A('RE0059',:SelectJOBSEEKER_cursor)
print SelectJOBSEEKER_cursor

--교육생 정보입력 -기업찾기
VAR Selectcompany_cursor REFCURSOR
exec procSelectcompany_A('S0250','OL007',:Selectcompany_cursor)
print Selectcompany_cursor

--평가점수입력
exec procUpdateEvalScore_A