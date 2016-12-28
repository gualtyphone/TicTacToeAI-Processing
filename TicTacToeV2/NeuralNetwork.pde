class NeuralNet{
  Layer inLayer = new Layer(18);
  Layer midLayer= new Layer(27);
  Layer outLayer= new Layer(9);
  float[] inMid;
  float[] midOut;
  
  int score = 0;
  
  NeuralNet(){
    inMid = new float[inLayer.numNodes*midLayer.nodes.length];
    midOut = new float[midLayer.numNodes*outLayer.nodes.length];
  }
  
  int getNetworkMove(int[] state){
    inLayer.inputBoard(state);
    midLayer.input(inLayer, inMid);
    outLayer.input(midLayer, midOut);
    return outLayer.bestNode();
  }
  
  
  void draw(int minX, int minY, int maxX, int maxY, int[] state){
    rectMode(CORNERS);
    fill(40);
    noStroke();
    rect(minX, minY, maxX, maxY);
    
    // first layer
    int w1 = (maxX-minX)/3;
    inLayer.draw(minX+(w1*0), minY, minX+(w1*1), maxY, inMid, midLayer);
    midLayer.draw(minX+(w1*1), minY, minX+(w1*2), maxY, midOut, outLayer);
    int move = getNetworkMove(state);
    outLayer.draw(minX+(w1*2), minY, minX+(w1*3), maxY, move);
    
    
    
  }
}