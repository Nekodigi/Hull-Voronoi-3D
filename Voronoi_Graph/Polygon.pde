import java.util.Arrays;

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  color col = color(basehue, random(100), 100, 100);
  
  Polygon(){}
  
  Polygon(Simplex simplex){
    this.vertices = new ArrayList(Arrays.asList(simplex.vertices));
  }
  
  void toGraph(){
    for(int i=0; i<vertices.size(); i++){
      Vertex a = vertices.get(i);
      Vertex b = vertices.get((i+1)%vertices.size());
      a.addAdj(b);
      b.addAdj(a);
    }
  }
  
  void show(){
    fill(col);
    beginShape();
    for(Vertex v : vertices){
      vertex(v.pos);
    }
    endShape(CLOSE);
  }
}
