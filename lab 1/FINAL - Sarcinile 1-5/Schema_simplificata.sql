-- Model ER simplu, fără ierarhii de specializare.
PRAGMA foreign_keys=ON;
BEGIN;
CREATE TABLE CATEDRA (
  id_catedra INTEGER NOT NULL,
  denumire_catedra TEXT NOT NULL,
  facultate TEXT NOT NULL,
  birou TEXT NOT NULL,
  PRIMARY KEY (id_catedra)
);

CREATE TABLE ANGAJAT_A (
  id_angajat_academic INTEGER NOT NULL,
  nume_angajat_a TEXT NOT NULL,
  prenume_angajat_a TEXT NOT NULL,
  functie TEXT NOT NULL,
  id_catedra INTEGER,
  PRIMARY KEY (id_angajat_academic),
  FOREIGN KEY (id_catedra) REFERENCES CATEDRA (id_catedra)
);

CREATE TABLE ECHIPA (
  id_echipa INTEGER NOT NULL,
  denumire_echipa TEXT NOT NULL,
  oras_echipa TEXT NOT NULL,
  an_fondare INTEGER NOT NULL,
  PRIMARY KEY (id_echipa),
  CHECK (an_fondare > 0)
);

CREATE TABLE JUCATOR (
  id_jucator INTEGER NOT NULL,
  nume_jucator TEXT NOT NULL,
  prenume_jucator TEXT NOT NULL,
  numar_tricou INTEGER NOT NULL,
  id_echipa INTEGER NOT NULL,
  PRIMARY KEY (id_jucator),
  FOREIGN KEY (id_echipa) REFERENCES ECHIPA (id_echipa),
  UNIQUE (id_echipa, numar_tricou),
  CHECK (numar_tricou > 0)
);

CREATE TABLE AUTOR (
  id_autor INTEGER NOT NULL,
  nume_autor TEXT NOT NULL,
  prenume_autor TEXT NOT NULL,
  nationalitate TEXT NOT NULL,
  PRIMARY KEY (id_autor)
);

CREATE TABLE CARTE (
  id_carte INTEGER NOT NULL,
  titlu_carte TEXT NOT NULL,
  an_publicare INTEGER NOT NULL,
  gen_literar TEXT NOT NULL,
  PRIMARY KEY (id_carte)
);

CREATE TABLE AUTOR_CARTE (
  id_autor INTEGER NOT NULL,
  id_carte INTEGER NOT NULL,
  PRIMARY KEY (id_autor, id_carte),
  FOREIGN KEY (id_autor) REFERENCES AUTOR (id_autor),
  FOREIGN KEY (id_carte) REFERENCES CARTE (id_carte)
);

CREATE TABLE CLIENT_J (
  id_client_juridic INTEGER NOT NULL,
  nume_client_j TEXT NOT NULL,
  prenume_client_j TEXT NOT NULL,
  adresa_client_j TEXT NOT NULL,
  PRIMARY KEY (id_client_juridic)
);

CREATE TABLE CONTRACT (
  id_contract INTEGER NOT NULL,
  data_semnare TEXT NOT NULL,
  obiect TEXT NOT NULL,
  valoare NUMERIC NOT NULL,
  id_client_juridic INTEGER NOT NULL,
  PRIMARY KEY (id_contract),
  FOREIGN KEY (id_client_juridic) REFERENCES CLIENT_J (id_client_juridic),
  CHECK (valoare >= 0)
);

CREATE TABLE PROPRIETAR (
  id_proprietar INTEGER NOT NULL,
  nume_complet TEXT NOT NULL,
  adresa_proprietar TEXT NOT NULL,
  email_contact TEXT,
  PRIMARY KEY (id_proprietar)
);

CREATE TABLE ANIMAL (
  id_animal INTEGER NOT NULL,
  nume_animal TEXT NOT NULL,
  rasa TEXT NOT NULL,
  varsta_ani INTEGER NOT NULL,
  specie TEXT NOT NULL,
  greutate_kg_animal NUMERIC,
  id_proprietar INTEGER NOT NULL,
  PRIMARY KEY (id_animal),
  FOREIGN KEY (id_proprietar) REFERENCES PROPRIETAR (id_proprietar),
  CHECK (varsta_ani >= 0),
  CHECK (greutate_kg_animal IS NULL OR greutate_kg_animal > 0)
);

