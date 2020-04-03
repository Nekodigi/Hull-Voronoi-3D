class SphericalVoronoi{
  ArrayList<Vertex> vertices;
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  ConvexHull hull = new ConvexHull(3);
  
  SphericalVoronoi(){}

  void Generate(ArrayList<Vertex> input){
    hull.Generate(input);
    for(Simplex simplex : hull.simplexes){//calculation all circumCenter
      simplex.calcCircumCenter();
    }
    vertices = hull.vertices;
    for(Vertex v : vertices){//calculate all polygon
      Polygon polygon = new Polygon();
      Simplex current = null; 
      for(Simplex simplex : hull.simplexes){//pick up one of simplex which contain v
        if(hasItem(v, simplex.vertices)){
          current = simplex;
          break;
        }
      }
      Simplex[] adjHasV = getAdjHasVertex(current, v);//get adjacent around v
      Simplex end = adjHasV[0];
      Simplex prev = current;
      current = adjHasV[1];
      polygon.vertices.add(end.circumC);
      polygon.vertices.add(prev.circumC);
      while(current != end){//add vertex while going around v
        adjHasV = getAdjHasVertex(current, v);
        if(adjHasV[0] != prev){//to avoid backing
          prev = current;
          polygon.vertices.add(prev.circumC);
          current = adjHasV[0];
        }else{
          prev = current;
          polygon.vertices.add(prev.circumC);
          current = adjHasV[1];
        }
      }
      polygons.add(polygon);
    }
  }
}