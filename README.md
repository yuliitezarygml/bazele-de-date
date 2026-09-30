# Proiect Baze de Date: Lucrarea de Laborator Nr. 1 (2026)
## Proiectarea Conceptuală și Relațională

Acest director conține rezolvarea integrală, academică și completă a **Lucrării de Laborator Nr. 1 (2026)** la unitatea de curs **Baze de date**.

---

### Structura Proiectului pe Sarcină și Fișiere

Fiecare sarcină din caietul de laborator este organizată în **fișiere separate**, conform cerinței:

```text
Laborator_1_Baze_de_Date/
├── Sarcina_1/
│   ├── Sarcina_1_Proiectare_Simpla.drawio    <- Model ER Chen (dreptunghiuri, romburi, cercuri)
│   ├── Sarcina_1_Tabele_Exemple.drawio       <- Tabele relaționale cu exemple de date și legături PK-FK
│   ├── Sarcina_1_Tabele_Access.drawio        <- Схема данных și tabele în stil Microsoft Access (1:∞, PK 🔑, FK 🔗, Subdatasheets)
│   └── Sarcina_1_Documentatie.md             <- Documentație detaliată și reguli de mapare
├── Sarcina_2/
│   ├── Sarcina_2_Clinica_Veterinara.drawio   <- Model ER Chen Clinica «PetCare Plus»
│   ├── Sarcina_2_Tabele_Exemple.drawio       <- Tabele relaționale cu tupluri (demonstrație omonimie)
│   └── Sarcina_2_Documentatie.md             <- Documentație, atribute extinse și ierarhie EER
├── Sarcina_3/
│   ├── Sarcina_3_Global_Express.drawio       <- Model ER Chen Logistica «Global Express»
│   ├── Sarcina_3_Tabele_Exemple.drawio       <- Tabele relaționale cu rute, checkpoint-uri și colete
│   └── Sarcina_3_Documentatie.md             <- Documentație, rute ordonate și trasabilitate
├── Sarcina_4/
│   ├── Sarcina_4_Colectioneri_md.drawio      <- Model ER Chen Platforma «Colectioneri.md»
│   ├── Sarcina_4_Tabele_Exemple.drawio       <- Tabele relaționale cu oferte, licitații și feedback
│   └── Sarcina_4_Documentatie.md             <- Documentație, roluri suprapuse și licitații
├── Sarcina_5/
│   ├── Sarcina_5_Auto_Star.drawio            <- Model ER Chen Vânzări «Auto-Star»
│   ├── Sarcina_5_Tabele_Exemple.drawio       <- Tabele relaționale cu calcul preț listă și vânzări
│   └── Sarcina_5_Documentatie.md             <- Documentație, dotări M:N și tranzacții
├── Intrebari_Control/
│   └── Intrebari_Control_Laborator_1.md      <- Răspunsuri la toate cele 30 de întrebări din laborator
└── README.md                                 <- Ghid general de utilizare și vizualizare
```

---

### Conținutul și Evidența Tehnică a Fiecărui Modul

1. **Sarcina 1: Proiectarea conceptuală simplă**
   * *1.A: Academică (Catedră - Angajat):* Relație 1:N simplă, migrare PK în FK.
   * *1.B: Sportiv (Echipă - Jucător):* Relație 1:N cu unicitate număr de tricou pe echipă.
   * *1.C: Editorială (Autor - Carte):* Relație M:N descompusă printr-o tabelă de joncțiune (`AUTOR_CARTE`) cu atribute proprii de drepturi de autor.
   * *1.D: Juridică (Client - Contract):* Relație 1:N cu participare totală pentru contract și parțială pentru client.
   * *1.E: Mentorat (Mentor - Mentee / Ierarhie de Mentorat):* Modelat conceptual prin 2 entități distincte (`MENTOR` și `MENTEE`) asociate prin rombul `Ghidează_Mentorat` (cu atribute de legătură proprii: chei externe și dată start), împreună cu explicarea mapării relaționale directe (2 tabele) și a unificării recursive (tabel unic cu `id_mentor`).
2. **Sarcina 2: Clinica veterinară „PetCare Plus”**
   * Entitate slabă `ANIMAL` în raport cu `PROPRIETAR`, rezolvând problema omonimiei (câini cu același nume la proprietari diferiți).
   * Ierarhie EER de specializare disjunctă `{d}`: `CAINE`, `PISICA`, `EXOTIC_PASARE`.
   * **3 Atribute Suplimentare Justificate:** `adresa_email`, `greutate_kg`, `tratament_prescris`.
