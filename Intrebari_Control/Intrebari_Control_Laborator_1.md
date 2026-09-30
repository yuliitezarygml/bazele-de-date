# Lucrarea de Laborator Nr. 1: Proiectarea Conceptuală
## Răspunsuri la Întrebările pentru Control (Pagina 10 din Lucrare)

---

### 1. Ce este o bază de date?
O **bază de date** (Database) este o colecție structurată, organizată și integrată de date interconectate logic, stocate pe suporturi de memorie permanentă, proiectată pentru a deservi eficient una sau mai multe aplicații prin evitarea redundanței și asigurarea consistenței datelor.

### 2. Ce sunt datele?
**Datele** reprezintă reprezentări brute, neprelucrate, ale unor fapte, evenimente, obiecte, măsurători sau observații din lumea reală, exprimate prin simboluri (cifre, litere, imagini, coduri), lipsite de context semantic direct până la momentul interpretării lor pentru a deveni informație.

### 3. Ce este un SGBD (DBMS)?
Un **SGBD (Sistem de Gestiune a Bazelor de Date)** sau **DBMS (Database Management System)** este un ansamblu complex de programe software care permite definirea (DDL), manipularea (DML), interogarea (DQL) și controlul accesului (DCL) la date, asigurând totodată securitatea, integritatea, recuperarea în caz de avarie și gestiunea tranzacțiilor concurente (proprietățile ACID). Exemple: PostgreSQL, MySQL, Oracle DB, Microsoft SQL Server.

### 4. Ce este o entitate?
O **entitate** reprezintă un obiect, concept, eveniment, persoană sau fenomen distinct din lumea reală, cu existență independentă (fizică sau conceptuală), despre care o organizație dorește să colecteze și să stocheze date. Exemple: `Student`, `Medic`, `Automobil`, `Comandă`.

### 5. Ce este un atribut?
Un **atribut** este o proprietate, o caracteristică sau o trăsătură calitativă ori cantitativă care descrie o entitate sau o asociere între entități. În modelul relațional, atributele devin coloanele (câmpurile) unui tabel. Exemple pentru entitatea `Student`: `nume`, `prenume`, `data_nasterii`, `medie_admitere`.

### 6. Ce este o relație (asociere)?
În modelul conceptual ER, o **relație (asociere)** reprezintă o conexiune, un raport sau o interacțiune logică semnificativă între două sau mai multe entități. Semantic este descrisă printr-un verb. Exemplu: Studentul *urmează* un Curs; Medicul *consultă* un Pacient. În modelul relațional, termenul „relație” definește însăși tabela bidimensională.

### 7. Ce este un tuplu?
În modelul relațional fundamentat de E. F. Codd, un **tuplu** este o linie (o înregistrare / un rând) dintr-un tabel relațional. Un tuplu reprezintă o instanță unică și concretă a entității modelate, formată dintr-un set de valori asociate fiecărui atribut.

### 8. Ce este un domeniu?
Un **domeniu** este mulțimea tuturor valorilor atomice permise pe care le poate lua un anumit atribut. Domeniul definește tipul de date (ex: `INT`, `VARCHAR`, `DATE`), intervalul de valori acceptate (ex: `varsta BETWEEN 0 AND 120`), formatul și constrângerile specifice (`CHECK`).

### 9. Ce este o schemă de bază de date?
**Schema unei baze de date** este descrierea formală, structurală și abstractă a bazei de date (metadatele), proiectată la nivel conceptual sau logic. Ea include denumirile tabelelor, lista atributelor, tipurile de date, constrângerile de integritate, cheile primare și relațiile de cheie străină. Schema este statică și se modifică rar (prin comenzi `ALTER`).

### 10. Ce este o instanță a bazei de date?
O **instanță a bazei de date** (starea bazei de date) reprezintă colecția concretă de date stocată în tabele la un moment temporal specific (un „snapshot”). Spre deosebire de schemă, instanța este dinamică și se modifică permanent pe măsură ce utilizatorii introduc (`INSERT`), modifică (`UPDATE`) sau șterg (`DELETE`) date.

