import 'dart:convert';

class Income {

  int? id;
  String fid;
  String? date;
  String? patient;
  String? reference;
  String? total;
  String patientCode = '';

  Income(
    {
      this.id,
      required this.fid,
      this.date,
      this.patient,
      this.reference,
      this.total,
    }
  );

  factory Income.fromSQLite(Map map){
    return Income(
        id: map["id"],
        fid: map["fid"],
        date: map["date"],
        patient: map["patient"],
        reference: map["reference"],
        total: map["total"]
    );
  }

  factory Income.fromFirebase(Map map){
    String code;
    if(map["patient"]!["_path"]!=null){
      code = map["patient"]!["_path"]!["segments"]![1];
    }
    else{
      code = map["patient"]!["code"];
    }
    return Income(
        fid: map["id"],
        date: map["date"],
        patient: jsonEncode(map["patient"]).replaceAll("'", "''") ?? "",
        reference: map["reference"],
        total: map["total"].toString()
    );
  }

  factory Income.empty(){
    return Income(
        fid: "",
        date: "",
        patient: "",
        reference: "",
        total: ""
    );
  }

  Map<String, Object?> toMap(){
    return {
      'id': id,
      'fid': fid,
      'date': date,
      'patient': patient,
      'reference': reference,
      "total": total
    };
  }

  set patient_code(String code){
    patientCode = code;
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<Income> fromSQLiteList(List<Map> listMap) {
    List<Income> incomes = [];
    for (Map item in listMap) {
      incomes.add(Income.fromSQLite(item));
    }
    return incomes;
  }

}