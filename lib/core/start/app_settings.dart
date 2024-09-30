import 'package:flutter_modular/flutter_modular.dart';

class AppSettings {
  static Future<void> init({
    required Module module,
  }) async {
    Modular.init(module);

    Modular.setInitialRoute('/');
  }
}
