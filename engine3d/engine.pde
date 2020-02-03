//My first stab at an interactive, 3D environment.

var showNodes = true;
var showLines = true;
var shapeColor = color(40, 255, 0);

var limitRenderDistance = false;
var renderDistance = 3000;


var keys = [];
void keyPressed(){keys[keyCode]=true;}
void keyReleased(){keys[keyCode]=false;}

var distance3d = function(p0, p1){
    return sqrt(pow(p1.x-p0.x, 2) + pow(p1.y-p0.y, 2) + pow(p1.z-p0.z, 2));
};

var Vector = function(x, y, z){
    var vec = {
        v: [x, y, z],
        addv: function(vector){
            this.v[0] += vector.v[0];
            this.v[1] += vector.v[1];
            this.v[2] += vector.v[2];
        },
        subv: function(vector){
            this.v[0] -= vector.v[0];
            this.v[1] -= vector.v[1];
            this.v[2] -= vector.v[2];
        }
    };
    return vec;
};

var Point = function(x, y, z){
    var p = {
        pos: {x: x, y: y, z: z},
        addv: function(vector){
            this.pos.x += vector.v[0];
            this.pos.y += vector.v[1];
            this.pos.z += vector.v[2];
            return Point(this.pos.x, this.pos.y, this.pos.z);
        },
        subv: function(vector){
            this.pos.x -= vector.v[0];
            this.pos.y -= vector.v[1];
            this.pos.z -= vector.v[2];
            return Point(this.pos.x, this.pos.y, this.pos.z);
        },
        subp: function(point){
            var x = this.x - point.x;
            var y = this.pos.y - point.pos.y;
            var z = this.pos.z - point.pos.z;
            return Vector(x, y, z);
        },
        screenPos: function(cam){
            var zPlaneDist = dist(this.pos.x, this.pos.z, cam.x, cam.z);
            var yPlaneDist = dist(this.pos.y, this.pos.z, cam.z, cam.z);
            var difX = this.pos.x-cam.x;
            var difY = cam.y - this.pos.y;
            var difZ = cam.z - this.pos.z;
            var yDist = cos(atan(difX/difZ)-cam.yaw)*zPlaneDist;
            var hDist = sin(atan(difX/difZ)-cam.yaw)*zPlaneDist;
            var pDist = sin(atan(difY/yDist)-cam.pitch)*yPlaneDist;
            var vDist = cos(atan(difY/yDist)-cam.pitch)*yPlaneDist;
            var x = (hDist/(yDist/2))*(width/2);
            var y = (pDist/(vDist/2))*(height/2);
            if(yDist > 0){
                return {x:x, y:y};
            } else {
                return {x: undefined, y: undefined};
            }
        },
        draw: function(cam){
            var zPlaneDist = dist(this.pos.x, this.pos.z, cam.x, cam.z);
            var yPlaneDist = dist(this.pos.y, this.pos.z, cam.y, cam.z);
            var difX = this.pos.x-cam.x;
            var difY = cam.y - this.pos.y;
            var difZ = cam.z - this.pos.z;
            var yDist = cos(atan(difX/difZ)-cam.yaw)*zPlaneDist;
            var hDist = sin(atan(difX/difZ)-cam.yaw)*zPlaneDist;
            var pDist = sin(atan(difY/yDist)-cam.pitch)*yPlaneDist;
            var vDist = cos(atan(difY/yDist)-cam.pitch)*yPlaneDist;
            var x = (hDist/(yDist/2))*(width/2);
            var y = (pDist/(vDist/2))*(height/2);
            noStroke();
            fill(shapeColor);
            ellipse(x, y, 8, 8);
        }
    };
    return p;
};

var origin = Point(0, 0, 0);

