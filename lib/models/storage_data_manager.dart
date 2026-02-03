import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';

class StorageDataManager {

  static Future<String> getDbPath(String name) async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, name);
    return path;
  }

  static Future<List<String>> getData() async {
    List<String> ls = [];

    String path = await getDbPath('user.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT)');
    });

    var res = await database.rawQuery('SELECT * FROM user GROUP BY username');
    for (var o in res) {
      ls.add("${o['username']}");
    }

    await database.close();

    return ls;
  }

  static Future<void> addUser(String username) async {
    String path = await getDbPath('user.db');
    Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT)');
    });
    
    await database.rawInsert('INSERT INTO user VALUES(NULL,?)', [username]);
    await database.close();
  }

  static Future<List<String>> delUser(String username) async {
    List<String> ls = [];

    String path = await getDbPath('user.db');
    Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS user(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT)');
    });

    await database.rawDelete('DELETE FROM user WHERE username=?', [username]);
    await database.close();
    ls = await getData();
    return ls;
  }

  static Future<List<Map>> getHospitalDataStorage(String email) async {
    List<Map> ls = [];

    String path = await getDbPath('hospital.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS hospital(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, infoId TEXT, data TEXT)');
    });

    var res = await database.rawQuery('SELECT * FROM hospital WHERE email=? GROUP BY data', [email]);
    for (var o in res) {
      Map m = jsonDecode("${o['data']}");
      Map k = { 'data': m };
      ls.add(k);
    }

    await database.close();

    return ls;
  }

  static Future<void> addHospitalBookmarkStorage(String email, dynamic hospitalInformation) async {
    String path = await getDbPath('hospital.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS hospital(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, infoId TEXT, data TEXT)');
    });

    await database.rawInsert('INSERT INTO hospital VALUES(NULL,?,?,?)', [email, hospitalInformation['hospitalInformationId'], jsonEncode(hospitalInformation)]);
    await database.close();
  }

  static Future<void> delHospitalInformationFromStorage(String infoId) async {
    String path = await getDbPath('hospital.db');
    Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS hospital(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, infoId TEXT, data TEXT)');
    });

    await database.rawDelete('DELETE FROM hospital WHERE infoId=?', [infoId]);
    await database.close();
  }

  static Future<void> addDoctorBookmarkStorage(String email, DoctorInfo data) async {
    String path = await getDbPath('doctor.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS doctor(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, infoId TEXT, data TEXT)');
    });

    await database.rawInsert('INSERT INTO doctor VALUES(NULL,?,?,?)', [email, data.mcr, jsonEncode(data)]);
    await database.close();
  }

  static Future<List<String>> delDoctorInformationFromStorage(String email, String infoId) async {
    List<String> ls = [];

    String path = await getDbPath('doctor.db');
    Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS doctor(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, infoId TEXT, data TEXT)');
    });

    await database.rawDelete('DELETE FROM doctor WHERE email=? AND infoId=?', [email, infoId]);
    await database.close();
    ls = await getData();
    return ls;
  }

  static Future<List<DoctorInfo>> getDoctorDataStorage(String email) async {
    List<DoctorInfo> ls = [];

    String path = await getDbPath('doctor.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS doctor(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, infoId TEXT, data TEXT)');
    });

    var res = await database.rawQuery('SELECT * FROM doctor WHERE email=? GROUP BY data', [email]);
    for (var o in res) {
      var m = jsonDecode("${o['data']}");
      DoctorInfo x = DoctorInfo.fromJson(m);
      ls.add(x);
    }

    await database.close();

    return ls;
  }

  static Future<List<Map>> getInfoIdFromStorage(String email, String tableName) async {
    List<Map> ls = [];

    String path = await getDbPath('$tableName.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, infoId TEXT, data TEXT)');
    });

    var res = await database.rawQuery('SELECT DISTINCT infoId FROM $tableName WHERE email=?', [email]);
    for (var o in res) {
      Map k = { 'infoId': o['infoId'] };
      ls.add(k);
    }

    return ls;
  }

  static Future<List<Map>> getApointmentDataStorage(String email) async {
    List<Map> ls = [];

    String path = await getDbPath('appointment.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS appointment(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, date TEXT, time TEXT, doctorName TEXT)');
    });

    var res = await database.rawQuery('SELECT * FROM appointment WHERE email=?', [email]);
    for (var o in res) {
      Map k = { 'date': o['date'], 'time': o['time'], 'doctorName': o['doctorName'] };
      ls.add(k);
    }

    await database.close();

    return ls;
  }

  static Future<void> addAppointmentToStorage(String email, dynamic data) async {
    String path = await getDbPath('appointment.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS appointment(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, date TEXT, time TEXT, doctorName TEXT)');
    });

    await database.rawInsert('INSERT INTO appointment VALUES(NULL,?,?,?,?)', [email, data.date, data.time, data.doctorName]);
    await database.close();
  }

  static Future<void> delAppointmentFromStorage(String time) async {
    String path = await getDbPath('appointment.db');
    Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS appointment(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT, date TEXT, time TEXT, doctorName TEXT)');
    });

    await database.rawDelete('DELETE FROM appointment WHERE time=?', [time]);
    await database.close();
  }

  static Future<void> addDoctorInformationToStorage(String branchId, List<DoctorInfo> data) async {
    String path = await getDbPath('doctorInfo.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS doctorInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, branchId TEXT, data TEXT)');
    });

    await database.rawInsert('INSERT INTO doctorInfo VALUES(NULL,?,?)', [branchId, jsonEncode(data)]);
    await database.close();
  }

  static Future<List<DoctorInfo>> getDoctorInformationFromStorage(String branchId) async {
    List<DoctorInfo> ls = [];

    String path = await getDbPath('doctorInfo.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS doctorInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, branchId TEXT, data TEXT)');
    });

    var res = await database.rawQuery('SELECT * FROM doctorInfo WHERE branchId=?', [branchId]);
    for (var o in res) {
      List lm = jsonDecode("${o['data']}") as List;
      ls = lm.map((x) => DoctorInfo.fromJson(x)).toList();
    }

    await database.close();

    return ls;
  }

  static Future<void> delDoctorInformationCacheFromStorage(String branchId) async {
    String path = await getDbPath('doctorInfo.db');
    Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS doctorInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, branchId TEXT, data TEXT)');
    });

    await database.rawDelete('DELETE FROM doctorInfo WHERE branchId=?', [branchId]);
    await database.close();
  }

  static Future<void> addHospitalInformationToStorageForGuest(dynamic data) async {
    String path = await getDbPath('hospitalInfo.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS hospitalInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)');
    });

    await database.rawInsert('INSERT INTO hospitalInfo VALUES(NULL,?)', [jsonEncode(data)]);
    await database.close();
  }

  static Future<List<Map>> getHospitalInformationFromStorageForGuest() async {
    List<Map> ls = [];

    String path = await getDbPath('hospitalInfo.db');
    Database database = await openDatabase(path, version: 1, 
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS hospitalInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)');
    });

    var res = await database.rawQuery('SELECT * FROM hospitalInfo', []);
    for (var o in res) {
      Map m = jsonDecode("${o['data']}");
      Map k = { 'data': m };
      ls.add(k);
    }

    await database.close();

    return ls;
  }

  static Future<void> deHospitalInformationCacheForGuest() async {
    String path = await getDbPath('hospitalInfo.db');
    Database database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS hospitalInfo(id INTEGER PRIMARY KEY AUTOINCREMENT, data TEXT)');
    });
    
    await database.rawDelete('DELETE FROM hospitalInfo', []);
    await database.close();
  }
}