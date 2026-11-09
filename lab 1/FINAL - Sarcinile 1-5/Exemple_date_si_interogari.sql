-- Date fictive pentru demonstrație. Rulați după Schema_validata.sql într-o bază goală.
PRAGMA foreign_keys=ON;
BEGIN;
INSERT INTO CATEDRA VALUES (1,'Informatică','Științe','201');
INSERT INTO ANGAJAT_A VALUES (1,'Perju','Denis','asistent',1);
INSERT INTO ANGAJAT_A VALUES (2,'Rusu','Ana','cercetător',NULL);
INSERT INTO ECHIPA VALUES (1,'Steaua','Chișinău',2000);
INSERT INTO JUCATOR VALUES (1,'Popa','Ion',10,1);
INSERT INTO AUTOR VALUES (1,'Autor','Ana','MD'),(2,'Autor','Ion','RO');
INSERT INTO CARTE VALUES (1,'Baze de date în exemple',2026,'Educațional');
INSERT INTO AUTOR_CARTE VALUES (1,1),(2,1);
INSERT INTO CLIENT_J VALUES (1,'Rusu','Ana','Chișinău');
INSERT INTO CONTRACT VALUES (1,'2026-10-01','Servicii',1000,1);
INSERT INTO ANGAJAT_M VALUES (1,'Popa','Mihai','senior',1,0,NULL);
INSERT INTO ANGAJAT_M VALUES (2,'Rusu','Maria','stagiar',0,1,1);
INSERT INTO PROPRIETAR VALUES (1,'Ana Rusu','Chișinău',NULL),(2,'Ion Popa','Bălți',NULL);
INSERT INTO ANIMAL VALUES (1,'Max','Metis',3,'CAINE',12,1),(2,'Max','Labrador',2,'CAINE',20,2),(3,'Max','Metis',1,'CAINE',8,1);
INSERT INTO CAINE VALUES (1,'de bază'),(2,'avansat'),(3,'începător');
INSERT INTO MEDIC VALUES ('V001','Elena Rusu','Medicină generală');
INSERT INTO CONSULTARE VALUES (1,'2026-10-01T08:00:00.000000Z','Control','Stare bună',100,'Monitorizare',1,'V001'),(2,'2026-10-08T08:00:00.000000Z','Control repetat','Stabil',80,NULL,1,'V001');
INSERT INTO CLIENT_L VALUES (1,'Ana Rusu','Florilor','1','Chișinău','MD','+37360000001'),(2,'Ion Popa','Unirii','2','București','RO','+40700000001');
INSERT INTO RUTA VALUES (1,'Chișinău–București',12);
INSERT INTO COLET VALUES ('TRK001',2,'Cărți',500,'2026-10-01T08:00:00.000000Z',1000,0,1,2,1);
INSERT INTO PUNCT_TRANZIT VALUES ('A','Depozit Chișinău','Chișinău','DEPOZIT'),('B','Sortare Iași','Iași','SORTARE'),('C','Hub București','București','HUB'),('X','Depozit deviere','Cluj','DEPOZIT');
INSERT INTO DEPOZIT_REGIONAL VALUES ('A',1000),('X',500);
INSERT INTO CENTRU_SORTARE VALUES ('B',2000);
INSERT INTO HUB_AEROPORTUAR VALUES ('C','OTP');
INSERT INTO SEGMENT VALUES (1,'A','B'),(2,'B','C');
INSERT INTO RUTA_SEGMENT VALUES (1,1,1),(1,2,2);
INSERT INTO ANGAJAT_L VALUES ('E001','Mihai Rusu');
INSERT INTO SCANARE VALUES (1,'2026-10-01T08:10:00.000000Z','INTRARE','TRK001','A','E001'),(2,'2026-10-01T09:10:00.000000Z','IESIRE','TRK001','A','E001'),(3,'2026-10-01T11:00:00.000000Z','INTRARE','TRK001','X','E001');
INSERT INTO MEMBRU VALUES ('ana@example.invalid','HASH_DEMO_NEUTILIZABIL','2026-10-01'),('ion@example.invalid','HASH_DEMO_NEUTILIZABIL','2026-10-01');
INSERT INTO CUMPARATOR VALUES ('ana@example.invalid','Chișinău',10000);
INSERT INTO VANZATOR VALUES ('ana@example.invalid','IBAN_DEMO_A','+37360000001'),('ion@example.invalid','IBAN_DEMO_B','+37360000002');
INSERT INTO CATEGORIE VALUES (1,'Numismatică',5,24);
INSERT INTO OBIECT VALUES ('O001','Monedă veche','Bună',100,'2026-10-01T08:00:00.000000Z',10,NULL,'ion@example.invalid',1);
INSERT INTO OFERTA VALUES (1,120,'2026-10-01T09:00:00.000001Z','ana@example.invalid','O001'),(2,140,'2026-10-01T10:00:00.000001Z','ana@example.invalid','O001');
INSERT INTO ADJUDECARE VALUES (1,'O001',2,'2026-10-02T08:00:00.000000Z');
INSERT INTO FEEDBACK VALUES (1,9,'Experiență bună','Mulțumesc');
INSERT INTO MARCA VALUES (1,'Toyota','Japonia');
INSERT INTO MODEL VALUES ('M001','Corolla',20000,1);
INSERT INTO DEALER VALUES ('D001','Auto Demo','Chișinău');
INSERT INTO VEHICUL VALUES ('TEST0000000000001','alb',2026,1800,10,'HIBRID','Euro 6','M001','D001'),('TEST0000000000002','gri',2026,1800,0,'TERMIC','Euro 6','M001','D001');
INSERT INTO HIBRID VALUES ('TEST0000000000001',1.8,'benzină');
INSERT INTO TERMIC VALUES ('TEST0000000000002','benzină');
INSERT INTO DOTARE VALUES ('OPT1','Trapă',500),('OPT2','Scaune piele',1200);
INSERT INTO VEHICUL_DOTARE VALUES ('TEST0000000000001','OPT1'),('TEST0000000000001','OPT2');
INSERT INTO CLIENT_AUTO VALUES ('CNP_DEMO_001','Rusu','Ana','ACT_DEMO','+37360000001');
INSERT INTO VANZARE VALUES ('F001','2026-10-03',36,21000,'transfer','TEST0000000000001','D001','CNP_DEMO_001');
COMMIT;
-- Coautori (2 rânduri pentru aceeași carte).
SELECT c.titlu,a.nume,a.prenume FROM CARTE c JOIN AUTOR_CARTE ac ON ac.id_carte=c.id_carte JOIN AUTOR a ON a.id_autor=ac.id_autor;
-- Preț de listă inclusiv pentru vehicule fără dotări (21700 și 20000).
SELECT v.vin,m.pret_baza+COALESCE(SUM(d.cost_suplimentar),0) AS pret_lista FROM VEHICUL v JOIN MODEL m ON m.cod_model=v.cod_model LEFT JOIN VEHICUL_DOTARE vd ON vd.vin=v.vin LEFT JOIN DOTARE d ON d.cod_dotare=vd.cod_dotare GROUP BY v.vin,m.pret_baza;
-- Ratingul vânzătorului pe scala 1–5 (4.5 în exemplu).
SELECT o.email_vanzator,AVG(f.nota)/2.0 AS rating FROM FEEDBACK f JOIN ADJUDECARE a ON a.id_adjudecare=f.id_adjudecare JOIN OBIECT o ON o.cod_obiect=a.cod_obiect GROUP BY o.email_vanzator;
-- Locații scanate în afara rutei (scanarea 3, punctul X).
SELECT sc.id_scanare,sc.cod_punct FROM SCANARE sc JOIN COLET c ON c.tracking_id=sc.tracking_id WHERE NOT EXISTS (SELECT 1 FROM RUTA_SEGMENT rs JOIN SEGMENT s ON s.id_segment=rs.id_segment WHERE rs.id_ruta=c.id_ruta AND sc.cod_punct IN (s.cod_plecare,s.cod_sosire));
