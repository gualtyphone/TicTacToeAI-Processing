class GA{
  final int POPULATION = 100;
  ArrayList<NeuralNet> populationX = new ArrayList<NeuralNet>();
  ArrayList<NeuralNet> populationO = new ArrayList<NeuralNet>();
  int generation = 0;
  int bestNet = 0;
  
  GA(){
    for (int i = 0; i < POPULATION; i++){
      populationX.add(new NeuralNet());
      populationO.add(new NeuralNet());
    }
    
    //Setting all network weights to random
    for (NeuralNet n : populationX){
      for (int i = 0; i < n.inMid.length; i++){
        n.inMid[i] = random(1);
      }
      for (int i = 0; i < n.midOut.length; i++){
        n.midOut[i] = random(1);
      }
    }
    for (NeuralNet n : populationO){
      for (int i = 0; i < n.inMid.length; i++){
        n.inMid[i] = random(1);
      }
      for (int i = 0; i < n.midOut.length; i++){
        n.midOut[i] = random(1);
      }
    }
  }
  
  NeuralNet getBest(){
    clearScores();
    scorePopulation();
    int scoreRecord = 0;
    for (int i = 0; i < POPULATION; i++){
      if (populationX.get(i).score > scoreRecord){
        scoreRecord = populationX.get(i).score;
        bestNet = i;
      }
    }
    return populationX.get(bestNet);
  }
  
  void oneGeneration(){
    generation++;
    clearScores();
    print(generation+" a ");
    scorePopulation();
    print(" b ");
    killAndReplace();
    print(" c ");
    print(" d\n");
    
  }
  
  void clearScores(){
    for (NeuralNet n : populationX){
      n.score = 0;
    }
    for (NeuralNet n : populationO){
      n.score = 0;
    }
  }
  
  void scorePopulation(){
    //until all networks have played against each other
    //take two networks and make them play against each other
    for (NeuralNet n1 : populationX){
      int won = 0;
      int count= 0;
      for (NeuralNet n2 : populationO){
        if (game(n1, n2)){
          won++;
        }
        count++;
      }
      if (won == count){
      wonAllGames = true;
      }
    }
  }
  void killAndReplace(){
    //find worst half of nets and remove() them
    //find best score 
    int scoreRecordX = 0;
    for (NeuralNet n : populationX){
      if (n.score > scoreRecordX){
        scoreRecordX = n.score;
      }
    }
    int scoreRecordO = 0;
    for (NeuralNet n : populationO){
      if (n.score > scoreRecordO){
        scoreRecordO = n.score;
      }
    }
    
    int killedX = 0;
    for (int j = 0; j < 50; j++){
      int scoreMin = 1000000000;
      int worstNet = 0;
      for (int i = 0; i < POPULATION-killedX; i++){
        if (populationX.get(i).score < scoreMin){
          scoreMin = populationX.get(i).score;
          worstNet = i;
        }
      }
      populationX.remove(worstNet);
      killedX++;
    }
    int killedO = 0;
    for (int j = 0; j < 50; j++){
      int scoreMin = 1000000000;
      int worstNet = 0;
      for (int i = 0; i < POPULATION-killedO; i++){
        if (populationO.get(i).score < scoreMin){
          scoreMin = populationO.get(i).score;
          worstNet = i;
        }
      }
      populationO.remove(worstNet);
      killedO++;
    }
    
    //create POPULATION/2 new networks
    for (int i = 0; i < POPULATION/2; i++){
      //select parents based on score
      int dice = 0;
      int n1;
      do{
        dice = (int)random(scoreRecordX);
        n1 = (int)random((POPULATION/2)-1);
      } while(populationX.get(n1).score <= dice);
      
      dice = (int)random(scoreRecordX);
      int n2;
      do{
        dice = (int)random(scoreRecordX);
        n2 = (int)random((POPULATION/2)-1);
      } while(populationX.get(n2).score <= dice);
      
      NeuralNet newNet = new NeuralNet();
      //set weights of new network based on parents weights
      for (int j = 0; j < newNet.inMid.length; j++){
        int parent = (int)random(0, 1);
        if (parent == 0){
          newNet.inMid[j] = populationX.get(n1).inMid[j];
        } else {
          newNet.inMid[j] = populationX.get(n2).inMid[j];
        }
      }
      for (int h = 0; h < newNet.midOut.length; h++){
        int parent = (int)random(0, 1);
        if (parent == 0){
          newNet.midOut[h] = populationX.get(n1).midOut[h];
        } else {
          newNet.midOut[h] = populationX.get(n2).midOut[h];
        }
      }
      mutate(newNet);
      populationX.add(newNet);
      killedX--;
    }
    
    //create POPULATION/2 new networks
    for (int i = 0; i < POPULATION/2; i++){
      //select parents based on score
      int dice = 0;
      int n1;
      do{
        dice = (int)random(scoreRecordO);
        n1 = (int)random((POPULATION/2)-1);
      } while(populationO.get(n1).score <= dice);
      
      dice = (int)random(scoreRecordO);
      int n2;
      do{
        dice = (int)random(scoreRecordO);
        n2 = (int)random((POPULATION/2)-1);
      } while(populationO.get(n2).score <= dice);
      
      NeuralNet newNet = new NeuralNet();
      //set weights of new network based on parents weights
      for (int j = 0; j < newNet.inMid.length; j++){
        int parent = (int)random(0, 1);
        if (parent == 0){
          newNet.inMid[j] = populationO.get(n1).inMid[j];
        } else {
          newNet.inMid[j] = populationO.get(n2).inMid[j];
        }
      }
      for (int h = 0; h < newNet.midOut.length; h++){
        int parent = (int)random(0, 1);
        if (parent == 0){
          newNet.midOut[h] = populationO.get(n1).midOut[h];
        } else {
          newNet.midOut[h] = populationO.get(n2).midOut[h];
        }
      }
      mutate(newNet);
      populationO.add(newNet);
      killedO--;
    }
  }
  
  void mutate(NeuralNet n){
    for (int j = 0; j < n.inMid.length; j++){
      if (random(100) < 3){
        n.inMid[j] += randomGaussian();
      }
      //n.inMid[j] = max(n.inMid[j], 0);
    }
    for (int h = 0; h < n.midOut.length; h++){
      if (random(100) < 3){
        n.midOut[h] += randomGaussian();
      }
      //n.midOut[h] = max(n.midOut[h], 0);
    }
  }
  
  boolean game(NeuralNet n1, NeuralNet n2){
    int winner = 0;
    int currentPlayer = 1;
    Board b = new Board();
    while(winner == 0){
      if (currentPlayer == 1){
        if (b.move(currentPlayer, n1.getNetworkMove(b.state))){
          n1.score += 20;
        } else {
          return false;
        }
      } else {
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
        if (b.move(currentPlayer, n2.getNetworkMove(invertedBoard))){
          n2.score += 20;
        } else {
          return false;
        }
      }
      currentPlayer++;
      if (currentPlayer > 2){
        currentPlayer = 1;
      }
      winner = b.checkWinner();
      if (winner == 0){
        int count = 0;
        for (int i = 0; i < b.state.length ; i++){
          if (b.state[i] != 0){
            count++;
          }
        }
        if (count == b.state.length){
          winner = 3;
        }
      }
    }
    if (winner == 1){
      n1.score += 100;
      return true;
    } else  if (winner == 2){
      n2.score += 100;
    } else if (winner == 3){
      n1.score += 50;
      n2.score += 50;
    }
    return false;
  }
}