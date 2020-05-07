import 'package:moto/model/base_model.dart';

import 'gasto.dart';

class Review extends Gasto implements BaseModel<Review> {
  @override
  String id;
  String notaURL;
  String itens;
  DateTime data;

  Review() {
    type = GastoType.REVISAO;
    imagem = "assets/revisao.png";
  }

  Review.fromMap(Map<dynamic, dynamic>  map) {
    type = GastoType.REVISAO;
    id = map["uId"];
    data = DateTime.parse(map["data"]);
    total = map["total"] as double;

    imagem = "assets/revisao.png";
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
  update(Review item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}