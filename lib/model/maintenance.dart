import 'package:moto/model/base_model.dart';

class Maintenance implements BaseModel<Maintenance> {

  String tipo;
  double total;
  String notaURL;
  String itens;

  @override
  String getUid() {
    // TODO: implement getUid
    throw UnimplementedError();
  }

  @override
  setUid(String uId) {
    // TODO: implement setUid
    throw UnimplementedError();
  }

  @override
  toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  update(Maintenance item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}