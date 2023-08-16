import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefController {
  static late SharedPreferences sharedPreferences;
  static SharedPrefController? _instance;

  SharedPrefController._();

  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  factory SharedPrefController() {
    return _instance ??= SharedPrefController._();
  }

  Future<bool> removeData({
    required String key,
  }) async {
    return await sharedPreferences.remove(key);
  }

  setData(String key, var value) async {
    if (value is double) return await sharedPreferences.setDouble(key, value);
  }

  dynamic getData({
    required String key,
  }) {
    return sharedPreferences.get(key);
  }
}
