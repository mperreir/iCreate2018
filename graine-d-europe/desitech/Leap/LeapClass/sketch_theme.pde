String getTheme() {
  int rand = (int) (Math.random() * (audio.getNbCat()));
  
  String theme = audio.getCatIndex(rand);
  
  return theme;
}



int[] getColorRGB(String theme) {
  int rand = (int) (Math.random() * (3));
  System.out.println(rand);
  int[] rgb = new int[3];
  
  if (theme == "citoyen") {
    switch (rand) {
      case 0:
        rgb = citoyen1;
        break;
      case 1:
        rgb = citoyen2;
        break;
      case 2:
        rgb = citoyen3;
        break;
    }
  } else if (theme == "culture") {
    switch (rand) {
      case 0:
        rgb = culture1;
        break;
      case 1:
        rgb = culture2;
        break;
      case 2:
        rgb = culture3;
        break;
    }
  } else if (theme == "deputes") {
    switch (rand) {
      case 0:
        rgb = deputes1;
        break;
      case 1:
        rgb = deputes1;
        break;
      case 2:
        rgb = deputes1;
        break;
    }
  } else if (theme == "environnement") {
    switch (rand) {
      case 0:
        rgb = environnement1;
        break;
      case 1:
        rgb = environnement2;
        break;
      case 2:
        rgb = environnement3;
        break;
    }
  } else if (theme == "education") {
    switch (rand) {
      case 0:
        rgb = education1;
        break;
      case 1:
        rgb = education2;
        break;
      case 2:
        rgb = education3;
        break;
    }
  } else if (theme == "histoire") {
    switch (rand) {
      case 0:
        rgb = histoire1;
        break;
      case 1:
        rgb = histoire2;
        break;
      case 2:
        rgb = histoire3;
        break;
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
        rgb = citoyen4;
  } else if (theme == "culture") {
        rgb = culture4;
  } else if (theme == "deputes") {
        rgb = deputes4;
  } else if (theme == "environnement") {
        rgb = environnement4;
  } else if (theme == "education") {
        rgb = education4;
  } else if (theme == "histoire") {
        rgb = histoire4;
  }

  return rgb;

}
