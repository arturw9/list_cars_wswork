import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/car.dart';

class CarService {
  Future<List<Car>> getCars() async {
    final response =
        await http.get(Uri.parse('https://wswork.com.br/cars.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['cars'];
      return jsonData.map((json) => Car.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load cars');
    }
  }
}
