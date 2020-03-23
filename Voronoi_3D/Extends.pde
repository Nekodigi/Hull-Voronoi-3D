void triangle(float[] a, float[] b, float[] c){
  beginShape();
  vertex(a);
  vertex(b);
  vertex(c);
  endShape(CLOSE);
}

void line(float[] a, float[] b){
  switch(min(a.length, b.length)){
    case 2:
      line(a[0], a[1], b[0], b[1]);
      break;
    case 3:
      line(a[0], a[1], a[2], b[0], b[1], b[2]);
      break;
  }
}

void point(float[] p){
  strokeWeight(50);
  switch(p.length){
    case 2:
      point(p[0], p[1], 0);
      break;
    case 3:
      point(p[0], p[1], p[2]);
      break;
  }
  strokeWeight(20);
}

void vertex(float[] p){
  switch(p.length){
    case 2:
      vertex(p[0], p[1], 0);
      break;
    case 3:
      vertex(p[0], p[1], p[2]);
      break;
  }
}