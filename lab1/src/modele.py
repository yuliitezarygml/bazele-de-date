"""Models and original illustrative rows for laboratory 1 (no Git sources)."""
from dataclasses import dataclass,field
@dataclass
class Col:
 name:str
 type:str
 key:str=''
 ref:str=''
 extra:bool=False
 derived:bool=False
@dataclass
class Table:
 name:str
 cols:list
 rows:list
 pos:tuple
@dataclass
class Rel:
 a:str
 b:str
 verb:str
 ca:str='(0,N)'
 cb:str='(1,1)'
 role:str=''
 kind:str='normal'
@dataclass
class Model:
 code:str
 title:str
 tables:list
 rels:list
 note:str
 extras:list=field(default_factory=list)

def C(name,type='INT',key='',ref='',extra=False,derived=False):return Col(name,type,key,ref,extra,derived)
def T(name,cols,rows,pos):return Table(name,cols,rows,pos)
def R(a,b,verb,ca='(0,N)',cb='(1,1)',role='',kind='normal'):return Rel(a,b,verb,ca,cb,role,kind)
SIMPLE=[
Model('1A','1.A — Organizarea academică',[
 T('CATEDRA',[C('id_catedra',key='PK'),C('denumire','VARCHAR(80)'),C('sediu','VARCHAR(80)'),C('telefon','VARCHAR(25)')],[[10,'Informatică','Blocul A','022 111 100']],(0,0)),
 T('ANGAJAT',[C('id_angajat',key='PK'),C('nume','VARCHAR(60)'),C('prenume','VARCHAR(60)'),C('functie','VARCHAR(50)'),C('id_catedra',ref='CATEDRA.id_catedra')],[[101,'Rusu','Ana','Lector',10],[102,'Popa','Ion','Asistent',10],[103,'Lungu','Irina','Secretar',None]],(1,0))],
 [R('CATEDRA','ANGAJAT','Angajează','(1,N)','(0,1)')],
 'Un angajat aparține la cel mult o catedră: FK id_catedra permite NULL. Fiecare catedră are cel puțin un angajat; această regulă se validează suplimentar față de FK.'),
Model('1B','1.B — Managementul sportiv',[
 T('ECHIPA',[C('id_echipa',key='PK'),C('denumire','VARCHAR(80)'),C('oras','VARCHAR(60)'),C('an_fondare','SMALLINT')],[[1,'Steaua Nordului','Bălți',2002],[2,'Orizont','Chișinău',2010]],(0,0)),
 T('JUCATOR',[C('id_jucator',key='PK'),C('nume','VARCHAR(60)'),C('prenume','VARCHAR(60)'),C('pozitie','VARCHAR(40)'),C('id_echipa',ref='ECHIPA.id_echipa')],[[11,'Lungu','Dan','Portar',1],[12,'Rusu','Mihai','Fundaș',1],[13,'Popa','Victor','Atacant',2]],(1,0))],
 [R('ECHIPA','JUCATOR','Legitimează','(1,N)','(1,1)')],
 'Modelul este pentru un singur sezon. Un jucător este legitimat la exact o echipă. Pentru mai multe sezoane se introduce LOT(id_jucator,sezon,id_echipa), cu PK(id_jucator,sezon).'),
Model('1C','1.C — Activitatea editorială',[
 T('AUTOR',[C('id_autor',key='PK'),C('nume','VARCHAR(60)'),C('prenume','VARCHAR(60)'),C('tara','VARCHAR(50)')],[[1,'Rusu','Ana','Moldova'],[2,'Lungu','Dan','România']],(0,0)),
 T('AUTOR_CARTE',[C('id_autor',key='PK/FK',ref='AUTOR.id_autor'),C('id_carte',key='PK/FK',ref='CARTE.id_carte')],[[1,10],[2,10],[1,11]],(1,0)),
 T('CARTE',[C('id_carte',key='PK'),C('titlu','VARCHAR(150)'),C('an_publicare','SMALLINT'),C('limba','VARCHAR(30)')],[[10,'Povești de toamnă',2025,'română'],[11,'Drumul spre casă',2026,'română']],(2,0))],
 [R('AUTOR','AUTOR_CARTE','Contribuie'),R('CARTE','AUTOR_CARTE','Are autori','(1,N)','(1,1)')],
 'Conceptual: AUTOR — Scrie — CARTE este M:N. Relațional: AUTOR_CARTE are PK(id_autor,id_carte), ambele câmpuri FK. Un autor poate exista înaintea primei publicații.'),
Model('1D','1.D — Gestiunea juridică',[
 T('CLIENT',[C('id_client',key='PK'),C('nume_denumire','VARCHAR(150)'),C('adresa','VARCHAR(150)'),C('telefon','VARCHAR(25)')],[[1,'Irina Popa','Chișinău, str. Florilor 8','069 111 222'],[2,'Nord SRL','Bălți, str. Păcii 10','022 333 444']],(0,0)),
 T('CONTRACT',[C('nr_contract','VARCHAR(30)','PK'),C('data_semnare','DATE'),C('obiect','VARCHAR(100)'),C('valoare','DECIMAL(12,2)'),C('id_client',ref='CLIENT.id_client')],[['CTR-2026-01','2026-09-01','Internet',1500,1],['CTR-2026-02','2026-10-01','Mentenanță',2000,1],['CTR-2026-03','2026-10-05','Găzduire',3500,2]],(1,0))],
 [R('CLIENT','CONTRACT','Semnează')],
 'Un client poate semna mai multe contracte, iar un contract este semnat de exact un client. id_client din CONTRACT este FK obligatorie.'),
Model('1E','1.E — Ierarhia de mentorat',[
 T('ANGAJAT',[C('id_angajat',key='PK'),C('nume','VARCHAR(100)'),C('functie','VARCHAR(50)'),C('departament','VARCHAR(60)'),C('id_mentor',ref='ANGAJAT.id_angajat')],[[1,'Ana Rusu','Senior','Dezvoltare',None],[2,'Ion Popa','Junior','Dezvoltare',1],[3,'Dan Lungu','Junior','Dezvoltare',1]],(0,0))],
 [R('ANGAJAT','ANGAJAT','Ghidează','(0,N)','(0,1)',role='mentor / discipol')],
 'Asociere recursivă: aceeași entitate ANGAJAT apare în rolurile Mentor și Discipol. Pentru angajații în formare, id_mentor este obligatoriu; pentru ceilalți poate fi NULL. id_mentor ≠ id_angajat; nu se admit cicluri.')]

