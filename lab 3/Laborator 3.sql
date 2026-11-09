-- =============================================================================
-- LUCRAREA DE LABORATOR NR. 3: ALGEBRA RELAȚIONALĂ ȘI INTEROGĂRI SQL (SQLite)
-- 
-- SGBD conectat în VS Code: SQLite (SQLTools / Database Client)
-- Operatorul de concatenare utilizat în SQLite: ||
-- Baza de date asociată: lab3.db
-- =============================================================================


-- #############################################################################
-- STRUCTURA ȘI DATELE BAZEI DE DATE (DDL & DML)
-- Rulați această secțiune dacă lucrați pe o bază nouă; datele sunt deja salvate în lab3.db
-- #############################################################################

-- Tabele Exercițiul 1
CREATE TABLE IF NOT EXISTS T (
    A INT,
    B INT,
    C INT
);

INSERT OR IGNORE INTO T (A, B, C) VALUES
(1, 2, 3),
(5, 6, 7),
(1, 2, 4);

CREATE TABLE IF NOT EXISTS S (
    A INT,
    B INT
);

INSERT OR IGNORE INTO S (A, B) VALUES
(3, 4),
(7, 8),
(1, 2);


-- Tabele Exercițiul 2
CREATE TABLE IF NOT EXISTS Student (
    idst INT PRIMARY KEY,
    nume_prenume TEXT,
    grupa TEXT,
    forma TEXT
);

CREATE TABLE IF NOT EXISTS Curs (
    idcurs INT PRIMARY KEY,
    denumire TEXT,
    credite INT,
    semestru INT
);

CREATE TABLE IF NOT EXISTS Note (
    idst INT,
    idcurs INT,
    data TEXT,
    nota INT,
    FOREIGN KEY (idst) REFERENCES Student(idst),
    FOREIGN KEY (idcurs) REFERENCES Curs(idcurs)
);

INSERT OR IGNORE INTO Student (idst, nume_prenume, grupa, forma) VALUES
(1, 'Ana Rusu', 'IT21', 'buget'),
(2, 'Ion Munteanu', 'IT22', 'contract'),
(3, 'Maria Lungu', 'IT21', 'buget'),
(4, 'Victor Popa', 'IS21', 'contract'),
(5, 'Elena Cojocaru', 'IT22', 'buget'),
(6, 'Dan Moraru', 'IT22', 'contract'),
(7, 'Irina Botnaru', 'IS21', 'buget'),
(8, 'Pavel Guțu', 'IT21', 'contract');

INSERT OR IGNORE INTO Curs (idcurs, denumire, credite, semestru) VALUES
(101, 'Matematică discretă', 5, 1),
(102, 'Programare procedurală', 6, 1),
(103, 'Arhitectura calculatoarelor', 4, 2),
(104, 'Programare orientată pe obiecte', 6, 2),
(105, 'Baze de date', 5, 3);

INSERT OR IGNORE INTO Note (idst, idcurs, data, nota) VALUES
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
CREATE TABLE IF NOT EXISTS Product (
    maker TEXT,
    model INT PRIMARY KEY,
    type TEXT
);

CREATE TABLE IF NOT EXISTS PC (
    model INT PRIMARY KEY,
    speed REAL,
    ram INT,
    hd INT,
    price REAL
);

CREATE TABLE IF NOT EXISTS Laptop (
    model INT PRIMARY KEY,
    speed REAL,
    ram INT,
    hd INT,
    screen REAL,
    price REAL
);

CREATE TABLE IF NOT EXISTS Printer (
    model INT PRIMARY KEY,
    color TEXT,
    type TEXT,
    price REAL
);

INSERT OR IGNORE INTO Product (maker, model, type) VALUES
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

INSERT OR IGNORE INTO PC (model, speed, ram, hd, price) VALUES
(1001, 3.2, 16, 512, 850),
(1002, 2.8, 8, 256, 520),
(1003, 3.6, 32, 1000, 1350),
(1004, 2.8, 16, 512, 780),
(1005, 3.2, 8, 256, 520);

