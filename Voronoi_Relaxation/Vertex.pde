class Vertex{
  int dim;
  int id;
  int tag;
  float[] pos;
  color col = color(basehue, random(100), 100, 100);
  
  Vertex(int id, float ... pos){
    dim = pos.length;
    this.pos = pos;
    this.id = id;
  }
}