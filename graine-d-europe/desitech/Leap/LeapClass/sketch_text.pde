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

PFont getFont() {
  return createFont("DK_Bocadillo.otf", 150);
}
