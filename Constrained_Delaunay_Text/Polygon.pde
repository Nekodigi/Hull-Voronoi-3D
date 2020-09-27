import java.util.Arrays;
int sampleN = 4;//number of sample to get true data
float sampleRange = 1;//sample in (-sample~sample)

class Polygon{
  ArrayList<Vertex> vertices = new ArrayList<Vertex>();
  color col = color(basehue, random(100), 100, 100);
  
  Polygon(){}
  
  Polygon(Simplex simplex){
    this.vertices = new ArrayList(Arrays.asList(simplex.vertices));
  }
  
  void show(){
    fill(col);
    Vertex[] vs = vertices.toArray(new Vertex[vertices.size()]);
    float[] centor = avg(extractPos(vs));
    int count = 0;//sample 10 around(because sometime produce wrong data)
    for(int i=0; i<sampleN; i++){
      Ray ray = new Ray(centor[0]+random(-sampleRange, sampleRange), centor[1]+random(-sampleRange, sampleRange), -1, 0, barriers);//println(barriers.size());
      ray.update();
      boolean inside = ray.inside;//println(inside, i, j);
      if(inside)count++;
    }
    //ray = new Ray(centor[0]+1, centor[1]+1, -1, 0, barriers);//println(barriers.size());
    //ray.update();
    //inside = inside || ray.inside;//println(inside, i, j);
    if(count>sampleN/2)return;
    beginShape();
    for(Vertex v : vertices){
      vertex(v.pos);
    }
    endShape(CLOSE);
    //ellipse(centor[0], centor[1], 10, 10);
  }
}
