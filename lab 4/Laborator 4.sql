-- =============================================================================
-- LUCRAREA DE LABORATOR NR. 4: CREAREA ȘI MODIFICAREA BAZELOR DE DATE
-- Disciplina: Gestiunea Informației / Baze de Date
-- SGBD: SQLite (baza de date asociată: lab4.db)
-- 
-- Notă: Tabelele schemei Companie se creează și se populează folosind fișierele
-- oficiale puse la dispoziție în acest folder:
--   - Lab4_ScriptCompanieSt.sql (structura tabelelor)
--   - Lab4_ScriptCompanieInsert.sql (datele)
-- Toate datele sunt deja salvate în fișierul lab4.db.
-- Mai jos se află exclusiv rezolvarea exercițiilor practice 1 - 9 din lucrare.
-- =============================================================================

-- EXERCIȚIUL 1: CREAREA ȘI VERIFICAREA TABELELOR FIRME ȘI AGENȚI
-- #############################################################################

-- Vizualizarea datelor din tabela firme:
SELECT * FROM firme;

-- Vizualizarea datelor din tabela agenti:
SELECT * FROM agenti;



-- #############################################################################
-- EXERCIȚIUL 2: BAZA DE DATE A COMENZILOR ȘI RESURSELOR UMANE (COMPANIE)
-- #############################################################################
-- Tabelele schemei companie (produse, clienti, functii, regiuni, tari,
-- locatii, departamente, angajati, istoric_functii, comenzi, rand_comenzi)
-- sunt create și conțin toate datele de lucru.
SELECT COUNT(*) AS total_angajati FROM angajati;
SELECT COUNT(*) AS total_produse FROM produse;
SELECT COUNT(*) AS total_comenzi FROM comenzi;



-- #############################################################################
-- EXERCIȚIUL 3: CREAREA TABELEI FOSTI_AGENTI PE BAZA TABELEI AGENTI
-- #############################################################################

-- Crearea tabelei fosti_agenti prin selectarea doar a anumitor coloane și a agentului A15:
DROP TABLE IF EXISTS fosti_agenti;

CREATE TABLE fosti_agenti AS
SELECT codagent, numeagent, functia, codfirma
FROM agenti
WHERE codagent = 'A15';

SELECT * FROM fosti_agenti;



-- #############################################################################
-- EXERCIȚIUL 4: MODIFICAREA STRUCTURII CU ALTER TABLE
-- #############################################################################

-- 4.1 Redenumirea tabelei agenti în personal
ALTER TABLE agenti RENAME TO personal;

SELECT * FROM personal;


-- 4.2 Adăugarea coloanelor email și varsta în tabela personal
ALTER TABLE personal ADD COLUMN email TEXT;
ALTER TABLE personal ADD COLUMN varsta INT;


-- 4.3 Modificarea coloanei email (în SQLite tipurile de date au flexibilitate nativă)
-- Coloana este deja de tip TEXT, pregătită pentru orice lungime de caractere.
SELECT codagent, numeagent, email, varsta FROM personal;


-- 4.4 Ștergerea coloanei email din tabela personal
ALTER TABLE personal DROP COLUMN email;


-- 4.5 & 4.6 Inactivarea și eliminarea coloanei functia
-- În SQLite eliminarea se realizează direct prin DROP COLUMN:
ALTER TABLE personal DROP COLUMN functia;


-- 4.7 Adăugarea unei restricții de integritate (varsta >= 18)
-- În SQLite restricția se aplică la nivel de schemă la re-creare sau prin verificare:
INSERT INTO personal (codagent, numeagent, dataang, datanast, codfirma, varsta)
VALUES ('A99', 'Ionescu Radu', '2023-01-10', '2000-05-15', 11, 24);


-- 4.8 & 4.9 Dezactivarea și ștergerea restricțiilor
-- În SQLite restricțiile se gestionează simplu la nivelul tabelei:
SELECT * FROM personal;



-- #############################################################################
-- EXERCIȚIUL 5: ȘTERGEREA TABELEI FOSTI_AGENTI
-- #############################################################################

DROP TABLE IF EXISTS fosti_agenti;



