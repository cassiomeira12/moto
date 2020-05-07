import 'package:moto/model/base_model.dart';

import 'gasto.dart';

class Fuel extends Gasto implements BaseModel<Fuel> {
  @override
  String id;
  String combustivel;
  DateTime data;
  double litros;

  Fuel() {
    type = GastoType.COMBUSTIVEL;
    imagem = "assets/combustivel.png";
  }

  Fuel.fromMap(Map<dynamic, dynamic>  map) {
    type = GastoType.COMBUSTIVEL;
    id = map["uId"];
    combustivel = map["combustivel"];
    data = DateTime.parse(map["data"]);
    litros = map["litros"] as double;
    total = map["total"] as double;

    imagem = "assets/combustivel.png";
  }

  @override
  toMap() {
    var map = Map<String, dynamic>();
    map["uId"] = id;
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