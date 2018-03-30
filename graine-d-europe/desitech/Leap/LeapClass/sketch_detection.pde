// Check if hand movements are begin detected
void handMovements(boolean detected) {
  if (detected) {
    setSpeedCoef(1);
  } else {
    setSpeedCoef(50);
  }
}

void detectionHand(boolean detected) {
  if (enableTest) {
    if (tmpTestCurrent > tmpTestTime && tmpTestCurrent < (tmpTestTime + 300)) {
      handMovements(true);
      reach = false;
    } else {
      handMovements(false);
      reach = false;
    }
  } else {
    if (detected) {
      if (vrac) {
        coefAmpReach = false;
        coefAmpHigher = false;
        vrac = false;
      }
      handMovements(true);
      reach = false;
    } else {
      handMovements(false);
      reach = false;
      if (!vrac) {
        vrac = true;
        coefAmpHigher = true;
        coefAmpReach = false;
        audio.playVrac(this);
      }
    }
  }
}
