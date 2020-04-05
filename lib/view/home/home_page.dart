import 'package:moto/strings.dart';
import 'package:moto/view/home/gasto_page.dart';
import 'package:moto/view/widgets/background_card.dart';
import 'package:moto/view/widgets/primary_button.dart';
import 'package:moto/view/widgets/secondary_button.dart';
import 'package:moto/view/widgets/shape_round.dart';
import 'package:flutter/material.dart';

import '../page_router.dart';
import 'search_page.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        title: Text(HOME, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                BackgroundCard(height: 200,),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _showForm(),
                    ],
                  ),
                ),
              ],
            ),
            formOpcoes(),
          ],
        ),
      ),
    );
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Abril",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                SecondaryButton(
                  child: Container(
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Atualizar KM atual: 36896",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    PageRouter.push(context, GastoPage());
                  },
                ),



                Text(
                  "Km percorridos: 300 km",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Gastos total: R\$:60,00",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget novoGastoButton() {
    return SecondaryButton(
      child: Container(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.add_circle,
                color: Colors.green,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Novo gasto",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      onPressed: () {

      },
    );
  }

  Widget item() {
    return SecondaryButton(
      child: Container(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/manutencao.png",
                  width: 40,
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Revisão completa",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.display1,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "4 de abril",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.display2,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "R\$: 700,00",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).errorColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: () {

      },
    );
  }

  Widget item2() {
    return SecondaryButton(
      child: Container(
        child: Row(
          children: <Widget>[
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Image.asset(
                  "assets/combustivel.png",
                  width: 40,
                ),
              ),
            ),
            Flexible(
              flex: 4,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Gasolina",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.display1,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "1 de abril",
                      maxLines: 1,
                      style: Theme.of(context).textTheme.display2,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "R\$: 10,00",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).errorColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
      onPressed: () {

      },
    );
  }

  Widget formOpcoes() {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            children: <Widget>[
              novoGastoButton(),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: item(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: item2(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: item2(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: item2(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: item2(),
              ),

            ],
          ),
        ),
      ],
    );
  }

}