### 11. Ce este o cheie primară?
O **cheie primară (Primary Key - PK)** este un atribut sau un grup restrâns de atribute selectat de proiectant pentru a identifica unic și neechivoc fiecare tuplu dintr-un tabel. Cheia primară impune două restricții fundamentale de integritate:
1. **Unicitate:** nicio valoare de cheie primară nu se poate repeta.
2. **Integritatea entității (NOT NULL):** nicio componentă a cheii primare nu poate avea valoarea `NULL`.

### 12. Ce este o cheie străină?
O **cheie străină (Foreign Key - FK)** este un atribut (sau grup de atribute) dintr-un tabel copil care conține valori ce corespund cheii primare (sau unei chei unice) dintr-un tabel părinte. Rolul ei fundamental este de a crea puntea logică dintre tabele și de a garanta **integritatea referențială**.

### 13. Ce este un atribut derivat?
Un **atribut derivat** este un atribut a cărui valoare nu este introdusă manual ca atare, ci poate fi calculată sau dedusă dinamic din valorile altor atribute existente în baza de date. În diagramele ER este figurat cu o elipsă punctată. Exemple: `varsta` (derivată din `data_curenta - data_nasterii`), `pret_lista_total` (derivat prin sumarea prețului de bază cu opționalele).

### 14. Ce este o entitate slabă?
O **entitate slabă (Weak Entity)** este o entitate care nu posedă suficiente atribute proprii pentru a forma o cheie primară unică și a cărei existență depinde obligatoriu de o altă entitate, numită **entitate proprietară (dominantă / puternică)**. Identificarea ei se realizează prin combinarea cheii parțiale (discriminatorul) cu cheia primară a entității puternice. În diagramele ER este reprezentată printr-un dreptunghi dublu. Exemplu: `Camera` identificată doar în contextul unui `Hotel`.

### 15. Ce este cardinalitatea?
**Cardinalitatea** unei relații specifică numărul maxim de instanțe ale unei entități care pot fi asociate cu o singură instanță a altei entități participante. Există trei clase majore: **1:1** (Unu-la-Unu), **1:N** (Unu-la-Mulți) și **M:N** (Mulți-la-Mulți).

### 16. Care este diferența dintre cheia primară și cea străină?
* **Cheia primară (PK):** Identifică unic fiecare rând în *propriul* tabel, interzice cu desăvârșire duplicatele și valorile `NULL`, fiind unică pe tabel.
* **Cheia străină (FK):** Stabilește o legătură către un *alt* tabel, poate accepta valori duplicate (în relații 1:N) și poate fi `NULL` (dacă participarea este opțională), având ca scop menținerea integrității referențiale.

### 17. Cum pot identifica corect o entitate slabă în diagrame?
O entitate slabă se recunoaște după următoarele semne distinctive:
1. **Reprezentare grafică:** Dreptunghi dublu pentru entitate și romb dublu pentru relația de identificare.
2. **Cheia parțială (discriminatorul):** Atributul care distinge instanțele slabe în interiorul entității părinte este subliniat cu o linie întreruptă.
3. **Dependență existențială:** Entitatea nu poate avea instanțe orfane fără un părinte asociat.
4. **Participare totală (dublă linie)** către relația de identificare.

### 18. Ce înseamnă cardinalitatea 1:N?
Cardinalitatea **1:N (Unu-la-Mulți)** înseamnă că o singură instanță a entității $A$ poate fi asociată cu zero, una sau mai multe instanțe ale entității $B$, în timp ce fiecare instanță a entității $B$ poate fi asociată cu cel mult o singură instanță a entității $A$. Exemplu: O `Catedră` are mai mulți `Profesori`, dar un `Profesor` aparține unei singure `Catedre`.

### 19. Ce reprezintă gradul și cardinalitatea unei relații?
* **Gradul unei relații:** Reprezintă numărul de entități participante la asociere:
  * Grad 1 = *unar* sau *recursiv* (o entitate asociată cu ea însăși).
  * Grad 2 = *binar* (două entități diferite).
  * Grad 3 = *ternar* (trei entități diferite).
  * Grad $n$ = *$n$-ar*.
