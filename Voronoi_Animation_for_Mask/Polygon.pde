import java.util.Arrays;

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  color col = color(random(360));
  
  Polygon(){}
  
  Polygon(Simplex simplex){
    this.vertices = new ArrayList(Arrays.asList(simplex.vertices));
  }
  
  void show(){
    Vertex[] vs = vertices.toArray(new Vertex[vertices.size()]);
    float[] centor = avg(extractPos(vs));
    float[] base = {0, 0};                            //50                    500
    float theta = constrain(HALF_PI*3-float(frameCount)/50+dist(centor, base)/50, 0, TWO_PI);
    float fac = constrain(sin(theta), 0, 1);
    if(theta < HALF_PI){
      fac = 1;
    }
    fill(360-360*fac);
    fac = constrain(sin(theta-HALF_PI), 0, 1);
    if(theta < PI){
      fac = 1;
    }
    stroke(360-360*fac);
    beginShape();
    for(Vertex v : vertices){
      vertex(v.pos);
    }
    endShape(CLOSE);
  }
}
