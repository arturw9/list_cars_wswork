import 'package:flutter/material.dart';

class Car {
  final int id;
  final int timestampCadastro;
  final int modeloId;
  final int ano;
  final String combustivel;
  final int numPortas;
  final String cor;
  final String nomeModelo;
  final double valor;
  String? comprador;

  Car({
    required this.id,
    required this.timestampCadastro,
    required this.modeloId,
    required this.ano,
    required this.combustivel,
    required this.numPortas,
    required this.cor,
    required this.nomeModelo,
    required this.valor,
    required this.comprador,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      timestampCadastro: json['timestamp_cadastro'],
      modeloId: json['modelo_id'],
      ano: json['ano'],
      combustivel: json['combustivel'],
      numPortas: json['num_portas'],
      cor: json['cor'],
      nomeModelo: json['nome_modelo'],
      valor: json['valor'].toDouble(),
      comprador: json['comprador'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp_cadastro': timestampCadastro,
      'modelo_id': modeloId,
      'ano': ano,
      'combustivel': combustivel,
      'num_portas': numPortas,
      'cor': cor,
      'nome_modelo': nomeModelo,
      'valor': valor,
    };
  }
}