3. **Sarcina 3: Managementul logisticii „Global Express”**
   * Rol dual pentru entitatea `CLIENT` (Expeditor și Destinatar pe același colet).
   * Secvențierea itinerariului prin tabela ordonată `RUTA_SEGMENTE` (cheie compusă).
   * Evenimentul de trasabilitate la checkpoint `SCANARE_EVENIMENT`.
   * Ierarhie EER disjunctă `{d}` pe infrastructură: `HUB_AEROPORTUAR`, `DEPOZIT_REGIONAL`, `CENTRU_SORTARE`.
   * **3 Atribute Suplimentare Justificate:** `volum_cm3`, `status_curent`, `flag_deviere_ruta`.
4. **Sarcina 4: Platforma de tranzacționare „Colectioneri.md”**
   * Ierarhie EER de **specializare suprapusă `{o}` (overlapping)**: un membru poate fi simultan și cumpărător și vânzător.
   * Dinamica licitațiilor cu rezoluție fină a mărcii temporale (`DATETIME(6)`) pentru partajarea ofertelor concurente.
   * Sistem de feedback 1:1 post-vânzare cu drept de replică.
   * **3 Atribute Suplimentare Justificate:** `pas_minim_licitare`, `pret_rezerva`, `raspuns_vanzator`.
5. **Sarcina 5: Controlul vânzărilor „Auto-Star”**
   * Ierarhia de producție: `MARCA` $
ightarrow$ `MODEL` $
ightarrow$ `VEHICUL` (identificat prin VIN din 17 caractere).
   * Catalog de dotări opționale montate în fabrică prin tabela asociativă `VEHICUL_DOTARI` (M:N).
   * Calculul atributului derivat `Pret_Lista_Total` și negocierea dealerului reflectată în `VANZARE`.
   * Ierarhie EER disjunctă `{d}` după sistemul de propulsie: `VEHICUL_ELECTRIC`, `VEHICUL_TERMIC`, `VEHICUL_HIBRID`.
   * **3 Atribute Suplimentare Justificate:** `norma_poluare`, `metoda_plata`, `reducere_dealer_acordata`.
6. **Întrebări pentru control (30 de întrebări complet rezolvate)**
   * Documentație academică riguroasă acoperind toți termenii: SGBD, tupluri, domenii, chei candidate vs primare vs superchei, participare totală/parțială, reguli de mapare 1:1, 1:N, M:N, recursive, entități slabe, atribute derivate și atribute multivaluate.

---

### Convenția de Notare ER (Notația Chen Clasic în Diagramele .drawio)

Conform modelării conceptuale academice:
1. **Entitățile:** reprezentate prin **dreptunghiuri** (`[NUME_ENTITATE]`).
2. **Asocierile / Relațiile:** reprezentate prin **romburi** (`<Nume_Relație>`).
3. **Legăturile:** realizate prin săgeți etichetate explicit cu rapoartele de cardinalitate: **1 la N**, **1 la 1**, **M la N**.
4. **Atributele:** reprezentate prin **cercuri / elipse** legate de entitate sau romb prin **linii simple** (fără săgeți):
   * **Cheia Principală (PK):** subliniată cu **<u>linie continuă</u>**.
   * **Cheia Străină / Secundară (FK):** subliniată cu **<span style="text-decoration: underline dashed;">linie întretăiată (dashed)</span>**.
   * **Atribut Derivat:** reprezentat prin elipsă cu contur întrerupt.
5. **Separarea Documentației:** Diagramele `.drawio` sunt strict conceptuale (fără tabele aglomerate sau notițe pe canvas). Toate explicațiile detaliate, regulile de mapare relațională, tabelele relaționale și exemplele concrete de date sunt organizate în fișierele Markdown (`.md`) asociate fiecărei sarcini.

---

### Cum se Deschid și se Editează Fișierele `.drawio`
Fișierele generate sunt fișiere XML native **draw.io** (diagrams.net). Le puteți vizualiza și edita în trei moduri simple:
1. **Online în browser (Fără instalare):**
   * Accesați [https://app.diagrams.net](https://app.diagrams.net)
   * Selectați **Open Existing Diagram** și alegeți fișierul `.drawio` dorit din folder.
2. **În Visual Studio Code / WebStorm / PyCharm:**
   * Instalați extensia **Draw.io Integration** (de Henning Dieterichs).
   * Dați dublu-click pe oricare fișier `.drawio` din explorator pentru a deschide direct editorul vizual integrat.
3. **În aplicația Desktop Draw.io:**
   * Descărcați gratuit aplicația oficială de pe [jgraph.github.io/drawio-desktop](https://jgraph.github.io/drawio-desktop/) și deschideți fișierele.
# bazele-de-date
