import 'package:desafio_flutter/app/data/datasources/get_address_by_cep/get_address_by_cep_datasource.dart';
import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/app/domain/models/via_cep_dto.dart';
import 'package:desafio_flutter/core/Services/client_https/via_cep/via_cep_client_https.dart';

class GetAddressByCepImpDatasource implements GetAddressByCepDatasource {
  final ViaCepClientHttps _clientHttps;

  GetAddressByCepImpDatasource(this._clientHttps);

  @override
  Future<AddressDto?> call(String cep) async {
    final result = await _clientHttps.get('$cep/json');

    if (result.data == null) return null;

    final viaCepDto = ViaCepDto.fromMap(result.data);

    return viaCepDto.toAddressDto();
  }
}
