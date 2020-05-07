import 'package:moto/contract/month/despesas_contract.dart';
import 'package:moto/services/firebase/firebase_despesas_service.dart';

class DespesasPresenter implements DespesasContractPresenter {
  final DespesasContractView _view;
  DespesasPresenter(this._view);

  DespesasContractService service = FirebaseDespesasService("despesas");

  @override
  Future<dynamic> create(dynamic item) async {
    return await service.create(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<dynamic> delete(dynamic item) async {
    return await service.delete(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<dynamic>> findBy(String field, dynamic value) async {
    return await service.findBy(field, value).then((value) {
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<dynamic> read(dynamic item) async {
    return await service.read(item).then((value) {
      print(value);
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<dynamic> update(dynamic item) async {
    return await service.update(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

}