CLINIC=Model('2','Sarcina 2 — Clinica veterinară PetCare Plus',[
 T('PERSOANA',[C('id_persoana',key='PK'),C('nume_complet','VARCHAR(100)')],[[1,'Ana Rusu'],[2,'Mihai Popa'],[3,'Irina Lungu']],(1,0)),
 T('PROPRIETAR',[C('id_persoana',key='PK/FK',ref='PERSOANA.id_persoana'),C('nr_client','VARCHAR(20)','UQ'),C('adresa','VARCHAR(150)'),C('telefon','VARCHAR(25)',extra=True)],[[1,'P001','Bălți, str. Păcii 4','069 100 100'],[3,'P003','Bălți, str. Florilor 2','069 300 300']],(0,1)),
 T('MEDIC',[C('id_persoana',key='PK/FK',ref='PERSOANA.id_persoana'),C('nr_legitimatie','VARCHAR(20)','UQ'),C('specializare','VARCHAR(80)')],[[2,'V101','Chirurgie'],[3,'V102','Medicină generală']],(2,1)),
 T('ANIMAL',[C('id_animal',key='PK'),C('nume','VARCHAR(50)'),C('rasa','VARCHAR(60)'),C('varsta_ani','SMALLINT'),C('microcip','VARCHAR(25)','UQ',extra=True),C('id_proprietar',ref='PROPRIETAR.id_persoana')],[[101,'Max','Labrador',4,'MD000101',1],[102,'Max','Bichon',2,None,3]],(0,2)),
 T('CONSULTATIE',[C('id_consultatie',key='PK'),C('id_animal',ref='ANIMAL.id_animal'),C('id_medic',ref='MEDIC.id_persoana'),C('data_ora','DATETIME'),C('diagnostic','VARCHAR(150)'),C('observatii','VARCHAR(200)'),C('cost_total','DECIMAL(10,2)'),C('status','VARCHAR(20)',extra=True)],[[1001,101,2,'2026-10-01 09:00','Otită','Control în 7 zile',350,'efectuată'],[1002,101,3,'2026-10-08 10:30','Vindecat','Fără tratament',200,'efectuată']],(2,2))],
 [R('PERSOANA','PROPRIETAR','Este proprietar','(0,1)','(1,1)',kind='isa'),R('PERSOANA','MEDIC','Este medic','(0,1)','(1,1)',kind='isa'),R('PROPRIETAR','ANIMAL','Deține'),R('ANIMAL','CONSULTATIE','Are vizite'),R('MEDIC','CONSULTATIE','Efectuează')],
 'Generalizare PERSOANA ← PROPRIETAR/MEDIC: totală, suprapusă (o persoană poate avea ambele roluri). ANIMAL–MEDIC este M:N în timp, rezolvat prin CONSULTATIE. Toate asocierile obișnuite sunt binare.',
 [('telefon','Contactarea rapidă a proprietarului.'),('microcip','Identificarea sigură a animalului; unic când există, NULL permis.'),('status','Distinge vizitele programate, efectuate și anulate.')])

