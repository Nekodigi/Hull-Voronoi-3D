class Voronoi{
  int dim;
  ArrayList<Region> regions = new ArrayList<Region>();
  Delaunay delaunay;
  
  Voronoi(int dim){
    this.dim = dim;
    delaunay = new Delaunay(dim);
  }
  
  void Generate(ArrayList<Vertex> input){
    delaunay.Generate(input);
    ArrayList<Simplex> around = new ArrayList<Simplex>();//simplex around vertices
    for(int i = 0; i < delaunay.vertices.size(); i++){
      Region region = new Region();
      around.clear();
      Vertex vertex = delaunay.vertices.get(i);
      for(int j = 0; j < delaunay.simplexes.size(); j++){
        Simplex simplex = delaunay.simplexes.get(j);
        if(contains(simplex.vertices, vertex)){
          around.add(simplex);
        }
      }
      if(around.size() > 0){
        for(int j = 0; j < around.size(); j++){
          Simplex simplex = around.get(j);
          for(int k = 0; k < simplex.adjacent.length; k++){
            Simplex adjFace = simplex.adjacent[k];
            if(around.contains(adjFace)){
              Simplex edge = new Simplex(2);
              simplex.calcCircumCenter();
              adjFace.calcCircumCenter();
              edge.vertices[0] = new Vertex(0, resize(simplex.circumC, dim));
              edge.vertices[1] = new Vertex(0, resize(adjFace.circumC, dim));
              region.edges.add(edge);
            }
          }
        }
        regions.add(region);
      }
    }
  }
}