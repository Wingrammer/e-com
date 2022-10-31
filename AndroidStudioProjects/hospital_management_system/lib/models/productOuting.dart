import 'dart:convert';

class ProductOuting {

  int? id;
  String fid;
  String? recu;
  String? produit;
  String? quantite;

  ProductOuting(
      {
        this.id,
        required this.fid,
        this.recu,
        this.produit,
        this.quantite,
      }
  );

  factory ProductOuting.fromFirebase(Map map){
    return ProductOuting(
        fid: map["id"],
        recu: map["Recu"],
        produit: jsonEncode(map["produit"]).replaceAll("'", "''"),
        quantite: map["quantite"]
    );
  }

  factory ProductOuting.fromSQLite(Map map){
    return ProductOuting(
        id: map["id"],
        fid: map["fid"],
        recu: map["recu"],
        produit: map["produit"],
        quantite: map["quantite"]
    );
  }

  factory ProductOuting.empty(Map map){
    return ProductOuting(
        fid: map[""],
        recu: map[""],
        produit: map[""],
        quantite: map[""]
    );
  }

  Map toMap(){
    return {
      'id': id,
      'fid': fid,
      'recu': recu,
      'produit': produit,
      'quantite': quantite
    };
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<ProductOuting> fromSQLiteList(List<Map> listMap) {
    List<ProductOuting> otherOutings = [];
    for (Map item in listMap) {
      otherOutings.add(ProductOuting.fromSQLite(item));
    }
    return otherOutings;
  }

}