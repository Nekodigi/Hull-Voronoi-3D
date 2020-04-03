//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;

ExampleSphericalVoronoi esv;

void setup(){
  size(500, 500, P3D);
  //fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  esv = new ExampleSphericalVoronoi();
  //size(500, 500, P3D);
  ortho();
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
    esv = new ExampleSphericalVoronoi();
  }
}

void draw(){
  background(360);
  translate(width/2, height/2);
  rotateX(float(frameCount)/500);
  rotateY(float(frameCount)/1000);
  rotateZ(float(frameCount)/2000);
  esv.show();
}