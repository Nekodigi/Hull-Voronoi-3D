class Region{//used for 3d
  int dim;
  //ArrayList<Simplex> edges = new ArrayList<Simplex>();
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ConvexHull hull;
  
  Region(int dim){
    this.dim = dim;
    hull = new ConvexHull(dim);
  }
  
  void calc(){
    hull.Generate(vertices);
  }
  
  void show(){
    //for(Vertex vertex : vertices){
    //  point(vertex.pos);
    //}
    for(Simplex simplex : hull.simplexes){
      simplex.show();
    }
  }
}
