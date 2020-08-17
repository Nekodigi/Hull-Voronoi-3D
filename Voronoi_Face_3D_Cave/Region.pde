class Region{//used for 3d
  int dim;
  //ArrayList<Simplex> edges = new ArrayList<Simplex>();
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  Vertex baseV;//core verex position when creating voronoi
  ConvexHull hull;
  boolean disable;//disable big region for easy to understand
   color col = color(basehue, random(100), 100, 100);
  
  Region(int dim){
    this.dim = dim;
    hull = new ConvexHull(dim);
  }
  
  float[] getBasePos(){
    return baseV.pos;
  }
  
  void calc(){
    hull.Generate(vertices);
    for(Vertex vertex : vertices){
      float dst = PVector.dist(toPVec(vertex.pos), toPVec(baseV.pos));
      if(dst > maxSize)disable = true;
    }
  }
  
  void show(){
    //for(Vertex vertex : vertices){
    //  point(vertex.pos);
    //}
    if(disable)return;
    //fill(col);
    for(Simplex simplex : hull.simplexes){
      simplex.show();
    }
  }
}
