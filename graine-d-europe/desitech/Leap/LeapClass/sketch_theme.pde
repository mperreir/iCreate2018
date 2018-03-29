String getTheme() {
  int rand = (int) (Math.random() * (6));
  String theme = "";
   
   switch (rand) {
     case 0: theme = "citoyen";
             break;
     case 1: theme = "culture";
             break; 
     case 2: theme = "deputes";
             break;
     case 3: theme = "environnement";
             break; 
     case 4: theme = "education";
             break; 
     case 5: theme = "histoire";
             break; 
   }
  
  return theme;
}



int[] getColorRGB(String theme) {
  int rand = (int) (Math.random() * (4));
  System.out.println(rand);
  int[] rgb = new int[3];
  
  if (theme == "citoyen") {
    switch (rand) {
      case 0:
        rgb[0] = 230;
        rgb[1] = 106;
        rgb[2] = 146;
        break;
      case 1:
        rgb[0] = 209;
        rgb[1] = 59;
        rgb[2] = 103;
        break;
      case 2:
        rgb[0] = 152;
        rgb[1] = 38;
        rgb[2] = 73;
        break;
      /*case 3:
        rgb[0] = 98;
        rgb[1] = 19;
        rgb[2] = 46;
        break;*/
    }
  } else if (theme == "culture") {
    switch (rand) {
      case 0:
        rgb[0] = 101;
        rgb[1] = 97;
        rgb[2] = 152;
        break;
      case 1:
        rgb[0] = 80;
        rgb[1] = 65;
        rgb[2] = 145;
        break;
      case 2:
        rgb[0] = 72;
        rgb[1] = 57;
        rgb[2] = 134;
        break;
      /*case 3:
        rgb[0] = 48;
        rgb[1] = 39;
        rgb[2] = 88;
        break;*/
    }
  } else if (theme == "deputes") {
    switch (rand) {
      case 0:
        rgb[0] = 91;
        rgb[1] = 193;
        rgb[2] = 224;
        break;
      case 1:
        rgb[0] = 59;
        rgb[1] = 170;
        rgb[2] = 216;
        break;
      case 2:
        rgb[0] = 29;
        rgb[1] = 125;
        rgb[2] = 162;
        break;
      /*case 3:
        rgb[0] = 17;
        rgb[1] = 78;
        rgb[2] = 102;
        break;*/
    }
  } else if (theme == "environnement") {
    switch (rand) {
      case 0:
        rgb[0] = 143;
        rgb[1] = 196;
        rgb[2] = 118;
        break;
      case 1:
        rgb[0] = 94;
        rgb[1] = 171;
        rgb[2] = 85;
        break;
      case 2:
        rgb[0] = 77;
        rgb[1] = 133;
        rgb[2] = 66;
        break;
      /*case 3:
        rgb[0] = 54;
        rgb[1] = 98;
        rgb[2] = 52;
        break;*/
    }
  } else if (theme == "education") {
    switch (rand) {
      case 0:
        rgb[0] = 235;
        rgb[1] = 141;
        rgb[2] = 77;
        break;
      case 1:
        rgb[0] = 233;
        rgb[1] = 124;
        rgb[2] = 49;
        break;
      case 2:
        rgb[0] = 179;
        rgb[1] = 90;
        rgb[2] = 46;
        break;
      /*case 3:
        rgb[0] = 153;
        rgb[1] = 69;
        rgb[2] = 38;
        break;*/
    }
  } else if (theme == "histoire") {
    switch (rand) {
      case 0:
        rgb[0] = 286;
        rgb[1] = 188;
        rgb[2] = 87;
        break;
      case 1:
        rgb[0] = 238;
        rgb[1] = 176;
        rgb[2] = 52;
        break;
      case 2:
        rgb[0] = 232;
        rgb[1] = 163;
        rgb[2] = 52;
        break;
      /*case 3:
        rgb[0] = 187;
        rgb[1] = 140;
        rgb[2] = 54;
        break;*/
    }
  }
  
  if (rand == 1) {
    System.out.println(rgb[0]);
  }

  return rgb;
}

int[] getColorTimer(String theme) {
    int[] rgb = new int[3];

    if (theme == "citoyen") {
        rgb[0] = 98;
        rgb[1] = 19;
        rgb[2] = 46;
  } else if (theme == "culture") {
        rgb[0] = 48;
        rgb[1] = 39;
        rgb[2] = 88;
  } else if (theme == "deputes") {
        rgb[0] = 17;
        rgb[1] = 78;
        rgb[2] = 102;
  } else if (theme == "environnement") {
        rgb[0] = 54;
        rgb[1] = 98;
        rgb[2] = 52;
  } else if (theme == "education") {
        rgb[0] = 153;
        rgb[1] = 69;
        rgb[2] = 38;
  } else if (theme == "histoire") {
        rgb[0] = 187;
        rgb[1] = 140;
        rgb[2] = 54;
  }

  return rgb;

}
