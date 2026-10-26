-- =============================================================================
-- LUCRAREA DE LABORATOR NR. 5: INTEROGAREA BAZELOR DE DATE
-- Disciplina: Gestiunea Informației / Baze de Date
-- Baza de date: Creată în cadrul Lucrării de laborator nr. 4 (Schema Angajati / HR)
-- =============================================================================

-- =============================================================================
-- CAPITOLUL 1: INTEROGĂRI SIMPLE (Exercițiile 1 - 13)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 1:
-- Se va executa cu succes următoarea interogare?
-- SELECT nume, id_functie, salariul AS sal FROM Angajati;
-- Răspuns: NU
-- Explicație: Numele coloanei în tabelul Angajati este 'salariu', nu 'salariul'.
-- Interogarea corectată:
-- -----------------------------------------------------------------------------
SELECT nume, id_functie, salariu AS sal
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 2:
-- Se va executa cu succes următoarea interogare?
-- SELECT * FROM Departamente;
-- Răspuns: DA
-- Explicație: Tabela 'Departamente' există în baza de date, iar sintaxa este corectă.
-- -----------------------------------------------------------------------------
SELECT * 
FROM Departamente;


-- -----------------------------------------------------------------------------
-- Exercițiul 3:
-- Se va executa cu succes următoarea interogare?
-- SELECT * FROM Salariu;
-- Răspuns: NU
-- Explicație: Nu există tabelul 'Salariu' (salariul este un atribut în tabela Angajati).
-- -----------------------------------------------------------------------------


-- -----------------------------------------------------------------------------
-- Exercițiul 4:
-- În interogarea de mai jos sunt 4 erori, determinați-le și corijați-le:
-- SELECT id_angajat, nume
-- sal x 12 salariu anual
-- FROM Angajati;
--
-- Erori identificate:
-- 1. Lipsește virgula ',' după atributul 'nume'.
-- 2. Atributul este 'salariu', nu 'sal'.
-- 3. Operatorul aritmetic de multiplicare este '*', nu 'x'.
-- 4. Alias-ul compus conține spațiu ("salariu anual") și trebuie încadrat între ghilimele duble.
-- -----------------------------------------------------------------------------
SELECT id_angajat, nume, salariu * 12 AS "salariu anual"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 5:
-- Afișați structura tabelului Departamente. Afișați conținutul acestui tabel.
-- -----------------------------------------------------------------------------
-- Structura tabelului:
DESCRIBE Departamente;

-- Conținutul tabelului:
SELECT * 
FROM Departamente;


-- -----------------------------------------------------------------------------
-- Exercițiul 6:
-- Afișează structura tabelului Angajați.
-- -----------------------------------------------------------------------------
DESCRIBE Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 7:
-- Afișează nume, id_funcție, data_angajare și id_angajat din tabelul Angajați.
-- Atributul id_angajat trebuie să fie primul în tabelul rezultat.
-- Pentru atributul data_angajare adăugați aliasul „Lucrează din”.
-- (Salvat și în fișierul lab5_ex7.sql)
-- -----------------------------------------------------------------------------
SELECT 
    id_angajat, 
    nume, 
    id_functie, 
    data_angajare AS "Lucrează din"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 8:
-- Afișați date din tabelul Angajați astfel încât:
-- id_angajat -> Identificatorul
-- nume -> Numele angajatului
-- id_funcție -> Funcția
-- data_angajare -> Data angajarii
-- -----------------------------------------------------------------------------
SELECT 
    id_angajat AS "Identificatorul",
    nume AS "Numele angajatului",
    id_functie AS "Funcția",
    data_angajare AS "Data angajarii"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 9:
-- Afișează lista identificatorilor funcțiilor din tabelul Angajați.
-- Dați 2 soluții: cu și fără duplicate.
-- -----------------------------------------------------------------------------
-- Soluția 1: Cu duplicate
SELECT id_functie 
FROM Angajati;

-- Soluția 2: Fără duplicate
SELECT DISTINCT id_functie 
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 10:
-- Să se afișeze numele angajatului concatenat cu identificatorul funcției,
-- separate prin virgulă și spațiu, etichetat cu coloana "Angajat și funcție".
-- -----------------------------------------------------------------------------
SELECT nume || ', ' || id_functie AS "Angajat și funcție"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 11:
-- Creați o cerere prin care să se afișeze toate datele din tabelul Angajați,
-- separate prin virgulă. Denumiți coloana "Informatii complete".
-- -----------------------------------------------------------------------------
SELECT 
    id_angajat || ', ' || 
    prenume || ', ' || 
    nume || ', ' || 
    email || ', ' || 
    numar_telefon || ', ' || 
    data_angajare || ', ' || 
    id_functie || ', ' || 
    salariu || ', ' || 
    NVL(TO_CHAR(comision), 'null') || ', ' || 
    NVL(TO_CHAR(id_manager), 'null') || ', ' || 
    NVL(TO_CHAR(id_departament), 'null') AS "Informatii complete"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 12:
