"""Create editable draw.io normalization diagrams and PNG previews.
Pillow is optional (only needed for previews). Does not read or edit lab1.
"""
from pathlib import Path
import xml.etree.ElementTree as ET
from html import escape
import math
try:
 from PIL import Image,ImageDraw,ImageFont
except ImportError:
 Image=None
ROOT=Path(__file__).resolve().parents[1]
PRE=ROOT/'previzualizari';PRE.mkdir(exist_ok=True)
FONT='/System/Library/Fonts/Supplemental/Arial.ttf';BOLD='/System/Library/Fonts/Supplemental/Arial Bold.ttf'
NAVY='#234f73';INK='#233b50';EDGE='#6b8aa3'

def f(sz=17,bold=False):return ImageFont.truetype(BOLD if bold else FONT,sz)

def card(name,fields,col,row):return (name,fields,col,row)
def link(source,target,label='1 : N'):return (source,target,label)

class Page:
 def __init__(self,name,subtitle='',height=1250,width=2040):
  self.name=name;self.subtitle=subtitle;self.width=width;self.height=height;self.boxes=[];self.edges=[];self.notes=[];self.cells=[]
 def note(self,text,x,y,w,h):self.notes.append((text,x,y,w,h))
 def cards(self,cards,edges):
  for name,fields,col,row in cards:
   self.boxes.append(dict(id='b'+str(len(self.boxes)),name=name,fields=fields,x=70+650*col,y=330+430*row,w=440,h=58+30*len(fields)))
  self.height=max(self.height,max(b['y']+b['h'] for b in self.boxes)+180)
  byname={b['name']:b for b in self.boxes}
  for i,(source,target,label) in enumerate(edges):
   a,b=byname[source],byname[target]
   if a['y']==b['y']:
    forward=a['x']<b['x'];x1=a['x']+(a['w'] if forward else 0);x2=b['x']+(0 if forward else b['w']);y1=a['y']+a['h']/2;y2=b['y']+b['h']/2;mid=(x1+x2)/2
    pts=[(x1,y1),(mid,y1),(mid,y2),(x2,y2)]
   elif a['x']==b['x'] and abs(a['y']-b['y'])<=430:
    down=a['y']<b['y'];x=a['x']+a['w']/2;y1=a['y']+(a['h'] if down else 0);y2=b['y']+(0 if down else b['h']);pts=[(x,y1),(x,y2)]
   else:
    down=a['y']<b['y'];x1=a['x']+a['w'];x2=b['x']+b['w'];corr1=x1+95;corr2=x2+95;y1=a['y']+a['h']/2;y2=b['y']+b['h']/2;mid=min(a['y'],b['y'])+365
    pts=[(x1,y1),(corr1,y1),(corr1,mid),(corr2,mid),(corr2,y2),(x2,y2)]
   candidates=[]
   for u,v in zip(pts,pts[1:]):
    for t in [.5,.25,.75]:
     x=u[0]+t*(v[0]-u[0]);y=u[1]+t*(v[1]-u[1]);box=(x-95,y-22,x+95,y+22)
     hits=sum(box[0]<n['x']+n['w']+8 and box[2]>n['x']-8 and box[1]<n['y']+n['h']+8 and box[3]>n['y']-8 for n in self.boxes)
     hits+=sum(abs(x-e['lx'])<190 and abs(y-e['ly'])<50 for e in self.edges)
     candidates.append((hits,abs(t-.5),x,y))
   _,_,lx,ly=min(candidates)
   self.edges.append(dict(a=a,b=b,pts=pts,label=label,lx=lx,ly=ly))
 def table(self,name,headers,rows,x,y,widths):
  total=sum(widths);self.cells.append((name,x,y,total,44,'title'));y+=44
  xx=x
  for h,w in zip(headers,widths):self.cells.append((str(h),xx,y,w,66,'header'));xx+=w
  y+=66
  for i,row in enumerate(rows):
   xx=x;hh=60 if all(len(str(v))<40 for v in row) else 95
   for v,w in zip(row,widths):self.cells.append(('NULL' if v is None else str(v),xx,y,w,hh,'data'+str(i%2)));xx+=w
   y+=hh
  self.width=max(self.width,x+total+60);self.height=max(self.height,y+180)
  return y
 def xml(self):
  m=ET.Element('mxGraphModel',grid='1',gridSize='10',guides='1',connect='1',page='1',pageScale='1',pageWidth=str(self.width),pageHeight=str(self.height));r=ET.SubElement(m,'root');ET.SubElement(r,'mxCell',id='0');ET.SubElement(r,'mxCell',id='1',parent='0')
  def vertex(id,value,x,y,w,h,style,parent='1'):
   c=ET.SubElement(r,'mxCell',id=id,value=value,style=style,vertex='1',parent=parent);ET.SubElement(c,'mxGeometry',x=str(x),y=str(y),width=str(w),height=str(h),**{'as':'geometry'});return c
  vertex('title',escape(self.name),60,25,self.width-120,55,f'text;html=1;align=left;fontColor={NAVY};fontSize=28;fontStyle=1;')
  vertex('sub',escape(self.subtitle),60,90,self.width-120,65,f'text;html=1;whiteSpace=wrap;align=left;fontColor={INK};fontSize=17;')
  for i,e in enumerate(self.edges):
   pts=e['pts'];a=e['a'];b=e['b'];style=f'edgeStyle=none;endArrow=none;html=1;strokeColor={EDGE};strokeWidth=2;'
   style+=f'exitX={(pts[0][0]-a["x"])/a["w"]};exitY={(pts[0][1]-a["y"])/a["h"]};entryX={(pts[-1][0]-b["x"])/b["w"]};entryY={(pts[-1][1]-b["y"])/b["h"]};'
   c=ET.SubElement(r,'mxCell',id='edge'+str(i),style=style,edge='1',parent='1',source=a['id'],target=b['id']);g=ET.SubElement(c,'mxGeometry',relative='1',**{'as':'geometry'});arr=ET.SubElement(g,'Array',**{'as':'points'})
   for x,y in pts[1:-1]:ET.SubElement(arr,'mxPoint',x=str(x),y=str(y))
   vertex('el'+str(i),escape(e['label']),e['lx']-95,e['ly']-22,190,44,f'text;html=1;whiteSpace=wrap;fillColor=#ffffff;fontColor={EDGE};fontSize=15;align=center;')
  for b in self.boxes:
   vertex(b['id'],'',b['x'],b['y'],b['w'],b['h'],f'fillColor=#ffffff;strokeColor={NAVY};strokeWidth=2;')
   vertex(b['id']+'_h',escape(b['name']),0,0,b['w'],48,f'html=1;fillColor={NAVY};strokeColor={NAVY};fontColor=#ffffff;fontSize=20;fontStyle=1;align=left;spacingLeft=14;',b['id'])
   for j,field in enumerate(b['fields']):vertex(b['id']+'_r'+str(j),escape(field),12,53+30*j,b['w']-24,30,f'text;html=1;align=left;fontColor={INK};fontSize=16;',b['id'])
  for i,(value,x,y,w,h) in enumerate(self.notes):vertex('note'+str(i),escape(value).replace('\n','<br>'),x,y,w,h,f'html=1;whiteSpace=wrap;fillColor=#f0f5fa;strokeColor=#d4dfeb;align=left;verticalAlign=top;spacing=14;fontSize=17;fontColor={INK};')
  for i,(text,x,y,w,h,kind) in enumerate(self.cells):
   fill=NAVY if kind=='title' else '#dceafa' if kind=='header' else '#ffffff' if kind=='data0' else '#f5f8fc';color='#ffffff' if kind=='title' else INK
   vertex('c'+str(i),escape(text).replace('\n','<br>'),x,y,w,h,f'html=1;whiteSpace=wrap;fillColor={fill};strokeColor={EDGE};fontColor={color};fontSize=16;fontStyle={int(kind in ("header","title"))};align=center;verticalAlign=middle;')
  return m
 def png(self,path):
  if Image is None:return
  im=Image.new('RGB',(self.width,self.height),'white');d=ImageDraw.Draw(im)
  def text(value,box,sz=17,color=INK,bold=False,center=False):
   x,y,w,h=box;words=str(value).split('\n');lines=[]
   for para in words:
    line=''
    for word in para.split():
     nxt=(line+' '+word).strip()
     if f(sz,bold).getlength(nxt)>w-20 and line:lines.append(line);line=word
     else:line=nxt
    lines.append(line)
   yy=y+(h-len(lines)*(sz+6))/2 if center else y+8
   for line in lines:
    xx=x+(w-f(sz,bold).getlength(line))/2 if center else x+10;d.text((xx,yy),line,font=f(sz,bold),fill=color);yy+=sz+6
  text(self.name,(60,25,self.width-120,55),28,NAVY,True);text(self.subtitle,(60,90,self.width-120,65),17)
  for e in self.edges:d.line(e['pts'],fill=EDGE,width=2);d.rectangle((e['lx']-95,e['ly']-22,e['lx']+95,e['ly']+22),fill='white');text(e['label'],(e['lx']-95,e['ly']-22,190,44),15,EDGE,center=True)
  for b in self.boxes:
   x,y,w,h=b['x'],b['y'],b['w'],b['h'];d.rectangle((x,y,x+w,y+h),fill='white',outline=NAVY,width=2);d.rectangle((x,y,x+w,y+48),fill=NAVY);text(b['name'],(x+4,y+1,w-8,46),20,'white',True)
   for j,field in enumerate(b['fields']):text(field,(x+4,y+50+30*j,w-8,30),16)
  for val,x,y,w,h in self.notes:d.rectangle((x,y,x+w,y+h),fill='#f0f5fa',outline='#d4dfeb');text(val,(x+5,y+4,w-10,h-8),17)
  for val,x,y,w,h,kind in self.cells:
   fill=NAVY if kind=='title' else '#dceafa' if kind=='header' else '#ffffff' if kind=='data0' else '#f5f8fc';col='white' if kind=='title' else INK
   d.rectangle((x,y,x+w,y+h),fill=fill,outline=EDGE);text(val,(x,y,w,h),16,col,kind in ('title','header'),True)
  if self.width>2400:im=im.resize((2400,round(self.height*2400/self.width)),Image.Resampling.LANCZOS)
  im.save(path)

