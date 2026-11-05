# Laboratorul 2 — Normalizarea relațiilor

PK = cheie primară; FK = cheie străină. Dependențele sunt deduse din regulile domeniului, nu doar din coincidențele dintr-un eșantion. Se presupun valori atomare unde nu sunt indicate liste.

## Sinteza rezultatelor

|Exercițiu|Cheia relației inițiale|Forma inițială|Rezultat|
|---|---|---|---|
|1|Nu este necesară pentru contraexemplu|—|X ⋈ Y produce 8 tupluri: 3 suplimentare|
|2|(Nr_comanda, Nr_articol) după atomizare|Nenormalizată (liste)|1FN → 2FN → 3FN/FNBC|
|3|nr_piesei|2FN|Piese, Categorii — FNBC|
|4|(a,b)|1FN|R1(b,c), R3(d,e,f), R4(a,b,d) — FNBC|
|5|(a,b)|1FN|A(a,c,g), B(b,e,g), C(c,f), G(g,h), AB(a,b,d) — FNBC|
|6|(IDP,nr_proiect), dacă IDP identifică persoana|1FN|Angajati, Proiecte, Participari — FNBC|
|7|(nr_sala,data_derularii,ora_derularii)|1FN|Filme, Sali, Proiectii — FNBC|
|8|Document compus, nu o relație atomică|—|Schema facturării în 3FN|

FNBC înseamnă: pentru orice dependență funcțională netrivială X→Y, X este supercheie. Formele inițiale indicate presupun atribute atomare, cu excepția listelor explicite din exercițiul 2.

## Exercițiul 1 — Descompunerea relației A

A conține 5 tupluri. X și Y sunt proiecțiile propuse în enunț. Reconstrucția X ⋈ Y se face pe Nr_credite, singurul atribut comun:

|Id_student|Nume_student|Cod_curs|Nr_credite|Observație|
|---|---|---|---|---|
|1111|Popescu Ion|IP201|5|tuplu inițial|
|1112|Negrescu Dan|IP202|6|tuplu inițial|
|1112|Negrescu Dan|IS201|6|tuplu suplimentar|
|1113|Sîrbu Oana|IP201|5|tuplu inițial|
|1114|Lisnic Dana|IP202|6|tuplu suplimentar|
|1114|Lisnic Dana|IS201|6|tuplu inițial|
|1115|Rotari Marin|IP202|6|tuplu suplimentar|
|1115|Rotari Marin|IS201|6|tuplu inițial|


Descompunerea **nu este fără pierderi**. X ∩ Y = {Nr_credite}, dar Nr_credite nu determină nici X, nici Y. Joncțiunea naturală produce 8 tupluri în loc de 5: fiecare dintre cei trei studenți cu 6 credite este asociat atât cu IP202, cât și cu IS201. Apar trei asocieri false: (1112, IS201), (1114, IP202), (1115, IP202).

O descompunere corectă: Inscrieri(Id_student, Cod_curs), Studenti(Id_student PK, Nume_student), Cursuri(Cod_curs PK, Nr_credite). Pentru mai multe cursuri/student, PK Inscrieri = (Id_student, Cod_curs), ambele coloane fiind FK. Intersecțiile sunt chei ale tabelelor referite, deci reconstrucția este fără pierderi.

## Exercițiul 2

### I. Motive

1. Eliminarea anomaliilor de actualizare: adresa clientului/prețul articolului nu se modifică în mai multe rânduri.
2. Eliminarea anomaliilor de inserare: un client/articol poate exista fără o comandă.
3. Eliminarea anomaliilor de ștergere: ștergerea ultimei comenzi nu elimină datele clientului sau articolului.

### II. Prima formă normală

PK = (Nr_comanda, Nr_articol); presupunem că un articol apare o singură dată într-o comandă. Datele originale sunt interpretate zi/lună/an.

