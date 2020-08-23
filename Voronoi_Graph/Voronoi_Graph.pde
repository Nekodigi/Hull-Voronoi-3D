//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean modeDelaunay = true;

ExampleVoronoi voronoi2D = new ExampleVoronoi(2);
ExampleDelaunay delaunay2D = new ExampleDelaunay(2);

void setup(){
  //fullScreen(P3D);
  size(500, 500, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  voronoi2D = new ExampleVoronoi(2);
  delaunay2D = new ExampleDelaunay(2);
  voronoi2D.toGraph();
  delaunay2D.toGraph();
  ortho();
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
    voronoi2D = new ExampleVoronoi(2);
    delaunay2D = new ExampleDelaunay(2);
  }
  if(key == 'm'){
    modeDelaunay = !modeDelaunay;
  }
}

void draw(){
  strokeWeight(5);
  fill(360, 10);
  lights();
  background(360);
  translate(width/2, height/2);
  if(modeDelaunay){
    delaunay2D.show();
    Vertex v = delaunay2D.delaunay.simplexes.get(0).vertices[0];
    ellipse(v.pos[0], v.pos[1], 15, 15);
    for(Vertex va : v.adj){
      ellipse(va.pos[0], va.pos[1], 10, 10);
    }
  }else{
    voronoi2D.show();
    Vertex v = voronoi2D.voronoi.polygons.get(0).vertices.get(0);
    ellipse(v.pos[0], v.pos[1], 15, 15);
    println(v.adj.size());
    for(Vertex va : v.adj){
      ellipse(va.pos[0], va.pos[1], 10, 10);
    }
  }
}
