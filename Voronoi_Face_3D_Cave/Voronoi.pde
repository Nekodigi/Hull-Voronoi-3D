class Voronoi{
  int dim;
  ArrayList<Region> regions = new ArrayList<Region>();//used for 3d
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();//used for 2d
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
    if(dim == 2)Generate2D();
    else if(dim == 3)Generate3D();
  }
  
  void Generate3D(){
    ArrayList<Simplex> around = new ArrayList<Simplex>();//simplex around vertices
    for(int i = 0; i < delaunay.vertices.size(); i++){
      around.clear();
      Vertex vertex = delaunay.vertices.get(i);
      Region region = new Region(dim);
      region.baseV = vertex;
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
              //region.vertices.add(new Vertex(0, resize(simplex.circumC.pos, dim)));
            }
          }
        }
        
      }
      if(around.size() > 0){
        for(int j = 0; j < around.size(); j++){
          Simplex simplex = around.get(j);simplex.calcCircumCenter();
          region.vertices.add(new Vertex(0, resize(simplex.circumC.pos, dim)));
        }
      }
      try{//to miss convex hull singular input error
      region.calc();
      }catch(IllegalArgumentException e){
        //miss this error
      }
      regions.add(region);
    }
  }
  
  void Generate2D(){
    for(Vertex v : delaunay.vertices){//calculate all polygon
      Polygon polygon = new Polygon();
      Simplex current = null; 
      for(Simplex simplex : delaunay.simplexes){//pick up one of simplex which contain v
        if(hasItem(v, simplex.vertices)){
          current = simplex;
          break;
        }
      }
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
