import 'package:collection/collection.dart';
import 'package:vesalius_m_flutter/constants.dart';
import 'package:vesalius_m_flutter/models/country_data.dart';
import 'package:vesalius_m_flutter/models/hospital_data.dart';
import 'package:vesalius_m_flutter/models/service_data.dart';
import 'package:vesalius_m_flutter/models/version_data.dart';

import 'api_helper.dart';

class CommonService {
  
  static String name = 'common';

  static Future<HospitalInfo?> getHospitalInfo() async {
    HospitalInfo? o;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/app/hospital-profile');
      if (res.statusCode == 204) {
        return o;
      }

      final ls = res.data as List? ?? [];
      final c1 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_INFO_APPT_DISPLAY');
      HospitalProfile p1 = HospitalProfile.fromJson(c1);
      final c2 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_24HOUR_DISPLAY');
      HospitalProfile p2 = HospitalProfile.fromJson(c2);
      final c3 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_TOLLFREE_MAL_DISPLAY');
      HospitalProfile p3 = HospitalProfile.fromJson(c3);
      final c4 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_TOLLFREE_IND_DISPLAY');
      HospitalProfile p4 = HospitalProfile.fromJson(c4);
      final c5 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_WHATSAPP_DISPLAY');
      HospitalProfile p5 = HospitalProfile.fromJson(c5);
      final c6 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_WHATSAPP_CALL');
      HospitalProfile p6 = HospitalProfile.fromJson(c6);
      final c7 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'EMAIL');
      HospitalProfile p7 = HospitalProfile.fromJson(c7);
      final c8 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'WEBSITE_URL');
      HospitalProfile p8 = HospitalProfile.fromJson(c8);
      final c9 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_INFO_APPT_CALL');
      HospitalProfile p9 = HospitalProfile.fromJson(c9);
      final c10 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_24HOUR_CALL');
      HospitalProfile p10 = HospitalProfile.fromJson(c10);
      final c11 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_TOLLFREE_MAL_CALL');
      HospitalProfile p11 = HospitalProfile.fromJson(c11);
      final c12 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'CONTACT_TOLLFREE_IND_CALL');
      HospitalProfile p12 = HospitalProfile.fromJson(c12);
      final c13 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'REGISTRATION_NUMBER');
      HospitalProfile p13 = HospitalProfile.fromJson(c13);
      final c14 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'ADDRESS1');
      HospitalProfile p14 = HospitalProfile.fromJson(c14);
      final c15 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'ADDRESS2');
      HospitalProfile p15 = HospitalProfile.fromJson(c15);
      final c16 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'POSTCODE');
      HospitalProfile p16 = HospitalProfile.fromJson(c16);
      final c17 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'STATE');
      HospitalProfile p17 = HospitalProfile.fromJson(c17);
      final c18 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'COUNTRY');
      HospitalProfile p18 = HospitalProfile.fromJson(c18);
      final c19 = ls.firstWhereOrNull((x) => x['profileDesc'] == 'COMPANY_NAME');
      HospitalProfile p19 = HospitalProfile.fromJson(c19);

      o = HospitalInfo(
        contactInfoApptDisplay: p1.value, 
        contactInfoApptCall: p9.value, 
        contact24Display: p2.value, 
        contact24Call: p10.value, 
        contactTollFreeMalDisplay: p3.value, 
        contactTollFreeMalCall: p11.value, 
        contactTollFreeIndDisplay: p4.value, 
        contactTollFreeIndCall: p12.value, 
        contactWhatsAppDisplay: p5.value, 
        contactWhatsAppCall: p6.value, 
        email: p7.value, 
        website: p8.value,
        reg: p13.value,
        addr1: p14.value,
        addr2: p15.value,
        postcode: p16.value,
        state: p17.value,
        country: p18.value,
        companyName: p19.value,
      );
    }

    catch (error) {
      rethrow;
    }

    return o;
  }

  static Future<List<AppVersion>> getVersions() async {
    List<AppVersion> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/app/version');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => AppVersion.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<Country>> getCountries() async {
    List<Country> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/country/list');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => Country.fromJson(x)).toList();
    }
    
    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<CountryTel>> getTelCountries() async {
    List<CountryTel> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/telcode/list');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => CountryTel.fromJson(x)).toList();
    }
    
    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<String>> getNationalities() async {
    List<String> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/nationality/list');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => x['nationality'].toString()).toList();
    }
    
    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<AppService>> getGuestModeServices() async {
    List<AppService> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/service/guest/list');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => AppService.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }

  static Future<List<AppService>> getAuthModeServices() async {
    List<AppService> lx;

    try {
      final res = await ApiHelper.dio.get('$kServerUrl/$name/service/auth/list');
      if (res.statusCode == 204) {
        lx = [];
        return lx;
      }

      final ls = res.data as List? ?? [];
      lx = ls.map((x) => AppService.fromJson(x)).toList();
    }

    catch (error) {
      rethrow;
    }

    return lx;
  }
}