CREATE TABLE MEDIC (
  nr_legitimatie TEXT NOT NULL,
  nume_medic TEXT NOT NULL,
  specializare TEXT NOT NULL,
  PRIMARY KEY (nr_legitimatie)
);

CREATE TABLE CONSULTARE (
  id_consultare INTEGER NOT NULL,
  data_ora TEXT NOT NULL,
  diagnostic TEXT NOT NULL,
  observatii TEXT NOT NULL,
  cost_total NUMERIC NOT NULL,
  tratament TEXT,
  id_animal INTEGER NOT NULL,
  nr_legitimatie TEXT NOT NULL,
  PRIMARY KEY (id_consultare),
  FOREIGN KEY (id_animal) REFERENCES ANIMAL (id_animal),
  FOREIGN KEY (nr_legitimatie) REFERENCES MEDIC (nr_legitimatie),
  CHECK (cost_total >= 0)
);

CREATE TABLE CLIENT_L (
  id_client_logistic INTEGER NOT NULL,
  nume_denumire TEXT NOT NULL,
  strada TEXT NOT NULL,
  numar TEXT NOT NULL,
  oras_client_l TEXT NOT NULL,
  tara_client_l TEXT NOT NULL,
  telefon TEXT NOT NULL,
  PRIMARY KEY (id_client_logistic)
);

CREATE TABLE RUTA (
  id_ruta INTEGER NOT NULL,
  denumire_ruta TEXT NOT NULL,
  durata_estimata_ore NUMERIC NOT NULL,
  PRIMARY KEY (id_ruta),
  CHECK (durata_estimata_ore > 0)
);

CREATE TABLE COLET (
  tracking_id TEXT NOT NULL,
  greutate_kg_colet NUMERIC NOT NULL,
  descriere TEXT NOT NULL,
  valoare_declarata NUMERIC NOT NULL,
  data_preluare TEXT NOT NULL,
  volum_cm3 NUMERIC NOT NULL,
  fragil INTEGER NOT NULL,
  id_expeditor INTEGER NOT NULL,
  id_destinatar INTEGER NOT NULL,
  id_ruta INTEGER NOT NULL,
  PRIMARY KEY (tracking_id),
  FOREIGN KEY (id_expeditor) REFERENCES CLIENT_L (id_client_logistic),
  FOREIGN KEY (id_destinatar) REFERENCES CLIENT_L (id_client_logistic),
  FOREIGN KEY (id_ruta) REFERENCES RUTA (id_ruta),
  CHECK (greutate_kg_colet > 0),
  CHECK (valoare_declarata >= 0),
  CHECK (volum_cm3 > 0),
  CHECK (fragil IN (0,1))
);

CREATE TABLE PUNCT_TRANZIT (
  cod_punct TEXT NOT NULL,
  denumire_punct_tranzit TEXT NOT NULL,
  localitate TEXT NOT NULL,
  tip TEXT NOT NULL,
  PRIMARY KEY (cod_punct),
  CHECK (tip IN ('DEPOZIT','HUB','SORTARE'))
);

CREATE TABLE SEGMENT (
  id_segment INTEGER NOT NULL,
  cod_plecare TEXT NOT NULL,
  cod_sosire TEXT NOT NULL,
  PRIMARY KEY (id_segment),
  FOREIGN KEY (cod_plecare) REFERENCES PUNCT_TRANZIT (cod_punct),
  FOREIGN KEY (cod_sosire) REFERENCES PUNCT_TRANZIT (cod_punct),
  CHECK (cod_plecare <> cod_sosire)
);

CREATE TABLE RUTA_SEGMENT (
  id_ruta INTEGER NOT NULL,
  pozitie INTEGER NOT NULL,
  id_segment INTEGER NOT NULL,
  PRIMARY KEY (id_ruta, pozitie),
  FOREIGN KEY (id_ruta) REFERENCES RUTA (id_ruta),
  FOREIGN KEY (id_segment) REFERENCES SEGMENT (id_segment),
  CHECK (pozitie > 0)
);

CREATE TABLE ANGAJAT_L (
  cod_personal TEXT NOT NULL,
  nume_angajat_l TEXT NOT NULL,
  PRIMARY KEY (cod_personal)
);

