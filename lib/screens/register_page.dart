import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat(reverse: true); // Hace que la animación se repita.

    _animation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Registro de Usuario',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Fondo blanco
          Container(
            color: Colors.white,
          ),
          // Contenido principal
          SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.shade100,
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person_add,
                      color: Colors.blueAccent,
                      size: 100,
                    ),
                  ),
                ),
                SizedBox(height: 30.0),
                _buildTextField(
                  controller: _nameController,
                  hintText: 'Nombre completo',
                  icon: Icons.person,
                  fillColor: Colors.white,
                  borderColor: Colors.blueAccent,
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                  controller: _emailController,
                  hintText: 'Correo electrónico',
                  icon: Icons.email,
                  fillColor: Colors.white,
                  borderColor: Colors.blueAccent,
                ),
                SizedBox(height: 20.0),
                _buildTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                  fillColor: Colors.white,
                  borderColor: Colors.blueAccent,
                ),
                SizedBox(height: 30.0),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Usuario registrado con éxito')),
                    );
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Registrar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 15.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Ola blanca al fondo con animación
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return ClipPath(
                  clipper: CustomWaveClipper(animationValue: _animation.value),
                  child: Container(
                    height: 100,
                    color: Colors.blueAccent,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    required Color fillColor,
    required Color borderColor,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: borderColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        filled: true,
        fillColor: fillColor,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
    );
  }
}

class CustomWaveClipper extends CustomClipper<Path> {
  final double animationValue;
  CustomWaveClipper({required this.animationValue});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50 + animationValue);
    path.quadraticBezierTo(
      size.width / 4,
      size.height + animationValue,
      size.width / 2,
      size.height - 50 + animationValue,
    );
    path.quadraticBezierTo(
      3 * size.width / 4,
      size.height - 100 + animationValue,
      size.width,
      size.height - 50 + animationValue,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true; // Reclip cada vez que cambia el valor de animación
  }
}