SCHEMAS=[];TABLES=[]
def schema(title,source,cards,edges,footer):
 p=Page(title,'PK = cheie primară • FK = cheie străină • PK/FK = parte a cheii compuse și cheie străină • 1:N = cardinalitate')
 p.note(source,60,175,1920,125);p.cards(cards,edges);p.note(footer,60,p.height-130,1920,100);SCHEMAS.append(p);return p

schema('Ex. 1 — O descompunere corectă','Descompunerea propusă A → X,Y este cu pierderi: X ⋈ Y conține 8 tupluri în loc de 5. Legătura pe Nr_credite produce trei asocieri false. O variantă fără pierderi este schema de mai jos, sub regulile Id_student → Nume_student și Cod_curs → Nr_credite.',[
card('Studenti',['PK Id_student','Nume_student'],0,0),card('Inscrieri',['PK/FK Id_student → Studenti','PK/FK Cod_curs → Cursuri'],1,0),card('Cursuri',['PK Cod_curs','Nr_credite'],2,0)],[link('Studenti','Inscrieri'),link('Cursuri','Inscrieri')],'Pentru mai multe cursuri/student, cheia Inscrieri este (Id_student,Cod_curs). Datele concrete ale reconstrucției incorecte sunt pe pagina Ex. 1 — Tabele.')

