import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vesalius_m_flutter/main.dart';
import 'patient_data.dart';
import 'user_details.dart';

class DataManager {

  static final _storage = FlutterSecureStorage(aOptions: _getAndroidOptions());

  static UserDetails? userDetails;
  static String? prn;
  static UserBranch? branchDetails;
  static PatientDetails? patientDetails;

  static Future<LazyBox> initHive() async{
    await Hive.initFlutter();
    Hive
    ..registerAdapter(UserDetailsAdapter())
    ..registerAdapter(UserBranchAdapter())
    ..registerAdapter(BranchAdapter())
    ..registerAdapter(PatientDetailsAdapter())
    ..registerAdapter(ContactNumberAdapter())
    ..registerAdapter(AddressAdapter())
    ..registerAdapter(NameAdapter())
    ..registerAdapter(NationalityAdapter())
    ..registerAdapter(SexAdapter())
    ..registerAdapter(DocumentAdapter());
    return await openHiveBox();
  }

  static Future<LazyBox> openHiveBox() async {
    return await Hive.openLazyBox('vesaliusmBox');
  }

  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static Future<String?> read(String key) async {
    String? s = await _storage.read(key: key);
    return s;
  }

  static Future<void> write(String key, String? value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> clear() async {
    await _storage.deleteAll();
    await box.deleteFromDisk();
    userDetails = null;
    prn = null;
    branchDetails = null;
    patientDetails = null;
    box = await openHiveBox();
  }

  static Future<void> setUserDetails(UserDetails o) async {
    await box.put('userDetails', o);
    userDetails = o;
  }

  static Future<UserDetails?> getUserDetails() async {
    userDetails = await getItem('userDetails');
    return userDetails;
  }

  static void setPrn(String mprn) {
    prn = mprn;
  }

  static String? getPrn() {
    return prn;
  }

  static Future<void> setBranchDetails(UserBranch o) async {
    await box.put('branchDetails', o);
    branchDetails = o;
  }

  static Future<UserBranch?> getBranchDetails() async {
    branchDetails = await getItem('branchDetails');
    return branchDetails;
  }

  static Future<void> setPatientDetails(PatientDetails? o) async {
    await box.put('patientDetails', o);
    patientDetails = o;
  }

  static Future<PatientDetails?> getPatientDetails() async {
    patientDetails = await getItem('patientDetails');
    return patientDetails;
  }

  static Future<void> setItem(String key, dynamic o) async {
    await box.put(key, o);
  }

  static Future<dynamic> getItem(String key) async {
    return await box.get(key);
  }

  static Future<void> removeItem(String key) async {
    await box.delete(key);
  }
}