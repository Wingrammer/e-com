class OtherOuting {

  int? id;
  String fid;
  String? recu;
  String? produit;
  String? quantite;

  OtherOuting(
    {
      this.id,
      required this.fid,
      this.recu,
      this.produit,
      this.quantite,
    }
  );

  factory OtherOuting.fromFirebase(Map map){
    return OtherOuting(
        fid: map["id"],
        recu: map["Recu"],
        produit: map["produit"].toString().replaceAll("'", "''"),
        quantite: map["quantite"]
    );
  }

  factory OtherOuting.fromSQLite(Map map){
    return OtherOuting(
        id: map["id"],
        fid: map["fid"],
        recu: map["recu"],
        produit: map["produit"],
        quantite: map["quantite"]
    );
  }

  factory OtherOuting.empty(Map map){
    return OtherOuting(
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

  static List<OtherOuting> fromSQLiteList(List<Map> listMap) {
    List<OtherOuting> otherOutings = [];
    for (Map item in listMap) {
      otherOutings.add(OtherOuting.fromSQLite(item));
    }
    return otherOutings;
  }

}