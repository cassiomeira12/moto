import 'package:moto/contract/user/user_contract.dart';
import 'package:moto/model/base_user.dart';
import 'package:moto/model/singleton/singleton_user.dart';
import 'package:moto/presenter/user/user_presenter.dart';
import 'package:moto/strings.dart';
import 'package:moto/themes/my_themes.dart';
import 'package:moto/themes/custom_theme.dart';
import 'package:moto/utils/preferences_util.dart';
import 'package:moto/view/tabs_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login/login_page.dart';
import 'login/verified_email_page.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  EMAIL_NOT_VERIFIED,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> implements UserContractView {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  UserContractPresenter presenter;

  @override
  void initState() {
    super.initState();
    presenter = UserPresenter(this);
    presenter.currentUser();
    updateCurrentTheme();
  }

  void updateCurrentTheme() async {
    String theme = await PreferencesUtil.getTheme();
    CustomTheme.instanceOf(context).changeTheme(MyThemes.geKey(theme));
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(loginCallback: loginCallback,);
        break;
      case AuthStatus.LOGGED_IN:
        return TabsPage(logoutCallback: logoutCallback,);
        break;
      case AuthStatus.EMAIL_NOT_VERIFIED:
        return VerifiedEmailPage(logoutCallback: logoutCallback,);
      default:
        return buildWaitingScreen();
    }
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Hero(
                tag: APP_NAME,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 100,
                    child: Image.asset("assets/logo_app.png"),
                  ),
                ),
              ),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }

  void loginCallback() {
    if (SingletonUser.instance.emailVerified) {
      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
    } else {
      setState(() {
        authStatus = AuthStatus.EMAIL_NOT_VERIFIED;
      });
    }
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  @override
  onFailure(String error) {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
    });
  }

  @override
  onSuccess(BaseUser user) {
    SingletonUser.instance.update(user);
    if (user.emailVerified) {
      setState(() {
        authStatus = AuthStatus.LOGGED_IN;
      });
    } else {
      setState(() {
        authStatus = AuthStatus.EMAIL_NOT_VERIFIED;
      });
    }
  }

}