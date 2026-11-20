-- =============================================================================
-- LUCRAREA DE LABORATOR NR. 3: ALGEBRA RELAȚIONALĂ ȘI INTEROGĂRI SQL (MariaDB)
--
-- Server: MariaDB în Docker (server-sql/docker-compose.yml)
-- Baza de date: lab3 (structura și datele: server-sql/init/03-lab3.sql)
-- Concatenare în MariaDB: CONCAT(...) — operatorul || înseamnă OR
-- =============================================================================

USE lab3;


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
  AND p.color = 'true';


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
WHERE pr.color = 'true'
  AND (pc.price + pr.price) <= 700;


-- Exercițiul 3.13: Toți producătorii cu imprimantele lor (cei fără imprimantă apar cu NULL)
SELECT DISTINCT p.maker, pr.model AS model_imprimanta, pr.price
FROM Product p
LEFT JOIN Printer pr ON p.model = pr.model
ORDER BY p.maker, pr.model;


-- Exercițiul 3.14: Numărul de PC-uri și prețul mediu pentru fiecare producător
-- În MariaDB concatenarea se face cu CONCAT():
SELECT CONCAT('Producatorul ', p.maker, ' ofera ', COUNT(pc.model),
              ' PC-uri la pret mediu de ', ROUND(AVG(pc.price), 2), ' EUR') AS statistica
FROM Product p
JOIN PC pc ON p.model = pc.model
GROUP BY p.maker;