-- Să se selecteze toți angajații din tabela Angajați.
-- -----------------------------------------------------------------------------
SELECT * 
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 13:
-- Să se selecteze coloanele id_angajat, nume, prenume și id_functie din tabela Angajați.
-- -----------------------------------------------------------------------------
SELECT id_angajat, nume, prenume, id_functie 
FROM Angajati;



-- =============================================================================
-- CAPITOLUL 2: CLAUZA WHERE ȘI ORDER BY. OPERATORI DE FILTRARE (Exercițiile 14 - 33)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 14:
-- Să se afișeze numele și salariul angajaților care câștigă mai mult de 12000 $.
-- (Salvat și în fișierul lab5_ex12.sql)
-- -----------------------------------------------------------------------------
SELECT nume, salariu
FROM Angajati
WHERE salariu > 12000;


-- -----------------------------------------------------------------------------
-- Exercițiul 15:
-- Să se creeze o cerere pentru a afișa numele angajatului și numărul departamentului
-- pentru angajatul cu identificatorul 176.
-- -----------------------------------------------------------------------------
SELECT nume, id_departament
FROM Angajati
WHERE id_angajat = 176;


-- -----------------------------------------------------------------------------
-- Exercițiul 16:
-- Să se afișeze numele și salariul pentru toți angajații al căror salariu nu se află
-- în domeniul 5000-12000$.
-- -----------------------------------------------------------------------------
SELECT nume, salariu
FROM Angajati
WHERE salariu NOT BETWEEN 5000 AND 12000;


-- -----------------------------------------------------------------------------
-- Exercițiul 17:
-- Să se creeze o cerere care ar afișa numele, funcția și data angajării a angajaților
-- cu numele Matos și Taylor. Ordonați rezultatele după dată.
-- -----------------------------------------------------------------------------
SELECT nume, id_functie, data_angajare
FROM Angajati
WHERE nume IN ('Matos', 'Taylor')
ORDER BY data_angajare ASC;


-- -----------------------------------------------------------------------------
-- Exercițiul 18:
-- Să se afișeze numele și departamentul (identificatorul) tuturor salariaților
-- din departamentul 20 și 50, ordonați în ordine alfabetică după nume.
-- -----------------------------------------------------------------------------
SELECT nume, id_departament
FROM Angajati
WHERE id_departament IN (20, 50)
ORDER BY nume ASC;


-- -----------------------------------------------------------------------------
-- Exercițiul 19:
-- Să se modifice lab5_ex12.sql astfel încât să afișeze numele și salariul angajaților
-- care câștigă între 5000-12000$ și care lucrează sau în departamentul 20, sau 50.
-- Etichetați câmpurile cu Angajat și Salariu_lunar.
-- (Salvat și în fișierul lab5_ex17.sql)
-- -----------------------------------------------------------------------------
SELECT 
    nume AS "Angajat", 
    salariu AS "Salariu_lunar"
FROM Angajati
WHERE (salariu BETWEEN 5000 AND 12000)
  AND id_departament IN (20, 50);


-- -----------------------------------------------------------------------------
-- Exercițiul 20:
-- Să se afișeze numele, funcția și data la care au început lucrul salariații angajați
-- între 20 Februarie 1987 și 1 Mai 1989. Rezultatul va fi ordonat crescător după data de început.
-- -----------------------------------------------------------------------------
SELECT nume, id_functie, data_angajare
FROM Angajati
WHERE data_angajare BETWEEN TO_DATE('1987-02-20', 'YYYY-MM-DD') 
                        AND TO_DATE('1989-05-01', 'YYYY-MM-DD')
ORDER BY data_angajare ASC;


-- -----------------------------------------------------------------------------
-- Exercițiul 21:
-- Să se afișeze numele și data angajării pentru fiecare salariat care a fost angajat în 1994.
-- Se cer 2 soluții: LIKE și YEAR() / EXTRACT().
-- -----------------------------------------------------------------------------
-- Varianta 1: Cu operatorul LIKE
SELECT nume, data_angajare
FROM Angajati
WHERE TO_CHAR(data_angajare, 'YYYY-MM-DD') LIKE '1994%';

-- Varianta 2: Cu funcția de extragere a anului (YEAR sau EXTRACT)
SELECT nume, data_angajare
FROM Angajati
WHERE EXTRACT(YEAR FROM data_angajare) = 1994;


-- -----------------------------------------------------------------------------
-- Exercițiul 22:
-- Să se afișeze numele și funcția (identificatorul) pentru toți angajații care nu au manager.
-- -----------------------------------------------------------------------------
SELECT nume, id_functie
FROM Angajati
WHERE id_manager IS NULL;


