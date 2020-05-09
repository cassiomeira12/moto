import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moto/model/singleton/singleton_month.dart';
import 'package:moto/strings.dart';
import 'package:moto/view/comanda/comanda_page.dart';
import 'package:moto/view/historico/historico_page.dart';
import 'package:moto/view/home/home_page.dart';
import 'package:moto/view/notifications/notifications_page.dart';
import 'package:moto/view/settings/settings_page.dart';
import 'package:flutter/material.dart';

import 'home/novo_gasto_page.dart';
import 'page_router.dart';

class TabsPage extends StatefulWidget {
  TabsPage({this.logoutCallback});

  final VoidCallback logoutCallback;

  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {

  int currentTab = 0;
  List<Widget> screens;
  Widget currentScreen;

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    screens = [
      HomePage(),
      NotificationsPage(),
      ComandaPage(),
      HistoricoPage(),
      SettingsPage(logoutCallback: widget.logoutCallback,),
    ];
    currentScreen = screens[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        splashColor: Theme.of(context).backgroundColor,
        onPressed: () async {
          final result = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return NovoGastoPage(month: SingletonMonth.instance);
              }
            ),
          );
          if (result != null) {
            (screens[0] as HomePage).addDespesa(result);
          }
        },
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            FaIcon(FontAwesomeIcons.plus, color: currentTab == 2 ? Theme.of(context).primaryColorLight : Colors.white,),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
              child: notificationCount(0),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: customBottomNavigationBar(),
    );
  }

  Widget customBottomNavigationBar() {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Container(
        height: 60,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: MaterialButton(
                  //color: currentTab == 0 ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
                  elevation: 0,
                  shape: StadiumBorder(),
                  splashColor: Theme.of(context).backgroundColor,
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[0];
                      currentTab = 0;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      //FaIcon(FontAwesomeIcons.home, color: currentTab == 0 ? Theme.of(context).cardColor : Colors.grey,),
                      FaIcon(FontAwesomeIcons.home, color: currentTab == 0 ? Theme.of(context).primaryColorLight : Colors.grey,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: notificationCount(0),
                      ),
                    ],
                  ),
                ),
              ),
            ),

//            Expanded(
//              flex: 2,
//              child: Container(
//                margin: EdgeInsets.fromLTRB(0, 5, 10, 5),
//                child: Stack(
//                  children: <Widget>[
//                    MaterialButton(
//                      //color: currentTab == 1 ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
//                      elevation: 0,
//                      height: double.maxFinite,
//                      shape: StadiumBorder(),
//                      splashColor: Theme.of(context).backgroundColor,
//                      clipBehavior: Clip.hardEdge,
//                      onPressed: () {
//                        setState(() {
//                          currentScreen = screens[1];
//                          currentTab = 1;
//                        });
//                      },
//                      child: Stack(
//                        alignment: Alignment.center,
//                        children: <Widget>[
//                          //FaIcon(FontAwesomeIcons.bell, color: currentTab == 1 ? Theme.of(context).cardColor : Colors.grey,),
//                          FaIcon(FontAwesomeIcons.solidBell, color: currentTab == 1 ? Theme.of(context).primaryColorLight : Colors.grey,),
//                          Padding(
//                            padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
//                            child: notificationCount(1),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),

            Expanded(
              flex: 1,
              child: Container(),
            ),

//            Expanded(
//              flex: 2,
//              child: Container(
//                margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
//                child: MaterialButton(
//                  //color: currentTab == 3 ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
//                  elevation: 0,
//                  shape: StadiumBorder(),
//                  splashColor: Theme.of(context).backgroundColor,
//                  clipBehavior: Clip.hardEdge,
//                  onPressed: () {
//                    setState(() {
//                      currentScreen = screens[3];
//                      currentTab = 3;
//                    });
//                  },
//                  child: Stack(
//                    alignment: Alignment.center,
//                    children: <Widget>[
//                      //FaIcon(FontAwesomeIcons.history, color: currentTab == 3 ? Theme.of(context).cardColor : Colors.grey,),
//                      FaIcon(FontAwesomeIcons.history, color: currentTab == 3 ? Theme.of(context).primaryColorLight : Colors.grey,),
//                      Padding(
//                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
//                        child: notificationCount(0),
//                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),

            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: MaterialButton(
                  //color: currentTab == 4 ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
                  elevation: 0,
                  shape: StadiumBorder(),
                  splashColor: Theme.of(context).backgroundColor,
                  clipBehavior: Clip.hardEdge,
                  onPressed: () {
                    setState(() {
                      currentScreen = screens[4];
                      currentTab = 4;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      //FaIcon(FontAwesomeIcons.userCog, color: currentTab == 4 ? Theme.of(context).cardColor : Colors.grey,),
                      FaIcon(FontAwesomeIcons.userCog, color: currentTab == 4 ? Theme.of(context).primaryColorLight : Colors.grey,),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: notificationCount(0),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget notificationCount(int notifications) {
    return notifications > 0 ?
    Align(
      alignment: Alignment.topCenter,
      child: ClipOval(
        child: Container(
          height: 20, width: 20,
          color: Colors.red,
          alignment: Alignment.center,
          child: Text(notifications.toString(), style: TextStyle(color: Colors.white,),),
        ),
      ),
    ) : Container();
  }
}
