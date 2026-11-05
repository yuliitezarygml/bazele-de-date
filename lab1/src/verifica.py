"""Verify sample keys/references and collision-free table connections."""
from pathlib import Path
from itertools import combinations
import sqlite3,json,xml.etree.ElementTree as E
from modele import MODELS
from redare import table_scene
ROOT=Path(__file__).resolve().parents[1]

def wires_cross(a,b,c,d):
 if a[0]==b[0] and c[0]==d[0]:return a[0]==c[0] and max(min(a[1],b[1]),min(c[1],d[1]))<min(max(a[1],b[1]),max(c[1],d[1]))
 if a[1]==b[1] and c[1]==d[1]:return a[1]==c[1] and max(min(a[0],b[0]),min(c[0],d[0]))<min(max(a[0],b[0]),max(c[0],d[0]))
 if a[0]!=b[0]:a,b,c,d=c,d,a,b
 return min(c[0],d[0])<=a[0]<=max(c[0],d[0]) and min(a[1],b[1])<=c[1]<=max(a[1],b[1])

def intersects_box(a,b,n):
 x,y,w,h=n['x'],n['y'],n['w'],n['h']
 if a[0]==b[0]:return x<a[0]<x+w and max(y,min(a[1],b[1]))<min(y+h,max(a[1],b[1]))
 return y<a[1]<y+h and max(x,min(a[0],b[0]))<min(x+w,max(a[0],b[0]))

def validate_model(m):
 con=sqlite3.connect(':memory:');con.execute('PRAGMA foreign_keys=ON');con.execute('BEGIN');con.execute('PRAGMA defer_foreign_keys=ON')
 for t in m.tables:
  cols=[c for c in t.cols if not c.derived];defs=[f'"{c.name}" {c.type}' for c in cols];pk=[f'"{c.name}"' for c in cols if 'PK' in c.key];defs.append('PRIMARY KEY ('+', '.join(pk)+')')
  for c in cols:
   if 'UQ' in c.key:defs.append(f'UNIQUE ("{c.name}")')
   if c.ref:
    target,col=c.ref.split('.');defs.append(f'FOREIGN KEY ("{c.name}") REFERENCES "{target}" ("{col}")')
  con.execute(f'CREATE TABLE "{t.name}" ('+', '.join(defs)+')')
 for t in m.tables:
  indices=[i for i,c in enumerate(t.cols) if not c.derived]
  assert all(len(row)==len(t.cols) for row in t.rows)
  for row in t.rows:
   for c,v in zip(t.cols,row):
    if v is not None and ('VARCHAR' in c.type or c.type.startswith('CHAR')):assert len(str(v))<=int(c.type.split('(')[1].split(')')[0]),(m.code,t.name,c.name,v)
  con.executemany(f'INSERT INTO "{t.name}" VALUES ('+','.join('?' for _ in indices)+')',[[row[i] for i in indices] for row in t.rows])
 assert con.execute('PRAGMA foreign_key_check').fetchall()==[]
 con.commit()
 scene=table_scene(m)
 for e1,e2 in combinations(scene.edges,2):
  assert not any(wires_cross(a,b,c,d) for a,b in zip(e1['pts'],e1['pts'][1:]) for c,d in zip(e2['pts'],e2['pts'][1:])),(m.code,'crossed wires',e1['id'],e2['id'])
 tables=[n for n in scene.shapes if n['parent']=='1' and n['id'].startswith('t_')];labels=[n for n in scene.shapes if n['id'].startswith('label')]
 for e in scene.edges:
  for a,b in zip(e['pts'],e['pts'][1:]):
   assert a[0]==b[0] or a[1]==b[1]
   for t in tables:assert not intersects_box(a,b,t),(m.code,'wire crosses table',e['id'],t['id'])
 for l in labels:
  for n in tables+[n for n in labels if n!=l]:assert not (l['x']<n['x']+n['w'] and l['x']+l['w']>n['x'] and l['y']<n['y']+n['h'] and l['y']+l['h']>n['y']),(m.code,'label overlap')
  for e in scene.edges:
   if e['id']=='relation'+l['id'][5:]:continue
   for a,b in zip(e['pts'],e['pts'][1:]):assert not intersects_box(a,b,l),(m.code,'wire crosses label')
 if m.code=='5':
  vin=con.execute('SELECT vin FROM VEHICUL').fetchone()[0];assert len(vin)==17
  price=con.execute('SELECT m.pret_baza+SUM(d.cost_suplimentar) FROM VEHICUL v JOIN MODEL m ON m.cod_model=v.cod_model JOIN VEHICUL_DOTARE vd ON vd.vin=v.vin JOIN DOTARE d ON d.cod_dotare=vd.cod_dotare GROUP BY v.vin').fetchone()[0]
  assert price==22500
 if m.code=='4':assert con.execute('SELECT COUNT(*) FROM ADJUDECARE a JOIN OFERTA o ON o.id_oferta=a.id_oferta_castigatoare AND o.id_licitatie=a.id_licitatie').fetchone()[0]==1
 return dict(tabele=len(m.tables),integritate_PK_FK=True,tipuri_si_lungimi=True,intersectii_intre_linii=0,intersectii_linii_tabele=0,suprapuneri_etichete=0)

if __name__=='__main__':
 results={m.code:validate_model(m) for m in MODELS}
 for path in ROOT.rglob('*.drawio'):
  root=E.parse(path).getroot()
  for page in root.findall('diagram'):
   assert 'ISA' not in ''.join(c.get('value','') for c in page.findall('.//mxCell'))
   cells=page.findall('.//mxCell');ids=[c.get('id') for c in cells];assert len(ids)==len(set(ids))
   for cell in cells:
    for attr in ('parent','source','target'):
     if cell.get(attr):assert cell.get(attr) in ids,(path,cell.get('id'),attr)
 (ROOT/'Verificare.json').write_text(json.dumps(results,ensure_ascii=False,indent=2)+'\n')
 print('OK: 9 models; valid sample keys/FKs; no table-wire crossings or label overlaps; all draw.io references valid; no ISA labels.')
