//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean modeDelaunay = false;
PImage img;
BicubicImage bicubic;

ExampleVoronoi ev2;
ExampleDelaunay ed2;

void setup(){
  size(500, 500, P3D);
  img = loadImage("FevCat.png");
  bicubic = new BicubicImage(img);
  //fullScreen(P3D);
  //colorMode(HSB, 360, 100, 100, 100);
  ev2 = new ExampleVoronoi(2);
  ed2 = new ExampleDelaunay(2);
  //size(500, 500, P3D);
  ortho();
  strokeWeight(5);
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
    ev2 = new ExampleVoronoi(2);
    ed2 = new ExampleDelaunay(2);
  }
  if(key == 'm'){
    modeDelaunay = !modeDelaunay;
  }
}

void draw(){
  background(255);
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
