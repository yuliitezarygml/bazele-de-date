-- =============================================================================
-- LUCRAREA DE LABORATOR NR. 5: INTEROGAREA BAZELOR DE DATE
-- Disciplina: Gestiunea Informației / Baze de Date
-- SGBD: SQLite (utilizând baza de date companie.db creată la Laboratorul 4)
-- 
-- Notă: Toate interogările extrag datele direct din fișierul local companie.db.
-- Puteți selecta oricare exercițiu și să rulați selecția direct în VS Code!
-- =============================================================================

-- SECȚIUNEA 1: INTEROGĂRI SIMPLE (EXERCIȚIILE 1 - 13)
-- #############################################################################

-- Exercitiul 1: Se va executa cu succes interogarea?
-- Răspuns: NU (coloana este 'salariu', nu 'salariul'). Interogarea corectată:
SELECT nume, id_functie, salariu AS sal 
FROM angajati;


-- Exercitiul 2: Se va executa cu succes interogarea?
-- Răspuns: DA (tabela departamente există).
SELECT * 
FROM departamente;


-- Exercitiul 3: Se va executa cu succes interogarea SELECT * FROM Salariu?
-- Răspuns: NU (nu există tabela Salariu în baza de date).
-- SELECT * FROM Salariu;


-- Exercitiul 4: Corectarea celor 4 erori din SELECT id_angajat, nume sal x 12 salariu anual FROM Angajati;
-- 1. Lipsă virgulă după nume | 2. Coloana este salariu (nu sal) | 3. Operatorul este * (nu x) | 4. Alias cu ghilimele
SELECT id_angajat, nume, salariu * 12 AS "Salariu anual" 
FROM angajati;


-- Exercitiul 5: Structura și conținutul tabelului Departamente
PRAGMA table_info(departamente);

SELECT * 
FROM departamente;


-- Exercitiul 6: Structura tabelului Angajați
PRAGMA table_info(angajati);


-- Exercitiul 7: Atributele: id_angajat (primul), nume, id_functie, data_angajare ("Lucrează din")
SELECT id_angajat, nume, id_functie, data_angajare AS "Lucrează din" 
FROM angajati;


-- Exercitiul 8: Redenumirea atributelor cu aliasuri în limba română
SELECT id_angajat AS "Identificatorul", 
       nume AS "Numele angajatului", 
       id_functie AS "Funcția", 
       data_angajare AS "Data angajarii" 
FROM angajati;


-- Exercitiul 9: Lista funcțiilor din Angajați (cu și fără duplicate)
-- Cu duplicate:
SELECT id_functie 
FROM angajati;

-- Fără duplicate:
SELECT DISTINCT id_functie 
FROM angajati;


-- Exercitiul 10: Numele concatenat cu funcția, separate prin virgulă și spațiu ("Angajat și funcție")
-- În SQLite concatenarea se realizează cu operatorul ||:
SELECT nume || ', ' || id_functie AS "Angajat și funcție" 
FROM angajati;


-- Exercitiul 11: Toate coloanele concatenate separate prin virgulă ("Informatii complete")
SELECT id_angajat || ', ' || prenume || ', ' || nume || ', ' || email || ', ' || telefon || ', ' || data_angajare || ', ' || id_functie || ', ' || salariu AS "Informatii complete" 
FROM angajati;


-- Exercitiul 12: Selectarea tuturor angajaților
SELECT * 
FROM angajati;


-- Exercitiul 13: Selectarea coloanelor id_angajat, nume, prenume, id_functie
SELECT id_angajat, nume, prenume, id_functie 
FROM angajati;



-- #############################################################################
-- SECȚIUNEA 2: CLAUZA WHERE, OPERATORI LOGICI ȘI SORTARE (EXERCIȚIILE 14 - 33)
-- #############################################################################

-- Exercitiul 14: Salariații care câștigă peste 12000 $
SELECT nume, salariu 
FROM angajati 
WHERE salariu > 12000;


-- Exercitiul 15: Numele și numărul departamentului pentru angajatul cu id = 176
SELECT nume, id_departament 
FROM angajati 
WHERE id_angajat = 176;


-- Exercitiul 16: Salariații al căror salariu NU se află în intervalul 5000 - 12000 $
SELECT nume, salariu 
FROM angajati 
WHERE salariu NOT BETWEEN 5000 AND 12000;


-- Exercitiul 17: Angajații cu numele Matos și Taylor, ordonați după data angajării
SELECT nume, id_functie, data_angajare 
FROM angajati 
WHERE nume IN ('Matos', 'Taylor') 
ORDER BY data_angajare ASC;


