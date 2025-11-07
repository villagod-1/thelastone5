import 'package:hive/hive.dart';

class LocalStorageDataSource {
  Future<void> saveData(String boxName, String key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.put(key, value);
  }

  Future<T?> getData<T>(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    return box.get(key) as T?;
  }

  Future<void> deleteData(String boxName, String key) async {
    final box = await Hive.openBox(boxName);
    await box.delete(key);
  }

  Future<Box<T>> openBox<T>(String boxName) async {
    return await Hive.openBox<T>(boxName);
  }

  Future<void> closeBox(String boxName) async {
    final box = Hive.box(boxName);
    await box.close();
  }
}