var Cube = function(x, y, z, w, h, d){
    var c = {
        x: x,
        y: y,
        z: z,
        nodes: [
            Point(x, y, z+d),
            Point(x+w, y, z+d),
            Point(x+w, y+h, z+d),
            Point(x, y+h, z+d),
            Point(x, y, z),
            Point(x+w, y, z),
            Point(x+w, y+h, z),
            Point(x, y+h, z)
        ],
        center: Point((w/2)+x, (h/2)+y, (d/2)+z),
        l: 0,
        lines: function(){
            var lines = [];
            var lp = this.nodes.length;
            for(var i = 0; i < lp; i++){
                var count = i;
                while(count < lp){
                    lines.push([i, count]);
                    count++;
                }
            }
            return lines;
        }, //draws every possible line in cube
        shape: function(){
            var trongles = [];
            var tp = this.nodes.length;
            for(var i = 0; i < tp; i++){
                var count = i;
                while(count < tp){
                    trongles.push([i, count, count+1]);
                    count++;
                }
            }
            return trongles;
        }, //draws every possible triangle in cube
        addv: function(v){
            for(var i = 0; i < this.nodes.length; i++){
                this.nodes[i].addv(v);
            }
        },
        subv: function(v){
            for(var i = 0; i < this.nodes.length; i++){
                this.nodes[i].subv(v);
            }
        },
        subc: function(cube){
            var n0 = this.nodes[4];
            var n1 = cube.nodes[4];
            var x = n0.pos.x - n1.pos.x;
            var y = n0.pos.y - n1.pos.y;
            var z = n0.pos.z - n1.pos.z;
            return Vector(x, y, z);
        },
        rotateX: function(theta, x, y, z){
            for(var i = 0; i < this.nodes.length; i++){
                var ry = this.nodes[i].pos.y;
                var rz = this.nodes[i].pos.z;
                this.nodes[i].pos.y = ry * cos(theta) - rz * sin(theta);
                this.nodes[i].pos.z = rz * cos(theta) + ry * sin(theta);
            }
        },
        rotateY: function(theta, x, y, z){
            if(x === undefined || y === undefined || z === undefined){
                x = this.center.pos.x;
                y = this.center.pos.y;
                z = this.center.pos.z;
            }
            for(var i = 0; i < this.nodes.length; i++){
                var rx = this.nodes[i].pos.x;
                var rz = this.nodes[i].pos.z;
                this.nodes[i].pos.x = rx * cos(theta) - rz * sin(theta);
                this.nodes[i].pos.z = rz * cos(theta) + rx * sin(theta);
            }
        },
        rotateZ: function(theta, x, y, z){
            for(var i = 0; i < this.nodes.length; i++){
                var rx = this.nodes[i].pos.x;
                var ry = this.nodes[i].pos.y;
                this.nodes[i].pos.x = rx * cos(theta) - ry * sin(theta);
                this.nodes[i].pos.y = ry * cos(theta) + rx * sin(theta);
            }
        },
        draw: function(cam){
            var s = this.shape();
            for(var i = 0; i < s.length; i++){
                var n0 = this.nodes[s[i][0]];
                var n1 = this.nodes[s[i][1]];
                var n2 = this.nodes[s[i][2]];
                if(n0.screenPos(cam).x !== undefined && n1.screenPos(cam).x !== undefined){
                    
                }
            }
            if(showNodes){
                for(var i = 0; i < this.nodes.length; i++){
                    this.nodes[i].draw(cam);
                    text(i, this.nodes[i].screenPos(cam).x-10, this.nodes[i].screenPos(cam).y-7);
                }
            }
            if(showLines){
                var l = this.lines();
                stroke(shapeColor);
                for(var i = 0; i < l.length; i++){
                    var n0 = this.nodes[l[i][0]];
                    var n1 = this.nodes[l[i][1]];
                    if(n0.screenPos(cam).x !== undefined && n1.screenPos(cam).x !== undefined){
                        line(n0.screenPos(cam).x, n0.screenPos(cam).y, n1.screenPos(cam).x, n1.screenPos(cam).y);
                    }
                }
            }
        }
    };
    c.nodes.push(c.center);
    return c;
};

var player = {
    x: 0,
    y: 0,
    z: 0,
    speed: 1.5,
    yaw: 0,
    pitch: 0,
    roll: 0,
    input: function(){
        if(keys[37] || keys[65]){
            this.x -= cos(-this.yaw)*this.speed;
            this.z += sin(-this.yaw)*this.speed;
        }
        if(keys[39] || keys[68]){
            this.x += cos(-this.yaw)*this.speed;
            this.z -= sin(-this.yaw)*this.speed;
        }
        if(keys[38] || keys[87]){
            this.z -= cos(-this.yaw)*this.speed;
            this.x -= sin(-this.yaw)*this.speed;
        }
        if(keys[40] || keys[83]){
            this.z += cos(-this.yaw)*this.speed;
            this.x += sin(-this.yaw)*this.speed;
        }
        if(keys[16]){
            this.y -= this.speed;
        }
        if(keys[32]){
            this.y += this.speed;
        }
        if(keys[81]){
            this.speed = 5;
        } else {
            this.speed = 1.5;
        }
    }
};

void setup(){
  size(1000, 800);
  var cube = Cube(-50, -50, -1050, 100, 100, 100);
  var cube1 = Cube(-250, -50, -1050, 100, 100, 100);
}

void draw() {
    player.input();
    
    pushMatrix();
    translate(width/2, height/2);
    
    background(0, 0, 0);
    
    cube.addv(Vector(sin(frameCount)*5, 0, 0));
    //cube1.addv(Vector(cos(frameCount), sin(frameCount), 0));
    //cube.rotateX(2);
    //cube1.rotateX(-2);
    
    cube.draw(player);
    cube1.draw(player);
    
    popMatrix();
}

void mouseDragged(){
    player.yaw -= pmouseX-mouseX;
    player.pitch -= pmouseY-mouseY;
}
