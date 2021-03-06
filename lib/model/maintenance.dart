import 'package:moto/model/base_model.dart';

import 'gasto.dart';

class Maintenance extends Gasto implements BaseModel<Maintenance> {
  @override
  String id;
  DateTime data;
  String notaURL;
  String itens;

  Maintenance() {
    type = GastoType.MANUTENCAO;
    imagem = "assets/manutencao.png";
  }

  Maintenance.fromMap(Map<dynamic, dynamic>  map) {
    type = GastoType.MANUTENCAO;
    id = map["uId"];
    data = DateTime.parse(map["data"]);
    total = map["total"] as double;

    imagem = "assets/combustivel.png";
  }

  @override
  toMap() {
    var map = Map<String, dynamic>();
    map["uId"] = id;
    map["type"] = type.toString();
    map["data"] = data.toString();
    map["total"] = total;
    return map;
  }

  @override
  update(Maintenance item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}