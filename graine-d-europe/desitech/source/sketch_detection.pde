/**
* Check if hand movements are begin detected
* @param detected True if the hand has been detected, false otherwise
*/
void handMovements(boolean detected) {
  if (detected) {
    setSpeedCoef(1);
  } else {
    setSpeedCoef(50);
  }
}

/**
* Change variables based on if the hand has been just detected or not detected
* @param detected True if the hand has been detected, false otherwise
*/
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