INSERT OR IGNORE INTO Laptop (model, speed, ram, hd, screen, price) VALUES
(2001, 2.4, 16, 512, 14.0, 1100),
(2002, 2.8, 8, 256, 15.6, 640),
(2003, 3.2, 32, 1000, 16.0, 1900),
(2004, 2.4, 8, 512, 13.3, 780),
(2005, 1.8, 8, 256, 15.6, 520);

INSERT OR IGNORE INTO Printer (model, color, type, price) VALUES
(3001, 'true', 'inkjet', 120),
(3002, 'false', 'laser', 210),
(3003, 'true', 'laser', 450),
(3004, 'true', 'inkjet', 95);



-- #############################################################################
-- EXERCIȚIUL 1: EXPRESII ALGEBRĂ RELAȚIONALĂ (SELECTAȚI ȘI RULAȚI FIECARE ITEM)
-- #############################################################################

-- Exercițiul 1.1: R = π_A,B (T)
SELECT DISTINCT A, B 
FROM T;


-- Exercițiul 1.2: σ_{A+B < 5} (R)
SELECT DISTINCT A, B 
FROM T 
WHERE A + B < 5;


-- Exercițiul 1.3: π_A (R)
SELECT DISTINCT A 
FROM T;


-- Exercițiul 1.4: R × S
SELECT R.A AS R_A, R.B AS R_B, S.A AS S_A, S.B AS S_B 
FROM (SELECT DISTINCT A, B FROM T) AS R 
CROSS JOIN S;


-- Exercițiul 1.5: R ⋈_{R.B < S.B} S
SELECT R.A AS R_A, R.B AS R_B, S.A AS S_A, S.B AS S_B 
FROM (SELECT DISTINCT A, B FROM T) AS R 
JOIN S ON R.B < S.B;


-- Exercițiul 1.6: R ∪ R
SELECT DISTINCT A, B FROM T
UNION 
SELECT DISTINCT A, B FROM T;


-- Exercițiul 1.7: R ∪ S
SELECT DISTINCT A, B FROM T
UNION 
SELECT A, B FROM S;


-- Exercițiul 1.8: R ∩ S
SELECT DISTINCT A, B FROM T
INTERSECT 
SELECT A, B FROM S;


-- Exercițiul 1.9: R - S
SELECT DISTINCT A, B FROM T
EXCEPT 
SELECT A, B FROM S;


-- Exercițiul 1.10: S - R
SELECT A, B FROM S
EXCEPT 
SELECT DISTINCT A, B FROM T;



-- #############################################################################
-- EXERCIȚIUL 2: OPTIMIZAREA INTEROGĂRILOR (ALGEBRĂ RELAȚIONALĂ ȘI SQL)
-- #############################################################################

-- Exercițiul 2.1: π_nume_prenume (Student ⋈ Note) -> Optimizat cu semi-joncțiune
SELECT s.nume_prenume 
FROM Student s 
WHERE s.idst IN (SELECT DISTINCT idst FROM Note);


-- Exercițiul 2.2: σ_{idst = 3} (Student ⋈ Note) -> Împingerea selecției pe ambele tabele
SELECT s.idst, s.nume_prenume, s.grupa, s.forma, n.idcurs, n.data, n.nota 
FROM (SELECT * FROM Student WHERE idst = 3) s 
JOIN (SELECT * FROM Note WHERE idst = 3) n ON s.idst = n.idst;


-- Exercițiul 2.3: σ_{grupa = 'IT22'} (Student ⋈ Note) -> Împingerea selecției pe Student
SELECT s.idst, s.nume_prenume, s.grupa, s.forma, n.idcurs, n.data, n.nota 
FROM (SELECT * FROM Student WHERE grupa = 'IT22') s 
JOIN Note n ON s.idst = n.idst;