-- -----------------------------------------------------------------------------
-- Exercițiul 23:
-- Să se afișeze numele, salariul și comisionul pentru toți salariații care câștigă comisioane.
-- Să se sorteze datele în ordine descrescătoare a salariilor și comisioanelor.
-- -----------------------------------------------------------------------------
SELECT nume, salariu, comision
FROM Angajati
WHERE comision IS NOT NULL AND comision > 0
ORDER BY salariu DESC, comision DESC;


-- -----------------------------------------------------------------------------
-- Exercițiul 24:
-- Eliminați clauza WHERE din cererea anterioară.
-- Întrebare: Unde sunt plasate valorile NULL în ordinea descrescătoare?
-- Răspuns: În Oracle SQL, valorile NULL sunt considerate cele mai mari posibile,
-- prin urmare la sortarea descrescătoare (DESC) valorile NULL apar PRIMELED (la început).
-- (În standardul MySQL sau SQL Server, NULL apar la sfârșit la sortare DESC).
-- -----------------------------------------------------------------------------
SELECT nume, salariu, comision
FROM Angajati
ORDER BY salariu DESC, comision DESC;


-- -----------------------------------------------------------------------------
-- Exercițiul 25:
-- Să se afișeze numele angajaților care conține literele "a" și "e".
-- -----------------------------------------------------------------------------
SELECT nume
FROM Angajati
WHERE LOWER(nume) LIKE '%a%' 
  AND LOWER(nume) LIKE '%e%';


-- -----------------------------------------------------------------------------
-- Exercițiul 26:
-- Să se listeze numele tuturor angajaților care au a treia literă din nume 'A'.
-- -----------------------------------------------------------------------------
SELECT nume
FROM Angajati
WHERE UPPER(nume) LIKE '__A%';


-- -----------------------------------------------------------------------------
-- Exercițiul 27:
-- Să se listeze numele tuturor angajaților care au 2 litere 'L' în nume
-- și lucrează în departamentul 30 sau managerul lor este 101.
-- -----------------------------------------------------------------------------
SELECT nume
FROM Angajati
WHERE UPPER(nume) LIKE '%L%L%'
  AND (id_departament = 30 OR id_manager = 101);


-- -----------------------------------------------------------------------------
-- Exercițiul 28:
-- Să se afișeze numele, funcția și salariul pentru toți salariații a căror funcție
-- conține șirul "clerk" sau "rep" și salariul nu este egal cu 2500, 3500 sau 7000 $.
-- (operatorul NOT IN)
-- -----------------------------------------------------------------------------
SELECT nume, id_functie, salariu
FROM Angajati
WHERE (LOWER(id_functie) LIKE '%clerk%' OR LOWER(id_functie) LIKE '%rep%')
  AND salariu NOT IN (2500, 3500, 7000);


-- -----------------------------------------------------------------------------
-- Exercițiul 29:
-- Să se afișeze numele, salariul și comisionul pentru toți angajații al căror salariu
-- este mai mare decât comisionul (salariu*comision) mărit de 5 ori.
-- -----------------------------------------------------------------------------
SELECT nume, salariu, comision
FROM Angajati
WHERE salariu > (salariu * comision * 5);


-- -----------------------------------------------------------------------------
-- Exercițiul 30:
-- Să se selecteze numai angajații care fac parte din categoria funcționari
-- (al căror id_functie conține "CLERK").
-- -----------------------------------------------------------------------------
SELECT *
FROM Angajati
WHERE UPPER(id_functie) LIKE '%CLERK%';


-- -----------------------------------------------------------------------------
-- Exercițiul 31:
-- Să se selecteze comenzile încheiate de angajatul cu id_angajat = 161.
-- -----------------------------------------------------------------------------
SELECT *
FROM comenzi
WHERE id_angajat = 161;


-- -----------------------------------------------------------------------------
-- Exercițiul 32:
-- Să se selecteze toate comenzile care au fost lansate online după 1 ianuarie 2000.
-- -----------------------------------------------------------------------------
SELECT *
FROM comenzi
WHERE LOWER(modalitate) = 'online'
  AND data_comanda > TO_DATE('2000-01-01', 'YYYY-MM-DD');


-- -----------------------------------------------------------------------------
-- Exercițiul 33:
-- Să se selecteze id_angajat, nume, prenume, id_manager, id_departament din tabela
-- angajați și denumire_departament din tabela departamente și să se realizeze joncțiunea.
-- -----------------------------------------------------------------------------
SELECT 
    a.id_angajat, 
    a.nume, 
    a.prenume, 
    a.id_manager, 
    a.id_departament, 
    d.denumire_departament
