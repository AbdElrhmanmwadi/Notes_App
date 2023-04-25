import 'package:get/get.dart';
import 'package:note/sql/SqlDb.dart';

class SqlController extends GetxController {
  SqlDb sqlDb = SqlDb();
  var response;
  Future readData(table) async {
    response = await sqlDb.read(table);
    update();
    return response;
  }
}
