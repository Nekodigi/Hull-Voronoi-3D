import java.util.Arrays;
import java.util.Collections;

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  PVector[] normal;
  int n;
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
  
  boolean isClockwise(){
    float sum = 0;
    int u = vertices.size()-1;
    for(int i = 0; i < vertices.size(); i++){
      float[] v = vertices.get(u).pos;
      float[] v2 = vertices.get(i).pos;
      sum += (v[0]*v2[1] - v2[0]*v[1]);
      u = i;
    }
    if(sum > 0) return true;
    else return false;
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
  
  void offset(float thickness){
    if(isClockwise()){
      Collections.reverse(vertices);
    }
    n = vertices.size();
    calcNormal();
    int u = n-1;
    for(int i = 0; i < n; i++){
      PVector na = normal[u];PVector nb = normal[i];
      PVector bis = PVector.add(na, nb).normalize();
      float l = thickness*sqrt(2) / sqrt(1 + PVector.dot(na, nb));
      PVector pt = PVector.mult(bis, l);
      float[] t = {pt.x, pt.y};
      vertices.set(u, new Vertex(0, add(vertices.get(u).pos, t)));
      u = i;
    }
  }
  
  void calcNormal(){
    int u = n-1;
    normal = new PVector[n];
    for(int i = 0; i < n; i++){
      float[] ndir = normalize(sub(vertices.get(i).pos, vertices.get(u).pos));
      normal[i] = new PVector(ndir[1], -ndir[0]);
      u = i;
    }
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