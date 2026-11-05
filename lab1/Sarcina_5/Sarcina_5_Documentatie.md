# Lucrarea de Laborator Nr. 1: Proiectarea Conceptuală
## Sarcina 5: Controlul Vânzărilor „Auto-Star”

---

### 1. Modelul Conceptual al Problemei (Diagrama ER/EER)

#### a. Identificarea Entităților și a Atributelor
Sistemul de distribuție auto „Auto-Star” gestionează parcursul mașinilor din fabrică până la livrare:
1. **`MARCA`** (Punctul de origine al ierarhiei de producție):
   * `id_marca` (INT, **Primary Key**): ID intern producător.
   * `nume_marca` (VARCHAR(50), **UNIQUE, NOT NULL**): Ex: `Toyota`, `BMW`, `Mercedes-Benz`.
   * `tara_provenienta` (VARCHAR(50), **NOT NULL**): Ex: Japonia, Germania.
2. **`MODEL`** (Gama de fabricație subordonată mărcii):
   * `cod_intern` (VARCHAR(30), **Primary Key**): Ex: `COR-2026`, `X5-G05`.
   * `nume_model` (VARCHAR(60), **NOT NULL**): Ex: `Corolla Hybrid`, `X5 xDrive40i`.
   * `pret_baza` (DECIMAL(12,2), **NOT NULL**): Costul variantei standard fără dotări adiționale.
   * `clasa_vehicul` (VARCHAR(30), **NOT NULL**): Sedan, SUV, Compactă, Coupe.
   * `id_marca` (INT, **Foreign Key**): Marca mamă căreia îi aparține obligatoriu modelul.
3. **`VEHICUL`** (Produsul finit unic – Superclasă EER):
   * `vin` (CHAR(17), **Primary Key**): Seria unică de șasiu standardizată ISO (17 caractere alfanumerice).
   * `culoare` (VARCHAR(30), **NOT NULL**): Culoarea caroseriei aplicată în fabrică.
   * `an_fabricatie` (INT, **NOT NULL**): Anul ieșirii de pe linia de asamblare.
   * `capacitate_motor_cm3` (INT, **NOT NULL**): Cilindreea motorului.
   * `numar_km` (INT, **NOT NULL**): Kilometrajul acumulat pe durata tranzitului logistic.
   * `pret_lista_total` (DECIMAL(12,2), **NOT NULL**): **Atribut Derivat** ($Pret_{Baza} + \sum Cost_{Dotari}$).
   * `norma_poluare` (VARCHAR(30)) – *Atribut Suplimentar 1*: Standardul de emisii.
   * `status_vehicul` (VARCHAR(30), **NOT NULL**): `In Fabrica`, `In Tranzit`, `In Stoc Dealer`, `Livrat Client`.
   * `cod_model` (VARCHAR(30), **Foreign Key**).
   * `cod_dealer_custode` (VARCHAR(20), **Foreign Key**): Dealerul în al cărui parc auto se află vehiculul.
4. **`DOTARE_OPTIONALA`** (Catalogul centralizat de dotări):
   * `cod_dotare` (VARCHAR(20), **Primary Key**): Ex: `DOT-001`, `DOT-002`.
   * `denumire` (VARCHAR(100), **NOT NULL**): Ex: `Trapă panoramică`, `Scaune din piele Merino`.
   * `cost_suplimentar` (DECIMAL(10,2), **NOT NULL**): Prețul de listă al opțiunii.
   * `categorie_dotare` (VARCHAR(50), **NOT NULL**): Interior, Exterior, Siguranță, Infotainment.
5. **`VEHICUL_DOTARI`** (Configurația asamblată în fabrică – Relație M:N):
   * `vin` (CHAR(17), **Primary Key**, **Foreign Key**).
   * `cod_dotare` (VARCHAR(20), **Primary Key**, **Foreign Key**).
   * `data_montare_fabrica` (DATE, **NOT NULL**).
6. **`DEALER`** (Distribuitorul autorizat / custodele vehiculului):
   * `cod_dealer` (VARCHAR(20), **Primary Key**): Ex: `DLR-MD-01`.
   * `denumire` (VARCHAR(100), **NOT NULL**): Ex: `Auto-Star Centru Chișinău`.
   * `adresa_fizica` (VARCHAR(200), **NOT NULL**), `oras` (VARCHAR(50)), `telefon_contact` (VARCHAR(25)).
