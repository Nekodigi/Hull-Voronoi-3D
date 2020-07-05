import java.util.Arrays;
import java.util.Collections;

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Vertex> resVertices = new ArrayList<Vertex>(); 
  color col = color(random(360));
  PVector[] normal;
  int n;
  
  Polygon(){}
  
  Polygon(Simplex simplex){
    this.vertices = new ArrayList(Arrays.asList(simplex.vertices));
  }
  
  void show(){
    Vertex[] vs = vertices.toArray(new Vertex[vertices.size()]);
    float[] centor = avg(extractPos(vs));
    float[] base = {0, 0};                            //  500                    5000
    float theta = constrain(HALF_PI*2.1-float(frameCount)/50+dist(centor, base)/500, 0, TWO_PI);
    float fac = constrain(sin(theta), 0, 1);
    if(theta < HALF_PI){
      fac = 1;
    }
    float faco = fac*rescaleLine/20;//factor for offset
    //if(isValid(fac)){
      offset(faco);
      if(isValidTri())return;
    //}//           *10     
    fill(360-360*fac);
    theta = constrain(HALF_PI*3-float(frameCount)/50+dist(centor, base)/500, 0, TWO_PI);
    fac = constrain(sin(theta-HALF_PI), 0, 1);
    if(theta < PI){
      fac = 1;
    }
    stroke(360-360*fac);
    beginShape();
    for(Vertex v : resVertices){
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
      if(maxDist < threshold*2*rescaleLine)return false;
      u = i;
    }
    return true && isValidTri();
  }
  
  boolean isValidTri(){//assume this polygon is triangle
    if(resVertices.size() < 3)return true;//cant use
    calcNormal();
    if(normal.length == 0) return true;
    PVector A = toPVec(resVertices.get(0).pos);
    PVector B = toPVec(resVertices.get(1).pos);
    PVector n = normal[0];
    //line(A.x, A.y, A.x+n.x*100, A.y+n.y*100);
    //ellipse(B.x, B.y, 10, 10);
    float nd = n.dot(A) - n.dot(B);//which side of AC?
    return nd >= 0;
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
  
  void offset(float thickness){
    if(isClockwise()){
      Collections.reverse(vertices);
    }
    resVertices = new ArrayList<Vertex>();
    for(Vertex v : vertices){
      resVertices.add(new Vertex(v.id, v.pos));
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
      resVertices.set(u, new Vertex(0, add(vertices.get(u).pos, t)));
      u = i;
    }
    solveSelfIntersect();
  }
  
  void solveSelfIntersect(){
    n = vertices.size();
    if(n > 3){
      for(int i = 0; i < n; i++){
        int i2 = (i+1)%n;
        int i3 = (i+2)%n;
        int i4 = (i+3)%n;
        Vertex ve3 = vertices.get(i3);
        PVector v1 = toPVec(vertices.get(i).pos);
        PVector v2 = toPVec(vertices.get(i2).pos);
        PVector v3 = toPVec(ve3.pos);
        PVector v4 = toPVec(vertices.get(i4).pos);
        if(_Intersections.LineLine(v1, v2, v3, v4, true)){
          PVector interVec = _Intersections.GetLineLineIntersectionPoint(v1, v2, v3, v4);
          vertices.remove(i2);
          n = vertices.size();
          float[] t = {interVec.x, interVec.y};
          ve3.pos = t;
        }
      }
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
}
