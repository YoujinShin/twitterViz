//randomSeed(100);
float t = random(100);

void displayPosition() {
  t = t + 0.01;
  float x = noise(t);
  x = map(x, 0, 1, 0, width);
  ellipse(x, height/2, 40, 40);
}

void displayDiameter(float x, float y) {
  t = t + 0.001;
  float d = noise(t);
  fill(255, 50);
  d = map(d, 0, 1, 50, 100);
  ellipse(x, y, d, d);
}
