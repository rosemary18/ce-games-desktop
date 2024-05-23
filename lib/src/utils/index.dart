import 'package:flutter_secure_storage/flutter_secure_storage.dart';

export 'files.dart';
export 'generator.dart';

const storage = FlutterSecureStorage();

readStorage({required String key, required Function(String?) cb}) async {
  storage.containsKey(key: key).then((value) {
    if (value) {
      storage.read(key: key).then((value) {
        cb(value);
      });
    } else cb(null);
  });
}

writeStorage({required String key, required String value}) async {

  bool exist = await storage.containsKey(key: key);
  
  if (exist) {
    await storage.delete(key: key);
    return storage.write(key: key, value: value);
  } 

  return storage.write(key: key, value: value);
}