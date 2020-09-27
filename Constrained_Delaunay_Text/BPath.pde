class BPath{//bezier path
  ArrayList<BVertex> vertices = new ArrayList<BVertex>();
  ArrayList<PVector> sampledPs = new ArrayList<PVector>();//sampled evenly spaced points(polygon)
  
  //void update(){
  //  for(PVector p : sampledPs){
  //    float angle = noise(p.x/noiseS, p.y/noiseS)*TWO_PI*8;
  //    p.x += cos(angle)*noiseP;
  //    p.y += sin(angle)*noiseP;
  //  }
  //}
  
  void showSampledPs(){
    for(PVector p : sampledPs){
      vertex(p.x, p.y);
    }
  }
  
  void sample(float spacing, boolean containsAnchor){
    //calculate evenly spaced points https://www.youtube.com/watch?v=d9k97JemYbM
    float resolution = 1;//higher valkue to get better points
    sampledPs = new ArrayList<PVector>();
    PVector previousP = vertices.get(0).anchor();
    sampledPs.add(previousP);//add start point
    for(int i = 1; i<vertices.size(); i++){
      BVertex BVertex = vertices.get(i);
      switch(BVertex.data.length){
        case 2://when line
          previousP = linearSampling(previousP, BVertex.anchor(), spacing);
          break;
        case 4://when 1 control point bezier(quadratic)
          Bezier bezier = new Bezier(previousP, BVertex);
          float controlNetLength = PVector.dist(previousP, BVertex.ctrl1()) + PVector.dist(BVertex.ctrl1(), BVertex.anchor());
          float estimatedLength = PVector.dist(previousP, BVertex.anchor()) + controlNetLength/2;
          int divisions = int(estimatedLength*resolution*10);
          for(float t = 0; t < 1; t+= 1./divisions){
            PVector pointOnCurve = bezier.P(t);
            previousP = linearSampling(previousP, pointOnCurve, spacing);
          }
          break;
        case 6://when 2 control point bezier
          bezier = new Bezier(previousP, BVertex);
          controlNetLength = PVector.dist(previousP, BVertex.ctrl1()) + PVector.dist(BVertex.ctrl1(), BVertex.ctrl2()) + PVector.dist(BVertex.ctrl2(), BVertex.anchor());
          estimatedLength = PVector.dist(previousP, BVertex.anchor()) + controlNetLength/2;
          divisions = int(estimatedLength*resolution*10);
          for(float t = 0; t < 1; t+= 1./divisions){
            PVector pointOnCurve = bezier.P(t);
            previousP = linearSampling(previousP, pointOnCurve, spacing);
          }
          break;        
      }
      if(containsAnchor){
        previousP = BVertex.anchor();//use when want exact edge, but some points are collided
        sampledPs.add(previousP);
      }
    }
  }
  
  PVector linearSampling(PVector A, PVector B, float spacing){//sampled point on AB but, not contains A and B
    float dstSinceLastEvenPoint = PVector.dist(A, B);//add distance between two BVertex
    while(dstSinceLastEvenPoint >= spacing){
      float overshootDst = dstSinceLastEvenPoint - spacing;
      PVector newEvenlySpacedPoint = PVector.add(B, PVector.sub(A, B).setMag(overshootDst));//liner interpolate
      sampledPs.add(newEvenlySpacedPoint);
      dstSinceLastEvenPoint = overshootDst;
      A = newEvenlySpacedPoint.copy();
    }
    return A;//return last sampled point
  }
  
  void addBVertex(float ... x){
    vertices.add(new BVertex(x));
  }
}
