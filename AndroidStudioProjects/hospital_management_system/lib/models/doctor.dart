class Doctor {

  int? id;
  String fid;
  String? nom;
  String? residence;
  String? speciality;

  Doctor(
    {
      this.id,
      required this.fid,
      this.nom,
      this.residence,
      this.speciality,
    }
  );


  factory Doctor.fromFirebase(Map map){
    return Doctor(
        fid: map["id"],
        nom: map["nom"],
        residence: map["residence"],
        speciality: map["spécialité"]
    );
  }

  factory Doctor.fromSQLite(Map map){
    return Doctor(
        id: map["id"],
        fid: map["fid"],
        nom: map["nom"],
        residence: map["residence"],
        speciality: map["spécialité"]
    );
  }

  factory Doctor.empty(Map map){
    return Doctor(
        id: map[""],
        fid: map[""],
        nom: map[""],
        residence: map[""],
        speciality: map[""]
    );
  }

  Map toMap(){
    return {
      "id": "$id",
      "fid": fid,
      "nom": "$nom",
      "residence": "$residence",
      "speciality": "$speciality"
    };
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<Doctor> fromSQLiteList(List<Map> listMap) {
    List<Doctor> doctors = [];
    for (Map item in listMap) {
      doctors.add(Doctor.fromSQLite(item));
    }
    return doctors;
  }

}