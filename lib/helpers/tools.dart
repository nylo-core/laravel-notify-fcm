import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getStorage({String key = 'key'}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<bool> storeStorage(String dynamic, {String key = 'key'}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.setString(key, dynamic);
}