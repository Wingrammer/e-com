
import 'package:hospital_management_system/models/income.dart';

class IncomesConnectionSQL{
  static const createTable = '''
  CREATE TABLE incomes (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    date TEXT NOT NULL,
    patient TEXT NOT NULL,
    reference TEXT NOT NULL, 
    total TEXT NOT NULL,
    lastModified	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllIncomes() {
    return 'select * from incomes order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertIncome(Income income) {

    return '''
    insert into incomes (fid, date, patient, reference, total)
    values ('${income.fid}', '${income.date}', '${income.patient}', '${income.reference}', '${income.total}');
    ''';
  }

  static String upsertIncome(Income income) {

    return '''
    insert into incomes (fid, date, patient, reference, total, lastModified)
    values ('${income.fid}', '${income.date}', '${income.patient}', '${income.reference}', '${income.total}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${income.fid}', date = '${income.date}', patient = '${income.patient}', reference = '${income.reference}', total = '${income.total}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateIncome(Income income) {

    return '''
    update incomes set fid = '${income.fid}', date = '${income.date}', patient = '${income.patient}', reference = '${income.reference}', total = '${income.total}' where fid = '${income.fid}';
    ''';
  }

  static String deleteIncome(Income income) {
    return 'delete from incomes where fid = ${income.fid};';
  }

}