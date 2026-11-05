"""Editable draw.io renderer matching the supplied table and Chen examples."""
from pathlib import Path
from copy import deepcopy
import xml.etree.ElementTree as E
from html import escape
import math
from PIL import Image,ImageDraw,ImageFont
from modele import *
from routing import route_all
ROOT=Path(__file__).resolve().parents[1];PRE=ROOT/'previzualizari';PRE.mkdir(exist_ok=True)
MONO='/System/Library/Fonts/Menlo.ttc';SANS='/System/Library/Fonts/Supplemental/Arial.ttf';BOLD='/System/Library/Fonts/Supplemental/Arial Bold.ttf'
INK='#334155';BORDER='#cbd5e1';PALETTE=['#0f766e','#15803d','#6d28d9','#1d4ed8','#b45309','#0369a1']
def font(sz=16,mono=False,bold=False):return ImageFont.truetype(MONO if mono else BOLD if bold else SANS,sz,index=1 if mono and bold else 0)
def wrap(value,width,sz=16,mono=False,bold=False):
 out=[]
 for para in str(value).split('\n'):
  line=''
  for word in para.split():
   nxt=(line+' '+word).strip()
   if font(sz,mono,bold).getlength(nxt)>width and line:out.append(line);line=word
   else:line=nxt
  out.append(line)
 return out

