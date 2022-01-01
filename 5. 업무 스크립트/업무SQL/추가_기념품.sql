--기념품정보
INSERT INTO TBLGIFT (GIFT_SEQ, NAME, PRICE) 
VALUES ('GIFT11', '신세계 백화점 상품권', 10000); --기념품 추가
UPDATE TBLGIFT SET NAME = '롯데 백화점 상품권'
WHERE GIFT_SEQ = 'GIFT11'; -- 기념품수정
DELETE FROM TBLGIFT
WHERE GIFT_SEQ = 'GIFT11'; --기념품삭제

select OPEN_COURSE_SEQ as "과정번호", 
REGEXP_REPLACE(LISTAGG(tblgift.name, ',') within group (order by tblgift.name), '([^,]+)(,\1)*(,|$)', '\1\3') as "과정별 증정 기념품" 
from tblGetgift join tblgift
on(tblGetgift.gift_seq = tblgift.gift_seq)
group by tblgetgift.open_course_seq; --교육 과정 별지급한 기념품을 확인

select OPEN_COURSE_SEQ as "과정번호", 
STUDENT_SEQ as "교육생번호", 
REGEXP_REPLACE(LISTAGG(tblgift.name, ',') within group (order by tblgift.name), '([^,]+)(,\1)*(,|$)', '\1\3') as "교육생별 증정 기념품" 
from tblGetgift join tblgift
on(tblGetgift.gift_seq = tblgift.gift_seq)
group by tblgetgift.OPEN_COURSE_SEQ, tblgetgift.STUDENT_SEQ;--수강별 지급받은 기념품 확인