| Nr_comanda | Data | Nr_client | Nume_client | Adresa | Nr_articol | Den_articol | Cantitatea | Pret |
|---|---|---|---|---|---|---|---|---|
|1001|2012-02-03|A004|Donici Ion|Bălți|6531|Dulap|1|700|
|1001|2012-02-03|A004|Donici Ion|Bălți|7890|Masă mic|1|400|
|1001|2012-02-03|A004|Donici Ion|Bălți|9134|Scaun|4|250|
|1002|2012-02-04|A986|Malcoș Dumitru|Bălți|3561|Taburetă|2|130|
|1003|2012-02-05|A201|Pintilei Ana|Drochia|4234|Cuier|1|300|
|1003|2012-02-05|A201|Pintilei Ana|Drochia|7890|Masă mic|1|400|

Dependențe: Nr_comanda → Data, Nr_client; Nr_client → Nume_client, Adresa; Nr_articol → Den_articol, Pret; (Nr_comanda, Nr_articol) → Cantitatea. Nr_comanda și Nr_articol determină separat atribute non-cheie; cantitatea depinde de întreaga cheie.

### III. A doua formă normală

Comenzi_2FN(Nr_comanda PK, Data, Nr_client, Nume_client, Adresa):

|Nr_comanda|Data|Nr_client|Nume_client|Adresa|
|---|---|---|---|---|
|1001|2012-02-03|A004|Donici Ion|Bălți|
|1002|2012-02-04|A986|Malcoș Dumitru|Bălți|
|1003|2012-02-05|A201|Pintilei Ana|Drochia|

Articole(Nr_articol PK, Den_articol, Pret):

|Nr_articol|Den_articol|Pret|
|---|---|---|
|6531|Dulap|700|
|7890|Masă mic|400|
|9134|Scaun|250|
|3561|Taburetă|130|
|4234|Cuier|300|

Detalii_comenzi(Nr_comanda PK/FK, Nr_articol PK/FK, Cantitatea):

|Nr_comanda|Nr_articol|Cantitatea|
|---|---|---|
|1001|6531|1|
|1001|7890|1|
|1001|9134|4|
|1002|3561|2|
|1003|4234|1|
|1003|7890|1|

Comenzi_2FN 1:N Detalii_comenzi; Articole 1:N Detalii_comenzi. Dependențele parțiale au fost eliminate; dependența tranzitivă prin Nr_client rămâne.

### IV. A treia formă normală

Clienti(Nr_client PK, Nume_client, Adresa):

|Nr_client|Nume_client|Adresa|
|---|---|---|
|A004|Donici Ion|Bălți|
|A986|Malcoș Dumitru|Bălți|
|A201|Pintilei Ana|Drochia|

Comenzi(Nr_comanda PK, Data, Nr_client FK):

|Nr_comanda|Data|Nr_client|
|---|---|---|
|1001|2012-02-03|A004|
|1002|2012-02-04|A986|
|1003|2012-02-05|A201|

Articole și Detalii_comenzi sunt exact tabelele de la pasul III. Clienti 1:N Comenzi; Comenzi 1:N Detalii_comenzi; Articole 1:N Detalii_comenzi. Toți determinanții netriviali sunt chei: schema este și în FNBC. Descompunerile sunt fără pierderi și păstrează dependențele. Prețul este cel de catalog din enunț; pentru prețuri istorice se adaugă Pret_vanzare la Detalii_comenzi, cu o altă dependență funcțională.

## Exercițiul 3 — Piesa

Cheia candidat unică este {nr_piesei}: închiderea sa conține toate atributele, iar nr_piesei nu apare în partea dreaptă a dependențelor. PK = nr_piesei. Relația este în 2FN, dar nu în 3FN: nr_piesei → categoria → TVA, iar categoria nu este supercheie. Actualizarea TVA necesită mai multe modificări; nu se poate adăuga o categorie fără piesă; ștergerea ultimei piese pierde TVA-ul categoriei.

FNBC: Piese(nr_piesei PK, pret, denumirea, categoria FK) și Categorii(categoria PK, TVA). Joncțiunea pe categoria este fără pierderi, iar ambele dependențe sunt păstrate.

## Exercițiul 4

