import java.util.Arrays;
import java.util.Collections;

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<PVector> offsetV = new ArrayList<PVector>(); 
  ArrayList<PVector> resV = new ArrayList<PVector>(); 
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
    float theta = constrain(HALF_PI*2.1-float(frameCount)/500+dist(centor, base)/5000, 0, TWO_PI);
    float fac = constrain(sin(theta), 0, 1);
    if(theta < HALF_PI){
      fac = 1;
    }
    float faco = fac*rescaleLine/20;//factor for offset
    offset(-faco);
    //if(!isValidCo())return;
    //               *10     
    fill(360-360*fac*10);
    //fill(360);
    theta = constrain(HALF_PI*3-float(frameCount)/50+dist(centor, base)/500, 0, TWO_PI);
    fac = constrain(sin(theta-HALF_PI), 0, 1);
    if(theta < PI){
      fac = 1;
    }
    stroke(360-360*fac);
    beginShape();
    for(PVector v : resV){
      vertex(v);
    }
    endShape(CLOSE);
  }
  
  void solveSelfIntersection(float thickness){//we can use for convex hull
    calcNormal();
    resV = new ArrayList<PVector>();
    //calclate self intersections
    for(int i=0; i<offsetV.size(); i++){
      PVector A = offsetV.get(i);
      PVector B = offsetV.get((i+1)%offsetV.size());
      resV.add(A);
      for(int j=0; j<offsetV.size(); j++){//we might improve this
        PVector C = offsetV.get(j);
        PVector D = offsetV.get((j+1)%offsetV.size());
        PVector p = intersection(A, B, C, D);
        if(p != null){
          //ellipse(p.x*scale, p.y*scale, 10, 10);
          resV.add(p);
        }
      }
    }
    //delete illegal points
    for(int i=0; i<vertices.size(); i++){
      PVector A = toPVec(vertices.get(i).pos);
      PVector C = toPVec(vertices.get((i+vertices.size()-1)%vertices.size()).pos);
      for(int j=resV.size()-1; j>=0; j--){
        //if(j != i && j != (i+vertices.length-1)%vertices.length){
          PVector B = resV.get(j);
          float nd = lineDist(B, A, C);//which side of AC?
          //line(A.x*scale, A.y*scale, A.x*scale+n.x*100, A.y*scale+n.y*100);
          nd = isClockwise() ? nd : -nd;
          if((nd > thickness+EPSILON*10)){//println(thickness, nd);
            //ellipse(B.x*scale, B.y*scale, 10, 10);
            resV.remove(j);
          }
        //}
      }
    }
    //Temporary method to prevent over offset which create very big triangle 
    if(thickness < -EPSILON && resV.size() >=3)if(!PointPolygon(toPVec(vertices), resV.get(0)) && !PointPolygon(toPVec(vertices), resV.get(1)) && !PointPolygon(toPVec(vertices), resV.get(2))){
      resV = new ArrayList<PVector>();
    }
  }
  
  //boolean isValidCo(){//check valid. !we can use this for only convex full: we should use solveIntersection instead of this
  //  calcNormal();
  //  boolean result = true;
  //  for(int i=0; i<offsetV.size(); i++){
  //    PVector A = offsetV.get(i);
  //    for(int j=0; j<vertices.size(); j++){ 
  //      if(j != i && j != (i+offsetV.size()-1)%offsetV.size()){
  //        PVector B = offsetV.get(j);
  //        PVector n = normal[i];
  //        //line(A.x, A.y, A.x+n.x*100, A.y+n.y*100);
  //        //ellipse(B.x, B.y, 10, 10);
  //        float nd = n.dot(A) - n.dot(B);//which side of AC?
  //        boolean whichSide = nd >= 0;
  //        boolean isValid = isClockwise() ? whichSide : !whichSide;
  //        result = result && isValid;//println(isValid, i, j);
  //      }
  //    }
  //  }
  //  return result;
  //}
  
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
    float fixedThickness = isClockwise() ? thickness : -thickness;
    
    if(isClockwise()){
      Collections.reverse(vertices);
    }
    offsetV = new ArrayList<PVector>();
    for(Vertex v : vertices){
      offsetV.add(toPVec(v.pos));
    }
    n = vertices.size();
    calcNormal();
    int u = n-1;
    for(int i = 0; i < n; i++){
      PVector na = normal[u];PVector nb = normal[i];
      PVector bis = PVector.add(na, nb).normalize();
      float l = fixedThickness*sqrt(2) / sqrt(1 + PVector.dot(na, nb));
      PVector pt = PVector.mult(bis, l);
      //float[] t = {pt.x, pt.y};
      //offsetV.set(u, PVector.add(vertices.get(u).pos, t)));
      offsetV.get(u).add(pt.x, pt.y);
      u = i;
    }
    solveSelfIntersection(thickness);
  }
  
  //void solveSelfIntersect(){
  //  n = vertices.size();
  //  if(n > 3){
  //    for(int i = 0; i < n; i++){
  //      int i2 = (i+1)%n;
  //      int i3 = (i+2)%n;
  //      int i4 = (i+3)%n;
  //      Vertex ve3 = vertices.get(i3);
  //      PVector v1 = toPVec(vertices.get(i).pos);
  //      PVector v2 = toPVec(vertices.get(i2).pos);
  //      PVector v3 = toPVec(ve3.pos);
  //      PVector v4 = toPVec(vertices.get(i4).pos);
  //      if(_Intersections.LineLine(v1, v2, v3, v4, true)){
  //        PVector interVec = _Intersections.GetLineLineIntersectionPoint(v1, v2, v3, v4);
  //        vertices.remove(i2);
  //        n = vertices.size();
  //        float[] t = {interVec.x, interVec.y};
  //        ve3.pos = t;
  //      }
  //    }
  //  }
  //}
  
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

 
