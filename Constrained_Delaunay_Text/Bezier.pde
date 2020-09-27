class Bezier{//based on these site https://en.wikipedia.org/wiki/B%C3%A9zier_curve
  ArrayList<PVector> B = new ArrayList<PVector>();//control point and anchors
  
  Bezier(PVector P, BVertex VB){//assume 1 control point or 2
    B.add(P);
    if(VB.data.length >= 4)B.add(VB.ctrl1());
    if(VB.data.length >= 6)B.add(VB.ctrl2());
    B.add(VB.anchor());
  }

  PVector P(float t){
    PVector result = new PVector();
    for(int i = 0; i < B.size(); i++){
      result.add(PVector.mult(B.get(i), J(B.size()-1, i, t)));
    }
    return result;
  }

  float J(int n, int i, float t){
    float b = binomial(n, i);
    return b*pow(t, i)*pow(1-t, n-i);
  }
}