LOGISTICS=Model('3','Sarcina 3 — Global Express',[
 T('CLIENT',[C('id_client',key='PK'),C('nume_denumire','VARCHAR(150)'),C('strada','VARCHAR(100)'),C('numar','VARCHAR(10)'),C('oras','VARCHAR(60)'),C('tara','VARCHAR(50)'),C('telefon','VARCHAR(25)'),C('tip_client','VARCHAR(10)'),C('email','VARCHAR(100)',extra=True)],[[1,'Ana Rusu','Păcii','4','Chișinău','Moldova','069 111 111','fizică','ana@example.test'],[2,'Nord SRL','Unirii','10','Iași','România','0740 111 111','juridică','nord@example.test']],(1,0)),
 T('COLET',[C('tracking_id','VARCHAR(30)','PK'),C('id_expeditor',ref='CLIENT.id_client'),C('id_destinatar',ref='CLIENT.id_client'),C('id_ruta',ref='RUTA.id_ruta'),C('greutate_kg','DECIMAL(8,3)'),C('descriere','VARCHAR(150)'),C('valoare_declarata','DECIMAL(12,2)'),C('data_preluare','DATETIME'),C('status','VARCHAR(25)',extra=True)],[['GE0001',1,2,10,'2.500','Documente',100,'2026-10-02 08:00','în tranzit']],(0,1)),
 T('RUTA',[C('id_ruta',key='PK'),C('denumire','VARCHAR(120)')],[[10,'Chișinău — Iași']],(1,1)),
 T('RUTA_SEGMENT',[C('id_ruta',key='PK/FK',ref='RUTA.id_ruta'),C('pozitie',key='PK'),C('id_segment',ref='SEGMENT.id_segment')],[[10,1,501],[10,2,502]],(2,1)),
 T('SCANARE',[C('id_scanare',key='PK'),C('tracking_id','VARCHAR(30)',ref='COLET.tracking_id'),C('id_punct',ref='PUNCT_TRANZIT.id_punct'),C('id_angajat',ref='ANGAJAT.id_angajat'),C('moment','DATETIME'),C('tip','VARCHAR(10)')],[[1,'GE0001',1,7,'2026-10-02 08:00','INTRARE'],[2,'GE0001',1,7,'2026-10-02 09:00','IESIRE'],[3,'GE0001',2,7,'2026-10-02 12:00','INTRARE'],[4,'GE0001',2,7,'2026-10-02 12:30','IESIRE']],(0,2)),
 T('PUNCT_TRANZIT',[C('id_punct',key='PK'),C('denumire','VARCHAR(100)'),C('localitate','VARCHAR(60)')],[[1,'Depozit Chișinău','Chișinău'],[2,'Hub Ungheni','Ungheni'],[3,'Centru Iași','Iași']],(1,2)),
 T('SEGMENT',[C('id_segment',key='PK'),C('id_plecare',ref='PUNCT_TRANZIT.id_punct'),C('id_sosire',ref='PUNCT_TRANZIT.id_punct')],[[501,1,2],[502,2,3]],(2,2)),
 T('ANGAJAT',[C('id_angajat',key='PK'),C('nume','VARCHAR(100)'),C('functie','VARCHAR(50)',extra=True)],[[7,'Ion Popa','Operator scanare']],(0,3))],
 [R('CLIENT','COLET','Expediază',role='expeditor'),R('CLIENT','COLET','Primește',role='destinatar'),R('RUTA','COLET','Este atribuită'),R('RUTA','RUTA_SEGMENT','Conține în ordine','(1,N)'),R('SEGMENT','RUTA_SEGMENT','Este inclus'),R('PUNCT_TRANZIT','SEGMENT','Este plecare',role='plecare'),R('PUNCT_TRANZIT','SEGMENT','Este sosire',role='sosire'),R('COLET','SCANARE','Este scanat'),R('PUNCT_TRANZIT','SCANARE','Înregistrează'),R('ANGAJAT','SCANARE','Efectuează')],
 'CLIENT → persoană fizică / persoană juridică: totală, disjunctă; mapare într-un tabel cu discriminator tip_client. SCANARE materializează evenimentul dintre colet, punct și angajat. Segmentele unei rute trebuie să fie consecutive; intrările și ieșirile se păstrează separat.',
 [('email','Transmiterea notificărilor clientului.'),('status','Urmărirea stării curente a coletului.'),('functie','Identificarea responsabilității angajatului.')])

