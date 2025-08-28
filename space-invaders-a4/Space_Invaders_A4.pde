// There are two main bugs that I couldn't correct that I wanted to detail before you experience them yourself (which you surely will):
// 1. When hit by an alien laser, sometimes more than one life will be taken, sometimes giving you an immediate game over
// I only ever change the livesRemaining variables when the collision occurs, so I don't know how to fix it
// 2. When you hit play again, the aliens are all supposed to "respawn," so in my gameReset method, i set all the values in the alienHit array
// to false. However, they still don't reset and the same aliens that were shot during the first game won't show up during the second game
// I couldn't figure how to fix either of them, so I figured I may as well own up to them here 

/***************************
 *                          *
 *      Stella Delorey      *
 *  Stella_Delorey_A4.pde   *
 *                          *
 *  ICS3U1 - Assignment 4   *
 *                          *
 *  Creating a recreation   *
 *  of Space Invaders to    *
 *  demonstrate ability to  *
 *  use arrays, the millis  *
 *  function, and PImages   *
 *                          *
 *     January 3, 2021      *
 *                          *
 ***************************/
int numColumns = 9, numRows = 3;
int numAliens = numColumns*numRows;
int numPlayerLives = 3;

PImage alienShip, shooter, logo;
PImage[] instructions = new PImage[2];
PImage[] easy = new PImage[2];
PImage[] medium = new PImage[2];
PImage[] hard = new PImage[2];
PImage lifeIcon;
PImage instructionsScreen;
int playerLivesRemaining;
int instructionsState, easyState, mediumState, hardState;
PImage leftArrow, rightArrow;
PImage playAgain, gameOver, playerWin;
int arrowState;
boolean arrowUp, arrowDown;
boolean[] buttonHover = new boolean[5];
int[] leftArrowX = {382, 330, 340, 330, 335};
int[] rightArrowX = {218, 270, 260, 270};
int[] arrowY = {400, 430, 460, 490};
float[][] alienXPos = new float[numAliens][numAliens];
float[][] alienYPos = new float[numAliens][numAliens];
boolean[][] alienHit = new boolean[numAliens][numAliens];
PImage[] alien = new PImage[6];
int[][] alienState = new int[numAliens][numAliens];
boolean shooterMoveLeft, shooterMoveRight;
boolean laserMoveRight, laserMoveLeft;
float shooterYPos;
float shooterXPos;
float shooterSpeed;
float laserYPos, laserXPos;
float lifeIconXPos;
float laserSpeed, alienSpeed;
float stopWatch, alienShipStopWatch;
float alienLaserXPos, alienLaserYPos, alienLaserSpeed;
float alienShipXPos, alienShipYPos, alienShipSpeed;
boolean alienShipHit;
int rate, alienShipRate;
// Checks if the laser line is in the laser or is in field of play
boolean shooterLoaded;
// Checks if space bad was pushed to shoot laser
boolean shootLaser;
// Checks if alien laser is behind an alien
boolean alienLaserLoaded;
int aliensRemaining;
int gameState;
boolean easyMode, mediumMode, hardMode;
float score;
float highScore = 0;

