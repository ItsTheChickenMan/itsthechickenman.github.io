// A basic "platformer" engine (neato)
// TODO: Fix collisions so that it prioritizes based on currnt key being pressed
// Documentation below:




/**
 * keys[];  Handles key presses
 
 * player[x, y, state];  An array which contains player data (better than three seperate vars)
 
 * objData[];  Stores collidable object data (no need to manually add to this, just use drawObject() function
 
 * drawObject(name, x, y, width, height, round, color[]); draws an object and stores it's collision data to objData
 
 * drawScreen();  draws the screen.  Anything before the for() loop won't be collidable, so you can add backgrounds.  For collidable objects, see above
 
 * drawPlayer(x, y, state);  Draws the player according to parameters   
 
 * checkCollisions();  Checks if the player is colliding with anything and returns an array of booleans: [canMoveLeft, canMoveRight, canMoveUp, canMoveDown], which is used in the   game() function to determine if it should ignore key presses
 
 * game();  Checks for and handles key presses, collisions, and player data. 
 
**/





var keys = [];
var player = [175, 30, "idle", 30, 10];   //0 - player x; 1 - player y; 2- playerState;  3- size;  4- jump force 
var objData = [[-25, -25, 25, 425, 0, [0, 0, 0]], [400, 0, 1, 400, 0, [0, 0, 0]], [-25, -25, 425, 25, 0, [0, 0, 0]]];

void keyPressed(){keys[keyCode] = true;};
void keyReleased(){keys[keyCode] = false;};

var drawScreen = function(){    //Draws the screen
    background(140, 255, 255);
    for(var i = 0; i < objData.length; i++){
        fill(objData[i][5][0], objData[i][5][1], objData[i][5][2]);
        rect(objData[i][0], objData[i][1], objData[i][2], objData[i][3], objData[i][4]);
    }
};

// Draws the player 
var drawPlayer = function(x, y, state, size){
    noStroke();
    fill(0, 90, 0);
    rect(x, y, size, size, size/5);
    switch(state){
        case "idle":
            fill(255, 255, 255);
            ellipse(x + size/(10/3), y + size/2.5, size/5, size/(10/3));
            ellipse(x + size/(10/7), y + size/2.5, size/5, size/(10/3));    
            break;
        case "left":
            fill(255, 255, 255);
            ellipse(x + size/5, y + size/2.5, size/5, size/(10/3));
            ellipse(x + size/(5/3), y + size/2.5, size/5, size/(10/3));  
            break;
        case "right":
            fill(255, 255, 255);
            ellipse(x + size/2.5, y + size/2.5, size/5, size/(10/3));
            ellipse(x + size/1.25, y + size/2.5, size/5, size/(10/3));  
            break;
        default:
            break;
    }
};

var drawObject = function(a, x, y, width, height, round, color){  //For collidable objects
    objData[objData.length] = [x, y, width, height, round, color];
};

// [canMoveLeft, canMoveRight, canMoveUp, canMoveDown]
var checkCollisions = function(){
    var ret = [true, true, true, true];  //Innocent until proven guilty
    for(var i = 0; i < objData.length; i++){
        if((player[1] + player[3]) >= objData[i][1] && player[1] < objData[i][1]){
            if(player[0] < (objData[i][0] + objData[i][2]) && player[0] + player[3] > objData[i][0]){              
                player[1] = objData[i][1] - player[3];
                ret[3] = false;
            }
        }
        if(player[0] + player[3] >= objData[i][0] && player[0] <= objData[i][0]){
            if(player[1] < (objData[i][1] + objData[i][3]) && (player[1] + player[3]) > objData[i][1]){            
                player[0] = objData[i][0] - player[3];
                ret[1] = false;
            }
        }
        if(player[1] <= (objData[i][1] + objData[i][3]) && player[1] + player[3] > (objData[i][1] + objData[i][3])){    
            if(player[0] < (objData[i][0] + objData[i][2]) && player[0] + player[3] > objData[i][0]){              
                player[1] = objData[i][1] + objData[i][3];
                ret[2] = false;
            }
        }
        if(player[0] <= (objData[i][0] + objData[i][2]) && player[0] + player[3] >= (objData[i][0] + objData[i][2])) {
            if(player[1] < (objData[i][1] + objData[i][3]) && (player[1] + player[3]) > objData[i][1]){            
                player[0] = objData[i][0] + objData[i][2];
                ret[0] = false;
            }
        }
    }
    return ret;
};

// Handles key presses and the player
var game = function(){  
    var jump;
    var collisions = checkCollisions();
    var i = player[4];
    if(keys[37] && collisions[0]){
        player[0] -= player[3]/6.25;
        player[2] = "left";
    } else if(keys[39] && collisions[1]){
        player[0] += player[3]/6.25;
        player[2] = "right";
    } else {
        player[2] = "idle";
    }
    if(keys[38] && collisions[2]){
        jump = true;
        player[1] -= player[4];
    }
    if(!jump && collisions[3]){
        player[1] += player[3]/3;
    }
    drawScreen();
    drawPlayer(player[0], player[1], player[2], player[3]);
};

// Test Level Data
{
    drawObject("ground", 0, 380, 401, 20, 0, [0, 0, 0]);
    drawObject("obj", 50, 273, 30, 30, 0, [0, 0, 0]);
    drawObject("large", 200, 100, 65, 65, 10, [0, 0, 255]);
    drawObject("small", 40, 40, 10, 10, 0, [0, 255, 0]);
    drawObject("groundObj", 200, 340, 40, 40, 0, [0, 0, 0]);  
}

void setup(){
  size( 400, 400 );
  frameRate( 60 );
}

void draw() {
    try {  
        game();
    } catch(e) {
        println(e);
    }
};
 
