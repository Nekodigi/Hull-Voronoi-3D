//based on this code https://github.com/Scrawk/Hull-Delaunay-Voronoi
float basehue = 0;
boolean mode3D = true;
float noiseS = 200;//500
float woff = 0;
float threshold = 0;
float maxSize = 250;//500 invisible big region for easy to understand
OpenSimplexNoise snoise = new OpenSimplexNoise();

ExampleVoronoi voronoi2D = new ExampleVoronoi(2);
ExampleVoronoi voronoi3D = new ExampleVoronoi(3);

void setup() {
  //fullScreen(P3D);
  size(500, 500, P3D);
  colorMode(HSB, 360, 100, 100, 100);
  voronoi2D = new ExampleVoronoi(2);
  voronoi3D = new ExampleVoronoi(3);
  ortho();
}

void keyPressed() {
  if (key == 'r') {
    basehue = random(360);
    voronoi2D = new ExampleVoronoi(2);
    voronoi3D = new ExampleVoronoi(3);
  }
  if (key == 'm') {
    mode3D = !mode3D;
  }
}

void draw() {
  fill(360, 50);
  lights();
  background(360);
  translate(width/2, height/2);
  if (mode3D) {
    rotateX(float(frameCount)/100);
    rotateY(float(frameCount)/500);
    rotateZ(float(frameCount)/1000);
    voronoi3D.show();
  } else {
    voronoi2D.show();
  }
  woff += 0.01;
}