void setup() {
  size(600, 800);
  playerLivesRemaining = 3;
  leftArrow = loadImage("LeftFacingArrow.png");
  leftArrow.resize(10, 10);
  rightArrow = loadImage("RightFacingArrow.png");
  rightArrow.resize(10, 10);
  arrowState = 0;
  arrowUp = false;
  arrowDown = false;
  instructionsScreen = loadImage("instructionsScreen.png");
  instructionsScreen.resize(600, 800);
  instructions[0] = loadImage("InstructionsSI.png");
  instructions[0].resize(145, 10);
  instructions[1] = loadImage("InstructionsSI2.png");
  instructions[1].resize(145, 10);
  easy[0] = loadImage("Easy.png");
  easy[0].resize(40, 10);
  easy[1] = loadImage("Easy2.png");
  easy[1].resize(40, 10);
  medium[0] = loadImage("Medium.png");
  medium[0].resize(60, 10);
  medium[1] = loadImage("Medium2.png");
  medium[1].resize(60, 10);
  hard[0] = loadImage("Hard.png");
  hard[0].resize(40, 10);
  hard[1] = loadImage("Hard2.png");
  hard[1].resize(40, 10);
  alien[0] = loadImage("squidAlien1.png"); // Squid alien state 1
  alien[1] = loadImage("squidAlien2.png"); // Squid alien state 2
  alien[2] = loadImage("jellyFishAlien1.png"); // Jellyfish alien state 1
  alien[3] = loadImage("jellyfishAlien2.png"); // Jellyfish alien state 2
  alien[4] = loadImage("crabAlien1.png"); // Crab alien state 1
  alien[5] = loadImage("crabAlien2.png"); // Crab alien state 2
  alien[0].resize(25, 25);
  alien[1].resize(25, 25);
  alien[2].resize(35, 20);
  alien[3].resize(35, 20);
  alien[4].resize(35, 25);
  alien[5].resize(35, 25);
  alienShip = loadImage("alienShip.png");
  alienShip.resize(80, 30);
  shooter = loadImage("laser.PNG");
  logo = loadImage("SpaceInvadersLogo.png");
  logo.resize(400, 150);
  lifeIcon = loadImage("laser.PNG");
  lifeIcon.resize(40, 20);
  instructionsState = 1; // Arrows start hovering over instructions button
  easyState = 1; // Game starts on easy mode
  mediumState = 0;
  hardState = 0;
  shooterMoveLeft = false;
  shooterMoveRight = false;
  laserMoveLeft = false;
  laserMoveRight = false;
  shooterXPos = 300;
  shooterYPos = 760;
  shooterSpeed = 5;
  shooterLoaded = true;
  shootLaser = false;
  lifeIconXPos = 230;
  alienLaserLoaded = true;
  laserYPos = 760;
  laserXPos = shooterXPos;
  laserSpeed = 15;
  alienLaserSpeed = 7;
  alienSpeed = 7;
  setAlienPositions();
  setAlienLaserPosition();
  alienShipSpeed = 6;
  alienShipXPos = -40;
  alienShipYPos = 100;
  alienShipHit = false;
  aliensRemaining = numAliens;
  gameState = 1;
  alienShipRate = 100;
  rate = 300;
  score = 0;
  // Sets all aliens to alive (not yet hit)
  for (int i = 0; i < numColumns; i++) {
    for (int j = 0; j < numRows; j++) {
      alienHit[i][j] = false;
    }
  }
  for (int i = 0; i < 4; i++) {
    buttonHover[i] = false;
  }
  // Sets all alien types
  int e = 0;
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numColumns; col++) {
      alienState[row][col] = e;
    }
    e = e + 2;
  }
  gameOver = loadImage("GameOver.png");
  gameOver.resize(400, 55);
  playAgain = loadImage("playAgain.png");
  playAgain.resize(120, 10);
  playerWin = loadImage("playerWin.png");
  playerWin.resize(400, 55);
}

