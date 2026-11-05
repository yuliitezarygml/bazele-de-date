CREATE TABLE Agenti(
	CodAgent TINYINT PRIMARY KEY NOT NULL,
	NumeAgent VARCHAR(30) NOT NULL,
	DataAngajarii DATE DEFAULT SYSDATE(),
	DataNasterii DATE,
	Functia VARCHAR(30),
	CodFirma TINYINT 
	FOREIGN KEY CodFirma REFERENCES Firma(CodFirma));  
	
INSERT INTO Agenti VALUES (
	22, 'Comarov', '2022-05-15', '1998-10-10', 'Manager', 11),
	(21, 'Morit', '2024-11-20', '1999-12-11', 'Agent vanzari', 12);
	
	CREATE TABLE FostiAgenti AS
	SELECT CodAgent, NumeAgent, Functia, CodFirma
	FROM Agenti
	WHERE CodAgent = 15;

ALTER TABLE Agenti RENAME TO Personal;	
ALTER TABLE Personal ADD COLUMN(email VARCHAR(50), varsta TINYINT);


ALTER TABLE Personal ADD CONSTRAINT CV CHECK (varsta >= 18)
ALTER TABLE Personal DROP CONSTRAINT CV 
DROP TABLE FostiAgenti;

	CREATE TABLE Salariati AS
	SELECT *
	FROM angajati
	WHERE id_angajat = 15;

INSERT INTO Salariati 
	SELECT *
	FROM angajati
	WHERE id_departament IN (20,30,50);	
	
	UPDATE  Salariati set salariu = salariu + 1000
	WHERE salariu < 3000;
	 
	 
	 SELECT id_angajat, prenume, nume,id_manager, salariu
	 FROM Salariati
	 WHERE id_angajat = 125 OR id_manager = 122;
	 
	 
	UPDATE  Salariati set salariu = (SELECT salariu 
												FROM Salariati
												WHERE id_angajat = 125) 
	WHERE id_manager = 122;
	
	SELECT prenume, nume, salariu
	FROM Salariati
	WHERE id_manager = 122;
	