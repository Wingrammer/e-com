
import 'package:hospital_management_system/models/productOuting.dart';

class ProductOutingsConnectionSQL{
  static const createTable = '''
  CREATE TABLE productOutings (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    recu TEXT,
    produit TEXT, 
    quantite TEXT,
    lastModified	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllProductOutings() {
    return 'select * from productOutings order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertProductOuting(ProductOuting productOuting) {

    return '''
    insert into productOutings (fid, recu, produit, quantite)
    values ('${productOuting.fid}', '${productOuting.recu}', '${productOuting.produit}', '${productOuting.quantite}');
    ''';
  }

  static String upsertProductOuting(ProductOuting productOuting) {

    return '''
    insert into productOutings (fid, recu, produit, quantite, lastModified)
    values ('${productOuting.fid}', '${productOuting.recu}', '${productOuting.produit}', '${productOuting.quantite}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${productOuting.fid}', recu = '${productOuting.recu}', produit = '${productOuting.produit}', quantite = '${productOuting.quantite}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateProductOuting(ProductOuting productOuting) {

    return '''
    update productOutings set fid = '${productOuting.fid}', recu = '${productOuting.recu}', produit = '${productOuting.produit}', quantite = '${productOuting.quantite}' where fid = '${productOuting.fid}';
    ''';
  }

  static String deleteProductOuting(ProductOuting productOuting) {
    return 'delete from productOutings where fid = ${productOuting.fid};';
  }

}