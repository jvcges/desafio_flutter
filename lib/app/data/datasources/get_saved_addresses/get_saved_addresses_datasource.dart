import 'package:desafio_flutter/app/domain/models/address_dto.dart';

abstract class GetSavedAddressesDatasource {
  Future<List<AddressDto>> call();
}
