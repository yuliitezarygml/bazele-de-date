# Rezultatele SQL verificate

Executate în SQLite cu integritatea referențială activată; semantica SELECT DISTINCT/UNION este de mulțime. Ordinea liniilor nu este semnificativă.

## Exercițiul 1

### 1 — 2 tupluri

| A | B |
| --- | --- |
| 1 | 2 |
| 5 | 6 |

### 2 — 1 tupluri

| A | B |
| --- | --- |
| 1 | 2 |

### 3 — 2 tupluri

| A |
| --- |
| 1 |
| 5 |

### 4 — 6 tupluri

| R_A | R_B | S_A | S_B |
| --- | --- | --- | --- |
| 1 | 2 | 3 | 4 |
| 1 | 2 | 7 | 8 |
| 1 | 2 | 1 | 2 |
| 5 | 6 | 3 | 4 |
| 5 | 6 | 7 | 8 |
| 5 | 6 | 1 | 2 |

### 5 — 3 tupluri

| R_A | R_B | S_A | S_B |
| --- | --- | --- | --- |
| 1 | 2 | 3 | 4 |
| 1 | 2 | 7 | 8 |
| 5 | 6 | 7 | 8 |

### 6 — 2 tupluri

| A | B |
| --- | --- |
| 1 | 2 |
| 5 | 6 |

### 7 — 4 tupluri

| A | B |
| --- | --- |
| 1 | 2 |
| 3 | 4 |
| 5 | 6 |
| 7 | 8 |

### 8 — 1 tupluri

| A | B |
| --- | --- |
| 1 | 2 |

### 9 — 1 tupluri

| A | B |
| --- | --- |
| 5 | 6 |

### 10 — 2 tupluri

| A | B |
| --- | --- |
| 3 | 4 |
| 7 | 8 |

## Exercițiul 2

### 1 — 7 tupluri

| nume_prenume |
| --- |
| Ana Rusu |
| Ion Munteanu |
| Maria Lungu |
| Victor Popa |
| Elena Cojocaru |
| Dan Moraru |
| Pavel Guțu |

### 2 — 3 tupluri

| idst | nume_prenume | grupa | forma | idcurs | data | nota |
| --- | --- | --- | --- | --- | --- | --- |
| 3 | Maria Lungu | IT21 | buget | 101 | 2026-01-14 | 10 |
| 3 | Maria Lungu | IT21 | buget | 102 | 2026-01-21 | 9 |
| 3 | Maria Lungu | IT21 | buget | 103 | 2026-06-10 | 8 |

### 3 — 5 tupluri

| idst | nume_prenume | grupa | forma | idcurs | data | nota |
| --- | --- | --- | --- | --- | --- | --- |
| 2 | Ion Munteanu | IT22 | contract | 101 | 2026-01-14 | 6 |
| 2 | Ion Munteanu | IT22 | contract | 103 | 2026-06-10 | 7 |
| 5 | Elena Cojocaru | IT22 | buget | 104 | 2026-06-17 | 7 |
| 6 | Dan Moraru | IT22 | contract | 101 | 2026-01-14 | 4 |
| 6 | Dan Moraru | IT22 | contract | 101 | 2026-02-05 | 6 |

### 4 — 4 tupluri

| idst | nume_prenume | grupa | forma | idcurs | data | nota |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Ana Rusu | IT21 | buget | 101 | 2026-01-14 | 9 |
| 1 | Ana Rusu | IT21 | buget | 104 | 2026-06-17 | 10 |
| 3 | Maria Lungu | IT21 | buget | 101 | 2026-01-14 | 10 |
| 3 | Maria Lungu | IT21 | buget | 102 | 2026-01-21 | 9 |

### 5 — 11 tupluri

| idst | nume_prenume | grupa | forma | idcurs | data | nota |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Ana Rusu | IT21 | buget | 101 | 2026-01-14 | 9 |
| 1 | Ana Rusu | IT21 | buget | 104 | 2026-06-17 | 10 |
| 2 | Ion Munteanu | IT22 | contract | 101 | 2026-01-14 | 6 |
| 2 | Ion Munteanu | IT22 | contract | 103 | 2026-06-10 | 7 |
| 3 | Maria Lungu | IT21 | buget | 101 | 2026-01-14 | 10 |
| 3 | Maria Lungu | IT21 | buget | 102 | 2026-01-21 | 9 |
| 4 | Victor Popa | IS21 | contract | 102 | 2026-01-21 | 5 |
| 6 | Dan Moraru | IT22 | contract | 101 | 2026-01-14 | 4 |
| 6 | Dan Moraru | IT22 | contract | 101 | 2026-02-05 | 6 |
| 8 | Pavel Guțu | IT21 | contract | 101 | 2026-01-14 | 7 |
| 8 | Pavel Guțu | IT21 | contract | 104 | 2026-06-17 | 6 |

### 6 — 11 tupluri

