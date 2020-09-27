class Vertex{
  int dim;
  int id;
  int tag;
  float[] pos;
  
  Vertex(int id, float ... pos){
    dim = pos.length;
    this.pos = pos;
    this.id = id;
  }
}

class BVertex{//bezier BVertex; use like BVertex, quadraticBVertex, bezierBVertex
  float[] data;
  
  BVertex(float ... data){
    this.data = data;
  }
  
  PVector ctrl1(){//use when data.length >= 4
    return new PVector(data[0], data[1]);
  }
  
  PVector ctrl2(){//use when data.length >= 4
    return new PVector(data[2], data[3]);
  }
  
  PVector anchor(){
    return new PVector(data[data.length-2], data[data.length-1]);
  }
}
