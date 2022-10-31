class Service {

  int? id;
  String fid;
  String? department;
  String? nom;
  String? prix;

  Service(
    {
      this.id,
      required this.fid,
      this.department,
      this.nom,
      this.prix,
    }
  );

  factory Service.fromFirebase(Map map){
    return Service(
        fid: map["id"],
        department: map["Departement"],
        nom: map["Nom"],
        prix: map["Prix"]
    );
  }

  factory Service.empty(Map<String, dynamic> map){
    return Service(
        fid: map[""],
        department: map[""],
        nom: map[""],
        prix: map[""]
    );
  }

  factory Service.fromSQLite(Map map){
    return Service(
        id: map["id"],
        fid: map["fid"],
        department: map["department"],
        nom: map["nom"],
        prix: map["prix"]
    );
  }

  Map toMap(){
    return {
      'id': id,
      'fid': fid,
      'department': department,
      'nom': nom,
      'prix': prix
    };
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<Service> fromSQLiteList(List<Map> listMap) {
    List<Service> services = [];
    for (Map item in listMap) {
      services.add(Service.fromSQLite(item));
    }
    return services;
  }

}