import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/models/allergy.dart';
import 'api_helper.dart';

class VesaliusService {

  static Future<PatientDetails?> getVesaliusPatientData(num branchId, String prn) async {
    PatientDetails? o;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-data/$branchId/$prn');
      o = PatientDetails.fromJson(res.data);
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<List<Allergy>> getPatientAllergies(num branchId, String prn) async {
    List<Allergy> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-allergy/$branchId/$prn');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => Allergy.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<PatientVisit>> getVesaliusPatientVisit(num branchId, String prn, num pageId) async {
    List<PatientVisit> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-visit/$branchId/$prn/$pageId'); // 20015952
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => PatientVisit.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<DoctorDetails>> getVesaliusDoctorData(num branchId) async {
    List<DoctorDetails> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/doctor-data/$branchId');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => DoctorDetails.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<Specialty>> getSpecialtyData(num branchId) async {
    List<Specialty> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/specialty-data/$branchId');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => Specialty.fromJson1(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<Map<String, dynamic>> getDoctorAppointments(num doctorId, int month, int year, [int appt = 0]) async {
    Map<String, dynamic> m = {};

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-doctor-appointments/$doctorId/$month/$year/$appt');
      final ls = res.data['calendarDailyStatus'] as List? ?? [];
      final lk = res.data['doctorAppointment'] as List? ?? [];
      List<DoctorAppointmentStatus> lx = ls.map((x) => DoctorAppointmentStatus.fromJson(x)).toList();
      List<DoctorAppointment> ly = lk.map((x) => DoctorAppointment.fromJson(x)).toList();
      m['calendarDailyStatus'] = lx;
      m['doctorAppointment'] = ly;
    }

    catch (error) {
      rethrow;
    }

    return m;
  }

  static Future<List<AvailableSlot>> getVesaliusNextAvailableSlot(num branchId, String prn, Map data) async {
    List<AvailableSlot> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/get-next-available-slots/$branchId/$prn', data: data);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => AvailableSlot.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<PatientAppointment>> getPatientVesaliusFutureAppointments(num branchId, String prn) async {
    List<PatientAppointment> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-future-appointments/$branchId/$prn');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => PatientAppointment.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<PastAppointment>> getVesaliusPastAppointments(num branchId, String prn) async {
    List<PastAppointment> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/past-appointments/$prn');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => PastAppointment.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<FutureAppointment>> getVesaliusFutureAppointments(num branchId, String prn) async {
    List<FutureAppointment> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/future-appointments/$branchId/$prn');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => FutureAppointment.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<void> postVesaliusMakeAppointment(num branchId, String prn, Map data) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/make-appointment/$branchId/$prn', data: data);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> postVesaliusCancelAppointment(num branchId, String prn, Map data) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/cancel-appointment/$branchId/$prn', data: data);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> postVesaliusChangeAppointment(num branchId, String prn, Map data) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/change-appointment/$branchId/$prn', data: data);
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<void> updatePatientData(num branchId, String prn, Map data) async {
    try {
      await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/update-patient-data/$branchId/$prn', data: {
        'contact': data,
      });
    }

    catch (error) {
      rethrow;
    }
  }

  static Future<List<VitalSignsData>> getVitalSignHistory(String type, num branchId, String prn, String dates) async {
    List<VitalSignsData> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-vital-signs-history/$branchId/$prn/$dates/$type');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => VitalSignsData.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<VitalSignsHistory>> getVitalSignHistories(num branchId, String prn) async {
    List<VitalSignsHistory> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-vital-signs-history/$branchId/$prn');
      if (res.data == null) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => VitalSignsHistory.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<LabHistory>> getLabHistories(num branchId, String prn) async {
    List<LabHistory> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-lab-history/$branchId/$prn');
      if (res.data == null) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => LabHistory.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<File> getHealthScrReportPdf(num branchId, String refno, String fp, void Function(int, int) onReceiveProgress) async {
    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/health-screening-report/$branchId/$refno',
        onReceiveProgress: onReceiveProgress,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        )
      );
      File file = File(fp);
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(res.data);
      await raf.close();
      return file;
    }

    catch (error) {
      rethrow;
    }
  }
}

class PublicVesaliusService {

  static Future<List<SessionAvailableSlot>> getVesaliusNextSessionAvailableSlot(num branchId, String prn, Map data) async {
    List<SessionAvailableSlot> lx;

    try {
      final res = await ApiHelper.dio.post('$kServerUrl/public/vesalius/get-next-session-available-slots/$branchId/$prn', data: data);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => SessionAvailableSlot.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<DoctorDetails>> getPublicDoctorData(num branchId) async {
    List<DoctorDetails> lx;

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/public/vesalius/doctor-data/$branchId');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }
      
      final ls = res.data as List? ?? [];
      lx = ls.map((x) => DoctorDetails.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List> getPublicHospitalInformation() async {
    List lx = [];

    try {
      final res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/public/hospital-information');
      lx = res.data;
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<UserBranch>> getPublicBranchList() async {
    List<UserBranch> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/public/branch/list');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => UserBranch.fromJson1(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<DoctorInfo>> getAllDoctors(num branchId, num page, num limit) async {
    List<DoctorInfo> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final res = await ApiHelper.dio.get('$kServerUrl/public/vesalius/getAllDoctorInformation/$branchId', queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      int totalPage = int.parse(res.headers['x-total-page']!.first);
      if (page > totalPage) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<DoctorInfo>> searchDoctors(num branchId, num page, num limit, String keyword) async {
    List<DoctorInfo> lx;

    try {
      final q = {
        '_page': page,
        '_limit': limit
      };
      final o = {
        'keyword': keyword
      };
      final res = await ApiHelper.dio.post('$kServerUrl/public/vesalius/getAllDoctorInformation/$branchId', data: o, queryParameters: q);
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      int totalPage = int.parse(res.headers['x-total-page']!.first);
      if (page > totalPage) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<DoctorInfo?> getDoctorByMCR(num branchId, String mcr) async {
    DoctorInfo? o;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/public/vesalius/getDoctorInformationByMCR/$branchId/$mcr');
      if (res.statusCode == 204) {
        return o;
      }

      final ls = res.data as List? ?? [];
      final lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
      if (lx.isNotEmpty) {
        o = lx.first;
      }
    }

    catch (error) {
      rethrow;
    }

    return o;
  }
}