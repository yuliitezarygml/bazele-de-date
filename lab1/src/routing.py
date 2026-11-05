"""Orthogonal grid routing with hard node and already-routed-wire obstacles."""
from heapq import heappush,heappop
from math import floor,ceil
STEP=40

def compress(points):
 out=[]
 for point in points:
  if out and point==out[-1]:continue
  while len(out)>1 and ((out[-2][0]==out[-1][0]==point[0]) or (out[-2][1]==out[-1][1]==point[1])):out.pop()
  out.append(point)
 return out

def route_all(boxes,relations,width,height):
 # Work in grid units. Tables retain their measured widths.
 limitx=ceil(width/STEP);limity=ceil(height/STEP)
 blocked=set()
 for b in boxes.values():
  for x in range(floor((b['x']-55)/STEP),ceil((b['x']+b['w']+55)/STEP)+1):
   for y in range(floor((b['y']-55)/STEP),ceil((b['y']+b['h']+55)/STEP)+1):blocked.add((x,y))
 used=set();used_ports=set();output=[]
 def ports(b):
  out=[]
  for y in range(ceil((b['y']+70)/STEP),floor((b['y']+b['h']-24)/STEP)+1):
   py=y*STEP
   for side in ['L','R']:
    x=b['x'] if side=='L' else b['x']+b['w'];gx=floor((x-100)/STEP) if side=='L' else ceil((x+100)/STEP)
    out.append(((x,py),(gx,y),side))
  for x in range(ceil((b['x']+50)/STEP),floor((b['x']+b['w']-50)/STEP)+1,2):
   px=x*STEP
   for side in ['T','B']:
    y=b['y'] if side=='T' else b['y']+b['h'];gy=floor((y-100)/STEP) if side=='T' else ceil((y+100)/STEP)
    out.append(((px,y),(x,gy),side))
  return [p for p in out if p[0] not in used_ports and p[1] not in used]
 def astar(start,end):
  if start in blocked or end in blocked:return None
  heap=[(abs(start[0]-end[0])+abs(start[1]-end[1]),0,start[0],start[1],-1)];dist={(start[0],start[1],-1):0};parent={}
  while heap:
   _,g,x,y,d=heappop(heap);state=(x,y,d)
   if g!=dist.get(state):continue
   if (x,y)==end:
    path=[]
    while state in parent:path.append((state[0],state[1]));state=parent[state]
    path.append(start);return path[::-1]
   for nd,(dx,dy) in enumerate([(1,0),(0,1),(-1,0),(0,-1)]):
    nx,ny=x+dx,y+dy
    if not (1<=nx<limitx and 5<=ny<limity):continue
    if (nx,ny) in blocked or (nx,ny) in used:continue
    ng=g+1+(3 if d>=0 and nd!=d else 0);ns=(nx,ny,nd)
    if ng<dist.get(ns,float('inf')):
     dist[ns]=ng;parent[ns]=(x,y,d);h=abs(nx-end[0])+abs(ny-end[1]);heappush(heap,(ng+h,ng,nx,ny,nd))
  return None
 for index,r in enumerate(relations):
  a,b=boxes[r.a],boxes[r.b];pa=ports(a);pb=ports(b);pairs=[]
  for p in pa:
   for q in pb:
    if p[0]==q[0] or p[1]==q[1]:continue
    man=abs(p[1][0]-q[1][0])+abs(p[1][1]-q[1][1]);align=0 if ((p[2],q[2]) in [('R','L'),('L','R'),('T','B'),('B','T')]) else 4
    # Prefer ports well inside table sides, away from corner bends.
    pairs.append((man+align,p,q))
  pairs.sort(key=lambda item:item[0]);result=None
  for _,p,q in pairs[:180]:
   path=astar(p[1],q[1])
   if path is not None:
    result=(p,q,path);break
  if result is None:raise RuntimeError(f'No clear orthogonal route: {r.a} → {r.b}')
  p,q,path=result;points=compress([p[0]]+[(x*STEP,y*STEP) for x,y in path]+[q[0]])
  # Reserve all path points, including each port approach, to prevent crossings.
  new_used=set()
  for u,v in zip(points,points[1:]):
   if u[0]==v[0]:
    gx=round(u[0]/STEP)
    for gy in range(ceil(min(u[1],v[1])/STEP),floor(max(u[1],v[1])/STEP)+1):new_used.add((gx,gy))
   else:
    gy=round(u[1]/STEP)
    for gx in range(ceil(min(u[0],v[0])/STEP),floor(max(u[0],v[0])/STEP)+1):new_used.add((gx,gy))
  used.update((x+dx,y+dy) for x,y in new_used for dx in range(-2,3) for dy in range(-2,3))
  used_ports.update([p[0],q[0]]);output.append((r,points))
 return output
