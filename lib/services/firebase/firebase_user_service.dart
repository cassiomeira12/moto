import 'dart:io';
import 'package:path/path.dart' as Path;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moto/contract/user/user_contract.dart';
import 'package:moto/model/base_user.dart';
import 'package:moto/model/singleton/singleton_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseUserService implements UserContractService {
  CollectionReference _collection = Firestore.instance.collection(BaseUser.getCollection());

  @override
  Future<BaseUser> create(BaseUser item) async {
    String uId = _collection.document().documentID;

    //Atualizando informacoes ao criar novo usuario
    item.setUid(uId);
    //user.notificationToken = PreferenceUtils(activity).getTokenNotification()
    //user.createAt = DateTime();
    //user.updateAt = DateTime();
    //item.status = Status.ATIVO;
    item.password = null; //Nao adicionar a senha no BD

    return await _collection.document(uId).setData(item.toMap()).then((result) {
      return item;
    }).catchError((error) {
      print("Erro ${error.toString()}");
      return null;
    });
  }

  @override
  Future<List<BaseUser>> findBy(String field, value) async {
    return await _collection.where(field, isEqualTo: value).getDocuments().then((value) {
      var list = List<BaseUser>();
      value.documents.forEach((element) {
        list.add(BaseUser.fromMap(element.data));
      });
      return list;
    }).catchError((error) {
      print(error.message);
      return null;
    });
  }

  Future<BaseUser> findUserByEmail(String email) async {
    List<BaseUser> list =  await findBy("email", email);

    if (list == null) {
      return null;
    }

    if (list.length == 1) {
      return list[0];
    } else if (list.length == 0) {
      print("Usuário não encontrado");
      return null;
    } else {
      print("Mais de 1 usuário com mesmo email");
      return null;
    }
  }

  @override
  Future<BaseUser> read(BaseUser item) {
    String uId = item.getUid();
    print("Read User $uId");
    return _collection.document(uId).get().then((result) {
      print("Documento exists ${result.exists}");
      return BaseUser.fromMap(result.data);
    }).catchError((error) {
      print("Erro ${error.toString()}");
      return null;
    });
  }

  @override
  Future<BaseUser> delete(BaseUser item) {
    return null;
  }

  @override
  Future<BaseUser> update(BaseUser item) {
    return _collection.document(item.getUid()).updateData(item.toMap()).timeout(Duration(seconds: 5)).then((value) {
      return item;
    }).catchError((error) {
      return null;
    });
  }

  @override
  Future<BaseUser> createAccount(BaseUser user) async {
    return await create(user);
  }

  @override
  Future<void> changePassword(String email, String password, String newPassword) async {
    return await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((result) {
      result.user.updatePassword(newPassword);
    });
  }

  @override
  Future<bool> changeName(String name) async {
    SingletonUser.instance.name = name;
    return await update(SingletonUser.instance) == null ? false : true;
  }

  @override
  Future<String> changeUserPhoto(File image) async {
    String baseName = Path.basename(image.path);
    String uID = SingletonUser.instance.getUid() + baseName.substring(baseName.length - 4);
    StorageReference storageReference = FirebaseStorage.instance.ref().child("users/${uID}");
    StorageUploadTask uploadTask = storageReference.putFile(image);
    return await uploadTask.onComplete.then((value) async {
      return await storageReference.getDownloadURL().then((fileURL) async {
        SingletonUser.instance.avatarURL = fileURL;
        return await update(SingletonUser.instance) == null ? null : fileURL;
      }).catchError((error) {
        print(error.message);
        return null;
      });
    }).catchError((error) {
      print(error.message);
      return null;
    });
  }

  @override
  Future<BaseUser> currentUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    if (currentUser == null) {
      return null;
    } else {
      BaseUser user = await findUserByEmail(currentUser.email);
      if (user == null) {
        return null;
      }
      user.emailVerified = currentUser.isEmailVerified;
      return user;
    }
  }

  @override
  Future<void> signOut() async {
    //SingletonUser.instance.update(null);
    return await FirebaseAuth.instance.signOut();
  }

  Future<void> _createUser(BaseUser user) async {
    String uId = _collection.document().documentID;
    //Atualizando informacoes ao criar novo usuario
    user.setUid(uId);
    //user.notificationToken = PreferenceUtils(activity).getTokenNotification()
    user.emailVerified = false;
    //user.createAt = DateTime();
    //user.updateAt = DateTime();
    //user.status = Status.ATIVO;
    user.password = null; //Nao adicionar a senha no BD

    return _collection.document(uId).setData(user.toMap());
  }

  @override
  Future<bool> isEmailVerified() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    bool emailVerified = currentUser.isEmailVerified;
    BaseUser user = await findUserByEmail(currentUser.email);
    if (user != null) {
      user.emailVerified = emailVerified;
      _collection.document(user.getUid()).updateData(user.toMap());
    }
    return emailVerified;
  }

  @override
  Future<void> sendEmailVerification() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    return currentUser.sendEmailVerification();
  }

}