-- Exercitiul 18: Salariații din departamentele 20 și 50, ordonați alfabetic după nume
SELECT nume, id_departament 
FROM angajati 
WHERE id_departament IN (20, 50) 
ORDER BY nume ASC;


-- Exercitiul 19: Nume și salariu (între 5000 și 12000 $) din departamentul 20 sau 50
SELECT nume AS "Angajat", salariu AS "Salariu_lunar" 
FROM angajati 
WHERE (salariu BETWEEN 5000 AND 12000) 
  AND id_departament IN (20, 50);


-- Exercitiul 20: Angajați între 20 Februarie 1987 și 1 Mai 1989, ordonat crescător după dată
SELECT nume, id_functie, data_angajare 
FROM angajati 
WHERE data_angajare BETWEEN '1987-02-20' AND '1989-05-01' 
ORDER BY data_angajare ASC;


-- Exercitiul 21: Salariați angajați în anul 1994 (extragere an din dată)
SELECT nume, data_angajare 
FROM angajati 
WHERE strftime('%Y', data_angajare) = '1994';


-- Exercitiul 22: Angajații fără manager (IS NULL)
SELECT nume, id_functie 
FROM angajati 
WHERE id_manager IS NULL;


-- Exercitiul 23: Salariații cu comision, ordonați descrescător după salariu și comision
SELECT nume, salariu, comision 
FROM angajati 
WHERE comision IS NOT NULL AND comision > 0 
ORDER BY salariu DESC, comision DESC;


-- Exercitiul 24: Eliminarea clauzei WHERE și comportamentul valorilor NULL la sortare descrescătoare
-- În SQLite valorile NULL sunt considerate cele mai mici, deci apar ultimele la ORDER BY DESC:
SELECT nume, salariu, comision 
FROM angajati 
ORDER BY salariu DESC, comision DESC;


-- Exercitiul 25: Numele angajaților care conțin literele 'a' și 'e'
SELECT nume 
FROM angajati 
WHERE LOWER(nume) LIKE '%a%' 
  AND LOWER(nume) LIKE '%e%';


-- Exercitiul 26: Numele tuturor angajaților care au a treia literă din nume 'A'
SELECT nume 
FROM angajati 
WHERE UPPER(nume) LIKE '__A%';


-- Exercitiul 27: Angajații cu două litere 'L' în nume și (departamentul 30 sau manager 101)
SELECT nume, id_departament, id_manager 
FROM angajati 
WHERE UPPER(nume) LIKE '%L%L%' 
  AND (id_departament = 30 OR id_manager = 101);


-- Exercitiul 28: Funcția conține 'clerk' sau 'rep', iar salariul nu este 2500, 3500 sau 7000
SELECT nume, id_functie, salariu 
FROM angajati 
WHERE (LOWER(id_functie) LIKE '%clerk%' OR LOWER(id_functie) LIKE '%rep%') 
  AND salariu NOT IN (2500, 3500, 7000);


-- Exercitiul 29: Salariul mai mare decât comisionul mărit de 5 ori (salariu > (salariu * comision) * 5)
SELECT nume, salariu, comision 
FROM angajati 
WHERE comision IS NOT NULL 
  AND salariu > ((salariu * comision) * 5);


-- Exercitiul 30: Angajații din categoria funcționari (id_functie conține 'CLERK')
SELECT * 
FROM angajati 
WHERE UPPER(id_functie) LIKE '%CLERK%';


-- Exercitiul 31: Comenzile încheiate de angajatul cu id_angajat = 161
SELECT * 
FROM comenzi 
WHERE id_angajat = 161;


-- Exercitiul 32: Comenzile lansate online după 1 ianuarie 2000
SELECT * 
FROM comenzi 
WHERE LOWER(modalitate) = 'online' 
  AND data_comanda > '2000-01-01';


-- Exercitiul 33: Joncțiunea angajați cu departamente
SELECT a.id_angajat, a.nume, a.prenume, a.id_manager, a.id_departament, d.denumire_departament 
FROM angajati a 
JOIN departamente d ON a.id_departament = d.id_departament;



-- #############################################################################
-- SECȚIUNEA 3: FUNCȚII SQL (ȘIRURI, NUMERICE, DATE CALENDARISTICE) (EX 34 - 54)
-- #############################################################################

-- Exercitiul 34: Data curentă în formate diferite în SQLite
SELECT datetime('now') AS "Data curenta", 
       strftime('%d-%m-%Y', 'now') AS "Format zi-luna-an", 
       strftime('%Y-%m-%d %H:%M:%S', 'now') AS "Format ISO";


