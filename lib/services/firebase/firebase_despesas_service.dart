import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moto/contract/month/despesas_contract.dart';
import 'package:moto/model/base_user.dart';
import 'package:moto/model/month.dart';
import 'package:moto/model/singleton/singleton_user.dart';
import 'package:moto/utils/log_util.dart';

import 'base_firebase_service.dart';

class FirebaseDespesasService implements DespesasContractService {
  CollectionReference _collection;
  BaseFirebaseService _firebaseCrud;

  FirebaseDespesasService(String path) {
    _firebaseCrud = BaseFirebaseService("users/${SingletonUser.instance.id}/$path");
    _collection = _firebaseCrud.collection;
  }

  @override
  Future<dynamic> create(dynamic item) {

  }

  @override
  Future<dynamic> read(dynamic item) {
    return _firebaseCrud.read(item).then((response) {
      return Month.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<dynamic> update(dynamic item) {
    return _firebaseCrud.update(item).then((response) {
      return Month.fromMap(response);
    }).catchError((error) {
      Log.e("Document ${item.id} not found");
    });
  }

  @override
  Future<dynamic> delete(dynamic item) {

  }

  @override
  Future<List<dynamic>> findBy(String field, dynamic value) async {

  }

  Future<List<dynamic>> listDespesas(Month item) {
//    String uId = item.getUid();
//    return _collection.document(uId).collection("despesas").getDocuments().then((value) {
//      List<dynamic> list = List();
//      value.documents.map((item) {
//
//      });
//    }).catchError((error) {
//      return null;
//    });
  }





}