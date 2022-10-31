
import 'package:hospital_management_system/models/invoice.dart';

class InvoicesConnectionSQL{
  static const createTable = '''
  CREATE TABLE "invoices" (
    "id" INTEGER,
    "fid" TEXT NOT NULL UNIQUE,
    "date" TEXT NOT NULL,
    "vendeur" TEXT NOT NULL,
    "reference" TEXT NOT NULL, 
    "total" TEXT NOT NULL,
    "lastModified"	INTEGER DEFAULT 'STRFTIME(''%s'', ''now'') * 1000',
    PRIMARY KEY (`id`, `fid`)
  );
  ''';

  static String selectAllInvoices() {
    return 'select * from invoices order by lastModified desc;';
  }

  int parseBool(boolean) => boolean ? 1 : 0;

  static String insertInvoice(Invoice invoice) {

    return '''
    insert into invoices (fid, date, vendeur, reference, total)
    values ('${invoice.fid}', '${invoice.date}', '${invoice.vendeur}', '${invoice.reference}', '${invoice.total}');
    ''';
  }

  static String upsertInvoice(Invoice invoice) {

    return '''
    insert into invoices (fid, date, vendeur, reference, total, lastModified)
    values ('${invoice.fid}', '${invoice.date}', '${invoice.vendeur}', '${invoice.reference}', '${invoice.total}', ${DateTime.now().millisecondsSinceEpoch})
    on conflict(fid) do update set fid = '${invoice.fid}', date = '${invoice.date}', vendeur = '${invoice.vendeur}', reference = '${invoice.reference}', total = '${invoice.total}', lastModified = ${DateTime.now().millisecondsSinceEpoch};
    ''';
  }

  static String updateInvoice(Invoice invoice) {

    return '''
    update invoices set fid = '${invoice.fid}', date = '${invoice.date}', vendeur = '${invoice.vendeur}', reference = '${invoice.reference}', total = '${invoice.total}' where fid = '${invoice.fid}';
    ''';
  }

  static String deleteInvoice(Invoice invoice) {
    return '''
    delete from invoices where fid = '${invoice.fid}';
    ''';
  }

}