void draw() {
  background(#000000);
  difficultyModes();
  determineGameState();
}

void keyPressed() {
  if (gameState == 1) {
    if (keyCode == 38 /*Up arrow*/) {
      // Makes arrows loop when they hit the top option
      if (arrowState == 0) {
        arrowState = 3;
      } else {
        arrowState = arrowState - 1;
      }
    }
    if (keyCode == 40 /*Down arrow*/) {
      // Makes arrows loop when they hit the bottom option
      if (arrowState == 3) {
        arrowState = 0;
      } else {
        arrowState++;
      }
    }
    if (keyCode == 32 /*Space key*/) {
      if (buttonHover[0]) { // Instructions screen
        gameState = 2;
      }
      if (buttonHover[1]) { // Easy mode
        easyMode = true;
        mediumMode = false;
        hardMode = false;
        gameState = 3;
      }
      if (buttonHover[2]) { // Medium mode
        mediumMode = true;
        easyMode = false;
        hardMode = false;
        gameState = 3;
      }
      if (buttonHover[3]) { // Hard mode
        hardMode = true;
        mediumMode = false;
        easyMode = false;
        gameState = 3;
      }
    }
  }
  if (gameState == 2) {
    if (keyCode == 66) { // B key
      gameState = 1;
    }
  }
  if (gameState == 3) {
    if (keyCode == 39 /*Right arrow*/) {
      shooterMoveRight = true;
      laserMoveRight = true;
    }
    if (keyCode == 37 /*Left arrow*/) {
      shooterMoveLeft = true;
      laserMoveLeft = true;
    }
    if (keyCode == 32 /*Space bar*/) {
      if (shooterLoaded == true) {
        shootLaser = true;
      }
    }
  }
  if (gameState == 4 || gameState == 5) {
    if (keyCode == 32) { // Space bar
      gameReset();
      gameState = 1;
    }
  }
}

void keyReleased() {
  if (keyCode == 39 /*Right arrow*/) {
    shooterMoveRight = false;
    laserMoveRight = false;
  }
  if (keyCode == 37 /*Left arrow*/) {
    shooterMoveLeft = false;
    laserMoveLeft = false;
  }
}

void determineGameState() {
  if (gameState == 1) { // Start screen
    createStartScreen();
    buttonState();
    startScreenArrows();
    displayHighScore();
  }
  if (gameState == 2) { // Instructions screen
    createInstructionsScreen();
  }
  if (gameState == 3) { // Game
    createAliens();
    createLaser(laserXPos, laserYPos);
    createShooter(shooterXPos, shooterYPos);
    moveShooter();
    detectShooterHitEdge();
    detectLaserHitEdge();
    shootLaser();
    checkLaserHitTop();
    moveAliens();
    playerLaserCollision();
    detectAliensHitShooter();
    alienSpeedUp();
    displayScore();
    displayPlayerLives();
    createAlienLaser();
    alienShootLaser();
    alienLaserCollision();
    createAlienShip();
    moveAlienShip();
    determineHighScore();
  }
  if (gameState == 4) { // Win screen
    createWinScreen();
  }
  if (gameState == 5) { // Game over screen
    createLoseScreen();
  }
}

void startScreenArrows() {
  for (int i = 0; i <= 3; i++) {
    if (arrowState == i) {
      image(leftArrow, leftArrowX[i], arrowY[i]);
      image(rightArrow, rightArrowX[i], arrowY[i]);
      buttonHover[i] = true;
    } else {
      buttonHover[i] = false;
    }
  }
}

// Button colours when arrows pick them / hover over them
void buttonState() {
  if (buttonHover[0]) { // Instructions button
    instructionsState = 1;
  } else {
    instructionsState = 0;
  }
  if (buttonHover[1]) { // Easy mode button
    easyState = 1;
  } else {
    easyState = 0;
  }
  if (buttonHover[2]) { // Medium mode button
    mediumState = 1;
  } else {
    mediumState = 0;
  }
  if (buttonHover[3]) { // Hard mode button
    hardState = 1;
  } else {
    hardState = 0;
  }
}

void createStartScreen() {
  imageMode(CENTER);
  image(logo, 300, 250);
  image(instructions[instructionsState], 300, 400);
  image(easy[easyState], 300, 430);
  image(medium[mediumState], 300, 460);
  image(hard[hardState], 300, 490);
}

void createInstructionsScreen() {
  image(instructionsScreen, 300, 400);
}

void createShooter(float x, float y) {
  imageMode(CENTER);
  image(shooter, x, y);
  shooter.resize(90, 50);
}

void moveShooter() {
  if (shooterMoveRight == true) {
    shooterXPos = shooterXPos + shooterSpeed;
  }
  if (shooterMoveLeft == true) {
    shooterXPos = shooterXPos - shooterSpeed;
  }
}

void detectShooterHitEdge() {
  if (shooterXPos + 20 >= 600) {
    shooterXPos = shooterXPos - shooterSpeed;
  }
  if (shooterXPos - 20 <= 0) {
    shooterXPos = shooterXPos + shooterSpeed;
  }
}

void detectLaserHitEdge() {
  if (laserXPos >= 600 - 20) {
    laserXPos = laserXPos - shooterSpeed;
  }
  if (laserXPos <= 0 + 20) {
    laserXPos = laserXPos + shooterSpeed;
  }
}

// Creates laser line behind laser shooter
// Follows XPos of laser shooter
void createLaser(float x, float y) {
  stroke(#FFFFFF);
  strokeWeight(2);
  line(x, y, x, y + 7);
  if (shooterLoaded == true) {
    if (laserMoveRight == true) {
      laserXPos = laserXPos + shooterSpeed;
    }
    if (laserMoveLeft == true) {
      laserXPos = laserXPos - shooterSpeed;
    }
  }
}

void shootLaser() {
  if (shootLaser == true) {
    laserYPos = laserYPos - laserSpeed;
    shooterLoaded = false;
  }
}

void checkLaserHitTop() {
  if (laserYPos < 0) {
    laserYPos = 760;
    laserXPos = shooterXPos;
    shootLaser = false;
    shooterLoaded = true;
  }
}

// Base alien positions
// Does NOT put aliens on screen
// Called in setup
void setAlienPositions() {
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numColumns; col++) {
      alienXPos[row][col] = col*50+100;
      alienYPos[row][col] = row*50+100;
    }
  }
}

