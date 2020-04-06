import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moto/contract/month/despesas_contract.dart';
import 'package:moto/model/base_user.dart';
import 'package:moto/model/month.dart';
import 'package:moto/model/singleton/singleton_user.dart';

class FirebaseDespesasService implements DespesasContractService {
  CollectionReference _collection = Firestore.instance
      .collection(BaseUser.getCollection())
      .document(SingletonUser.instance.getUid())
      .collection(Month.getCollection());

  @override
  Future<dynamic> create(dynamic item) {


  }

  @override
  Future<dynamic> delete(dynamic item) {

  }

  @override
  Future<List<dynamic>> findBy(String field, dynamic value) async {

  }

  Future<List<dynamic>> listDespesas(Month item) {
    String uId = item.getUid();
    return _collection.document(uId).collection("despesas").getDocuments().then((value) {
      List<dynamic> list = List();
      value.documents.map((item) {

      });
    }).catchError((error) {
      return null;
    });
  }

  @override
  Future<dynamic> read(dynamic item) {
    String uId = item.getUid();
    return _collection.document(uId).get().then((result) async {
      return Month.fromMap(result.data);
    }).catchError((error) {
      return null;
    });
  }

  @override
  Future<dynamic> update(dynamic item) {
    return _collection.document(item.getUid()).updateData(item.toMap()).timeout(Duration(seconds: 5)).then((value) {
      return item;
    }).catchError((error) {
      return null;
    });
  }



}