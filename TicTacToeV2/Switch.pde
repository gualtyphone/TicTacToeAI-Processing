class Switch extends Button{
  
  boolean opt = false;
  String opt1;
  String opt2;
  
  Switch(String _opt1, String _opt2, int _minX, int _minY, int _maxX, int _maxY){
    super( _opt1,  _minX,  _minY,  _maxX,  _maxY );
    opt1 = _opt1;
    opt2 = _opt2;
  }
  
  boolean isClicked(){
    if (super.isClicked()){
      opt = !opt;
      if (opt){
        super.txt = opt2;
      } else {
        super.txt = opt1;
      }
      return true;
    }
    return false;
  }
}