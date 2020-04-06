import 'package:moto/contract/base_result_contract.dart';
import 'package:moto/services/crud.dart';

abstract class DespesasContractView implements BaseResultContract<dynamic> {

}

abstract class DespesasContractPresenter extends DespesasContractService {

}

abstract class DespesasContractService extends Crud<dynamic> {

}