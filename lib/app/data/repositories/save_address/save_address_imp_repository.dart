import 'package:desafio_flutter/app/data/datasources/save_address/save_address_datasource.dart';
import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/repositories/save_address/save_address_repository.dart';
import 'package:desafio_flutter/shared/exceptions/custom_exception.dart';
import 'package:desafio_flutter/shared/loggers/logger.dart';

class SaveAddressImpRepository implements SaveAddressRepository {
  final SaveAddressDatasource _addressDatasource;

  SaveAddressImpRepository(this._addressDatasource);

  @override
  Future<void> call(AddressDto address) async {
    try {
      return await _addressDatasource(address);
    } on CustomException catch (e) {
      appLog(e.message);
      rethrow;
    } catch (e) {
      appLog(e);
      throw CustomException(title: "Ocorreu um erro ao salvar o endereço!");
    }
  }
}
