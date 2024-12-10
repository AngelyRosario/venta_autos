import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'models/vehiculo.dart';
import 'providers/cart_provider.dart';
import 'screens/cart_screen.dart';
import 'pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Lista de Vehículos',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginPage(), // Pantalla de login inicial
      ),
    );
  }
}

// La pantalla HomeScreen que muestra los vehículos
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Vehiculo> vehiculos = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchVehiculos();
  }

  Future<void> fetchVehiculos() async {
    try {
      final response =
          await http.get(Uri.parse('http://18.116.28.65:3001/vehiculos'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          vehiculos = data.map((json) => Vehiculo.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error al cargar los vehículos';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'No se pudo conectar con el servidor';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Vehículos'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : vehiculos.isEmpty
                  ? Center(
                      child: Text(
                        'No hay vehículos disponibles',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : ListView.builder(
                      itemCount: vehiculos.length,
                      itemBuilder: (context, index) {
                        final vehiculo = vehiculos[index];
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: ListTile(
                            leading: Image.network(
                              vehiculo.imagen,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                return progress == null
                                    ? child
                                    : Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.error);
                              },
                            ),
                            title: Text(vehiculo.vehiculoNombre),
                            subtitle: Text(
                              '${vehiculo.proveedorNombre}\n\$${vehiculo.precio}',
                            ),
                            trailing: ElevatedButton(
                              child: Text('Comprar'),
                              onPressed: () {
                                Provider.of<CartProvider>(context,
                                        listen: false)
                                    .addToCart(vehiculo);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${vehiculo.vehiculoNombre} agregado al carrito'),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
