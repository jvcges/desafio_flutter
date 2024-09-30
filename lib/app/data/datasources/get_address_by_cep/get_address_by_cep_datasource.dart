import 'package:desafio_flutter/app/domain/models/address_dto.dart';

abstract class GetAddressByCepDatasource {
  Future<AddressDto?> call(String cep);
}