class Scene:
 def __init__(self,title,subtitle='',width=2400,height=1600):self.title=title;self.subtitle=subtitle;self.width=width;self.height=height;self.shapes=[];self.edges=[];self.labels=[]
 def add(self,id,value,x,y,w,h,kind='rect',fill='white',stroke=BORDER,sz=17,bold=False,color=INK,mono=False,parent='1',html=None,**kw):
  s=dict(id=id,value=str(value),x=x,y=y,w=w,h=h,kind=kind,fill=fill,stroke=stroke,sz=sz,bold=bold,color=color,mono=mono,parent=parent,html=html);s.update(kw);self.shapes.append(s);return s
 def edge(self,id,pts,source=None,target=None,color='#334155',dashed=False,arrow=False,width=2):self.edges.append(dict(id=id,pts=pts,source=source,target=target,color=color,dashed=dashed,arrow=arrow,width=width))
 def label(self,id,value,x,y,w=230,h=40,color='#0f766e',border=False,sz=16):return self.add(id,value,x,y,w,h,'text','white',color if border else 'none',sz,True,color,align='center')
 def absolute(self,s):
  x,y=s['x'],s['y'];byid={p['id']:p for p in self.shapes};p=s['parent']
  while p!='1':n=byid[p];x+=n['x'];y+=n['y'];p=n['parent']
  return x,y
 def xml(self):
  m=E.Element('mxGraphModel',grid='1',gridSize='10',guides='1',connect='1',tooltips='1',page='0',pageScale='1',pageWidth=str(self.width),pageHeight=str(self.height),background='#ffffff');r=E.SubElement(m,'root');E.SubElement(r,'mxCell',id='0');E.SubElement(r,'mxCell',id='1',parent='0')
  byid={s['id']:s for s in self.shapes}
  for e in self.edges:
   pts=e['pts'];style=f'edgeStyle=none;rounded=0;html=1;endArrow={"block" if e["arrow"] else "none"};endSize=8;strokeWidth={e["width"]};strokeColor={e["color"]};dashed={int(e["dashed"])};'
   for attr,prefix,point in [('source','exit',pts[0]),('target','entry',pts[-1])]:
    if e[attr]:
     s=byid[e[attr]];x,y=self.absolute(s);style+=f'{prefix}X={(point[0]-x)/s["w"]};{prefix}Y={(point[1]-y)/s["h"]};{prefix}Perimeter=0;'
   c=E.SubElement(r,'mxCell',id=e['id'],value='',style=style,edge='1',parent='1')
   for a in ('source','target'):
    if e[a]:c.set(a,e[a])
   g=E.SubElement(c,'mxGeometry',relative='1',**{'as':'geometry'});E.SubElement(g,'mxPoint',x=str(pts[0][0]),y=str(pts[0][1]),**{'as':'sourcePoint'});E.SubElement(g,'mxPoint',x=str(pts[-1][0]),y=str(pts[-1][1]),**{'as':'targetPoint'});arr=E.SubElement(g,'Array',**{'as':'points'})
   for x,y in pts[1:-1]:E.SubElement(arr,'mxPoint',x=str(x),y=str(y))
  for s in self.shapes:
   style={'rect':'rounded=0;','round':'rounded=1;arcSize=8;','ellipse':'ellipse;','diamond':'rhombus;','text':'text;'}[s['kind']]
   style+=f'html=1;whiteSpace=wrap;fillColor={s["fill"]};strokeColor={s["stroke"]};fontColor={s["color"]};fontSize={s["sz"]};fontStyle={int(s["bold"])};fontFamily={"Menlo" if s["mono"] else "Arial"};align={s.get("align","center")};verticalAlign=middle;spacing=6;strokeWidth={s.get("line_width",1)};shadow={int(s.get("shadow",False))};dashed={int(s.get("dashed",False))};'
   value=s['html'] if s['html'] is not None else escape(s['value']).replace('\n','<br>')
   if s.get('underline') and s['html'] is None:value='<u>'+value+'</u>'
   c=E.SubElement(r,'mxCell',id=s['id'],value=value,style=style,vertex='1',parent=s['parent']);E.SubElement(c,'mxGeometry',x=str(s['x']),y=str(s['y']),width=str(s['w']),height=str(s['h']),**{'as':'geometry'})
  return m
 def png(self,path,maxwidth=2600):
  im=Image.new('RGB',(math.ceil(self.width),math.ceil(self.height)),'#ffffff');d=ImageDraw.Draw(im)
  # The same grid visible in the provided draw.io examples.
  for x in range(0,int(self.width),20):d.line((x,0,x,self.height),fill='#f2f4f7')
  for y in range(0,int(self.height),20):d.line((0,y,self.width,y),fill='#f2f4f7')
  def txt(value,x,y,w,h,sz=17,color=INK,bold=False,mono=False,align='center',underline=False):
   lines=wrap(value,w-16,sz,mono,bold);lh=sz+6;yy=y+(h-lh*len(lines))/2
   for line in lines:
    tw=font(sz,mono,bold).getlength(line);xx=x+8 if align=='left' else x+(w-tw)/2;d.text((xx,yy),line,font=font(sz,mono,bold),fill=color)
    if underline:d.line((xx,yy+sz+1,xx+tw,yy+sz+1),fill=color,width=1)
    yy+=lh
  for e in self.edges:
   if e['dashed']:
    for a,b in zip(e['pts'],e['pts'][1:]):
     length=math.dist(a,b)
     if not length:continue
     for off in range(0,int(length),16):
      t=off/length;u=min((off+9)/length,1);d.line((a[0]+(b[0]-a[0])*t,a[1]+(b[1]-a[1])*t,a[0]+(b[0]-a[0])*u,a[1]+(b[1]-a[1])*u),fill=e['color'],width=e['width'])
   else:d.line(e['pts'],fill=e['color'],width=e['width'])
   if e['arrow']:
    a,b=e['pts'][-2:];ang=math.atan2(b[1]-a[1],b[0]-a[0]);d.polygon([b,(b[0]-12*math.cos(ang-.4),b[1]-12*math.sin(ang-.4)),(b[0]-12*math.cos(ang+.4),b[1]-12*math.sin(ang+.4))],fill=e['color'])
  for s in self.shapes:
   x,y=self.absolute(s);w,h=s['w'],s['h'];box=(x,y,x+w,y+h);outline=None if s['stroke']=='none' else s['stroke']
   if s.get('shadow'):d.rounded_rectangle((x+4,y+5,x+w+4,y+h+5),radius=12,fill='#d8dee5')
   if s['kind']=='round':d.rounded_rectangle(box,radius=12,fill=s['fill'],outline=outline,width=s.get('line_width',1))
   elif s['kind']=='ellipse':
    d.ellipse(box,fill=s['fill'],outline=None if s.get('dashed') else outline,width=s.get('line_width',1))
    if s.get('dashed'):
     for deg in range(0,360,18):d.arc(box,deg,deg+9,fill=outline,width=2)
   elif s['kind']=='diamond':d.polygon([(x+w/2,y),(x+w,y+h/2),(x+w/2,y+h),(x,y+h/2)],fill=s['fill'],outline=outline,width=2)
   else:d.rectangle(box,fill=s['fill'],outline=outline,width=s.get('line_width',1))
   if s.get('column'):
    col=s['column'];key=col.key or ('FK' if col.ref else '');name=(f'[{key}] ' if key else '')+col.name
    txt(name,x+4,y+3,w-8,30,16,'#b45309' if 'PK' in key else '#2563eb' if col.ref else '#404040',True,True,'left','PK' in key)
    txt(col.type,x+4,y+32,w-8,25,14,'#64748b',False,True,'left')
    if col.derived:txt('calculat',x+4,y+55,w-8,18,12,'#64748b',False,True,'left')
   else:txt(s['value'],x,y,w,h,s['sz'],s['color'],s['bold'],s['mono'],s.get('align','center'),s.get('underline',False))
  if self.width>maxwidth:im=im.resize((maxwidth,round(self.height*maxwidth/self.width)),Image.Resampling.LANCZOS)
  im.save(path)

