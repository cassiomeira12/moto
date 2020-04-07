import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:moto/contract/month/month_contract.dart';
import 'package:moto/model/base_model.dart';
import 'package:moto/model/base_user.dart';
import 'package:moto/model/fuel.dart';
import 'package:moto/model/gasto.dart';
import 'package:moto/model/item.dart';
import 'package:moto/model/maintenance.dart';
import 'package:moto/model/month.dart';
import 'package:moto/model/review.dart';
import 'package:moto/model/singleton/singleton_user.dart';

class FirebaseMonthService implements MonthContractService {
  CollectionReference _collection = Firestore.instance
      .collection(BaseUser.getCollection())
      .document(SingletonUser.instance.getUid())
      .collection(Month.getCollection());

  @override
  Future<Month> create(Month item) async {
    String uId = item.getUid();//_collection.document().documentID;
    item.setUid(uId);
    return await _collection.document(uId).setData(item.toMap()).then((result) {
      return item;
    }).catchError((error) {
      print("Erro ${error.toString()}");
      return null;
    });
  }

  @override
  Future<Month> delete(Month item) {

  }

  @override
  Future<List<Month>> findBy(String field, dynamic value) async {

  }

  @override
  Future<Month> read(Month item) async {
    String uId = item.getUid();
    return await _collection.document(uId).get().then((result) async {
      if (result.exists) {
        return Month.fromMap(result.data);
      }
      return await create(item);
    }).catchError((error) {
      print(error);
      return null;
    });
  }

  @override
  Future<Month> update(Month item) {
    return _collection.document(item.getUid()).updateData(item.toMap()).timeout(Duration(seconds: 5)).then((value) {
      return item;
    }).catchError((error) {
      return null;
    });
  }

  @override
  Future<dynamic> addDespesa(Month month, item) async {
    String uId = _collection.document().documentID;
//    if ((item as Gasto).type == GastoType.MANUTENCAO) {
//      Maintenance maintenance = item as Maintenance;
//      maintenance.setUid(uId);
//      return await _collection.document(month.getUid()).collection("despesas").document(uId).setData(maintenance.toMap()).then((result) {
//        return maintenance;
//      }).catchError((error) {
//        print(error.toString());
//        print(error.message);
//        return null;
//      });
//    } else if ((item as Gasto).type == GastoType.PRODUTO) {
//      print("Produto");
//      Item produto = item as Item;
//      produto.setUid(uId);
//      return await _collection.document(month.getUid()).collection("despesas").document(uId).setData(produto.toMap()).then((result) {
//        return produto;
//      }).catchError((error) {
//        print(error.toString());
//        print(error.message);
//        return null;
//      });
//    } else if ((item as Gasto).type == GastoType.REVISAO) {
//      print("Revisao");
//      Review review = item as Review;
//      review.setUid(uId);
//      return await _collection.document(month.getUid()).collection("despesas").document(uId).setData(review.toMap()).then((result) {
//        return review;
//      }).catchError((error) {
//        print(error.toString());
//        print(error.message);
//        return null;
//      });
//    } else if ((item as Gasto).type == GastoType.COMBUSTIVEL) {
//      Fuel combustivel = item as Fuel;
//      combustivel.setUid(uId);
//      return await _collection.document(month.getUid()).collection("despesas").document(uId).setData(combustivel.toMap()).then((result) {
//        return combustivel;
//      }).catchError((error) {
//        print(error.toString());
//        print(error.message);
//        return null;
//      });
//    }
    (item as BaseModel).setUid(uId);
    return await _collection.document(month.getUid()).collection("despesas").document(uId).setData((item as BaseModel).toMap()).timeout(Duration(seconds: 10)).then((result) {
      print("result");
      return item;
    }).catchError((error) {
      print(error.toString());
      print(error.message);
      return null;
    });
  }

  @override
  Future<List> listDespesas(Month month) async {
    String uId = month.getUid();
    print("listDespesas: $uId");
    return await _collection.document(uId).collection("despesas").getDocuments().then((value) {
//      value.documents.forEach((element) {
//        print(element.data["type"]);
//      });
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
      print(error.toString());
      print(error.message);
      return null;
    });
  }



}