FROM Angajati a
JOIN Departamente d ON a.id_departament = d.id_departament;



-- =============================================================================
-- CAPITOLUL 3: FUNCȚII ÎN SQL (Exercițiile 34 - 37)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 34:
-- Care este data curentă? Afișați diferite formate ale acesteia.
-- -----------------------------------------------------------------------------
SELECT 
    SYSDATE AS "Data implicita",
    TO_CHAR(SYSDATE, 'DD-MM-YYYY') AS "Format Zi-Luna-An",
    TO_CHAR(SYSDATE, 'DD Month YYYY') AS "Format text extins",
    TO_CHAR(SYSDATE, 'YYYY/MM/DD HH24:MI:SS') AS "Format Timestamp",
    TO_CHAR(SYSDATE, 'Day, DD-Mon-YYYY') AS "Format Zi a saptamanii"
FROM dual;


-- -----------------------------------------------------------------------------
-- Exercițiul 35:
-- Să se afișeze pentru fiecare angajat câmpurile: id_angajat, nume, salariu și
-- salariu mărit cu 15,5% (rotunjit până la întreg). Etichetează: "Salariu majorat".
-- (Salvat și în fișierul lab6_ex2.sql)
-- -----------------------------------------------------------------------------
SELECT 
    id_angajat, 
    nume, 
    salariu, 
    ROUND(salariu * 1.155) AS "Salariu majorat"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 36:
-- În interogarea anterioară să se adauge încă un câmp: diferența dintre noul salariu
-- și vechiul salariu. Etichetat: "Majorare".
-- -----------------------------------------------------------------------------
SELECT 
    id_angajat, 
    nume, 
    salariu, 
    ROUND(salariu * 1.155) AS "Salariu majorat",
    ROUND(salariu * 1.155) - salariu AS "Majorare"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 37:
-- Să se afișeze numele angajaților cu majuscule pentru toți angajații al căror nume
-- începe cu "J", "A" sau "M". Al doilea câmp va conține lungimea numelui.
-- Etichetați câmpurile. Ordonați rezultatul după numele angajaților.
-- -----------------------------------------------------------------------------
SELECT 
    UPPER(nume) AS "Nume Angajat", 
    LENGTH(nume) AS "Lungime Nume"
FROM Angajati
WHERE SUBSTR(UPPER(nume), 1, 1) IN ('J', 'A', 'M')
ORDER BY nume ASC;



-- =============================================================================
-- CAPITOLUL 4: FUNCȚII PE ȘIRURI DE CARACTERE (Exercițiile 38 - 41)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 38:
-- Scrieți o cerere: <prenume> <nume> castiga <salariu> lunar dar doreste <salariu de 3 ori mai mare>.
-- Etichetat "Salariu ideal". Utilizați CONCAT și '||'.
-- -----------------------------------------------------------------------------
SELECT CONCAT(CONCAT(prenume, ' '), nume) || ' castiga ' || salariu || 
       ' lunar dar doreste ' || (salariu * 3) AS "Salariu ideal"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 39:
-- Afișează prenumele cu prima literă majusculă și restul mici (INITCAP),
-- numele cu majuscule (UPPER) și lungimea numelui (LENGTH),
-- pentru cei cu nume începând cu J, M sau având a 3-a literă A.
-- Ordonat descrescător după lungimea numelui. 2 soluții: LIKE și SUBSTR.
-- -----------------------------------------------------------------------------
-- Soluția 1: Folosind operatorul LIKE
SELECT 
    INITCAP(prenume) AS "Prenume",
    UPPER(nume) AS "Nume",
    LENGTH(nume) AS "Lungime nume"
FROM Angajati
WHERE UPPER(nume) LIKE 'J%' 
   OR UPPER(nume) LIKE 'M%' 
   OR UPPER(nume) LIKE '__A%'
ORDER BY LENGTH(nume) DESC;

-- Soluția 2: Folosind funcția SUBSTR
SELECT 
    INITCAP(prenume) AS "Prenume",
    UPPER(nume) AS "Nume",
    LENGTH(nume) AS "Lungime nume"
FROM Angajati
WHERE SUBSTR(UPPER(nume), 1, 1) IN ('J', 'M')
   OR SUBSTR(UPPER(nume), 3, 1) = 'A'
ORDER BY LENGTH(nume) DESC;


-- -----------------------------------------------------------------------------
-- Exercițiul 40:
-- Să se afișeze pentru angajații cu prenumele „Steven”, codul, numele și codul
-- departamentului în care lucrează. Căutarea să fie case-insensitive și să ignore blank-uri.
-- -----------------------------------------------------------------------------
SELECT id_angajat, nume, id_departament
FROM Angajati
WHERE LOWER(TRIM(prenume)) = 'steven';


