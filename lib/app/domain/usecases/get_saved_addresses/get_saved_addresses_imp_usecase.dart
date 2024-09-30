import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/repositories/get_saved_addresses/get_saved_addresses_repository.dart';
import 'package:desafio_flutter/app/domain/usecases/get_saved_addresses/get_saved_addresses_usecase.dart';

class GetSavedAddressesImpUsecase implements GetSavedAddressesUsecase {
  final GetSavedAddressesRepository _addressesRepository;

  GetSavedAddressesImpUsecase(this._addressesRepository);

  @override
  Future<List<AddressDto>> call() async {
    return await _addressesRepository();
  }
}