-- Exercițiul 2.4: σ_{forma = 'buget' ∧ nota >= 9} (Student ⋈ Note) -> Cine primește bursă de merit?
SELECT s.nume_prenume, s.grupa, n.nota, n.idcurs 
FROM (SELECT * FROM Student WHERE forma = 'buget') s 
JOIN (SELECT * FROM Note WHERE nota >= 9) n ON s.idst = n.idst;


-- Exercițiul 2.5: σ_{forma = 'contract' ∨ nota >= 9} (Student ⋈ Note)
-- Nu se poate împinge direct sub joncțiune din cauza operatorului OR între tabele
SELECT s.nume_prenume, s.forma, n.nota 
FROM Student s 
JOIN Note n ON s.idst = n.idst 
WHERE s.forma = 'contract' OR n.nota >= 9;


-- Exercițiul 2.6: Rescrierea interogării 2.5 prin reuniune (UNION)
SELECT s.idst, s.nume_prenume, s.forma, n.idcurs, n.nota 
FROM (SELECT * FROM Student WHERE forma = 'contract') s 
JOIN Note n ON s.idst = n.idst
UNION 
SELECT s.idst, s.nume_prenume, s.forma, n.idcurs, n.nota 
FROM Student s 
JOIN (SELECT * FROM Note WHERE nota >= 9) n ON s.idst = n.idst;


-- Exercițiul 2.7: π_denumire, nota (σ_{idcurs = 101} (Note ⋈ Curs)) -> Produs cartezian cu constantă
SELECT c.denumire, n.nota 
FROM (SELECT denumire FROM Curs WHERE idcurs = 101) c 
CROSS JOIN (SELECT nota FROM Note WHERE idcurs = 101) n;


-- Exercițiul 2.8: π_denumire (Curs ⋈ Note) -> La ce cursuri s-au susținut examene?
SELECT c.denumire 
FROM Curs c 
WHERE c.idcurs IN (SELECT DISTINCT idcurs FROM Note);


-- Exercițiul 2.9: σ_{semestru = 2} ((Student ⋈ Note) ⋈ Curs) -> Filtrare Curs mai întâi
SELECT s.nume_prenume, c.denumire, n.nota 
FROM (SELECT idcurs, denumire FROM Curs WHERE semestru = 2) c 
JOIN Note n ON c.idcurs = n.idcurs 
JOIN Student s ON n.idst = s.idst;


-- Exercițiul 2.10: Compararea expresiilor:
-- a) Toate notele (identic cu relația Note datorită integrității referențiale):
SELECT DISTINCT n.idst, n.idcurs, n.data, n.nota 
FROM Student s 
JOIN Note n ON s.idst = n.idst;

-- b) Studenții care au susținut cel puțin un examen:
SELECT DISTINCT s.idst, s.nume_prenume, s.grupa, s.forma 
FROM Student s 
JOIN Note n ON s.idst = n.idst;



-- #############################################################################
-- EXERCIȚIUL 3: SARCINA 3 (PRODUSE ȘI CALCULATOARE)
-- #############################################################################

-- Exercițiul 3.1: Modelul și prețul PC-urilor cu viteza >= 3.0 GHz
SELECT model, price 
FROM PC 
WHERE speed >= 3.0;


-- Exercițiul 3.2: Modelul și prețul laptopurilor cu ecran >= 15 inch sau SSD >= 1000 GB și preț < 1000 €
SELECT model, price 
FROM Laptop 
WHERE (screen >= 15.0 OR hd >= 1000) 
  AND price < 1000;


-- Exercițiul 3.3: Producătorii imprimantelor laser color
-- Explicație: Joncțiunea naturală dă relație vidă deoarece ambele tabele conțin coloana 'type',
-- dar Product.type are valori ('pc','laptop','printer') iar Printer.type are ('laser','inkjet').
-- Joncțiunea corectă se face doar pe atributul 'model':
SELECT DISTINCT pr.maker 
FROM Product pr 
JOIN Printer p ON pr.model = p.model 
WHERE p.type = 'laser' 
  AND (p.color = 'true' OR p.color = 1);