-- -----------------------------------------------------------------------------
-- Exercițiul 41:
-- Să se afișeze pentru toți angajații al căror nume se termină cu litera 'e':
-- codul, numele, lungimea numelui și poziția din nume în care apare prima dată litera 'a'.
-- -----------------------------------------------------------------------------
SELECT 
    id_angajat AS "Cod Angajat",
    nume AS "Nume",
    LENGTH(nume) AS "Lungime Nume",
    INSTR(LOWER(nume), 'a') AS "Pozitie Litera A"
FROM Angajati
WHERE LOWER(nume) LIKE '%e';



-- =============================================================================
-- CAPITOLUL 5: FUNCȚII ARITMETICE (Exercițiile 42 - 44)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 42:
-- Să se afișeze detalii despre salariații care au lucrat un număr întreg de săptămâni
-- până la data curentă (diferența de zile modulo 7 este 0).
-- -----------------------------------------------------------------------------
SELECT *
FROM Angajati
WHERE MOD(TRUNC(SYSDATE - data_angajare), 7) = 0;


-- -----------------------------------------------------------------------------
-- Exercițiul 43:
-- Să se afișeze codul salariatului, numele, salariul, salariul mărit cu 15% rotunjit la
-- 2 zecimale și numărul de sute al salariului nou rotunjit la 2 zecimale.
-- Etichete: "Salariu nou", "Numar sute".
-- Filtrare: salariații al căror salariu nu este divizibil cu 1000.
-- -----------------------------------------------------------------------------
SELECT 
    id_angajat,
    nume,
    salariu,
    ROUND(salariu * 1.15, 2) AS "Salariu nou",
    ROUND((salariu * 1.15) / 100, 2) AS "Numar sute"
FROM Angajati
WHERE MOD(salariu, 1000) != 0;


-- -----------------------------------------------------------------------------
-- Exercițiul 44:
-- Să se listeze numele și data angajării salariaților care câștigă comision.
-- Etichete: „Nume angajat”, „Data angajarii”. Pentru a nu trunchia aliasul, folosiți RPAD.
-- -----------------------------------------------------------------------------
SELECT 
    RPAD(nume, 25) AS "Nume angajat",
    RPAD(TO_CHAR(data_angajare, 'YYYY-MM-DD'), 25) AS "Data angajarii"
FROM Angajati
WHERE comision IS NOT NULL AND comision > 0;



-- =============================================================================
-- CAPITOLUL 6: FUNCȚII ȘI OPERAȚII CU DATE CALENDARISTICE (Exercițiile 45 - 51)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 45:
-- Numărul de luni dintre data curentă și data angajării, rotunjit în sus (CEIL).
-- Eticheta: MONTHS_WORKED. Ordonat după numărul de luni.
-- -----------------------------------------------------------------------------
SELECT 
    nume, 
    CEIL(MONTHS_BETWEEN(SYSDATE, data_angajare)) AS "MONTHS_WORKED"
FROM Angajati
ORDER BY "MONTHS_WORKED" ASC;


-- -----------------------------------------------------------------------------
-- Exercițiul 46:
-- Să se afișeze data (numele lunii, ziua, anul, ora, minutul și secunda) de peste 30 de zile.
-- -----------------------------------------------------------------------------
SELECT TO_CHAR(SYSDATE + 30, 'Month DD, YYYY HH24:MI:SS') AS "Data peste 30 zile"
FROM dual;


-- -----------------------------------------------------------------------------
-- Exercițiul 47:
-- Să se afișeze numărul de zile rămase până la sfârșitul anului curent.
-- -----------------------------------------------------------------------------
SELECT ROUND(TO_DATE('31-12-' || TO_CHAR(SYSDATE, 'YYYY'), 'DD-MM-YYYY') - SYSDATE) AS "Zile pana la sfarsit de an"
FROM dual;


-- -----------------------------------------------------------------------------
-- Exercițiul 48:
-- a) Să se afișeze data de peste 12 ore (+ 12/24 dintr-o zi).
-- b) Să se afișeze data de peste 5 minute (+ 5/(24*60) dintr-o zi).
-- -----------------------------------------------------------------------------
-- a) Peste 12 ore:
SELECT TO_CHAR(SYSDATE + (12/24), 'YYYY-MM-DD HH24:MI:SS') AS "Data peste 12 ore"
FROM dual;

-- b) Peste 5 minute:
SELECT TO_CHAR(SYSDATE + (5/(24*60)), 'YYYY-MM-DD HH24:MI:SS') AS "Data peste 5 minute"
FROM dual;


-- -----------------------------------------------------------------------------
-- Exercițiul 49:
-- Numele și prenumele angajatului, data angajării și data negocierii salariului
-- (prima zi de Luni după 6 luni de serviciu). Etichetă: "Negociere".
-- -----------------------------------------------------------------------------
SELECT 
    nume || ' ' || prenume AS "Angajat",
    data_angajare,
    NEXT_DAY(ADD_MONTHS(data_angajare, 6), 'MONDAY') AS "Negociere"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 50:
