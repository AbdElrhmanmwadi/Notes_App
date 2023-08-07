import 'package:get/get.dart';
import 'package:note/src/sql/SqlDb.dart';

class SqlController extends GetxController {
  SqlDb sqlDb = SqlDb();
  var response;
  Future readData(table, myWhere) async {
    response = await sqlDb.read(table, myWhere);
    update();
    return response;
  }
}
