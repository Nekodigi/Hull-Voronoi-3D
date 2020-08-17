class Simplex{
  int dim;
  // The simplexs adjacent to this simplex
  // For 2D a simplex will be a segment and it with have two adjacent segments joining it.
  // For 3D a simplex will be a triangle and it with have three adjacent triangles joining it.
  Simplex[] adjacent;
  // The vertices that make up the simplex.
  // For 2D a face will be 2 vertices making a line.
  // For 3D a face will be 3 vertices making a triangle.
  Vertex[] vertices;
  ArrayList<Vertex> beyondVertices;//vertices that positive side this face (same side as normal)
  Vertex furthestVertex;
  float maxDist;
  // The simplexs normal.
  float[] normal;
  Vertex circumC;//circumCenter
  float circumR;//circumRadius
  boolean isNormalFlipped;
  // The simplexs centroid.
  float[] centroid;
  // The simplexs offset from the origin.
  float offset;
  int tag;
  
  Simplex(int dim){
    if(dim < 2 || dim > 4){ throw new IllegalArgumentException("Invalid number of dimension for Simplex:"+dim);}
    this.dim = dim;
    adjacent = new Simplex[dim];
    normal = new float[dim];
    centroid = new float[dim];
    vertices = new Vertex[dim];
  }
  
  void calcCentroid(){
    centroid = avg(extractPos(vertices));
  }
  
  void setAllVerticesTag(int tag){
    for(int i = 0; i < dim; i++){
      vertices[i].tag = tag;
    }
  }
  
  void clearBeyond(){
    beyondVertices = new ArrayList<Vertex>();
    maxDist = Float.NEGATIVE_INFINITY;
    furthestVertex = null;
  }
  
  void show(){
    switch(vertices.length){
      case 2:
        line(vertices[0].pos, vertices[1].pos);
      case 3:
        beginShape();
        for(Vertex vertex : vertices){
          vertex(vertex.pos);
        }
        endShape(CLOSE);
    }
  }
  
  void calcCircumCenter(){
    switch(dim){
      case 3://triangle
        calcCircumTriangle();
        break;
      case 4://tetrahedra
        calcCircumTetra();
        break;
    }
  }
  
  void calcCircumTriangle(){//https://ja.wikipedia.org/wiki/%E5%A4%96%E6%8E%A5%E5%86%86
    float[] A = vertices[0].pos;
    float[] B = vertices[1].pos;
    float[] C = vertices[2].pos;
    float a = dist(B, C);
    float b = dist(C, A);
    float c = dist(A, B);
    float t1 = a*a*(b*b + c*c - a*a);
    float t2 = b*b*(c*c + a*a - b*b);
    float t3 = c*c*(a*a + b*b - c*c);
    float[] circumC_ = div(add(add(mult(A, t1), mult(B, t2)), mult(C, t3)), t1 + t2 + t3);
    circumC = new Vertex(0, circumC_);
    circumR = dist(circumC_, A);
  }
  
  void calcCircumTetra(){//https://math.stackexchange.com/questions/2414640/circumsphere-of-a-tetrahedron
    float[] v0 = vertices[0].pos;
    float[] v1 = vertices[1].pos;
    float[] v2 = vertices[2].pos;
    float[] v3 = vertices[3].pos;
    float[] u1 = sub(v1, v0);
    float[] u2 = sub(v2, v0);
    float[] u3 = sub(v3, v0);
    float sqrl01 = sqrDist(v0, v1);
    float sqrl02 = sqrDist(v0, v2);
    float sqrl03 = sqrDist(v0, v3);
    float[] u23c = cross(u2, u3);
    float[] u31c = cross(u3, u1);
    float[] u12c = cross(u1, u2);
    float[] t1 = add(add(mult(u23c, sqrl01), mult(u31c, sqrl02)), mult(u12c, sqrl03));
    float t2 = dot(mult(u1, 2), u23c);
    float[] circumC_ = add(v0, div(t1, t2));
    circumC = new Vertex(0, circumC_);
    circumR = dist(circumC_, v0);
  }
}
