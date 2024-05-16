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
  storage.containsKey(key: key).then((exist) {
    if (exist) {
      storage.delete(key: key).then((_) {
        return storage.write(key: key, value: value);
      });
    } 
    return storage.write(key: key, value: value);
  });

  return false;
}