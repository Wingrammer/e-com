
import 'package:hospital_management_system/models/product.dart';

class ProductsConnectionSQL{
  static const createTable = '''
  CREATE TABLE products (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    nom TEXT NOT NULL,
    fabricant TEXT, 
    category TEXT,
    voie TEXT,
    lastModified	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllProducts() {
    return 'select * from products order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertProduct(Product product) {

    return '''
    insert into products (fid, nom, fabricant, category, voie)
    values ('${product.fid}', '${product.nom}', '${product.fabricant}', '${product.category}', '${product.voie}');
    ''';
  }

  static String upsertProduct(Product product) {

    return '''
    insert into products (fid, nom, fabricant, category, voie, lastModified)
    values ('${product.fid}', '${product.nom}', '${product.fabricant}', '${product.category}', '${product.voie}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${product.fid}', nom = '${product.nom}', fabricant = '${product.fabricant}', category = '${product.category}', voie = '${product.voie}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateProduct(Product product) {

    return '''
    update products set fid = '${product.fid}', nom = '${product.nom}', fabricant = '${product.fabricant}', category = '${product.category}', voie = '${product.voie}' where fid = '${product.fid}';
    ''';
  }

  static String deleteProduct(Product product) {
    return 'delete from products where fid = ${product.fid};';
  }

}