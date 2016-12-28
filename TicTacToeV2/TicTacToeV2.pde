Board b;
int boardW = 300, boardH = 300;
int currentPlayer = 1;
int winner = 0;

Button oneGen;
Button tenGen;
Button hundredGen;
Button currentGen;

GA ga;
NeuralNet n1; 
boolean busy = false;
boolean mode = true;

boolean wonAllGames = false;

void setup(){
  size(600, 600);
  b = new Board();
  ga = new GA();
  ga.oneGeneration();
  n1 = ga.getBest();
  oneGen = new Button("One Gen", 20, 300+(60), 260, 300+(60*2));
  tenGen = new Button("UntilFound", 20, 300+(60*3), 260, 300+(60*4));
  hundredGen = new Button("100 Gen", 320, 300+(60*1), 560, 300+(60*2));
  currentGen = new Button("Gen: "+str(ga.generation), 320, 300+(60*3), 560, 300+(60*4));
}

void draw(){
  background(0);
  b.draw(boardW, boardH);
  if (winner != 0){
    fill(0, 255, 0);
    textSize(50);
    text("winner = " + winner,boardW/2, boardH/2);
  }
  if (mode){
    int pos = n1.getNetworkMove(b.state);
    if (currentPlayer == 1){
      if (b.move(currentPlayer, pos)){
        winner = b.checkWinner();
      } else {
        winner = 2;
      }
      currentPlayer++;
      if (currentPlayer > 2){
        currentPlayer = 1;
      }
    }
  } else {
    if (currentPlayer == 2){
      int[] invertedBoard = new int[9];
      for (int i = 0; i < invertedBoard.length; i++){
        if (b.state[i] == 1){
          invertedBoard[i] = 2;
        } else if (b.state[i] == 2){
          invertedBoard[i] = 1;
        } else {
          invertedBoard[i] = 0;
        }
      }
      int pos = n1.getNetworkMove(invertedBoard);
      if (b.move(currentPlayer, pos)){
        winner = b.checkWinner();
      } else {
        winner = 2;
      }
      currentPlayer++;
      if (currentPlayer > 2){
        currentPlayer = 1;
      }
    }
  }
  n1.draw(300, 0, 600, 300, b.state);
  oneGen.draw();
  tenGen.draw();
  hundredGen.draw();
  currentGen.txt = "Gen: "+str(ga.generation);
  currentGen.draw();
}

void mousePressed(){
  if (winner == 0){
    if (mouseX < 300 && mouseY < 300){
      if ((currentPlayer == 2 && mode) || (currentPlayer == 1 && !mode)){
        int y = mouseX*3/boardW;
        int x = mouseY*3/boardH;
        int pos = (y*3)+x;
        b.move(currentPlayer, pos);
        currentPlayer++;
        if (currentPlayer > 2){
          currentPlayer = 1;
        }
      }
      winner = b.checkWinner();
    }
  }
  if (!busy){
    if (oneGen.isClicked()){
      busy = true;
      noLoop();
      ga.oneGeneration();
      loop();
      n1 = ga.getBest();
      busy = false;
    }
    if (tenGen.isClicked()){
      busy = true;
      noLoop();
      while(!wonAllGames){
        ga.oneGeneration();
      }
      loop();
      n1 = ga.getBest();
      wonAllGames = false;
      busy = false;
    }
    if (hundredGen.isClicked()){
      busy = true;
      //noLoop();
      int i = 0;
      while( i < 1000){
        ga.oneGeneration();
        i++;
        n1 = ga.getBest();
      }
      //loop();
      n1 = ga.getBest();
      busy = false;
    }
  }
}

void keyPressed(){
  if (key == 'r'){
    b = new Board();
    winner = 0;
    currentPlayer = 1;
  }
  if (key == 'm'){
    //mode = !mode;
  }
}