7. **`CLIENT`** (Cumpărătorul final):
   * `cnp` (VARCHAR(13), **Primary Key**): Codul numeric personal unic.
   * `nume` (VARCHAR(50)), `prenume` (VARCHAR(50)).
   * `serie_numar_buletin` (VARCHAR(20), **NOT NULL**): Datele actului de identitate.
   * `adresa_domiciliu` (VARCHAR(200)), `telefon` (VARCHAR(25)).
8. **`VANZARE`** (Contractul comercial de încheiere a tranzacției):
   * `nr_factura` (VARCHAR(30), **Primary Key**): Numărul facturii fiscale emise.
   * `data_facturarii` (DATE, **NOT NULL**).
   * `perioada_garantie_luni` (INT, **NOT NULL**): Numărul de luni de garanție acordate (ex: 36, 60 luni).
   * `pret_final_negociat` (DECIMAL(12,2), **NOT NULL**): Suma achitată efectiv de cumpărător.
   * `metoda_plata` (VARCHAR(30)) – *Atribut Suplimentar 2*: Opțiunea financiară.
   * `reducere_dealer_acordata` (DECIMAL(10,2)) – *Atribut Suplimentar 3*: Discountul comercial.
   * `vin` (CHAR(17), **Foreign Key**, **UNIQUE**): Un vehicul nou se vinde o singură dată.
   * `cod_dealer` (VARCHAR(20), **Foreign Key**).
   * `cnp_client` (VARCHAR(13), **Foreign Key**).

#### b. Ierarhia EER: Specializarea pe Sistemul de Propulsie
Entitatea `VEHICUL` a fost specializată după tehnologia de tracțiune într-o ierarhie **disjunctă `{d}` și totală**:
* **`VEHICUL_ELECTRIC`:** atribute specifice `capacitate_baterie_kwh`, `autonomie_wltp_km`, `timp_incarcare_min`.
* **`VEHICUL_TERMIC`:** atribute specifice `emisii_co2_g_km`, `tip_combustibil` (Benzină / Motorină), `rezervor_litri`.
* **`VEHICUL_HIBRID`:** atribute specifice `capacitate_baterie_kwh`, `autonomie_electric_km`, `tip_hibrid` (PHEV / Full Hybrid).

#### c. Relația 1:1 Dintre Vehicul și Vânzare
Fiecare mașină fabricată ca nouă poate fi vândută către client o singură dată în cadrul acestui flux:
* Prin marcarea coloanei `vin` din tabela `VANZARE` cu atributul `UNIQUE`, se obține o cardinalitate strictă **1:1**.
* Relația dintre `DEALER` și `VANZARE` este **1:N** (dealerul emite sute de facturi).
* Relația dintre `CLIENT` și `VANZARE` este **1:N** (un client fidel poate achiziționa mai multe vehicule în timp).

---

### 2. Extinderea Modelului cu 3 Atribute Suplimentare Justificate

1. **`VEHICUL.norma_poluare` (VARCHAR(30))**
   * *Justificare:* Standardul ecologic (ex: `Euro 6d-ISC-FCM`, `Euro 7`, `Zero Emisii EV`) este obligatoriu prin lege la omologarea și înmatricularea fiecărui vehicul, stabilind cuantumul taxelor de mediu și dreptul de acces în zonele urbane cu emisii reduse.
2. **`VANZARE.metoda_plata` (VARCHAR(30))**
   * *Justificare:* Valori: `Transfer Bancar Integral`, `Leasing Financiar`, `Credit Auto`, `Cash (în limita plafonului legal)`. Atributul este indispensabil pentru departamentul de contabilitate, conformitatea cu legislația împotriva spălării banilor (AML) și fluxul de eliberare a cărții de identitate a vehiculului către compania de leasing.
3. **`VANZARE.reducere_dealer_acordata` (DECIMAL(10,2))**
   * *Justificare:* Reprezintă diferența matematică dintre prețul de listă total al mașinii și prețul final negociat ($Pret_{Lista} - Pret_{Negociat}$). Este esențială pentru analiza rentabilității dealerului, auditul performanței agenților de vânzări și verificarea respectării pragurilor maxime de discount autorizate de fabrică.

---

### 3. Modelul Relațional Rezultat și Reguli de Integritate