def header(scene,title,subtitle):
 scene.add('page_title',title,50,30,scene.width-100,58,'round','#1e293b','#0f172a',25,True,'white',shadow=True)
 scene.add('legend',subtitle,50,105,scene.width-100,55,'text','white','none',17,False,INK)
def footer(scene,model,y):
 text=model.note
 if model.extras:text+='\nATRIBUTE SUPLIMENTARE: '+' • '.join(name+': '+why for name,why in model.extras)
 scene.add('note',text,50,y,scene.width-100,145,'round','#f8fafc','#cbd5e1',17,False,INK,align='left')

def widths(table):
 vals=[]
 for i,col in enumerate(table.cols):
  key=col.key or ('FK' if col.ref else '');name=(f'[{key}] ' if key else '')+col.name
  vals.append(max(125,math.ceil(max(font(16,True,True).getlength(name)+24,font(14,True).getlength(col.type)+24,*[min(410,font(16,True).getlength('NULL' if r[i] is None else str(r[i])))+24 for r in table.rows]))))
 return vals

def add_table(scene,table,x,y,color):
 ws=widths(table);w=sum(ws)+24;rh=[]
 for row in table.rows:rh.append(max(38,max(len(wrap('NULL' if v is None else str(v),cw-16,16,True)) for v,cw in zip(row,ws))*23+14))
 hh=80 if any(c.derived for c in table.cols) else 66;h=12+44+hh+sum(rh)+20;id='t_'+table.name
 container=scene.add(id,'',x,y,w,h,'round','white','#94a3b8',line_width=2,shadow=True)
 scene.add(id+'_title','TABEL: '+table.name,12,12,w-24,44,'round',color,color,22,True,'white',True,parent=id)
 xx=12
 for j,(c,cw) in enumerate(zip(table.cols,ws)):
  key=c.key or ('FK' if c.ref else '');haspk='PK' in key;fill='#fff9c4' if haspk else '#eff6ff' if c.ref else '#ecfdf5' if c.extra else '#f8fafc'
  label=(f'[{key}] ' if key else '')+c.name;keycolor='#b45309' if haspk else '#2563eb' if c.ref else '#404040'
  html=f'<div style="text-align:left;font-family:Menlo,monospace;padding:4px"><b style="color:{keycolor};'+('text-decoration:underline;' if haspk else '')+f'">{escape(label)}</b><br><span style="font-size:14px;color:#64748b">{escape(c.type)}</span>'
  if c.derived:html+='<br><i style="font-size:12px;color:#64748b">calculat</i>'
  html+='</div>'
  scene.add(id+'_col'+str(j),label+'\n'+c.type,xx,56,cw,hh,fill=fill,mono=True,bold=True,parent=id,html=html,column=c)
  yy=56+hh
  for ri,row in enumerate(table.rows):
   scene.add(id+f'_r{ri}c{j}','NULL' if row[j] is None else row[j],xx,yy,cw,rh[ri],fill='#ffffff' if ri%2==0 else '#f8fafc',sz=16,mono=True,parent=id,align='left',color='#64748b' if row[j] is None else '#404040');yy+=rh[ri]
  xx+=cw
 return container

