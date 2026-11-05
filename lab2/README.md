# Laboratorul 2 — Normalizarea relațiilor

Sunt rezolvate toate cele 8 exerciții din `Enunt.pdf`, folosind materialul din `laboratormateriale`. Nu sunt incluse întrebări de control sau alte laboratoare.

- `Rezolvare.md` — răspunsuri, chei, dependențe funcționale, anomalii, normalizarea și justificările descompunerilor.
- `Lab2_Scheme_Normalizare.drawio` — 9 pagini editabile: schemele exercițiilor 1–8, cu etape separate pentru 2FN și 3FN la exercițiul 2.
- `Lab2_Tabele_Exemple.drawio` — 6 pagini editabile: tabelele A/X/Y, joncțiunea cu tupluri suplimentare, tabelele 1FN/2FN/3FN și datele facturii.
- `previzualizari/` — imagini PNG pentru vizualizare rapidă.
- `Verificare.json` — rezultatele verificărilor automate.

Fișierele `.drawio` se deschid în aplicația Draw.io / diagrams.net. Paginile se schimbă din filele din partea de jos a editorului.

## Verificare

Din folderul proiectului:

```sh
python3 lab2/src/verifica.py
```

Scriptul folosește numai biblioteca standard Python. Verifică exhaustiv cheile candidate și dependențele proiectate pentru exercițiile 2–7, forma FNBC, păstrarea dependențelor și absența pierderilor prin chase. Pentru exercițiul 1 verifică cele 3 tupluri suplimentare; pentru 2, reconstrucția exactă a celor 6 linii; pentru 8, volumele și sumele monetare, prin aritmetică zecimală.

Ipotezele necesare la exercițiile 6 și 7 sunt explicate în rezolvare. Exercițiul 8 este un model propus în 3FN; schema include înlesnirile procentuale și păstrează distinct sfârșitul perioadei facturate și data ultimei citiri, așa cum apar în imagine.

## Regenerarea diagramelor

```sh
python3 lab2/src/diagrame.py
```

Generarea fișierelor Draw.io folosește biblioteca standard Python. Pentru PNG-uri este necesar Pillow și, în configurația curentă macOS, fontul Arial. Regenerarea nu modifică alte laboratoare.
