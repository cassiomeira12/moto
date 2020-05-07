import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moto/contract/month/month_contract.dart';
import 'package:moto/model/base_model.dart';
import 'package:moto/model/fuel.dart';
import 'package:moto/model/gasto.dart';
import 'package:moto/model/item.dart';
import 'package:moto/model/maintenance.dart';
import 'package:moto/model/month.dart';
import 'package:moto/model/review.dart';
import 'package:moto/model/singleton/singleton_user.dart';
import 'package:moto/utils/date_util.dart';
import 'package:moto/utils/log_util.dart';

import 'base_firebase_service.dart';

class FirebaseMonthService implements MonthContractService {
  CollectionReference _collection;
  BaseFirebaseService _firebaseCrud;

  FirebaseMonthService(String path) {
    _firebaseCrud = BaseFirebaseService("users/${SingletonUser.instance.id}/$path");
    _collection = _firebaseCrud.collection;
  }

  @override
  Future<Month> create(Month item) async {
    return _firebaseCrud.create(item).then((response) {
      return Month.fromMap(response);
    });
  }

  @override
  Future<Month> read(Month item) async {
    return _firebaseCrud.read(item).then((response) async {
      if (response == null) {// Criar um novo mês
        var today = DateTime.now();
        var prevMonth = DateTime(today.year, today.month - 1, today.day);
        String mesAnterior = DateUtil.getNumberMonth(prevMonth) + DateUtil.getNumberYear(prevMonth);
        var list = await findBy("uId", mesAnterior);
        if (list == null || list.isEmpty) {
          item.kmInicio = 0;
          item.kmFim = 0;
          return await create(item);
        } else {
          var lastMonth = list[0];
          item.kmInicio = lastMonth.kmFim;
          item.kmFim = lastMonth.kmFim;
          return await create(item);
        }
      }
      return Month.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<Month> update(Month item) {
    return _firebaseCrud.update(item).then((response) {
      return Month.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<Month> delete(Month item) {

  }

  @override
  Future<List<Month>> findBy(String field, dynamic value) async {
    return _firebaseCrud.findBy(field, value).then((response) {
      return response.map<Month>((item) => Month.fromMap(item)).toList();
    });
  }

  @override
  Future<dynamic> addDespesa(Month month, item) async {
    String uId = _collection.document().documentID;
    (item as BaseModel).id = uId;
    return await _collection.document(month.id).collection("despesas").document(uId).setData((item as BaseModel).toMap()).timeout(Duration(seconds: 10)).then((result) {
      print("result");
      return item;
    }).catchError((error) {
      Log.e(error);
      return null;
    });
  }

  @override
  Future<List> listDespesas(Month month) async {
    String uId = month.id;
    return await _collection.document(uId).collection("despesas").getDocuments().then((value) {
      return value.documents.map<dynamic>((item) {
        if (item.data["type"] == GastoType.MANUTENCAO.toString()) {
          return Maintenance.fromMap(item.data);
        } else if (item.data["type"] == GastoType.PRODUTO.toString()) {
          return Item.fromMap(item.data);
        } else if (item.data["type"] == GastoType.REVISAO.toString()) {
          return Review.fromMap(item.data);
        } else if (item.data["type"] == GastoType.COMBUSTIVEL.toString()) {
          return Fuel.fromMap(item.data);
        }
        return null;
      }).toList();
    }).catchError((error) {
      Log.e(error);
      return null;
    });
  }

}