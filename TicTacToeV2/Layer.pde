class Layer{
  Node[] nodes;
  int numNodes;
  
  Layer(int _numberOfNodes){
    numNodes = _numberOfNodes;
    nodes = new Node[numNodes+1];
    for (int i = 0; i < numNodes; i++){
      nodes[i] = new Node();
    }
    nodes[numNodes] = new Node();
    nodes[numNodes].value = 1;
    nodes[numNodes].count = 1;
  }
  
  void inputBoard(int[] state){
    for (int i = 0; i < numNodes; i++){
      nodes[i].value = 0.0f;
      nodes[i].count = 0;
    }
    for(int j = 0; j < 2; j++){
      for (int i = 0; i < state.length; i++){
        if (state[i] == j+1)
        {
          nodes[i+(j*9)].in(1);
        } else {
          nodes[i+(j*9)].in(0);
        }
      }
    }
  }
  
  void input(Layer prevLayer, float[] axons){
    for (int i = 0; i < numNodes;  i++){
      nodes[i].value = 0.0f;
      nodes[i].count = 0;
    }
    for (int y = 0; y < prevLayer.nodes.length; y++){
      for (int x = 0; x < numNodes;  x++){
        nodes[x].in(prevLayer.nodes[y].out() * axons[(x*prevLayer.numNodes)+y]);
      }
    }
  }
  
  void draw(int minX, int minY, int maxX, int maxY, int bestNode){
    int h = maxY-minY;
    int nodePosX = minX+ (maxX - minX)/2;
    int nodePosY = h / nodes.length;
    int nodeSize = nodePosY*80/100;
    for (int i =0; i < nodes.length; i++){
      float fillColor = (nodes[i].out())*255.0f;
      fill(fillColor);
      if (i == bestNode){
        stroke(0, 255, 0);
      }
      else {
        noStroke();
      }
      ellipse(nodePosX, minY+(nodePosY*i)+(nodeSize/2), nodeSize, nodeSize);
      textAlign(CENTER, CENTER);
      textSize(7);
      fill(255 - fillColor);
      String text = str(nodes[i].out());
      text(text, nodePosX, minY+(nodePosY*i)+(nodeSize/2));
    }
  }
  
  void draw(int minX, int minY, int maxX, int maxY, float[] axons, Layer nextLayer){
    int h = maxY-minY;
    int nodePosX = minX+ (maxX - minX)/2;
    int nodePosY = h / nodes.length;
    int nodeSize = nodePosY*80/100;
    int node2PosX = minX+(maxX - minX) + (maxX - minX)/2;
    int node2PosY = h / nextLayer.nodes.length;
    int node2Size = node2PosY*80/100;
    for (int i =0; i < nodes.length; i++){
      for (int j = 0; j < nextLayer.numNodes; j++){
        stroke(calculateColor(axons[(j*numNodes)+i]));
        line(nodePosX, minY+(nodePosY*i)+(nodeSize/2), node2PosX, minY+(node2PosY*j)+(node2Size/2));
      }
      float fillColor = (nodes[i].out())*255.0f;
      fill(fillColor);
      noStroke();
      ellipse(nodePosX, minY+(nodePosY*i)+(nodeSize/2), nodeSize, nodeSize);
      textAlign(CENTER, CENTER);
      textSize(7);
      fill(255 - fillColor);
      String text = str(nodes[i].out());
      text(text, nodePosX, minY+(nodePosY*i)+(nodeSize/2));
    }
  }
  
  color calculateColor(float axon){
    color finalColor  = color(0, 0, 0);
    if (axon >= 0){
      finalColor = color(0, axon *255.0f, 0);
    } else {
      finalColor = color(abs(axon)*255.0f, 0, 0);
    }
    return finalColor;
  }
  
  String coolify(float val){
    int v = (int)(Math.round(val*100));
    if (v >= 0){
      if(v == 100){
        return "1";
      }else if(v < 10){
        return ".0"+v;
      }else{
        return "."+v;
      }
    } else {
      v = abs(v);
      if(v == 100){
        return "-1";
      }else if(v < 10){
        return "-.0"+v;
      }else{
        return "-."+v;
      }
    }
  }
  
  int bestNode(){
    int best = 0;
    float worldRecord = 0;
    for (int i = 0; i < numNodes; i++){
      if(nodes[i].out() > worldRecord){
        best = i;
        worldRecord = nodes[i].out();
      }
    }
    return best;
  }
  
}