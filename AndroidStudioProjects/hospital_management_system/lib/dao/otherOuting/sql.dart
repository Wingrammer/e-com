
import 'package:hospital_management_system/models/otherOuting.dart';

class OtherOutingsConnectionSQL{
  static const createTable = '''
  CREATE TABLE otherOutings (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    recu TEXT,
    produit TEXT, 
    quantite TEXT,
    lastModified	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllOtherOutings() {
    return 'select * from otherOutings order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertOtherOuting(OtherOuting otherOuting) {

    return '''
    insert into otherOutings (fid, recu, produit, quantite)
    values ('${otherOuting.fid}', '${otherOuting.recu}', '${otherOuting.produit}', '${otherOuting.quantite}');
    ''';
  }

  static String upsertOtherOuting(OtherOuting otherOuting) {

    return '''
    insert into otherOutings (fid, recu, produit, quantite, lastModified)
    values ('${otherOuting.fid}', '${otherOuting.recu}', '${otherOuting.produit}', '${otherOuting.quantite}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${otherOuting.fid}', recu = '${otherOuting.recu}', produit = '${otherOuting.produit}', quantite = '${otherOuting.quantite}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateOtherOuting(OtherOuting otherOuting) {

    return '''
    update otherOutings set fid = '${otherOuting.fid}', recu = '${otherOuting.recu}', produit = '${otherOuting.produit}', quantite = '${otherOuting.quantite}' where fid = '${otherOuting.fid}';
    ''';
  }

  static String deleteOtherOuting(OtherOuting otherOuting) {
    return 'delete from otherOutings where fid = ${otherOuting.fid};';
  }

}