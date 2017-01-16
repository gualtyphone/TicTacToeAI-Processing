class PPlayer{
  int getMove(int[] board){
    int[] invertedBoard = new int[9];
    for (int x = 0; x < invertedBoard.length; x++){
      if (board[x] == 1){
        invertedBoard[x] = 2;
      } else if (board[x] == 2){
        invertedBoard[x] = 1;
      } else {
        invertedBoard[x] = 0;
      }
    }
    for (int i = 0; i < 9; i++){
      //print(invertedBoard[i]);
    }
    //print("\n");
    for (int j = 0; j < solutionO.length; j+= 9){
      
      int same = 9;
      for (int i = 0; i < 9; i++){
        if(invertedBoard[i] != solutionO[j+i]){
          same--;
          if (solutionO[j+i] == 1){
            same++;
          }
        }
      }
      
      if (same == 9){
        
        for (int x = 0; x < 9; x++){
          //print(solutionO[x+j]);
        }
        for (int i = 0; i < 9; i++){
          if (invertedBoard[i] != solutionO[j+i]){
            
            return i;
          }
        }
      }
    }
    return -1;
  }
}