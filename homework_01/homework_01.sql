CREATE TABLE student(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	date_of_birth DATE,
	enrolled_date DATE,
	gender VARCHAR(10),
	naational_id_number INTEGER
);
CREATE TABLE teacher(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	date_of_birth DATE,
	academic_rank VARCHAR(20),
	hire_date DATE	
);
CREATE TABLE grade_details(
	id SERIAL PRIMARY KEY,
	grade_id INTEGER,
	achievement_type_id INTEGER,
	achievement_points INTEGER,
	achievement_mac_points INTEGER,
	achievement_date DATE
);
CREATE TABLE course(
	id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	credit INTEGER,
	academic_year INTEGER,
	semester VARCHAR(10)
);
CREATE TABLE grade(
	id SERIAL PRIMARY KEY,
	student_id INTEGER REFERENCES student(id),
	course_id INTEGER REFERENCES course(id),
	teacher_id INTEGER REFERENCES teacher(id),
	grade SMALLINT,
	comment_ VARCHAR(100),
	created_date DATE
);
CREATE TABLE achievement_type(
	id SERIAL PRIMARY KEY,
	name VARCHAR(20),
	description VARCHAR(100),
	participation_rate VARCHAR(50)
);

INSERT INTO student 
VALUES (1, 'Jon', 'Doe', '20-05-1999', '21-12-2007', 'Male', 1176289)

INSERT INTO teacher
VALUES(1,'Ben','Dover','01-01-2000','General','01-02-2001')

INSERT INTO grade_details
VALUES(1, 3, 2, 96, 100, '03-04-2000')

INSERT INTO course
VALUES(1, 'SQL', 15, 2025, 'Second')

INSERT INTO grade
VALUES(1, 1, 1, 1, 4, 'No Comment', '10-04-2025')

INSERT INTO achievement_type
VALUES(1, 'Achievement', 'Very good achievement', 'Good rate')

SELECT * FROM student
SELECT * FROM teacher
SELECT * FROM grade_details
SELECT * FROM course
SELECT * FROM grade
SELECT * FROM achievement_type




