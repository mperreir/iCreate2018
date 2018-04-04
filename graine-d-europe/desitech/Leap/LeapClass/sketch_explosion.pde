/*
* Check if an explosion has been detected
* @param entropy The entropy of the movements of the hand, if it's too high then it will be detected as an explosion
*/
void detectionExplosion(float entropy) {
  if (enableTestExplosion) {
    if (tmpTestCurrentExplosion == tmpTestTimeExplosion) {
      explosion();
    }
  } else {
    if (entropy > entropyCoef && !explosion) {
      explosion();
      explosion = true;
    }
  }
}

/**
* Does the effects of an explosion
*/
void explosion() {
  int[] corner1 = {0, 0};
  int[] corner2 = {height, 0};
  int[] corner3 = {height, width};
  int[] corner4 = {0, width};
  int[][] corners = {corner1, corner2, corner3, corner4};
  for (Circle c : listCircles) {
    subExplosition(corners, c);
  }
  for (Circle c : listCirclesFull) {
    subExplosition(corners, c);
  }
}

void subExplosition(int[][] corners, Circle c) {
  int corner_index = 0;
  double value = Integer.MAX_VALUE;
  for (int i = 0; i < corners.length; i++) {
    double tmpDist = Math.sqrt(Math.pow((corners[i][1] - c.xpos), 2) + Math.pow((corners[i][0] - c.ypos), 2));
    if (value > tmpDist) {
      corner_index = i;
      value = tmpDist;
    }
  }
  
  switch (corner_index) {
      case 0:
        c.speedx = -Math.abs(c.speedx);
        c.speedy = -Math.abs(c.speedy);
        break;
      case 1:
        c.speedx = -Math.abs(c.speedx);
        c.speedy = Math.abs(c.speedy);
        break;
      case 2:
        c.speedx = Math.abs(c.speedx);
        c.speedy = Math.abs(c.speedy);
        break;
      case 3:
        c.speedx = Math.abs(c.speedx);
        c.speedy = -Math.abs(c.speedy);
        break;
    }
    
    c.explosion = true;
}