// Places aliens on screen
// Called when game starts
void createAliens() {
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numColumns; col++) {
      if (!alienHit[row][col]) { // Checks if alien should still be on screen
        image(alien[alienState[row][col]], alienXPos[row][col], alienYPos[row][col]);
      }
    }
  }
}

void createAlienShip() {
  if (!alienShipHit) {
    image(alienShip, alienShipXPos, alienShipYPos);
  }
}

void moveAlienShip() {
  if (millis()/alienShipRate - alienShipStopWatch > 0) {
    alienShipStopWatch = millis()/alienShipRate;
    // Waits until the top row of aliens reach the y coordinate 140 to move so they don't hit each other
    if (alienYPos[0][0] > 140) {
      alienShipXPos = alienShipXPos + alienShipSpeed;
    }
    // Turns around off screen to mimick timer in between its on screen return
    if (alienShipXPos >= 845) {
      alienShipSpeed = -1 * alienShipSpeed;
      alienShipHit = false;
    }
    if (alienShipXPos <= -245) {
      alienShipSpeed = -1 * alienShipSpeed;
      alienShipHit = false;
    }
  }
}

// Checks if each alien has been hit by the laser
void playerLaserCollision() {
  // Regular aliens
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numColumns; col++) {
      if (laserXPos >= alienXPos[row][col] - 20 && laserXPos <= alienXPos[row][col] + 20 &&
        laserYPos >= alienYPos[row][col] - 12 && laserYPos <= alienYPos[row][col] + 12 && alienHit[row][col] == false) {
        alienHit[row][col] = true;
        // Following reset laser
        laserYPos = 760;
        laserXPos = shooterXPos;
        shootLaser = false;
        shooterLoaded = true;
        aliensRemaining = aliensRemaining - 1;
        // Determines amount of points gained depending on alien type hit
        if (alienState[row][col] == 0 || alienState[row][col] == 1) {
          score = score + 40;
        } else if (alienState[row][col] == 2 || alienState[row][col] == 3) {
          score = score + 25;
        } else if (alienState[row][col] == 4 || alienState[row][col] == 5) {
          score = score + 15;
        }
      }
    }
  }
  // Alien ship
  if (laserXPos >= alienShipXPos - 40 && laserXPos <= alienShipXPos + 40 &&
    laserYPos >= alienShipYPos - 15 && laserYPos <= alienShipYPos + 15 && !alienShipHit) {
    alienShipHit = true;
    score = score + 100;
    laserYPos = 760;
    laserXPos = shooterXPos;
    shootLaser = false;
    shooterLoaded = true;
  }
}