-- Exercitiul 35: Salariul mărit cu 15.5% (rotunjit) - coloana "Salariu majorat"
SELECT id_angajat, nume, salariu, 
       ROUND(salariu * 1.155) AS "Salariu majorat" 
FROM angajati;


-- Exercitiul 36: Adăugarea coloanei "Majorare" (salariul nou - salariul vechi)
SELECT id_angajat, nume, salariu, 
       ROUND(salariu * 1.155) AS "Salariu majorat",
       ROUND(salariu * 1.155) - salariu AS "Majorare" 
FROM angajati;


-- Exercitiul 37: Numele cu majuscule (începe cu J, A, M) și lungimea numelui
SELECT UPPER(nume) AS "Nume majuscule", 
       LENGTH(nume) AS "Lungime nume" 
FROM angajati 
WHERE UPPER(nume) LIKE 'J%' 
   OR UPPER(nume) LIKE 'A%' 
   OR UPPER(nume) LIKE 'M%' 
ORDER BY nume ASC;


-- Exercitiul 38: Text compus cu operatorul de concatenare ||:
SELECT prenume || ' ' || nume || ' castiga ' || salariu || ' lunar dar doreste ' || (salariu * 3) AS "Salariu ideal" 
FROM angajati;


-- Exercitiul 39: Prenume cu inițială mare, nume cu majuscule, lungimea numelui
SELECT UPPER(SUBSTR(prenume, 1, 1)) || LOWER(SUBSTR(prenume, 2)) AS "Prenume", 
       UPPER(nume) AS "Nume", 
       LENGTH(nume) AS "Lungime" 
FROM angajati 
WHERE UPPER(nume) LIKE 'J%' 
   OR UPPER(nume) LIKE 'M%' 
   OR UPPER(nume) LIKE '__A%' 
ORDER BY LENGTH(nume) DESC;


-- Exercitiul 40: Angajații cu prenumele 'Steven' (case-insensitive, eliminare spații)
SELECT id_angajat, nume, id_departament 
FROM angajati 
WHERE UPPER(TRIM(prenume)) = 'STEVEN';


-- Exercitiul 41: Nume terminat cu 'e', lungimea numelui și prima apariție a literei 'a'
SELECT id_angajat, nume, 
       LENGTH(nume) AS "Lungime nume", 
       INSTR(LOWER(nume), 'a') AS "Pozitie prima litera a" 
FROM angajati 
WHERE LOWER(nume) LIKE '%e';


-- Exercitiul 42: Salariații care au lucrat un număr întreg de săptămâni (rest 0 la împărțire cu 7)
SELECT id_angajat, nume, data_angajare 
FROM angajati 
WHERE CAST((julianday('now') - julianday(data_angajare)) AS INT) % 7 = 0;


-- Exercitiul 43: Salariul mărit cu 15% și numărul de sute, pentru salarii nedivizibile cu 1000
SELECT id_angajat, nume, salariu, 
       ROUND(salariu * 1.15, 2) AS "Salariu nou", 
       CAST((salariu * 1.15) / 100 AS INT) AS "Numar sute" 
FROM angajati 
WHERE salariu % 1000 != 0;


-- Exercitiul 44: Numele și data angajării celor cu comision, formatate cu lățime fixă (printf)
SELECT printf('%-20s', nume) AS "Nume angajat", 
       printf('%-15s', data_angajare) AS "Data angajarii" 
FROM angajati 
WHERE comision IS NOT NULL AND comision > 0;


-- Exercitiul 45: Numărul de luni lucrate de la angajare (MONTHS_WORKED)
SELECT nume, 
       CAST((julianday('now') - julianday(data_angajare)) / 30.4375 AS INT) AS MONTHS_WORKED 
FROM angajati 
ORDER BY MONTHS_WORKED DESC;


-- Exercitiul 46: Data de peste 30 de zile
SELECT datetime('now', '+30 days') AS "Peste 30 zile";


-- Exercitiul 47: Numărul de zile rămase până la sfârșitul anului curent
SELECT CAST(julianday(strftime('%Y', 'now') || '-12-31') - julianday('now') AS INT) AS "Zile pana la sfarsitul anului";


-- Exercitiul 48: Data de peste 12 ore și peste 5 minute
SELECT datetime('now', '+12 hours') AS "Peste 12 ore", 
       datetime('now', '+5 minutes') AS "Peste 5 minute";


-- Exercitiul 49: Nume și prenume, data angajării și data negocierii (prima zi de Luni după 6 luni)
SELECT prenume || ' ' || nume AS "Angajat", 
       data_angajare, 
       date(data_angajare, '+6 months', 'weekday 1') AS "Negociere" 
