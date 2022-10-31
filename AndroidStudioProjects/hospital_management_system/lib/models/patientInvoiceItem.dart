import 'dart:convert';

class PatientInvoiceItem {

  int? id;
  String? fid;
  String? conclusion;
  String? consultation;
  bool? paid;
  String? note;
  String? status;
  String? service;
  String? receipt;
  String? result;
  String? quantite;

  PatientInvoiceItem(
    {
      this.id,
      required this.fid,
      this.conclusion,
      this.consultation,
      this.paid,
      this.note,
      this.quantite,
      this.service,
      this.status,
      this.result,
      this.receipt,
    }
  );

  factory PatientInvoiceItem.fromFirebase(Map map){
    return PatientInvoiceItem(
        fid: map["id"],
        conclusion: map["conclusion"],
        consultation: jsonEncode(map["consultation"]).replaceAll("'", "''") ?? "",
        note: map["note"],
        receipt: map["receipt"],
        status: map["status"],
        result: map["result"],
        quantite: map["quantite"].toString(),
        service: jsonEncode(map["service"]).replaceAll("'", "''") ?? "",
        paid: map["paid"]
    );
  }

  factory PatientInvoiceItem.fromSQLite(Map map){
    return PatientInvoiceItem(
        id: map["id"],
        fid: map["fid"],
        conclusion: map["conclusion"],
        consultation: map["consultation"],
        note: map["note"],
        receipt: map["receipt"],
        status: map["status"],
        result: map["result"],
        quantite: map["quantite"],
        service: map["service"],
        paid: map["paid"] == 0 ? false : true
    );
  }

  factory PatientInvoiceItem.empty(Map map){
    return PatientInvoiceItem(
        fid: map[""],
        conclusion: map[""],
        consultation: map[""],
        note: map[""],
        receipt: map[""],
        status: map[""],
        result: map[""],
        quantite: map[""],
        service: map[""],
        paid: map[""]
    );
  }

  Map toMap(){
    return {
      'id': id,
      'fid': fid,
      'conclusion': conclusion,
      'consultation': consultation,
      'service': service,
      'status': status,
      'result': result,
      'receipt': receipt,
      'quantite': quantite,
      'paid': paid,
      'note': note
    };
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<PatientInvoiceItem> fromSQLiteList(List<Map> listMap) {
    List<PatientInvoiceItem> patientInvoiceItems = [];
    for (Map item in listMap) {
      patientInvoiceItems.add(PatientInvoiceItem.fromSQLite(item));
    }
    return patientInvoiceItems;
  }

}