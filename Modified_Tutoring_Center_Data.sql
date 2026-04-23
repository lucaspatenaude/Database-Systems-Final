-- =============================================================================
--                    1. CREATE TABLES
-- =============================================================================

CREATE TABLE Students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    student_email VARCHAR(100) UNIQUE NOT NULL,
    student_phone VARCHAR(20),
    student_major VARCHAR(100),
    student_level VARCHAR(50)
);

CREATE TABLE Tutors (
    tutor_id INT AUTO_INCREMENT PRIMARY KEY,
    tutor_name VARCHAR(100) NOT NULL,
    tutor_email VARCHAR(100) UNIQUE NOT NULL,
    tutor_phone VARCHAR(20)
);

CREATE TABLE Subjects (
    subject_id INT AUTO_INCREMENT PRIMARY KEY,
    course_code VARCHAR(20),
    subject_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE TutorSubjects (
    tutor_id INT NOT NULL,
    subject_id INT NOT NULL,
    PRIMARY KEY (tutor_id, subject_id),
    FOREIGN KEY (tutor_id) REFERENCES Tutors(tutor_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Certifications (
    certification_id INT AUTO_INCREMENT PRIMARY KEY,
    certification_name VARCHAR(100) NOT NULL
);

CREATE TABLE TutorCertifications (
    tutor_id INT NOT NULL,
    certification_id INT NOT NULL,
    PRIMARY KEY (tutor_id, certification_id),
    FOREIGN KEY (tutor_id) REFERENCES Tutors(tutor_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (certification_id) REFERENCES Certifications(certification_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_status VARCHAR(20) NOT NULL,
    payment_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),

    CHECK (payment_amount >= 0),
    CHECK (payment_status IN ('Pending', 'Paid', 'Paid late', 'Unpaid', 'Waived', 'Failed', 'Refunded'))
);

CREATE TABLE Appointments (
    appointment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    tutor_id INT NOT NULL,
    subject_id INT NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    session_length_mins INT NOT NULL,
    appointment_status VARCHAR(20) NOT NULL,
    session_notes TEXT,
    room VARCHAR(50),
    follow_up_requested BOOLEAN DEFAULT FALSE,
    payment_id INT,

    FOREIGN KEY (student_id) REFERENCES Students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (tutor_id) REFERENCES Tutors(tutor_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (subject_id) REFERENCES Subjects(subject_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
        ON DELETE SET NULL ON UPDATE CASCADE,

    CHECK (session_length_mins > 0),
    CHECK (appointment_status IN ('Scheduled', 'Completed', 'Cancelled', 'No-Show')),
    UNIQUE (tutor_id, appointment_date, appointment_time),
    UNIQUE (student_id, appointment_date, appointment_time)
);

-- =============================================================================
--                 2. INSERT DATA INTO TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Students
-- -----------------------------------------------------------------------------
INSERT INTO Students (student_id, student_name, student_email, student_phone, student_major, student_level) VALUES
    (1,  'Maya Patel',    'maya.patel@colorado.edu',    '303-555-0181', 'Computer Science',       'Freshman'),
    (2,  'Jordan Lee',    'jordan.lee@colorado.edu',    '720-555-0104', 'Applied Math',           'Sophomore'),
    (3,  'Sofia Ramirez', 'sofia.ramirez@colorado.edu', '303-555-0199', 'Biology',                'Freshman'),
    (4,  'Ethan Brooks',  'ethan.brooks@colorado.edu',  '303-555-0124', 'Physics',                'Junior'),
    (5,  'Priya Shah',    'priya.shah@colorado.edu',    '720-555-0168', 'Computer Science',       'Sophomore'),
    (6,  'Noah Kim',      'noah.kim@colorado.edu',      '303-555-0155', 'Economics',              'Sophomore'),
    (7,  'Elena Garcia',  'elena.garcia@colorado.edu',  '303-555-0177', 'Integrative Physiology', 'Junior'),
    (8,  'Owen Davis',    'owen.davis@colorado.edu',    '720-555-0142', 'Mechanical Engineering', 'Sophomore'),
    (9,  'Chloe Nguyen',  'chloe.nguyen@colorado.edu',  '303-555-0139', 'Data Science',           'Freshman'),
    (10, 'Daniel Wu',     'daniel.wu@colorado.edu',     '303-555-0188', 'Economics',              'Senior'),
    (11, 'Hannah Reed',   'hannah.reed@colorado.edu',   '720-555-0191', 'Neuroscience',           'Freshman'),
    (12, 'Marcus Hill',   'marcus.hill@colorado.edu',   '303-555-0161', 'Computer Engineering',   'Junior');

-- -----------------------------------------------------------------------------
-- Tutors
-- -----------------------------------------------------------------------------
INSERT INTO Tutors (tutor_id, tutor_name, tutor_email, tutor_phone) VALUES
    (1, 'Ava Lopez',       'ava.lopez@colorado.edu',       '303-555-0110'),
    (2, 'Liam Chen',       'liam.chen@colorado.edu',       '303-555-0111'),
    (3, 'Olivia Brown',    'olivia.brown@colorado.edu',    '303-555-0113'),
    (4, 'Sophia Martinez', 'sophia.martinez@colorado.edu', '303-555-0115'),
    (5, 'Ryan Scott',      'ryan.scott@colorado.edu',      '303-555-0116'),
    (6, 'Emma Wilson',     'emma.wilson@colorado.edu',     '303-555-0117'),
    (7, 'Grace Turner',    'grace.turner@colorado.edu',    '303-555-0112');

-- -----------------------------------------------------------------------------
-- Subjects
-- -----------------------------------------------------------------------------
INSERT INTO Subjects (subject_id, course_code, subject_name) VALUES
    (1, 'CSCI 1300', 'Starting Computing'),
    (2, 'CSCI 2270', 'Data Structures'),
    (3, 'APPM 1350', 'Calculus 1'),
    (4, 'APPM 1360', 'Calculus 2'),
    (5, 'ECON 3818', 'Statistics'),
    (6, 'CHEM 1113', 'General Chemistry'),
    (7, 'CHEM 3311', 'Organic Chemistry'),
    (8, 'PHYS 1110', 'Physics I'),
    (9, 'MATH 2001', 'Discrete Math');

-- -----------------------------------------------------------------------------
-- TutorSubjects
-- -----------------------------------------------------------------------------
INSERT INTO TutorSubjects (tutor_id, subject_id) VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (3, 5),
    (3, 3),
    (4, 6),
    (4, 7),
    (5, 8),
    (5, 3),
    (6, 5),
    (6, 8),
    (7, 2),
    (7, 9);

-- -----------------------------------------------------------------------------
-- Certifications
-- -----------------------------------------------------------------------------
INSERT INTO Certifications (certification_id, certification_name) VALUES
    (1, 'CRLA Level 1'),
    (2, 'CRLA Level 2'),
    (3, 'Peer Tutor'),
    (4, 'Math Tutor'),
    (5, 'Chemistry Tutor'),
    (6, 'Physics Tutor'),
    (7, 'Statistics Tutor'),
    (8, 'Statistics Lab');

-- -----------------------------------------------------------------------------
-- TutorCertifications
-- -----------------------------------------------------------------------------
INSERT INTO TutorCertifications (tutor_id, certification_id) VALUES
    (1, 1),
    (1, 3),
    (2, 1),
    (2, 4),
    (3, 2),
    (3, 8),
    (4, 5),
    (4, 1),
    (5, 6),
    (5, 1),
    (6, 7),
    (6, 6),
    (7, 2);

-- -----------------------------------------------------------------------------
-- Payments
-- (Inserted before Appointments since Appointments references payment_id)
-- -----------------------------------------------------------------------------
INSERT INTO Payments (payment_id, payment_status, payment_amount, payment_method) VALUES
    (1,  'Paid',     35.00, 'Card'),
    (2,  'Paid',     35.00, 'Card'),
    (3,  'Pending',  35.00, NULL),
    (4,  'Paid',     40.00, 'Cash'),
    (5,  'Unpaid',   40.00, NULL),
    (6,  'Paid',     45.00, 'Card'),
    (7,  'Pending',  45.00, NULL),
    (8,  'Paid',     35.00, 'Cash'),
    (9,  'Waived',    0.00, 'N/A'),
    (10, 'Pending',  35.00, NULL),
    (11, 'Paid',     35.00, 'Card'),
    (12, 'Paid late',35.00, 'Card'),
    (13, 'Pending',  35.00, NULL),
    (14, 'Paid',     40.00, 'Card'),
    (15, 'Paid',     40.00, 'Cash'),
    (16, 'Paid',     35.00, 'Card'),
    (17, 'Pending',  35.00, NULL),
    (18, 'Paid',     45.00, 'Card'),
    (19, 'Paid',     35.00, 'Card'),
    (20, 'Pending',  35.00, NULL),
    (21, 'Paid',     40.00, 'Card'),
    (22, 'Pending',  40.00, NULL),
    (23, 'Unpaid',   35.00, NULL),
    (24, 'Pending',  35.00, NULL),
    (25, 'Paid',     35.00, 'Card'),
    (26, 'Pending',  35.00, NULL),
    (27, 'Paid',     35.00, 'Card'),
    (28, 'Pending',  40.00, NULL),
    (29, 'Pending',  40.00, NULL),
    (30, 'Paid',     45.00, 'Card'),
    (31, 'Paid',     40.00, 'Card'),
    (32, 'Paid',     35.00, 'Card'),
    (33, 'Waived',    0.00, 'N/A'),
    (34, 'Pending',  35.00, NULL),
    (35, 'Paid',     35.00, 'Cash');

-- -----------------------------------------------------------------------------
-- Appointments
-- -----------------------------------------------------------------------------
INSERT INTO Appointments (appointment_id, student_id, tutor_id, subject_id, appointment_date, appointment_time, session_length_mins, appointment_status, session_notes, room, follow_up_requested, payment_id) VALUES
    (1,  1,  1, 1, '2026-03-02', '15:00', 60, 'Completed',  'Worked on loops and conditionals',  'ECCR 1B30',  TRUE,  1),
    (2,  1,  1, 1, '2026-03-16', '15:00', 60, 'Completed',  'Review for midterm 1',               'ECCR 1B30',  TRUE,  2),
    (3,  1,  2, 3, '2026-04-09', '10:00', 60, 'Scheduled',  NULL,                                 'Zoom',       FALSE, 3),
    (4,  2,  2, 3, '2026-03-03', '11:00', 60, 'Completed',  'Derivative practice',                'Math 250',   FALSE, 4),
    (5,  2,  3, 3, '2026-03-24', '11:30', 60, 'No-Show',    NULL,                                 'Math 250',   FALSE, 5),
    (6,  3,  4, 6, '2026-03-05', '13:00', 90, 'Completed',  'Stoichiometry review',               'CHEM 120',   TRUE,  6),
    (7,  3,  4, 6, '2026-04-10', '13:00', 90, 'Scheduled',  NULL,                                 'CHEM 120',   TRUE,  7),
    (8,  4,  5, 8, '2026-03-06', '14:00', 60, 'Completed',  'Kinematics and vectors',             'DUAN G1B20', FALSE, 8),
    (9,  4,  5, 8, '2026-03-20', '14:00', 60, 'Cancelled',  'Student sick',                       'DUAN G1B20', FALSE, 9),
    (10, 4,  6, 5, '2026-04-12', '14:30', 60, 'Scheduled',  NULL,                                 'Zoom',       FALSE, 10),
    (11, 5,  1, 2, '2026-03-07', '09:00', 60, 'Completed',  'Linked lists',                       'ECCR 1B30',  FALSE, 11),
    (12, 5,  7, 2, '2026-03-28', '09:30', 60, 'Completed',  'Stacks and queues',                  'ECCR 1B40',  TRUE,  12),
    (13, 5,  1, 2, '2026-04-14', '09:30', 60, 'Scheduled',  NULL,                                 'ECCR 1B30',  TRUE,  13),
    (14, 6,  6, 5, '2026-03-08', '16:00', 60, 'Completed',  'Confidence intervals',               'KOBL S240',  FALSE, 14),
    (15, 6,  3, 5, '2026-03-29', '16:30', 60, 'Completed',  'Regression basics',                  'KOBL S240',  FALSE, 15),
    (16, 7,  4, 6, '2026-03-10', '12:00', 60, 'Completed',  'Periodic trends',                    'CHEM 120',   FALSE, 16),
    (17, 7,  4, 6, '2026-04-15', '12:00', 60, 'Scheduled',  NULL,                                 'CHEM 120',   FALSE, 17),
    (18, 8,  5, 8, '2026-03-11', '17:00', 90, 'Completed',  'Forces and free-body diagrams',      'DUAN G1B20', TRUE,  18),
    (19, 9,  7, 9, '2026-03-12', '10:00', 60, 'Completed',  'Logic and proofs',                   'ECCR 1B40',  FALSE, 19),
    (20, 9,  2, 3, '2026-04-16', '10:30', 60, 'Scheduled',  NULL,                                 'Math 250',   FALSE, 20),
    (21, 10, 6, 5, '2026-03-13', '15:30', 60, 'Completed',  'ANOVA overview',                     'KOBL S240',  FALSE, 21),
    (22, 10, 3, 5, '2026-04-18', '15:30', 60, 'Scheduled',  NULL,                                 'Zoom',       FALSE, 22),
    (23, 11, 4, 6, '2026-03-14', '08:00', 60, 'No-Show',    NULL,                                 'CHEM 120',   FALSE, 23),
    (24, 11, 4, 6, '2026-04-19', '08:00', 60, 'Scheduled',  NULL,                                 'CHEM 120',   FALSE, 24),
    (25, 12, 7, 2, '2026-03-17', '18:00', 60, 'Completed',  'Trees and recursion',                'ECCR 1B40',  TRUE,  25),
    (26, 12, 7, 9, '2026-04-21', '18:00', 60, 'Scheduled',  NULL,                                 'ECCR 1B40',  TRUE,  26),
    (27, 3,  6, 5, '2026-03-18', '09:00', 60, 'Completed',  'Probability basics',                 'KOBL S240',  FALSE, 27),
    (28, 2,  2, 4, '2026-04-22', '11:00', 60, 'Scheduled',  NULL,                                 'Math 250',   FALSE, 28),
    (29, 6,  3, 5, '2026-04-23', '16:30', 60, 'Scheduled',  NULL,                                 'Zoom',       FALSE, 29),
    (30, 7,  4, 7, '2026-03-31', '12:00', 60, 'Completed',  'Nomenclature and reactions',         'CHEM 120',   TRUE,  30),
    (31, 10, 6, 5, '2026-03-25', '15:30', 60, 'Completed',  'Hypothesis testing',                 'KOBL S240',  FALSE, 31),
    (32, 5,  1, 1, '2026-03-21', '09:00', 60, 'Completed',  'Functions and arrays',               'ECCR 1B30',  FALSE, 32),
    (33, 9,  7, 9, '2026-03-26', '10:00', 60, 'Cancelled',  'Tutor unavailable',                  'ECCR 1B40',  FALSE, 33),
    (34, 8,  2, 3, '2026-04-24', '17:00', 60, 'Scheduled',  NULL,                                 'Math 250',   FALSE, 34),
    (35, 11, 6, 5, '2026-03-27', '08:00', 60, 'Completed',  'Exam review',                        'KOBL S240',  FALSE, 35);