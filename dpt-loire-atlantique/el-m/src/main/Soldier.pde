import java.util.Date;

class Soldier {
  int id;
  int matricule;
  Date dateNaissance;
  float xNaissance;
  float yNaissance;
  Date dateDeces;
  float xDeces;
  float yDeces;

  /**
  * constructeur
  */
  Soldier(int id, int matricule, Date dateNaissance, float xNaissance, float yNaissance, Date dateDeces, float xDeces, float yDeces) {
    this.id = id;
    this.matricule = matricule;
    this.dateNaissance = dateNaissance;
    this.xNaissance = xNaissance;
    this.yNaissance = yNaissance;
    this.dateDeces = dateDeces;
    this.xDeces = xDeces;
    this.yDeces = yDeces;
  }

  void convertToXY(){
    // pour map1
    //this.x = (float) ((((this.longitude - 14.15) * Math.cos(42.7))/13.20));
    //this.y = (float) ((-(this.latitude - 42.7)/ 26.7)+0.5);
    
    // pour map2  
    //this.x = (float) ((((this.longitude - 5.76) * Math.cos(47.7))/37.26));
    //this.y = (float) ((-(this.latitude - 47.7)/ 21.1)+0.5);
    
    //System.out.println(this.x + "," + this.y);
  }

  String toString() {
    return "Soldier [id=" + id + ", matricule=" + matricule + ", dateNaissance=" + dateNaissance + ", xNaissance="
        + xNaissance + ", yNaissance=" + yNaissance + ", dateDeces=" + dateDeces + ", xDeces=" + xDeces
        + ", yDeces=" + yDeces + "]";
  }

}
