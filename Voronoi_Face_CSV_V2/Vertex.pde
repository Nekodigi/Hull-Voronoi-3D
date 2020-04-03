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
  
  String toCSV(){//only 2d
    return pos[0]/rescale4CSV + " " + pos[1]/rescale4CSV;
  }
}