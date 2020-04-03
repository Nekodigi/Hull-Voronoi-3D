//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean modeDelaunay = true;
float rescale4CSV;

ExampleSphericalVoronoi esv;
ExampleVoronoi ev2;
ExampleDelaunay ed2;

void setup(){
  size(500, 500, P3D);
  rescale4CSV = width*2;
  //fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  esv = new ExampleSphericalVoronoi();
  ev2 = new ExampleVoronoi(2);
  ed2 = new ExampleDelaunay(2);
  //size(500, 500, P3D);
  ortho();
  strokeWeight(5);
  println(ev2.toCSV());
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
    esv = new ExampleSphericalVoronoi();
    ev2 = new ExampleVoronoi(2);
    ed2 = new ExampleDelaunay(2);
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