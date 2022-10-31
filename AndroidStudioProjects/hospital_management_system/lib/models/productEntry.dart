import 'dart:convert';

class ProductEntry {

  int? id;
  String fid;
  String? produit;
  String? quantite;
  String? facture;
  String? expirationDate;
  String? sellingPrice;
  String? buyingPrice;

  ProductEntry(
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

  factory ProductEntry.fromFirebase(Map map){

    return ProductEntry(
        fid: map["id"],
        produit: jsonEncode(map["produit"]).replaceAll("'", "''") ?? "",
        quantite: map["quantite"],
        expirationDate: map["Date d'expiration"],
        sellingPrice: map["Prix de vente"],
        buyingPrice: map["Prix d'achat"],
        facture: map["Facture"]
    );
  }

  factory ProductEntry.empty(Map map){
    return ProductEntry(
        fid: map[""],
        produit: map[""],
        quantite: map[""],
        expirationDate: map[""],
        sellingPrice: map[""],
        buyingPrice: map[""],
        facture: map[""]
    );
  }

  factory ProductEntry.fromSQLite(Map map){
    return ProductEntry(
        id: map["id"],
        fid: map["fid"],
        produit: map["produit"],
        quantite: map["quantite"],
        expirationDate: map["expirationDate"],
        sellingPrice: map["sellingPrice"],
        buyingPrice: map["buyingPrice"],
        facture: map["facture"]
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

  static List<ProductEntry> fromSQLiteList(List<Map> listMap) {
    List<ProductEntry> otherEntries = [];
    for (Map item in listMap) {
      otherEntries.add(ProductEntry.fromSQLite(item));
    }
    return otherEntries;
  }

}