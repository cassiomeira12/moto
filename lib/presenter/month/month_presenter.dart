import 'package:moto/contract/month/month_contract.dart';
import 'package:moto/model/fuel.dart';
import 'package:moto/model/month.dart';
import 'package:moto/services/firebase/firebase_month_service.dart';

class MouthPresenter implements MonthContractPresenter {
  final MonthContractView _view;
  MouthPresenter(this._view);

  MonthContractService service = FirebaseMonthService("meses");

  @override
  Future<Month> create(Month item) async {
    return await service.create(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Month> read(Month item) async {
    return await service.read(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      print(error);
      _view.onFailure(error);
      return null;
    });
  }

  @override
  Future<Month> update(Month item) async {
    return await service.update(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<Month> delete(Month item) async {
    return await service.delete(item).then((value) {
      _view.onSuccess(value);
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future<List<Month>> findBy(String field, dynamic value) async {
    return await service.findBy(field, value).then((value) {
      return value;
    }).catchError((error) {
      _view.onFailure(error.message);
      return null;
    });
  }

  @override
  Future addDespesa(Month month, item) async {
    return await service.addDespesa(month, item);
  }

  @override
  Future<List> listDespesas(Month month) async {
    return await service.listDespesas(month);
  }

}