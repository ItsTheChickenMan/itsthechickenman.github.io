/*Greetings, strange fellow!
This program is a work in progress for a rhythm game I'm making for a friend.  
The actually game will be in Java, and then ported to a Raspberry Pi, but I decided to make a model in 
Processing because it's so easy to create graphics.
*/

/* @pjs preload="assets/characterNeutral.png"; */
/* @pjs preload="assets/characterRed.png";     */
/* @pjs preload="assets/characterBlue.png";    */
/* @pjs preload="assets/characterGreen.png";   */
/* @pjs preload="assets/characterYellow.png";  */

//I don't have everything perfectly annotated, just bear with me for a little while :P
//Have fun scrolling through and stuff

PImage characterNeutral;
PImage characterRed;
PImage characterGreen;
PImage characterBlue;
PImage characterYellow;
void setup() {
  frameRate(60);
  size( 400, 400 );
  characterNeutral = loadImage("assets/characterNeutral.png");
  characterRed = loadImage("assets/characterRed.png");
  characterGreen = loadImage("assets/characterGreen.png");
  characterBlue = loadImage("assets/characterBlue.png");
  characterYellow = loadImage("assets/characterYellow.png");
}

//Test level data
var level1 = [];

//Player vars (usually I store these in an array, but I did multiple vars for readability)
var playerX = 200;  //x
var playerY = 200;  //y
var playerXOffset = -6;
var playerYOffset = -6;
var pcolor;         //color
var playerPhase = 0;//current phase
var smoooth = 100;  //health
var levelEnd = 0;   //is the level over?

//Other vars
var neatmapVersion = "1";

//Key handlers
var keys = [];
keys[37] = 0;
keys[38] = 0;
keys[39] = 0;
keys[40] = 0;  //These need to be pre-defined so that multiple key combinations work
void keyPressed(){keys[keyCode] = 1;};
void keyReleased(){keys[keyCode] = 0;};

//Generates random level for testing purposes
var randomLevel = function(length, out, difficulty){
    for(var i = 0; i < length; i ++){
        out[i] = [];
        out[i][0] = floor(random(difficulty - 3, difficulty));
        out[i][1] = floor(random(1, 8));
        out[i][2] = floor(random(1, 4));
        out[i][3] = floor(random(0, 60));
    }
};

var readMapData = function(map){
    var header = [52, 50, 48, 69, 76, 77, 65, 79, 58, 78, 101, 97, 116, 109, 97, 112, 118, 49, 33, 33, 58];
    byte mapData[] = loadBytes(map);
    var stoopid = [];
    var stoopidIndex = 0;
    for(var a = 0; a < header.length; a++){
        if(mapData[a] !== byte(header[a])){
             println("Unable to load neatmap: header was obstructed or out of date");
        }
    }
    for(var i = 0; i < mapData.length; i++){
        var fetchBeat = 0;
        var fetchDat = 0;
        var b = mapData[i];
        if(b === 33){
          fetchBeat++;
        } else if(b === 37) {
          var stooString;
          for(var c = 0; c < stoopid.length; c++){
            stooString += stoopid[c];
          }
          var dat = int(stooString);
          level1[fetchBeat][fetchDat] = dat;
          stoopidIndex = 0;
          stoopid = [];
          fetchDat++;
        } else {
          stoopid[stoopidIndex]=b;
          stoopidIndex++;
        }
    }
    println(level1);
}
//Updates background
var drawScreen = function(){
    background(255, 255, 255);
    fill(255, 0, 0);
    textSize(35);
    text(smoooth, 70, 40);
    stroke(0);
    fill(255, 255, 255);
    ellipse(200, 200, 200, 200);
};

//Draws beat, init defines position, phase defines which beat (1-8), and color defines the color (1-3)
var drawBeat = function(init, phase, color){
    var phs = [247.5, 292.5, 337.5, 22.5, 67.5, 112.5, 157.5, 202.5, 247.5];
    var xy = [init, init, 200, -init+400,-init+400,-init+400, 200, init, init, init];
    var col = [[255, 0, 0], [0, 255, 0], [0, 0, 255]];
    noFill();
    stroke(50);
    strokeWeight(10);
    if(phase === 3){
        phs[2] = -22.5;
    }
    stroke(col[color - 1][0],col[color - 1][1], col[color - 1][2]);
    arc(xy[phase + 1], xy[phase - 1], 200, 200, radians(phs[phase - 1]), radians(phs[phase]));
    strokeWeight(1);
};