def choose_label(scene,pts,w=235,h=38,ignore_edge=None):
 candidates=[]
 for a,b in zip(pts,pts[1:]):
  for t in [.5,.3,.7,.15,.85]:
   x=a[0]+t*(b[0]-a[0]);y=a[1]+t*(b[1]-a[1]);box=(x-w/2,y-h/2,x+w/2,y+h/2)
   hits=0
   for s in scene.shapes:
    if s['parent']!='1' or s['id'] in ('page_title','legend','note'):continue
    sx,sy=s['x'],s['y'];sw,sh=s['w'],s['h']
    if box[0]<sx+sw+8 and box[2]>sx-8 and box[1]<sy+sh+8 and box[3]>sy-8:hits+=1
   for e in scene.edges:
    if e['id']==ignore_edge:continue
    for u,v in zip(e['pts'],e['pts'][1:]):
     if u[0]==v[0] and box[0]-8<u[0]<box[2]+8 and max(min(u[1],v[1]),box[1]-8)<min(max(u[1],v[1]),box[3]+8):hits+=1
     elif u[1]==v[1] and box[1]-8<u[1]<box[3]+8 and max(min(u[0],v[0]),box[0]-8)<min(max(u[0],v[0]),box[2]+8):hits+=1
   candidates.append((hits,abs(t-.5),x-w/2,y-h/2))
 return min(candidates)[2:]

def table_scene(model):
 sizes={t.name:(sum(widths(t))+24,12+44+(80 if any(c.derived for c in t.cols) else 66)+sum(max(38,max(len(wrap('NULL' if v is None else str(v),cw-16,16,True)) for v,cw in zip(row,widths(t)))*23+14) for row in t.rows)+20) for t in model.tables}
 nc=max(t.pos[0] for t in model.tables)+1;nr=max(t.pos[1] for t in model.tables)+1
 colw=[max(sizes[t.name][0] for t in model.tables if t.pos[0]==j) for j in range(nc)];rowh=[max(sizes[t.name][1] for t in model.tables if t.pos[1]==j) for j in range(nr)]
 xs=[320];ys=[320]
 for w in colw[:-1]:xs.append(xs[-1]+w+900)
 for h in rowh[:-1]:ys.append(ys[-1]+h+600)
 width=max(1800,xs[-1]+colw[-1]+900);height=ys[-1]+rowh[-1]+650
 scene=Scene(model.title+' — Tabele relaționale',width=width,height=height)
 nodes={}
 for i,t in enumerate(model.tables):nodes[t.name]=add_table(scene,t,xs[t.pos[0]],ys[t.pos[1]],PALETTE[i%len(PALETTE)])
 routed=route_all(nodes,model.rels,width,height)
 for i,(r,pts) in enumerate(routed):
  a,b=nodes[r.a],nodes[r.b]
  scene.edge('relation'+str(i),pts,a['id'],b['id'],color='#0f766e')
 for i,(r,pts) in enumerate(routed):
  label=('1 : 1' if r.ca.endswith('1)') and r.cb.endswith('1)') else '1 : N')+' ('+r.verb.lower()+')'
  lx,ly=choose_label(scene,pts,ignore_edge='relation'+str(i));scene.label('label'+str(i),label,lx,ly,235,38,border=True,sz=16)
 header(scene,scene.title,'[PK] cheie primară • [FK] cheie străină • [PK/FK] cheie primară și străină • [UQ] unic • verde pal = atribut suplimentar • date fictive')
 footer(scene,model,height-180)
 return scene

