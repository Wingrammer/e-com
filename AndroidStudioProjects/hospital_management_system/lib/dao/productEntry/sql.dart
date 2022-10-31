
import 'package:hospital_management_system/models/productEntry.dart';

class ProductEntriesConnectionSQL{
  static const createTable = '''
  CREATE TABLE productEntries (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    produit TEXT NOT NULL,
    quantite TEXT NOT NULL, 
    expirationDate TEXT NOT NULL,
    sellingPrice TEXT,
    buyingPrice TEXT NOT NULL,
    facture TEXT NOT NULL,
    lastModified	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllProductEntries() {
    return 'select * from productEntries order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertProductEntry(ProductEntry productEntry) {

    return '''
    insert into productEntries (fid, produit, quantite, expirationDate, sellingPrice, buyingPrice, facture)
    values ('${productEntry.fid}', '${productEntry.produit}', '${productEntry.quantite}', '${productEntry.expirationDate}', '${productEntry.sellingPrice}', '${productEntry.buyingPrice}', '${productEntry.facture}');
    ''';
  }

  static String upsertProductEntry(ProductEntry productEntry) {

    return '''
    insert into productEntries (fid, produit, quantite, expirationDate, sellingPrice, buyingPrice, facture, lastModified)
    values ('${productEntry.fid}', '${productEntry.produit}', '${productEntry.quantite}', '${productEntry.expirationDate}', '${productEntry.sellingPrice}', '${productEntry.buyingPrice}', '${productEntry.facture}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${productEntry.fid}', produit = '${productEntry.produit}', quantite = '${productEntry.quantite}', expirationDate = '${productEntry.expirationDate}', sellingPrice = '${productEntry.sellingPrice}', buyingPrice = '${productEntry.buyingPrice}', facture = '${productEntry.facture}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateProductEntry(ProductEntry productEntry) {

    return '''
    update productEntries set fid = '${productEntry.fid}', produit = '${productEntry.produit}', quantite = '${productEntry.quantite}', expirationDate = '${productEntry.expirationDate}', sellingPrice = '${productEntry.sellingPrice}', buyingPrice = '${productEntry.buyingPrice}', facture = '${productEntry.facture}' where fid = '${productEntry.fid}';
    ''';
  }

  static String deleteProductEntry(ProductEntry productEntry) {
    return 'delete from productEntries where fid = ${productEntry.fid};';
  }

}