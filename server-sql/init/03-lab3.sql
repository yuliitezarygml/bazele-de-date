-- =============================================================================
-- LUCRAREA DE LABORATOR NR. 3 — structura și datele (MariaDB)
-- Baza de date: lab3
-- Rularea repetată recreează baza de la zero (fără duplicate).
-- =============================================================================

DROP DATABASE IF EXISTS lab3;
CREATE DATABASE lab3 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE lab3;

-- Tabele Exercițiul 1
CREATE TABLE T (
    A INT,
    B INT,
    C INT
);

INSERT INTO T (A, B, C) VALUES
(1, 2, 3),
(5, 6, 7),
(1, 2, 4);

CREATE TABLE S (
    A INT,
    B INT
);

INSERT INTO S (A, B) VALUES
(3, 4),
(7, 8),
(1, 2);


-- Tabele Exercițiul 2
CREATE TABLE Student (
    idst INT PRIMARY KEY,
    nume_prenume VARCHAR(100),
    grupa VARCHAR(10),
    forma VARCHAR(20)
);

CREATE TABLE Curs (
    idcurs INT PRIMARY KEY,
    denumire VARCHAR(100),
    credite INT,
    semestru INT
);

CREATE TABLE Note (
    idst INT,
    idcurs INT,
    data VARCHAR(10),
    nota INT,
    FOREIGN KEY (idst) REFERENCES Student(idst),
    FOREIGN KEY (idcurs) REFERENCES Curs(idcurs)
);

INSERT INTO Student (idst, nume_prenume, grupa, forma) VALUES
(1, 'Ana Rusu', 'IT21', 'buget'),
(2, 'Ion Munteanu', 'IT22', 'contract'),
(3, 'Maria Lungu', 'IT21', 'buget'),
(4, 'Victor Popa', 'IS21', 'contract'),
(5, 'Elena Cojocaru', 'IT22', 'buget'),
(6, 'Dan Moraru', 'IT22', 'contract'),
(7, 'Irina Botnaru', 'IS21', 'buget'),
(8, 'Pavel Guțu', 'IT21', 'contract');

INSERT INTO Curs (idcurs, denumire, credite, semestru) VALUES
(101, 'Matematică discretă', 5, 1),
(102, 'Programare procedurală', 6, 1),
(103, 'Arhitectura calculatoarelor', 4, 2),
(104, 'Programare orientată pe obiecte', 6, 2),
(105, 'Baze de date', 5, 3);

INSERT INTO Note (idst, idcurs, data, nota) VALUES
(1, 101, '14.01.2026', 9),
(1, 102, '21.01.2026', 8),
(1, 104, '17.06.2026', 10),
(2, 101, '14.01.2026', 6),
(2, 103, '10.06.2026', 7),
(3, 101, '14.01.2026', 10),
(3, 102, '21.01.2026', 9),
(3, 103, '10.06.2026', 8),
(4, 102, '21.01.2026', 5),
(5, 104, '17.06.2026', 7),
(6, 101, '14.01.2026', 4),
(6, 101, '05.02.2026', 6),
(8, 101, '14.01.2026', 7),
(8, 104, '17.06.2026', 6);


-- Tabele Exercițiul 3
CREATE TABLE Product (
    maker VARCHAR(10),
    model INT PRIMARY KEY,
    type VARCHAR(10)
);

CREATE TABLE PC (
    model INT PRIMARY KEY,
    speed DECIMAL(3,1),
    ram INT,
    hd INT,
    price DECIMAL(10,2)
);

CREATE TABLE Laptop (
    model INT PRIMARY KEY,
    speed DECIMAL(3,1),
    ram INT,
    hd INT,
    screen DECIMAL(4,1),
    price DECIMAL(10,2)
);

CREATE TABLE Printer (
    model INT PRIMARY KEY,
    color VARCHAR(5),
    type VARCHAR(10),
    price DECIMAL(10,2)
);

INSERT INTO Product (maker, model, type) VALUES
('A', 1001, 'pc'),
('A', 1002, 'pc'),
('A', 2001, 'laptop'),
('A', 3001, 'printer'),
('B', 1003, 'pc'),
('B', 2002, 'laptop'),
('C', 1004, 'pc'),
('C', 2003, 'laptop'),
('C', 2004, 'laptop'),
('C', 3002, 'printer'),
('D', 2005, 'laptop'),
('D', 3003, 'printer'),
('E', 1005, 'pc'),
('E', 3004, 'printer');

INSERT INTO PC (model, speed, ram, hd, price) VALUES
(1001, 3.2, 16, 512, 850),
(1002, 2.8, 8, 256, 520),
(1003, 3.6, 32, 1000, 1350),
(1004, 2.8, 16, 512, 780),
(1005, 3.2, 8, 256, 520);

INSERT INTO Laptop (model, speed, ram, hd, screen, price) VALUES
(2001, 2.4, 16, 512, 14.0, 1100),
(2002, 2.8, 8, 256, 15.6, 640),
(2003, 3.2, 32, 1000, 16.0, 1900),
(2004, 2.4, 8, 512, 13.3, 780),
(2005, 1.8, 8, 256, 15.6, 520);

INSERT INTO Printer (model, color, type, price) VALUES
(3001, 'true', 'inkjet', 120),
(3002, 'false', 'laser', 210),
(3003, 'true', 'laser', 450),
(3004, 'true', 'inkjet', 95);
