import 'package:desafio_flutter/app/domain/models/address_dto.dart';

abstract class GetAddressByCepUsecase {
  Future<AddressDto?> call(String cep);
}
