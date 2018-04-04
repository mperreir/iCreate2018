import processing.sound.*;
import java.util.Map;
import java.util.Iterator;

/**
* Audio class
*/
class AudioFiles {
  
  boolean playing = false;
  SoundFile play;
  HashMap<String, ArrayList<String>> musics;
  
  AudioFiles() {
    String path = sketchPath();
    
    String[] directoriesNames = listFileNames(path + "/data/");
    
    this.musics = new HashMap<String, ArrayList<String>>();
    
    for (String dname : directoriesNames) {
      if (!dname.equals("DK_Bocadillo.otf") && !dname.equals("vrac.mp3")) {
        this.musics.put(dname, new ArrayList<String>());
        String[] filesNames = listFileNames(path + "/data/" + dname + "/");
        for (String aname : filesNames) {
          aname = aname.split("\\.")[0] += " ?";
          this.musics.get(dname).add(aname);
        }
      }
    }
  }
  
  /**
  * Change the amplitude of the audio (fading ish)
  */
  void changeAmp() {
    if (!coefAmpReach && coefAmp < 1 && coefAmpHigher) {
      coefAmp += coefAmpProgression;
      this.play.amp(coefAmp);
      if ((coefAmp - 1) > 0.001) {
        coefAmpReach = true;
        coefAmpHigher = false;
      }
    } else if (!coefAmpReach && coefAmp > 0 && !coefAmpHigher) {
      coefAmp -= coefAmpProgression;
      this.play.amp(coefAmp);
      if ((coefAmp - 0) < 0.001) {
        coefAmpReach = true;
        coefAmpHigher = true;
        this.play.stop();
        this.playing = false;
      }
    }
  }
  
  /**
  * Plays the brouhaha
  * @param pa The parent applet in order to play sound file
  */
  void playVrac(PApplet pa) {
    if (!this.playing) {
      this.play = new SoundFile(pa, "vrac.mp3");
      this.play.loop();
      this.playing = true;
    }
  }
  
  /**
  * Play the current selected audio file
  */
  void play() {
    this.play.play();
  }
  
  /**
  * Get the duration of the audio file
  * @param pa The parent application in order to create a sound file
  * @param theme The current selected theme
  * @param video The video go the the duration
  * @return The duration of the audio file
  */
  float getDuration(PApplet pa,String theme, String video) {
    video = video.substring(0,video.length() - 2);
    System.out.println(theme + "/" + video + ".mp3");
    this.play = new SoundFile(pa, theme + "/" + video + ".mp3");
    return this.play.duration();
  }
  
  // This function returns all the files in a directory as an array of Strings  
  private String[] listFileNames(String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    } else {
      // If it's not a directory
      return null;
    }
  }
  
  // Recursive function to traverse subdirectories
  void recurseDir(ArrayList<File> a, String dir) {
    File file = new File(dir);
    if (file.isDirectory()) {
      // If you want to include directories in the list
      a.add(file);  
      File[] subfiles = file.listFiles();
      for (int i = 0; i < subfiles.length; i++) {
        // Call this function on all files in this directory
        recurseDir(a, subfiles[i].getAbsolutePath());
      }
    } else {
      a.add(file);
    }
  }
  
  int getNbCat() {
    return this.musics.size();
  }
  
  int getNbMusicsForCat(String cat) {
    return this.musics.get(cat).size();
  }
  
  String getCatIndex(int index) {
    for (String key : this.musics.keySet()) {
      if (index == 0) {
        return key;
      }
      index--;
    }
    return null;
  }
  
  String getMusicAtCatByIndex(String cat, int index) {
    return this.musics.get(cat).get(index);
  }
  
}
