import 'package:moto/model/base_model.dart';

import 'gasto.dart';

class Review extends Gasto implements BaseModel<Review> {

  String _uId;
  double total;
  String notaURL;
  String itens;

  Review() {
    type = GastoType.REVISAO;
  }

  @override
  String getUid() {
    return _uId;
  }

  @override
  setUid(String uId) {
    this._uId = uId;
  }

  Review.fromMap(Map<dynamic, dynamic>  map) {
    type = GastoType.REVISAO;
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
  update(Review item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}