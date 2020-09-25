import java.util.Comparator;

ArrayList<Vertex> getNotIth(ArrayList<Vertex> vs, int i){
  ArrayList<Vertex> result = new ArrayList<Vertex>();
  for(int j = 0; j < vs.size(); j++){
    if(j == i){continue;}
    result.add(vs.get(j));
  }
  return result;
}

Simplex[] getAdjHasVertex(Simplex simplex, Vertex v){
  Simplex[] result = new Simplex[simplex.adjacent.length-1];
  for(int j = 0, k = 0; j < simplex.adjacent.length; j++){
    if(simplex.adjacent[j] != null && hasItem(v, simplex.adjacent[j].vertices)){
      result[k++] = simplex.adjacent[j];
    }else continue;
  }
  return result;
}

class VertexIdComparator implements Comparator<Vertex> {
  @Override
  public int compare(Vertex a, Vertex b) {
    return a.id - b.id;
  }
}

boolean hasItem(Vertex v, Vertex[] vertices){
  for(Vertex v_ : vertices){
    if(v_ == v)return true;
  }
  return false;
}

float[] sphereSampling(float u, float theta){//https://mathworld.wolfram.com/SpherePointPicking.html
  float x = sqrt(1-u*u)*cos(theta);
  float y = sqrt(1-u*u)*sin(theta);
  float[] result = {x, y, u};
  return result;
}

ArrayList<Polygon> simplex2Poly(ArrayList<Simplex> simplexes){
  ArrayList<Polygon> result = new ArrayList<Polygon>();
  for(Simplex simplex : simplexes){
    result.add(new Polygon(simplex));
  }
  return result;
}

boolean contains(ArrayList<Integer> ids, int id){
  for(int i : ids){
    if(id == i)return true;
  }
  return false;
}

float[][] extractPos(Vertex ... vertices){
  float[][] result = new float[vertices.length][];
  for(int i = 0; i < vertices.length; i++){
    result[i] = vertices[i].pos;
  }
  return result;
}
