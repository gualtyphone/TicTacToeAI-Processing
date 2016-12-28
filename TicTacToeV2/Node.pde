class Node{
  float value = 0.0f;
  int count = 0;
  
  void in(float _in){
    value += _in;
    count++;
  }
  
  float out(){
    return value/count;
  }
}