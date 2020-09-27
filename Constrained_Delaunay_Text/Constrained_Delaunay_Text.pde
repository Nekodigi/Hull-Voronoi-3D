//can't draw charactor such as double circle

//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 250;
float spacing = 50;//sampling interval
boolean modeDelaunay = true;
ArrayList<ArrayList<float[]>> constraintss = new ArrayList<ArrayList<float[]>>();
ArrayList<ArrayList<BPath>> charactors;
ArrayList<Barrier> barriers = new ArrayList<Barrier>();

int numVertices = 800;
float size = 2000;

ExampleVoronoi ev2;
ExampleConstrainedDelaunay ed2;

void setup(){
  //size(500, 500, P3D);
  fullScreen(P3D);
  colorMode(HSB, 360, 100, 100, 100);
  //calculate font outline
  charactors = genPath("Arial", height/3, "Nekodigi", 0, -200);//delaunay vertex sampling range is(-width/2, width/2)... so offset text 
  for(ArrayList<BPath> charactor : charactors){
    for(BPath BPath : charactor){
      BPath.sample(spacing ,true);
    }
  }
  //ArrayList<float[]> constraints = new ArrayList<float[]>();
  for(int i=0; i<charactors.size(); i++){//charactors.size()
    ArrayList<BPath> bps = charactors.get(i);
    for(int j=0; j<bps.size(); j++){  //bps.size()
      BPath bp = bps.get(j);
      for(int k=0; k<bp.sampledPs.size(); k++){
        PVector A = bp.sampledPs.get(k);
        PVector B = bp.sampledPs.get((k+1)%bp.sampledPs.size());
        barriers.add(new Barrier(set(A.x, A.y), set(B.x, B.y)));
        //constraints.add(set(A.x, A.y));
      }
    }
  }
  for(int i=0; i<charactors.size(); i++){//charactors.size()
    ArrayList<BPath> bps = charactors.get(i);
    for(int j=0; j<bps.size(); j++){  //bps.size()
      ArrayList<float[]> constraints = new ArrayList<float[]>();
      BPath bp = bps.get(j);
      
      for(PVector p : bp.sampledPs){
        constraints.add(set(p.x, p.y));
      }
      //println(isPolygonOrientedClokwise(constraints));
      //if(!isPolygonOrientedClokwise(constraints)){
      //  constraints = changePolygonOrient(constraints);//println("flip:", i, j);
      //}
      constraintss.add(constraints);
    } 
  }
  //ev2 = new ExampleVoronoi(2);
  ed2 = new ExampleConstrainedDelaunay(2, constraintss, false);
  //ed2 = new ExampleConstrainedDelaunay(2, constraintss, true);
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
   Ray ray = new Ray(mouseX-width/2, mouseY-height/2, -1, 0, barriers);//println(barriers.size());
    ray.update();
    boolean inside = ray.inside;//println(inside, i, j);
    if(inside){
      ellipse(mouseX-width/2, mouseY-height/2, 100, 100);
    }
}
