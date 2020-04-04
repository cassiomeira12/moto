import 'package:moto/strings.dart';
import 'package:moto/view/widgets/background_card.dart';
import 'package:flutter/material.dart';

class AboutAppPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutAppPage> {
  final _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        title: Text(ABOUT, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                BackgroundCard(height: 200,),
                txtAboutApp(),
              ],
            ),
            SingleChildScrollView(
              child: _showForm(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showForm() {
    return new Container(
      padding: EdgeInsets.all(12.0),
      child: new Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            imgApp(),
            txtAppName(),
            //textTitle(),
            //emailInput(),
            //textMensagem(),
            //_isLoading ? showCircularProgress() : sendButton()
          ],
        ),
      ),
    );
  }

  Widget imgApp() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Center(
        child: Hero(
          tag: "about",
          child: Padding(
            padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 80.0,
              child: Image.asset("assets/logo_app.png"),
            ),
          ),
        ),
      ),
    );
  }

  Widget txtAppName() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Center(
        child: Text(
          APP_NAME,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.body1,
        ),
      ),
    );
  }

  Widget txtAboutApp() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      width: double.maxFinite,
      child: Text(
        "About App",
        style: Theme.of(context).textTheme.body1,
      ),
    );
  }

}