//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean modeDelaunay = true;
float sampItv = 20;//voronoi line sampling interval

Delaunay delaunay;
Voronoi voronoi;
ArrayList<Vertex> vertices = new ArrayList<Vertex>();
PVector prevMouse;

void setup(){
  size(500, 500, P3D);
  //fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  //size(500, 500, P3D);
  ortho();
  strokeWeight(5);
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
  }
  if(key == 'm'){
    modeDelaunay = !modeDelaunay;
  }
}

void mousePressed(){
  vertices.add(new Vertex(0, mouseX, mouseY-10));
  vertices.add(new Vertex(0, mouseX, mouseY+10));
}

void draw(){
  background(360);
  if(mousePressed){
    PVector mouse = new PVector(mouseX, mouseY);
    if(prevMouse==null){
      prevMouse = mouse.copy();
    }else{
      if(PVector.dist(prevMouse, mouse) > sampItv){
        PVector normal = PVector.sub(mouse, prevMouse).normalize().rotate(HALF_PI);
        PVector p1 = PVector.add(mouse, PVector.mult(normal, 10));
        PVector p2 = PVector.add(mouse, PVector.mult(normal, -10));
        vertices.add(new Vertex(0, p1.x, p1.y));
        vertices.add(new Vertex(0, p2.x, p2.y));
        prevMouse = mouse;
      }
    }
  }
  strokeWeight(1);
  delaunay = new Delaunay(2);
  //vertices.add(new Vertex(0, 0, 0));
  //vertices.add(new Vertex(0, width, 0));
  //vertices.add(new Vertex(0, width-0.1, height-1));
  //vertices.add(new Vertex(0, 0, height-0.01));
  delaunay.Generate(vertices);
  voronoi = new Voronoi(2);
  voronoi.Generate(vertices);
  stroke(0);
  noFill();
  if(modeDelaunay){
    for(Simplex s : delaunay.simplexes){
      s.show();
    }
  }else{
    for(Polygon poly : voronoi.polygons){
      poly.show();
    }
  }
}