-- Numele și numărul de luni de la data angajării rotunjit la cel mai apropiat întreg.
-- Eticheta: "Luni lucrate". Ordonat crescător după luni lucrate.
-- -----------------------------------------------------------------------------
SELECT 
    nume, 
    ROUND(MONTHS_BETWEEN(SYSDATE, data_angajare)) AS "Luni lucrate"
FROM Angajati
ORDER BY "Luni lucrate" ASC;


-- -----------------------------------------------------------------------------
-- Exercițiul 51:
-- Numele, data angajării și ziua săptămânii în care a început lucrul.
-- Etichetă: "Zi". Ordonat începând cu Luni.
-- -----------------------------------------------------------------------------
SELECT 
    nume, 
    data_angajare, 
    TO_CHAR(data_angajare, 'Day') AS "Zi"
FROM Angajati
ORDER BY TO_CHAR(data_angajare - 1, 'D');



-- =============================================================================
-- CAPITOLUL 7: FUNCȚII DIVERSE, CASE ȘI DECODE (Exercițiile 52 - 54)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 52:
-- Numele și comisionul. Dacă nu are comision, să se scrie "Fara comision".
-- Etichetă: "Comision".
-- -----------------------------------------------------------------------------
SELECT 
    nume, 
    NVL(TO_CHAR(comision), 'Fara comision') AS "Comision"
FROM Angajati;


-- -----------------------------------------------------------------------------
-- Exercițiul 53:
-- Numele, salariul și comisionul tuturor angajaților al căror venit lunar depășește 10000$.
-- Venit lunar = salariu + (salariu * comision).
-- -----------------------------------------------------------------------------
SELECT 
    nume, 
    salariu, 
    comision
FROM Angajati
WHERE (salariu + salariu * NVL(comision, 0)) > 10000;


-- -----------------------------------------------------------------------------
-- Exercițiul 54:
-- Numele, codul funcției, salariul și "Salariu renegociat":
-- IT_PROG -> +20%, SA_REP -> +25%, SA_MAN -> +35%, alții -> nemodificat.
-- Prezentat în 2 variante: instrucțiunea CASE și comanda DECODE.
-- -----------------------------------------------------------------------------
-- Varianta 1: Cu instrucțiunea CASE
SELECT 
    nume, 
    id_functie, 
    salariu,
    CASE id_functie
        WHEN 'IT_PROG' THEN salariu * 1.20
        WHEN 'SA_REP'  THEN salariu * 1.25
        WHEN 'SA_MAN'  THEN salariu * 1.35
        ELSE salariu
    END AS "Salariu renegociat"
FROM Angajati;

-- Varianta 2: Cu comanda DECODE
SELECT 
    nume, 
    id_functie, 
    salariu,
    DECODE(id_functie,
        'IT_PROG', salariu * 1.20,
        'SA_REP',  salariu * 1.25,
        'SA_MAN',  salariu * 1.35,
        salariu
    ) AS "Salariu renegociat"
FROM Angajati;



-- =============================================================================
-- CAPITOLUL 8: OPERATORII ANY ȘI ALL (Exercițiile 55 - 56)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 55:
-- Angajații care nu lucrează în departamentul/funcția IT_PROG și al căror salariu
-- este mai mic decât oricare dintre salariile angajaților din IT_PROG (< ANY).
-- Întrebare: Ce condiție trebuie pusă?
-- Răspuns: salariu < ANY (SELECT salariu FROM Angajati WHERE id_functie = 'IT_PROG')
-- -----------------------------------------------------------------------------
SELECT id_angajat, prenume, id_functie, salariu
FROM Angajati
WHERE id_functie != 'IT_PROG'
  AND salariu < ANY (
      SELECT salariu 
      FROM Angajati 
      WHERE id_functie = 'IT_PROG'
  );


-- -----------------------------------------------------------------------------
-- Exercițiul 56:
-- Angajații care nu lucrează în funcția IT_PROG și al căror salariu este mai mic
-- decât fiecare dintre salariile angajaților din IT_PROG (< ALL).
-- -----------------------------------------------------------------------------
SELECT id_angajat, prenume, id_functie, salariu
FROM Angajati
WHERE id_functie != 'IT_PROG'
  AND salariu < ALL (
      SELECT salariu 
      FROM Angajati 
      WHERE id_functie = 'IT_PROG'
  );



