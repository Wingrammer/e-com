import 'package:hospital_management_system/models/service.dart';

class ServicesConnectionSQL{
  static const createTable = '''
  CREATE TABLE services (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    department TEXT NOT NULL,
    nom TEXT NOT NULL, 
    prix TEXT NOT NULL,
    lastModified	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllServices() {
    return 'select * from services order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertService(Service service) {

    return '''
    insert into services (fid, department, nom, prix)
    values ('${service.fid}', '${service.department}', '${service.nom}', '${service.prix}');
    ''';
  }

  static String upsertService(Service service) {

    return '''
    insert into services (fid, department, nom, prix, lastModified)
    values ('${service.fid}', '${service.department}', '${service.nom}', '${service.prix}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${service.fid}', department = '${service.department}', nom = '${service.nom}', prix = '${service.prix}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateService(Service service) {

    return '''
    update services set fid = '${service.fid}', department = '${service.department}', nom = '${service.nom}', prix = '${service.prix}' where fid = '${service.fid}';
    ''';
  }

  static String deleteService(Service service) {
    return 'delete from services where fid = ${service.fid};';
  }

}