AUCTION=Model('4','Sarcina 4 — Colectioneri.md',[
 T('MEMBRU',[C('email','VARCHAR(100)','PK'),C('parola_hash','VARCHAR(255)'),C('data_inregistrare','DATE')],[['ana@example.test','[hash demonstrativ A]','2026-01-01'],['ion@example.test','[hash demonstrativ I]','2026-01-02']],(1,0)),
 T('CUMPARATOR',[C('email','VARCHAR(100)','PK/FK','MEMBRU.email'),C('adresa_livrare','VARCHAR(150)'),C('limita_credit','DECIMAL(12,2)')],[['ana@example.test','Bălți, str. Păcii 4',10000],['ion@example.test','Chișinău, str. Florilor 5',5000]],(0,1)),
 T('VANZATOR',[C('email','VARCHAR(100)','PK/FK','MEMBRU.email'),C('iban','VARCHAR(34)'),C('telefon_asistenta','VARCHAR(25)'),C('rating_1_5','DECIMAL(3,2)',derived=True)],[['ion@example.test','MD24AG000225100013104168','069 222 222','4.56']],(2,1)),
 T('OFERTA',[C('id_oferta',key='PK'),C('id_licitatie',ref='LICITATIE.id_licitatie'),C('email_cumparator','VARCHAR(100)',ref='CUMPARATOR.email'),C('suma','DECIMAL(12,2)'),C('moment','DATETIME')],[[11,100,'ana@example.test',1100,'2026-10-05 12:00:01'],[12,100,'ana@example.test',1250,'2026-10-05 12:05:02']],(0,2)),
 T('LICITATIE',[C('id_licitatie',key='PK'),C('id_obiect',ref='OBIECT.id_obiect'),C('data_start','DATETIME'),C('data_sfarsit','DATETIME'),C('stare','VARCHAR(20)',extra=True),C('pas_minim','DECIMAL(10,2)',extra=True)],[[100,501,'2026-10-01 12:00','2026-10-06 12:00','finalizată',50]],(1,2)),
 T('OBIECT',[C('id_obiect',key='PK'),C('titlu','VARCHAR(100)'),C('descriere','VARCHAR(150)'),C('pret_pornire','DECIMAL(12,2)'),C('email_vanzator','VARCHAR(100)',ref='VANZATOR.email'),C('id_categorie',ref='CATEGORIE.id_categorie'),C('moneda','CHAR(3)',extra=True)],[[501,'Monedă veche','Stare bună',1000,'ion@example.test',1,'MDL']],(2,2)),
 T('ADJUDECARE',[C('id_licitatie',key='PK/FK',ref='LICITATIE.id_licitatie'),C('id_oferta_castigatoare',key='UQ/FK',ref='OFERTA.id_oferta'),C('data_finalizare','DATETIME')],[[100,12,'2026-10-07 15:00']],(0,3)),
 T('FEEDBACK',[C('id_licitatie',key='PK/FK',ref='ADJUDECARE.id_licitatie'),C('nota_1_10','SMALLINT'),C('comentariu','VARCHAR(200)')],[[100,9,'Livrare rapidă.']],(1,3)),
 T('CATEGORIE',[C('id_categorie',key='PK'),C('denumire','VARCHAR(80)'),C('comision_procente','DECIMAL(5,2)'),C('durata_ore',type='INT')],[[1,'Numismatică',5,120]],(2,3))],
 [R('MEMBRU','CUMPARATOR','Este cumpărător','(0,1)','(1,1)',kind='isa'),R('MEMBRU','VANZATOR','Este vânzător','(0,1)','(1,1)',kind='isa'),R('CUMPARATOR','OFERTA','Plasează'),R('VANZATOR','OBIECT','Listează'),R('CATEGORIE','OBIECT','Clasifică'),R('OBIECT','LICITATIE','Este licitat'),R('LICITATIE','OFERTA','Primește'),R('LICITATIE','ADJUDECARE','Se încheie prin','(0,1)','(1,1)'),R('OFERTA','ADJUDECARE','Câștigă','(0,1)','(1,1)'),R('ADJUDECARE','FEEDBACK','Primește','(0,1)','(1,1)')],
 'MEMBRU → CUMPARATOR/VANZATOR: totală, suprapusă. Se păstrează toate ofertele; la sume egale câștigă oferta anterioară (apoi id_oferta). Feedback unic, numai de la câștigător, după finalizare. Rating derivat = 1 + 4×(AVG(nota)−1)/9; fără feedback este NULL.',
 [('moneda','Clarifică moneda prețului și a ofertelor.'),('pas_minim','Controlează creșterea minimă a ofertelor.'),('stare','Distinge licitațiile active, încheiate și finalizate.')])

