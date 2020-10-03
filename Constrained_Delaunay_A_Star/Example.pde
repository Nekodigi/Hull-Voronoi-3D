class ExampleSphericalVoronoi {
  int numVertices = 100;
  float size = 200;
  SphericalVoronoi sVoronoi = new SphericalVoronoi();
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;

  ExampleSphericalVoronoi() {
    //randomSeed(seed);
    for (int i = 0; i < numVertices; i++) {
      vertices.add(new Vertex(0, mult(sphereSampling(random(-1, 1), random(TWO_PI)), size)));
    }

    sVoronoi.Generate(vertices);
  }

  void show() {
    stroke(360);
    for (Vertex vertex : vertices) {
      //point(vertex.pos);
    }
    stroke(0);
    strokeWeight(5);
    //noStroke();
    for (Polygon polygon : sVoronoi.polygons) {
      polygon.show();
    }
  }
}

class ExampleVoronoi {
  int numVertices = 100;
  float size = 200;
  Voronoi voronoi;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;
  Delaunay delaunay;

  ExampleVoronoi(int dim) {
    //randomSeed(seed);
    for (int i = 0; i < numVertices; i++) {
      switch(dim) {
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
    voronoi = new Voronoi(dim);
    voronoi.Generate(delaunay.simplexes, delaunay.vertices);
  }

  void show() {
    stroke(255);
    for (Vertex vertex : vertices) {
      //point(vertex.pos);
    }
    stroke(0);
    noFill();
    for (Polygon polygon : voronoi.polygons) {
      polygon.show();
    }
  }
}

class ExampleConstrainedVoronoi {
  int numVertices = 100;
  float size = 200;
  Voronoi voronoi;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<float[]> constraints = new ArrayList<float[]>();
  int seed = 0;
  Delaunay delaunay;
  SimplexVertices constrained;

  ExampleConstrainedVoronoi(ArrayList<float[]> constraints, boolean shouldRemoveTriangles) {
    int dim = 2;
    this.constraints = constraints;
    //randomSeed(seed);
    for (int i = 0; i < numVertices; i++) {
      switch(dim) {
      case 2:
        vertices.add(new Vertex(0, random(-size, size), random(-size, size)));//id will be assigned later
        break;
      case 3:
        vertices.add(new Vertex(0, random(-size, size), random(-size, size), random(-size, size)));//id will be assigned later
        break;
      }
    }
    for (float[] constraint : constraints) {
      vertices.add(new Vertex(0, constraint));
    }
    int count=0;
    for(Vertex vertex : vertices){
      vertex.id = count++;
    }
    delaunay = new Delaunay(dim);
    delaunay.Generate(vertices);
    HEData he =new HEData(delaunay.simplexes);
    //he = AddConstraints(he, constraints, shouldRemoveTriangles);
    //convet to simplex and to poly
    constrained = he.toSimplexes();
    //delaunay.simplexes = triangles;
    voronoi = new Voronoi(dim);
    voronoi.Generate(constrained.simplexes, constrained.vertices);
    //voronoi.Generate(delaunay.simplexes, delaunay.vertices);
  }
  
  void show() {
    stroke(255);
    for (Vertex vertex : vertices) {
      //point(vertex.pos);
    }
    stroke(0);
    noFill();
    for(Simplex s : delaunay.simplexes){
      for(Simplex s2 : s.adjacent){
        if(s==null || s2==null)continue;
        s.calcCircumCenter();
        s2.calcCircumCenter();
        line(s.circumC.pos[0], s.circumC.pos[1], s2.circumC.pos[0], s2.circumC.pos[1]);
      }
    }
    for (Polygon polygon : voronoi.polygons) {
      polygon.show();
      
    }
  }
}

class ExampleDelaunay {
  int numVertices = 20;
  float size = 200;
  Delaunay delaunay;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  int seed = 0;

  ExampleDelaunay(int dim) {
    //randomSeed(seed);
    for (int i = 0; i < numVertices; i++) {
      switch(dim) {
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

  void show() {
    stroke(255);
    for (Vertex vertex : vertices) {
      //point(vertex.pos);
    }
    //stroke(255, 0, 0);
    //point(delaunay.centroid);
    stroke(0);
    for (Polygon polygon : polygons) {
      polygon.show();
    }
  }
}

class ExampleConstrainedDelaunay {
  Delaunay delaunay;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  int seed = 0;
  ArrayList<float[]> constraints = new ArrayList<float[]>();
  SimplexVertices constrained;

  ExampleConstrainedDelaunay(ArrayList<float[]> constraints, boolean shouldRemoveTriangles) {
    int dim = 2;
    //randomSeed(seed);
    this.constraints = constraints;
    for (int i = 0; i < numVertices; i++) {
      switch(dim) {
      case 2:
        vertices.add(new Vertex(0, random(-size, size), random(-size, size)));//id will be assigned later
        break;
      case 3:
        vertices.add(new Vertex(0, random(-size, size), random(-size, size), random(-size, size)));//id will be assigned later
        break;
      }
    }
    for (float[] constraint : constraints) {
      vertices.add(new Vertex(0, constraint));
    }
    int count=0;
    for(Vertex vertex : vertices){
      vertex.id = count++;
    }
    delaunay = new Delaunay(dim);
    delaunay.Generate(vertices);
    HEData he =new HEData(delaunay.simplexes);
    he = AddConstraints(he, constraints, shouldRemoveTriangles);
    //convet to simplex and to poly
    constrained = he.toSimplexes();
    polygons = simplex2Poly(constrained.simplexes);
  }
  
  void toGraph(){
    for(Simplex s : constrained.simplexes){
      s.toGraph();
    }
  }

  void show() {
    stroke(255);
    for (Vertex vertex : vertices) {
      //point(vertex.pos);
    }
    //stroke(255, 0, 0);
    //point(delaunay.centroid);
    stroke(0);
    for (Polygon polygon : polygons) {
      polygon.show();
    }
  }
}

class ExampleHull {
  int numVertices = 100;
  float size = 200;
  ConvexHull hull;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  int seed = 0;

  ExampleHull(int dim) {
    //randomSeed(seed);
    for (int i = 0; i < numVertices; i++) {
      switch(dim) {
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

  void show() {
    stroke(360);
    for (Vertex vertex : vertices) {
      point(vertex.pos);
    }
    stroke(0, 100, 100);
    point(hull.centroid);
    stroke(0);
    fill(360);
    for (Simplex simplex : hull.simplexes) {
      simplex.show();
    }
  }
}