* `MARCI` (<u>id_marca</u>, nume_marca, tara_provenienta)
* `MODELE` (<u>cod_intern</u>, nume_model, pret_baza, clasa_vehicul, #id_marca)
* `VEHICULE` (<u>vin</u>, culoare, an_fabricatie, capacitate_motor_cm3, numar_km, pret_lista_total, norma_poluare, status_vehicul, #cod_model, #cod_dealer_custode)
* `VEHICULE_ELECTRICE` (<u>#vin</u>, capacitate_baterie_kwh, autonomie_wltp_km, timp_incarcare_min)
* `VEHICULE_TERMICE` (<u>#vin</u>, emisii_co2_g_km, tip_combustibil, rezervor_litri)
* `VEHICULE_HIBRIDE` (<u>#vin</u>, capacitate_baterie_kwh, autonomie_electric_km, tip_hibrid)
* `DOTARI_OPTIONALE` (<u>cod_dotare</u>, denumire, cost_suplimentar, categorie_dotare)
* `VEHICULE_DOTARI` (<u>#vin</u>, <u>#cod_dotare</u>, data_montare_fabrica)
* `DEALERI` (<u>cod_dealer</u>, denumire, adresa_fizica, oras, telefon_contact)
* `CLIENTI` (<u>cnp</u>, nume, prenume, serie_numar_buletin, adresa_domiciliu, telefon)
* `VANZARI` (<u>nr_factura</u>, data_facturarii, perioada_garantie_luni, pret_final_negociat, metoda_plata, reducere_dealer_acordata, #vin, #cod_dealer, #cnp_client)

**Reguli de Integritate Referențială:**
* `MODELE.id_marca` $ightarrow$ `MARCI.id_marca` (`ON DELETE RESTRICT`)
* `VEHICULE.cod_model` $ightarrow$ `MODELE.cod_intern` (`ON DELETE RESTRICT`)
* `VEHICULE.cod_dealer_custode` $ightarrow$ `DEALERI.cod_dealer` (`ON DELETE RESTRICT`)
* `VEHICULE_DOTARI.vin` $ightarrow$ `VEHICULE.vin` (`ON DELETE CASCADE`)
* `VEHICULE_DOTARI.cod_dotare` $ightarrow$ `DOTARI_OPTIONALE.cod_dotare` (`ON DELETE RESTRICT`)
* `VANZARI.vin` $ightarrow$ `VEHICULE.vin` (`ON DELETE RESTRICT`, `UNIQUE`)
* `VANZARI.cod_dealer` $ightarrow$ `DEALERI.cod_dealer` (`ON DELETE RESTRICT`)
* `VANZARI.cnp_client` $ightarrow$ `CLIENTI.cnp` (`ON DELETE RESTRICT`)

---

### 4. Instanțe Concrete de Date (Exemple de Tupluri)

**Tabel: MARCI & MODELE**
* MARCI: `(1, 'BMW', 'Germania')`
* MODELE: `('X5-G05-2026', 'BMW X5 xDrive40i', 72000.00 EUR, 'SUV Premium', 1)`

**Tabel: DOTARI_OPTIONALE**
| cod_dotare (PK) | denumire | cost_suplimentar | categorie |
| :--- | :--- | :--- | :--- |
| **DOT-001** | Trapă panoramică din sticlă Sky Lounge | 2400.00 EUR | Confort Plafon |
| **DOT-002** | Scaune confortabile piele Merino | 3100.00 EUR | Tapițerie Interior |
| **DOT-003** | Sistem audio Bowers & Wilkins Diamond 3D | 3800.00 EUR | Multimedia Audio |

**Tabel: VEHICULE (Calculul Prețului de Listă Total)**
* VIN: `WBA11AA008N123456`
* Preț Bază Model: `72000.00 EUR`
* Sumă Dotări Montate: `2400 + 3100 + 3800 = 9300.00 EUR`
* **Preț de Listă Total Calculat:** `72000 + 9300 = 81300.00 EUR`
* Tuplu: `('WBA11AA008N123456', 'Mineral White', 2026, 2998, 15, 81300.00, 'Euro 6d-ISC-FCM', 'In Stoc Dealer', 'X5-G05-2026', 'DLR-MD-01')`

**Tabel: VANZARI (Tranzacția cu discountul dealerului)**
| nr_factura (PK) | data | garantie | pret_final_negociat | metoda_plata [+] | reducere_dealer [+] | vin (FK/UNIQUE) | client (FK) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **FACT-2026-0045** | 2026-05-18 | 48 luni | **77500.00 EUR** | Leasing Financiar | **3800.00 EUR** | WBA11AA008N123456 | 2001004123456 |

Fișierul asociat de diagramă este: `Sarcina_5_Auto_Star.drawio`.
