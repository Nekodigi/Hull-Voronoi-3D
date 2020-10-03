void A_Star(){
  solving = true;
  openSet = new ArrayList<Vertex>();
  closedSet = new ArrayList<Vertex>();
  openSet.add(current);
  while(solving)A_Star_Step();
}

void A_Star_Step() {
  if(current.adj.size() != 0)println(current.adj.size());
  if (openSet.size() > 0) {
    Vertex winner = openSet.get(0);
    for (Vertex node : openSet) {
      if (node.getF() < winner.getF()) {
        winner = node;
      }
    }

    current = winner;
    openSet.remove(current);
    closedSet.add(current);
    for (Vertex neighbor : current.adj) {
      if (!closedSet.contains(neighbor)) {
        float tempG = neighbor.g = current.g + heuristic(neighbor, current);
        if (openSet.contains(neighbor)) {
          if (tempG < neighbor.g) {
            neighbor.g = tempG;
          }
        } else {
          neighbor.g = tempG;
          openSet.add(neighbor);
        }
        neighbor.h = heuristic(neighbor, end);
        neighbor.previous = current;
      }
    }
    if (current == end) {
      //println("DONE");
      solving = false;
    }
  } else {
    //println("NO SOLUTION");
    solving = false;
  }
  path = new ArrayList<Vertex>();
  Vertex temp = current;
  path.add(temp);
  while(temp.previous != null){
    path.add(temp.previous);
    temp = temp.previous;
  }
}

float heuristic(Vertex a, Vertex b){
  switch(heurType){
    case 0:
      return (a.pos[0]-b.pos[0]) * (a.pos[0]-b.pos[0]) + (a.pos[1]-b.pos[1]) * (a.pos[1]-b.pos[1]);
    case 1:
      return dist(a.pos[0], a.pos[1], b.pos[0], b.pos[1]);
    case 2:
      return abs(a.pos[0]-b.pos[0]) + abs(a.pos[1]-b.pos[1]);
    default:
      return 1;
  }
}

void showPath(){
  stroke(0, 100, 100, 100);
  strokeWeight(2);
  noFill();
  beginShape();
  for(Vertex node : path){
    vertex(node.pos[0], node.pos[1]);
  }
  endShape();
}
