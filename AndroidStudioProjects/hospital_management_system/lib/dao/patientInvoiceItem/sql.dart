import 'package:hospital_management_system/models/patientInvoiceItem.dart';

class PatientInvoiceItemsConnectionSQL{
  static const createTable = '''
  CREATE TABLE patientInvoiceItems (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    conclusion TEXT,
    consultation TEXT NOT NULL, 
    note TEXT,
    receipt TEXT NOT NULL,
    status TEXT,
    result TEXT,
    quantite TEXT NOT NULL,
    service TEXT NOT NULL,
    paid BOOLEAN NOT NULL,
    lastModified	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllPatientInvoiceItems() {
    return 'select * from patientInvoiceItems order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertPatientInvoiceItem(PatientInvoiceItem patientInvoiceItem) {

    return '''
    insert into patientInvoiceItems (fid, conclusion, consultation, note, receipt, status, result, quantite, service, paid)
    values ('${patientInvoiceItem.fid}', '${patientInvoiceItem.conclusion}', '${patientInvoiceItem.consultation}', '${patientInvoiceItem.note}', '${patientInvoiceItem.receipt}', '${patientInvoiceItem.status}', '${patientInvoiceItem.result}', '${patientInvoiceItem.quantite}', '${patientInvoiceItem.service}', '${patientInvoiceItem.paid}');
    ''';
  }

  static String upsertPatientInvoiceItem(PatientInvoiceItem patientInvoiceItem) {

    return '''
    insert into patientInvoiceItems (fid, conclusion, consultation, note, receipt, status, result, quantite, service, paid, lastModified)
    values ('${patientInvoiceItem.fid}', '${patientInvoiceItem.conclusion}', '${patientInvoiceItem.consultation}', '${patientInvoiceItem.note}', '${patientInvoiceItem.receipt}', '${patientInvoiceItem.status}', '${patientInvoiceItem.result}', '${patientInvoiceItem.quantite}', '${patientInvoiceItem.service}', '${patientInvoiceItem.paid}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${patientInvoiceItem.fid}', conclusion = '${patientInvoiceItem.conclusion}', consultation = '${patientInvoiceItem.consultation}', note = '${patientInvoiceItem.note}', receipt = '${patientInvoiceItem.receipt}', status = '${patientInvoiceItem.status}', result = '${patientInvoiceItem.result}', quantite = '${patientInvoiceItem.quantite}', service = '${patientInvoiceItem.service}', paid = '${patientInvoiceItem.paid}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updatePatientInvoiceItem(PatientInvoiceItem patientInvoiceItem) {

    return '''
    update patientInvoiceItems set fid = '${patientInvoiceItem.fid}', conclusion = '${patientInvoiceItem.conclusion}', consultation = '${patientInvoiceItem.consultation}', note = '${patientInvoiceItem.note}', receipt = '${patientInvoiceItem.receipt}', status = '${patientInvoiceItem.status}', result = '${patientInvoiceItem.result}', quantite = '${patientInvoiceItem.quantite}', service = '${patientInvoiceItem.service}', paid = '${patientInvoiceItem.paid}' where fid = '${patientInvoiceItem.fid}';
    ''';
  }

  static String deletePatientInvoiceItem(PatientInvoiceItem patientInvoiceItem) {
    return 'delete from patientInvoiceItems where fid = ${patientInvoiceItem.fid};';
  }

}