-- =============================================================================
-- CAPITOLUL 9: JONCȚIUNI ÎNTRE RELAȚII (Exercițiile 57 - 62)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 57 (a. Joncțiune de egalitate):
-- Să se selecteze comenzile încheiate de angajați.
-- -----------------------------------------------------------------------------
SELECT 
    c.id_comanda, 
    c.data_comanda, 
    a.id_angajat, 
    a.nume, 
    a.prenume
FROM comenzi c
JOIN Angajati a ON c.id_angajat = a.id_angajat;


-- -----------------------------------------------------------------------------
-- Exercițiul 58:
-- Să se selecteze comenzile încheiate de angajatul Greene numai în luna noiembrie.
-- -----------------------------------------------------------------------------
SELECT 
    c.id_comanda, 
    c.data_comanda, 
    a.nume, 
    a.prenume
FROM comenzi c
JOIN Angajati a ON c.id_angajat = a.id_angajat
WHERE a.nume = 'Greene'
  AND EXTRACT(MONTH FROM c.data_comanda) = 11;


-- -----------------------------------------------------------------------------
-- Exercițiul 59:
-- Să se calculeze valoarea fiecărui produs (valoare = cantitate * pret)
-- și să se afișeze denumirea produsului, prețul, cantitatea și valoarea.
-- -----------------------------------------------------------------------------
SELECT 
    p.denumire_produs,
    rc.pret,
    rc.cantitate,
    (rc.cantitate * rc.pret) AS valoare
FROM rand_comenzi rc
JOIN produse p ON rc.id_produs = p.id_produs;


-- -----------------------------------------------------------------------------
-- Exercițiul 60:
-- Să se selecteze numai produsele cu valoarea cuprinsă între 1000 și 2000.
-- -----------------------------------------------------------------------------
SELECT 
    p.denumire_produs,
    rc.pret,
    rc.cantitate,
    (rc.cantitate * rc.pret) AS valoare
FROM rand_comenzi rc
JOIN produse p ON rc.id_produs = p.id_produs
WHERE (rc.cantitate * rc.pret) BETWEEN 1000 AND 2000;


-- -----------------------------------------------------------------------------
-- Exercițiul 61 (b. Joncțiune externă):
-- Să se afișeze id-ul produsului, denumirea produsului și cantitatea, chiar dacă
-- nu au fost comandate (LEFT OUTER JOIN).
-- -----------------------------------------------------------------------------
SELECT 
    p.id_produs,
    p.denumire_produs,
    rc.cantitate
FROM produse p
LEFT JOIN rand_comenzi rc ON p.id_produs = rc.id_produs;


-- -----------------------------------------------------------------------------
-- Exercițiul 62 (c. Joncțiunea pe aceeași tabelă - Self Join):
-- Să se afișeze numele fiecărui angajat și numele șefului direct superior.
-- -----------------------------------------------------------------------------
SELECT 
    ang.nume AS "Nume Angajat",
    mgr.nume AS "Nume Sef Direct"
FROM Angajati ang
JOIN Angajati mgr ON ang.id_manager = mgr.id_angajat;



-- =============================================================================
-- CAPITOLUL 10: INTEROGĂRI SUBORDONATE (SUBQUERIES) ȘI COMPLEXE (Exercițiile 63 - 75)
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Exercițiul 63:
-- Să se selecteze angajații care sunt în același departament cu angajatul Smith.
-- -----------------------------------------------------------------------------
SELECT nume, prenume, id_departament
FROM Angajati
WHERE id_departament IN (
    SELECT id_departament 
    FROM Angajati 
    WHERE nume = 'Smith'
)
AND nume != 'Smith';


-- -----------------------------------------------------------------------------
-- Exercițiul 64:
-- Să se afișeze produsele care au prețul unitar cel mai mic.
-- -----------------------------------------------------------------------------
SELECT *
FROM produse
WHERE pret_unitar = (
    SELECT MIN(pret_unitar) 
    FROM produse
);


-- -----------------------------------------------------------------------------
-- Exercițiul 65:
-- Să se afișeze numele salariatului, codul și numele departamentului pentru toți angajații.
-- -----------------------------------------------------------------------------
SELECT 
    a.nume, 
    a.id_departament, 
    d.denumire_departament
FROM Angajati a
LEFT JOIN Departamente d ON a.id_departament = d.id_departament;


-- -----------------------------------------------------------------------------
-- Exercițiul 66:
-- Să se listeze titlurile job-urilor care există în departamentul 30.
-- -----------------------------------------------------------------------------
SELECT DISTINCT j.titlu_functie
FROM Angajati a
JOIN jobs j ON a.id_functie = j.id_functie
WHERE a.id_departament = 30;


-- -----------------------------------------------------------------------------
-- Exercițiul 67:
-- Să se afișeze numele angajatului, numele departamentului și locația pentru toți angajații
-- care câștigă comision.
-- -----------------------------------------------------------------------------
SELECT 
    a.nume AS "Nume Angajat",
    d.denumire_departament AS "Nume Departament",
    l.oras AS "Locatia"
