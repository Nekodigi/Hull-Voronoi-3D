class ExampleSphericalVoronoi{
  int numVertices = 1000;
  float size = 800;
  SphericalVoronoi sVoronoi = new SphericalVoronoi();;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  
  ExampleSphericalVoronoi(){
    //randomSeed(seed);
    for(int i = 0; i < numVertices; i++){
      vertices.add(new Vertex(0, mult(sphereSampling(random(0.999, 1), random(TWO_PI)), size)));
    }
    for(int i = 0; i < numVertices/30; i++){
      vertices.add(new Vertex(0, mult(sphereSampling(random(-1, 1), random(TWO_PI)), size)));
    }
    
    sVoronoi.Generate(vertices);
  }
  
  void relax(float fac){
    for(Polygon polygon : sVoronoi.polygons){
      polygon.relax(fac);
    }
    for(int i = vertices.size()-1; i >= 0; i--){
      Vertex v = vertices.get(i);
      v.pos = setMag(v.pos, size);
    }
    sVoronoi = new SphericalVoronoi();
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

class ExampleVoronoi{
  int numVertices = 1000;
  float size = 10;
  Voronoi voronoi;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  int dim;
  PVector origin;
  ExampleVoronoi(PVector origin){
    this.origin = origin;
    this.dim = 2;
    //randomSeed(seed);
    resetVertex();
    
    voronoi = new Voronoi(dim);
    voronoi.Generate(vertices);
  }
  
  void resetVertex(){
    vertices = new ArrayList<Vertex>();
    for(int i = 0; i < numVertices; i++){
      vertices.add(new Vertex(0, random(-size, size), random(-size, size)));//id will be assigned later
    }
  }
  
  void relax(float fac){
    for(Polygon polygon : voronoi.polygons){
      polygon.relax(fac);
    }
    for(int i = vertices.size()-1; i >= 0; i--){
      Vertex v = vertices.get(i);
      float[] t = {constrain(v.pos[0], -origin.x-100, -origin.x+width+100), constrain(v.pos[1], -origin.y-100, -origin.y+height+100)};
      v.pos = t;
    }
    try{
    voronoi = new Voronoi(dim);
    voronoi.Generate(vertices);
    }catch(Exception e){
      resetVertex();
      relax(fac);
    }
  }
  
  void show(){
    stroke(255);
    for(Vertex vertex : vertices){
      //point(vertex.pos);
    }
    stroke(0);
    noFill();
    pushMatrix();
    translate(origin.x, origin.y);
    for(Polygon polygon : voronoi.polygons){
      polygon.show();
    }
    popMatrix();
  }
}

class ExampleDelaunay{
  int numVertices = 100;
  float size = 200;
  Delaunay delaunay;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
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
    polygons = simplex2Poly(delaunay.simplexes);
  }
  
  void show(){
    stroke(255);
    for(Vertex vertex : vertices){
      //point(vertex.pos);
    }
    //stroke(255, 0, 0);
    //point(delaunay.centroid);
    stroke(0);
    for(Polygon polygon : polygons){
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