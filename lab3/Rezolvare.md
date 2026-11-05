# Laboratorul 3 — Algebra relațională

Datele sunt transcrise din enunț în `01_date.sql`. Soluțiile SQL echivalente sunt în `02_ex1.sql`, `03_ex2.sql`, `04_ex3.sql`; toate rezultatele executate sunt în `Rezultate.md`. σ = selecție, π = proiecție cu eliminarea duplicatelor, ρ = redenumire, ⋈ = joncțiune naturală, ⋉ = semijoncțiune. N = Note. În SQL se folosesc condiții ON explicite pentru a evita coloane comune accidentale.

## Exercițiul 1

T={(1,2,3),(5,6,7),(1,2,4)}, S={(3,4),(7,8),(1,2)}.

1. R = π_A,B(T) = {(1,2),(5,6)}.
2. σ_A+B<5(R) = {(1,2)}.
3. π_A(R) = {(1),(5)}.
4. R × S, schema (R.A,R.B,S.A,S.B): {(1,2,3,4),(1,2,7,8),(1,2,1,2),(5,6,3,4),(5,6,7,8),(5,6,1,2)}.
5. R ⋈_R.B<S.B S = {(1,2,3,4),(1,2,7,8),(5,6,7,8)}.
6. R ∪ R = {(1,2),(5,6)}.
7. R ∪ S = {(1,2),(5,6),(3,4),(7,8)}.
8. R ∩ S = {(1,2)}.
9. R − S = {(5,6)}.
10. S − R = {(3,4),(7,8)}.

Operațiile de mulțimi sunt definite: R și S au scheme compatibile (A,B). Produsul și theta-joncțiunea păstrează ambele perechi de coloane, cu nume calificate.

## Exercițiul 2 — Optimizare

1. π_nume_prenume(Student ⋉ N). Echivalent cu π_nume_prenume(π_idst,nume_prenume(Student) ⋈ π_idst(N)). Sunt necesare doar identitatea studentului și existența unei note; rezultatul are 7 nume.
2. (σ_idst=3(Student)) ⋈ (σ_idst=3(N)). Se propagă egalitatea prin atributul de joncțiune; 3 tupluri.
3. (σ_grupa='IT22'(Student)) ⋈ N. Selecția locală este împinsă înainte de joncțiune; 5 tupluri.
4. (σ_forma='buget'(Student)) ⋈ (σ_nota≥9(N)). Conjuncția se separă între operanzi; 4 tupluri. Candidați în sensul filtrului: Ana Rusu și Maria Lungu. Acesta nu dovedește eligibilitatea administrativă pentru bursă, pentru care nu sunt date alte reguli.
5. σ_forma='contract'∨nota≥9(Student ⋈ N). Disjuncția nu se poate împinge ca două filtre locale unite prin ⋈: s-ar obține AND și s-ar pierde tupluri. Sunt 11 tupluri.
6. ((σ_forma='contract'(Student)) ⋈ N) ∪ (Student ⋈ (σ_nota≥9(N))). Distribuirea OR prin reuniune este corectă în algebra de mulțimi; UNION elimină suprapuneri. Pe acest set ramurile sunt disjuncte, dar nu există această garanție pentru alte date. Două joncțiuni și deduplicarea pot costa mai mult decât un singur join cu OR; folosul depinde de indici și selectivitate.
7. π_denumire,nota((π_denumire(σ_idcurs=101(Curs))) × (π_nota(σ_idcurs=101(N)))). După filtrarea ambelor relații pe același idcurs și eliminarea lui, joncțiunea poate fi înlocuită cu produsul cartezian. Nu se poate elimina pur și simplu predicatul înainte de filtrarea ambelor relații. Rezultat: Matematică discretă cu notele distincte 4,6,7,9,10 (5 tupluri).
8. π_denumire(Curs ⋉ N). Rezultatul conține 4 cursuri; Baze de date nu apare.
9. Student ⋈ (N ⋈ σ_semestru=2(Curs)). Asociativitatea permite efectuarea joncțiunii selective mai întâi: rămân 5 note înainte de asocierea studenților. Cele două planuri sunt comparate în tabel.
10. a) π_idst,idcurs,data,nota(Student ⋈ N) = N, deoarece fiecare N.idst este FK nenul către Student.idst, cheie unică. b) π_idst,nume_prenume,grupa,forma(Student ⋈ N) = Student ⋉ N, diferit de Student: Irina Botnaru (idst=7) nu are examene. FK garantează existența părintelui pentru fiecare copil, fără a impune existența unui copil pentru fiecare părinte.

### Tabel comparativ

Convenție explicită: cost = celule ale rezultatelor de joncțiune/semijoncțiune materializate înainte de filtrul/proiecția finală. La un plan cu mai multe joncțiuni se însumează etapele. Nu includem scanările, indicii sau deduplicarea, deci acesta este un model didactic, nu timpul real al unui SGBD. Student are 8×4 celule, N are 14×4 și Curs 5×4; Student ⋈ N are 14×7.

