import 'package:moto/contract/base_result_contract.dart';
import 'package:moto/model/base_model.dart';
import 'package:moto/model/gasto.dart';
import 'package:moto/model/month.dart';
import 'package:moto/services/crud.dart';

abstract class MonthContractView implements BaseResultContract<Month> {

}

abstract class MonthContractPresenter extends MonthContractService {

}

abstract class MonthContractService extends Crud<Month> {
  Future<dynamic> addDespesa(Month month, dynamic item);
  Future<dynamic> deleteDespesa(Month month, BaseModel gasto);
  Future<List<dynamic>> listDespesas(Month month);
}