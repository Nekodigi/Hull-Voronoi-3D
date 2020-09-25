static class SimplexConnector{
  int[] vertices;//vertex indices.
  int hashCode;//the hash code computed from indices.
  Simplex face;
  int edgeIndex;//the edge to be connected
  
  SimplexConnector(Simplex face, int edgeIndex, int dim){
    vertices = new int[dim - 1];
    this.face = face;
    this.edgeIndex = edgeIndex;
    hashCode = 31;
    
    for(int i = 0, c = 0; i < dim; i++){
      if(i != edgeIndex){
        int v = face.vertices[i].id;
        vertices[c++] = v;
        hashCode += (23 * hashCode + v);
      }
    }
    
    Arrays.sort(vertices);
    
    hashCode = abs(hashCode);
  }
  
  static boolean areConnectable(SimplexConnector a, SimplexConnector b, int dim){
    if(a.hashCode != b.hashCode) return false;
    
    int n = dim - 1;
    for(int i = 0; i < n; i++){
      if(a.vertices[i] != b.vertices[i]) return false;
    }
    return true;
  }
  
  static void connect(SimplexConnector a, SimplexConnector b){
    a.face.adjacent[a.edgeIndex] = b.face;
    b.face.adjacent[b.edgeIndex] = a.face;
  }
}