-- Exercițiul 3.4: Modelul și prețul tuturor produselor producătorului 'A'
SELECT p.model, pc.price 
FROM Product p 
JOIN PC pc ON p.model = pc.model 
WHERE p.maker = 'A'
UNION 
SELECT p.model, l.price 
FROM Product p 
JOIN Laptop l ON p.model = l.model 
WHERE p.maker = 'A'
UNION 
SELECT p.model, pr.price 
FROM Product p 
JOIN Printer pr ON p.model = pr.model 
WHERE p.maker = 'A';


-- Exercițiul 3.5: Producătorii care produc laptopuri, dar nu produc PC-uri
SELECT DISTINCT maker 
FROM Product 
WHERE type = 'laptop' 
  AND maker NOT IN (
      SELECT maker FROM Product WHERE type = 'pc'
  );


-- Exercițiul 3.6: Vitezele care apar atât la PC-uri, cât și la laptopuri
SELECT speed FROM PC 
INTERSECT 
SELECT speed FROM Laptop;


-- Exercițiul 3.7: Perechile de modele PC cu aceeași viteză (fiecare pereche o singură dată)
SELECT a.model AS model_1, b.model AS model_2, a.speed 
FROM PC a 
JOIN PC b ON a.speed = b.speed AND a.model < b.model;


-- Exercițiul 3.8: Producătorii care produc cel puțin 2 modele diferite de calculatoare (PC sau laptop)
SELECT maker 
FROM Product 
WHERE type IN ('pc', 'laptop') 
GROUP BY maker 
HAVING COUNT(DISTINCT model) >= 2;


-- Exercițiul 3.9: Laptopurile mai ieftine decât cel puțin un PC al aceluiași producător
SELECT DISTINCT l.model AS laptop_model, l.price AS laptop_pret, p_pc.maker, pc.model AS pc_model, pc.price AS pc_pret 
FROM Laptop l 
JOIN Product p_l ON l.model = p_l.model 
JOIN Product p_pc ON p_l.maker = p_pc.maker 
JOIN PC pc ON p_pc.model = pc.model 
WHERE l.price < pc.price;


-- Exercițiul 3.10: Modelul celui mai scump PC (fără funcții de agregare)
SELECT model, price 
FROM PC 
WHERE model NOT IN (
    SELECT a.model 
    FROM PC a 
    JOIN PC b ON a.price < b.price
);


-- Exercițiul 3.11: Producătorii care produc toate tipurile de produse
SELECT maker 
FROM Product 
GROUP BY maker 
HAVING COUNT(DISTINCT type) = (SELECT COUNT(DISTINCT type) FROM Product);


-- Exercițiul 3.12: Combinații PC + Imprimantă color în bugetul de 700 €
SELECT pc.model AS model_pc, pc.price AS pret_pc, 
       pr.model AS model_imprimanta, pr.price AS pret_imprimanta, 
       (pc.price + pr.price) AS pret_total 
FROM PC pc 
CROSS JOIN Printer pr 
WHERE (pr.color = 'true' OR pr.color = 1) 
  AND (pc.price + pr.price) <= 700;


-- Exercițiul 3.13: Toți producătorii cu imprimantele lor (cei fără imprimantă apar cu NULL)
SELECT DISTINCT p.maker, pr.model AS model_imprimanta, pr.price 
FROM Product p 
LEFT JOIN Printer pr ON p.model = pr.model 
ORDER BY p.maker, pr.model;


-- Exercițiul 3.14: Numărul de PC-uri și prețul mediu pentru fiecare producător
-- Concatenare pură cu operatorul || (specific SQLite):
SELECT 'Producatorul ' || p.maker || ' ofera ' || COUNT(pc.model) || ' PC-uri la pret mediu de ' || ROUND(AVG(pc.price), 2) || ' EUR' AS statistica 
FROM Product p 
JOIN PC pc ON p.model = pc.model 
GROUP BY p.maker;

