Board b;
int boardW = 300, boardH = 300;
int currentPlayer = 1;
int winner = 0;

Button oneGen;
Switch untilFound;
Button hundredGen;
Button currentGen;
Switch versus;

GA ga;
NeuralNet n1;
NeuralNet n2;
boolean busy = false;

PPlayer p1;
Boolean vsPerfect = false;

Button avgFitness;
Button bestFitness;

boolean wonAllGames = false;

void setup(){
  size(900, 600);
  b = new Board();
  ga = new GA();
  ga.oneGeneration();
  n1 = ga.getBest();
  n2 = ga.getBestO();
  p1 = new PPlayer();
  currentGen = new Button("Gen: "+str(ga.generation),620, 10, 880, 40);
  avgFitness = new Button("avgFitness = 0", 620, 50, 880, 80);
  bestFitness = new Button("bestFitness = 0", 620, 90, 880, 120);
  untilFound = new Switch("Run Generations", "Stop Running",620,130, 880, 160);
  oneGen = new Button("One Gen", 620, 170, 880, 200);
  hundredGen = new Button("100 Gen ASAP",  620, 210, 880, 240);
  versus = new Switch("vs: O", "vs: X", 620, 90, 880, 120);
}

void draw(){
  if (untilFound.opt){
    ga.oneGeneration(); //<>//
    n1 = ga.getBest();
    n2 = ga.getBestO();
  }
  background(0);
  b.draw(boardW, boardH);
  if (winner != 0){
    fill(0, 255, 0);
    textSize(50);
    text("winner = " + winner,boardW/2, boardH/2);
  }
  if (winner == 0){
    if (vsPerfect){
      if (currentPlayer == 2){
        int pos = p1.getMove(b.state);
        if (pos != -1){
          b.move(currentPlayer, pos);
        }
        currentPlayer++;
        if (currentPlayer > 2){
          currentPlayer = 1;
        }
      }
    } else if (versus.opt){
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
        int pos = n2.getNetworkMove(invertedBoard);
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
  }
  if (versus.opt){
    n1.draw(300, 0, 600, 300, b.state);
  } else {
    n2.draw(300, 0, 600, 300, b.state);
  }
  oneGen.draw();
  untilFound.draw();
  hundredGen.draw();
  currentGen.txt = "Gen: "+str(ga.generation);
  currentGen.draw();
  avgFitness.txt = "avgFitness = "+ga.getAvgFitness();
  avgFitness.draw();
  versus.draw();
  //bestFitness.txt = "bestFitness = "+ga.getBestFitness();
  //bestFitness.draw();
  ga.draw(0,300,600,600);
}

void mousePressed(){
  if (winner == 0){
    if (mouseX < 300 && mouseY < 300){
      if ((currentPlayer == 2 && versus.opt) || (currentPlayer == 1 && !versus.opt)){
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
      n2 = ga.getBestO();
      busy = false;
    }
    if (hundredGen.isClicked()){
      busy = true;
      noLoop();
      int i = 0;
      while( i < 100){
        ga.oneGeneration();
        i++;
      }
      n1 = ga.getBest();
      n2 = ga.getBestO();
      loop();
      busy = false;
    }
    untilFound.isClicked();
    versus.isClicked();
  }
}

void keyPressed(){
  if (key == 'r'){
    b = new Board();
    winner = 0;
    currentPlayer = 1;
  }
  if (key == 'm'){
    vsPerfect = !vsPerfect;
  }
}