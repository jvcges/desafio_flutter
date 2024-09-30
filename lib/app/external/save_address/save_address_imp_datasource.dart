import 'package:desafio_flutter/app/data/datasources/save_address/save_address_datasource.dart';
import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveAddressImpDatasource implements SaveAddressDatasource {
  @override
  Future<void> call(AddressDto address) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String addressJson = address.toJson();
    final list = preferences.getStringList('savedLocations');

    if (list != null) {
      int existingIndex = list.indexWhere((element) {
        AddressDto existingAddress = AddressDto.fromJson(element);
        return existingAddress.cep == address.cep;
      });

      if (existingIndex != -1) {
        list[existingIndex] = addressJson;
      } else {
        list.insert(0, addressJson);
      }
      await preferences.setStringList('savedLocations', list);
    } else {
      await preferences.setStringList('savedLocations', [addressJson]);
    }
  }
}
