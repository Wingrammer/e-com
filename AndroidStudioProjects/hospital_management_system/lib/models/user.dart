
class User {

  int? id;
  String? fid;
  String? birthDate;
  String? code;
  String? displayName;
  String? email;
  String? password;
  String? genre;
  String? phoneNumber;
  bool? vip;

  User({
    this.id,
    this.fid,
    this.birthDate,
    this.code,
    this.displayName,
    this.email,
    this.password,
    this.genre,
    this.phoneNumber,
    this.vip
  });

  factory User.fromSQLite(Map map){
    print('creating fromSQL');
    return User(
        id: map["id"],
        fid: map["fid"],
        birthDate: map["birthDate"],
        code: map["code"],
        displayName: map["displayName"],
        email: map["email"],
        password: map["password"],
        genre: map["genre"],
        phoneNumber: map["phoneNumber"],
        vip: map["vip"] == 0 ? false : true,
    );
  }

  factory User.fromFirebase(Map map){
    return User(
        fid: map["id"],
        birthDate: map["birthDate"],
        code: map["code"],
        displayName: map["displayName"],
        email: map["email"],
        password: map["password"],
        genre: map["genre"],
        phoneNumber: map["phoneNumber"],
        vip: map["vip"]
    );
  }

  static List<User> fromSQLiteList(List<Map> listMap) {
    List<User> users = [];
    for (Map item in listMap) {
      users.add(User.fromSQLite(item));
    }
    return users;
  }

  Map<String, dynamic> toMap() {
    return {
      "fid": id,
      "birthDate": birthDate,
      "code": code,
      "displayName": displayName,
      "email": email,
      "password": password,
      "genre": genre,
      "phoneNumber": phoneNumber,
      "vip": vip
    };
  }

}