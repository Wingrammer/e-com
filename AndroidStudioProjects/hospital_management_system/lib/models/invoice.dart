
import 'package:hospital_management_system/providers/database.dart';

class Invoice {

  int? id;
  String fid;
  String date;
  String vendeur;
  String reference;
  String total;

  Invoice({
    this.id,
    required this.fid,
    required this.date,
    required this.vendeur,
    required this.reference,
    required this.total
  });


  factory Invoice.fromSQLite(Map map){
    print('creating fromSQL');
    return Invoice(
        id: map["id"],
        fid: map["fid"],
        date: map["date"],
        vendeur: map["vendeur"],
        reference: map["reference"],
        total: map["total"]
    );
  }

  factory Invoice.fromFirebase(Map map){
    print('creating fromSQL');
    return Invoice(
        fid: map["id"],
        date: map["date"],
        vendeur: map["vendeur"],
        reference: map["reference"],
        total: map["total"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fid': fid,
      'date': date,
      'vendeur': vendeur,
      'reference': reference,
      'total': total
    };
  }

  factory Invoice.empty(){
    return Invoice(
        fid: '',
        date: '',
        vendeur: '',
        reference: '',
        total: ''
    );
  }

  String allFields() {
    return toMap().values.join('').toLowerCase().trim();
  }

  static List<Invoice> fromSQLiteList(List<Map> listMap) {
    List<Invoice> invoices = [];
    for (Map item in listMap) {
      invoices.add(Invoice.fromSQLite(item));
    }
    return invoices;
  }

}