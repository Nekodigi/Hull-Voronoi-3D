import java.util.Arrays;

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  color col = color(basehue, random(100), 100, 100);
  
  Polygon(){}
  
  Polygon(Simplex simplex){
    this.vertices = new ArrayList(Arrays.asList(simplex.vertices));
  }
  
  void show(){
    fill(col);
    beginShape();
    for(Vertex v : vertices){
      vertex(v.pos);
    }
    endShape(CLOSE);
  }
  
  boolean isValid(float threshold){
    int u = vertices.size()-1;
    for(int i = 0; i < vertices.size(); i++){
      float maxDist = 0;//calculate Height
      for(Vertex v : vertices){
        float dist = lineDistL(toPVec(v.pos), toPVec(vertices.get(u).pos), toPVec(vertices.get(i).pos));
        maxDist = max(dist, maxDist);
      }
      if(maxDist < threshold*2*rescale4CSV)return false;
      u = i;
    }
    return true;
  }
  
  String toCSV(){
    String result = "";
    for(Vertex v : vertices){
     result += String.valueOf(v.id)+ " ";
    }
    result = result.substring(0, result.length()-1);
    return result;
  }
}