class CommonExample{
  ArrayList<Polygon> polygons = new ArrayList<Polygon>();
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  ArrayList<Vertex> input = new ArrayList<Vertex>();
  int numVertices = 100;
  float size = 200;
  int dim = 2;
  
  CommonExample(){
    for(int i = 0; i < numVertices; i++){
      input.add(new Vertex(0, random(-size, size), random(-size, size)));//id will be assigned later
    }
  }
  
  void setSuper(ArrayList<Polygon> polygons_, ArrayList<Vertex> vertices_){
    this.polygons = polygons_;
    this.vertices = vertices_;println(polygons_.size());
  }
  
  String toCSV(String fname){
    int i = 0;
    for(Polygon polygon : polygons){
      for(Vertex v : polygon.vertices){
        v.id = i++;
      }
    }
    String str = Vert2CSV() + "/" + Face2CSV();
    PrintWriter output;
    output = createWriter(fname);
    output.print(str);
    output.close();
    return str;
  }
  
  String Face2CSV(){
    String result = "";
    for(Polygon polygon : polygons){
      result += polygon.toCSV()+"\n";
    }
    return result.substring(0, result.length()-1);
  }
  
  String Vert2CSV(){
    String result = "";
    int i = 0;
    for(Polygon polygon : polygons){
      for(Vertex v : polygon.vertices){
        v.id = i++;
        result += v.toCSV()+"\n";
      }
    }
    return result.substring(0, result.length()-1);
  }
  
  void offset(float thickness){
    for(int i = polygons.size()-1; i >= 0; i--){
      Polygon polygon = polygons.get(i);
      if(polygon.isValid(thickness)){
        polygon.offset(thickness*rescale4CSV);
      }else polygons.remove(polygon);
    }
  }
  
  void show(){
    stroke(0);
    for(Polygon polygon : polygons){
      polygon.show();
    }
  }
}

class ExampleVoronoi extends CommonExample{
  Voronoi voronoi;
  
  ExampleVoronoi(){
    super();
    voronoi = new Voronoi(2);
    voronoi.Generate(input);
    setSuper(voronoi.polygons, voronoi.Vvertices);
  }
}

class ExampleDelaunay extends CommonExample{
  Delaunay delaunay;
  
  ExampleDelaunay(){
    super();
    delaunay = new Delaunay(2);
    delaunay.Generate(input);
    setSuper(delaunay.polygons, delaunay.vertices);
  }
}