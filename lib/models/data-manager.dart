import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'patient-data.dart';
import 'user-details.dart';

class DataManager {

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static final LocalStorage storage = LocalStorage('vesalius_m');

  static UserDetails? userDetails;
  static String? prn;
  static UserBranch? branchDetails;
  static PatientDetails? patientDetails;

  static Future<void> clear() async {
    await storage.ready;
    await storage.clear();
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
    userDetails = null;
    prn = null;
    branchDetails = null;
    patientDetails = null;
  }

  static Future<void> setUserDetails(UserDetails o) async {
    await storage.ready;
    userDetails = o;
    await storage.setItem('userDetails', o);
  }

  static Future<UserDetails?> getUserDetails() async {
    await storage.ready;
    var o = storage.getItem('userDetails');
    if (o != null) {
      userDetails = UserDetails.fromJson(o);
    }

    return userDetails;
  }

  static void setPrn(String _prn) {
    prn = prn;
  }

  static String? getPrn() {
    return prn;
  }

  static Future<void> setBranchDetails(UserBranch o) async {
    await storage.ready;
    branchDetails = o;
    await storage.setItem('branchDetails', o);
  }

  static Future<UserBranch?> getBranchDetails() async {
    await storage.ready;
    var o = storage.getItem('branchDetails');
    if (o != null) {
      branchDetails = UserBranch.fromJson(o);
    }

    return branchDetails;
  }

  static Future<void> setPatientDetails(PatientDetails? o) async {
    await storage.ready;
    patientDetails = o;
    await storage.setItem('patientDetails', o);
  }

  static Future<PatientDetails?> getPatientDetails() async {
    await storage.ready;
    var o = storage.getItem('patientDetails');
    if (o != null) {
      patientDetails = PatientDetails.fromJson(o);
    }
    
    return patientDetails;
  }

  static Future<void> setItem(String key, dynamic o) async {
    await storage.ready;
    await storage.setItem(key, o);
  }

  static Future<dynamic> getItem(String key) async {
    await storage.ready;
    var o = storage.getItem(key);
    return o;
  }

  static Future<void> removeItem(String key) async {
    await storage.ready;
    await storage.deleteItem(key);
  }
}