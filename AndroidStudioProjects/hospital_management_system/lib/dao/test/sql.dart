
import 'package:hospital_management_system/models/test.dart';

class TestsConnectionSQL{
  static const createTable = '''
  CREATE TABLE tests (
    id INTEGER,
    fid TEXT NOT NULL UNIQUE,
    recu TEXT NOT NULL,
    service TEXT NOT NULL,
    lastModified	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllTests() {
    return 'select * from tests order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertTest(Test test) {

    return '''
    insert into tests (fid, recu, service)
    values ('${test.fid}', '${test.recu}', '${test.service}');
    ''';
  }

  static String upsertTest(Test test) {

    return '''
    insert into tests (fid, recu, service, lastModified)
    values ('${test.fid}', '${test.recu}', '${test.service}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${test.fid}', recu = '${test.recu}', service = '${test.service}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateTest(Test test) {

    return '''
    update tests set fid = '${test.fid}', recu = '${test.recu}', service = '${test.service}' where fid = '${test.fid}';
    ''';
  }

  static String deleteTest(Test test) {
    return 'delete from tests where fid = ${test.fid};';
  }

}