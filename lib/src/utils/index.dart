import 'package:flutter_secure_storage/flutter_secure_storage.dart';

export 'files.dart';
export 'generator.dart';

const storage = FlutterSecureStorage();

readStorage({required String key, required Function(String?) cb}) async {
  await storage.containsKey(key: key).then((value) async {
    if (value) {
      return await storage.read(key: key).then((value) {
        cb(value);
      });
    } else return await cb(null);
  });
}

writeStorage({required String key, required String value}) async {

  bool exist = await storage.containsKey(key: key);
  
  if (exist) {
    await storage.delete(key: key);
    return await storage.write(key: key, value: value);
  } 

  return await storage.write(key: key, value: value);
}