CREATE TABLE SCANARE (
  id_scanare INTEGER NOT NULL,
  moment_scanare TEXT NOT NULL,
  tip_eveniment TEXT NOT NULL,
  tracking_id TEXT NOT NULL,
  cod_punct TEXT NOT NULL,
  cod_personal TEXT NOT NULL,
  PRIMARY KEY (id_scanare),
  FOREIGN KEY (tracking_id) REFERENCES COLET (tracking_id),
  FOREIGN KEY (cod_punct) REFERENCES PUNCT_TRANZIT (cod_punct),
  FOREIGN KEY (cod_personal) REFERENCES ANGAJAT_L (cod_personal),
  CHECK (tip_eveniment IN ('INTRARE','IESIRE'))
);

CREATE TABLE MEMBRU (
  email TEXT NOT NULL,
  parola_hash TEXT NOT NULL,
  data_inregistrare TEXT NOT NULL,
  PRIMARY KEY (email)
);

CREATE TABLE CUMPARATOR (
  email TEXT NOT NULL,
  adresa_livrare TEXT NOT NULL,
  limita_credit NUMERIC NOT NULL,
  PRIMARY KEY (email),
  FOREIGN KEY (email) REFERENCES MEMBRU (email),
  CHECK (limita_credit >= 0)
);

CREATE TABLE VANZATOR (
  email TEXT NOT NULL,
  iban TEXT NOT NULL,
  telefon_asistenta TEXT NOT NULL,
  PRIMARY KEY (email),
  FOREIGN KEY (email) REFERENCES MEMBRU (email)
);

CREATE TABLE CATEGORIE (
  id_categorie INTEGER NOT NULL,
  denumire_categorie TEXT NOT NULL,
  comision_proc NUMERIC NOT NULL,
  durata_ore INTEGER NOT NULL,
  PRIMARY KEY (id_categorie),
  CHECK (comision_proc BETWEEN 0 AND 100),
  CHECK (durata_ore > 0)
);

CREATE TABLE OBIECT (
  cod_obiect TEXT NOT NULL,
  titlu_obiect TEXT NOT NULL,
  descriere_stare TEXT NOT NULL,
  pret_pornire NUMERIC NOT NULL,
  start_licitatie TEXT NOT NULL,
  pas_minim NUMERIC NOT NULL,
  pret_rezerva NUMERIC,
  email_vanzator TEXT NOT NULL,
  id_categorie INTEGER NOT NULL,
  PRIMARY KEY (cod_obiect),
  FOREIGN KEY (email_vanzator) REFERENCES VANZATOR (email),
  FOREIGN KEY (id_categorie) REFERENCES CATEGORIE (id_categorie),
  CHECK (pret_pornire >= 0),
  CHECK (pas_minim > 0),
  CHECK (pret_rezerva IS NULL OR pret_rezerva >= pret_pornire)
);

CREATE TABLE OFERTA (
  id_oferta INTEGER NOT NULL,
  suma NUMERIC NOT NULL,
  moment_oferta TEXT NOT NULL,
  email_cumparator TEXT NOT NULL,
  cod_obiect TEXT NOT NULL,
  PRIMARY KEY (id_oferta),
  FOREIGN KEY (email_cumparator) REFERENCES CUMPARATOR (email),
  FOREIGN KEY (cod_obiect) REFERENCES OBIECT (cod_obiect),
  UNIQUE (id_oferta, cod_obiect),
  CHECK (suma > 0)
);

CREATE TABLE ADJUDECARE (
  id_adjudecare INTEGER NOT NULL,
  cod_obiect TEXT NOT NULL,
  id_oferta INTEGER NOT NULL,
  data_finalizare TEXT NOT NULL,
  PRIMARY KEY (id_adjudecare),
  FOREIGN KEY (cod_obiect) REFERENCES OBIECT (cod_obiect),
  FOREIGN KEY (id_oferta,cod_obiect) REFERENCES OFERTA (id_oferta,cod_obiect),
  UNIQUE (cod_obiect),
  UNIQUE (id_oferta)
);

CREATE TABLE FEEDBACK (
  id_adjudecare INTEGER NOT NULL,
  nota INTEGER NOT NULL,
  comentariu TEXT NOT NULL,
  raspuns_vanzator TEXT,
  PRIMARY KEY (id_adjudecare),
  FOREIGN KEY (id_adjudecare) REFERENCES ADJUDECARE (id_adjudecare),
  CHECK (nota BETWEEN 1 AND 10)
);

