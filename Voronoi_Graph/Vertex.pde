class Vertex{
  int dim;
  int id;
  int tag;
  float[] pos;
  ArrayList<Vertex> adj = new ArrayList<Vertex>();
  
  Vertex(int id, float ... pos){
    dim = pos.length;
    this.pos = pos;
    this.id = id;
  }
  
  void addAdj(Vertex v){
    if(!hasItem(v, adj)){
      adj.add(v);
    }
  }
}
