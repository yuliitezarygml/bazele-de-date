# Lucrarea de Laborator Nr. 1: Proiectarea Conceptuală
## Sarcina 4: Platforma de Tranzacționare „Colectioneri.md”

---

### 1. Modelul Conceptual al Problemei (Diagrama ER/EER)

#### a. Identificarea Entităților și a Atributelor
Platforma „Colectioneri.md” gestionează bunuri de valoare, utilizatori cu permisiuni multiple, licitări în timp real și evaluări:
1. **`MEMBRU`** (Superclasă EER – Utilizatorul comunității):
   * `email` (VARCHAR(100), **Primary Key**): Identificator unic de autentificare.
   * `parola_criptata_hash` (VARCHAR(255), **NOT NULL**): Rezumatul criptografic (SHA-256/bcrypt).
   * `data_inregistrarii` (DATE, **NOT NULL**): Momentul deschiderii contului.
   * `status_cont` (VARCHAR(20), **NOT NULL**): `Activ`, `Suspendat`, `In Verificare`.
   * `este_cumparator` (BOOLEAN), `este_vanzator` (BOOLEAN): Discriminatori pentru roluri.
2. **`CUMPARATOR`** (Subclasă EER specializată):
   * `email` (VARCHAR(100), **Primary Key**, **Foreign Key**).
   * `adresa_livrare_detaliata` (VARCHAR(255), **NOT NULL**): Adresa completă pentru curierat securizat.
   * `limita_credit_licitare` (DECIMAL(12,2), **NOT NULL**): Suma maximă autorizată în licitații.
3. **`VANZATOR`** (Subclasă EER specializată):
   * `email` (VARCHAR(100), **Primary Key**, **Foreign Key**).
   * `cont_iban` (VARCHAR(34), **NOT NULL**): Cont bancar verificat pentru transferul fondurilor.
   * `telefon_asistenta` (VARCHAR(25), **NOT NULL**): Număr de contact dedicat verificării.
   * `rating_incredere` (DECIMAL(3,2), **NOT NULL**): Notă medie calculată automat (1.00 – 5.00 stele).
4. **`CATEGORIE`** (Clasificarea tematică a catalogului):
   * `id_categorie` (INT, **Primary Key**): Identificator numeric unic.
   * `denumire_categorie` (VARCHAR(100), **NOT NULL**): Ex: `Pictură Europeană`, `Numismatică Antică`, `Ceasuri de Epocă`.
   * `comision_procent` (DECIMAL(5,2), **NOT NULL**): Comisionul perceput de platformă (ex: 7.50%).
   * `durata_licitatie_zile` (INT, **NOT NULL**): Durata normată a unei sesiuni (ex: 7, 14, 30 zile).
5. **`OBIECT`** (Articolul de colecție scos la licitație):
   * `cod_inventar` (VARCHAR(30), **Primary Key**): Cod unic al bunului (ex: `OBJ-ART-9921`).
   * `titlu` (VARCHAR(150), **NOT NULL**): Denumirea comercială atractivă.
   * `descriere_stare` (TEXT, **NOT NULL**): Expertiza stării de conservare, patină, restaurări.
   * `pret_pornire` (DECIMAL(12,2), **NOT NULL**): Prețul de deschidere al licitației.
   * `data_lansare` (DATETIME, **NOT NULL**), `data_expirare` (DATETIME, **NOT NULL**).
   * `status_licitatie` (VARCHAR(30), **NOT NULL**): `Activa`, `Adjudecata`, `Retrasa`, `Expirata Fara Oferte`.
   * `pas_minim_licitare` (DECIMAL(10,2)) – *Atribut Suplimentar 1*: Pragul de incrementare.
   * `pret_rezerva` (DECIMAL(12,2)) – *Atribut Suplimentar 2*: Pragul secret de vânzare.
   * `email_vanzator` (VARCHAR(100), **Foreign Key**): Proprietarul care listează obiectul.
   * `id_categorie` (INT, **Foreign Key**): Categoria din care face parte.
   * `email_castigator` (VARCHAR(100), **Foreign Key**, **NULL**): Cumpărătorul care a câștigat.
6. **`OFERTA_LICITARE`** (Evenimentul dinamic de bid):
   * `id_oferta` (INT, **Primary Key**): ID secvențial unicitate.
   * `suma_oferita` (DECIMAL(12,2), **NOT NULL**): Valoarea propusă de licitator.
   * `marca_temporala` (DATETIME(6), **NOT NULL**): Marcă temporală de înaltă precizie (microsecunde).
   * `ip_origina` (VARCHAR(45), **NOT NULL**): Adresa IP de audit.
   * `cod_inventar` (VARCHAR(30), **Foreign Key**).
   * `email_cumparator` (VARCHAR(100), **Foreign Key**).
