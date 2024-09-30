import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/repositories/get_address_by_cep/get_address_by_cep_repository.dart';
import 'package:desafio_flutter/app/domain/usecases/get_address_by_cep/get_address_by_cep_usecase.dart';

class GetAddressByCepImpUsecase implements GetAddressByCepUsecase {
  final GetAddressByCepRepository _addressByCepRepository;

  GetAddressByCepImpUsecase(this._addressByCepRepository);

  @override
  Future<AddressDto?> call(String cep) async {
    return await _addressByCepRepository(cep);
  }
}