schema('Ex. 2 — Comenzi în 2FN','Cheie inițială: (Nr_comanda,Nr_articol). Nr_comanda → Data,Nr_client,Nume_client,Adresa; Nr_articol → Den_articol,Pret. Separăm dependențele parțiale. Cantitatea depinde de întreaga cheie.',[
card('Comenzi_2FN',['PK Nr_comanda','Data','Nr_client','Nume_client','Adresa'],0,0),card('Detalii_comenzi',['PK/FK Nr_comanda → Comenzi_2FN','PK/FK Nr_articol → Articole','Cantitatea'],1,0),card('Articole',['PK Nr_articol','Den_articol','Pret'],2,0)],[link('Comenzi_2FN','Detalii_comenzi'),link('Articole','Detalii_comenzi')],'Comenzi_2FN păstrează dependența tranzitivă Nr_comanda → Nr_client → Nume_client,Adresa. Aceasta va fi eliminată în 3FN.')
schema('Ex. 2 — Comenzi în 3FN / FNBC','Eliminăm dependența tranzitivă prin Nr_client. Clienti păstrează identitatea clientului; Comenzi păstrează doar referința. Tabelele și cele 6 linii de comandă sunt prezentate separat, cu datele din enunț.',[
card('Clienti',['PK Nr_client','Nume_client','Adresa'],0,0),card('Comenzi',['PK Nr_comanda','Data','FK Nr_client → Clienti'],1,0),card('Detalii_comenzi',['PK/FK Nr_comanda → Comenzi','PK/FK Nr_articol → Articole','Cantitatea'],1,1),card('Articole',['PK Nr_articol','Den_articol','Pret'],2,1)],[link('Clienti','Comenzi'),link('Comenzi','Detalii_comenzi'),link('Articole','Detalii_comenzi')],'Toate dependențele sunt păstrate. Determinanții netriviali sunt chei; rezultatul este în FNBC. Joncțiunea celor 4 tabele reconstruiește exact cele 6 tupluri din 1FN.')

