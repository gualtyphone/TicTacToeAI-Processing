class Button{
  int minX = 0;
  int minY = 0; 
  int maxX = 0;
  int maxY = 0;
  
  String txt = "NULL";
  
  Button(String _txt, int _minX, int _minY, int _maxX, int _maxY ){
    txt = _txt;
    minX = _minX;
    minY = _minY; 
    maxX = _maxX;
    maxY = _maxY;
  }
  
  void draw(){
    rectMode(CORNERS);
    fill(40);
    stroke(0);
    rect(minX, minY, maxX, maxY);
    fill(255);
    stroke(255);
    textSize(56);
    textAlign(CENTER, CENTER);
    text(txt, minX-((minX-maxX)/2), minY-((minY-maxY)/2));
  }
  
  boolean isClicked(){
    if (mouseX > minX && mouseX < maxX && mouseY > minY && mouseY < maxY){
      return true;
    }
    return false;
  }
}