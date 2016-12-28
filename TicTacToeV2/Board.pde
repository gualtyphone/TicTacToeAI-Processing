class Board{
  int[] state = new int[9];
  
  Board(){
    for (int i = 0; i < 9; i++){
      state[i] = 0;
    }
  }
  
  boolean move(int player, int pos){
    if (state[pos] == 0){
      state[pos] = player;
      return true;
    } else {
      return false;
    }
  }
  
  int checkWinner(){
    if (checkSolved(1)){
      return 1;
    } else if (checkSolved(2)){
      return 2;
    } else {
      return 0;
    }
  }
  
  boolean checkSolved(int player){
    for(int i = 0; i < 3; i++){
      if (state[(i*3)+0] == player &&
          state[(i*3)+1] == player &&
          state[(i*3)+2] == player){
            return true;
      }
    }
    for(int i = 0; i < 3; i++)
    {
      if (state[(i)+0] == player &&
          state[(i)+3] == player &&
          state[(i)+6] == player){
        return true;
      }
    }
    if(state[0] == player &&
       state[4] == player &&
       state[8] == player){
         return true;
       }
     if(state[2] == player &&
       state[4] == player &&
       state[6] == player){
         return true;
       }
    return false;
  }
  
  void draw(int w, int h){
    rectMode(CORNER);
    for (int i = 0; i < state.length; i++){
      int x = (int)i/3;
      int y = (int)i%3;
      fill(240);
      stroke(10);
      String print = " ";
      switch (state[i]){
        case 0:
          print = " ";
          fill(240);
        break;
        case 1:
          print = "X";
          fill(0, 0, 255);
        break;
        case 2:
          print = "O";
          fill(255, 0, 0);
        break;
      }
      rect(x*(w/3),y*(h/3), w/3, h/3);
      textAlign(CENTER, CENTER);
      textSize(64);
      stroke(0);
      fill(0);
      text(print, x*(w/3)+(w/3)/2,(y*(h/3))+(h/3)/2);
    }
  }
}