schema('Ex. 3 — Piese și categorii, FNBC','Piesa(nr_piesei,pret,TVA,denumirea,categoria). nr_piesei → pret,TVA,denumirea,categoria; categoria → TVA. Cheie: nr_piesei. Inițial: 2FN, nu 3FN. Dependența tranzitivă spre TVA produce anomalii.',[
card('Categorii',['PK categoria','TVA'],0,0),card('Piese',['PK nr_piesei','pret','denumirea','FK categoria → Categorii'],1,0)],[link('Categorii','Piese')],'Intersecția este categoria, cheie în Categorii: descompunere fără pierderi. TVA se actualizează o singură dată pentru fiecare categorie. Ambele relații sunt în FNBC.')
schema('Ex. 4 — R(a,b,c,d,e,f), FNBC','Dependențe: ab → c,d,e,f; b → c; d → e,f. Unica cheie: {a,b}, deoarece a și b nu apar în părțile drepte și (ab)+ = abcdef. Inițial: 1FN; b → c încalcă 2FN.',[
card('R1',['PK b','c'],0,0),card('R4',['PK a','PK/FK b → R1','FK d → R3'],1,0),card('R3',['PK d','e','f'],2,0)],[link('R1','R4'),link('R3','R4')],'Se separă b→c, apoi d→e,f. Intersecțiile b și d sunt chei în relațiile extrase. Toate dependențele inițiale rezultă din cele păstrate; fiecare relație este în FNBC.')
schema('Ex. 5 — R(a,b,c,d,e,f,g,h), FNBC','Dependențe: a → c,g; b → e,g; ab → d; c → f; g → h. Cheie: {a,b}. Inițial: 1FN, nu 2FN. Sinteza păstrează ambele dependențe spre g și o relație care conține cheia inițială.',[
card('C',['PK c','f'],0,0),card('A',['PK a','FK c → C','FK g → G'],1,0),card('G',['PK g','h'],2,0),card('AB',['PK/FK a → A','PK/FK b → B','d'],1,1),card('B',['PK b','e','FK g → G'],2,1)],[link('C','A'),link('G','A'),link('G','B'),link('A','AB'),link('B','AB')],'A, B, C, G și AB sunt în FNBC. Cheia {a,b} este în AB: sinteză fără pierderi, confirmată prin chase. Pentru fiecare pereche din AB, valorile g referite prin A și B trebuie să coincidă.')
schema('Ex. 6 — Angajați și proiecte, FNBC','Ipoteză: IDP identifică persoana. IDP → nume_angajat; nr_proiect → den_proiect,laborator; (IDP,nr_proiect) → nr_ore. Numele angajatului și denumirea proiectului nu sunt unice. Inițial: 1FN.',[
card('Angajati',['PK IDP','nume_angajat'],0,0),card('Participari',['PK/FK IDP → Angajati','PK/FK nr_proiect → Proiecte','nr_ore'],1,0),card('Proiecte',['PK nr_proiect','den_proiect','laborator'],2,0)],[link('Angajati','Participari'),link('Proiecte','Participari')],'Relația M:N dintre Angajati și Proiecte este rezolvată prin Participari. Dacă IDP este ID al participării, trebuie introdus un id_angajat distinct; varianta este explicată în Rezolvare.md.')
schema('Ex. 7 — Cinema, FNBC','Cheie: (nr_sala,data_derularii,ora_derularii), presupunând cel mult o proiecție/sală/moment. nr_film → titlu_film,durata_film; nr_sala → capacitate_sala,tip_scaun. Prețul aparține proiecției. Inițial: 1FN.',[
card('Filme',['PK nr_film','titlu_film','durata_film'],0,0),card('Proiectii',['PK/FK nr_sala → Sali','PK data_derularii','PK ora_derularii','FK nr_film → Filme','pret'],1,0),card('Sali',['PK nr_sala','capacitate_sala','tip_scaun'],2,0)],[link('Filme','Proiectii'),link('Sali','Proiectii')],'Nu presupunem din enunț că tip_scaun determină prețul. Dacă această regulă este impusă, se adaugă Tarife(tip_scaun PK,pret), se leagă Sali și se elimină pret din Proiectii.')