* **Cardinalitatea:** Reprezintă raportul numeric de asociere între instanțele acelor entități (1:1, 1:N, M:N).

### 20. Ce este o relație recursivă (auto-asociere)?
O **relație recursivă** (sau auto-asociere) este o relație de grad 1 în care aceeași entitate participă de mai multe ori în roluri semantice diferite. Exemplu clasic: Entitatea `Angajat` participă în rolul de `Mentor` (pe partea de 1) și în rolul de `Mentee/Învățăcel` (pe partea de N), implementată relațional prin adăugarea unei chei străine `id_mentor` care referențiază `id_angajat` din același tabel.

### 21. Care este diferența dintre o entitate puternică și o entitate slabă?
* **Entitatea puternică:** Are o existență autonomă în sistem, deține o cheie primară naturală sau generată formată exclusiv din atribute proprii și poate exista fără a depinde de alte entități.
* **Entitatea slabă:** Nu poate fi identificată unic fără contextul unei entități puternice, existența sa este subordonată acesteia, iar dacă entitatea dominantă este ștearsă, entitățile slabe asociate sunt de regulă șterse în cascadă (`CASCADE`).

### 22. Care este diferența dintre cheia candidată, cheia primară și supercheie?
* **Supercheie:** Orice set de unul sau mai multe atribute care identifică în mod unic un tuplu într-un tabel (poate conține și atribute redundante; ex: `{cnp, nume, email}`).
* **Cheie Candidată:** O **supercheie minimală**, adică un set de atribute din care nu se poate elimina niciun atribut fără a pierde proprietatea de identificare unică.
* **Cheie Primară:** Este acea cheie candidată anume **selectată oficial** de proiectantul bazei de date pentru a deveni mecanismul principal de identificare al tabelului. Celelalte chei candidate neselectate devin *chei alternative / unice*.

### 23. Ce diferențiază specializarea de generalizare?
* **Specializarea (abordare Top-Down):** Procesul prin care o superclasă existentă este descompusă în subclase specifice pe baza unor trăsături particulare (ex: din `Vehicul` desprindem `Vehicul_Electric` și `Vehicul_Termic`).
* **Generalizarea (abordare Bottom-Up):** Procesul invers, prin care mai multe tipuri de entități care au proprietăți similare sunt sintetizate într-o superclasă comună (ex: din `Medic` și `Asistent` sintetizăm superclasa `Personal_Spitalicesc`).

### 24. Care este diferența dintre participarea totală și participarea parțială?
* **Participare Totală (Dependență de Existență):** Fiecare instanță a entității trebuie să participe obligatoriu la cel puțin o legătură în acea relație. Se reprezintă prin linie dublă în ER și $min \ge 1$. În modelul relațional, cheia străină corespunzătoare este `NOT NULL`.
* **Participare Parțială:** Doar unele instanțe ale entității participă la relație ($min = 0$). Se reprezintă prin linie simplă în ER. În modelul relațional, cheia străină poate avea valoarea `NULL`.

### 25. Când ar trebui să modelăm un concept ca entitate și când ca atribut?
* Modelăm conceptul ca **atribut** dacă este o proprietate simplă, atomică, ce nu necesită detalieri suplimentare și are sens doar în contextul unei singure entități (ex: `culoare`, `greutate_kg`).
* Modelăm conceptul ca **entitate** dacă:
  1. Are o existență de sine stătătoare în lumea reală.
  2. Posedă la rândul său multiple atribute descriptive proprii (ex: adresa detaliată cu stradă, oraș, cod poștal).
  3. Participă în relații multiple cu alte entități din sistem.
  4. Poate avea valori multivaluate sau se repetă independent.

