class Vertex{
  int dim;
  int id;
  int tag;
  float[] pos;
  
  Vertex(int id, float ... pos){
    dim = pos.length;
    this.pos = pos;
    this.id = id;
  }
}