import 'package:moto/model/base_model.dart';

import 'gasto.dart';

class Fuel extends Gasto implements BaseModel<Fuel> {

  String _uId;
  String combustivel;
  DateTime data;
  double litros;

  Fuel() {
    type = GastoType.COMBUSTIVEL;
    imagem = "assets/combustivel.png";
  }

  @override
  String getUid() {
    return _uId;
  }

  @override
  setUid(String uId) {
    this._uId = uId;
  }

  Fuel.fromMap(Map<dynamic, dynamic>  map) {
    type = GastoType.COMBUSTIVEL;
    _uId = map["uId"];
    combustivel = map["combustivel"];
    data = DateTime.parse(map["data"]);
    litros = map["litros"] as double;
    total = map["total"] as double;

    imagem = "assets/combustivel.png";
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map["uId"] = _uId;
    map["type"] = type.toString();
    map["combustivel"] = combustivel;
    map["data"] = data.toString();
    map["litros"] = litros;
    map["total"] = total;
    return map;
  }

  @override
  update(Fuel item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}