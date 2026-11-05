"""Checks of normalization solutions; Python standard library only.
Run from any directory: python3 /absolute/path/lab2/src/verifica.py
"""
from itertools import combinations
from functools import lru_cache
from decimal import Decimal, ROUND_HALF_UP
from pathlib import Path
import sqlite3, json

ROOT=Path(__file__).resolve().parents[1]

def fd(left,right):return (frozenset(left.split()),frozenset(right.split()))
CASES={
 'Ex2':dict(attrs='nr_comanda data nr_client nume_client adresa nr_articol den_articol cantitatea pret',fds=[fd('nr_comanda','data nr_client'),fd('nr_client','nume_client adresa'),fd('nr_articol','den_articol pret'),fd('nr_comanda nr_articol','cantitatea')],parts=['nr_client nume_client adresa','nr_comanda data nr_client','nr_articol den_articol pret','nr_comanda nr_articol cantitatea'],key='nr_comanda nr_articol'),
 'Ex3':dict(attrs='nr_piesei pret TVA denumirea categoria',fds=[fd('nr_piesei','pret TVA denumirea categoria'),fd('categoria','TVA')],parts=['nr_piesei pret denumirea categoria','categoria TVA'],key='nr_piesei'),
 'Ex4':dict(attrs='a b c d e f',fds=[fd('a b','c d e f'),fd('b','c'),fd('d','e f')],parts=['b c','d e f','a b d'],key='a b'),
 'Ex5':dict(attrs='a b c d e f g h',fds=[fd('a','c g'),fd('b','e g'),fd('a b','d'),fd('c','f'),fd('g','h')],parts=['a c g','b e g','c f','g h','a b d'],key='a b'),
 'Ex6':dict(attrs='IDP nume_angajat nr_proiect nr_ore den_proiect laborator',fds=[fd('IDP','nume_angajat'),fd('nr_proiect','den_proiect laborator'),fd('IDP nr_proiect','nr_ore')],parts=['IDP nume_angajat','nr_proiect den_proiect laborator','IDP nr_proiect nr_ore'],key='IDP nr_proiect'),
 'Ex7':dict(attrs='nr_film titlu_film durata_film nr_sala capacitate_sala tip_scaun pret data_derularii ora_derularii',fds=[fd('nr_film','titlu_film durata_film'),fd('nr_sala','capacitate_sala tip_scaun'),fd('nr_sala data_derularii ora_derularii','nr_film pret')],parts=['nr_film titlu_film durata_film','nr_sala capacitate_sala tip_scaun','nr_sala data_derularii ora_derularii nr_film pret'],key='nr_sala data_derularii ora_derularii'),
}

def subsets(xs):
 xs=sorted(xs)
 for size in range(len(xs)+1):
  for group in combinations(xs,size):yield frozenset(group)

def closure(x,fds):
 out=set(x)
 while True:
  old=len(out)
  for left,right in fds:
   if left<=out:out.update(right)
  if len(out)==old:return frozenset(out)

def lossless(attrs,parts,fds):
 """FD chase: a full distinguished row proves lossless join."""
 attrs=sorted(attrs);n=len(attrs);parent={}
 def find(x):
  parent.setdefault(x,x)
  if parent[x]!=x:parent[x]=find(parent[x])
  return parent[x]
 def merge(x,y):
  x,y=find(x),find(y)
  if x==y:return False
  if y.startswith('a:'):x,y=y,x
  parent[y]=x;return True
 rows=[[('a:'+a) if a in part else f'b:{i}:{a}' for a in attrs] for i,part in enumerate(parts)]
 while True:
  changed=False
  for left,right in fds:
   li=[attrs.index(a) for a in left];ri=[attrs.index(a) for a in right]
   for row1,row2 in combinations(rows,2):
    if all(find(row1[j])==find(row2[j]) for j in li):
     for j in ri:changed=merge(row1[j],row2[j]) or changed
  if not changed:break
 return any(all(find(row[j])==find('a:'+a) for j,a in enumerate(attrs)) for row in rows)

def check_case(case):
 attrs=frozenset(case['attrs'].split());fds=case['fds'];parts=[frozenset(p.split()) for p in case['parts']]
 cl=lru_cache(None)(lambda x:closure(x,fds))
 keys=[]
 for x in subsets(attrs):
  if cl(x)==attrs and not any(k<=x for k in keys):keys.append(x)
 assert keys==[frozenset(case['key'].split())],('Unexpected candidate keys',keys)
 projected=[]
 for part in parts:
  for x in subsets(part):
   implied=cl(x)&part
   if implied-x:
    assert implied==part,('BCNF violation',part,x,implied)
    projected.append((x,implied-x))
 assert all(right<=closure(left,projected) for left,right in fds),'Dependency not preserved'
 assert lossless(attrs,parts,fds),'Lossy decomposition'
 return {'chei_candidate':[sorted(k) for k in keys],'FNBC':True,'dependente_pastrate':True,'fara_pierderi_chase':True}

