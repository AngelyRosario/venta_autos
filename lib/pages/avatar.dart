import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('assets/images/capibara.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Usuario',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Información de Usuario',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Nombres: Capibara ',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Apellidos:  Liao Yue',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Comprador:  Premium',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
