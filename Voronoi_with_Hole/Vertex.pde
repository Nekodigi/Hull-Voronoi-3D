class Vertex{
  int dim;
  int id;
  int tag;
  float[] pos;
  float r = vr;
  color col;
  
  Vertex(int id, float ... pos){
    dim = pos.length;
    this.pos = pos;
    this.id = id;
    col = color(basehue, random(100), 100, 100);
  }
}

void relax(ArrayList<Vertex> verts){
  for(int i=0; i<verts.size(); i++){
    Vertex vert = verts.get(i);
    for(Vertex target : verts){
      if(target == vert)continue;
      float[] diff = sub(vert.pos, target.pos);
      float dist = mag(diff);
      if(dist < target.r+vert.r){
        float rdist = target.r+vert.r-dist;
        vert.pos = add(vert.pos, setMag(diff, rdist*relaxP));
      }
    }
  }
}

void centerAttr(ArrayList<Vertex> verts){//attract to center
  float[] center = set(width/2, height/2);
  for(Vertex target : verts){
    target.pos = lerp(target.pos, center, centerAttrP);
  }
}
