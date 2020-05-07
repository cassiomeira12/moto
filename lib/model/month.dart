import 'package:moto/model/base_model.dart';

class Month implements BaseModel<Month> {
  @override
  String id;
  int kmInicio = 0;
  int kmFim = 0;

  Month();

  Month.fromMap(Map<dynamic, dynamic>  map) {
    id = map["uId"];
    kmInicio = map["kmInicio"] as int;
    kmFim = map["kmFim"] as int;
  }

  @override
  toMap() {
    var map = Map<String, dynamic>();
    map['uId'] = id;
    map['kmInicio'] = kmInicio;
    map['kmFim'] = kmFim;
    return map;
  }

  @override
  update(Month item) {
    id = item.id;
    kmInicio = item.kmInicio;
    kmFim = item.kmFim;
  }

  int kmRodados() {
    return (kmFim - kmInicio);
  }

}