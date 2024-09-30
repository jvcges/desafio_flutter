import 'package:desafio_flutter/app/data/datasources/get_saved_addresses/get_saved_addresses_datasource.dart';
import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/repositories/get_saved_addresses/get_saved_addresses_repository.dart';
import 'package:desafio_flutter/shared/exceptions/custom_exception.dart';
import 'package:desafio_flutter/shared/loggers/logger.dart';

class GetSavedAddressesImpRepository implements GetSavedAddressesRepository {
  final GetSavedAddressesDatasource _addressesDatasource;

  GetSavedAddressesImpRepository(this._addressesDatasource);

  @override
  Future<List<AddressDto>> call() async {
    try {
      return await _addressesDatasource();
    } on CustomException catch (e) {
      appLog(e.message);
      rethrow;
    } catch (e) {
      appLog(e);
      throw CustomException(title: "Ocorreu um erro ao salvar o endereço!");
    }
  }
}