void moveAliens() {
  if (millis()/rate - stopWatch > 0) {
    stopWatch = millis()/rate;
    boolean edgeHit = false;
    for (int row = 0; row < numRows && !edgeHit; row++) {
      for (int col = 0; col < numColumns && !edgeHit; col++) {
        // Checks if any alien has touched right edge
        if (alienXPos[row][col] <= 40 && !alienHit[row][col] || alienXPos[row][col] > 560 && !alienHit[row][col]) {
          edgeHit = true;
          for (int row2 = 0; row2 < numRows; row2++) {
            for (int col2 = 0; col2 < numColumns; col2++) {
              alienYPos[row2][col2] = alienYPos[row2][col2] + 10;
            }
          }
          // Changes direction of alien (speed becomes negative)
          alienSpeed = -1*alienSpeed;
        }
      }
    }
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numColumns; col++) {
        alienXPos[row][col] = alienXPos[row][col] + alienSpeed;
      }
    }
    // Changes animation states of aliens
    for (int row = 0; row < numRows; row++) {
      for (int col = 0; col < numColumns; col++) {
        if (alienState[row][col] == 0) {
          alienState[row][col] = 1;
        } else if (alienState[row][col] == 1) {
          alienState[row][col] = 0;
        } else if (alienState[row][col] == 2) {
          alienState[row][col] = 3;
        } else if (alienState[row][col] == 3) {
          alienState[row][col] = 2;
        } else if (alienState[row][col] == 4) {
          alienState[row][col] = 5;
        } else if (alienState[row][col] == 5) {
          alienState[row][col] = 4;
        }
      }
    }
  }
}

// Ends game if the aliens hit the bottom (the shooter)
void detectAliensHitShooter() {
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numColumns; col++) {
      if (alienYPos[row][col] >= 750 && alienHit[row][col] == false) {
        gameState = 5;
      }
    }
  }
}

void alienSpeedUp() {
  if (easyMode){
    if (aliensRemaining == 3) {
      rate = 300;
    } else if (aliensRemaining == 1) {
      rate = 150;
    }
  } else if (mediumMode){
    if (aliensRemaining == 3){
      rate = 80;
    } else if (aliensRemaining == 1){
      rate = 50;
    }
  } else if (hardMode){
    if (aliensRemaining == 3){
      rate = 35;
    } else if (aliensRemaining == 1){
      rate = 20;
    }
  }
  // Win condition is set here for convenience
  if (aliensRemaining <= 0) {
    gameState = 4; // Win screen
  }
}

// Sets alien laser position to one of the aliens directly above the shooter if it's alive
void setAlienLaserPosition() {
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numColumns; col++) {
      if (alienXPos[row][col] >= shooterXPos - 20 && alienXPos[row][col] <= shooterXPos + 20 && !alienHit[row][col]) {
        alienLaserXPos = alienXPos[row][col];
        alienLaserYPos = alienYPos[row][col];
      }
    }
  }
}

