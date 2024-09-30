import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppRouters {
  static goToSaveLocationPage(AddressDto selectedAddress) {
    return Modular.to.pushNamed(
      '/saveLocation',
      arguments: {
        'selectedAddress': selectedAddress,
      },
    );
  }

  static void pop<T extends Object>([T? result]) {
    if (result != null) {
      Modular.to.pop(result);
      return;
    }

    Modular.to.pop();
  }

  AppRouters._();
}
