float totalTime = 300;
int rows = 18;
int cols = 6;
float noiseStrength = 140;
float maxDistForLine = 350;
float noiseDiameter = 0.8;
float minSize = 4;
float maxSize = 26;
float minStrokeWeight = 6;
float maxStrokeWeight = 16;

float yShake;
float zOff;
float timeLeft = totalTime;
NoiseLoop[][] noiseLoops;
OpenSimplexNoise simplexNoise;
boolean record = false;

void setup() {
  size(1440, 3040, P2D);
  frameRate(144);
  simplexNoise = new OpenSimplexNoise();
  yShake = height/2/(rows-1);
  noiseLoops = new NoiseLoop[cols][rows];
  for (int i = 0; i < noiseLoops.length; i++) {
    for (int j = 0; j < noiseLoops[0].length; j++) {
      noiseLoops[i][j] = new NoiseLoop(noiseDiameter, -noiseStrength, noiseStrength);
    }
  }
}

void draw() {
  background(0, 120, 255);
  zOff = map(timeLeft, 0, totalTime, 0, TWO_PI);
  
  for (int i = 1; i < cols; i++) {
    for (int j = 0; j < rows-1; j++) {
      float x1 = map(i-1, 0, cols-1, 0, width) + getXShake(i-1, j);
      float x2 = map(i, 0, cols-1, 0, width) + getXShake(i, j);
      float y = map(j, 0, rows-1, 0, height) + yShake;
      
      float dist = x2 - x1;
      stroke(255, map(dist, 0, maxDistForLine, 255, 0));
      float strokeWeight = map(dist, 0, maxDistForLine, maxStrokeWeight, minStrokeWeight);
      strokeWeight(strokeWeight);
      line(x1, y, x2, y);
      
    }
  }
  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows-1; j++) {
      float x1 = map(i, 0, cols-1, 0, width) + getXShake(i, j);
      float x0 = i > 0 ? map(i-1, 0, cols-1, 0, width) + getXShake(i-1, j) : x1 + maxDistForLine;
      float x2 = i < cols-1 ? map(i+1, 0, cols-1, 0, width) + getXShake(i+1, j) : x1 + maxDistForLine;
      float y = map(j, 0, rows-1, 0, height) + yShake;
      float totalDist = abs(x2 - x1) + abs(x1 - x0);
      float size = map(totalDist, 0, maxDistForLine*2, maxSize, minSize);
      ellipseMode(CENTER);
      noStroke();
      fill(255);
      ellipse(x1, y, size, size);
    }
  }
  
  if (record) {
    save("output1/image" + nf(round(frameCount - totalTime), 4) + ".jpg");
  }
  
  timeLeft --;
  if (timeLeft <= 0) {
    timeLeft = totalTime;
    if (record) exit();
    record = true;
  }
}

float getXShake(int i, int j) {
  return noiseLoops[i][j].value(zOff);
}