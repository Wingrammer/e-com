
import 'package:hospital_management_system/models/otherEntry.dart';

class OtherEntriesConnectionSQL{
  static const createTable = '''
  CREATE TABLE otherEntries (
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

  static String selectAllOtherEntries() {
    return 'select * from otherEntries order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertOtherEntry(OtherEntry otherEntry) {

    return '''
    insert into otherEntries (fid, produit, quantite, expirationDate, sellingPrice, buyingPrice, facture)
    values ('${otherEntry.fid}', '${otherEntry.produit}', '${otherEntry.quantite}', '${otherEntry.expirationDate}', '${otherEntry.sellingPrice}', '${otherEntry.buyingPrice}', '${otherEntry.facture}');
    ''';
  }

  static String upsertOtherEntry(OtherEntry otherEntry) {

    return '''
    insert into otherEntries (fid, produit, quantite, expirationDate, sellingPrice, buyingPrice, facture, lastModified)
    values ('${otherEntry.fid}', '${otherEntry.produit}', '${otherEntry.quantite}', '${otherEntry.expirationDate}', '${otherEntry.sellingPrice}', '${otherEntry.buyingPrice}', '${otherEntry.facture}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${otherEntry.fid}', produit = '${otherEntry.produit}', quantite = '${otherEntry.quantite}', expirationDate = '${otherEntry.expirationDate}', sellingPrice = '${otherEntry.sellingPrice}', buyingPrice = '${otherEntry.buyingPrice}', facture = '${otherEntry.facture}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateOtherEntry(OtherEntry otherEntry) {

    return '''
    update otherEntries set fid = '${otherEntry.fid}', produit = '${otherEntry.produit}', quantite = '${otherEntry.quantite}', expirationDate = '${otherEntry.expirationDate}', sellingPrice = '${otherEntry.sellingPrice}', buyingPrice = '${otherEntry.buyingPrice}', facture = '${otherEntry.facture}' where fid = '${otherEntry.fid}';
    ''';
  }

  static String deleteOtherEntry(OtherEntry otherEntry) {
    return 'delete from otherEntries where fid = ${otherEntry.fid};';
  }

}