AUTO=Model('5','Sarcina 5 — Auto-Star',[
 T('MARCA',[C('id_marca',key='PK'),C('nume','VARCHAR(50)','UQ'),C('tara','VARCHAR(50)')],[[1,'Toyota','Japonia']],(0,0)),
 T('MODEL',[C('cod_model','VARCHAR(20)','PK'),C('id_marca',ref='MARCA.id_marca'),C('nume','VARCHAR(60)'),C('pret_baza','DECIMAL(12,2)')],[['COR',1,'Corolla',20000]],(1,0)),
 T('DOTARE',[C('cod_dotare','VARCHAR(20)','PK'),C('denumire','VARCHAR(80)'),C('cost_suplimentar','DECIMAL(10,2)')],[['D1','Trapă panoramică',1000],['D2','Scaune din piele',1500]],(2,0)),
 T('MOTOR_TERMIC',[C('vin','CHAR(17)','PK/FK','VEHICUL.vin'),C('capacitate_cm3','SMALLINT')],[['JTDBR32E720000001',1800]],(0,1)),
 T('VEHICUL',[C('vin','CHAR(17)','PK'),C('cod_model','VARCHAR(20)',ref='MODEL.cod_model'),C('culoare','VARCHAR(30)'),C('an_fabricatie','SMALLINT'),C('kilometri','INT'),C('data_expirare_itp','DATE',extra=True),C('pret_lista_total','DECIMAL(12,2)',derived=True)],[['JTDBR32E720000001','COR','Alb',2026,12,'2029-10-01',22500]],(1,1)),
 T('VEHICUL_DOTARE',[C('vin','CHAR(17)','PK/FK','VEHICUL.vin'),C('cod_dotare','VARCHAR(20)','PK/FK','DOTARE.cod_dotare')],[['JTDBR32E720000001','D1'],['JTDBR32E720000001','D2']],(2,1)),
 T('MOTOR_ELECTRIC',[C('vin','CHAR(17)','PK/FK','VEHICUL.vin'),C('capacitate_baterie_kwh','DECIMAL(6,2)',extra=True)],[['JTDBR32E720000001','1.80']],(0,2)),
 T('CUSTODIE',[C('id_custodie',key='PK'),C('vin','CHAR(17)',ref='VEHICUL.vin'),C('cod_dealer',ref='DEALER.cod_dealer'),C('data_intrare','DATE'),C('data_iesire','DATE')],[[1,'JTDBR32E720000001',10,'2026-10-01','2026-10-10']],(1,2)),
 T('DEALER',[C('cod_dealer',key='PK'),C('denumire','VARCHAR(100)'),C('adresa','VARCHAR(150)')],[[10,'Auto-Star Centru','Chișinău, str. Industrială 10']],(2,2)),
 T('CLIENT',[C('cnp','VARCHAR(20)','PK'),C('nume','VARCHAR(60)'),C('prenume','VARCHAR(60)'),C('serie_buletin','VARCHAR(5)'),C('numar_buletin','VARCHAR(15)'),C('email','VARCHAR(100)',extra=True)],[['2000000000001','Rusu','Ana','AB','123456','ana@example.test']],(0,3)),
 T('VANZARE',[C('id_vanzare',key='PK'),C('vin','CHAR(17)','UQ/FK','VEHICUL.vin'),C('id_custodie',ref='CUSTODIE.id_custodie'),C('cnp','VARCHAR(20)',ref='CLIENT.cnp'),C('data_facturare','DATE'),C('garantie_luni','SMALLINT'),C('pret_final_negociat','DECIMAL(12,2)')],[[500,'JTDBR32E720000001',1,'2000000000001','2026-10-10',36,21500]],(1,3))],
 [R('MARCA','MODEL','Definește'),R('MODEL','VEHICUL','Descrie'),R('VEHICUL','MOTOR_TERMIC','Are motor termic','(0,1)','(1,1)',kind='isa'),R('VEHICUL','MOTOR_ELECTRIC','Are motor electric','(0,1)','(1,1)',kind='isa'),R('VEHICUL','VEHICUL_DOTARE','Este echipat'),R('DOTARE','VEHICUL_DOTARE','Este instalată'),R('VEHICUL','CUSTODIE','Trece prin','(1,N)'),R('DEALER','CUSTODIE','Păstrează'),R('CUSTODIE','VANZARE','Finalizează','(0,1)'),R('CLIENT','VANZARE','Cumpără'),R('VEHICUL','VANZARE','Este vândut','(0,1)')],
 'VEHICUL → MOTOR_TERMIC/MOTOR_ELECTRIC: totală, suprapusă; un hibrid este în ambele subclase. CUSTODIE păstrează istoricul dealerilor. Prima vânzare: VIN este unic în VANZARE. Preț de listă = preț de bază + suma dotărilor; prețul negociat se păstrează distinct.',
 [('capacitate_baterie_kwh','Descrie autonomia potențială a vehiculului electric/hibrid.'),('email','Permite notificarea clientului.'),('data_expirare_itp','Permite urmărirea valabilității inspecției.')])