//Draws player with x, y, and colors (0-3)
var drawPlayer = function(x, y, color){
    var col = [characterNeutral, characterRed, characterGreen, characterBlue, characterYellow];
    stroke(0);
    noStroke();
    image(col[color], x+playerXOffset, y+playerYOffset, 12, 12);
};

//When called will take in level data and play it
//Level data is a 2D array structed like so:
//[speed, phase, color, delay]
//speed = how fast it travels;  phase = phase to draw;  color is obvious;  delay = how long before launch next beat (defined in 60ths of a second, for instance a delay of 30 is half a second)

var currentBeat = 0;
var pos = -300;    //If you want a delay at the start, change this 
var level = function(levelData){
    if(pos >= 200 && smoooth > 0){
        if(playerPhase !== levelData[currentBeat][1]){
            smoooth -= 6;
        } else if(pcolor !== levelData[currentBeat][2]){
            smoooth -= 3;
        }
        smoooth++;
        currentBeat++;
        pos = 0 - levelData[currentBeat - 1][3];
    }
    if(currentBeat !== levelData.length && smoooth > 0){
        drawBeat(pos, levelData[currentBeat][1], levelData[currentBeat][2]);
        pos += levelData[currentBeat][0];
    } else if(smoooth <= 0){
        print("!");
        for(var i = 0; i < level1.length; i++){
            print("!");
            for(var c = 0; c < 4; c++){
                print(level1[i][c]);
                if(c === 3){}else {print("%");}
            }
            print("&");
            if(i === level1.length - 1){}else{print("%");}
        }
        print("&");
        println("YOU LOSE!  Here's the data, if you want to try again.");
        println("Just paste it into level1 at the top of the code.");
        levelEnd = 1;
    } else {
        print("!");
        for(var i = 0; i < level1.length; i++){
            print("!");
            for(var c = 0; c < 4; c++){
                print(level1[i][c]);
                if(c === 3){}else {print("%");}
            }
            print("&");
            if(i === level1.length - 1){}else{print("%");}
        }
        print("&");
        println("You won!  Level data above");
        levelEnd = 1;
    }
};

//The main game.  Normally I would just drop this into the draw function, but for this I'll keep it it's own seperate thing.  This handles key presses, the levels + data, and some other stuff

randomLevel(30, level1, 5);
var game = function(){
    var twoKey = false;
    pcolor = 0;
    if((keys[37] + keys[38] + keys[39] + keys[40]) === 2){
        twoKey = true;
    }
    playerX = 200;
    playerY = 200;
    playerPhase = 0;
    if(keys[37] && !twoKey){
        playerPhase = 7;
        playerX = 100;
    } else if(keys[39] && !twoKey){
        playerPhase = 3;
        playerX = 300;
    } else if(keys[38] && !twoKey){
        playerPhase = 1;
        playerY = 100;
    } else if(keys[40] && !twoKey){
        playerPhase = 5;
        playerY = 300;
    }
    if(twoKey){
        if(keys[37] && keys[38]){
            playerPhase = 8;
            playerX = 129;
            playerY = 129;
        } else if(keys[37] && keys[40]){
            playerPhase = 6;
            playerX = 129;
            playerY = 271;
        } else if(keys[40] && keys[39]){
            playerPhase = 4;
            playerX = 271;
            playerY = 271;
        } else if(keys[39] && keys[38]){
            playerPhase = 2;
            playerX = 271;
            playerY = 129;
        }
    }
    if(keys[90]){
        pcolor = 1;
    } else if(keys[88]){
        pcolor = 2;
    } else if(keys[67]){
        pcolor = 3;
    }
    drawScreen();
    if(levelEnd === 0){
        level(level1);
    } 
    drawPlayer(playerX, playerY, pcolor);
};

//Ah, yes.  The draw() function.  The apple of the eye of Processing, the thing that seperates it from just another event-based, javascript-like programming language.  This is, of course, where the game() function is efficiently recalled at 60 executions per second.  Enjoy.
void draw () {
        game();
};

