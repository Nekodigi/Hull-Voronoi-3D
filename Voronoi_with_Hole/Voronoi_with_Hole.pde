//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean modeDelaunay = true;
int n = 200;//number of vertices;
float vr = 20;//vertex radius
float mouseR = 120;//mouse separate radius, when delaunay it means radius, when voronoi it mean diameter
float relaxP = 0.4;//relax power
float centerAttrP = 0.01;//center attract power
float maxLength = 80;//max edge length

Delaunay delaunay;
Voronoi voronoi;
ArrayList<Vertex> vertices = new ArrayList<Vertex>();
Vertex mouse;

void setup(){
  size(500, 500, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  for(int i=0; i<n; i++){
    vertices.add(new Vertex(0, random(width), random(height)));
  }
  mouse = new Vertex(0, 0, 0);
  mouse.r = mouseR;
  vertices.add(mouse);
  //fullScreen(P3D);
  //size(500, 500, P3D);
  ortho();
  strokeWeight(1);
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
  }
  if(key == 'm'){
    modeDelaunay = !modeDelaunay;
  }
}

void draw(){
  background(360);
  mouse.pos = set(mouseX, mouseY);
  relax(vertices);
  centerAttr(vertices);
  mouse.pos = set(mouseX, mouseY);
  delaunay = new Delaunay(2);
  delaunay.Generate(vertices);
  voronoi = new Voronoi(2);
  voronoi.Generate(vertices);
  
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
