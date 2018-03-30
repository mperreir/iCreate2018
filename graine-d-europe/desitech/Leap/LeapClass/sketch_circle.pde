class Circle {
  float xpos, ypos, baseSize, size, baseSpeedx, baseSpeedy, speedx, speedy, radius, sizeCurrentCoef, sizeExpansionCoef, sizeProgressionCoef;
  int[] rgb;
  String col, audioName;
  boolean full, hover, hoverReached, reachSize, explosion, mainCircle;

  Circle (boolean full, String audioName) {  
    this.xpos = Math.floor(Math.random()*2) == 1 ? (float) (Math.random() * (width)) - width : (float) (Math.random() * (width)) + width;
    this.ypos = (float) (Math.random() * ((height - border) - border)) + border;
    this.baseSize = full ? (float) (Math.random() * (175 - 150)) + 150 : (float) (Math.random() * (90 - 50)) + 50;
    this.size = baseSize;
    this.radius = this.size / 2;
    
    this.baseSpeedx = (float) (Math.random() * 3) + 1;
    this.baseSpeedx *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    this.speedx = this.baseSpeedx >= 0 ? this.baseSpeedx + (speedProgressionCoef * (speedCoef / speedProgressionCoef)) : this.baseSpeedx - (speedProgressionCoef * (speedCoef / speedProgressionCoef));
    
    this.baseSpeedy = (float) (Math.random() * 2) + 1;
    this.baseSpeedy *= Math.floor(Math.random()*2) == 1 ? 1 : -1;
    this.speedy = this.baseSpeedy >= 0 ? this.baseSpeedy + (speedProgressionCoef * ((speedCoef / speedProgressionCoef) / coefSpeedY)) : this.baseSpeedy - (speedProgressionCoef * ((speedCoef / speedProgressionCoef) / coefSpeedY)) ;
    
    this.rgb = getColorRGB(theme);
    this.full = full;
    this.hover = false;
    this.hoverReached = true;
    this.reachSize = true;
    this.explosion = false;
    this.mainCircle = false;
    
    this.sizeCurrentCoef = sizeCurrentCoef_f;
    this.sizeExpansionCoef = sizeExpansionCoef_f;
    this.sizeProgressionCoef = sizeProgressionCoef_f;
    
    this.audioName = audioName;
  }

  void update() {
    this.changeSpeed();

    this.hoverEffects();

    // If the circle reaches a top or bottom border, we make it bounce
    if (!mainCircle) {
      if (!this.explosion) {
        this.positionChange();
      } else {
        this.speedx += this.speedx >= 0 ? 1 : -1; 
        this.speedy += this.speedy >= 0 ? 1 : -1; 
        this.xpos = (this.xpos + this.speedx);
        this.ypos = (this.ypos + this.speedy);
      }
      this.representation();
    } else {
      this.invisible();
    }
  }
  
  private void representation() {
    if (this.full) {
      fill(this.rgb[0], this.rgb[1], this.rgb[2], 255);
      noStroke();
    } else {
      fill(0, 0, 0, 0);
      stroke(this.rgb[0], this.rgb[1], this.rgb[2], 150);
      strokeWeight(4);
    }

    ellipse(this.xpos, this.ypos, this.size, this.size);
  }
  
  // Change the speed of the circle based on the coef
  // We need to check if the speed is negative or positive
  private void changeSpeed() {
    if (!reach) {
      if (higher) {
        this.speedx = this.speedx >= 0 ? this.speedx + (speedProgressionCoef) : this.speedx - (speedProgressionCoef);
        this.speedy = this.speedy >= 0 ? this.speedy + (speedProgressionCoef/coefSpeedY) : this.speedy - (speedProgressionCoef/coefSpeedY);
      } else {
        this.speedx = this.speedx >= 0 ? this.speedx - (speedProgressionCoef) : this.speedx + (speedProgressionCoef);
        this.speedy = this.speedy >= 0 ? this.speedy - (speedProgressionCoef/coefSpeedY) : this.speedy + (speedProgressionCoef/coefSpeedY);
      }
    }
  }
  
  private void hoverEffects() {
    if (!reachSize) {
      if (this.full && this.hover) {
        if ((this.sizeCurrentCoef - this.sizeExpansionCoef) < -this.sizeProgressionCoef) {
          this.size += this.sizeProgressionCoef;
          this.speedx = 0;
          this.speedy = 0;
        }
      } else if (this.size > this.baseSize) {
        this.size -= sizeProgressionCoef;
        if (this.speedx == 0) {
          this.speedx = this.baseSpeedx >= 0 ? this.baseSpeedx + (speedProgressionCoef * (speedCoef / speedProgressionCoef)) : this.baseSpeedx - (speedProgressionCoef * (speedCoef / speedProgressionCoef));
          this.speedy = this.baseSpeedy;
        }
      }
    }

    if (!this.reachSize) {
      if ((this.sizeCurrentCoef - this.sizeExpansionCoef) < -this.sizeProgressionCoef) {
        this.sizeCurrentCoef += this.sizeProgressionCoef;
      } else if ((this.sizeCurrentCoef - this.sizeExpansionCoef) > this.sizeProgressionCoef) {
        this.sizeCurrentCoef -= this.sizeProgressionCoef;
      } else {
        this.reachSize = true;
      }
    }
  }
  
  private void positionChange() {
    if (timerAppear < waitAppear) {
        this.xpos = (this.xpos + this.speedx) % (width*2);
        if (this.xpos < (-width)) {
          this.xpos = width;
        }
      } else {
        this.xpos = (this.xpos + this.speedx) % width;
        if (this.xpos < 0) {
          this.xpos = width;
        }
      }
      if (((this.ypos + this.speedy) > (height - border)) || ((this.ypos + this.speedy) < border)) {
        this.speedy = -this.speedy;
      }
      this.ypos = (this.ypos + this.speedy) % (height - border);
      if (this.ypos < border) {
        this.ypos = height - border;
      }
  }
  
  private void invisible() {
    if (this.full) {
      fill(this.rgb[0], this.rgb[1], this.rgb[2], 0);
      noStroke();
    }

    ellipse(this.xpos, this.ypos, this.size, this.size);
  }
  
  String getAudioName() {
    return this.audioName;
  }
}
