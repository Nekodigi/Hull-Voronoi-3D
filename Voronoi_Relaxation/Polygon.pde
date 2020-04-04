import java.util.Arrays;

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  color col;// = color(basehue, random(100), 100, 100);
  Vertex baseVertex;
  
  Polygon(){}
  
  Polygon(Simplex simplex){
    this.vertices = new ArrayList(Arrays.asList(simplex.vertices));
  }
  
  void setBaseVertex(Vertex v){
    baseVertex = v;
    col = v.col;
  }
  
  void show(){
    fill(col);
    beginShape();
    for(Vertex v : vertices){
      vertex(v.pos);
    }
    endShape(CLOSE);
  }
  
  float[] Centroid()
  {
      float[] centroid = {0, 0};
      double signedArea = 0.0;
      double x0 = 0.0; // Current vertex X
      double y0 = 0.0; // Current vertex Y
      double x1 = 0.0; // Next vertex X
      double y1 = 0.0; // Next vertex Y
      double a = 0.0;  // Partial signed area
  
      // For all vertices except last
      int i=0;
      for (i=0; i<vertices.size()-1; ++i)
      {
          x0 = vertices.get(i).pos[0];
          y0 = vertices.get(i).pos[1];
          x1 = vertices.get(i+1).pos[0];
          y1 = vertices.get(i+1).pos[1];
          a = x0*y1 - x1*y0;
          signedArea += a;
          centroid[0] += (x0 + x1)*a;
          centroid[1] += (y0 + y1)*a;
      }
  
      // Do last vertex separately to avoid performing an expensive
      // modulus operation in each iteration.
      x0 = vertices.get(i).pos[0];
      y0 = vertices.get(i).pos[1];
      x1 = vertices.get(0).pos[0];
      y1 = vertices.get(0).pos[1];
      a = x0*y1 - x1*y0;
      signedArea += a;
      centroid[0] += (x0 + x1)*a;
      centroid[1] += (y0 + y1)*a;
  
      signedArea *= 0.5;
      centroid[0] /= (6.0*signedArea);
      centroid[1] /= (6.0*signedArea);
  
      return centroid;
  }
  
  void relax(float fac){
    float[] npos;
    if(baseVertex.pos.length == 2){
      npos = Centroid();
    }else{
      npos = avg(extractPos(vertices.toArray(new Vertex[vertices.size()])));
    }
    baseVertex.pos =lerp(npos, baseVertex.pos, fac);
  }
}