FROM Angajati a
JOIN Departamente d ON a.id_departament = d.id_departament
JOIN locatii l ON d.id_locatie = l.id_locatie
WHERE a.comision IS NOT NULL AND a.comision > 0;


-- -----------------------------------------------------------------------------
-- Exercițiul 68:
-- Să se afișeze numele salariatului și numele departamentului pentru toți salariații
-- care au litera 'A' inclusă în nume.
-- -----------------------------------------------------------------------------
SELECT 
    a.nume, 
    d.denumire_departament
FROM Angajati a
JOIN Departamente d ON a.id_departament = d.id_departament
WHERE UPPER(a.nume) LIKE '%A%';


-- -----------------------------------------------------------------------------
-- Exercițiul 69:
-- Să se afișeze numele, job-ul, codul și numele departamentului pentru toți angajații
-- care lucrează în Oxford.
-- -----------------------------------------------------------------------------
SELECT 
    a.nume,
    a.id_functie,
    a.id_departament,
    d.denumire_departament
FROM Angajati a
JOIN Departamente d ON a.id_departament = d.id_departament
JOIN locatii l ON d.id_locatie = l.id_locatie
WHERE LOWER(l.oras) = 'oxford';


-- -----------------------------------------------------------------------------
-- Exercițiul 70:
-- Să se afișeze codul angajatului și numele acestuia, împreună cu numele și codul șefului său direct.
-- Etichete: Ang#, Angajat, Mgr#, Manager.
-- -----------------------------------------------------------------------------
SELECT 
    ang.id_angajat AS "Ang#",
    ang.nume AS "Angajat",
    mgr.id_angajat AS "Mgr#",
    mgr.nume AS "Manager"
FROM Angajati ang
JOIN Angajati mgr ON ang.id_manager = mgr.id_angajat;


-- -----------------------------------------------------------------------------
-- Exercițiul 71:
-- Să se modifice cererea precedentă pentru a afișa toți salariații, inclusiv cei fără șef.
-- (LEFT JOIN)
-- -----------------------------------------------------------------------------
SELECT 
    ang.id_angajat AS "Ang#",
    ang.nume AS "Angajat",
    mgr.id_angajat AS "Mgr#",
    mgr.nume AS "Manager"
FROM Angajati ang
LEFT JOIN Angajati mgr ON ang.id_manager = mgr.id_angajat;


-- -----------------------------------------------------------------------------
-- Exercițiul 72:
-- Creați o cerere care să afișeze numele angajatului, codul departamentului și toți
-- salariații care lucrează în același departament cu el.
-- -----------------------------------------------------------------------------
SELECT 
    a1.id_departament AS "Cod Departament",
    a1.nume AS "Angajat",
    a2.nume AS "Coleg Departament"
FROM Angajati a1
JOIN Angajati a2 ON a1.id_departament = a2.id_departament
WHERE a1.id_angajat != a2.id_angajat
ORDER BY a1.id_departament, a1.nume, a2.nume;


-- -----------------------------------------------------------------------------
-- Exercițiul 73:
-- Structura tabelului JOBS și cerere pentru a afișa numele, codul funcției, titlul funcției,
-- numele departamentului și salariul angajaților.
-- -----------------------------------------------------------------------------
-- Structura:
DESCRIBE jobs;

-- Cererea:
SELECT 
    a.nume,
    a.id_functie,
    j.titlu_functie,
    d.denumire_departament,
    a.salariu
FROM Angajati a
LEFT JOIN jobs j ON a.id_functie = j.id_functie
LEFT JOIN Departamente d ON a.id_departament = d.id_departament;


-- -----------------------------------------------------------------------------
-- Exercițiul 74:
-- Să se afișeze numele și data angajării pentru salariații care au fost angajați după Gates.
-- -----------------------------------------------------------------------------
SELECT nume, data_angajare
FROM Angajati
WHERE data_angajare > (
    SELECT data_angajare 
    FROM Angajati 
    WHERE nume = 'Gates'
);


-- -----------------------------------------------------------------------------
-- Exercițiul 75:
-- Să se afișeze numele salariatului și data angajării împreună cu numele și data angajării
-- șefului direct pentru salariații care au fost angajați înaintea șefilor lor.
-- Etichete: Angajat, Data_ang, Manager, Data_mgr.
-- -----------------------------------------------------------------------------
SELECT 
    ang.nume AS "Angajat",
    ang.data_angajare AS "Data_ang",
    mgr.nume AS "Manager",
    mgr.data_angajare AS "Data_mgr"
FROM Angajati ang
JOIN Angajati mgr ON ang.id_manager = mgr.id_angajat
WHERE ang.data_angajare < mgr.data_angajare;

