# Laboratorul 1 — Proiectarea conceptuală

Sunt realizate exercițiile **1.A–1.E** și sarcinile **2–5**. Prezentarea folosește stilul exemplelor furnizate: tabele cu antete colorate, tipuri de date, PK/FK și tupluri, respectiv diagrame cu dreptunghiuri, romburi și ovale. Datele demonstrative sunt fictive.

## Fișiere principale

- `Lab1_Tabele_Relationale.drawio` — 9 pagini cu tabele legate, câte una pentru fiecare scenariu. Liniile au trasee separate, fără intersecții între ele, cu tabelele sau cu etichetele altor relații.
- `Lab1_Diagrame_Chen.drawio` — un plan general pentru 1.A–1.E și 9 pagini individuale cu diagrame.
- `Sarcina_1/` … `Sarcina_5/` — aceleași rezultate separate pe sarcini, în câte două fișiere (diagrame și tabele).
- `previzualizari/` — imagini PNG pentru consultare rapidă.

În Draw.io, paginile se schimbă din filele din partea de jos. Formele, textele, celulele și legăturile sunt editabile. Mutarea unei tabele păstrează împreună antetul, coloanele și tuplurile sale.

PK identifică în mod unic un rând; FK referă o cheie din alt tabel; PK/FK are ambele roluri; UQ marchează unicitatea. Un atribut UQ opțional (de exemplu microcip) nu este considerat cheie candidat pentru rândurile în care lipsește. Câmpurile marcate «calculat» sunt derivate și nu trebuie stocate redundant.

## Rezolvări și reguli

### 1.A — Organizarea academică

Un angajat aparține la cel mult o catedră: FK id_catedra permite NULL. Fiecare catedră are cel puțin un angajat; această regulă se validează suplimentar față de FK.

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|CATEDRA|id_catedra|—|
|ANGAJAT|id_angajat|id_catedra → CATEDRA.id_catedra|

### 1.B — Managementul sportiv

Modelul este pentru un singur sezon. Un jucător este legitimat la exact o echipă. Pentru mai multe sezoane se introduce LOT(id_jucator,sezon,id_echipa), cu PK(id_jucator,sezon).

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|ECHIPA|id_echipa|—|
|JUCATOR|id_jucator|id_echipa → ECHIPA.id_echipa|

### 1.C — Activitatea editorială

Conceptual: AUTOR — Scrie — CARTE este M:N. Relațional: AUTOR_CARTE are PK(id_autor,id_carte), ambele câmpuri FK. Un autor poate exista înaintea primei publicații.

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|AUTOR|id_autor|—|
|AUTOR_CARTE|id_autor, id_carte|id_autor → AUTOR.id_autor; id_carte → CARTE.id_carte|
|CARTE|id_carte|—|

### 1.D — Gestiunea juridică

Un client poate semna mai multe contracte, iar un contract este semnat de exact un client. id_client din CONTRACT este FK obligatorie.

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|CLIENT|id_client|—|
|CONTRACT|nr_contract|id_client → CLIENT.id_client|

### 1.E — Ierarhia de mentorat

Asociere recursivă: aceeași entitate ANGAJAT apare în rolurile Mentor și Discipol. Pentru angajații în formare, id_mentor este obligatoriu; pentru ceilalți poate fi NULL. id_mentor ≠ id_angajat; nu se admit cicluri.

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|ANGAJAT|id_angajat|id_mentor → ANGAJAT.id_angajat|

### Sarcina 2 — Clinica veterinară PetCare Plus

PROPRIETAR 1:N ANIMAL; ANIMAL 1:N CONSULTATIE; MEDIC 1:N CONSULTATIE. Un animal are un identificator propriu; numele nu este unic. Consultațiile păstrează istoricul pacientului, data/ora, diagnosticul, observațiile și costul. Asocierile sunt binare.

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|PROPRIETAR|id_proprietar|—|
|MEDIC|nr_legitimatie|—|
|ANIMAL|id_animal|id_proprietar → PROPRIETAR.id_proprietar|
|CONSULTATIE|id_consultatie|id_animal → ANIMAL.id_animal; id_medic → MEDIC.nr_legitimatie|

Cele trei atribute suplimentare:

- **telefon** — Contactarea rapidă a proprietarului.
- **microcip** — Identificarea sigură a animalului; unic când există, NULL permis.
- **status** — Distinge vizitele programate, efectuate și anulate.

### Sarcina 3 — Global Express

Un client poate avea ambele roluri: expeditor și destinatar. Tipul fizică/juridică este atribut al clientului. SCANARE materializează evenimentul dintre colet, punct și angajat. Segmentele unei rute sunt ordonate și consecutive; intrările și ieșirile sunt evenimente separate.

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|CLIENT|id_client|—|
|COLET|tracking_id|id_expeditor → CLIENT.id_client; id_destinatar → CLIENT.id_client; id_ruta → RUTA.id_ruta|
|RUTA|id_ruta|—|
|RUTA_SEGMENT|id_ruta, pozitie|id_ruta → RUTA.id_ruta; id_segment → SEGMENT.id_segment|
|SCANARE|id_scanare|tracking_id → COLET.tracking_id; id_punct → PUNCT_TRANZIT.id_punct; id_angajat → ANGAJAT.id_angajat|
|PUNCT_TRANZIT|id_punct|—|
|SEGMENT|id_segment|id_plecare → PUNCT_TRANZIT.id_punct; id_sosire → PUNCT_TRANZIT.id_punct|
|ANGAJAT|id_angajat|—|