MODELS=SIMPLE+[CLINIC,LOGISTICS,AUCTION,AUTO]

# The user requested ordinary relationships, without ISA diagrams.
# Keep the company/member roles as profiles; veterinary identities are independent.
CLINIC.tables=[t for t in CLINIC.tables if t.name!='PERSOANA']
for t in CLINIC.tables:
 if t.name=='PROPRIETAR':
  t.cols=[C('id_proprietar',key='PK'),C('nume_complet','VARCHAR(100)'),C('adresa','VARCHAR(150)'),C('telefon','VARCHAR(25)',extra=True)]
  t.rows=[[1,'Ana Rusu','Bălți, str. Păcii 4','069 100 100'],[3,'Irina Lungu','Bălți, str. Florilor 2','069 300 300']];t.pos=(0,0)
 elif t.name=='MEDIC':
  t.cols=[C('nr_legitimatie','VARCHAR(20)','PK'),C('nume_complet','VARCHAR(100)'),C('specializare','VARCHAR(80)')]
  t.rows=[['V101','Mihai Popa','Chirurgie'],['V102','Irina Lungu','Medicină generală']];t.pos=(2,1)
 elif t.name=='ANIMAL':
  t.pos=(1,0)
  next(c for c in t.cols if c.name=='id_proprietar').ref='PROPRIETAR.id_proprietar'
 elif t.name=='CONSULTATIE':
  t.pos=(1,1);next(c for c in t.cols if c.name=='id_medic').type='VARCHAR(20)';next(c for c in t.cols if c.name=='id_medic').ref='MEDIC.nr_legitimatie'
  for row in t.rows:row[2]='V101' if row[2]==2 else 'V102'
