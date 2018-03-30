void writeText(String text) {
  if (fading_higher && timerText < (waitText / fading_time)) {
    opacity_text += (255 / (waitText / fading_time));
  } else if (!fading_higher && timerText > ((waitText / fading_time)*(fading_time-1))) {
    opacity_text -= (255 / (waitText / fading_time));
  }
  if (opacity_text >= 240) {
    fading_higher = false;
  }
  textFont(font);
  fill(0, 0, 0, opacity_text);
  text(text, width/2, height/2);
  textAlign(CENTER, CENTER);
}

PFont getFont() {
  return createFont(PFont.list()[0], 200);
}

void writeCentralText(String text) {
  
  int nbChar = text.length();
  
  textFont(createFont(PFont.list()[0], 2000/nbChar));
  
  int[] rgb = getColorTimer(theme);
  
  fill(rgb[0], rgb[1], rgb[2], 255);
  text(text, width/2 - 200, height/2 - 200, 400, 400);
  textAlign(CENTER, CENTER);
}
