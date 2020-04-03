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

class ExampleVoronoi{
  int numVertices = 100;
  float size = 200;
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
      //point(vertex.pos);
    }
    stroke(0);
    noFill();
    for(Polygon polygon : voronoi.polygons){
      polygon.show();
    }
  }
  
  String toCSV(){
    String str = Vert2CSV() + "/" + Face2CSV();
    PrintWriter output;
    output = createWriter("voronoi.txt");
    output.print(str);
    output.close();
    return str;
  }
  
  String Face2CSV(){
    String result = "";
    for(Polygon polygon : voronoi.polygons){
      if(polygon.isValid(0.003)){
        result += polygon.toCSV()+"\n";
      }
    }
    return result.substring(0, result.length()-1);
  }
  
  String Vert2CSV(){
    String result = "";
    for(int i = 0; i < voronoi.Vvertices.size(); i++){
      result += voronoi.Vvertices.get(i).toCSV()+"\n";
    }
    return result.substring(0, result.length()-1);
  }
}

class ExampleDelaunay{
  int numVertices = 100;
  float size = 200;
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
  
  String toCSV(){
    String str = Vert2CSV() + "/" + Face2CSV();
    PrintWriter output;
    output = createWriter("delaunay.txt");
    output.print(str);
    output.close();
    return str;
  }
  
  String Face2CSV(){
    for(int i = 0; i < vertices.size(); i++){
      vertices.get(i).id = i;
    }
    String result = "";
    for(Polygon polygon : delaunay.polygons){
      if(polygon.isValid(0.003)){
        result += polygon.toCSV()+"\n";
      }
    }
    return result.substring(0, result.length()-1);
  }
  
  String Vert2CSV(){
    String result = "";
    for(int i = 0; i < vertices.size(); i++){
      result += vertices.get(i).toCSV()+"\n";
    }
    return result.substring(0, result.length()-1);
  }
  
  void show(){
    stroke(255);
    for(Vertex vertex : vertices){
      //point(vertex.pos);
    }
    //stroke(255, 0, 0);
    //point(delaunay.centroid);
    stroke(0);
    for(Polygon polygon : delaunay.polygons){
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