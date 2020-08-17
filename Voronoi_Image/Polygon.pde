import java.util.Arrays;

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  color col = color(basehue, random(100), 100, 100);
  float[] centroid = new float[2];//assume 2d
  
  Polygon(){}
  
  Polygon(Simplex simplex){
    this.vertices = new ArrayList(Arrays.asList(simplex.vertices));
    calcCentroid();
  }
  
  void calcCentroid(){
    for(Vertex v : vertices){
      centroid = add(centroid, v.pos);
    }
    centroid = div(centroid, vertices.size());
  }
  
  void show(){
    fill(bicubic.colorAt(map(centroid[0], -width/2, width/2, 0, img.width), map(centroid[1], -height/2, height/2, 0, img.height)));
    beginShape();
    for(Vertex v : vertices){
      vertex(v.pos);
    }
    endShape(CLOSE);
  }
}
