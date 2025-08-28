PVector position, velocity, gravity, titlePosition, titleVelocity, titleGravity;
float elasticity, titleElasticity; 
PImage background, startButton, title, titleCharacter, titlePlatform, blackHole, pageRip;
PImage gameOver, menuButton, yourScoreText, yourHighscoreText, playAgainButton;
PImage[] character = new PImage [4];
int numPlatforms = 20;
int gameState;
PImage[] platform = new PImage [4];
int[] platformType = {0, 1, 0, 1, 0, 0, 2, 0, 1, 2, 0, 1, 0, 0, 0, 2, 1, 0, 0, 1};
// Sets first positions of platforms
float[] platformXPos = {60, 270, 130, 250, 350, 100, 250, 280, 450, 230, 100, 80, 400, 360, 450, 300, 250, 350, 90, 270};
float[] originalPlatformXPos = {60, 270, 130, 250, 350, 100, 250, 280, 450, 230, 100, 80, 400, 360, 450, 300, 250, 350, 90, 270};
float[] platformYPos = {790, 760, 730, 700, 650, 600, 550, 520, 430, 400, 360, 265, 290, 240, 200, 120, 80, 60, 40, 10};
float[] originalPlatformYPos = {790, 760, 730, 700, 650, 600, 550, 520, 430, 400, 360, 265, 290, 240, 200, 120, 80, 60, 40, 10};
float platformHitY;
boolean platformHit;
float platformSpeed[] = new float [numPlatforms];
int characterAnimationState;
boolean characterLeft, characterRight;
boolean characterJump, characterShoot;
boolean gameStart;
boolean mouseOverStartButton, mouseOverMenuButton, mouseOverPlayAgainButton;
int score;
int highscore;
int scoreStopwatch;

void setup(){
  size(500, 800);
  position = new PVector(250, 500);
  velocity = new PVector(0, 0);
  gravity = new PVector(0, 0.3);
  titlePosition = new PVector(150, 400);
  titleVelocity = new PVector(0, 0);
  titleGravity = new PVector(0, 0.3);
  elasticity = 10;
  titleElasticity = 10;
  character[0] = loadImage("characterLeftStretch.png");
  character[1] = loadImage("characterRightStretch.png");
  character[2] = loadImage("characterShoot.png");
  for (int i = 0; i < 3; i++){
    character[i].resize(60, 60);
  }
  platform[0] = loadImage("greenPlatform.png");
  platform[1] = loadImage("bluePlatform.png");
  platform[2] = loadImage("whitePlatform.png");
  platform[3] = loadImage("brokenPlatform.png");
  startButton = loadImage("doodleJumpPlayButton.png");
  startButton.resize(150, 150);
  title = loadImage("doodleJumpTitle.png");
  title.resize(350, 250);
  titleCharacter = loadImage("characterRightStretch.png");
  titleCharacter.resize(60, 60);
  titlePlatform = loadImage("greenPlatform.png");
  titlePlatform.resize(90, 80);
  pageRip = loadImage("pageRip.png");
  pageRip.resize(500, 350);
  blackHole = loadImage("blackHole.png");
  blackHole.resize(250, 250);
  for (int i = 0; i < 4; i++){
    // Resizes all platforms to the same proportions
    platform[i].resize(90, 80);
  }
    for (int i = 0; i < numPlatforms; i++){
    // Sets all platform speeds to the same rate
    platformSpeed[i] = 3;
  }
  gameStart = false;
  characterAnimationState = 1;
  background = loadImage("doodleJumpBackground.png");
  background.resize(500, 800);
  characterLeft = false;
  characterRight = false;
  characterShoot = false;
  characterJump = true;
  numPlatforms = 20;
  gameState = 1;
  score = 0;
  highscore = 0;
  platformHit = false;
  mouseOverStartButton = false;
  mouseOverPlayAgainButton = false;
  mouseOverMenuButton = false;
  gameOver = loadImage("gameOver.png");
  gameOver.resize(300, 300);
  yourScoreText = loadImage("yourScoreText.png");
  yourScoreText.resize(180, 180);
  yourHighscoreText = loadImage("yourHighscoreText.png");
  yourHighscoreText.resize(220, 200);
  playAgainButton = loadImage("playAgainButton.png");
  playAgainButton.resize(150, 150);
  menuButton = loadImage("menuButton.png");
  menuButton.resize(150, 150);
}


