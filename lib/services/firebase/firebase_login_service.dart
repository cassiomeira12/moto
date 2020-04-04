import 'package:moto/contract/login/login_contract.dart';
import 'package:moto/model/base_user.dart';
import 'package:moto/services/firebase/firebase_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../strings.dart';
import '../crud.dart';

class FirebaseLoginService extends LoginContractService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseLoginService(LoginContractPresenter presenter) : super(presenter);

  @override
  signIn(String email, String password) async {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((AuthResult result) async {
      Crud<BaseUser> crud = FirebaseUserService();
      List<BaseUser> list =  await crud.findBy("email", email);

      if (list == null) {
        return presenter.onFailure(USUARIO_NAO_ENCONTRADO);
      }

      if (list.length == 1) {
        BaseUser user = list[0];
        if (!user.emailVerified) { // Verificando se o email do usuario foi validado
          user.emailVerified = result.user.isEmailVerified; // Atualizando caso o email ja foi validado
          crud.update(user); // Atualizando a base de dados
        }
        presenter.onSuccess(user);
      } else if (list.length == 0) {
        _firebaseAuth.signOut();
        presenter.onFailure(USUARIO_NAO_ENCONTRADO);
      }

    }).catchError((error) {
      presenter.onFailure(error.toString());
    });
  }

  @override
  signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: googleSignInAuthentication.accessToken,
      accessToken: googleSignInAuthentication.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential).then((AuthResult result) async {
      Crud<BaseUser> crud = FirebaseUserService();
      List<BaseUser> list =  await crud.findBy("email", result.user.email);

      if (list == null) {
        return presenter.onFailure(USUARIO_NAO_ENCONTRADO);
      }

      if (list.length == 1) {
        BaseUser user = list[0];
        if (!user.emailVerified) { // Verificando se o email do usuario foi validado
          user.emailVerified = result.user.isEmailVerified; // Atualizando caso o email ja foi validado
          crud.update(user); // Atualizando a base de dados
        }
        presenter.onSuccess(user);
      } else if (list.length == 0) {
        _firebaseAuth.signOut();
        presenter.onFailure(USUARIO_NAO_ENCONTRADO);
      }

    }).catchError((error) {
      print(error.message);
      presenter.onFailure(error.message);
    });
  }

}