a și b nu apar în partea dreaptă, deci orice cheie le conține; (ab)+ = abcdef. Unica cheie candidat este {a,b}. Relația este în 1FN, nu în 2FN: b → c este parțială; d → e,f este tranzitivă față de cheie.

2FN: R1(b PK,c), R2(a,b,d,e,f; PK a,b).
FNBC: R1(b PK,c), R3(d PK,e,f), R4(a,b,d; PK a,b; FK b→R1, d→R3). Dependența ab→d este totală. Descompunem mai întâi prin b→c, apoi prin d→ef; intersecțiile b și d sunt chei în relațiile extrase. Toate dependențele inițiale se deduc din cele păstrate.

## Exercițiul 5

a și b sunt obligatorii în cheie; (ab)+ = abcdefgh. Unica cheie candidat: {a,b}. Relația este în 1FN, nu în 2FN, din cauza a→c,g și b→e,g. Mai există c→f și g→h.

FNBC: A(a PK,c FK,g FK), B(b PK,e,g FK), C(c PK,f), G(g PK,h), AB(a FK,b FK,d; PK a,b). Fiecare determinant netrivial este cheia relației sale. Toate dependențele date sunt păstrate: a→c,g în A; b→e,g în B; ab→d în AB; c→f în C; g→h în G.

Justificarea reconstrucției fără pierderi: aceasta este o sinteză 3FN bazată pe acoperirea minimă, cu dependențele grupate după determinant, iar AB conține cheia originală {a,b}. Prin urmare descompunerea este fără pierderi. Fiecare relație obținută satisface suplimentar FNBC. Un chase asupra dependențelor confirmă rezultatul. Nu se elimină g din relația rămasă înainte de a păstra ambele dependențe a→g și b→g.

Legături: C 1:N A prin c; G 1:N A și G 1:N B prin g; A 1:N AB prin a; B 1:N AB prin b. Pentru aceeași pereche (a,b), valorile g din A și B trebuie să coincidă; aceasta este o condiție globală dedusă din relația inițială, neimpusă numai de cheile străine.

## Exercițiul 6

Interpretare explicită: IDP este identificatorul persoanei, nu al participării. Numele nu identifică o persoană. IDP→nume_angajat; nr_proiect→den_proiect,laborator; (IDP,nr_proiect)→nr_ore. Cheia este (IDP,nr_proiect); forma inițială este 1FN, nu 2FN. Numele și datele proiectului se repetă; inserarea unui angajat/proiect cere participare; ștergerea ultimei participări pierde descrierile.

FNBC: Angajati(IDP PK,nume_angajat), Proiecte(nr_proiect PK,den_proiect,laborator), Participari(IDP PK/FK,nr_proiect PK/FK,nr_ore). Ambele relații cu Participari sunt 1:N. Descompunere fără pierderi și cu păstrarea dependențelor: se separă întâi IDP→nume_angajat (intersecția IDP este cheie în Angajati), apoi nr_proiect→den_proiect,laborator (intersecția nr_proiect este cheie în Proiecte). În fiecare tabel final, determinantul este o cheie.

Dacă IDP înseamnă ID al participării, enunțul nu oferă un identificator de angajat: trebuie introdus id_angajat; nu se poate folosi numele neunic drept cheie. Atunci Participari(IDP PK,id_angajat FK,nr_proiect FK,nr_ore), cu UNIQUE(id_angajat,nr_proiect).

## Exercițiul 7

Presupunem o singură proiecție într-o sală la aceeași dată/oră. PK = (nr_sala,data_derularii,ora_derularii). Dependențe: nr_film→titlu_film,durata_film; nr_sala→capacitate_sala,tip_scaun; cheia proiecției→nr_film,pret. Prețul este considerat prețul proiecției: enunțul nu afirmă că tipul scaunului determină prețul.

Forma inițială: 1FN, nu 2FN, deoarece nr_sala este parte din cheie. Apar redundanțe la actualizarea filmului/sălii, inserarea lor fără proiecții și ștergerea ultimei proiecții.