void draw(){
  background(background);
  detectHighscore();
  detectMouseOverButtons();
  if (gameState == 1){ // Start screen
    createStartScreen();
    if (gameStart){
      initializeGame();
      gameState = 2;
    }
  } else if (gameState == 2){ // Game
    createCharacter();
    bounceCharacter();
    moveCharacter();
    checkCharacterHitEdge();
    createPlatforms();
    platformCharacterCollision();
    movePlatformsWithCharacter();
    checkPlatformHitBottom();
    moveBluePlatform();
    bluePlatformHitSide();
    whitePlatformCollision();
    createTopBoard();
    displayScore();
  } else if (gameState == 3){ // Lose screen
    createGameOverScreen();
  }
}

void keyPressed(){
  if (gameState == 2){
    if (keyCode == 37){ // Left arrow
      characterLeft = true;
    }
    if (keyCode == 39){ // Right arrow
      characterRight = true;
    }
  }
}

void keyReleased(){
  if (gameState == 2){
    if (keyCode == 37){ // Left arrow
      characterLeft = false;
    }
    if (keyCode == 39){ // Right arrow
      characterRight = false;
    }
  }
}

void mouseClicked(){
  if (gameState == 1){
    if (mouseOverStartButton){
      gameStart = true;
    }
  } else if (gameState == 3){
    if (mouseOverMenuButton){
      gameState = 1;
    } else if (mouseOverPlayAgainButton){
      initializeGame();
      gameState = 2;
    }
  }
}