# Classic ER/Chen layout: attributes are real ellipses and associations real diamonds.
def chen_model(model):
 ts=deepcopy(model.tables);rs=deepcopy(model.rels)
 if model.code=='1C':
  ts=[ts[0],ts[2]];ts[1].pos=(1,0);rs=[R('AUTOR','CARTE','Scrie','(0,N)','(1,N)')]
 if model.code=='1E':
  ts=[deepcopy(ts[0]),deepcopy(ts[0])];ts[0].name='MENTOR';ts[1].name='DISCIPOL';ts[1].pos=(1,0)
  ts[0].cols=[c for c in ts[0].cols if c.name!='id_mentor'];rs=[R('MENTOR','DISCIPOL','Ghidează','(0,N)','(0,1)',role='Aceeași entitate ANGAJAT')]
 nc=max(t.pos[0] for t in ts)+1;nr=max(t.pos[1] for t in ts)+1
 scene=Scene(model.title+' — Diagrama ER / Chen',width=max(2200,nc*1400+140),height=nr*1100+510)
 nodes={};base={}
 for t in ts:
  bx=70+t.pos[0]*1400;by=320+t.pos[1]*1100;x=bx+410;y=by+330
  node=scene.add('e_'+t.name,t.name,x,y,240,70,fill='#dbeafe',stroke='#6c8ebf',sz=21,bold=True,shadow=True,line_width=2);nodes[t.name]=node;base[t.name]=(bx,by)
  slots=[(380,70),(20,100),(0,235),(20,480),(380,650),(740,480),(760,235),(740,100),(740,-100),(0,-100)]
  for j,col in enumerate(t.cols):
   sx,sy=slots[j];sx+=bx;sy+=by;haspk='PK' in col.key;isfk=bool(col.ref);fill='#fff6bf' if haspk and not isfk else '#eff6ff' if isfk else '#ecfdf5' if col.extra else '#f5f5f5';stroke='#d79b00' if haspk and not isfk else '#2563eb' if isfk else '#64748b';label=col.name
   attr=scene.add(t.name+'_a'+str(j),label,sx,sy,300,60,'ellipse',fill,stroke,17,False,INK,underline=haspk,dashed=col.derived,line_width=2 if haspk else 1)
   ac=(sx+150,sy+30);ec=(x+120,y+35)
   if abs(ac[0]-ec[0])<40:ep=(ec[0],y if ac[1]<ec[1] else y+70);ap=(ac[0],sy+60 if ac[1]<ec[1] else sy)
   else:ep=(x if ac[0]<ec[0] else x+240,ec[1]);ap=(sx+300 if ac[0]<ec[0] else sx,ac[1])
   scene.edge(t.name+'_attr'+str(j),[ep,ap],node['id'],attr['id'],color='#64748b',width=1)
 counts={};totals={}
 for r in rs:key=tuple(sorted((r.a,r.b)));totals[key]=totals.get(key,0)+1
 for i,r in enumerate(rs):
  a,b=nodes[r.a],nodes[r.b];abx,aby=base[r.a];bbx,bby=base[r.b];key=tuple(sorted((r.a,r.b)));k=counts.get(key,0);counts[key]=k+1
  if a['y']==b['y']:
   dx=(a['x']+b['x']+240)/2;dy=a['y']+35+(170*(2*k-1) if totals[key]>1 else 0);forward=a['x']<b['x']
   if forward:p1=[(a['x']+240,a['y']+35),(dx-140,a['y']+35),(dx-140,dy),(dx-100,dy)];p2=[(dx+100,dy),(dx+140,dy),(dx+140,b['y']+35),(b['x'],b['y']+35)]
   else:p1=[(a['x'],a['y']+35),(dx+140,a['y']+35),(dx+140,dy),(dx+100,dy)];p2=[(dx-100,dy),(dx-140,dy),(dx-140,b['y']+35),(b['x']+240,b['y']+35)]
  else:
   dx=(abx+bbx)/2+1230+(560*(k-.5) if totals[key]>1 else 0);dy=min(aby,bby)+965;corr1=abx+1230;corr2=bbx+1230
   p1=[(a['x']+240,a['y']+35),(corr1,a['y']+35),(corr1,dy),(dx-100,dy)];p2=[(dx+100,dy),(corr2,dy),(corr2,b['y']+35),(b['x']+240,b['y']+35)]
  isa=r.kind=='isa';shape=scene.add('assoc'+str(i),'ISA' if isa else r.verb,dx-100,dy-55,200,110,'diamond','#ede9fe' if isa else '#fff2cc','#8b5cf6' if isa else '#d79b00',17,True,line_width=2)
  scene.edge('assoc_a'+str(i),p1,a['id'],shape['id'],dashed=isa);scene.edge('assoc_b'+str(i),p2,shape['id'],b['id'],arrow=not isa,dashed=isa)
  multiplicity='M:N' if r.ca.endswith('N)') and r.cb.endswith('N)') else '1:1' if r.ca.endswith('1)') and r.cb.endswith('1)') else '1:N'
  if a['y']==b['y'] and totals[key]==1:
   lx=(p1[0][0]+p1[-1][0])/2-125;rx=(p2[0][0]+p2[-1][0])/2-125
   scene.label('assoc_ca'+str(i),multiplicity+' | '+r.a+'\n'+r.ca,lx,a['y']+9,250,52,INK,border=True,sz=15)
   scene.label('assoc_cb'+str(i),multiplicity+' | '+r.b+'\n'+r.cb,rx,b['y']+9,250,52,INK,border=True,sz=15)
  else:
   scene.label('assoc_ca'+str(i),multiplicity+' | '+r.a+' '+r.ca,dx-155,dy-108,310,38,INK,sz=16)
   scene.label('assoc_cb'+str(i),multiplicity+' | '+r.b+' '+r.cb,dx-155,dy+72,310,38,INK,sz=16)
 header(scene,scene.title,'Dreptunghi = entitate • romb = asociere • oval = atribut • subliniat = PK • albastru = FK • oval punctat = derivat • (min,max) = participare')
 footer(scene,model,scene.height-180)
 return scene

