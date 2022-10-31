class OtherEntry {

  int? id;
  String fid;
  String? produit;
  String? quantite;
  String? facture;
  String? expirationDate;
  String? sellingPrice;
  String? buyingPrice;

  OtherEntry(
    {
      this.id,
      required this.fid,
      this.produit,
      this.quantite,
      this.facture,
      this.expirationDate,
      this.sellingPrice,
      this.buyingPrice,
    }
  );

  factory OtherEntry.fromFirebase(Map map){
    return OtherEntry(
        fid: map["id"],
        produit: map["Nom"],
        quantite: map["quantite"],
        expirationDate: map["Date d'expiration"],
        sellingPrice: map["Prix d'achat"],
        buyingPrice: map["Prix de vente"],
        facture: map["Facture"]
    );
  }

  factory OtherEntry.empty(Map map){
    return OtherEntry(
        fid: map[""],
        produit: map[""],
        quantite: map[""],
        expirationDate: map[""],
        sellingPrice: map[""],
        buyingPrice: map[""],
        facture: map[""]
    );
  }

  factory OtherEntry.fromSQLite(Map map){
    return OtherEntry(
        id: map["id"],
        fid: map["fid"],
        produit: map["Nom"],
        quantite: map["quantite"],
        expirationDate: map["Date d'expiration"],
        sellingPrice: map["Prix d'achat"],
        buyingPrice: map["Prix de vente"],
        facture: map["Facture"]
    );
  }

  Map toMap(){
    return {
      'id': id,
      'fid': id,
      'produit': produit,
      'quantite': quantite,
      'facture': facture,
      'expirationDate': expirationDate,
      'sellingPrice': sellingPrice,
      'buyingPrice': buyingPrice
    };
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<OtherEntry> fromSQLiteList(List<Map> listMap) {
    List<OtherEntry> otherEntries = [];
    for (Map item in listMap) {
      otherEntries.add(OtherEntry.fromSQLite(item));
    }
    return otherEntries;
  }

}