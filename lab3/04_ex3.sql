-- Exercițiul 1
SELECT model,price FROM PC WHERE speed>=3.0;

-- Exercițiul 2
SELECT model,price FROM Laptop WHERE (screen>=15 OR ssd>=1000) AND price<1000;

-- Exercițiul 3
SELECT DISTINCT p.maker FROM Product p JOIN Printer r ON r.model=p.model WHERE r.type='laser' AND r.color=1;

-- Exercițiul 4
SELECT c.model,c.price FROM Product p JOIN PC c ON c.model=p.model WHERE p.maker='A' UNION SELECT l.model,l.price FROM Product p JOIN Laptop l ON l.model=p.model WHERE p.maker='A' UNION SELECT r.model,r.price FROM Product p JOIN Printer r ON r.model=p.model WHERE p.maker='A';

-- Exercițiul 5
SELECT maker FROM Product WHERE type='laptop' EXCEPT SELECT maker FROM Product WHERE type='pc';

-- Exercițiul 6
SELECT speed FROM PC INTERSECT SELECT speed FROM Laptop;

-- Exercițiul 7
SELECT a.model AS model1,b.model AS model2 FROM PC a JOIN PC b ON a.speed=b.speed AND a.model<b.model;

-- Exercițiul 8
SELECT DISTINCT a.maker FROM Product a JOIN Product b ON a.maker=b.maker AND a.model<b.model WHERE a.type IN ('pc','laptop') AND b.type IN ('pc','laptop');

-- Exercițiul 9
SELECT DISTINCT l.model,l.price FROM Laptop l JOIN Product pl ON pl.model=l.model JOIN Product pp ON pp.maker=pl.maker JOIN PC c ON c.model=pp.model AND l.price<c.price;

-- Exercițiul 10
SELECT model FROM PC EXCEPT SELECT a.model FROM PC a JOIN PC b ON a.price<b.price;

-- Exercițiul 11
SELECT DISTINCT p.maker FROM Product p WHERE NOT EXISTS (SELECT 1 FROM (SELECT DISTINCT type FROM Product) t WHERE NOT EXISTS (SELECT 1 FROM Product x WHERE x.maker=p.maker AND x.type=t.type));

-- Exercițiul 12
SELECT c.model AS pc_model,r.model AS printer_model FROM PC c CROSS JOIN Printer r WHERE r.color=1 AND c.price+r.price<=700;

-- Exercițiul 13
SELECT m.maker,r.model FROM (SELECT DISTINCT maker FROM Product) m LEFT JOIN (SELECT p.maker,r.model FROM Product p JOIN Printer r ON r.model=p.model) r ON r.maker=m.maker;

-- Exercițiul 14
SELECT p.maker,COUNT(*) AS nr_modele,AVG(1.0*c.price) AS pret_mediu FROM Product p JOIN PC c ON c.model=p.model GROUP BY p.maker;
