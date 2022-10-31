class Product {

  int? id;
  String fid;
  String? nom;
  String? fabricant;
  String? voie;
  String? category;

  Product(
      {
        this.id,
        required this.fid,
        this.nom,
        this.fabricant,
        this.voie,
        this.category,
      }
      );

  factory Product.fromFirebase(Map map){
    //print(map["Nom"]);
    return Product(
        fid: map["id"],
        nom: map["Nom"],
        fabricant: map["Fabricant"],
        category: map["Categorie"],
        voie: map["Voie d'application"]
    );
  }

  factory Product.empty(Map map){
    return Product(
        fid: map[""],
        nom: map[""],
        fabricant: map[""],
        category: map[""],
        voie: map[""]
    );
  }

  factory Product.fromSQLite(Map map){
    return Product(
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

  static List<Product> fromSQLiteList(List<Map> listMap) {
    List<Product> others = [];
    for (Map item in listMap) {
      others.add(Product.fromSQLite(item));
    }
    return others;
  }

}