def save(path,pages,prefix):
 path.parent.mkdir(parents=True,exist_ok=True)
 r=E.Element('mxfile',host='app.diagrams.net',version='24.7.17',type='device')
 for i,p in enumerate(pages,1):d=E.SubElement(r,'diagram',id=prefix+str(i),name=p.title);d.append(p.xml());p.png(PRE/(prefix+f'{i:02}.png'))
 E.indent(r);E.ElementTree(r).write(path,encoding='utf-8',xml_declaration=True)

def overview(chens):
 # One sheet with all five 1.A–1.E blocks, following the reference screenshot.
 view=Scene('Sarcina 1 — Exercițiile 1.A–1.E','',width=6100,height=3800)
 placements=[(80,170),(3120,170),(80,1340),(3120,1340),(1600,2510)]
 for i,(page,(ox,oy)) in enumerate(zip(chens[:5],placements)):
  # Keep the substantive shapes only; omit each page's large header/footer.
  scale=.86
  byid={s['id']:s for s in page.shapes}
  ids={s['id']:f'ex{i}_'+s['id'] for s in page.shapes if s['id'] not in ('page_title','legend','note')}
  view.add(f'block{i}',SIMPLE[i].title,ox,oy-20,2850,48,'round',PALETTE[i],PALETTE[i],23,True,'white',shadow=True)
  for shape in page.shapes:
   if shape['id'] not in ids:continue
   n=deepcopy(shape);x,y=page.absolute(shape);n['id']=ids[shape['id']];n['parent']='1';n['x']=ox+(x-30)*scale;n['y']=oy+(y-180)*scale+30;n['w']*=scale;n['h']*=scale;n['sz']=max(14,round(n['sz']*scale));view.shapes.append(n)
  for edge in page.edges:
   n=deepcopy(edge);n['id']=f'ex{i}_'+n['id'];n['pts']=[(ox+(x-30)*scale,oy+(y-180)*scale+30) for x,y in n['pts']];n['source']=ids.get(n['source']);n['target']=ids.get(n['target']);view.edges.append(n)
 header(view,view.title,'Entități, atribute, chei și asocieri • 1.A–1.E sunt disponibile și pe pagini separate pentru citire la scară mare.')
 return view

def main():
 chens=[chen_model(m) for m in MODELS];tables=[table_scene(m) for m in MODELS];eers=[]
 # Keep both requested formats separate, with named task pages.
 save(ROOT/'Lab1_Tabele_Relationale.drawio',tables,'Tabele_')
 save(ROOT/'Lab1_Diagrame_Chen.drawio',[overview(chens)]+chens+eers,'Chen_')
 for n,indices in [(1,range(5)),(2,[5]),(3,[6]),(4,[7]),(5,[8])]:
  folder=ROOT/f'Sarcina_{n}';cp=[chens[i] for i in indices]
  if n==1:cp=[overview(chens)]+cp
  save(folder/f'Sarcina_{n}_Diagrame_Chen.drawio',cp,f'S{n}_Chen_')
  save(folder/f'Sarcina_{n}_Tabele_Exemple.drawio',[tables[i] for i in indices],f'S{n}_Tabele_')
 print('Generated 9 linked table pages, 9 Chen pages, without inheritance pages and task-specific files.')
if __name__=='__main__':main()
