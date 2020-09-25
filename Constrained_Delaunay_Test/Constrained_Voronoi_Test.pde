//I try out new method to add constraint and It goes well to some extent. However it sometimes cause error
//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean modeDelaunay = true;
ArrayList<Vertex> constrains = new ArrayList<Vertex>();

ExampleVoronoi ev2;
ExampleConstrainedDelaunay ed2;

void setup(){
  size(500, 500, P3D);
  //fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  constrains.add(new Vertex(0, -100, -100));
  constrains.add(new Vertex(0, 100, 0));
  constrains.add(new Vertex(0, 0, 100));
  //ev2 = new ExampleVoronoi(2);
  ed2 = new ExampleConstrainedDelaunay(2, constrains);
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
  if(key == 'n'){
    ed2.n();
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
  for(Vertex c : constrains){
    vertex(c.pos[0], c.pos[1]);
  }
  endShape(CLOSE);
}
