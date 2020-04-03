class SphericalVoronoi{
  ArrayList<Vertex> vertices;
  ArrayList<Simplex> edges = new ArrayList<Simplex>();
  ConvexHull hull = new ConvexHull(3);
  
  SphericalVoronoi(){}

  void Generate(ArrayList<Vertex> input){
    hull.Generate(input);
    for(Simplex simplex : hull.simplexes){//calculation all circumCenter
      simplex.calcCircumCenter();
      simplex.tag = 0;
    }
    vertices = hull.vertices;
    for(Simplex simplex : hull.simplexes){//calculate all polygon
      simplex.tag = 1;
      for(Simplex adj : simplex.adjacent){
        if(adj.tag == 0){//Prevent the same Edge from being registered again
          edges.add(new Simplex(simplex.circumC, adj.circumC));
        }
      }
    }
  }
}