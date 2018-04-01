import java.util.ArrayList;

class SoldiersList {

  ArrayList<Soldier> list;

  /**
  * constructeur
  */
  SoldiersList() {
    this.list = new ArrayList<Soldier>();
  }

  /**
  * remplissage de la liste à partir du json
  */
  void initialize() {
    JSONArray values = loadJSONArray("example.json");
    for (int i = 0; i < values.size(); i++) {
      JSONObject soldier = values.getJSONObject(i); 

      int id = soldier.getInt("id");
      int matricule = soldier.getInt("matricule");

      String dateNaissanceStr = soldier.getString("dateNaissance");
      Date dateNaissance = new Date(int(dateNaissanceStr.split("/")[1]), int(dateNaissanceStr.split("/")[0]), 0, 0, 0);
      float xNaissance = Float.parseFloat(soldier.getString("xNaissance"));
      float yNaissance = Float.parseFloat(soldier.getString("yNaissance"));

      String dateDecesStr = soldier.getString("dateDeces");
      Date dateDeces = new Date(int(dateDecesStr.split("/")[1]), int(dateDecesStr.split("/")[0]), 0, 0, 0);
      float xDeces = Float.parseFloat(soldier.getString("xDeces"));
      float yDeces = Float.parseFloat(soldier.getString("yDeces"));

      this.list.add(new Soldier(id, matricule, dateNaissance, xNaissance, yNaissance, dateDeces, xDeces, yDeces));
    } 
  }

  /**
  * renvoie le nombre de soldat dans la liste
  */
  int getSize(){
    return this.list.size();
  }

  String toString() {
    String str = "";
    for(Soldier s : this.list){
      str+=s.toString()+"\n";
    }
    return str;
  }
}
