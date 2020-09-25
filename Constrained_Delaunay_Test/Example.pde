import java.util.ArrayDeque;
import java.util.Queue;

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

    voronoi = new Voronoi(dim);
    voronoi.Generate(vertices);
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
  int numVertices = 40;
  float size = 200;
  Delaunay delaunay;
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  int seed = 0;
  ArrayList<Vertex> constraints = new ArrayList<Vertex>();

  ExampleConstrainedDelaunay(int dim, ArrayList<Vertex> constraints) {
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
    for (Vertex constraint : constraints) {
      vertices.add(constraint);
    }
    int count=0;
    for(Vertex vertex : vertices){
      vertex.id = count++;
    }
    delaunay = new Delaunay(dim);
    delaunay.Generate(vertices);
    polygons = simplex2Poly(delaunay.simplexes);
  }
  
  void n(){
    //calculate unique edge
    
    println("find intersect");
    //find intersecting edge with constrains
    for (int i=0; i<constrains.size(); i++) {
      Vertex ca = constrains.get(i);
      Vertex cb = constrains.get((i+1)%constrains.size());
      
      ArrayList<EdgeLS> uniqueEdges = new ArrayList<EdgeLS>();//unique((edge in same position is same edge)) edge element which shared by two simplexes;
      for(Simplex simplex : delaunay.simplexes){
        simplex.checked = false;
      }
      
      for (Simplex simplex : delaunay.simplexes) {
        simplex.checked = true;
        for (Simplex adj : simplex.adjacent) {
          if (adj != null && adj.checked == false) {
            uniqueEdges.add(new EdgeLS(simplex, adj));
          }
        }
      }
      
      Queue<EdgeLS> interEdges = new ArrayDeque<EdgeLS>();//intersecting unique edge
      for (EdgeLS edge : uniqueEdges) {edge.calcaAB();
        Vertex ea = edge.A.vertices[(edge.aA+1)%3];
        Vertex eb = edge.A.vertices[(edge.aA+2)%3];
        if (IsCrossingEdge(ca.pos, cb.pos, ea.pos, eb.pos)) {
          interEdges.add(edge);
        }
      }
      println(uniqueEdges.size(), interEdges.size());
      println("to new edge");
      ArrayList<EdgeLS> newEdges = new ArrayList<EdgeLS>();
      int safety = 0;
      while (interEdges.size() > 0 && safety < 1000) {
        safety++;
        EdgeLS edge = interEdges.poll();
        //println("1");
        edge.calcaAB();
        
        if(!IsQuadrilateralConvex(edge.A.vertices[0].pos, edge.A.vertices[1].pos, edge.A.vertices[2].pos, edge.B.vertices[edge.aB].pos)){
          interEdges.add(edge);
          continue;
        }else{
          println("flip", safety);
          edge.flip();println("fe");
          edge.calcaAB();
          if(IsCrossingEdge(ca.pos, cb.pos, edge.A.vertices[(edge.aA+1)%3].pos, edge.A.vertices[(edge.aA+2)%3].pos)){
            interEdges.add(edge);
          }else{
            newEdges.add(edge);
          }
        }
      }
    }
    
    //Simplex A = delaunay.simplexes.get(0);
    //Simplex B = delaunay.simplexes.get(1);
    //int i = 0, j = 0;
    //if(A.adjacent[1] == B)i = 1;
    //if(A.adjacent[2] == B)i = 2;
    //if(B.adjacent[1] == A)j = 1;
    //if(B.adjacent[2] == A)j = 2;
    //println(i, j);
    //EdgeLS els = new EdgeLS(A, i, B, j);
    //els.flip();

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
