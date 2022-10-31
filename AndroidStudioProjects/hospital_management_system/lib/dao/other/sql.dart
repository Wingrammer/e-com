
import 'package:hospital_management_system/models/other.dart';

class OthersConnectionSQL{
  static const createTable = '''
  CREATE TABLE others (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    nom TEXT NOT NULL,
    fabricant TEXT, 
    category TEXT,
    voie TEXT,
    "lastModified"	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllOthers() {
    return 'select * from others order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertOther(Other other) {

    return '''
    insert into others (fid, nom, fabricant, category, voie)
    values ('${other.fid}', '${other.nom}', '${other.fabricant}', '${other.category}', '${other.voie}');
    ''';
  }

  static String upsertOther(Other other) {

    return '''
    insert into others (fid, nom, fabricant, category, voie, lastModified)
    values ('${other.fid}', '${other.nom}', '${other.fabricant}', '${other.category}', '${other.voie}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${other.fid}', nom = '${other.nom}', fabricant = '${other.fabricant}', category = '${other.category}', voie = '${other.voie}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateOther(Other other) {

    return '''
    update others set fid = '${other.fid}', nom = '${other.nom}', fabricant = '${other.fabricant}', category = '${other.category}', voie = '${other.voie}' where fid = '${other.fid}';
    ''';
  }

  static String deleteOther(Other other) {
    return 'delete from others where fid = ${other.fid};';
  }

}