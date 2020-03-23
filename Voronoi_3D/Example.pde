class ExampleVoronoi{
  int numVertices = 100;
  float size = 800;
  Voronoi voronoi;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  
  ExampleVoronoi(int dim){
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
  
  void show(){
    stroke(255);
    for(Vertex vertex : vertices){
      point(vertex.pos);
    }
    stroke(0);
    noFill();
    for(Region region : voronoi.regions){
      region.show();
    }
  }
}

class ExampleDelaunay{
  int numVertices = 100;
  float size = 800;
  Delaunay delaunay;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  
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
  }
  
  void show(){
    stroke(255);
    for(Vertex vertex : vertices){
      point(vertex.pos);
    }
    stroke(255, 0, 0);
    point(delaunay.centroid);
    stroke(0);
    noFill();
    for(Simplex simplex : delaunay.simplexes){
      simplex.show();
    }
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