FROM angajati;


-- Exercitiul 50: Numele și numărul de luni de la data angajării ("Luni lucrate")
SELECT nume, 
       ROUND((julianday('now') - julianday(data_angajare)) / 30.4375) AS "Luni lucrate" 
FROM angajati 
ORDER BY "Luni lucrate" DESC;


-- Exercitiul 51: Numele, data angajării și ziua săptămânii ("Zi"), ordonat începând cu Luni
SELECT nume, data_angajare, 
       CASE strftime('%w', data_angajare) 
            WHEN '0' THEN 'Duminica' 
            WHEN '1' THEN 'Luni' 
            WHEN '2' THEN 'Marti' 
            WHEN '3' THEN 'Miercuri' 
            WHEN '4' THEN 'Joi' 
            WHEN '5' THEN 'Vineri' 
            WHEN '6' THEN 'Sambata' 
       END AS "Zi" 
FROM angajati 
ORDER BY ((CAST(strftime('%w', data_angajare) AS INT) + 6) % 7);


-- Exercitiul 52: Numele și comisionul; dacă e NULL se afișează "Fara comision"
SELECT nume, 
       IFNULL(CAST(comision AS TEXT), 'Fara comision') AS "Comision" 
FROM angajati;


-- Exercitiul 53: Salariații al căror venit total depășește 10000 $
SELECT nume, salariu, comision 
FROM angajati 
WHERE (salariu + (salariu * IFNULL(comision, 0))) > 10000;


-- Exercitiul 54: Mărirea de salariu condiționată (CASE) - coloana "Salariu renegociat"
SELECT nume, id_functie, salariu, 
       CASE id_functie 
            WHEN 'IT_PROG' THEN salariu * 1.20 
            WHEN 'SA_REP'  THEN salariu * 1.25 
            WHEN 'SA_MAN'  THEN salariu * 1.35 
            ELSE salariu 
       END AS "Salariu renegociat" 
FROM angajati;



-- #############################################################################
-- SECȚIUNEA 4: SUBINTEROGĂRI ȘI JONCȚIUNI COMPLEXE (EXERCIȚIILE 55 - 75)
-- #############################################################################

-- Exercitiul 55: Angajații cu salariu mai mic decât oricare din IT_PROG (adică < MAX)
SELECT id_angajat, prenume, id_functie, salariu 
FROM angajati 
WHERE id_functie != 'IT_PROG' 
  AND salariu < (
      SELECT MAX(salariu) 
      FROM angajati 
      WHERE id_functie = 'IT_PROG'
  );


-- Exercitiul 56: Angajații cu salariu mai mic decât fiecare din IT_PROG (adică < MIN)
SELECT id_angajat, prenume, id_functie, salariu 
FROM angajati 
WHERE id_functie != 'IT_PROG' 
  AND salariu < (
      SELECT MIN(salariu) 
      FROM angajati 
      WHERE id_functie = 'IT_PROG'
  );


-- Exercitiul 57: Comenzile încheiate de angajați
SELECT c.numar_comanda, c.data_comanda, c.modalitate, a.id_angajat, a.nume, a.prenume 
FROM comenzi c 
JOIN angajati a ON c.id_angajat = a.id_angajat;


-- Exercitiul 58: Comenzile încheiate de angajatul Greene în luna noiembrie (luna 11)
SELECT c.numar_comanda, c.data_comanda, a.nume 
FROM comenzi c 
JOIN angajati a ON c.id_angajat = a.id_angajat 
WHERE a.nume = 'Greene' 
  AND strftime('%m', c.data_comanda) = '11';


-- Exercitiul 59: Valoarea produselor comandate (cantitate * preț)
SELECT p.denumire_produs, rc.pret, rc.cantitate, 
       (rc.cantitate * rc.pret) AS valoare 
FROM rand_comenzi rc 
JOIN produse p ON rc.id_produs = p.id_produs;


-- Exercitiul 60: Doar produsele cu valoarea cuprinsă între 1000 și 2000
SELECT p.denumire_produs, rc.pret, rc.cantitate, 
       (rc.cantitate * rc.pret) AS valoare 
FROM rand_comenzi rc 
JOIN produse p ON rc.id_produs = p.id_produs 
WHERE (rc.cantitate * rc.pret) BETWEEN 1000 AND 2000;


-- Exercitiul 61: Joncțiune externă (LEFT JOIN) - toate produsele, chiar dacă nu au fost comandate
SELECT p.id_produs, p.denumire_produs, rc.cantitate 
FROM produse p 
LEFT JOIN rand_comenzi rc ON p.id_produs = rc.id_produs;


