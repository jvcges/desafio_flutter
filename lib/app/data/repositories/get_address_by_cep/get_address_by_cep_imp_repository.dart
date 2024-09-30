import 'package:desafio_flutter/app/data/datasources/get_address_by_cep/get_address_by_cep_datasource.dart';
import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/repositories/get_address_by_cep/get_address_by_cep_repository.dart';
import 'package:desafio_flutter/shared/exceptions/custom_exception.dart';
import 'package:desafio_flutter/shared/loggers/logger.dart';

class GetAddressByCepImpRepository implements GetAddressByCepRepository {
  final GetAddressByCepDatasource _addressByCepDatasource;

  GetAddressByCepImpRepository(this._addressByCepDatasource);

  @override
  Future<AddressDto?> call(String cep) async {
    try {
      return await _addressByCepDatasource(cep);
    } on CustomException catch (e) {
      appLog(e.message);
      rethrow;
    } catch (e) {
      appLog(e);
      throw CustomException(title: "Ocorreu um erro ao buscar o endereço!");
    }
  }
}