CREATE TABLE MARCA (
  id_marca INTEGER NOT NULL,
  nume_marca TEXT NOT NULL,
  tara_marca TEXT NOT NULL,
  PRIMARY KEY (id_marca),
  UNIQUE (nume_marca)
);

CREATE TABLE MODEL (
  cod_model TEXT NOT NULL,
  nume_model TEXT NOT NULL,
  pret_baza NUMERIC NOT NULL,
  id_marca INTEGER NOT NULL,
  PRIMARY KEY (cod_model),
  FOREIGN KEY (id_marca) REFERENCES MARCA (id_marca),
  CHECK (pret_baza >= 0)
);

CREATE TABLE DEALER (
  cod_dealer TEXT NOT NULL,
  denumire_dealer TEXT NOT NULL,
  adresa_dealer TEXT NOT NULL,
  PRIMARY KEY (cod_dealer)
);

CREATE TABLE VEHICUL (
  vin TEXT NOT NULL,
  culoare TEXT NOT NULL,
  an_fabricatie INTEGER NOT NULL,
  capacitate_cm3 INTEGER NOT NULL,
  km_parcursi INTEGER NOT NULL,
  tip_propulsie TEXT NOT NULL,
  norma_poluare TEXT NOT NULL,
  cod_model TEXT NOT NULL,
  cod_dealer TEXT NOT NULL,
  PRIMARY KEY (vin),
  FOREIGN KEY (cod_model) REFERENCES MODEL (cod_model),
  FOREIGN KEY (cod_dealer) REFERENCES DEALER (cod_dealer),
  CHECK (length(vin) = 17),
  CHECK (capacitate_cm3 >= 0),
  CHECK (km_parcursi >= 0),
  CHECK (tip_propulsie IN ('ELECTRIC','TERMIC','HIBRID'))
);

CREATE TABLE DOTARE (
  cod_dotare TEXT NOT NULL,
  denumire_dotare TEXT NOT NULL,
  cost_suplimentar NUMERIC NOT NULL,
  PRIMARY KEY (cod_dotare),
  CHECK (cost_suplimentar >= 0)
);

CREATE TABLE VEHICUL_DOTARE (
  vin TEXT NOT NULL,
  cod_dotare TEXT NOT NULL,
  PRIMARY KEY (vin, cod_dotare),
  FOREIGN KEY (vin) REFERENCES VEHICUL (vin),
  FOREIGN KEY (cod_dotare) REFERENCES DOTARE (cod_dotare)
);

CREATE TABLE CLIENT_AUTO (
  cnp TEXT NOT NULL,
  nume_client_auto TEXT NOT NULL,
  prenume_client_auto TEXT NOT NULL,
  date_buletin TEXT NOT NULL,
  telefon_contact TEXT NOT NULL,
  PRIMARY KEY (cnp)
);

CREATE TABLE VANZARE (
  nr_factura TEXT NOT NULL,
  data_facturare TEXT NOT NULL,
  garantie_luni INTEGER NOT NULL,
  pret_final NUMERIC NOT NULL,
  metoda_plata TEXT NOT NULL,
  vin TEXT NOT NULL,
  cod_dealer TEXT NOT NULL,
  cnp TEXT NOT NULL,
  PRIMARY KEY (nr_factura),
  FOREIGN KEY (vin) REFERENCES VEHICUL (vin),
  FOREIGN KEY (cod_dealer) REFERENCES DEALER (cod_dealer),
  FOREIGN KEY (cnp) REFERENCES CLIENT_AUTO (cnp),
  UNIQUE (vin),
  CHECK (garantie_luni >= 0),
  CHECK (pret_final >= 0)
);

CREATE TABLE MENTOR (
 id_mentor INTEGER NOT NULL PRIMARY KEY,
 nume_mentor TEXT NOT NULL,
 prenume_mentor TEXT NOT NULL,
 grad_profesional_mentor TEXT NOT NULL
);

CREATE TABLE ANGAJAT_FORMARE (
 id_angajat_formare INTEGER NOT NULL PRIMARY KEY,
 nume_angajat_formare TEXT NOT NULL,
 prenume_angajat_formare TEXT NOT NULL,
 functie_angajat_formare TEXT NOT NULL,
 id_mentor INTEGER NOT NULL REFERENCES MENTOR(id_mentor)
);
COMMIT;
