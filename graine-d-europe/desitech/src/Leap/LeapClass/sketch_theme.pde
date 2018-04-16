String getTheme() {
  String themeRet = "";
  do {
  int rand = (int) (Math.random() * (audio.getNbCat()));
  
  themeRet = audio.getCatIndex(rand);
  } while (theme == themeRet);
  
  return themeRet;
}

int[] getBrighestColor() {
  if (theme.equals("Citoyen")) {
    return citoyen1;
  } else if (theme.equals("Culture")) {
    return culture1;
  } else if (theme.equals("Députés")) {
    return deputes1;
  } else if (theme.equals("Environnement")) {
    return environnement1;
  } else if (theme.equals("Éducation")) {
    return education1;
  } else if (theme.equals("Histoire")) {
    return histoire1;
  }
  return new int[3];
}

int[] getColorRGB(String theme) {
  int rand = (int) (Math.random() * (3));
  int[] rgb = new int[3];
  if (theme.equals("Citoyen")) {
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
  } else if (theme.equals("Culture")) {
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
  } else if (theme.equals("Députés")) {
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
  } else if (theme.equals("Environnement")) {
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
  } else if (theme.equals("Éducation")) {
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
  } else if (theme.equals("Histoire")) {
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

  return rgb;
}

int[] getColorTimer(String theme) {
    int[] rgb = new int[3];

    if (theme.equals("Citoyen")) {
        rgb = citoyen4;
  } else if (theme.equals("Culture")) {
        rgb = culture4;
  } else if (theme.equals("Députés")) {
        rgb = deputes4;
  } else if (theme.equals("Environnement")) {
        rgb = environnement4;
  } else if (theme.equals("Éducation")) {
        rgb = education4;
  } else if (theme.equals("Histoire")) {
        rgb = histoire4;
  }

  return rgb;

}
