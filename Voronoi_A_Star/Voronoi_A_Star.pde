//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
int heurType = 0;

float basehue = 0;
boolean modeDelaunay = false;
Vertex current;
Vertex end;
ArrayList<Vertex> openSet = new ArrayList<Vertex>();
ArrayList<Vertex> closedSet = new ArrayList<Vertex>();
ArrayList<Vertex> path = new ArrayList<Vertex>();
boolean solving = false;
float vsize = 200;//1000 vertex distribute
int vnum = 1000;//10000 vertex distribute
int startI = 0;//start index

ExampleVoronoi voronoi2D = new ExampleVoronoi(2);
ExampleDelaunay delaunay2D = new ExampleDelaunay(2);

void setup(){
  //fullScreen(P3D);
  size(500, 500, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  background(360);
  voronoi2D = new ExampleVoronoi(2);
  delaunay2D = new ExampleDelaunay(2);
  voronoi2D.toGraph();
  delaunay2D.toGraph();
  ortho();
}

void draw(){
  //strokeWeight(5);
  //fill(360, 10);
  //lights();
  //background(360);
  translate(width/2, height/2);
  ArrayList<Vertex> vs = new ArrayList<Vertex>();
  if(modeDelaunay){
    vs =delaunay2D.vertices;
  }else{
    vs =voronoi2D.voronoi.vertices;
  }
  current = vs.get(startI);println(vs.size());
  end = vs.get((int)random(vs.size()));//println(end.adj.size());
  A_Star();
  showPath();
  
  if(modeDelaunay){
    //delaunay2D.show();
    //stroke(360);
    //Vertex v = delaunay2D.delaunay.simplexes.get(0).vertices[0];
    //ellipse(v.pos[0], v.pos[1], 10, 10);
    //for(Vertex va : v.adj){
    //  ellipse(va.pos[0], va.pos[1], 5, 5);
    //}
  }else{
    //voronoi2D.show();
    //stroke(360);
    //Vertex v = voronoi2D.voronoi.polygons.get(0).vertices.get(0);
    //ellipse(v.pos[0], v.pos[1], 10, 10);
    //println(v.adj.size());
    //for(Vertex va : v.adj){
    //  ellipse(va.pos[0], va.pos[1], 5, 5);
    //}
  }
}

void keyPressed(){
  if(key == 'm'){
    modeDelaunay = !modeDelaunay;
    ArrayList<Vertex> vs = new ArrayList<Vertex>();
    background(360);
    if(modeDelaunay){
      vs =delaunay2D.vertices;
    }else{
      vs =voronoi2D.voronoi.vertices;
    }
    for(Vertex v : vs){
      v.previous = null;
    }
    startI = (int)random(vs.size());
  }
  if(key == 'r'){
    ArrayList<Vertex> vs = new ArrayList<Vertex>();
    background(360);
    if(modeDelaunay){
      vs =delaunay2D.vertices;
    }else{
      vs =voronoi2D.voronoi.vertices;
    }
    for(Vertex v : vs){
      v.previous = null;
    }
    startI = (int)random(vs.size());
  }
}
