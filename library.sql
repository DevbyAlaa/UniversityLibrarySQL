CREATE DATABASE IF NOT EXISTS university_library;
USE university_library;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    major VARCHAR(60) NOT NULL
);

CREATE TABLE books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(150) NOT NULL,
    author VARCHAR(100) NOT NULL,
    category VARCHAR(50) NOT NULL,
    publication_year YEAR
);

CREATE TABLE loans (
    loan_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    book_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,

    CONSTRAINT fk_loan_student
        FOREIGN KEY (student_id)
        REFERENCES students(student_id),

    CONSTRAINT fk_loan_book
        FOREIGN KEY (book_id)
        REFERENCES books(book_id),

    CONSTRAINT chk_due_date
        CHECK (due_date >= loan_date),

    CONSTRAINT chk_return_date
        CHECK (
            return_date IS NULL
            OR return_date >= loan_date
        )
);

INSERT INTO students (full_name, email, major)
VALUES
('Alaa Ahmed', 'alaa@example.com', 'Information Technology'),
('Sara Ali', 'sara@example.com', 'Computer Science'),
('Noura Khalid', 'noura@example.com', 'Information Technology'),
('Lama Omar', 'lama@example.com', 'Software Engineering');

INSERT INTO books (title, author, category, publication_year)
VALUES
('Database Fundamentals', 'Maya Hassan', 'Databases', 2023),
('Learning Java', 'Omar Saleh', 'Programming', 2022),
('Introduction to Cybersecurity', 'Nora Ali', 'Cybersecurity', 2024),
('Data Structures Basics', 'Adam Sami', 'Programming', 2021),
('Practical SQL', 'Sara Adel', 'Databases', 2024);

INSERT INTO loans (
    student_id, book_id, loan_date, due_date, return_date
)
VALUES
(1, 1, '2026-10-01', '2026-10-15', '2026-10-12'),
(1, 3, '2026-11-01', '2026-11-15', NULL),
(2, 2, '2026-10-20', '2026-11-03', NULL),
(3, 1, '2026-11-02', '2026-11-16', NULL),
(2, 4, '2026-11-03', '2026-11-17', NULL);

SELECT *
FROM students;

SELECT title, category
FROM books;

SELECT full_name, major
FROM students
WHERE major = 'Information Technology'
ORDER BY full_name ASC;

SELECT title
FROM books
WHERE title LIKE '%SQL%';

SELECT title, publication_year
FROM books
WHERE publication_year BETWEEN 2022 AND 2024;

SELECT DISTINCT category
FROM books;

UPDATE loans
SET return_date = '2026-11-05'
WHERE loan_id = 3;

INSERT INTO students (full_name, email, major)
VALUES ('Test Student', 'test@example.com', 'Information Technology');

DELETE FROM students
WHERE email = 'test@example.com';

SELECT
    l.loan_id,
    s.full_name,
    b.title,
    l.loan_date,
    l.due_date,
    l.return_date
FROM loans AS l
INNER JOIN students AS s
    ON l.student_id = s.student_id
INNER JOIN books AS b
    ON l.book_id = b.book_id
ORDER BY l.loan_id;

SELECT
    s.full_name,
    b.title,
    l.due_date
FROM loans AS l
INNER JOIN students AS s
    ON l.student_id = s.student_id
INNER JOIN books AS b
    ON l.book_id = b.book_id
WHERE l.return_date IS NULL;

SELECT
    s.student_id,
    s.full_name,
    COUNT(l.loan_id) AS total_loans
FROM students AS s
LEFT JOIN loans AS l
    ON s.student_id = l.student_id
GROUP BY s.student_id, s.full_name
ORDER BY total_loans DESC;

SELECT
    s.student_id,
    s.full_name,
    COUNT(l.loan_id) AS total_loans
FROM students AS s
INNER JOIN loans AS l
    ON s.student_id = l.student_id
GROUP BY s.student_id, s.full_name
HAVING COUNT(l.loan_id) >= 2;

SELECT
    COUNT(*) AS total_books,
    MIN(publication_year) AS oldest_publication,
    MAX(publication_year) AS newest_publication
FROM books;

SELECT book_id, title
FROM books
WHERE book_id NOT IN (
    SELECT book_id
    FROM loans
);

SELECT
    category,
    COUNT(*) AS total_books
FROM books
GROUP BY category
ORDER BY total_books DESC, category ASC;
