import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:moto/contract/month/month_contract.dart';
import 'package:moto/model/fuel.dart';
import 'package:moto/model/gasto.dart';
import 'package:moto/model/item.dart';
import 'package:moto/model/maintenance.dart';
import 'package:moto/model/month.dart';
import 'package:moto/model/review.dart';
import 'package:moto/presenter/month/month_presenter.dart';
import 'package:moto/strings.dart';
import 'package:moto/view/widgets/background_card.dart';
import 'package:moto/view/widgets/primary_button.dart';
import 'package:moto/view/widgets/rounded_shape.dart';
import 'package:moto/view/widgets/scaffold_snackbar.dart';
import 'package:moto/view/widgets/shape_round.dart';
import 'package:flutter/material.dart';

class GastoPage extends StatefulWidget {
  GastoPage({this.month});

  final Month month;

  @override
  State<StatefulWidget> createState() => _GastoPageState();
}

class _GastoPageState extends State<GastoPage> implements MonthContractView {
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  MonthContractPresenter presenter;

  String _tipoGasto;
  String _tipoCombustivel = "Gasolina";

  Widget currentGasto;

  var _controllerProduto = TextEditingController();
  var _controllerPreco = MoneyMaskedTextController(leftSymbol: 'R\$: ', decimalSeparator: '.', thousandSeparator: ',');
  var _controllerLitros = MoneyMaskedTextController(rightSymbol: ' L', decimalSeparator: '.', thousandSeparator: ',');
  var _controllerQuantidade = TextEditingController();

  @override
  void initState() {
    super.initState();
    presenter = MouthPresenter(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Gasto", style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                BackgroundCard(),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        child: tipoGasto(),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                        child: currentGasto == null ? Container() : ShapeRound(_showForm()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: RaisedButton(
                elevation: 10,
                color: Theme.of(context).backgroundColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "Câmera",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                onPressed: () { },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  onFailure(String error) {
    ScaffoldSnackBar.failure(context, _scaffoldKey, error);
  }

  @override
  onSuccess(Month result) {
    ScaffoldSnackBar.success(context, _scaffoldKey, "Sucesso!");
//    setState(() {
//      currentMonth = result;
//    });
  }

  Widget tipoGasto() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: RoundedShape(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: DropdownButton<String>(
          value: _tipoGasto,
          underline: SizedBox(),
          style: Theme.of(context).textTheme.body2,
          isExpanded: true,
          hint: Text(
            "Tipo de gasto",
            style: Theme.of(context).textTheme.body2,
          ),
          items: GastoType.values.map<DropdownMenuItem<String>>((GastoType value) {
            return DropdownMenuItem<String>(
              value: value.toString().split(".").last,
              child: Text(value.toString().split(".").last),
            );
          }).toList(),
          onChanged: (value) {
            _controllerLitros.clear();
            _controllerPreco.clear();
            _controllerProduto.clear();
            _controllerQuantidade.clear();
            setState(() => _tipoGasto = value);
            if (value == GastoType.COMBUSTIVEL.toString().split(".").last) {
              setState(() => currentGasto = gastoCombustivel());
            } else if (value == GastoType.MANUTENCAO.toString().split(".").last) {
              setState(() => currentGasto = gastoManutencao());
            } else if (value == GastoType.PRODUTO.toString().split(".").last) {
              setState(() => currentGasto = gastoProduto());
            } else if (value == GastoType.REVISAO.toString().split(".").last) {
              setState(() => currentGasto = gastoRevisao());
            }
          },
        ),
      ),
    );
  }

  Widget gastoCombustivel() {
    return Column(
      children: <Widget>[
        combustivelDropButton(),
        precoInput(),
        litrosInput(),
        salvarButton(),
      ],
    );
  }

  Widget gastoManutencao() {
    return Column(
      children: <Widget>[
        precoInput(),
        salvarButton(),
      ],
    );
  }

  Widget gastoProduto() {
    return Column(
      children: <Widget>[
        produtoInput(),
        quantidadeInput(),
        precoInput(),
        salvarButton(),
      ],
    );
  }

  Widget gastoRevisao() {
    return Column(
      children: <Widget>[
        precoInput(),
        salvarButton(),
      ],
    );
  }