7. **`FEEDBACK`** (Evaluarea reputației post-adjudecare):
   * `id_feedback` (INT, **Primary Key**).
   * `nota_evaluare` (INT, **NOT NULL**, **CHECK 1..10**): Nota acordată de cumpărător vânzătorului.
   * `comentariu_text` (TEXT, **NOT NULL**): Descrierea calității împachetării, autenticității etc.
   * `data_feedback` (DATETIME, **NOT NULL**).
   * `raspuns_vanzator` (TEXT) – *Atribut Suplimentar 3*: Răspunsul public al vânzătorului.
   * `cod_inventar` (VARCHAR(30), **Foreign Key**, **UNIQUE**): Un singur feedback per obiect tranzacționat.
   * `email_cumparator` (VARCHAR(100), **Foreign Key**).
   * `email_vanzator` (VARCHAR(100), **Foreign Key**).

#### b. Analiza Ierarhiei EER: De ce Specializarea este Suprapusă {o} (Overlapping)?
Conform textului cerinței:
> „Regulamentul platformei permite ca un membru să fie în același timp și cumpărător și vânzător, însă există membri care aleg să rămână doar la un singur rol.”

Aceasta este definiția clasică a unei **specializări suprapuse (overlapping - `{o}`)**:
* O persoană care vinde o colecție de monede vechi poate utiliza fondurile obținute pentru a licita la o pictură.
* Astfel, instanța `email` din superclasa `MEMBRU` poate coexista simultan atât în tabela `CUMPARATOR`, cât și în tabela `VANZATOR`.
* Ierarhia este **parțială**, deoarece un utilizator abia înregistrat poate avea statut simplu de observator înainte de a-și completa adresa de livrare sau contul IBAN.

#### c. Limite de Participare (min, max)
* `VANZATOR` $ightarrow$ `(0, N)` către `OBIECT` (1, 1): Un vânzător poate avea 0 sau N obiecte listate.
* `CUMPARATOR` $ightarrow$ `(0, N)` către `OFERTA_LICITARE` (1, 1).
* `OBIECT` $ightarrow$ `(0, N)` către `OFERTA_LICITARE` (1, 1).
* `OBIECT` $ightarrow$ `(0, 1)` către `FEEDBACK` (1, 1): Doar obiectele adjudecate primesc feedback (maxim 1).

---

### 2. Extinderea Modelului cu 3 Atribute Suplimentare Justificate

1. **`OBIECT.pas_minim_licitare` (DECIMAL(10,2))**
   * *Justificare:* Fără un pas minim (ex: 50 EUR pentru obiecte scumpe, 10 MDL pentru obiecte uzuale), utilizatorii rău-intenționați sau roboții automați ar supralicita cu 0.01 EUR în ultimele fracțiuni de secundă, blocând baza de date și perturbând dinamica normală a pieței.
2. **`OBIECT.pret_rezerva` (DECIMAL(12,2))**
   * *Justificare:* Prețul de rezervă este suma minimă confidențială sub care vânzătorul refuză înstrăinarea bunului de patrimoniu. Dacă la expirarea timpului cea mai mare ofertă este sub prețul de rezervă, obiectul nu este considerat adjudecat, protejând vânzătorul de pierderi neprevăzute.
3. **`FEEDBACK.raspuns_vanzator` (TEXT)**
   * *Justificare:* Asigură transparența și principiul dreptului la replică în cadrul sistemului de reputație. Vânzătorul poate aduce clarificări publice în cazul în care cumpărătorul lasă o recenzie nefavorabilă din cauza întârzierilor provocate de transportator sau vamă.

---

### 3. Modelul Relațional Rezultat și Reguli de Integritate

