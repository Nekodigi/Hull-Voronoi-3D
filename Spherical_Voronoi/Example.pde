class ExampleSphericalVoronoi{
  int numVertices = 100;
  float size = 200;
  SphericalVoronoi sVoronoi = new SphericalVoronoi();;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  
  ExampleSphericalVoronoi(){
    //randomSeed(seed);
    for(int i = 0; i < numVertices; i++){
      vertices.add(new Vertex(0, mult(sphereSampling(random(-1, 1), random(TWO_PI)), size)));
    }
    
    sVoronoi.Generate(vertices);
  }
  
  void show(){
    stroke(360);
    for(Vertex vertex : vertices){
      //point(vertex.pos);
    }
    stroke(0);
    strokeWeight(5);
    //noStroke();
    for(Polygon polygon : sVoronoi.polygons){
      polygon.show();
    }
  }
}

class ExampleHull{
  int numVertices = 100;
  float size = 200;
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
    stroke(360);
    for(Vertex vertex : vertices){
      point(vertex.pos);
    }
    stroke(0, 100, 100);
    point(hull.centroid);
    stroke(0);
    fill(360);
    for(Simplex simplex : hull.simplexes){
      simplex.show();
    }
  }
}