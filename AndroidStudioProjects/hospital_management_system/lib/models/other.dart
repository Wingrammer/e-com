class Other {

  int? id;
  String fid;
  String? nom;
  String? fabricant;
  String? voie;
  String? category;

  Other(
    {
      this.id,
      required this.fid,
      this.nom,
      this.fabricant,
      this.voie,
      this.category,
    }
  );

  factory Other.fromFirebase(Map map){
    return Other(
        fid: map["id"],
        nom: map["Nom"],
        fabricant: map["Fabricant"],
        category: map["Categorie"],
        voie: map["Voie d'application"]
    );
  }

  factory Other.empty(Map map){
    return Other(
        fid: map[""],
        nom: map[""],
        fabricant: map[""],
        category: map[""],
        voie: map[""]
    );
  }

  factory Other.fromSQLite(Map map){
    return Other(
        id: map["id"],
        fid: map["fid"],
        nom: map["Nom"],
        fabricant: map["Fabricant"],
        category: map["Categorie"],
        voie: map["Voie d'application"]
    );
  }

  Map toMap(){
    return {
      'id': id,
      'fid': fid,
      'nom': nom,
      'fabricant': fabricant,
      'voie': voie,
      'category': category
    };
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<Other> fromSQLiteList(List<Map> listMap) {
    List<Other> others = [];
    for (Map item in listMap) {
      others.add(Other.fromSQLite(item));
    }
    return others;
  }

}