FNBC: Filme(nr_film PK,titlu_film,durata_film), Sali(nr_sala PK,capacitate_sala,tip_scaun), Proiectii(nr_sala PK/FK,data_derularii PK,ora_derularii PK,nr_film FK,pret). Dacă se impune suplimentar tip_scaun→pret, atunci se extrage Tarife(tip_scaun PK,pret), tip_scaun devine FK în Sali și pret se elimină din Proiectii. În varianta de bază, separarea Filmelor folosește intersecția nr_film, cheie în Filme, iar separarea Sălilor folosește intersecția nr_sala, cheie în Sali. Dependențele sunt păstrate, iar fiecare determinant netrivial este supercheie. Ambele variante sunt fără pierderi sub ipotezele respective. Suprapunerile între intervalele de rulare necesită o verificare suplimentară, nu doar unicitatea momentului de început.

## Exercițiul 8 — Factura pentru apă

### Datele observate în imagine

Sunt prezentați doi furnizori: „Glorin” S.R.L. și ÎM Regia „APA-CANAL-Bălți”. Contorul este **002342**; numărul trebuie păstrat ca text. Perioada facturată este **28.11.2013–25.12.2013**, iar termenul de plată este **31.01.2014**. Citirile sunt **100 la 28.11.2013** și **105 la 26.12.2013**, cu volum de **5,000 m³**. Data ultimei citiri și sfârșitul perioadei sunt câmpuri distincte, deoarece în document diferă cu o zi.

Segmentele de consum sunt de 25 și 3 zile, cu volume 4,464 și 0,536 m³, pentru 2 persoane. Facturile includ tarife, o coloană pentru înlesniri procentuale și rubricile Calculat, Datorie, Recalculare, Contra plată. Nu se modelează avizul de decontare sau reclama, conform cerinței.

### Schema relațională în 3FN

|Relație|Atribute și chei|
|---|---|
|Furnizori|**id_furnizor PK**, denumire, cod_fiscal (UNIQUE, opțional)|
|Banci|**cod_banca PK**, denumire_banca|
|Conturi_furnizori|**id_cont PK**, id_furnizor FK → Furnizori, cod_banca FK → Banci, numar_cont (UNIQUE, NOT NULL)|
|Consumatori|**id_consumator PK**, nume, adresa|
|Contoare|**nr_contor PK** (text), id_consumator FK → Consumatori|
|Citiri|**id_citire PK**, nr_contor FK → Contoare, data_citirii, index_contor; UNIQUE(nr_contor, data_citirii)|
|Facturi|**id_factura PK**, numar_document, id_cont FK → Conturi_furnizori, id_consumator FK → Consumatori, perioada_start, perioada_sfarsit, data_scadenta, datorie, recalculare; UNIQUE(id_cont, numar_document)|
|Consum_facturat|**id_consum PK**, id_factura FK → Facturi, id_citire_initiala FK → Citiri, id_citire_finala FK → Citiri; UNIQUE(id_factura, id_citire_initiala, id_citire_finala)|
|Segmente_consum|**id_segment PK**, id_consum FK → Consum_facturat, ordine_segment, nr_persoane, nr_zile, volum; UNIQUE(id_consum, ordine_segment)|
|Servicii|**id_serviciu PK**, denumire_serviciu, unitate_masura|
|Linii_servicii|**id_segment PK/FK** → Segmente_consum, **id_serviciu PK/FK** → Servicii, tarif_aplicat, procent_inlesnire|

Se presupune un singur cont activ de consumator pentru fiecare contor în intervalul analizat. Datele consumatorului nu sunt vizibile în imagine; schema permite stocarea lor, fără a inventa valori personale. În exemplu, identificatorii tehnici F1 și F2 sunt aleși pentru demonstrație și nu reprezintă numere de factură confirmate.

### Dependențe și normalizare

