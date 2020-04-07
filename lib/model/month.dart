import 'package:moto/model/base_model.dart';

class Month implements BaseModel<Month> {
  static getCollection() => "meses";

  String _uId;
  int kmInicio = 0;
  int kmFim = 0;

  Month();

  @override
  String getUid() {
    return _uId;
  }

  @override
  setUid(String uId) {
    this._uId = uId;
  }

  Month.fromMap(Map<dynamic, dynamic>  map) {
    _uId = map["uId"];
    kmInicio = map["kmInicio"] as int;
    kmFim = map["kmFim"] as int;
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map['uId'] = _uId;
    map['kmInicio'] = kmInicio;
    map['kmFim'] = kmFim;
    return map;
  }

  @override
  update(Month item) {
    _uId = item.getUid();
    kmInicio = item.kmInicio;
    kmFim = item.kmFim;
  }

  int kmRodados() {
    return (kmFim - kmInicio);
  }

}