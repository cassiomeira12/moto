import 'package:moto/model/base_model.dart';

class Veicle implements BaseModel<Veicle> {

  String marca;
  String modelo;
  String ano;
  String placa;

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
  update(Veicle item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}