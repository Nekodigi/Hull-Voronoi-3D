class Region{
  int dim;
  ArrayList<Simplex> edges = new ArrayList<Simplex>();
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ConvexHull hull;
  
  Region(int dim){
    this.dim = dim;
    hull = new ConvexHull(dim);
  }
  
  void calc(){
    hull.Generate()
  }
  
  void show(){
    for(Simplex edge : edges){
      edge.show();
    }
  }
}