-- Exercitiul 62: Numele angajatului și numele șefului direct (self-join)
SELECT a.nume AS "Nume Angajat", 
       m.nume AS "Nume Sef Direct" 
FROM angajati a 
JOIN angajati m ON a.id_manager = m.id_angajat;


-- Exercitiul 63: Angajații care sunt în același departament cu Smith
SELECT nume, prenume, id_departament 
FROM angajati 
WHERE id_departament = (
    SELECT id_departament 
    FROM angajati 
    WHERE nume = 'Smith'
) 
AND nume != 'Smith';


-- Exercitiul 64: Produsele cu prețul de listă cel mai mic
SELECT id_produs, denumire_produs, pret_lista 
FROM produse 
WHERE pret_lista = (
    SELECT MIN(pret_lista) 
    FROM produse
);


-- Exercitiul 65: Numele salariatului, codul și numele departamentului
SELECT a.nume, a.id_departament, d.denumire_departament 
FROM angajati a 
LEFT JOIN departamente d ON a.id_departament = d.id_departament;


-- Exercitiul 66: Titlurile funcțiilor prezente în departamentul 30
SELECT DISTINCT f.denumire_functie 
FROM angajati a 
JOIN functii f ON a.id_functie = f.id_functie 
WHERE a.id_departament = 30;


-- Exercitiul 67: Numele salariatului, departamentul și orașul pentru cei cu comision
SELECT a.nume, d.denumire_departament, l.oras 
FROM angajati a 
JOIN departamente d ON a.id_departament = d.id_departament 
JOIN locatii l ON d.id_locatie = l.id_locatie 
WHERE a.comision IS NOT NULL AND a.comision > 0;


-- Exercitiul 68: Numele salariaților și departamentul pentru cei cu litera 'A' în nume
SELECT a.nume, d.denumire_departament 
FROM angajati a 
JOIN departamente d ON a.id_departament = d.id_departament 
WHERE UPPER(a.nume) LIKE '%A%';


-- Exercitiul 69: Numele, funcția, departamentul pentru salariații din Oxford
SELECT a.nume, a.id_functie, a.id_departament, d.denumire_departament 
FROM angajati a 
JOIN departamente d ON a.id_departament = d.id_departament 
JOIN locatii l ON d.id_locatie = l.id_locatie 
WHERE UPPER(l.oras) = 'OXFORD';


-- Exercitiul 70: Cod angajat, nume angajat, cod manager, nume manager
SELECT a.id_angajat AS "Ang#", 
       a.nume AS "Angajat", 
       m.id_angajat AS "Mgr#", 
       m.nume AS "Manager" 
FROM angajati a 
JOIN angajati m ON a.id_manager = m.id_angajat;


-- Exercitiul 71: Toți angajații, inclusiv cei fără șef (LEFT JOIN)
SELECT a.id_angajat AS "Ang#", 
       a.nume AS "Angajat", 
       m.id_angajat AS "Mgr#", 
       m.nume AS "Manager" 
FROM angajati a 
LEFT JOIN angajati m ON a.id_manager = m.id_angajat;


-- Exercitiul 72: Numele angajatului, departamentul și colegii din același departament
SELECT a.nume AS "Angajat", 
       a.id_departament AS "Dept", 
       c.nume AS "Coleg Departament" 
FROM angajati a 
JOIN angajati c ON a.id_departament = c.id_departament 
WHERE a.id_angajat != c.id_angajat 
ORDER BY a.id_departament, a.nume;


-- Exercitiul 73: Informații complete angajat: nume, funcție, denumire funcție, departament, salariu
SELECT a.nume, a.id_functie, f.denumire_functie, d.denumire_departament, a.salariu 
FROM angajati a 
JOIN functii f ON a.id_functie = f.id_functie 
LEFT JOIN departamente d ON a.id_departament = d.id_departament;


-- Exercitiul 74: Salariații angajați DUPĂ Gates
SELECT nume, data_angajare 
FROM angajati 
WHERE data_angajare > (
    SELECT data_angajare 
    FROM angajati 
    WHERE nume = 'Gates'
);


-- Exercitiul 75: Salariații angajați ÎNAINTEA șefilor lor direcți
SELECT a.nume AS "Angajat", 
       a.data_angajare AS "Data_ang", 
       m.nume AS "Manager", 
       m.data_angajare AS "Data_mgr" 
FROM angajati a 
JOIN angajati m ON a.id_manager = m.id_angajat 
WHERE a.data_angajare < m.data_angajare;

