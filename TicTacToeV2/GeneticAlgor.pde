class GA{
  final int POPULATION = 100;
  ArrayList<NeuralNet> populationX = new ArrayList<NeuralNet>();
  ArrayList<NeuralNet> populationO = new ArrayList<NeuralNet>();
  int generation = 0;
  int bestNet = 0;
  
  ArrayList<Integer> maxFitnesses = new ArrayList<Integer>();
  ArrayList<Integer> maxFitnessesO = new ArrayList<Integer>();

  ArrayList<Integer> avgFitnesses = new ArrayList<Integer>();
  ArrayList<Integer> avgFitnessesO = new ArrayList<Integer>();

  GA(){
    for (int i = 0; i < POPULATION; i++){
      populationX.add(new NeuralNet());
      populationO.add(new NeuralNet());
    }
    
    //Setting all network weights to random
    for (NeuralNet n : populationX){
      for (int i = 0; i < n.inMid.length; i++){
        n.inMid[i] = 1-random(2);
      }
      for (int i = 0; i < n.midOut.length; i++){
        n.midOut[i] = 1-random(2);
      }
    }
    for (NeuralNet n : populationO){
      for (int i = 0; i < n.inMid.length; i++){
        n.inMid[i] = 1-random(2);
      }
      for (int i = 0; i < n.midOut.length; i++){
        n.midOut[i] = 1-random(2);
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
    //print(generation+" a ");
    maxFitnesses.add(getBest().score);
    maxFitnessesO.add(getBestO().score);
    int avg = 0;
    int c = 0;
    for (NeuralNet n : populationX){
      avg += n.score;
      c++;
    }
    avgFitnesses.add(avg/c);
    avg = 0;
    c = 0;
    for (NeuralNet n : populationO){
      avg += n.score;
      c++;
    }
    avgFitnessesO.add(avg/c);
    //print(" b ");
    killAndReplace();
    //print(" c ");
    //print(" d\n");
    
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
    //for (NeuralNet n1 : populationX){
    //  game(n1);
    //}
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
    
    //print("b1");
    
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
        float parent = random(100);
        if (parent > 50){
          newNet.inMid[j] = populationX.get(n1).inMid[j];
        } else {
          newNet.inMid[j] = populationX.get(n2).inMid[j];
        }
      }
      for (int h = 0; h < newNet.midOut.length; h++){
        float parent = random(100);
        if (parent > 50){
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
        float parent = random(100);
        if (parent > 50){
          newNet.inMid[j] = populationO.get(n1).inMid[j];
        } else {
          newNet.inMid[j] = populationO.get(n2).inMid[j];
        }
      }
      for (int h = 0; h < newNet.midOut.length; h++){
        float parent = random(100);
        if (parent > 50){
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
      if ((int)random(0, 100) < 50){
        n.inMid[j] += randomGaussian();
      }
      n.inMid[j] = max(n.inMid[j], -1);
      n.inMid[j] = min(n.inMid[j], 1);
    }
    for (int h = 0; h < n.midOut.length; h++){
      if ((int)random(0, 100) < 50){
        n.midOut[h] += randomGaussian();
      }
      n.midOut[h] = max(n.midOut[h], -1);
      n.midOut[h] = min(n.midOut[h], 1);
    }
  }
  
  boolean game(NeuralNet n1){
    int winner = 0;
    int currentPlayer = 0;
    PPlayer p1 = new PPlayer();
    Board b = new Board();
    
    while(winner == 0){
      if (currentPlayer == 1){
        b.move(currentPlayer, n1.getNetworkMove(b.state));
        n1.score++;
      } else {
        int pos = p1.getMove(b.state);
        if(pos != -1){
          b.move(currentPlayer, pos);
        } else {
          //perfect player failed to give move
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
          n1.score+= 10;
        }
      }
      b.draw(boardW, boardH);
    }
    if (winner == 1){
      n1.score += 7;
    }
    return false;
  }
  
  boolean game(NeuralNet n1, NeuralNet n2){
    int winner = 0;
    int currentPlayer = 1;
    Board b = new Board();
    while(winner == 0){
      if (currentPlayer == 1){
        if (b.move(currentPlayer, n1.getNetworkMove(b.state))){
          //n1.score += 1;
        } else {
          //n1.score -= 5;
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
          //n2.score += 1;
        } else {
          //n2.score -= 5;
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
      n1.score += 2;
      //n2.score-=5;
      return true;
    } else  if (winner == 2){
      n2.score += 2;
      //n1.score-=5;
    } else if (winner == 3){
      n1.score += 1;
      n2.score += 1;
    }
    return false;
  }
  
  int getAvgFitness(){
    int avgFit = 0;
    int count = 0;
    for (NeuralNet n : populationX){
      avgFit += n.score;
      count++;
    }
    avgFit /= count;
    return avgFit;
  }
  
  int getBestFitness(){
    return getBest().score;
  }
  
  int getAvgFitnessO(){
    int avgFit = 0;
    int count = 0;
    for (NeuralNet n : populationO){
      avgFit += n.score;
      count++;
    }
    avgFit /= count;
    return avgFit;
  }
  
  int getBestFitnessO(){
    return getBestO().score;
  }
  
  NeuralNet getBestO(){
    clearScores();
    scorePopulation();
    int scoreRecord = 0;
    for (int i = 0; i < POPULATION; i++){
      if (populationO.get(i).score > scoreRecord){
        scoreRecord = populationO.get(i).score;
        bestNet = i;
      }
    }
    return populationO.get(bestNet);
  }
  
  void draw(int minX, int minY, int maxX, int maxY){
    rectMode(CORNERS);
    fill(#FFB803);
    stroke(0);
    rect(minX, minY, maxX, maxY);
    
    float spacePerGeneration = (float)(maxX - minX)/generation;
    int maxGenFitness = 0;
    for (int i = 0; i < generation; i++){
      if (maxFitnesses.get(i) > maxGenFitness){
        maxGenFitness = maxFitnesses.get(i);
      }
    }
    /*for (int i = 0; i < generation; i++){
      if (maxFitnessesO.get(i) > maxGenFitness){
        maxGenFitness = maxFitnessesO.get(i);
      }
    }*/
    float scaleHeight = (float)(maxY - minY)/ maxGenFitness;
    stroke(#030CFF);
    line(minX, maxY, minX+spacePerGeneration, maxY - (maxFitnesses.get(0)*scaleHeight));
    for (int i = 1; i < generation; i++){
      line(minX+(spacePerGeneration*i), maxY - (maxFitnesses.get(i-1)*scaleHeight), minX+(spacePerGeneration*(i+1)), maxY - (maxFitnesses.get(i)*scaleHeight));
      if (i == generation-1){
        fill(#030CFF);
        textAlign(LEFT);
        textSize(20);
        text("Best X", minX+(spacePerGeneration*(i+1)), maxY - (maxFitnesses.get(i)*scaleHeight));
      }
    }
    
    stroke(#FF0303);
    line(minX, maxY, minX+spacePerGeneration, maxY - (maxFitnessesO.get(0)*scaleHeight));
    for (int i = 1; i < generation; i++){
      line(minX+(spacePerGeneration*i), maxY - (maxFitnessesO.get(i-1)*scaleHeight), minX+(spacePerGeneration*(i+1)), maxY - (maxFitnessesO.get(i)*scaleHeight));
      if (i == generation-1){
        fill(#FF0303);
        textAlign(LEFT);
        textSize(20);
        text("Best Y", minX+(spacePerGeneration*(i+1)), maxY - (maxFitnessesO.get(i)*scaleHeight));
      }
    }
    
    stroke(#03FFFD);
    line(minX, maxY, minX+spacePerGeneration, maxY - (avgFitnesses.get(0)*scaleHeight));
    for (int i = 1; i < generation; i++){
      line(minX+(spacePerGeneration*i), maxY - (avgFitnesses.get(i-1)*scaleHeight), minX+(spacePerGeneration*(i+1)), maxY - (avgFitnesses.get(i)*scaleHeight));
      if (i == generation-1){
          fill(#03FFFD);
          textAlign(LEFT);
          textSize(20);
          text("Avg X", minX+(spacePerGeneration*(i+1)), maxY - (avgFitnesses.get(i)*scaleHeight));
        }
    }
    
    stroke(#FF03FB);
    line(minX, maxY, minX+spacePerGeneration, maxY - (avgFitnessesO.get(0)*scaleHeight));
    for (int i = 1; i < generation; i++){
      line(minX+(spacePerGeneration*i), maxY - (avgFitnessesO.get(i-1)*scaleHeight), minX+(spacePerGeneration*(i+1)), maxY - (avgFitnessesO.get(i)*scaleHeight));
      if (i == generation-1){
          fill(#FF03FB);
          textAlign(LEFT);
          textSize(20);
          text("Avg Y", minX+(spacePerGeneration*(i+1)), maxY - (avgFitnessesO.get(i)*scaleHeight));
        }
    }
  }
}