| idst | nume_prenume | grupa | forma | idcurs | data | nota |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Ana Rusu | IT21 | buget | 101 | 2026-01-14 | 9 |
| 1 | Ana Rusu | IT21 | buget | 104 | 2026-06-17 | 10 |
| 2 | Ion Munteanu | IT22 | contract | 101 | 2026-01-14 | 6 |
| 2 | Ion Munteanu | IT22 | contract | 103 | 2026-06-10 | 7 |
| 3 | Maria Lungu | IT21 | buget | 101 | 2026-01-14 | 10 |
| 3 | Maria Lungu | IT21 | buget | 102 | 2026-01-21 | 9 |
| 4 | Victor Popa | IS21 | contract | 102 | 2026-01-21 | 5 |
| 6 | Dan Moraru | IT22 | contract | 101 | 2026-01-14 | 4 |
| 6 | Dan Moraru | IT22 | contract | 101 | 2026-02-05 | 6 |
| 8 | Pavel Guțu | IT21 | contract | 101 | 2026-01-14 | 7 |
| 8 | Pavel Guțu | IT21 | contract | 104 | 2026-06-17 | 6 |

### 7 — 5 tupluri

| denumire | nota |
| --- | --- |
| Matematică discretă | 9 |
| Matematică discretă | 6 |
| Matematică discretă | 10 |
| Matematică discretă | 4 |
| Matematică discretă | 7 |

### 8 — 4 tupluri

| denumire |
| --- |
| Matematică discretă |
| Programare procedurală |
| Arhitectura calculatoarelor |
| Programare orientată pe obiecte |

### 9 — 5 tupluri

| idst | nume_prenume | grupa | forma | idcurs | data | nota | denumire | credite | semestru |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | Ana Rusu | IT21 | buget | 104 | 2026-06-17 | 10 | Programare orientată pe obiecte | 6 | 2 |
| 2 | Ion Munteanu | IT22 | contract | 103 | 2026-06-10 | 7 | Arhitectura calculatoarelor | 4 | 2 |
| 3 | Maria Lungu | IT21 | buget | 103 | 2026-06-10 | 8 | Arhitectura calculatoarelor | 4 | 2 |
| 5 | Elena Cojocaru | IT22 | buget | 104 | 2026-06-17 | 7 | Programare orientată pe obiecte | 6 | 2 |
| 8 | Pavel Guțu | IT21 | contract | 104 | 2026-06-17 | 6 | Programare orientată pe obiecte | 6 | 2 |

### 10a — 14 tupluri

| idst | idcurs | data | nota |
| --- | --- | --- | --- |
| 1 | 101 | 2026-01-14 | 9 |
| 1 | 102 | 2026-01-21 | 8 |
| 1 | 104 | 2026-06-17 | 10 |
| 2 | 101 | 2026-01-14 | 6 |
| 2 | 103 | 2026-06-10 | 7 |
| 3 | 101 | 2026-01-14 | 10 |
| 3 | 102 | 2026-01-21 | 9 |
| 3 | 103 | 2026-06-10 | 8 |
| 4 | 102 | 2026-01-21 | 5 |
| 5 | 104 | 2026-06-17 | 7 |
| 6 | 101 | 2026-01-14 | 4 |
| 6 | 101 | 2026-02-05 | 6 |
| 8 | 101 | 2026-01-14 | 7 |
| 8 | 104 | 2026-06-17 | 6 |

### 10b — 7 tupluri

| idst | nume_prenume | grupa | forma |
| --- | --- | --- | --- |
| 1 | Ana Rusu | IT21 | buget |
| 2 | Ion Munteanu | IT22 | contract |
| 3 | Maria Lungu | IT21 | buget |
| 4 | Victor Popa | IS21 | contract |
| 5 | Elena Cojocaru | IT22 | buget |
| 6 | Dan Moraru | IT22 | contract |
| 8 | Pavel Guțu | IT21 | contract |

## Exercițiul 3

### 1 — 3 tupluri

| model | price |
| --- | --- |
| 1001 | 850 |
| 1003 | 1350 |
| 1005 | 520 |

### 2 — 2 tupluri

| model | price |
| --- | --- |
| 2002 | 640 |
| 2005 | 520 |

### 3 — 1 tupluri

| maker |
| --- |
| D |

### 4 — 4 tupluri

| model | price |
| --- | --- |
| 1001 | 850 |
| 1002 | 520 |
| 2001 | 1100 |
| 3001 | 120 |

### 5 — 1 tupluri

| maker |
| --- |
| D |

### 6 — 2 tupluri

| speed |
| --- |
| 2.8 |
| 3.2 |

### 7 — 2 tupluri

| model1 | model2 |
| --- | --- |
| 1001 | 1005 |
| 1002 | 1004 |

### 8 — 3 tupluri

| maker |
| --- |
| A |
| B |
| C |

### 9 — 1 tupluri

| model | price |
| --- | --- |
| 2002 | 640 |

### 10 — 1 tupluri

| model |
| --- |
| 1003 |

### 11 — 2 tupluri

| maker |
| --- |
| A |
| C |

### 12 — 4 tupluri

| pc_model | printer_model |
| --- | --- |
| 1002 | 3004 |
| 1002 | 3001 |
| 1005 | 3004 |
| 1005 | 3001 |

### 13 — 5 tupluri

| maker | model |
| --- | --- |
| A | 3001 |
| B | NULL |
| C | 3002 |
| E | 3004 |
| D | 3003 |

### 14 — 4 tupluri

| maker | nr_modele | pret_mediu |
| --- | --- | --- |
| A | 2 | 685.0 |
| B | 1 | 1350.0 |
| C | 1 | 780.0 |
| E | 1 | 520.0 |
