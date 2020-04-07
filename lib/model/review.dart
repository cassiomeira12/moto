import 'package:moto/model/base_model.dart';

import 'gasto.dart';

class Review extends Gasto implements BaseModel<Review> {

  String _uId;
  String notaURL;
  String itens;
  DateTime data;

  Review() {
    type = GastoType.REVISAO;
    imagem = "assets/revisao.png";
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
    data = DateTime.parse(map["data"]);
    total = map["total"] as double;

    imagem = "assets/revisao.png";
  }

  @override
  toMap() {
    var map = new Map<String, dynamic>();
    map["uId"] = _uId;
    map["type"] = type.toString();
    map["data"] = data.toString();
    map["total"] = total;
    return map;
  }

  @override
  update(Review item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}