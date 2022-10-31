
import 'package:hospital_management_system/models/consultation.dart';

class ConsultationsConnectionSQL{
  static const createTable = '''
  CREATE TABLE consultations (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    date TEXT NOT NULL,
    doctor TEXT,
    patient TEXT NOT NULL,
    poids TEXT,
    programmed BOOLEAN,
    taille TEXT,
    temperature TEXT,
    tension TEXT,
    urgence BOOLEAN,
    "lastModified"	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllConsultations() {
    return 'select * from consultations order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertConsultation(Consultation consultation) {

    return '''
    insert into consultations (fid, date, doctor, patient, poids, programmed, taille, temperature, tension, urgence)
    values ('${consultation.fid}', '${consultation.date}', '${consultation.doctor}', '${consultation.patient}', '${consultation.poids}', '${consultation.programmed}', '${consultation.taille}', '${consultation.temperature}', '${consultation.tension}', '${consultation.urgence}');
    ''';
  }

  static String upsertConsultation(Consultation consultation) {

    return '''
    insert into consultations (fid, date, doctor, patient, poids, programmed, taille, temperature, tension, urgence, lastModified)
    values ('${consultation.fid}', '${consultation.date}', '${consultation.doctor}', '${consultation.patient}', '${consultation.poids}', '${consultation.programmed}', '${consultation.taille}', '${consultation.temperature}', '${consultation.tension}', '${consultation.urgence}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${consultation.fid}', date = '${consultation.date}', doctor = '${consultation.doctor}', patient = '${consultation.patient}', poids = '${consultation.poids}', programmed = '${consultation.programmed}', taille = '${consultation.taille}', temperature = '${consultation.temperature}', tension = '${consultation.tension}', urgence = '${consultation.urgence}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateConsultation(Consultation consultation) {

    return '''
    update consultations set fid = '${consultation.fid}', date = '${consultation.date}', doctor = '${consultation.doctor}', patient = '${consultation.patient}', poids = '${consultation.poids}', programmed = '${consultation.programmed}', taille = '${consultation.taille}', temperature = '${consultation.temperature}', tension = '${consultation.tension}', urgence = '${consultation.urgence}' where fid = '${consultation.fid}';
    ''';
  }

  static String deleteConsultation(Consultation consultation) {
    return 'delete from consultations where fid = ${consultation.fid};';
  }

}