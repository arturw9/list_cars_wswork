import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:list_cars_wswork/service/car.service.dart';
import '../../model/car.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CarView extends StatefulWidget {
  final String email;
  final String password;

  const CarView({Key? key, required this.email, required this.password})
      : super(key: key);

  @override
  _CarListState createState() => _CarListState();
}

class _CarListState extends State<CarView> {
  final CarService _carService = CarService();
  late Database _database;

  late Future<List<Car>> _carsFuture;

  @override
  void initState() {
    super.initState();
    _initDatabase();
    _carsFuture = _carService.getCars();

    Timer.periodic(Duration(seconds: 10), (timer) {
      _sendDataToServer();
    });
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'car_database.db'),
      onCreate: (db, version) {
        db.execute(
          'CREATE TABLE cars(id INTEGER PRIMARY KEY, timestamp_cadastro INTEGER, modelo_id INTEGER, ano INTEGER, combustivel TEXT, num_portas INTEGER, cor TEXT, nome_modelo TEXT, valor REAL)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS cars');
        await db.execute(
            'CREATE TABLE cars(id INTEGER PRIMARY KEY, timestamp_cadastro INTEGER, modelo_id INTEGER, ano INTEGER, combustivel TEXT, num_portas INTEGER, cor TEXT, nome_modelo TEXT, valor REAL)');
      },
      version: 2,
    );
  }

  Future<void> _insertCar(Car car) async {
    await _database.insert(
      'cars',
      car.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _sendDataToServer() async {
    // Preenche os campos aleatoriamente
    final Random random = Random();
    final Car randomCar = Car(
      id: random.nextInt(1000),
      timestampCadastro: DateTime.now().millisecondsSinceEpoch,
      modeloId: random.nextInt(10),
      ano: 2020 + random.nextInt(5),
      combustivel: ['Gasolina', 'Álcool', 'Diesel', 'Flex'][random.nextInt(4)],
      numPortas: 2 + random.nextInt(3),
      cor: ['Vermelho', 'Azul', 'Preto', 'Branco'][random.nextInt(4)],
      nomeModelo: 'Modelo ${random.nextInt(100)}',
      valor: 20000 + random.nextInt(80000).toDouble(),
      comprador: "",
    );

    // Rotina de tempos em tempos para fazer os post de leads na URL
    final url = Uri.parse('https://www.wswork.com.br/cars/leads/');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(randomCar.toMap()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Lista de Carros')),
      ),
      body: FutureBuilder<List<Car>>(
        future: _carsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final car = snapshot.data![index];
                car.comprador = widget.email;
                return ListTile(
                  title: Text(car.nomeModelo),
                  subtitle: Text('Ano: ${car.ano}, Valor: ${car.valor}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          _insertCar(car);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Sucesso"),
                                content: Text(
                                    "Registo de compra do ${car.nomeModelo} feito com sucesso por ${car.comprador}"),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text("Fechar"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Eu quero'),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
