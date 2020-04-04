//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean mode2D = true;

ExampleSphericalVoronoi esv;
ExampleVoronoi ev2;
ExampleDelaunay ed2;

void setup(){
  //size(500, 500, P3D);
  fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  esv = new ExampleSphericalVoronoi();
  ev2 = new ExampleVoronoi(new PVector(width/2, height/2));
  ed2 = new ExampleDelaunay(2);
  //size(500, 500, P3D);
  ortho();
  strokeWeight(5);
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
    esv = new ExampleSphericalVoronoi();
    ev2 = new ExampleVoronoi(new PVector(mouseX, mouseY));
    ed2 = new ExampleDelaunay(2);
  }
  if(key == 'm'){
    mode2D = !mode2D;
  }
}

void draw(){
  background(360);
  
  if(mode2D){
    ev2.show();
    ev2.relax(0.5);
  }else{
    translate(width/2, height/2);
      rotateX(float(frameCount)/400);
    rotateY(float(frameCount)/800);
    rotateZ(float(frameCount)/1600);
    esv.show();
    esv.relax(0.01);
  }
}