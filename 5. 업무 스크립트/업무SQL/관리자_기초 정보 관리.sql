-- *****기초 정보 입력*****
-- 기초 과정 정보 추가하기
INSERT INTO tblCourse (course_seq, name, goal, detail) VALUES ('L018', '과정명', '과정목표', '과정설명');
-- 기초 과목 정보 추가하기
INSERT INTO tblSubject (subject_seq, name, type) VALUES ('SUB041', '과목명', '과목분류');
-- 기초 교재 정보 추가하기
INSERT INTO tblTextbook (textbook_seq, name, publisher) VALUES ('B122', '교재명', '출판사');
-- 기초 강의실 정보 추가하기
INSERT INTO tblClassroom (classroom_seq, name, capacity) VALUES ('R007', '강의실 명', '강의실 정원');




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
-- 기초 과목 정보 수정하기
UPDATE tblSubject SET name='과목명 수정' WHERE subject_seq='과목코드';
UPDATE tblSubject SET type='과목분류 수정' WHERE subject_seq='과목코드';
-- 기초 교재 정보 수정하기
select * from tblClassroom;
UPDATE tblTextbook SET name='교재명 수정' WHERE textbook_seq='교재코드';
UPDATE tblTextbook SET publisher='출판사 수정' WHERE textbook_seq='교재코드';
-- 기초 강의실 정보 수정하기
UPDATE tblClassroom SET name='강의실명 수정' WHERE classroom_seq='강의실코드';
UPDATE tblClassroom SET capacity='강의실정원 수정' WHERE classroom_seq='강의실코드';




-- *****기초 정보 삭제*****
-- 기초 과정 정보 삭제
DELETE FROM tblCourse WHERE course_seq='과정코드';
DELETE FROM tblCourse WHERE name='과정명';
-- 기초 과목 정보 삭제
DELETE FROM tblSubject WHERE subject_seq='과목코드';
DELETE FROM tblSubject WHERE name='과목명';
-- 기초 교재 정보 삭제
DELETE FROM tblTextbook WHERE textbook_seq='교재코드';
DELETE FROM tblTextbook WHERE name='교재명';
-- 기초 강의실 정보 삭제
DELETE FROM tblClassroom WHERE classroom_seq='강의실코드';
DELETE FROM tblClassroom WHERE name='강의실명';

