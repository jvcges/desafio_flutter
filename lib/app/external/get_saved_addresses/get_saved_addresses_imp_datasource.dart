import 'package:desafio_flutter/app/data/datasources/get_saved_addresses/get_saved_addresses_datasource.dart';
import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/shared/loggers/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetSavedAddressesImpDatasource implements GetSavedAddressesDatasource {
  @override
  Future<List<AddressDto>> call() async {
    List<AddressDto> addressList = [];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final list = preferences.getStringList('savedLocations');
    if (list != null) {
      addressList = list.map((e) => AddressDto.fromJson(e)).toList();
    }
    appLog("LISTA SALVA");
    appLog(addressList);
    return addressList;
  }
}
