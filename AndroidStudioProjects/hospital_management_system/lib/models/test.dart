class Test {

  int? id;
  String fid;
  String? recu;
  String? service;

  Test(
    {
      this.id,
      required this.fid,
      this.recu,
      this.service,
    }
  );

  factory Test.fromFirebase(Map map){
    return Test(
        fid: map["id"],
        recu: map["Recu"],
        service: map["service"].toString()
    );
  }

  factory Test.empty(Map map){
    return Test(
        fid: map[""],
        recu: map[""],
        service: map[""]
    );
  }

  factory Test.fromSQLite(Map map){
    return Test(
        id: map["id"],
        fid: map["fid"],
        recu: map["Recu"],
        service: map["service"]
    );
  }

  Map toMap(){
    return {
      'id': id,
      'fid': fid,
      'recu': recu,
      'service': service
    };
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<Test> fromSQLiteList(List<Map> listMap) {
    List<Test> tests = [];
    for (Map item in listMap) {
      tests.add(Test.fromSQLite(item));
    }
    return tests;
  }

}