schema('Ex. 8 — Factura pentru apă, 3FN','Factura → consum facturat → segmente de consum → linii de servicii. Apa și canalizarea folosesc același volum de segment, fără duplicarea persoanelor/zilelor/volumului pe fiecare linie. Numărul contorului este text: 002342.',[
card('Furnizori',['PK id_furnizor','denumire','UQ cod_fiscal [opțional]'],0,0),card('Conturi_furnizori',['PK id_cont','FK id_furnizor → Furnizori','FK cod_banca → Banci','UQ numar_cont'],1,0),card('Banci',['PK cod_banca','denumire_banca'],2,0),
card('Consumatori',['PK id_consumator','nume','adresa'],0,1),card('Facturi',['PK id_factura','numar_document','FK id_cont → Conturi_furnizori','FK id_consumator → Consumatori','perioada_start','perioada_sfarsit','data_scadenta','datorie','recalculare','AK (id_cont,numar_document)'],1,1),card('Servicii',['PK id_serviciu','denumire_serviciu','unitate_masura'],2,1),
card('Contoare',['PK nr_contor [text]','FK id_consumator → Consumatori'],0,2),card('Consum_facturat',['PK id_consum','FK id_factura → Facturi','FK id_citire_initiala → Citiri','FK id_citire_finala → Citiri','AK: combinația celor trei FK'],1,2),card('Linii_servicii',['PK/FK id_segment → Segmente_consum','PK/FK id_serviciu → Servicii','tarif_aplicat','procent_inlesnire'],2,2),
card('Citiri',['PK id_citire','FK nr_contor → Contoare','data_citirii','index_contor','AK (nr_contor,data_citirii)'],0,3),card('Segmente_consum',['PK id_segment','FK id_consum → Consum_facturat','ordine_segment','nr_persoane','nr_zile','volum','AK (id_consum,ordine_segment)'],1,3)
],[link('Furnizori','Conturi_furnizori'),link('Banci','Conturi_furnizori'),link('Conturi_furnizori','Facturi'),link('Consumatori','Facturi'),link('Consumatori','Contoare'),link('Contoare','Citiri'),link('Facturi','Consum_facturat'),link('Citiri','Consum_facturat','1:N • două roluri'),link('Consum_facturat','Segmente_consum'),link('Segmente_consum','Linii_servicii'),link('Servicii','Linii_servicii')],'UQ = unic; AK = cheie candidat alternativă (atribute NOT NULL). Suma liniei, totalul și suma de plată sunt calculate, nu repetate. Schema nu conține avizul de decontare. Reguli și verificarea sumelor: Rezolvare.md.')

