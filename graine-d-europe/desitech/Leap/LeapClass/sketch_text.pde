/**
* Write a text during the transition (the theme)
* @param text The text to write
*/
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
  int[] darkest = getBrighestColor();
  fill(darkest[0], darkest[1], darkest[2], opacity_text);
  text(text, width/2, height/2);
  textAlign(CENTER, CENTER);
}

/**
* Create a new font
* @return The new font
*/
PFont getFont() {
  return createFont("DK_Bocadillo.otf", 150);
}

/**
* Write a text in the main circle
* @param text The text to write
*/
void writeCentralText(String text) {
  
  int nbChar = text.length();
  
  textFont(createFont("DK_Bocadillo.otf", 3500/nbChar));
  
  int[] rgb = getColorTimer(theme);
  
  fill(rgb[0], rgb[1], rgb[2], 255);
  text(text, width/2 - 350, height/2 - 350, 700, 700);
  textAlign(CENTER, CENTER);
}