void createAlienLaser() {
  stroke(#FFFFFF);
  strokeWeight(2);
  line(alienLaserXPos, alienLaserYPos, alienLaserXPos, alienLaserYPos + 7);
}

void alienShootLaser() {
  if (alienLaserLoaded) {
    alienLaserYPos = alienLaserYPos + alienLaserSpeed;
  }
}

void alienLaserCollision() {
  // Alien laser collision with shooter
  if (alienLaserXPos >= shooterXPos - 20 && alienLaserXPos <= shooterXPos + 20 &&
    alienLaserYPos >= shooterYPos - 10 && alienLaserYPos <= shooterYPos + 10) {
    alienLaserHitObject();
    playerLivesRemaining = playerLivesRemaining - 1;
  }
  // Alien laser collision with bottom of screen
  if (alienLaserYPos >= 810) {
    alienLaserHitObject();
  }
}

// Referred to in alienLaserCollision();
void alienLaserHitObject() {
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numColumns; col++) {
      if (alienXPos[row][col] >= shooterXPos - 20 && alienXPos[row][col] <= shooterXPos + 20 && !alienHit[row][col]) {
        alienLaserXPos = alienXPos[row][col];
        alienLaserYPos = alienYPos[row][col];
      }
    }
  }
  shooterLoaded = true;
}

void displayPlayerLives() {
  text("Lives Remaining:", 150, 55);
  if (playerLivesRemaining == 3) {
    image(lifeIcon, 270, 50);
    image(lifeIcon, 310, 50);
    image(lifeIcon, 350, 50);
  } else if (playerLivesRemaining == 2) {
    image(lifeIcon, 270, 50);
    image(lifeIcon, 310, 50);
  } else if (playerLivesRemaining == 1) {
    image(lifeIcon, 270, 50);
  } else if (playerLivesRemaining == 0) { // Game over condition statement here for convenience
    gameState = 5;
  }
}

void displayScore() {
  text("Score : " + int(score), 420, 55);
}

// High score only remains for a singular sketch's duration
void determineHighScore() {
  if (score > highScore) {
    highScore = score;
  }
}

void displayHighScore() {
  text("Highscore: " + int(highScore), 267, 525);
}

void difficultyModes() {
  if (easyMode) {
    rate = 500;
    alienShipRate = 150;
    alienLaserSpeed = 7;
    laserSpeed = 15;
  } else if (mediumMode) {
    rate = 200;
    alienShipRate = 100;
    alienLaserSpeed = 12;;
    laserSpeed = 15;
  } else if (hardMode) {
    rate = 50;
    alienShipRate = 40;
    alienLaserSpeed = 15;
    laserSpeed = 20;
  }
}

void createWinScreen() {
  imageMode(CENTER);
  image(playerWin, 300, 350);
  image(playAgain, 300, 420);
}

void createLoseScreen() {
  imageMode(CENTER);
  image(gameOver, 300, 350);
  image(playAgain, 300, 420);
}

// Initializes all variables after player restarts game
void gameReset() {
  numColumns = 9;
  numRows = 3;
  numAliens = numColumns*numRows;
  numPlayerLives = 3;
  playerLivesRemaining = numPlayerLives;
  shooterMoveLeft = false;
  shooterMoveRight = false;
  laserMoveLeft = false;
  laserMoveRight = false;
  shooterXPos = 300;
  shooterYPos = 760;
  shooterSpeed = 5;
  shooterLoaded = true;
  shootLaser = false;
  lifeIconXPos = 230;
  alienLaserLoaded = true;
  laserYPos = 760;
  laserXPos = shooterXPos;
  laserSpeed = 15;
  alienLaserSpeed = 7;
  alienSpeed = 7;
  setAlienPositions();
  setAlienLaserPosition();
  alienShipSpeed = 6;
  alienShipXPos = -40;
  alienShipYPos = 100;
  alienShipHit = false;
  aliensRemaining = numAliens;
  gameState = 1;
  alienShipRate = 100;
  stopWatch = 0;
  alienShipStopWatch = 0;
  rate = 300;
  score = 0;
  setAlienPositions();
  setAlienLaserPosition();
  // Sets all alien types
  int e = 0;
  for (int row = 0; row < numRows; row++) {
    for (int col = 0; col < numColumns; col++) {
      alienState[row][col] = e;
    }
    e = e + 2;
  }
  // Sets all aliens to alive (not yet hit)
  for (int row = 0; row < numColumns; row++) {
    for (int col = 0; col < numRows; col++) {
      alienHit[row][col] = false;
    }
  }
}
