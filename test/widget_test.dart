import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:ventas_autos/models/vehiculo.dart';
import 'package:ventas_autos/providers/cart_provider.dart';
import 'package:ventas_autos/screens/home_screen.dart';
import 'package:ventas_autos/screens/cart_screen.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('Prueba de la pantalla principal', () {
    testWidgets(
        'Probar si los vehículos se listan y se pueden agregar al carrito',
        (WidgetTester tester) async {
      final mockClient = MockClient();

      when(mockClient.get(Uri.parse('http://18.116.28.65:3001/vehiculos')))
          .thenAnswer((_) async => http.Response(
              '[{"id_vehiculo": 1, "vehiculoNombre": "Car 1", "proveedorNombre": "Provider 1", "anio": 2020, "tipo_combustible": "Gasoline", "num_puertas": "4", "color": "Red", "precio": "10000", "imagen": "https://via.placeholder.com/150"}]',
              200));

      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: HomeScreen(),
          ),
        ),
      );

      // Esperar a que se cargue la lista de vehículos
      await tester.pumpAndSettle();

      // Verificar si el nombre del vehículo se muestra en la lista
      expect(find.text('Car 1'), findsOneWidget);

      // Tocar el botón "Comprar" para agregar al carrito
      await tester.tap(find.text('Comprar'));
      await tester.pump();

      // Verificar si el artículo se agregó al carrito
      expect(find.text('Car 1 agregado al carrito'), findsOneWidget);
    });
  });

  group('Prueba de la pantalla de carrito', () {
    testWidgets(
        'Probar si los artículos en el carrito y el precio total se muestran',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: MaterialApp(
            home: CartScreen(),
          ),
        ),
      );

      // Agregar un artículo al carrito
      Provider.of<CartProvider>(tester.element(find.byType(CartScreen)),
              listen: false)
          .addToCart(
        Vehiculo(
          idVehiculo: 1,
          vehiculoNombre: "Car 1",
          proveedorNombre: "Provider 1",
          idProveedor: 123, // Agregado el idProveedor
          anio: 2020,
          tipoCombustible: "Gasoline",
          numPuertas: "4",
          color: "Red",
          precio: 10000,
          imagen: "https://via.placeholder.com/150",
          tipo: "Sedan", // Asegurarse de pasar el argumento 'tipo'
        ),
      );

      await tester.pump();

      // Verificar si se muestra el precio total
      expect(find.text('Total: \$10000.00'), findsOneWidget);

      // Tocar el botón "Pagar"
      await tester.tap(find.text('Pagar'));
      await tester.pump();

      // Verificar si el carrito fue vaciado
      expect(find.text('El carrito está vacío'), findsOneWidget);
    });
  });
}
