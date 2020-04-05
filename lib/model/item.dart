import 'package:moto/model/base_model.dart';

class Item implements BaseModel<Item> {

  String tipo;
  String produto;
  double quantidade;
  double total;

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
  update(Item item) {
    // TODO: implement update
    throw UnimplementedError();
  }

}