* `MEMBRI` (<u>email</u>, parola_criptata_hash, data_inregistrarii, status_cont, este_cumparator, este_vanzator)
* `CUMPARATORI` (<u>#email</u>, adresa_livrare_detaliata, limita_credit_licitare)
* `VANZATORI` (<u>#email</u>, cont_iban, telefon_asistenta, rating_incredere)
* `CATEGORII` (<u>id_categorie</u>, denumire_categorie, comision_procent, durata_licitatie_zile)
* `OBIECTE` (<u>cod_inventar</u>, titlu, descriere_stare, pret_pornire, data_lansare, data_expirare, status_licitatie, pas_minim_licitare, pret_rezerva, #email_vanzator, #id_categorie, #email_castigator)
* `OFERTE_LICITARE` (<u>id_oferta</u>, suma_oferita, marca_temporala, ip_origina, #cod_inventar, #email_cumparator)
* `FEEDBACK_URI` (<u>id_feedback</u>, nota_evaluare, comentariu_text, data_feedback, raspuns_vanzator, #cod_inventar, #email_cumparator, #email_vanzator)

**Reguli de Integritate Referențială:**
* `CUMPARATORI.email` $ightarrow$ `MEMBRI.email` (`ON DELETE CASCADE`)
* `VANZATORI.email` $ightarrow$ `MEMBRI.email` (`ON DELETE CASCADE`)
* `OBIECTE.email_vanzator` $ightarrow$ `VANZATORI.email` (`ON DELETE RESTRICT`)
* `OBIECTE.id_categorie` $ightarrow$ `CATEGORII.id_categorie` (`ON DELETE RESTRICT`)
* `OBIECTE.email_castigator` $ightarrow$ `CUMPARATORI.email` (`ON DELETE SET NULL`)
* `OFERTE_LICITARE.cod_inventar` $ightarrow$ `OBIECTE.cod_inventar` (`ON DELETE CASCADE`)
* `OFERTE_LICITARE.email_cumparator` $ightarrow$ `CUMPARATORI.email` (`ON DELETE RESTRICT`)
* `FEEDBACK_URI.cod_inventar` $ightarrow$ `OBIECTE.cod_inventar` (`ON DELETE RESTRICT`, `UNIQUE`)

---

### 4. Instanțe Concrete de Date (Exemple de Tupluri)

**Tabel: MEMBRI (Demonstrație rol suprapus vs simplu)**
| email (PK) | status_cont | este_cumparator | este_vanzator | ROL REZULTAT |
| :--- | :--- | :--- | :--- | :--- |
| **mihai.antichitati@gmail.com** | Activ | **TRUE** | **TRUE** | **Rol Dublu (Vinde și Cumpără)** |
| **alexandru.buyer@yahoo.com** | Activ | **TRUE** | **FALSE** | **Exclusiv Cumpărător** |

**Tabel: CUMPARATORI & VANZATORI**
* CUMPARATORI: `(mihai.antichitati@gmail.com, str. Livezilor 10, Chișinău, 15000.00 EUR)`
* CUMPARATORI: `(alexandru.buyer@yahoo.com, bd. Moscova 5, Chișinău, 25000.00 EUR)`
* VANZATORI: `(mihai.antichitati@gmail.com, MD24AGRN000012345678, +37369112233, 4.95 stele)`

**Tabel: OBIECTE**
| cod_inv (PK) | titlu | pret_start | pas_min [+] | pret_rezerva [+] | vanzator (FK) | status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **OBJ-ART-9921** | Monedă Drahma Aur sec. IV î.Hr. | 4500.00 EUR | 50.00 EUR | 6000.00 EUR | mihai.antichitati@... | Adjudecata |

**Tabel: OFERTE_LICITARE (Rezoluție concurențială fină)**
| id_of (PK) | suma_oferita | marca_temporala (DATETIME(6)) | ip_origina | cod_inv (FK) | cumparator (FK) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **1001** | 4550.00 EUR | 2026-04-12 18:45:10.142851 | 188.237.40.11 | OBJ-ART-9921 | alexandru.buyer@... |
| **1002** | 4600.00 EUR | 2026-04-12 18:45:12.805210 | 85.204.10.92 | OBJ-ART-9921 | victor.collector@... |
| **1003** | 6200.00 EUR | 2026-04-12 19:59:58.914205 | 188.237.40.11 | OBJ-ART-9921 | alexandru.buyer@... *(Câștigător)* |

**Tabel: FEEDBACK_URI**
| id_fb (PK) | nota | comentariu_text | raspuns_vanzator [+] | cod_inv | cump | vanz |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **1** | **10** | Autenticitate confirmată la muzeu, ambalare ermetică. | Vă mulțumesc! A fost o onoare să colaborez cu un fin cunoscător. | OBJ-ART-9921 | alexandru... | mihai... |

Fișierul asociat de diagramă este: `Sarcina_4_Colectioneri_md.drawio`.
