-- Exercițiul 1
SELECT DISTINCT s.nume_prenume FROM Student s WHERE EXISTS (SELECT 1 FROM Note n WHERE n.idst=s.idst);

-- Exercițiul 2
SELECT s.*,n.idcurs,n.data,n.nota FROM (SELECT * FROM Student WHERE idst=3) s JOIN Note n ON n.idst=s.idst;

-- Exercițiul 3
SELECT s.*,n.idcurs,n.data,n.nota FROM (SELECT * FROM Student WHERE grupa='IT22') s JOIN Note n ON n.idst=s.idst;

-- Exercițiul 4
SELECT s.*,n.idcurs,n.data,n.nota FROM (SELECT * FROM Student WHERE forma='buget') s JOIN (SELECT * FROM Note WHERE nota>=9) n ON n.idst=s.idst;

-- Exercițiul 5
SELECT s.*,n.idcurs,n.data,n.nota FROM Student s JOIN Note n ON s.idst=n.idst WHERE s.forma='contract' OR n.nota>=9;

-- Exercițiul 6
SELECT s.*,n.idcurs,n.data,n.nota FROM Student s JOIN Note n ON s.idst=n.idst WHERE s.forma='contract' UNION SELECT s.*,n.idcurs,n.data,n.nota FROM Student s JOIN Note n ON s.idst=n.idst WHERE n.nota>=9;

-- Exercițiul 7
SELECT DISTINCT c.denumire,n.nota FROM (SELECT denumire FROM Curs WHERE idcurs=101) c CROSS JOIN (SELECT nota FROM Note WHERE idcurs=101) n;

-- Exercițiul 8
SELECT DISTINCT c.denumire FROM Curs c WHERE EXISTS (SELECT 1 FROM Note n WHERE n.idcurs=c.idcurs);

-- Exercițiul 9
SELECT s.*,n.idcurs,n.data,n.nota,c.denumire,c.credite,c.semestru FROM Note n JOIN (SELECT * FROM Curs WHERE semestru=2) c ON c.idcurs=n.idcurs JOIN Student s ON s.idst=n.idst;

-- Exercițiul 10a
SELECT idst,idcurs,data,nota FROM Note;

-- Exercițiul 10b
SELECT s.* FROM Student s WHERE EXISTS (SELECT 1 FROM Note n WHERE n.idst=s.idst);
