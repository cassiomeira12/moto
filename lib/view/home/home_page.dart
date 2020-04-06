import 'package:moto/contract/month/month_contract.dart';
import 'package:moto/model/fuel.dart';
import 'package:moto/model/gasto.dart';
import 'package:moto/model/item.dart';
import 'package:moto/model/maintenance.dart';
import 'package:moto/model/month.dart';
import 'package:moto/model/review.dart';
import 'package:moto/presenter/month/month_presenter.dart';
import 'package:moto/strings.dart';
import 'package:moto/view/home/gasto_page.dart';
import 'package:moto/view/widgets/background_card.dart';
import 'package:moto/view/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

import '../page_router.dart';

class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements MonthContractView {
  final _formKey = new GlobalKey<FormState>();

  MonthContractPresenter presenter;

  Month currentMonth;
  String totalMes = "0.00";
  int kmRodados;

  List<dynamic> listDespesas;

  @override
  void initState() {
    super.initState();
    presenter = MouthPresenter(this);
    currentMonth = Month();
    currentMonth.setUid("0${DateTime.now().month}${DateTime.now().year}");
    presenter.read(currentMonth);
    list();
  }

  Future list() async {
    List list = await presenter.listDespesas(currentMonth);
    double total = 0;
//    list.forEach((element) {
//      total += (element as Fuel).total;
//    });
    setState(() {
      totalMes = total.toString();
      listDespesas = list;
    });
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
                BackgroundCard(height: 300,),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _showForm(),
                    ],
                  ),
                ),
              ],
            ),
            novoGastoButton(),
            Container(
              width: double.infinity,
              height: 300,
              child: listDespesas == null ? showCircularProgress() : listView2(),
            ),
            //formOpcoes(),
          ],
        ),
      ),
    );
  }

  @override
  onFailure(String error) {
    print("error");
  }

  @override
  onSuccess(Month result) {
    kmRodados = result.kmRodados();
    setState(() {
      currentMonth = result;
    });
  }

  Widget showCircularProgress() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: CircularProgressIndicator(),
    );
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(0),
      child: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 12),
                  child: Text(
                    "Abril",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 100,
                        child: RaisedButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                          color: Theme.of(context).backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              currentMonth == null ?
                              showCircularProgress()
                                  :
                              Column(
                                children: <Widget>[
                                  Text(
                                    "Atual: ${currentMonth.kmFim} km",
                                    style: Theme.of(context).textTheme.body1,
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "Mês ${kmRodados} km",
                                    style: Theme.of(context).textTheme.body1,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onPressed: () {
                            //print(currentMonth.combustivel.toString());
                          },
                        ),
                      ),
                    ),

                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 100,
                        child: RaisedButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                          color: Theme.of(context).backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Moto Honda Fan 150",
                                style: Theme.of(context).textTheme.body1,
                                textAlign: TextAlign.center,
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                child: Text(
                                  "NYM4C20",
                                  style: Theme.of(context).textTheme.body1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () { },
                        ),
                      ),
                    ),


                  ],
                ),




                Padding(
                  padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                  child: SizedBox(
                    height: 100,
                    child: RaisedButton(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                      color: Theme.of(context).backgroundColor,
                      child: Center(
                        child: Text(
                          "Gastos total: R\$: ${totalMes}",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                      onPressed: () { },
                    ),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: SecondaryButton(
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
          PageRouter.push(context, GastoPage(month: currentMonth,));
        },
      ),
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

  Widget item2(int index) {

    String tipo, imagem, preco, data;

    switch((listDespesas[index] as Gasto).type) {
      case GastoType.COMBUSTIVEL:
        Fuel fuel = listDespesas[index] as Fuel;
        tipo = "Combustível";
        imagem = "assets/combustivel.png";
        preco = fuel.total.toString();
        break;
      case GastoType.MANUTENCAO:
        Maintenance maintenance = listDespesas[index] as Maintenance;
        tipo = "Manutenção";
        imagem = "assets/manutencao.png";
        preco = maintenance.total.toString();
        break;
      case GastoType.PRODUTO:
        Item item = listDespesas[index] as Item;
        tipo = "Produto";
        imagem = "assets/manutencao.png";
        preco = item.total.toString();
        break;
      case GastoType.REVISAO:
        Review review = listDespesas[index] as Review;
        tipo = "Revisão";
        imagem = "assets/manutencao.png";
        preco = review.total.toString();
        break;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: SecondaryButton(
        child: Container(
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    imagem,
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
                        tipo,
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
                    "R\$: $preco",
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
      ),
    );
  }

  Widget listView2() {
    return ListView.builder(
      itemCount: listDespesas == null ? 0 : listDespesas.length,
      itemBuilder: (BuildContext context, int index) {
        return item2(index);
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

//              listDespesas == null ?
//                Container()
//                  :
//                ListView.builder(
//                  itemCount: listDespesas.length,
//                  itemBuilder: (BuildContext context, int index) {
//                    return Padding(
//                      padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                      child: item(),
//                    );
//                  },
//                ),


//              Padding(
//                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                child: item2(),
//              ),
//              Padding(
//                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                child: item2(),
//              ),
//              Padding(
//                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                child: item2(),
//              ),
//              Padding(
//                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
//                child: item2(),
//              ),

            ],
          ),
        ),
      ],
    );
  }

}