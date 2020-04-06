import 'package:moto/model/base_model.dart';

import 'gasto.dart';

class Item extends Gasto implements BaseModel<Item> {

  String _uId;
  String produto;
  double quantidade;
  double total;

  Item() {
    type = GastoType.PRODUTO;
  }

  @override
  String getUid() {
    return _uId;
  }

  @override
  setUid(String uId) {
    this._uId = uId;
  }

  Item.fromMap(Map<dynamic, dynamic>  map) {
    type = GastoType.PRODUTO;
    _uId = map["uId"];
    produto = map["produto"];
    quantidade = map["quantidade"] as double;
    total = map["total"] as double;
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map["uId"] = _uId;
    map["type"] = type.toString();
    map["produto"] = produto;
    map["quantidade"] = quantidade;
    map["total"] = total;
    return map;
  }

  @override
  update(Item item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}