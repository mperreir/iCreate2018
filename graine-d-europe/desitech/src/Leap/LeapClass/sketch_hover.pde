/**
* Does the "no hover" state for every non hovered circles
*/
void noHover() {
  for (Circle c : listCirclesFull) {
    c.hover = false;
    c.reachSize = false;
    c.sizeExpansionCoef = 1;
  }
}

void detectionHover(int index) {
  if (enableTestSize) {
    if (tmpTestCurrentSize == tmpTestTimeSize) {
      circleHover(1);
    } else if (tmpTestCurrentSize == tmpTestTimeSizeStop) {
      noHover();
    }
  } else {
    if (index != -1) {
      circleHover(index);
      //check if the user select the circle
      if (leap.actionPoing()) {
        g_hover = true;
        Circle c = listCirclesFull[index];
        c.mainCircle = true;
        mc = new MainCircle(c.xpos, c.ypos, c.rgb, c.size, index, audio.getDuration(this, theme, c.getAudioName())*30 + 30, c.getAudioName());
        
      }
    } else {
      noHover();
    }
  }
}

/**
* Does the effects when a circle is being hovered
* @param index The index of the circle which is being hovered
*/
void circleHover(int index) {
  listCirclesFull[index].hover = true;
  listCirclesFull[index].hoverReached = false;
  listCirclesFull[index].reachSize = false;
  listCirclesFull[index].sizeExpansionCoef = sizeTopCoef_f;
  
  for (int i = 0; i < listCirclesFull.length; i++) {
    if (i != index) {
      listCirclesFull[i].hover = false;
      listCirclesFull[i].reachSize = false;
      listCirclesFull[i].sizeExpansionCoef = 1;
    }
  }
}

/**
* Check if a circle is being hovered or not
* @param x_coord The coordinate x of the hand
* @param y_coord The coordinate y of the hand
* @The index of the detected circle being hovered, -1 if none
*/
int checkIfHover(int x_coord, int y_coord) {
  for (int i = 0; i < listCirclesFull.length; i++) {
    //(x - center_x)^2 + (y - center_y)^2 < radius^2
    if ((Math.pow(x_coord - listCirclesFull[i].xpos, 2) +  Math.pow(y_coord - listCirclesFull[i].ypos, 2)) < Math.pow(listCirclesFull[i].radius, 2)) {
      return i;
    }
  }
  return -1;
}

/**
* Does the effect when you swipe down
*/
void checkSwipeDown() {
  if (mc != null && mc.isPlaying && leap.isSwipingDown()) {
    mcClosing();
    swipe = true;
  }
}
