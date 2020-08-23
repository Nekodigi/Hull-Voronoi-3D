class ExampleVoronoi{
  int dim;
  int numVertices = vnum;
  float size = vsize;
  Voronoi voronoi;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  
  ExampleVoronoi(int dim){
    this.dim = dim;
    //randomSeed(seed);
    for(int i = 0; i < numVertices; i++){
      switch(dim){
        case 2:
          vertices.add(new Vertex(0, random(-size, size), random(-size, size)));//id will be assigned later
          break;
        case 3:
          vertices.add(new Vertex(0, random(-size, size), random(-size, size), random(-size, size)));//id will be assigned later
          break;
      }
    }
    
    voronoi = new Voronoi(dim);
    voronoi.Generate(vertices);
  }
  
  void toGraph(){
    if(dim == 2){
      for(Polygon poly : voronoi.polygons){
        poly.toGraph();
      }
    }
  }
  
  void show(){
    stroke(255);
    for(Vertex vertex : vertices){
      //point(vertex.pos);
    }
    stroke(0);
    //noFill();
    if(dim == 2){
      for(Polygon poly : voronoi.polygons){
        poly.show();
      }
    }else if(dim == 3){
      noStroke();
      for(Region region : voronoi.regions){
        region.show();
      }
      //voronoi.regions.get(int(float(frameCount)/10%voronoi.regions.size())).show();//for easy to understand
    }
  }
}

class ExampleDelaunay{
  int numVertices = vnum;
  float size = vsize;
  Delaunay delaunay;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  
  ExampleDelaunay(int dim){
    //randomSeed(seed);
    for(int i = 0; i < numVertices; i++){
      switch(dim){
        case 2:
          vertices.add(new Vertex(0, random(-size, size), random(-size, size)));//id will be assigned later
          break;
        case 3:
          vertices.add(new Vertex(0, random(-size, size), random(-size, size), random(-size, size)));//id will be assigned later
          break;
      }
    }
    
    delaunay = new Delaunay(dim);
    delaunay.Generate(vertices);
    polygons = simplex2Poly(delaunay.simplexes);
  }
  
  void toGraph(){
    for(Simplex s : delaunay.simplexes){
      s.toGraph();
    }
  }
  
  void show(){
    stroke(255);
    for(Vertex vertex : vertices){
      //point(vertex.pos);
    }
    stroke(255, 0, 0);
    //point(delaunay.centroid);
    stroke(0);
    noFill();
    for(Polygon poly : polygons){
      poly.show();
    }
    //for(Simplex simplex : delaunay.simplexes){
    //  simplex.show();
    //}
  }
}

class ExampleHull{
  int numVertices = 100;
  float size = 800;
  ConvexHull hull;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  
  ExampleHull(int dim){
    //randomSeed(seed);
    for(int i = 0; i < numVertices; i++){
      switch(dim){
        case 2:
          vertices.add(new Vertex(0, random(-size, size), random(-size, size)));//id will be assigned later
          break;
        case 3:
          vertices.add(new Vertex(0, random(-size, size), random(-size, size), random(-size, size)));//id will be assigned later
          break;
        case 4:
          vertices.add(new Vertex(0, random(-size, size), random(-size, size), random(-size, size), random(-size, size)));//id will be assigned later
          break;
      }
    }
    
    hull = new ConvexHull(dim);
    hull.Generate(vertices);
  }
  
  void show(){
    stroke(255);
    for(Vertex vertex : vertices){
      point(vertex.pos);
    }
    stroke(255, 0, 0);
    point(hull.centroid);
    stroke(0);
    fill(255);
    for(Simplex simplex : hull.simplexes){
      simplex.show();
    }
  }
}
