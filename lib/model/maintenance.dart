import 'package:moto/model/base_model.dart';

import 'gasto.dart';

class Maintenance extends Gasto implements BaseModel<Maintenance> {

  String _uId;
  double total;
  DateTime data;
  String notaURL;
  String itens;

  Maintenance() {
    type = GastoType.MANUTENCAO;
  }

  @override
  String getUid() {
    return _uId;
  }

  @override
  setUid(String uId) {
    this._uId = uId;
  }

  Maintenance.fromMap(Map<dynamic, dynamic>  map) {
    type = GastoType.MANUTENCAO;
    _uId = map["uId"];
    //data = map["data"] as DateTime;
    total = map["total"] as double;
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map["uId"] = _uId;
    map["type"] = type.toString();
    //map["data"] = data;
    map["total"] = total;
    return map;
  }

  @override
  update(Maintenance item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}