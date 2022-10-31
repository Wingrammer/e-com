import 'dart:io';

import 'package:syncfusion_flutter_xlsio/xlsio.dart';


class Export{

  static Directory findRoot(FileSystemEntity entity) {
    final Directory parent = entity.parent;
    if (parent.path == entity.path) return parent;
    return findRoot(parent);
  }

  static excelFile(List data, String path) async{
    // Create a new Excel Document.
    final Workbook workbook = Workbook();
    String cols = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    // Accessing sheet via index.
    final Worksheet sheet = workbook.worksheets[0];
    if(data.isNotEmpty){
      List keys = data[0].toMap().keys.toList();
      var i = 1;
      var j = 0;
      for (var element in keys) {
        sheet.getRangeByName(cols.substring(j, j+1)+i.toString()).setText(element);
        j++;
      }
      i++;
      for (var element in data) {
        List values = element.toMap().keys.toList();
        j = 0;
        for (var value in values) {
          sheet.getRangeByName(cols.substring(j, j+1)+i.toString()).setText('${element.toMap()[value]}');
          j++;
        }
        i++;
      }
    }
    // Save and dispose workbook.
    final List<int> bytes = workbook.saveAsStream();
    File file = await File('$path/${DateTime.now()}.xlsx').create(recursive: true);
    file.writeAsBytes(bytes);
    workbook.dispose();
  }

}