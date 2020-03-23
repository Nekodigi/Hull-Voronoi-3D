//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi

boolean mode3D = false;

ExampleVoronoi voronoi2D = new ExampleVoronoi(2);
ExampleVoronoi voronoi3D = new ExampleVoronoi(3);

void setup(){
  fullScreen(P3D);
  //size(500, 500, P3D);
  ortho();
}

void keyPressed(){
  if(key == 'r'){
    voronoi2D = new ExampleVoronoi(2);
    voronoi3D = new ExampleVoronoi(3);
  }
  if(key == 'm'){
    mode3D = !mode3D;
  }
}

void draw(){
  lights();
  background(200);
  translate(width/2, height/2);
  if(mode3D){
    rotateX(float(frameCount)/100);
    rotateY(float(frameCount)/500);
    rotateZ(float(frameCount)/1000);
    voronoi3D.show();
  }else{
    voronoi2D.show();
  }
}