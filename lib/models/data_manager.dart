import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/main.dart';
import 'allergy_data.dart';
import 'cart_data.dart';
import 'doctor_data.dart';
import 'package_data.dart';
import 'patient_data.dart';
import 'user_details.dart';

class DataManager {

  UserDetails? userDetails;
  String? prn;
  UserBranch? branchDetails;
  PatientDetails? patientDetails;

  DataManager._privateConstructor();

  static final DataManager instance = DataManager._privateConstructor();

  final _storage = const FlutterSecureStorage(aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));

  Future<LazyBox> initHive() async{
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
    ..registerAdapter(DocumentAdapter())

    ..registerAdapter(DoctorInfoAdapter())
    ..registerAdapter(DoctorSpokenLanguageAdapter())
    ..registerAdapter(DoctorQualificationAdapter())
    ..registerAdapter(DoctorSpecialitiesAdapter())
    ..registerAdapter(DoctorClinicLocationAdapter())
    ..registerAdapter(DoctorClinicHoursAdapter())
    ..registerAdapter(DoctorContactAdapter())
    ..registerAdapter(DoctorSpecialtyAdapter())
    ..registerAdapter(SpecialtyAdapter())

    ..registerAdapter(MyCartItemAdapter())
    ..registerAdapter(PackageAdapter())
    ..registerAdapter(AllergyAdapter())
    ..registerAdapter(AllergyGroupAdapter());

    return await openHiveBox();
  }

  Future<LazyBox> openHiveBox() async {
    return await Hive.openLazyBox(kHiveBoxName);
  }

  Future<String?> read(String key) async {
    String? s = await _storage.read(key: key);
    return s;
  }

  Future<void> write(String key, String? value) async {
    await _storage.write(key: key, value: value);
  }

  Future<void> remove(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clear() async {
    await _storage.deleteAll();
    await box.clear();
    await box.deleteFromDisk();
    userDetails = null;
    prn = null;
    branchDetails = null;
    patientDetails = null;
    box = await openHiveBox();
  }

  Future<void> setUserDetails(UserDetails o) async {
    await box.put('userDetails', o);
    userDetails = o;
  }

  Future<UserDetails?> getUserDetails() async {
    userDetails = await getItem('userDetails');
    return userDetails;
  }

  void setPrn(String mprn) {
    prn = mprn;
  }

  String? getPrn() {
    return prn;
  }

  Future<void> setBranchDetails(UserBranch o) async {
    await box.put('branchDetails', o);
    branchDetails = o;
  }

  Future<UserBranch?> getBranchDetails() async {
    branchDetails = await getItem('branchDetails');
    return branchDetails;
  }

  Future<void> setPatientDetails(PatientDetails? o) async {
    await box.put('patientDetails', o);
    patientDetails = o;
  }

  Future<PatientDetails?> getPatientDetails() async {
    patientDetails = await getItem('patientDetails');
    return patientDetails;
  }

  Future<void> setItem(String key, dynamic o) async {
    await box.put(key, o);
  }

  Future<dynamic> getItem(String key) async {
    return await box.get(key);
  }

  Future<void> removeItem(String key) async {
    await box.delete(key);
  }
}