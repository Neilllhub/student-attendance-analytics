
USE student_analytics;

-- 1. Insert fictional students if they do not exist
INSERT INTO students (student_name, class_name)
SELECT 'Aarav Shah', 'BCA DS'
WHERE NOT EXISTS (
    SELECT 1 FROM students
    WHERE student_name = 'Aarav Shah'
      AND class_name = 'BCA DS'
);

INSERT INTO students (student_name, class_name)
SELECT 'Riya Patil', 'BCA DS'
WHERE NOT EXISTS (
    SELECT 1 FROM students
    WHERE student_name = 'Riya Patil'
      AND class_name = 'BCA DS'
);

INSERT INTO students (student_name, class_name)
SELECT 'Kabir Mehta', 'BCA DS'
WHERE NOT EXISTS (
    SELECT 1 FROM students
    WHERE student_name = 'Kabir Mehta'
      AND class_name = 'BCA DS'
);

INSERT INTO students (student_name, class_name)
SELECT 'Ananya Rao', 'BCA DS'
WHERE NOT EXISTS (
    SELECT 1 FROM students
    WHERE student_name = 'Ananya Rao'
      AND class_name = 'BCA DS'
);

INSERT INTO students (student_name, class_name)
SELECT 'Ishaan Joshi', 'BCA DS'
WHERE NOT EXISTS (
    SELECT 1 FROM students
    WHERE student_name = 'Ishaan Joshi'
      AND class_name = 'BCA DS'
);

-- 2. Insert subjects
INSERT IGNORE INTO subjects (subject_name)
VALUES
('Python Programming'),
('Database Management Systems'),
('Statistics');

-- 3. Insert fictional attendance records
-- Five dates: 19 to 23 October 2026
-- Pattern: Present, Present, Absent, Present, Present

INSERT INTO attendance
    (student_id, subject_id, class_date, status)
SELECT s.student_id, sub.subject_id, d.class_date, d.status
FROM students s
CROSS JOIN subjects sub
CROSS JOIN (
    SELECT DATE('2026-10-19') AS class_date, 'Present' AS status
    UNION ALL
    SELECT DATE('2026-10-20'), 'Present'
    UNION ALL
    SELECT DATE('2026-10-21'), 'Absent'
    UNION ALL
    SELECT DATE('2026-10-22'), 'Present'
    UNION ALL
    SELECT DATE('2026-10-23'), 'Present'
) d
WHERE s.student_name IN (
    'Aarav Shah', 'Riya Patil', 'Kabir Mehta',
    'Ananya Rao', 'Ishaan Joshi'
)
AND s.class_name = 'BCA DS'
AND sub.subject_name IN (
    'Python Programming',
    'Database Management Systems',
    'Statistics'
)
AND NOT EXISTS (
    SELECT 1
    FROM attendance a
    WHERE a.student_id = s.student_id
      AND a.subject_id = sub.subject_id
      AND a.class_date = d.class_date
);

-- 4. Insert fictional marks if a record for that
-- student, subject and exam date does not exist

INSERT INTO marks
    (student_id, subject_id, marks_obtained, max_marks, exam_date)
SELECT s.student_id, sub.subject_id, sample.marks, 100,
       DATE('2026-10-24')
FROM (
    SELECT 'Aarav Shah' AS student_name,
           'Python Programming' AS subject_name, 85 AS marks
    UNION ALL SELECT 'Aarav Shah', 'Database Management Systems', 78
    UNION ALL SELECT 'Aarav Shah', 'Statistics', 82
    UNION ALL SELECT 'Riya Patil', 'Python Programming', 92
    UNION ALL SELECT 'Riya Patil', 'Database Management Systems', 88
    UNION ALL SELECT 'Riya Patil', 'Statistics', 90
    UNION ALL SELECT 'Kabir Mehta', 'Python Programming', 70
    UNION ALL SELECT 'Kabir Mehta', 'Database Management Systems', 75
    UNION ALL SELECT 'Kabir Mehta', 'Statistics', 72
    UNION ALL SELECT 'Ananya Rao', 'Python Programming', 95
    UNION ALL SELECT 'Ananya Rao', 'Database Management Systems', 91
    UNION ALL SELECT 'Ananya Rao', 'Statistics', 94
    UNION ALL SELECT 'Ishaan Joshi', 'Python Programming', 80
    UNION ALL SELECT 'Ishaan Joshi', 'Database Management Systems', 84
    UNION ALL SELECT 'Ishaan Joshi', 'Statistics', 79
) sample
JOIN students s
  ON s.student_name = sample.student_name
 AND s.class_name = 'BCA DS'
JOIN subjects sub
  ON sub.subject_name = sample.subject_name
WHERE NOT EXISTS (
    SELECT 1 FROM marks m
    WHERE m.student_id = s.student_id
      AND m.subject_id = sub.subject_id
      AND m.exam_date = DATE('2026-10-24')
);

-- 5. Verify the data
SELECT COUNT(*) AS total_students FROM students;
SELECT COUNT(*) AS total_subjects FROM subjects;
SELECT COUNT(*) AS total_attendance_records FROM attendance;
SELECT COUNT(*) AS total_marks_records FROM marks;