### 26. Ce se propune în situația în care o relație ternară nu poate fi descompusă în relații binare fără a pierde informație?
Dacă o relație de grad 3 (ternară) conține o semantică specifică indivizibilă (ex: un `Medic` prescrie un `Medicament` specific unui `Pacient` anume), descompunerea în 3 relații binare duce la „pierderea conexiunii ternare”. În acest caz se recomandă:
1. **Reificarea relației (Promovarea ca Entitate Asociativă):** Relația ternară este transformată într-o entitate de sine stătătoare (ex: `Prescriptie_Medicala`).
2. Entitatea nou creată se conectează prin 3 relații binare de tip `1:N` cu cele trei entități inițiale.
3. Cheia primară a noii entități va fi o cheie compusă din cheile primare ale celor trei entități sau o cheie surogat unică secondată de constrângerea de unicitate pe triplet.

### 27. Cum este transformată o relație de tip Mulți-la-Mulți (M:N) în modelul relațional?
O relație **M:N** nu poate fi mapată direct adăugând o cheie străină în tabelele existente. Ea se transformă prin:
1. Crearea unei **tabele asociative intermediare (tabel de joncțiune / linking table)**.
2. Tabela de joncțiune preia ca și chei străine cheile primare din ambele tabele participante.
3. **Cheia primară a tabelei asociative** este de regulă cheia compusă din cele două chei străine: $PK = (FK_1, FK_2)$.
4. Dacă relația M:N deținea atribute proprii în diagrama conceptuală (ex: `data_achizitie`, `cota_procentuala`), acestea devin coloane în tabela asociativă.
5. Relația M:N inițială este descompusă astfel în două relații binare de tip `1:N`.

### 28. Care este regula de mapare pentru un atribut multivaluat (de exemplu, mai multe numere de telefon pentru un singur angajat)?
Pentru a respecta **Prima Formă Normală (1NF)**, care interzice stocarea de liste sau mulțimi de valori într-o singură celulă:
1. Se creează un **nou tabel dedicat** acelui atribut multivaluat (ex: `TELEFOANE_ANGAJATI`).
2. Tabela nouă va conține:
   * Cheia străină către entitatea părinte (`id_angajat`).
   * Coloana cu valoarea atributului (`numar_telefon`).
3. **Cheia primară a noului tabel** va fi cheia compusă: `(id_angajat, numar_telefon)` sau o cheie primară surogat.

### 29. Cum se formează cheia primară a unei entități slabe în modelul relațional după mapare?
Cheia primară a unei entități slabe se formează conform regulii:
$$PK_{Entitate\_Slaba} = \{ PK_{Entitate\_Puternica} \} \cup \{ Discriminator / Cheie\_Partiala \}$$
Cheia primară a entității puternice migrează în tabela entității slabe ca și cheie străină (`NOT NULL`), participând simultan ca parte integrantă a cheii primare compuse a entității slabe. În implementările moderne, se poate adăuga o cheie primară surogat (ex: `id_animal INT AUTO_INCREMENT`), cu condiția ca perechea `(id_proprietar, discriminator)` să fie definită ca index unic (`UNIQUE`).

### 30. Ce opțiuni de implementare există pentru o relație 1:1, în funcție de participarea (totală sau parțială) a entităților?
Există trei strategii canonice de implementare a relațiilor **1:1**:
1. **Comasarea tabelelor (Single Table):** Dacă participarea este **totală pe ambele părți (1,1)-(1,1)**, cele două entități pot fi unificate într-un singur tabel relațional, eliminând necesitatea joncțiunilor.
2. **Cheie străină cu constrângere UNIQUE (Foreign Key Approach):**
   * Dacă o entitate are participare **totală** și cealaltă **parțială**, cheia primară a entității cu participare parțială se migrează ca FK în tabela cu participare totală, cu constrângerile `NOT NULL` și `UNIQUE`. Aceasta evită apariția valorilor `NULL` în tabel.
   * Dacă ambele au participare **parțială (0,1)-(0,1)**, FK poate fi plasată în oricare dintre tabele, cu atributul `UNIQUE` și acceptând `NULL`.
3. **Tabel de asociere separat (Cross-Reference Table):** Se utilizează o a treia tabelă pentru a memora perechile, având ambele FK-uri unice; soluție elegantă dacă participarea este extrem de rară (parțială masivă), evitând complet coloanele cu valori nule în tabelele de bază.