Cele trei atribute suplimentare:

- **email** — Transmiterea notificărilor clientului.
- **status** — Urmărirea stării curente a coletului.
- **functie** — Identificarea responsabilității angajatului.

RUTA_SEGMENT are cheia compusă (id_ruta,pozitie). Fiecare segment are plecare și sosire; sosirea segmentului k trebuie să coincidă cu plecarea segmentului k+1. O scanare identifică un eveniment colet–punct–angajat; intrarea și ieșirea sunt două evenimente distincte, cu marcaje temporale proprii. Compararea punctelor scanate cu traseul rutei permite detectarea abaterilor.

### Sarcina 4 — Colectioneri.md

Un membru poate avea profil de cumpărător și/sau vânzător; fiecare profil referă exact un membru. Se păstrează toate ofertele. Câștigă suma maximă, apoi momentul anterior și id_oferta. Oferta câștigătoare aparține licitației. Feedback unic, numai de la câștigător, după finalizare. Rating = 1 + 4×(AVG(nota)−1)/9; fără feedback este NULL.

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|MEMBRU|email|—|
|CUMPARATOR|email|email → MEMBRU.email|
|VANZATOR|email|email → MEMBRU.email|
|OFERTA|id_oferta|id_licitatie → LICITATIE.id_licitatie; email_cumparator → CUMPARATOR.email|
|LICITATIE|id_licitatie|id_obiect → OBIECT.id_obiect|
|OBIECT|id_obiect|email_vanzator → VANZATOR.email; id_categorie → CATEGORIE.id_categorie|
|ADJUDECARE|id_licitatie|id_licitatie → LICITATIE.id_licitatie; id_oferta_castigatoare → OFERTA.id_oferta|
|FEEDBACK|id_licitatie|id_licitatie → ADJUDECARE.id_licitatie|
|CATEGORIE|id_categorie|—|

Cele trei atribute suplimentare:

- **moneda** — Clarifică moneda prețului și a ofertelor.
- **pas_minim** — Controlează creșterea minimă a ofertelor.
- **stare** — Distinge licitațiile active, încheiate și finalizate.

Cheie candidat alternativă: ADJUDECARE.id_oferta_castigatoare, dacă este obligatorie. Trebuie validat că oferta aparține licitației adjudecate și că feedbackul este creat de câștigător după finalizare. Vânzătorul evaluat rezultă din obiectul licitat, iar cumpărătorul rezultă din oferta câștigătoare; aceste referințe nu se duplică în FEEDBACK. Parola se reprezintă prin hash. Ratingul demonstrativ pentru nota 9 este 4,56 din 5.

### Sarcina 5 — Auto-Star

Fiecare model aparține unei mărci. Vehiculul are VIN unic de 17 caractere. CUSTODIE păstrează istoricul dealerilor. VIN este unic în VANZARE (prima vânzare). Preț de listă = preț de bază + suma dotărilor; prețul negociat rămâne distinct. Capacitatea bateriei poate fi NULL pentru un vehicul fără baterie de tracțiune.

|Tabel|Cheie primară|Chei străine|
|---|---|---|
|MARCA|id_marca|—|
|MODEL|cod_model|id_marca → MARCA.id_marca|
|DOTARE|cod_dotare|—|
|VEHICUL|vin|cod_model → MODEL.cod_model|
|VEHICUL_DOTARE|vin, cod_dotare|vin → VEHICUL.vin; cod_dotare → DOTARE.cod_dotare|
|CUSTODIE|id_custodie|vin → VEHICUL.vin; cod_dealer → DEALER.cod_dealer|
|DEALER|cod_dealer|—|
|CLIENT|cnp|—|
|VANZARE|id_vanzare|vin → VEHICUL.vin; id_custodie → CUSTODIE.id_custodie; cnp → CLIENT.cnp|

Cele trei atribute suplimentare:

- **capacitate_baterie_kwh** — Descrie autonomia potențială a vehiculului electric/hibrid.
- **email** — Permite notificarea clientului.
- **data_expirare_itp** — Permite urmărirea valabilității inspecției.

Chei candidate suplimentare: MARCA.nume și VANZARE.vin. VIN-ul din VANZARE trebuie să coincidă cu VIN-ul custodiei selectate, iar dealerul vânzător se obține prin CUSTODIE. Nu se admit intervale de custodie simultane pentru același vehicul; kilometrajul nu descrește. În exemplu: 20 000 + 1 000 + 1 500 = 22 500 preț de listă; prețul negociat este 21 500.

## Verificare și regenerare

```sh
python3 lab1/src/redare.py
python3 lab1/src/verifica.py
```

Este necesar Python cu Pillow și fonturile macOS Arial/Menlo. Verificarea controlează exemplele de date (PK, FK, lungimi), referințele din fișierele Draw.io și geometria conexiunilor dintre tabele. Rezultatele sunt salvate în `Verificare.json`.
