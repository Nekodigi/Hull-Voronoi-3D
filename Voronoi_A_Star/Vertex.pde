class Vertex{
  int dim;
  int id;
  int tag;
  float[] pos;
  ArrayList<Vertex> adj = new ArrayList<Vertex>();
  Vertex previous;
  float h;
  float g;
  
  Vertex(int id, float ... pos){
    dim = pos.length;
    this.pos = pos;
    this.id = id;
  }
  
  float getF(){
    return h + g;
  }
  
  void addAdj(Vertex v){
    if(!hasItem(v, adj)){
      adj.add(v);
    }
  }
}
