import 'package:desafio_flutter/app/domain/models/address_dto.dart';

abstract class GetSavedAddressesUsecase {
  Future<List<AddressDto>> call();
}
