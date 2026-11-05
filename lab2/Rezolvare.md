# Laboratorul 2 — Normalizarea relațiilor

PK = cheie primară; FK = cheie străină. Dependențele sunt deduse din regulile domeniului, nu doar din coincidențele dintr-un eșantion. Se presupun valori atomare unde nu sunt indicate liste.

## Exercițiul 1

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

Dependențe: Nr_comanda → Data, Nr_client; Nr_client → Nume_client, Adresa; Nr_articol → Den_articol, Pret; (Nr_comanda, Nr_articol) → Cantitatea. Primele două părți ale cheii determină atribute separat; cantitatea depinde de întreaga cheie.

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

## Exercițiul 3

PK = nr_piesei. Relația este în 2FN, dar nu în 3FN: nr_piesei → categoria → TVA, iar categoria nu este supercheie. Actualizarea TVA necesită mai multe modificări; nu se poate adăuga o categorie fără piesă; ștergerea ultimei piese pierde TVA-ul categoriei.

FNBC: Piese(nr_piesei PK, pret, denumirea, categoria FK) și Categorii(categoria PK, TVA). Joncțiunea pe categoria este fără pierderi, iar ambele dependențe sunt păstrate.

## Exercițiul 4

a și b nu apar în partea dreaptă, deci orice cheie le conține; (ab)+ = abcdef. Unica cheie candidat este {a,b}. Relația este în 1FN, nu în 2FN: b → c este parțială; d → e,f este tranzitivă față de cheie.

2FN: R1(b PK,c), R2(a,b,d,e,f; PK a,b).
FNBC: R1(b PK,c), R3(d PK,e,f), R4(a,b,d; PK a,b; FK b→R1, d→R3). Dependența ab→d este totală. Descompunem mai întâi prin b→c, apoi prin d→ef; intersecțiile b și d sunt chei în relațiile extrase. Toate dependențele inițiale se deduc din cele păstrate.

## Exercițiul 5

a și b sunt obligatorii în cheie; (ab)+ = abcdefgh. Unica cheie candidat: {a,b}. Relația este în 1FN, nu în 2FN, din cauza a→c,g și b→e,g. Mai există c→f și g→h.

FNBC: A(a PK,c FK,g FK), B(b PK,e,g FK), C(c PK,f), G(g PK,h), AB(a FK,b FK,d; PK a,b). Fiecare determinant netrivial este cheia relației sale. Toate dependențele date sunt păstrate. Descompunerea este fără pierderi: se extrag C prin c→f, G prin g→h, apoi A prin a→c,g și B prin b→e,g, rămânând AB. Faptul că g apare în A și B păstrează ambele dependențe spre g.

## Exercițiul 6

Interpretare explicită: IDP este identificatorul persoanei, nu al participării. Numele nu identifică o persoană. IDP→nume_angajat; nr_proiect→den_proiect,laborator; (IDP,nr_proiect)→nr_ore. Cheia este (IDP,nr_proiect); forma inițială este 1FN, nu 2FN. Numele și datele proiectului se repetă; inserarea unui angajat/proiect cere participare; ștergerea ultimei participări pierde descrierile.

FNBC: Angajati(IDP PK,nume_angajat), Proiecte(nr_proiect PK,den_proiect,laborator), Participari(IDP PK/FK,nr_proiect PK/FK,nr_ore). Ambele relații cu Participari sunt 1:N. Descompunere fără pierderi și cu păstrarea dependențelor.

Dacă IDP înseamnă ID al participării, enunțul nu oferă un identificator de angajat: trebuie introdus id_angajat; nu se poate folosi numele neunic drept cheie. Atunci Participari(IDP PK,id_angajat FK,nr_proiect FK,nr_ore), cu UNIQUE(id_angajat,nr_proiect).

## Exercițiul 7

Presupunem o singură proiecție într-o sală la aceeași dată/oră. PK = (nr_sala,data_derularii,ora_derularii). Dependențe: nr_film→titlu_film,durata_film; nr_sala→capacitate_sala,tip_scaun; cheia proiecției→nr_film,pret. Prețul este considerat prețul proiecției: enunțul nu afirmă că tipul scaunului determină prețul.

Forma inițială: 1FN, nu 2FN, deoarece nr_sala este parte din cheie. Apar redundanțe la actualizarea filmului/sălii, inserarea lor fără proiecții și ștergerea ultimei proiecții.

FNBC: Filme(nr_film PK,titlu_film,durata_film), Sali(nr_sala PK,capacitate_sala,tip_scaun), Proiectii(nr_sala PK/FK,data_derularii PK,ora_derularii PK,nr_film FK,pret). Dacă se impune suplimentar tip_scaun→pret, atunci se extrage Tarife(tip_scaun PK,pret), tip_scaun devine FK în Sali și pret se elimină din Proiectii. Ambele variante sunt fără pierderi sub ipotezele respective. Suprapunerile între intervalele de rulare necesită o verificare suplimentară, nu doar unicitatea momentului de început.

## Exercițiul 8 — Factura pentru apă

Modelul separă furnizorul, contorul, citirile și serviciile facturate. Imaginea prezintă doi furnizori, contorul 002342, perioada 28.11.2013–25.12.2013, termenul 31.01.2014, tarife distincte pentru apă/canalizare și segmente de 25/3 zile. Nu inventăm date personale care nu apar lizibil în document.

| Relație în 3FN | Chei și atribute |
|---|---|
|Furnizori|id_furnizor PK, denumire, cod_fiscal UNIQUE nullable|
|Banci|id_banca PK, denumire, cod_bancar UNIQUE|
|Conturi_furnizori|id_cont PK, id_furnizor FK, id_banca FK, numar_cont UNIQUE|
|Consumatori|id_consumator PK, nume, adresa|
|Contoare|id_contor PK (text, păstrează zerourile), id_consumator FK|
|Citiri|id_citire PK, id_contor FK, data_citirii, index_contor; UNIQUE(id_contor,data_citirii)|
|Facturi|id_factura PK, numar_document, id_cont FK, id_consumator FK, perioada_start, perioada_sfarsit, data_scadenta, datorie, recalculare; UNIQUE(id_cont,numar_document)|
|Servicii|id_serviciu PK, denumire, unitate_masura|
|Linii_factura|id_factura PK/FK, nr_linie PK, id_serviciu FK, segment_start, segment_sfarsit, nr_persoane, volum, tarif_aplicat|
|Consum_facturat|id_factura PK/FK, id_citire_initiala PK/FK, id_citire_finala PK/FK|

Conturi_furnizori identifică furnizorul/banca, astfel Facturi nu le duplică. O linie este pentru un singur serviciu și segment; apa și canalizarea devin linii distincte. Tariful aplicat este istoric, determinat de cheia liniei, nu de serviciu singur. Nr_zile, volumul dintre citiri, suma liniei ROUND(volum*tarif_aplicat,2), totalul calculat și suma de plată se calculează în interogări; nu se repetă ca atribute dependente. Datorie și recalculare reprezintă ajustările facturii. Nu includem avizul de decontare și reclama. Orice determinant netrivial declarat este o cheie candidat, deci relațiile sunt în 3FN (și FNBC sub aceste reguli).