def check_examples():
 c=sqlite3.connect(':memory:')
 c.executescript('''PRAGMA foreign_keys=ON;
 CREATE TABLE A(id INTEGER,nume TEXT,curs TEXT,credite INTEGER);
 INSERT INTO A VALUES (1111,'Popescu Ion','IP201',5),(1112,'Negrescu Dan','IP202',6),(1113,'Sîrbu Oana','IP201',5),(1114,'Lisnic Dana','IS201',6),(1115,'Rotari Marin','IS201',6);
 CREATE VIEW X AS SELECT DISTINCT id,nume,credite FROM A;
 CREATE VIEW Y AS SELECT DISTINCT curs,credite FROM A;
 CREATE TABLE Sursa(nr_comanda INTEGER,data TEXT,nr_client TEXT,nume_client TEXT,adresa TEXT,nr_articol INTEGER,den_articol TEXT,cantitatea INTEGER,pret INTEGER,PRIMARY KEY(nr_comanda,nr_articol));
 INSERT INTO Sursa VALUES (1001,'2012-02-03','A004','Donici Ion','Bălți',6531,'Dulap',1,700),(1001,'2012-02-03','A004','Donici Ion','Bălți',7890,'Masă mic',1,400),(1001,'2012-02-03','A004','Donici Ion','Bălți',9134,'Scaun',4,250),(1002,'2012-02-04','A986','Malcoș Dumitru','Bălți',3561,'Taburetă',2,130),(1003,'2012-02-05','A201','Pintilei Ana','Drochia',4234,'Cuier',1,300),(1003,'2012-02-05','A201','Pintilei Ana','Drochia',7890,'Masă mic',1,400);
 CREATE TABLE Clienti(nr_client TEXT PRIMARY KEY,nume_client TEXT,adresa TEXT);
 INSERT INTO Clienti SELECT DISTINCT nr_client,nume_client,adresa FROM Sursa;
 CREATE TABLE Comenzi(nr_comanda INTEGER PRIMARY KEY,data TEXT,nr_client TEXT REFERENCES Clienti);
 INSERT INTO Comenzi SELECT DISTINCT nr_comanda,data,nr_client FROM Sursa;
 CREATE TABLE Articole(nr_articol INTEGER PRIMARY KEY,den_articol TEXT,pret INTEGER);
 INSERT INTO Articole SELECT DISTINCT nr_articol,den_articol,pret FROM Sursa;
 CREATE TABLE Detalii_comenzi(nr_comanda INTEGER REFERENCES Comenzi,nr_articol INTEGER REFERENCES Articole,cantitatea INTEGER,PRIMARY KEY(nr_comanda,nr_articol));
 INSERT INTO Detalii_comenzi SELECT nr_comanda,nr_articol,cantitatea FROM Sursa;
 ''')
 a=set(c.execute('SELECT * FROM A'));joined=set(c.execute('SELECT id,nume,curs,credite FROM X NATURAL JOIN Y'))
 assert len(joined)==8 and len(joined-a)==3 and a<=joined
 restored=set(c.execute('''SELECT c.nr_comanda,c.data,c.nr_client,cl.nume_client,cl.adresa,d.nr_articol,ar.den_articol,d.cantitatea,ar.pret
 FROM Comenzi c JOIN Clienti cl ON cl.nr_client=c.nr_client JOIN Detalii_comenzi d ON d.nr_comanda=c.nr_comanda JOIN Articole ar ON ar.nr_articol=d.nr_articol'''))
 assert restored==set(c.execute('SELECT * FROM Sursa')) and len(restored)==6
 assert c.execute('PRAGMA foreign_key_check').fetchall()==[]
 money=lambda qty,tariff:(Decimal(qty)*Decimal(tariff)).quantize(Decimal('.01'),rounding=ROUND_HALF_UP)
 f1=money('4.464','3.900');f2=money('4.464','11.080')+money('.536','11.080')+money('.536','3.900')
 assert f1==Decimal('17.41') and f2==Decimal('57.49')
 assert Decimal('4.464')+Decimal('.536')==Decimal('105')-Decimal('100')
 return {'ex1_tupluri_initiale':5,'ex1_tupluri_dupa_join':8,'ex1_tupluri_suplimentare':3,'ex2_reconstructie_exacta':6,'ex2_integritate_FK':True,'ex8_total_Glorin':str(f1),'ex8_total_APA_CANAL':str(f2),'ex8_volum_total':'5.000'}

if __name__=='__main__':
 result={name:check_case(case) for name,case in CASES.items()};result['exemple']=check_examples()
 (ROOT/'Verificare.json').write_text(json.dumps(result,ensure_ascii=False,indent=2)+'\n')
 print('OK: chei candidate, FNBC, păstrarea dependențelor și chase pentru Ex. 2–7; exemple Ex. 1, 2 și 8.')
