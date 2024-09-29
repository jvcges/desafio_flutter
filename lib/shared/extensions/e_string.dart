extension EString on String {
  String justNumbers() => replaceAll(RegExp("[^0-9]"), "");
}
