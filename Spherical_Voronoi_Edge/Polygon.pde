class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  color col = color(basehue, random(100), 100, 100);
  
  void show(){
    fill(col);
    beginShape();
    for(Vertex v : vertices){
      vertex(v.pos);
    }
    endShape(CLOSE);
  }
}