import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/repositories/save_address/save_address_repository.dart';
import 'package:desafio_flutter/app/domain/usecases/save_address/save_address_usecase.dart';

class SaveAddressImpUsecase implements SaveAddressUsecase {
  final SaveAddressRepository _saveAddressRepository;

  SaveAddressImpUsecase(this._saveAddressRepository);

  @override
  Future<void> call(AddressDto address) async {
    return await _saveAddressRepository(address);
  }
}
