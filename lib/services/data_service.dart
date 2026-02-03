import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/appointment_data.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/models/patient_data.dart';
import 'package:vesalius_m_flutter/models/user_details.dart';
import 'package:vesalius_m_flutter/models/allergy.dart';
import 'api_helper.dart';

Future<PatientDetails?> getVesaliusPatientData(num branchId, String prn) async {
  PatientDetails? o;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-data/$branchId/$prn');
    o = PatientDetails.fromJson(res.data);
  }

  catch (error) {
    rethrow;
  }

  return o;
}

Future<void> changePassword(o) async {
  try {
    await ApiHelper.tokenDioInterceptor.post('$kServerUrl/user/change-password', data: o);
  }

  catch (error) {
    rethrow;
  }
}

Future<List<DoctorDetails>> getPublicDoctorData(num branchId) async {
  List<DoctorDetails> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/public/vesalius/doctor-data/$branchId');
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }
    
    var ls = res.data as List? ?? [];
    lx = ls.map((x) => DoctorDetails.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List> getPublicHospitalInformation() async {
  List lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/public/hospital-information');
    lx = res.data;
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<Allergy>> getPatientAllergies(num branchId, String prn) async {
  List<Allergy> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-allergy/$branchId/$prn');
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => Allergy.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<PatientVisit>> getVesaliusPatientVisit(num branchId, String prn, num pageId) async {
  List<PatientVisit> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/patient-visit/$branchId/$prn/$pageId'); // 20015952
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => PatientVisit.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<UserBranch>> getUserBranches() async {
  List<UserBranch> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/user/branches');
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => UserBranch.fromJson(x)).toList();
  }
  
  catch (error) {
    rethrow;
  }

  return lx;
}

// public

Future<List<UserBranch>> getPublicBranchList() async {
  List<UserBranch> lx;

  try {
    var res = await ApiHelper.dio.get('$kServerUrl/public/branch/list');
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => UserBranch.fromJson1(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<DoctorInfo>> getAllDoctors(num branchId, num page, num limit) async {
  List<DoctorInfo> lx;

  try {
    var q = {
      '_page': page,
      '_limit': limit
    };
    var res = await ApiHelper.dio.get('$kServerUrl/public/vesalius/getAllDoctorInformation/$branchId', queryParameters: q);
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var totalPage = int.parse(res.headers['x-total-page']!.first);
    if (page > totalPage) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<DoctorInfo>> searchDoctors(num branchId, num page, num limit, String keyword) async {
  List<DoctorInfo> lx;

  try {
    var q = {
      '_page': page,
      '_limit': limit
    };
    var o = {
      'keyword': keyword
    };
    var res = await ApiHelper.dio.post('$kServerUrl/public/vesalius/getAllDoctorInformation/$branchId', data: o, queryParameters: q);
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var totalPage = int.parse(res.headers['x-total-page']!.first);
    // print('page : $page, totalPage : $totalPage');
    if (page > totalPage) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<DoctorInfo?> getDoctorByMCR(num branchId, String mcr) async {
  DoctorInfo? o;

  try {
    var res = await ApiHelper.dio.get('$kServerUrl/public/vesalius/getDoctorInformationByMCR/$branchId/$mcr');
    if (res.statusCode == 204) {
      return o;
    }

    var ls = res.data as List;
    var lx = ls.map((x) => DoctorInfo.fromJson(x)).toList();
    if (lx.isNotEmpty) {
      o = lx.first;
    }
  }

  catch (error) {
    rethrow;
  }

  return o;
}

Future<List<DoctorDetails>> getVesaliusDoctorData(num branchId) async {
  List<DoctorDetails> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/doctor-data/$branchId');
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => DoctorDetails.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<Specialty>> getSpecialtyData(num branchId) async {
  List<Specialty> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/specialty-data/$branchId');
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => Specialty.fromJson1(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<AvailableSlot>> getVesaliusNextAvailableSlot(num branchId, String prn, Map data) async {
  List<AvailableSlot> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/get-next-available-slots/$branchId/$prn', data: data);
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => AvailableSlot.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<FutureAppointment>> getVesaliusFutureAppointments(num branchId, String prn) async {
  List<FutureAppointment> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/future-appointments/$branchId/$prn');
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => FutureAppointment.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<void> postVesaliusMakeAppointment(String prn, Map data) async {
  try {
    await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/make-appointment/${data['branchId']}/$prn', data: {
      'caseType': data['caseType'],
      'slotNumber': data['slotNumber'],
    });
  }

  catch (error) {
    rethrow;
  }
}

Future<void> postVesaliusCancelAppointment(num branchId, String prn, Map data) async {
  try {
    await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/cancel-appointment/$branchId/$prn', data: data);
  }

  catch (error) {
    rethrow;
  }
}

Future<void> postVesaliusChangeAppointment(num branchId, String prn, Map data) async {
  try {
    await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/change-appointment/$branchId/$prn', data: data);
  }

  catch (error) {
    rethrow;
  }
}

Future<void> updatePatientData(num branchId, String prn, Map data) async {
  try {
    await ApiHelper.tokenDioInterceptor.post('$kServerUrl/vesalius/update-patient-data/$branchId/$prn', data: {
      'contact': data,
    });
  }

  catch (error) {
    rethrow;
  }
}

Future<List<VitalSignsData>> getVitalSignHistory(String type, num branchId, String prn, String dates) async {
  List<VitalSignsData> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-vital-signs-history/$branchId/$prn/$dates/$type');
    if (res.statusCode == 204) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => VitalSignsData.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<VitalSignsHistory>> getVitalSignHistories(num branchId, String prn) async {
  List<VitalSignsHistory> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-vital-signs-history/$branchId/$prn');
    if (res.data == null) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => VitalSignsHistory.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<List<LabHistory>> getLabHistories(num branchId, String prn) async {
  List<LabHistory> lx;

  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/get-lab-history/$branchId/$prn');
    if (res.data == null) {
      lx = [];
      return lx;
    }

    var ls = res.data as List? ?? [];
    lx = ls.map((x) => LabHistory.fromJson(x)).toList();
  }

  catch (error) {
    rethrow;
  }

  return lx;
}

Future<File> getHealthScrReportPdf(num branchId, String refno, String fp, void Function(int, int) onReceiveProgress) async {
  try {
    var res = await ApiHelper.tokenDioInterceptor.get('$kServerUrl/vesalius/health-screening-report/$branchId/$refno',
      onReceiveProgress: onReceiveProgress,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      )
    );
    File file = File(fp);
    var raf = file.openSync(mode: FileMode.write);
    raf.writeFromSync(res.data);
    await raf.close();
    return file;
  }

  catch (error) {
    rethrow;
  }
}