  Widget combustivelDropButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: RoundedShape(
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: DropdownButton<String>(
          value: _tipoCombustivel,
          underline: SizedBox(),
          style: Theme.of(context).textTheme.body2,
          isExpanded: true,
          hint: Text(
            "Combustível",
            style: Theme.of(context).textTheme.body2,
          ),
          items: [
            DropdownMenuItem(
              value: "Gasolina",
              child: Center(
                child: Text(
                  "Gasolina",
                ),
              ),
            ),
            DropdownMenuItem(
              value: "Álcool",
              child: Center(
                child: Text(
                  "Álcool",
                ),
              ),
            ),
          ],
          onChanged: (value) {
            setState(() => _tipoCombustivel = value);
          },
        ),
      ),
    );
  }

  Widget _showForm() {
    return Container(
      padding: EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: currentGasto == null ? Container() : currentGasto,
      ),
    );
  }

  Widget salvarButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: PrimaryButton(
        text: SALVAR,
        onPressed: salvarGasto,
      ),
    );
  }

  Widget produtoInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextFormField(
        textAlign: TextAlign.center,
        maxLines: 1,
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.body2,
        controller: _controllerProduto,
        decoration: InputDecoration(
          labelText: "Produto",
          labelStyle: Theme.of(context).textTheme.body2,
          //hintText: "",
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
        validator: (value) => value.isEmpty ? EMAIL_INVALIDO : null,
        //onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget quantidadeInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: TextFormField(
        textAlign: TextAlign.center,
        maxLines: 1,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.body2,
        controller: _controllerQuantidade,
        decoration: InputDecoration(
          labelText: "Quantidade",
          labelStyle: Theme.of(context).textTheme.body2,
          //hintText: "",
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
        validator: (value) => value.isEmpty ? EMAIL_INVALIDO : null,
        //onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget precoInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        style: Theme.of(context).textTheme.body2,
        textCapitalization: TextCapitalization.words,
        controller: _controllerPreco,
        decoration: InputDecoration(
          labelText: "Preço",
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
        validator: (value) => value.isEmpty ? DIGITE_NUMERO_TELEFONE : null,
        //onSaved: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  Widget litrosInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 16.0, 0.0, 0.0),
      child: TextFormField(
        textAlign: TextAlign.center,
        maxLines: 1,
        keyboardType: TextInputType.phone,
        style: Theme.of(context).textTheme.body2,
        textCapitalization: TextCapitalization.words,
        controller: _controllerLitros,
        decoration: InputDecoration(
          labelText: "Litros",
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
        validator: (value) => value.isEmpty ? DIGITE_NUMERO_TELEFONE : null,
        //onSaved: (value) => _phoneNumber = value.trim(),
      ),
    );
  }

  void salvarGasto() {
    if (_tipoGasto == GastoType.COMBUSTIVEL.toString().split(".").last) {
      salvarGastoCombustivel();
    } else if (_tipoGasto == GastoType.MANUTENCAO.toString().split(".").last) {
      salvarGastoManutencao();
    } else if (_tipoGasto == GastoType.PRODUTO.toString().split(".").last) {
      salvarGastoProduto();
    } else if (_tipoGasto == GastoType.REVISAO.toString().split(".").last) {
      salvarGastoRevisao();
    }
  }

  void salvarGastoCombustivel() {
    Fuel combustivel = Fuel();
    combustivel.combustivel = _tipoCombustivel;
    combustivel.litros = _controllerLitros.numberValue;
    combustivel.total = _controllerPreco.numberValue;
    combustivel.data = DateTime.now();

    presenter.addDespesa(widget.month, combustivel);
  }

  void salvarGastoManutencao() {
    Maintenance maintenance = Maintenance();
    maintenance.total = _controllerPreco.numberValue;
    maintenance.data = DateTime.now();

    presenter.addDespesa(widget.month, maintenance);
  }

  void salvarGastoProduto() {
    Item item = Item();
    item.total = _controllerPreco.numberValue;

    presenter.addDespesa(widget.month, item);
  }

  void salvarGastoRevisao() {
    Review review = Review();
    review.total = _controllerPreco.numberValue;

    presenter.addDespesa(widget.month, review);
  }

}