void createStartScreen(){
  imageMode(CENTER);
  image(title, 200, 100);
  image(startButton, 200, 220);
  image(titleCharacter, titlePosition.x, titlePosition.y);
  image(titlePlatform, 150, 600);
  titleCharacterBounce();
  titleCharacterPlatformCollision();
  image(blackHole, 30, 720);
  image(pageRip, 250, 760);
  image(blackHole, 400, 250);
  fill(#000000);
  image(yourScoreText, 150, 330);
  text(score, 250, 330);
  image(yourHighscoreText, 150, 380);
  text(highscore, 270, 383);
}

void titleCharacterBounce(){
  titleVelocity.add(titleGravity);
  titlePosition.add(titleVelocity);
}

void titleCharacterPlatformCollision(){
  if (titlePosition.x >= 150 - 45 && titlePosition.x <= 150 + 45 && titlePosition.y >= 600 - 40 && titlePosition.y <= 600 + 40){
    titleVelocity.y = 0;
    titleVelocity.y = -titleElasticity;
  }
}

void detectMouseOverButtons(){
  if (gameState == 1){
    if (mouseX >= 200 - 75 && mouseX <= 200 + 75 && mouseY >= 220 - 75 && mouseY <= 220 + 75){
      mouseOverStartButton = true;
    } 
  } else if (gameState == 3){
    if (mouseX >= 250 - 75 && mouseX <= 250 + 75 && mouseY >= 480 - 75 && mouseY <= 480 + 75){
      mouseOverPlayAgainButton = true;
    } else if (mouseX >= 250 - 75 && mouseX <= 250 + 75 && mouseY >= 550 - 75 && mouseY <= 550 + 75){
      mouseOverMenuButton = true;
    }
  }
}

void initializeGame(){
  for (int i = 0; i < 4; i++){
    // Resizes all platforms to the same proportions
    platform[i].resize(90, 80);
  }
  for (int i = 0; i < numPlatforms; i++){
    // Sets all platform speeds to the same rate
    platformSpeed[i] = 3;
  }
  for (int i = 0; i < numPlatforms; i++){
    platformXPos[i] = originalPlatformXPos[i];
    platformYPos[i] = originalPlatformYPos[i];
  }
  position = new PVector(250, 500);
  velocity = new PVector(0, 0);
  gravity = new PVector(0, 0.3);
  titlePosition = new PVector(150, 400);
  titleVelocity = new PVector(0, 0);
  titleGravity = new PVector(0, 0.3);
  elasticity = 10;
  titleElasticity = 10;
    for (int i = 0; i < numPlatforms; i++){
    // Sets all platform speeds to the same rate
    platformSpeed[i] = 3;
  }
  gameStart = false;
  characterAnimationState = 1;
  characterLeft = false;
  characterRight = false;
  characterShoot = false;
  characterJump = true;
  numPlatforms = 20;
  gameState = 1;
  score = 0;
  platformHit = false;
  mouseOverStartButton = false;
  mouseOverPlayAgainButton = false;
  mouseOverMenuButton = false;
}

void createCharacter(){
  image(character[characterAnimationState], position.x, position.y);
}

void createTopBoard(){
  rectMode(CORNER);
  fill(#ABDDFC);
  strokeWeight(3);
  rect(-5, -5, 510, 35);
}

void bounceCharacter() { 
  velocity.add(gravity);
  if (characterJump){
    position.add(velocity);
  }
}

void moveCharacter(){
  if (characterLeft){
    characterAnimationState = 0;
    position.x = position.x - 7;
  } else if (characterRight){
    characterAnimationState = 1;
    position.x = position.x + 7;
  }
}

void checkCharacterHitEdge(){
  if (platformHit){
    velocity.y = -elasticity;
    position.y = platformHitY - 20;
    platformHit = false;
  }
  if (position.x < -30){
    position.x = 530;
  }
  if (position.x > 530){
    position.x = -30;
  }
  if (position.y >= 800){
    gameState = 3; // lose screen
  }
}

void createPlatforms(){
  imageMode(CENTER); 
  for (int i = 0; i < numPlatforms; i++){
    image(platform[platformType[i]], platformXPos[i], platformYPos[i]);
  }
}

void platformCharacterCollision(){
  for (int i = 0; i < numPlatforms; i++){
    if (position.x <= platformXPos[i] + 45 && position.x >= platformXPos[i] - 50 &&
    position.y <= platformYPos[i] - 30 && position.y >= platformYPos[i] - 40 && 
    velocity.y > 0){
      velocity.y = 0;
      platformHit = true;
      platformHitY = platformYPos[i];
    }
  }
}

// If the character reaches the middle of the screen, 
// the platforms all move up at the same velocity to 
// resemble the camera following the character
void movePlatformsWithCharacter(){
  if (position.y <= 400 && velocity.y < 0){
    characterJump = false;
    if (!characterJump){
      for (int i = 0; i < numPlatforms; i++){
        platformYPos[i] = platformYPos[i] - velocity.y;
      }
    }
  } else {
    characterJump = true;
  }
}

// moves platforms out of view to the top to avoid remaking every platform 
void checkPlatformHitBottom(){
  for (int i = 0; i < numPlatforms; i++){
    if (platformYPos[i] >= 845){
      platformYPos[i] = -45;
      platformXPos[i] = originalPlatformXPos[i];
      score = score + 25;
      if (platformType[i] == 0 || platformType[i] == 1){
        platformType[i] = int(random(2));
      }
    }
  }
}

// Causes only blue platforms to move right and left
// across the screen
void moveBluePlatform(){
  for (int i = 0; i < numPlatforms; i++){
    if (platformType[i] == 1){
      platformXPos[i] = platformXPos[i] + platformSpeed[i];
    }
  }
}

// Collision with sides of the screen
void bluePlatformHitSide(){
  for (int i = 0; i < numPlatforms; i++){
    if (platformXPos[i] < 50 || platformXPos[i] > 450){
      platformSpeed[i] = platformSpeed[i] * -1;
    }
  }
}

// White platforms move to a random new
// location when hit
void whitePlatformCollision(){
  for (int i = 0; i < numPlatforms; i++){
    if (platformType[i] == 2){
      if (platformHitY == platformYPos[i]){
        platformXPos[i] = int(random(50, 451));
        platformYPos[i] = int(random(50, 751));
      }  
    }
  }
}

void displayScore(){
  fill(#FFFFFF);
  text(score + " points", 30, 20);
}

void detectHighscore(){
  if (score > highscore){
    highscore = score;
  }
}

void createGameOverScreen(){
  imageMode(CENTER);
  image(gameOver, 250, 180);
  image(yourScoreText, 200, 330);
  fill(#000000);
  text(score, 300, 330);
  image(yourHighscoreText, 200, 380);
  text(highscore, 320, 383);
  image(pageRip, 250, 760);
  image(playAgainButton, 250, 480);
  image(menuButton, 250, 550);
}
