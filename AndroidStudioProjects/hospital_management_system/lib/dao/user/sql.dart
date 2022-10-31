
import 'package:hospital_management_system/models/user.dart';

class UsersConnectionSQL{
  static const createTable = '''
  CREATE TABLE users (
    `id` INTEGER,
    `fid` TEXT NOT NULL UNIQUE,
    `birthDate` TEXT,
    `code` TEXT, 
    `displayName` TEXT,
    `email` TEXT,
    `password` TEXT,
    `genre` TEXT,
    `phoneNumber` TEXT,
    `vip` BOOLEAN,
    `lastModified`	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllUsers() {
    return 'select * from users order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertUser(User user) {

    int vip = user.vip==true ? 1 : 0;
    return '''
    insert into users (fid, birthDate, displayName, code, email, password, genre, phoneNumber, vip)
    values ('${user.fid}', '${user.birthDate}', '${user.displayName}', '${user.code}', '${user.email}', '${user.password}', '${user.genre}', '${user.phoneNumber}', $vip);
    ''';
  }

  static String upsertUser(User user) {
    int vip = user.vip==true ? 1 : 0;
    return '''
    insert into users (fid, birthDate, displayName, code, email, password, genre, phoneNumber, vip, lastModified)
    values ('${user.fid}', '${user.birthDate}', '${user.displayName}', '${user.code}', '${user.email}', '${user.password}', '${user.genre}', '${user.phoneNumber}', $vip, ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${user.fid}', birthDate = '${user.birthDate}', code = '${user.code}', displayName = '${user.displayName}', email = '${user.email}', password = '${user.password}', genre = '${user.genre}', phoneNumber = '${user.phoneNumber}', vip = $vip, lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateUser(User user) {
    int vip = user.vip==true ? 1 : 0;
    return '''
    update users set fid = '${user.fid}', birthDate = '${user.birthDate}', code = '${user.code}', displayName = '${user.displayName}', email = '${user.email}', password = '${user.password}', genre = '${user.genre}', phoneNumber = '${user.phoneNumber}', vip = $vip where fid = '${user.fid}';
    ''';
  }

  static String deleteUser(User user) {
    return 'delete from users where fid = ${user.fid};';
  }

}