- id_furnizor → denumire, cod_fiscal.
- cod_banca → denumire_banca.
- id_cont → id_furnizor, cod_banca, numar_cont; numar_cont → id_cont și restul atributelor contului.
- id_consumator → nume, adresa; nr_contor → id_consumator.
- id_citire → nr_contor, data_citirii, index_contor; (nr_contor, data_citirii) este cheie candidat.
- id_factura → toate atributele Facturi; (id_cont, numar_document) este cheie candidat când ambele sunt obligatorii.
- id_consum → id_factura, id_citire_initiala, id_citire_finala; tripletul declarat UNIQUE este cheie candidat.
- id_segment → id_consum, ordine_segment, nr_persoane, nr_zile, volum; (id_consum, ordine_segment) este cheie candidat.
- id_serviciu → denumire_serviciu, unitate_masura.
- (id_segment, id_serviciu) → tarif_aplicat, procent_inlesnire.

Datele furnizorului și băncii nu se repetă în Facturi. Detaliile citirilor nu se repetă în Consum_facturat. Persoanele, zilele și volumul segmentului sunt stocate o singură dată în Segmente_consum; apa și canalizarea se leagă de același segment prin Linii_servicii. Astfel se evită dependența tranzitivă care ar apărea dacă volumul și numărul de persoane ar fi repetate pe fiecare linie de serviciu.

Tariful este istoric: depinde de segment și serviciu, nu doar de serviciu. Nu presupunem că toate facturile au același tarif. Sub dependențele declarate, orice determinant netrivial din fiecare relație este o supercheie: relațiile sunt în 3FN și în FNBC. Nu declarăm numele furnizorului sau numele consumatorului drept identificatori unici.

### Cardinalități

Furnizori 1:N Conturi_furnizori; Banci 1:N Conturi_furnizori; Consumatori 1:N Contoare și 1:N Facturi; Contoare 1:N Citiri; Conturi_furnizori 1:N Facturi; Facturi 1:N Consum_facturat; Citiri 1:N Consum_facturat în cele două roluri (inițială/finală); Consum_facturat 1:N Segmente_consum; Segmente_consum 1:N Linii_servicii; Servicii 1:N Linii_servicii. O factură încă necompletată poate avea temporar zero detalii.

### Reconstituirea sumelor

Pentru exemplu, procent_inlesnire = 0 (nu este indicată o reducere). Formula unei linii:

`Suma_linie = ROUND(volum × tarif_aplicat × (1 − procent_inlesnire / 100), 2)`

|Factura tehnică|Segment|Serviciu|Volum m³|Tarif|Suma|
|---|---|---|---|---|---|
|F1 — Glorin|25 zile|Canalizare|4,464|3,900|17,41|
|F2 — APA-CANAL|25 zile|Apă|4,464|11,080|49,46|
|F2 — APA-CANAL|3 zile|Apă|0,536|11,080|5,94|
|F2 — APA-CANAL|3 zile|Canalizare|0,536|3,900|2,09|

F1 nu are o linie de serviciu taxată pentru segmentul de 3 zile; la afișare acel segment are suma 0,00. Pentru F2, linia tipărită de 3 zile regrupează apa și canalizarea: 5,94 + 2,09 = **8,03**. Calculat F1 = **17,41**; Calculat F2 = **49,46 + 5,94 + 2,09 = 57,49**. Valorile coincid cu documentul.

`Calculat = SUM(Suma_linie)`; `Contra_plata = Calculat + Datorie + Recalculare`, unde Recalculare este un ajustaj cu semn. În exemplu, rubricile goale Datorie și Recalculare sunt tratate ca 0 pentru calcul. Totalurile, diferența dintre indexuri și suma liniilor nu se stochează redundant. Volumele segmentelor se stochează cu 3 zecimale, sumele cu 2, iar tarifele cu cel puțin 3; se folosește aritmetică zecimală, nu float.

### Reguli de integritate

Citirile unui consum facturat trebuie să aparțină aceluiași contor și să fie în ordine cronologică; indexul final este cel puțin egal cu cel inițial. Consumatorul facturii trebuie să coincidă cu cel al contorului. Volumele segmentelor însumate trebuie să corespundă volumului facturat. Volumele și tarifele sunt nenegative; procent_inlesnire este între 0 și 100. Aceste reguli care implică mai multe relații se validează suplimentar față de PK/FK.
