
10. //////////////////////////////////////////////

SELECT tMax.subject_name AS Предмет, 
tests.test_name AS [Назва тесту], 
tMax.MaxTime AS [Час на проходження]
FROM tests 
INNER JOIN 
(SELECT test_subjects.ID as subjectId, 
	test_subjects.subject_name, 
	MAX(tests.time) as MaxTime
FROM test_subjects 
INNER JOIN tests 
ON test_subjects.ID = tests.test_subject_id 
Group BY test_subjects.ID, test_subjects.subject_name)  AS tMax 
ON (tests.test_subject_id = tMax.subjectId) AND (tests.time = tMax.MaxTime);

11. //////////////////////////////////////////////
SELECT test_subjects.subject_name, tests.test_name, tests.uri_alias, tests.time, Count(questions.ID) AS questions_count
FROM (test_subjects INNER JOIN tests ON test_subjects.ID = tests.test_subject_id) LEFT JOIN questions ON tests.ID = questions.test_id
GROUP BY test_subjects.subject_name, tests.test_name, tests.uri_alias, tests.time;

SELECT tests.test_subject_id
tests.test_name, 
tests.time,
(inner_test.questions_count / tests.time) as complexity
FROM tests
INNER JOIN 
(SELECT tests.ID as test_id, count(questions.ID) as questions_count
	FROM tests
	LEFT JOIN questions
	ON (tests.ID = questions.test_id)
	GROUP BY tests.ID) as inner_test
ON (inner_test.test_id = tests.ID)
ORDER BY (inner_test.questions_count / tests.time) ASC


SELECT test_subjects.subject_name,
	tests_with_complexity.test_name,
	tests_with_complexity.time,
	tests_with_complexity.complexity
FROM test_subjects
INNER JOIN
(SELECT 
	TOP 5
	tests.test_subject_id,
	tests.test_name, 
	tests.time,
	(inner_test.questions_count / tests.time) as complexity
	FROM tests
	INNER JOIN 
	(SELECT tests.ID as test_id, count(questions.ID) as questions_count
		FROM tests
		LEFT JOIN questions
		ON (tests.ID = questions.test_id)
		GROUP BY tests.ID) as inner_test
	ON (inner_test.test_id = tests.ID)
	ORDER BY (inner_test.questions_count / tests.time) ASC) as tests_with_complexity
ON (tests_with_complexity.test_subject_id = test_subjects.ID)
GROUP BY test_subjects.subject_name, 
	tests_with_complexity.test_name,
	tests_with_complexity.time,
	tests_with_complexity.complexity

SELECT tests.test_name, count(questions.ID) as questions_count,
(questions_count / tests.time) as complexity from tests
LEFT JOIN questions
ON (tests.id = questions.test_id)
GROUP BY tests.test_name, (questions_count / tests.time)
ORDER BY complexity ASC


SELECT * FROM (SELECT
	tests.test_subject_id,
	tests.test_name, 
	tests.time,
	(inner_test.questions_count / tests.time) as complexity,
	ROW_NUMBER() OVER (
		PARTITION BY tests.test_subject_id
		ORDER BY (inner_test.questions_count / tests.time) ASC
	) AS rows_num
	FROM tests
	INNER JOIN 
	(SELECT tests.ID as test_id, count(questions.ID) as questions_count
		FROM tests
		LEFT JOIN questions
		ON (tests.ID = questions.test_id)
		GROUP BY tests.ID) as inner_test
	ON (inner_test.test_id = tests.ID)
	) AS inside 
WHERE inside.rows_num <= 2 


