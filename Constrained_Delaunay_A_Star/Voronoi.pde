class Voronoi{
  int dim;
  ArrayList<Vertex> vertices;
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  
  Voronoi(int dim){
    this.dim = dim;
  }
  
  void Generate(ArrayList<Simplex> input, ArrayList<Vertex> ivertices){
    for(Simplex simplex : input){//calculation all circumCenter
      simplex.calcCircumCenter();
    }
    vertices = ivertices;//we use this when 2d
    for(Vertex v : vertices){//calculate all polygon
      Polygon polygon = new Polygon();
      Simplex current = null; 
      for(Simplex simplex : input){//pick up one of simplex which contain v
        if(hasItem(v, simplex.vertices)){
          current = simplex;
          break;
        }
      }
      Simplex[] adjHasV = getAdjHasVertex(current, v);//get adjacent around v
      Simplex end = adjHasV[0];
      Simplex prev = current;//println(end, prev, current);
      current = adjHasV[1];if(end == null || end.circumC == null)continue;if(prev.circumC == null)continue;
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
    }
  }
}
