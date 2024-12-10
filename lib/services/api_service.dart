import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vehiculo.dart';

class ApiService {
  final String baseUrl = "http://18.116.28.65:3001/vehiculos";

  Future<List<Vehiculo>> fetchVehiculos() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Vehiculo.fromJson(json)).toList();
    } else {
      throw Exception("Error al cargar los vehículos");
    }
  }
}