# Tables reproduced from the actual assignment, without invented rows in exercises 3–7.
p=Page('Ex. 1 — Tabelele A, X și Y','Joncțiunea X ⋈ Y se face pe Nr_credite. Acest atribut nu determină nici studentul, nici cursul.',height=1250)
a=[[1111,'Popescu Ion','IP201',5],[1112,'Negrescu Dan','IP202',6],[1113,'Sîrbu Oana','IP201',5],[1114,'Lisnic Dana','IS201',6],[1115,'Rotari Marin','IS201',6]]
p.table('A — relația inițială',['Id_student','Nume_student','Cod_curs','Nr_credite'],a,60,185,[160,230,160,140]);p.table('X',['Id_student','Nume_student','Nr_credite'],[[r[0],r[1],r[3]] for r in a],900,185,[160,230,140]);p.table('Y',['Cod_curs','Nr_credite'],[['IP201',5],['IP202',6],['IS201',6]],900,750,[200,200]);p.note('A are 5 tupluri, X are 5, Y are 3. Cele 3 linii cu 6 credite din X se potrivesc cu câte 2 cursuri din Y: 2×1 + 3×2 = 8 tupluri după joncțiune.',60,1000,720,150);TABLES.append(p)
p=Page('Ex. 1 — Rezultatul X ⋈ Y','Sunt păstrate toate cele 5 tupluri inițiale, dar apar 3 tupluri suplimentare. Prin urmare descompunerea este cu pierderi.',height=1150)
joined=[]
for sid,name,course,credits in a:
 for newcourse,cr in [('IP201',5),('IP202',6),('IS201',6)]:
  if credits==cr:joined.append([sid,name,newcourse,credits,'inițial' if course==newcourse else 'SUPLIMENTAR'])
p.table('X ⋈ Y',['Id_student','Nume_student','Cod_curs','Nr_credite','Observație'],joined,60,185,[180,280,180,180,230]);TABLES.append(p)

