//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean modeDelaunay = false;
float rescale4CSV;

ExampleVoronoi ev2;
ExampleDelaunay ed2;

void setup(){
  size(500, 500, P3D);
  rescale4CSV = width*2;
  //fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  ev2 = new ExampleVoronoi();
  ed2 = new ExampleDelaunay();
  //size(500, 500, P3D);
  ortho();
  strokeWeight(0);
  ev2.offset(0.003);
  ed2.offset(0.003);
  println(ev2.toCSV("voronoi.txt"));
  println(ed2.toCSV("delaunay.txt"));
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
    ev2 = new ExampleVoronoi();
    ed2 = new ExampleDelaunay();
    ev2.offset(0.003);
    ed2.offset(0.003);
    println(ev2.toCSV("voronoi.txt"));
    println(ed2.toCSV("delaunay.txt"));
  }
  if(key == 'm'){
    modeDelaunay = !modeDelaunay;
  }
}

void draw(){
  background(360);
  translate(width/2, height/2);
  //rotateX(float(frameCount)/500);
  //rotateY(float(frameCount)/1000);
  //rotateZ(float(frameCount)/2000);
  //esv.show();
  if(modeDelaunay){
    ed2.show();
  }else{
    ev2.show();
  }
}