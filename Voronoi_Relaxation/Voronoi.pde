class Voronoi{
  int dim;
  ArrayList<Vertex> vertices;
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  Delaunay delaunay;
  
  Voronoi(int dim){
    this.dim = dim;
    delaunay = new Delaunay(dim);
  }
  
  void Generate(ArrayList<Vertex> input){
    delaunay.Generate(input);
    for(Simplex simplex : delaunay.simplexes){//calculation all circumCenter
      simplex.calcCircumCenter();
    }
    vertices = delaunay.vertices;
    for(Vertex v : vertices){//calculate all polygon
      Polygon polygon = new Polygon();
      polygon.setBaseVertex(v);
      Simplex current = null; 
      for(Simplex simplex : delaunay.simplexes){//pick up one of simplex which contain v
        if(hasItem(v, simplex.vertices)){
          current = simplex;
          break;
        }
      }
      if(current == null)continue;
      Simplex[] adjHasV = getAdjHasVertex(current, v);//get adjacent around v
      Simplex end = adjHasV[0];
      Simplex prev = current;
      current = adjHasV[1];if(end.circumC == null)continue;if(prev.circumC == null)continue;
      polygon.vertices.add(end.circumC);
      polygon.vertices.add(prev.circumC);
      boolean breakTag = false;
      while(current != end){//add vertex while going around v
      if(current == null)break;
        adjHasV = getAdjHasVertex(current, v);
        if(adjHasV[0] != prev){//to avoid backing
          prev = current;if(prev.circumC == null){breakTag = true; break;};
          polygon.vertices.add(prev.circumC);
          current = adjHasV[0];
        }else{
          prev = current;if(prev.circumC == null){breakTag = true; break;};
          polygon.vertices.add(prev.circumC);
          current = adjHasV[1];
        }
      }
      if(breakTag == true) continue;
      polygons.add(polygon);
    }
  }
}