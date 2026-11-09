-- CREATE DATABASE Companie;
-- USE Companie;

CREATE TABLE produse (
    id_produs DECIMAL(6) PRIMARY KEY,
    denumire_produs VARCHAR(50),
    descriere VARCHAR(2000),
    categorie VARCHAR(40),
    pret_lista DECIMAL(8,2),
    pret_min DECIMAL(8,2)
);

CREATE TABLE clienti (
    id_client DECIMAL(6) PRIMARY KEY,
    prenume_client VARCHAR(20) NOT NULL,
    nume_client VARCHAR(20) NOT NULL,
    telefon VARCHAR(20),
    limita_credit DECIMAL(9,2),
    email_client VARCHAR(30),
    data_nastere DATE,
    stare_civila VARCHAR(20),
    sex VARCHAR(1),
    nivel_venituri VARCHAR(20)
);

CREATE TABLE functii (
    id_functie VARCHAR(10) PRIMARY KEY,
    denumire_functie VARCHAR(35) NOT NULL,
    salariu_min DECIMAL(6),
    salariu_max DECIMAL(6)
);

CREATE TABLE regiuni (
    id_regiune DECIMAL PRIMARY KEY,
    denumire_regiune VARCHAR(25)
);

CREATE TABLE tari (
    id_tara CHAR(2) PRIMARY KEY,
    denumire_tara VARCHAR(40),
    id_regiune DECIMAL,
    FOREIGN KEY (id_regiune) REFERENCES regiuni(id_regiune)
);

CREATE TABLE locatii (
    id_locatie DECIMAL(4) PRIMARY KEY,
    adresa VARCHAR(40),
    cod_postal VARCHAR(12),
    oras VARCHAR(30) NOT NULL,
    zona VARCHAR(25),
    id_tara CHAR(2),
    FOREIGN KEY (id_tara) REFERENCES tari(id_tara)
);

CREATE TABLE departamente (
    id_departament DECIMAL(4) PRIMARY KEY ,
    denumire_departament VARCHAR(30) NOT NULL,
    id_manager DECIMAL(6) UNIQUE,
    id_locatie DECIMAL(4),
    FOREIGN KEY (id_locatie) REFERENCES locatii(id_locatie)
);

CREATE TABLE angajati (
    id_angajat DECIMAL(6) PRIMARY KEY,
    prenume VARCHAR(20),
    nume VARCHAR(25) NOT NULL,
    email VARCHAR(25) NOT NULL,
    telefon VARCHAR(20),
    data_angajare DATE NOT NULL,
    id_functie VARCHAR(10) NOT NULL,
    salariu DECIMAL(8,2),
    comision DECIMAL(2,2),
    id_manager DECIMAL(6),
    id_departament DECIMAL(4),
    FOREIGN KEY (id_functie) REFERENCES functii(id_functie),
    CONSTRAINT fk_id_departament FOREIGN KEY (id_departament) REFERENCES departamente(id_departament),
    CONSTRAINT fk_id_manager FOREIGN KEY (id_manager) REFERENCES departamente(id_manager)
);

CREATE TABLE istoric_functii (
    id_angajat DECIMAL(6) NOT NULL,
    data_inceput DATE NOT NULL,
    data_sfarsit DATE NOT NULL,
    id_functie VARCHAR(10) NOT NULL,
    id_departament DECIMAL(4),
    FOREIGN KEY (id_functie) REFERENCES functii(id_functie),
    FOREIGN KEY (id_departament) REFERENCES departamente(id_departament),
    FOREIGN KEY (id_angajat) REFERENCES angajati(id_angajat)
);

CREATE TABLE comenzi (
    numar_comanda DECIMAL(12) PRIMARY KEY,
    data_comanda TIMESTAMP(6) NOT NULL,
    modalitate VARCHAR(8),
    id_client DECIMAL(6)  NOT NULL,
    stare_comanda DECIMAL(2),
    id_angajat DECIMAL(6),
    FOREIGN KEY (id_angajat) REFERENCES angajati(id_angajat),
    FOREIGN KEY (id_client) REFERENCES clienti(id_client)
);

CREATE TABLE rand_comenzi (
    numar_comanda DECIMAL(12) NOT NULL,
    id_produs DECIMAL(6) NOT NULL,
    pret DECIMAL(8,2),
    cantitate DECIMAL(8),
    FOREIGN KEY (id_produs) REFERENCES produse(id_produs),
	FOREIGN KEY (numar_comanda) REFERENCES comenzi(numar_comanda)
);