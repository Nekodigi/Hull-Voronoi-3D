//it changes Simplex data
class EdgeLS{//edge linked to two simplex
  Simplex A, B;
  int aA, aB;//which adj is B in A, which adj is A in B;
  
  EdgeLS(Simplex A, Simplex B){
    this.A = A;
    this.B = B;
    calcaAB();
    A.edges[aA] = this;
    B.edges[aB] = this;
  }
  
  public void calcaAB(){
    aA = 0; aB = 0;
    if(A.adjacent[1] == B)aA = 1;
    if(A.adjacent[2] == B)aA = 2;
    if(aA == 0 && A.adjacent[0] != B)println(A, "error", A.adjacent[0], A.adjacent[1], A.adjacent[2]);
    if(B.adjacent[1] == A)aB = 1;
    if(B.adjacent[2] == A)aB = 2;
    if(aB == 0 && B.adjacent[0] != A)println(B, "error", B.adjacent[0], B.adjacent[1], B.adjacent[2]);
  }
  
  public void flip(){
    //have to reculculate aA, aB;
    calcaAB();
   
    Vertex v1 = A.vertices[aA];
    Vertex v2 = A.vertices[(aA+1)%3];
    Vertex v3 = A.vertices[(aA+2)%3];
    Vertex v4 = B.vertices[aB];
    int v2b = 0, v3b = 0;//v2, v3 vertex index in B
    if(v2.id == B.vertices[(aB+1)%3].id){v2b = (aB+1)%3;v3b = (aB+2)%3;}
    if(v2.id == B.vertices[(aB+2)%3].id){v2b = (aB+2)%3;v3b = (aB+1)%3;}
    //if(v2b == 0 && v2.id != B.vertices[(aB)%3].id)println("error2");
    Simplex C = new Simplex(3);
    Simplex D = new Simplex(3);
    int c0 = 0, c2 = 0;
    int d0 = 0, d2 = 0;
    if(B.adjacent[v3b] != null){
      if (B.adjacent[v3b].adjacent[1] == B)c0 = 1;
      if (B.adjacent[v3b].adjacent[2] == B)c0 = 2;
      //if(c0 == 0 && B.adjacent[v3b].adjacent[0] != B)println("error3");
      B.adjacent[v3b].adjacent[c0] = A;
      EdgeLS e = B.edges[v3b];
      C.edges[0] = e;
      if(e != null){
        if(e.A == B)e.A = A;
        if(e.B == B)e.B = A;
      }
    }
    if(A.adjacent[(aA+2)%3] != null){
      if (A.adjacent[(aA+2)%3].adjacent[1] == A)c2 = 1;
      if (A.adjacent[(aA+2)%3].adjacent[2] == A)c2 = 2;
      A.adjacent[(aA+2)%3].adjacent[c2] = A;
      EdgeLS e = B.edges[(aA+2)%3];
      C.edges[2] = e;
    }
    if(B.adjacent[v2b] != null){
      if (B.adjacent[v2b].adjacent[1] == B)d0 = 1;
      if (B.adjacent[v2b].adjacent[2] == B)d0 = 2;
      B.adjacent[v2b].adjacent[d0] = B;
      EdgeLS e = B.edges[v2b];
      D.edges[0] = e;
    }
    if(A.adjacent[(aA+1)%3] != null){
      if (A.adjacent[(aA+1)%3].adjacent[1] == A)d2 = 1;
      if (A.adjacent[(aA+1)%3].adjacent[2] == A)d2 = 2;
      A.adjacent[(aA+1)%3].adjacent[d2] = B;//println("ba", A.adjacent[(aA+1)%3], A.edges[(aA+1)%3].A, A.edges[(aA+1)%3].B);
      EdgeLS e = A.edges[(aA+1)%3];
      D.edges[2] = e;
      if(e != null){
        if(e.A == A)e.A = B;
        if(e.B == A)e.B = B;
      }
    }
    
    C.vertices[1] = v2;
    C.adjacent[1] = B;
    C.vertices[0] = v1;
    C.adjacent[0] = B.adjacent[v3b];
    C.vertices[2] = v4;
    C.adjacent[2] = A.adjacent[(aA+2)%3];
    D.vertices[1] = v3;
    D.adjacent[1] = A;
    D.vertices[0] = v1;
    D.adjacent[0] = B.adjacent[v2b];
    D.vertices[2] = v4;
    D.adjacent[2] = A.adjacent[(aA+1)%3];
    A.vertices = C.vertices;
    A.adjacent = C.adjacent;
    A.edges = C.edges;
    B.vertices = D.vertices;
    B.adjacent = D.adjacent;
    B.edges = D.edges;
    
     //println("inter calc");
    if(B.adjacent[v3b] != null){
      EdgeLS e = B.edges[v3b];
      if(e != null)e.calcaAB();//println(A, B, e.A, e.B);
    }println("to2");
    if(A.adjacent[(aA+2)%3] != null){
      EdgeLS e = B.edges[(aA+2)%3];
      if(e != null)e.calcaAB();
    }println("to3");
    if(B.adjacent[v2b] != null){
      EdgeLS e = B.edges[v2b];
      if(e != null)e.calcaAB();
    }println("to4");
    if(A.adjacent[(aA+1)%3] != null){
      EdgeLS e = A.edges[(aA+1)%3];
      if(e != null)e.calcaAB();//println(A, B, e.A, e.B);
    }
    
    aA = 1;
    aB = 1;
    A.edges[1] = this;
    B.edges[1] = this;
    //println("last calc");
    calcaAB();
  }
}
