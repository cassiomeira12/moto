import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moto/contract/month/month_contract.dart';
import 'package:moto/model/base_model.dart';
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
import 'package:moto/view/home/novo_gasto_page.dart';
import 'package:moto/view/widgets/scaffold_snackbar.dart';
import 'package:moto/view/widgets/secondary_button.dart';
import 'package:flutter/material.dart';

import '../page_router.dart';
import 'veiculo_page.dart';

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
      listDespesas.sort((a, b) {
        return b.data.compareTo(a.data);
      });
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
      //SingletonMonth.instance.id = "042020";
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
        CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                  widget.listDespesas.map<Widget>((item) {
                    return listItem(item);
                  }).toList()
              ),
            ),
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
                            showDialogUpdateKM();
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
                          onPressed: () {
                            PageRouter.push(context, VeiculoPage());
                          },
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
                return NovoGastoPage(month: currentMonth);
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

  Widget listItem(dynamic item) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: gastoWidget(item as Gasto),
      ),
      secondaryActions: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 8, 0),
          child: IconSlideAction(
            caption: DELETAR,
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              showDialogDeleteGasto(item as BaseModel);
            },
          ),
        ),
      ],
    );
  }

  Widget gastoWidget(Gasto gasto) {
    String tipo, preco, data;
    preco = gasto.total.toString();

    switch(gasto.type) {
      case GastoType.COMBUSTIVEL:
        Fuel fuel = gasto as Fuel;
        data = DateUtil.formatDateMouthHour(fuel.data);
        tipo = "${fuel.combustivel} - ${fuel.litros} litros";
        break;
      case GastoType.MANUTENCAO:
        Maintenance maintenance = gasto as Maintenance;
        data = DateUtil.formatDateMouthHour(maintenance.data);
        tipo = "Manutenção";
        break;
      case GastoType.PRODUTO:
        Item item = gasto as Item;
        data = DateUtil.formatDateMouthHour(item.data);
        tipo = item.produto;
        break;
      case GastoType.REVISAO:
        Review review = gasto as Review;
        data = DateUtil.formatDateMouthHour(review.data);
        tipo = "Revisão";
        break;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: SecondaryButton(
        child: Container(
          child: Row(
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    gasto.imagem,
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
                        data,
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
                    "R\$ $preco",
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
          PageRouter.push(context, GastoPage());
        },
      ),
    );
  }

  void showDialogUpdateKM() {
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

  void showDialogDeleteGasto(BaseModel gasto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DELETAR),
          content: Text("Deseja remover o gasto ?"),
          actions: <Widget>[
            FlatButton(
              child: Text(CANCELAR),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text(DELETAR),
              onPressed: () {
                PageRouter.pop(context);
                presenter.deleteDespesa(currentMonth, gasto);
                setState(() {
                  widget.listDespesas.remove(gasto);
                });
              },
            ),
          ],
        );
      },
    );
  }

}