headers=['Nr_comanda','Data','Nr_client','Nume_client','Adresa','Nr_articol','Den_articol','Cantitatea','Pret']
rows=[[1001,'2012-02-03','A004','Donici Ion','Bălți',6531,'Dulap',1,700],[1001,'2012-02-03','A004','Donici Ion','Bălți',7890,'Masă mic',1,400],[1001,'2012-02-03','A004','Donici Ion','Bălți',9134,'Scaun',4,250],[1002,'2012-02-04','A986','Malcoș Dumitru','Bălți',3561,'Taburetă',2,130],[1003,'2012-02-05','A201','Pintilei Ana','Drochia',4234,'Cuier',1,300],[1003,'2012-02-05','A201','Pintilei Ana','Drochia',7890,'Masă mic',1,400]]
p=Page('Ex. 2 — Prima formă normală (1FN)','Cheie compusă: (Nr_comanda,Nr_articol). Listele din enunț sunt desfăcute în câte o linie pentru fiecare articol al comenzii.',height=1050)
p.table('Comenzi_1FN',headers,rows,60,190,[150,170,150,220,160,160,180,150,130]);p.note('Fiecare celulă conține o valoare atomică. Nr_comanda → Data,Nr_client; Nr_client → Nume_client,Adresa; Nr_articol → Den_articol,Pret; (Nr_comanda,Nr_articol) → Cantitatea.',60,800,1850,125);TABLES.append(p)
orders=[[1001,'2012-02-03','A004','Donici Ion','Bălți'],[1002,'2012-02-04','A986','Malcoș Dumitru','Bălți'],[1003,'2012-02-05','A201','Pintilei Ana','Drochia']]
articles=[[6531,'Dulap',700],[7890,'Masă mic',400],[9134,'Scaun',250],[3561,'Taburetă',130],[4234,'Cuier',300]]
details=[[r[0],r[5],r[7]] for r in rows]
p=Page('Ex. 2 — Tabelele în 2FN','Sunt eliminate dependențele parțiale de Nr_comanda și Nr_articol. Dependența prin client rămâne în Comenzi_2FN.',height=1500)
p.table('Comenzi_2FN • PK Nr_comanda',headers[:5],orders,60,185,[160,180,160,240,160]);p.table('Articole • PK Nr_articol',['Nr_articol','Den_articol','Pret'],articles,1180,185,[170,230,140]);p.table('Detalii_comenzi • PK (Nr_comanda,Nr_articol)',['Nr_comanda PK/FK','Nr_articol PK/FK','Cantitatea'],details,60,750,[260,260,200]);TABLES.append(p)
p=Page('Ex. 2 — Tabelele în 3FN / FNBC','Clienti 1:N Comenzi; Comenzi 1:N Detalii_comenzi; Articole 1:N Detalii_comenzi. Datele sunt aceleași ca în enunț.',height=1600)
p.table('Clienti • PK Nr_client',['Nr_client','Nume_client','Adresa'],[[r[2],r[3],r[4]] for r in orders],60,185,[180,260,180]);p.table('Comenzi • PK Nr_comanda',['Nr_comanda','Data','Nr_client FK'],[[r[0],r[1],r[2]] for r in orders],1050,185,[200,230,210]);p.table('Articole • PK Nr_articol',['Nr_articol','Den_articol','Pret'],articles,60,750,[200,270,160]);p.table('Detalii_comenzi • PK (Nr_comanda,Nr_articol)',['Nr_comanda PK/FK','Nr_articol PK/FK','Cantitatea'],details,1050,750,[250,250,170]);TABLES.append(p)
p=Page('Ex. 8 — Citiri, consum și sumele facturilor','F1 și F2 sunt identificatori tehnici ai exemplului. Datele personale și numerele efective ale facturilor nu sunt inventate.',height=1500)
p.table('Citiri • contorul 002342',['Data_citirii','Index'],[['2013-11-28',100],['2013-12-26',105]],60,185,[220,180]);p.table('Segmente observate (aceleași valori în cele două facturi)',['Ordine','Nr_persoane','Nr_zile','Volum m³'],[[1,2,25,'4.464'],[2,2,3,'0.536']],700,185,[150,210,180,200])
p.table('Linii de servicii taxate • procent_inlesnire = 0',['Factura','Segment','Serviciu','Volum m³','Tarif','Suma'],[['F1','25 zile','Canalizare','4.464','3.900','17.41'],['F2','25 zile','Apă','4.464','11.080','49.46'],['F2','3 zile','Apă','0.536','11.080','5.94'],['F2','3 zile','Canalizare','0.536','3.900','2.09']],60,700,[160,180,230,190,190,190]);p.note('Volum total = 105 − 100 = 5.000 m³ = 4.464 + 0.536. Total F1 = 17.41; total F2 = 49.46 + 5.94 + 2.09 = 57.49. În factura F2, cele două servicii din segmentul de 3 zile sunt afișate împreună: 8.03.',60,1250,1800,130);TABLES.append(p)

def save(filename,pages,prefix):
 root=ET.Element('mxfile',host='app.diagrams.net',version='24.7.17',type='device')
 for i,p in enumerate(pages,1):d=ET.SubElement(root,'diagram',id=prefix+str(i),name=p.name);d.append(p.xml());p.png(PRE/(prefix+f'{i:02}.png'))
 ET.indent(root);ET.ElementTree(root).write(ROOT/filename,encoding='utf-8',xml_declaration=True)

if __name__=='__main__':
 save('Lab2_Scheme_Normalizare.drawio',SCHEMAS,'Schema_')
 save('Lab2_Tabele_Exemple.drawio',TABLES,'Tabele_')
 print(f'Created {len(SCHEMAS)} schema pages and {len(TABLES)} table pages.')
