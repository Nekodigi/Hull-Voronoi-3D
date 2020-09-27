//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean modeDelaunay = true;
ArrayList<float[]> constraints = new ArrayList<float[]>();

int numVertices = 200;
float size = 200;

ExampleVoronoi ev2;
ExampleConstrainedDelaunay ed2;

void setup(){
  size(500, 500, P3D);
  //fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  constraints.add(set(-150, -100));//if clockwise withhole, if counterclockwise clipped delaunay
  constraints.add(set(0, 100));
  constraints.add(set(100, 0));
  constraints.add(set(0, 20));
  //constraints = changePolygonOrient(constraints);
  println(isPolygonOrientedClokwise(constraints));
  
  //ev2 = new ExampleVoronoi(2);
  ed2 = new ExampleConstrainedDelaunay(2, constraints, true);
  //size(500, 500, P3D);
  ortho();
  strokeWeight(5);
}

void keyPressed(){
  if(key == 'r'){
    basehue = random(360);
    //ev2 = new ExampleVoronoi(2);
    //ed2 = new ExampleDelaunay(2);
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
  noFill();
  beginShape();
  for(float[] c : constraints){
    vertex(c[0], c[1]);
  }
  endShape(CLOSE);
}