|Nr.|Expresia optimizată (abreviată)|Regulă|Cost inițial|Cost optimizat|Tupluri finale|
|---|---|---|---|---|---|
|1|π_nume(Student ⋉ N)|semijoncțiune/proiecție|14×7=98|7×1=7, semijoin cu ieșire doar nume|7|
|2|σ_idst=3(Student) ⋈ σ_idst=3(N)|selecție și propagare egalitate|14×7=98|3×7=21|3|
|3|σ_grupa='IT22'(Student) ⋈ N|selecție locală|14×7=98|5×7=35|5|
|4|σ_forma='buget'(Student) ⋈ σ_nota≥9(N)|separare AND|14×7=98|4×7=28|4|
|5|σ_forma='contract'∨nota≥9(Student ⋈ N)|OR rămâne după join|14×7=98|14×7=98|11|
|6|(σ_contract(Student) ⋈ N) ∪ (Student ⋈ σ_nota≥9(N))|distribuire prin UNION|14×7=98|7×7+4×7=77, plus UNION necuantificat|11|
|7|π_denumire,nota(π_denumire(σ_101(Curs)) × π_nota(σ_101(N)))|selecție/proiecție/produs|14×7=98|1×5×2=10|5|
|8|π_denumire(Curs ⋉ N)|semijoncțiune|14×7=98|4×1=4, ieșire doar denumire|4|
|9a|σ_sem=2((Student ⋈ N) ⋈ Curs)|plan inițial|14×7+14×10=238|238|5|
|9b|Student ⋈ (N ⋈ σ_sem=2(Curs))|asociativitate și selecție|238|5×7+5×10=85|5|
|10a|N|eliminarea join prin FK|98|0 celule de join; citire 14×4|14|
|10b|Student ⋉ N|semijoncțiune|98|7×4=28|7|

Pentru 7, π_nota(N filtrată) are 5 valori distincte, deși există 6 încercări de examen. SQL-ul atașat elimină duplicatele la final și produce același rezultat; un optimizator poate împinge DISTINCT înaintea produsului. Costurile pentru 1 și 8 presupun semijoncțiuni cu proiecția integrată.

## Exercițiul 3 — Produse

Abrevieri: P=Product, C=PC, L=Laptop, I=Printer. Atributele comune nefolosite drept chei se califică/redenumește. În fișierul auxiliar vechi `hd` desemnează atributul numit `ssd` în PDF; folosim `ssd`.

1. π_model,price(σ_speed≥3.0(C)). Rezultat: (1001,850),(1003,1350),(1005,520).
2. π_model,price(σ_(screen≥15∨ssd≥1000)∧price<1000(L)). Rezultat: (2002,640),(2005,520). Parantezele aplică limita de preț ambelor alternative.
3. π_maker(P ⋈_P.model=I.model σ_I.type='laser'∧color=true(I)). Rezultat: D. Joncțiunea naturală P ⋈ I compară și `type`: 'printer' nu este 'laser'/'inkjet', deci rezultatul este vid. Soluția folosește egalitatea modelelor explicită.
4. π_C.model,C.price(σ_maker='A'(P ⋈_P.model=C.model C)) ∪ π_L.model,L.price(σ_maker='A'(P ⋈_P.model=L.model L)) ∪ π_I.model,I.price(σ_maker='A'(P ⋈_P.model=I.model I)). Rezultat: (1001,850),(1002,520),(2001,1100),(3001,120). Proiecțiile se redenumesc uniform (model,price) înainte de reuniune.
5. π_maker(σ_type='laptop'(P)) − π_maker(σ_type='pc'(P)) = {D}.
6. π_speed(C) ∩ π_speed(L) = {2.8,3.2}.
7. π_c1.model,c2.model(σ_c1.speed=c2.speed∧c1.model<c2.model(ρ_c1(C) × ρ_c2(C))). Rezultat: (1001,1005),(1002,1004). Inegalitatea elimină perechile reflexive și simetrice.
8. Fie Q=σ_type='pc'∨type='laptop'(P). π_q1.maker(σ_q1.maker=q2.maker∧q1.model<q2.model(ρ_q1(Q) × ρ_q2(Q))) = {A,B,C}.
9. π_L.model,L.price(σ_L.price<C.price((ρ_pl(P) ⋈_pl.model=L.model L) ⋈_pl.maker=pp.maker (ρ_pp(P) ⋈_pp.model=C.model C))). Rezultat: (2002,640).
10. π_model(C) − ρ_model←c1.model(π_c1.model(σ_c1.price<c2.price(ρ_c1(C) × ρ_c2(C)))) = {1003}. Sunt păstrate toate egalitățile de maxim, fără agregări.
11. Fie U=π_maker,type(P), V=π_type(P), M=π_maker(P). Cu diviziune: U ÷ V. Doar operatori de bază: M − π_maker((M × V) − U). Rezultat: {A,C}; pentru fiecare producător se exclud tipurile lipsă. V conține pc,laptop,printer.
12. π_C.model,I.model(σ_C.price+I.price≤700∧I.color=true(C × I)). Rezultat: (1002,3001),(1002,3004),(1005,3001),(1005,3004).
13. π_maker(P) ⟕_maker Q, unde Q=π_P.maker,I.model(P ⋈_P.model=I.model I). Rezultat: (A,3001),(B,NULL),(C,3002),(D,3003),(E,3004). Se folosește algebra extinsă; left join nu se exprimă în algebra clasică fără extinderea cu NULL.
14. γ_maker;COUNT(C.model)→nr_modele,AVG(C.price)→pret_mediu(P ⋈_P.model=C.model C). Rezultat: A(2,685), B(1,1350), C(1,780), E(1,520). γ este agregare din algebra extinsă.
