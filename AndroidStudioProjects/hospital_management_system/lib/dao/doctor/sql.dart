
import 'package:hospital_management_system/models/doctor.dart';

class DoctorsConnectionSQL{
  static const createTable = '''
  CREATE TABLE doctors (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    nom TEXT,
    residence TEXT, 
    speciality TEXT,
    lastModified INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllDoctors() {
    return 'select * from doctors order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertDoctor(Doctor doctor) {

    return '''
    insert into doctors (fid, nom, residence, speciality)
    values ('${doctor.fid}', '${doctor.nom}', '${doctor.residence}', '${doctor.speciality}');
    ''';
  }

  static String upsertDoctor(Doctor doctor) {

    return '''
    insert into doctors (fid, nom, residence, speciality, lastModified)
    values ('${doctor.fid}', '${doctor.nom}', '${doctor.residence}', '${doctor.speciality}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${doctor.fid}', nom = '${doctor.nom}', residence = '${doctor.residence}', speciality = '${doctor.speciality}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateDoctor(Doctor doctor) {

    return '''
    update doctors set fid = '${doctor.fid}', nom = '${doctor.nom}', residence = '${doctor.residence}', speciality = '${doctor.speciality}' where fid = '${doctor.fid}';
    ''';
  }

  static String deleteDoctor(Doctor doctor) {
    return 'delete from doctors where fid = ${doctor.fid};';
  }

}