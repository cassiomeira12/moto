import 'package:moto/contract/user/user_contract.dart';
import 'package:moto/model/base_user.dart';
import 'package:moto/model/singleton/singleton_user.dart';
import 'package:moto/presenter/user/user_presenter.dart';
import 'package:moto/presenter/version_app_presenter.dart';
import 'package:moto/strings.dart';
import 'package:moto/themes/my_themes.dart';
import 'package:moto/themes/custom_theme.dart';
import 'package:moto/utils/preferences_util.dart';
import 'package:moto/view/tabs_page.dart';
import 'package:moto/model/version_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login/login_page.dart';
import 'login/verified_email_page.dart';
import 'widgets/background_card.dart';
import 'widgets/primary_button.dart';
import 'widgets/secondary_button.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  EMAIL_NOT_VERIFIED,
  LOGGED_IN,
  UPDATE_APP,
}

class RootPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> implements UserContractView {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;

  UserContractPresenter presenter;

  VersionApp versionApp;
  bool minimumUpdate = true;

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
      case AuthStatus.UPDATE_APP:
        return updateAppScreen();
        break;
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

  void checkLastVersionApp() async {
    var last = await PreferencesUtil.getLastCheckUpdate();
    if (last == null) {//First check
      checkCurrentVersion();
    } else {
      var now = DateTime.now();
      var dif = now.difference(last);
      if (dif.inDays > 3) {//Check update
        checkCurrentVersion();
      }
      checkCurrentVersion();
    }
  }

  void checkCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    int buildNumber = int.parse(packageInfo.buildNumber);
    versionApp = await VersionAppPresenter().checkCurrentVersion(packageName);
    if (versionApp != null) {
      if (versionApp.currentCode > buildNumber) {
        setState(() => authStatus = AuthStatus.UPDATE_APP);
      }
      if (versionApp.minimumCode > buildNumber) {
        setState(() {
          minimumUpdate = false;
        });
      }
    }
    PreferencesUtil.setLastCheckUpdate(DateTime.now());//Atualizando ultimo check de versao
  }

  Widget updateAppScreen() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Stack(
            children: <Widget>[
              BackgroundCard(height: 200,),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 130,),
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Theme.of(context).hintColor,
                  ),
                ),
                child: Icon(
                  Icons.system_update,
                  size: 100,
                  color: Colors.lightBlue,
                ),
              ),
            ],
          ),
          Text(
            UPDATE_APP,
            style: Theme.of(context).textTheme.subtitle,
            textAlign: TextAlign.center,
          ),
          minimumUpdate ?
          Container()
              :
          Text(
            VERSION_OLDER,
            style: Theme.of(context).textTheme.body1,
            textAlign: TextAlign.center,
          ),
          Row(
            children: <Widget>[
              minimumUpdate ?
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: SecondaryButton(
                    text: NOT_NOW,
                    onPressed: () => setState(() => authStatus = AuthStatus.LOGGED_IN),
                  ),
                ),
              )
                  :
              Container(),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: PrimaryButton(
                    text: UPDATE,
                    onPressed: () async {
                      if (await canLaunch(versionApp.url)) {
                        launch(versionApp.url);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
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
    updateNotificationToken();
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
      checkLastVersionApp();
    } else {
      setState(() {
        authStatus = AuthStatus.EMAIL_NOT_VERIFIED;
      });
    }
    updateNotificationToken();
  }

  void updateNotificationToken() async {
    String notificationToken = await PreferencesUtil.getNotificationToken();
    NotificationToken token = SingletonUser.instance.notificationToken;
    if (token == null || token.token != notificationToken) {
      SingletonUser.instance.notificationToken = NotificationToken(notificationToken);
      presenter.update(SingletonUser.instance);
    }
  }

}