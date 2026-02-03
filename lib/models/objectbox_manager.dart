import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:vesalius_m_flutter/models/doctor_data.dart';
import 'package:vesalius_m_flutter/objectbox.g.dart';

class ObjectBox {

  late final Store _store;
  late final Box<DoctorInfoModel> _docBox;

  ObjectBox._create(this._store) {
    _docBox = Box<DoctorInfoModel>(_store);
  }

  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore(directory: p.join(docsDir.path, "vesalius-m"));
    return ObjectBox._create(store);
  }

  Future<void> addDoctorBookmark(String userMode, DoctorInfo o) async {
    DoctorInfoModel m = DoctorInfoModel();
    m.set(userMode, o);
    await _docBox.putAsync(m);
  }

  Future<void> removeDoctorBookmark(String userMode, String mcr) async {
    Query<DoctorInfoModel> qry = _docBox.query(
      DoctorInfoModel_.user.equals(userMode)
      .and(DoctorInfoModel_.mcr.equals(mcr))
    ).build();
    await qry.removeAsync();
    qry.close();
  }

  Future<List<String>> getDoctorBookmarkMCRList(String userMode) async {
    Query<DoctorInfoModel> qry = _docBox.query(
      DoctorInfoModel_.user.equals(userMode)
    ).build();
    final res = qry.property(DoctorInfoModel_.mcr).find();
    qry.close();
    return res;
  }

  Future<List<DoctorInfo>> getDoctorBookmarkList(String userMode) async {
    Query<DoctorInfoModel> qry = (_docBox.query(
      DoctorInfoModel_.user.equals(userMode)
    )..order(DoctorInfoModel_.date, flags: Order.descending)).build();
    final ls = await qry.findAsync();
    qry.close();
    final res = ls.map((x) => DoctorInfo.fromObjectbox(x)).toList();
    return res;
  }
}