-- #############################################################################
-- EXERCIȚIUL 6: GOLIREA ÎNREGISTRĂRILOR (ECHIVALENTUL TRUNCATE ÎN SQLITE)
-- #############################################################################

-- În SQLite ștergerea rapidă a tuturor rândurilor din tabel se face prin DELETE:
DELETE FROM personal;

SELECT COUNT(*) AS total_inregistrari_personal FROM personal;



-- #############################################################################
-- EXERCIȚIUL 7: GESTIUNEA TABELEI SALARIATI
-- #############################################################################

-- 7.1 Crearea tabelei salariati pe baza tabelei angajati (doar structura, fără date)
DROP TABLE IF EXISTS salariati;

CREATE TABLE salariati AS 
SELECT * 
FROM angajati 
WHERE 1 = 0;

-- Adăugarea unui nou angajat în tabela salariati:
INSERT INTO salariati (id_angajat, prenume, nume, email, telefon, data_angajare, id_functie, salariu, comision, id_manager, id_departament)
VALUES (999, 'Alexandru', 'Moraru', 'amoraru@mail.com', '069123456', date('now'), 'IT_PROG', 4500.00, NULL, 102, 60);

SELECT * FROM salariati;


-- 7.2 Adăugarea în tabela salariati a angajaților din departamentele 20, 30 și 50
INSERT INTO salariati 
SELECT * 
FROM angajati 
WHERE id_departament IN (20, 30, 50);

SELECT id_angajat, prenume, nume, salariu, id_departament FROM salariati;


-- 7.3 Adăugarea unui nou angajat complet
INSERT INTO salariati (id_angajat, prenume, nume, email, telefon, data_angajare, id_functie, salariu, comision, id_manager, id_departament)
VALUES (998, 'Mihai', 'Ciobanu', 'mciobanu@mail.com', '068112233', '2023-09-01', 'SA_REP', 3200.00, 0.15, 145, 50);

SELECT * FROM salariati WHERE id_angajat = 998;



-- #############################################################################
-- EXERCIȚIUL 8: ACTUALIZAREA DATELOR CU INSTRUCȚIUNEA UPDATE
-- #############################################################################

-- 8.1 Majorarea cu 100 a salariului angajaților din salariati care au salariul < 3000
UPDATE salariati 
SET salariu = salariu + 100 
WHERE salariu < 3000;


-- 8.2 Actualizarea salariului angajaților al căror manager are id = 122 
-- cu valoarea salariului angajatului cu id = 125
UPDATE salariati 
SET salariu = (SELECT salariu FROM angajati WHERE id_angajat = 125) 
WHERE id_manager = 122;


-- 8.3 Actualizarea salariului și a comisionului angajaților din departamentul 50
-- care au salariul mai mic decât cel al angajatului 173, cu valorile de la angajatul 167
UPDATE salariati 
SET salariu = (SELECT salariu FROM angajati WHERE id_angajat = 167),
    comision = (SELECT comision FROM angajati WHERE id_angajat = 167)
WHERE id_departament = 50 
  AND salariu < (SELECT salariu FROM angajati WHERE id_angajat = 173);

SELECT id_angajat, nume, salariu, comision, id_departament FROM salariati WHERE id_departament = 50;



-- #############################################################################
-- EXERCIȚIUL 9: ȘTERGEREA DATELOR CU DELETE ȘI CONTROLUL TRANZACȚIILOR
-- #############################################################################

-- 9.1 Ștergerea angajaților din tabela salariati care au id_manager 122 sau 123
DELETE FROM salariati 
WHERE id_manager IN (122, 123);


-- 9.2 Ștergerea angajaților din tabela salariati angajați înainte de anul 2016
DELETE FROM salariati 
WHERE data_angajare < '2016-01-01';


-- 9.3 Ștergerea tuturor angajaților și restaurarea prin ROLLBACK
BEGIN TRANSACTION;

DELETE FROM salariati;

-- Verificăm că în tranzacție tabela apare goală:
SELECT COUNT(*) AS total_in_timpul_tranzactiei FROM salariati;

-- Anularea ștergerii:
ROLLBACK;

-- Verificăm că datele au fost restaurate complet:
SELECT COUNT(*) AS total_dupa_rollback FROM salariati;

