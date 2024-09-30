import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressDto {
  final String? cep;
  final String? address;
  final int? number;
  final String? complement;
  final LatLng? latLng;
  AddressDto({
    this.cep,
    this.address,
    this.number,
    this.complement,
    this.latLng,
  });

  AddressDto copyWith({
    String? cep,
    String? address,
    int? number,
    String? complement,
    LatLng? latLng,
  }) {
    return AddressDto(
      cep: cep ?? this.cep,
      address: address ?? this.address,
      number: number ?? this.number,
      complement: complement ?? this.complement,
      latLng: latLng ?? this.latLng,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (cep != null) {
      result.addAll({'cep': cep});
    }
    if (address != null) {
      result.addAll({'address': address});
    }
    if (number != null) {
      result.addAll({'number': number});
    }
    if (complement != null) {
      result.addAll({'complement': complement});
    }
    if (latLng != null) {
      result.addAll({
        'latLng': {
          'latitude': latLng!.latitude,
          'longitude': latLng!.longitude,
        }
      });
    }

    return result;
  }

  factory AddressDto.fromMap(Map<String, dynamic> map) {
    return AddressDto(
      cep: map['cep'],
      address: map['address'],
      number: map['number']?.toInt(),
      complement: map['complement'],
      latLng: map['latLng'] != null
          ? LatLng(
              map['latLng']['latitude'],
              map['latLng']['longitude'],
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressDto.fromJson(String source) =>
      AddressDto.fromMap(json.decode(source));

  @override
  String toString() {
    return 'AddressDto(cep: $cep, address: $address, number: $number, complement: $complement, latLng: $latLng)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AddressDto &&
        other.cep == cep &&
        other.address == address &&
        other.number == number &&
        other.complement == complement &&
        other.latLng == latLng;
  }

  @override
  int get hashCode {
    return cep.hashCode ^
        address.hashCode ^
        number.hashCode ^
        complement.hashCode ^
        latLng.hashCode;
  }
}
