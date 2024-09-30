import 'dart:convert';

import 'package:desafio_flutter/app/domain/models/address_dto.dart';
import 'package:desafio_flutter/shared/exceptions/custom_exception.dart';

class ViaCepDto {
  final String? cep;
  final String? logradouro;
  final String? bairro;
  final String? localidade;
  final String? uf;
  ViaCepDto({
    this.cep,
    this.logradouro,
    this.bairro,
    this.localidade,
    this.uf,
  });

  ViaCepDto copyWith({
    String? cep,
    String? logradouro,
    String? bairro,
    String? localidade,
    String? uf,
  }) {
    return ViaCepDto(
      cep: cep ?? this.cep,
      logradouro: logradouro ?? this.logradouro,
      bairro: bairro ?? this.bairro,
      localidade: localidade ?? this.localidade,
      uf: uf ?? this.uf,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (cep != null) {
      result.addAll({'cep': cep});
    }
    if (logradouro != null) {
      result.addAll({'logradouro': logradouro});
    }
    if (bairro != null) {
      result.addAll({'bairro': bairro});
    }
    if (localidade != null) {
      result.addAll({'localidade': localidade});
    }
    if (uf != null) {
      result.addAll({'uf': uf});
    }

    return result;
  }

  AddressDto toAddressDto() {
    String address = '';
    if (cep == null) throw CustomException(title: "Erro ao buscar CEP!");
    if (logradouro != null) {
      address += logradouro!;
    }
    if (bairro != null) {
      if (address.isNotEmpty) {
        address += ' - ';
      }
      address += bairro!;
    }
    if (localidade != null) {
      if (address.isNotEmpty) {
        address += ', ';
      }
      address += localidade!;
    }
    if (uf != null) {
      if (address.isNotEmpty) {
        address += ' - ';
      }
      address += uf!;
    }

    return AddressDto(
      cep: cep,
      address: address,
    );
  }

  factory ViaCepDto.fromMap(Map<String, dynamic> map) {
    return ViaCepDto(
      cep: map['cep'],
      logradouro: map['logradouro'],
      bairro: map['bairro'],
      localidade: map['localidade'],
      uf: map['uf'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ViaCepDto.fromJson(String source) =>
      ViaCepDto.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ViaCepDto(cep: $cep, logradouro: $logradouro, bairro: $bairro, localidade: $localidade, uf: $uf)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ViaCepDto &&
        other.cep == cep &&
        other.logradouro == logradouro &&
        other.bairro == bairro &&
        other.localidade == localidade &&
        other.uf == uf;
  }

  @override
  int get hashCode {
    return cep.hashCode ^
        logradouro.hashCode ^
        bairro.hashCode ^
        localidade.hashCode ^
        uf.hashCode;
  }
}
