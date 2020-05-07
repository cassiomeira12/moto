import 'package:flutter/cupertino.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moto/contract/month/month_contract.dart';
import 'package:moto/main.dart';
import 'package:moto/model/fuel.dart';
import 'package:moto/model/gasto.dart';
import 'package:moto/model/item.dart';
import 'package:moto/model/maintenance.dart';
import 'package:moto/model/month.dart';
import 'package:moto/model/review.dart';
import 'package:moto/model/singleton/singleton_month.dart';
import 'package:moto/presenter/month/month_presenter.dart';
import 'package:moto/strings.dart';
import 'package:moto/utils/date_util.dart';
import 'package:moto/view/home/gasto_page.dart';
import 'package:moto/view/widgets/scaffold_snackbar.dart';
import 'package:moto/view/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

import '../page_router.dart';

class HomePage extends StatefulWidget {
  _HomePageState page;
  List<dynamic> listDespesas;

  @override
  State<StatefulWidget> createState() {
    page = _HomePageState();
    return page;
  }

  void addDespesa(dynamic despesa) {
    page.setState(() {
      page.totalMes += (despesa as Gasto).total;
      listDespesas.add(despesa);
    });
  }
}

class _HomePageState extends State<HomePage> implements MonthContractView {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String month = "";

  var _controllerKilometragem = TextEditingController();

  MonthContractPresenter presenter;

  Month currentMonth;
  double totalMes = 0.0;
  int kmInicio, kmAtualTemp = 0, kmRodados;

  @override
  void initState() {
    super.initState();
    presenter = MouthPresenter(this);
    month = "Mês de ${DateUtil.getMonth(DateTime.now())}";
    if (SingletonMonth.instance.id == null) {
      SingletonMonth.instance.id = DateUtil.getNumberMonth(DateTime.now()) + DateUtil.getNumberYear(DateTime.now());
    }
    currentMonth = SingletonMonth.instance;
    presenter.read(currentMonth);
    list();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future list() async {
    List list = await presenter.listDespesas(currentMonth);
    double total = 0;
    list.forEach((element) {
      total += (element as Gasto).total;
    });
    setState(() {
      totalMes = total;
      widget.listDespesas = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(HOME, style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 250,
              floating: false,
              pinned: false, //barra
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  month,
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                background: _showForm(),
              ),
            ),
          ];
        },
        body: (widget.listDespesas == null || widget.listDespesas.isEmpty) ?
        semDespesas()
          :
        ListView.builder(
          itemCount: widget.listDespesas == null ? 0 : widget.listDespesas.length,
          itemBuilder: (context, index) {
            return gastoWidget(index);
          },
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
    SingletonMonth.instance.update(result);
    kmInicio = result.kmInicio;
    kmRodados = result.kmRodados();
    setState(() {
      currentMonth.update(SingletonMonth.instance);
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
            padding: EdgeInsets.fromLTRB(0, 12, 0, 0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: SizedBox(
                        height: 100,
                        child: RaisedButton(
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
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
                                    style: Theme.of(context).textTheme.display1,
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
                            showDialogLogOut();
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                          color: Theme.of(context).backgroundColor,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Moto Honda Fan 150",
                                style: Theme.of(context).textTheme.display1,
                                textAlign: TextAlign.center,
                              ),
                              RaisedButton(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                                child: Text(
                                  "NYM4C20",
                                  style: Theme.of(context).textTheme.body1,
                                  textAlign: TextAlign.center,
                                ),
                                disabledColor: Colors.black12,
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
                  padding: EdgeInsets.fromLTRB(8, 24, 8, 0),
                  child: SizedBox(
                    height: 50,
                    child: RaisedButton(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),),
                      color: Theme.of(context).backgroundColor,
                      child: Center(
                        child: Text(
                          "Gastos total: R\$: ${totalMes}",
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                      disabledColor: Theme.of(context).backgroundColor,
                    ),
                  ),
                ),

                //novoGastoButton(),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget semDespesas() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 12, 0, 8),
          child: Center(
            child: Text(
              "Sem despesas",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.body2,
            ),
          ),
        )
      ],
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
        onPressed: () async {
          final result = await Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) {
                return GastoPage(month: currentMonth);
              }
            ),
          );
          setState(() {
            totalMes += (result as Gasto).total;
            widget.listDespesas.add(result);
          });
        },
      ),
    );
  }

  Widget gastoWidget(int index) {
    String tipo, preco, data;
    preco = (widget.listDespesas[index] as Gasto).total.toString();

    switch((widget.listDespesas[index] as Gasto).type) {
      case GastoType.COMBUSTIVEL:
        Fuel fuel = widget.listDespesas[index] as Fuel;
        //data = "Dia ${fuel.data.day} às ${fuel.data.hour}:${fuel.data.minute}";
        tipo = "Combustível";
        break;
      case GastoType.MANUTENCAO:
        Maintenance maintenance = widget.listDespesas[index] as Maintenance;
        //data = "Dia ${maintenance.data.day} às ${maintenance.data.hour}:${maintenance.data.minute}";
        tipo = "Manutenção";
        break;
      case GastoType.PRODUTO:
        Item item = widget.listDespesas[index] as Item;
        //data = "Dia ${item.data.day} às ${item.data.hour}:${item.data.minute}";
        tipo = "Produto";
        break;
      case GastoType.REVISAO:
        Review review = widget.listDespesas[index] as Review;
        //data = "Dia ${review.data.day} às ${review.data.hour}:${review.data.minute}";
        tipo = "Revisão";
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
                    (widget.listDespesas[index] as Gasto).imagem,
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
                        "Data",
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

  void showDialogLogOut() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Atualizar kilometragem"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              kmInicio == 0 ? kilometragemInicioInput() : Container(),
              kilometragemInput(),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(CANCELAR),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(SALVAR),
              onPressed: atualizarKilometragem,
            ),
          ],
        );
      },
    );
  }

  Widget kilometragemInicioInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: TextFormField(
        textAlign: TextAlign.center,
        maxLines: 1,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.body2,
        textCapitalization: TextCapitalization.words,
        //controller: _controllerKilometragem,
        decoration: InputDecoration(
          labelText: "Km inicio",
          //hintText: "(XX) X XXXX-XXXX",
          //hintStyle: Theme.of(context).textTheme.body2,
          labelStyle: Theme.of(context).textTheme.body2,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).errorColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        onChanged: (value) {
          kmInicio = int.parse(value);
        },
      ),
    );
  }

  Widget kilometragemInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: TextFormField(
        textAlign: TextAlign.center,
        maxLines: 1,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.body2,
        textCapitalization: TextCapitalization.words,
        controller: _controllerKilometragem,
        decoration: InputDecoration(
          labelText: "Km atual",
          //hintText: "(XX) X XXXX-XXXX",
          //hintStyle: Theme.of(context).textTheme.body2,
          labelStyle: Theme.of(context).textTheme.body2,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).errorColor),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).errorColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        onChanged: (value) {
          kmAtualTemp = int.parse(value);
        },
      ),
    );
  }

  void atualizarKilometragem() {
    if (kmAtualTemp != 0) {
      _controllerKilometragem.clear();
      setState(() {
        if (currentMonth.kmInicio != kmInicio) {
          currentMonth.kmInicio = kmInicio;
        }
        currentMonth.kmFim = kmAtualTemp;
        kmRodados = currentMonth.kmRodados();
      });
      presenter.update(currentMonth);
      kmAtualTemp = 0;
      Navigator.of(context).pop();
      ScaffoldSnackBar.success(context, _scaffoldKey, "Kilometragem atualizada");
    }
  }

}