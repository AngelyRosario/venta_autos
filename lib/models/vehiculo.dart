class Vehiculo {
  final int idVehiculo;
  final String vehiculoNombre;
  final int idProveedor; // Agregado de la primera clase
  final String proveedorNombre;
  final int anio;
  final String tipoCombustible;
  final String numPuertas;
  final String color;
  final double precio; // Cambiado a double
  final String tipo; // Agregado de la primera clase
  final String imagen;

  // Constructor
  Vehiculo({
    required this.idVehiculo,
    required this.vehiculoNombre,
    required this.idProveedor, // Agregado de la primera clase
    required this.proveedorNombre,
    required this.anio,
    required this.tipoCombustible,
    required this.numPuertas,
    required this.color,
    required this.precio, // Cambiado a double
    required this.tipo, // Agregado de la primera clase
    required this.imagen,
  });

  // Método para crear un objeto Vehiculo desde JSON
  factory Vehiculo.fromJson(Map<String, dynamic> json) {
    return Vehiculo(
      idVehiculo: json['id_vehiculo'],
      vehiculoNombre: json['vehiculoNombre'],
      idProveedor: json['id_proveedor'], // Agregado de la primera clase
      proveedorNombre: json['proveedorNombre'],
      anio: json['anio'],
      tipoCombustible: json['tipo_combustible'],
      numPuertas: json['num_puertas'],
      color: json['color'],
      precio: double.parse(json['precio'].toString()), // Cambiado a double
      tipo: json['tipo'], // Agregado de la primera clase
      imagen: json['imagen'],
    );
  }
}