CLINIC.rels=[r for r in CLINIC.rels if r.kind!='isa']
CLINIC.note='PROPRIETAR 1:N ANIMAL; ANIMAL 1:N CONSULTATIE; MEDIC 1:N CONSULTATIE. Un animal are un identificator propriu; numele nu este unic. Consultațiile păstrează istoricul pacientului, data/ora, diagnosticul, observațiile și costul. Asocierile sunt binare.'
LOGISTICS.note='Un client poate avea ambele roluri: expeditor și destinatar. Tipul fizică/juridică este atribut al clientului. SCANARE materializează evenimentul dintre colet, punct și angajat. Segmentele unei rute sunt ordonate și consecutive; intrările și ieșirile sunt evenimente separate.'
for r in AUCTION.rels:
 if r.kind=='isa':r.kind='normal';r.verb='Are profil de '+('cumpărător' if r.b=='CUMPARATOR' else 'vânzător')
AUCTION.note='Un membru poate avea profil de cumpărător și/sau vânzător; fiecare profil referă exact un membru. Se păstrează toate ofertele. Câștigă suma maximă, apoi momentul anterior și id_oferta. Oferta câștigătoare aparține licitației. Feedback unic, numai de la câștigător, după finalizare. Rating = 1 + 4×(AVG(nota)−1)/9; fără feedback este NULL.'
AUTO.tables=[t for t in AUTO.tables if t.name not in ('MOTOR_TERMIC','MOTOR_ELECTRIC')]
for t in AUTO.tables:
 if t.name=='VEHICUL':
  t.cols=[C('vin','CHAR(17)','PK'),C('cod_model','VARCHAR(20)',ref='MODEL.cod_model'),C('culoare','VARCHAR(30)'),C('an_fabricatie','SMALLINT'),C('capacitate_cm3','SMALLINT'),C('kilometri','INT'),C('capacitate_baterie_kwh','DECIMAL(6,2)',extra=True),C('data_expirare_itp','DATE',extra=True),C('pret_lista_total','DECIMAL(12,2)',derived=True)]
  t.rows=[['JTDBR32E720000001','COR','Alb',2026,1800,12,'1.80','2029-10-01',22500]]
AUTO.rels=[r for r in AUTO.rels if r.kind!='isa']
AUTO.note='Fiecare model aparține unei mărci. Vehiculul are VIN unic de 17 caractere. CUSTODIE păstrează istoricul dealerilor. VIN este unic în VANZARE (prima vânzare). Preț de listă = preț de bază + suma dotărilor; prețul negociat rămâne distinct. Capacitatea bateriei poate fi NULL pentru un vehicul fără baterie de tracțiune.'
MODELS=SIMPLE+[CLINIC,LOGISTICS,AUCTION,AUTO]
