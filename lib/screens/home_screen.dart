import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../models/vehiculo.dart';
import 'cart_screen.dart';
import '../providers/cart_provider.dart';
import '../pages/avatar.dart'; // Importamos el perfil de usuario Avatar
import 'dart:convert'; // Importamos 'dart:convert' para usar json.decode()

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Vehiculo> vehiculos = [];
  List<Vehiculo> filteredVehiculos = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchVehiculos();
    searchController.addListener(() {
      filterVehiculos();
    });
  }

  Future<void> fetchVehiculos() async {
    final response =
        await http.get(Uri.parse('http://18.116.28.65:3001/vehiculos'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        vehiculos = data.map((json) => Vehiculo.fromJson(json)).toList();
        filteredVehiculos = vehiculos; // Inicializa la lista filtrada
      });
    } else {
      throw Exception('Error al cargar los vehículos');
    }
  }

  void filterVehiculos() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredVehiculos = vehiculos
          .where((vehiculo) =>
              vehiculo.vehiculoNombre.toLowerCase().contains(query) ||
              vehiculo.proveedorNombre.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lista de Vehículos',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: CircleAvatar(
            backgroundImage: NetworkImage('assets/images/capibara.png'),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Avatar()), // Navegar a Avatar
            );
          },
        ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar vehículos...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
          Expanded(
            child: filteredVehiculos.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredVehiculos.length,
                    itemBuilder: (context, index) {
                      final vehiculo = filteredVehiculos[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: EdgeInsets.all(15.0),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    vehiculo.imagen,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  vehiculo.vehiculoNombre,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${vehiculo.proveedorNombre}',
                                          style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 14)),
                                      SizedBox(height: 4),
                                      Text(
                                        '\$${vehiculo.precio.toStringAsFixed(2)}',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.visibility,
                                              color: Colors.white),
                                          SizedBox(width: 8),
                                          Text(
                                            'Ver detalle',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  Text(vehiculo.vehiculoNombre),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Proveedor: ${vehiculo.proveedorNombre}'),
                                                      Text(
                                                          'Año: ${vehiculo.anio}'),
                                                      Text(
                                                          'Tipo de combustible: ${vehiculo.tipoCombustible}'),
                                                      Text(
                                                          'Número de puertas: ${vehiculo.numPuertas}'),
                                                      Text(
                                                          'Color: ${vehiculo.color}'),
                                                      Text(
                                                          'Tipo: ${vehiculo.tipo}'),
                                                    ]),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(),
                                                    child: Text('Cerrar')),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20))),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.add_shopping_cart,
                                              color: Colors.white),
                                          SizedBox(width: 8),
                                          Text(
                                            'Añadir al carrito',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        final cartProvider =
                                            Provider.of<CartProvider>(context,
                                                listen: false);
                                        cartProvider.addToCart(vehiculo);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
