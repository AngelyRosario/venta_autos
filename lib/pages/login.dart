import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ventas_autos/screens/home_screen.dart'; // Asegúrate de tener esta ruta
import 'package:ventas_autos/screens/register_page.dart'; // Ruta para RegisterPage

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String defaultEmail = "example@gmail.com";
  final String defaultPassword = "123";
  bool isInvisible = true;
  late AnimationController _controller;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _waveAnimation = Tween<double>(begin: 0, end: 40).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void _login() {
    if (_emailController.text == defaultEmail &&
        _passwordController.text == defaultPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Inicio de sesión exitoso!')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciales incorrectas, inténtalo de nuevo')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  children: [
                    CustomPaint(
                      painter: WavePainter(
                        animationValue: _waveAnimation.value,
                        position: WavePosition.top,
                        color: Colors.lightBlue.withOpacity(0.8),
                      ),
                      child: Container(),
                    ),
                    CustomPaint(
                      painter: WavePainter(
                        animationValue: _waveAnimation.value,
                        position: WavePosition.top2,
                        color: Colors.blue.withOpacity(0.6),
                      ),
                      child: Container(),
                    ),
                    CustomPaint(
                      painter: WavePainter(
                        animationValue: _waveAnimation.value,
                        position: WavePosition.bottom,
                        color: Colors.blueAccent.withOpacity(0.6),
                      ),
                      child: Container(),
                    ),
                  ],
                );
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12.0,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: Image(
                            image: NetworkImage("assets/images/car.png"),
                            width: 90, // Logo más grande
                            height: 90, // Logo más grande
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Text(
                          "Iniciar sesión",
                          style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Correo electrónico",
                            prefixIcon: Icon(CupertinoIcons.mail),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextField(
                          controller: _passwordController,
                          obscureText: isInvisible,
                          decoration: InputDecoration(
                            hintText: "Contraseña",
                            prefixIcon: Icon(CupertinoIcons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isInvisible
                                    ? CupertinoIcons.eye_slash
                                    : CupertinoIcons.eye,
                              ),
                              onPressed: () {
                                setState(() {
                                  isInvisible = !isInvisible;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: ElevatedButton(
                            onPressed: _login,
                            child: Text(
                              "Iniciar sesión",
                              style: TextStyle(fontSize: 18),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .blueAccent, // Cambié 'primary' por 'backgroundColor'
                              foregroundColor: Colors
                                  .white, // Cambié 'onPrimary' por 'foregroundColor'
                              padding: EdgeInsets.symmetric(
                                horizontal: 60.0,
                                vertical: 15.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 10.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20.0),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterPage()),
                            );
                          },
                          child: Text(
                            '¿No tienes una cuenta? Regístrate aquí',
                            style: TextStyle(color: Colors.blueAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum WavePosition { top, top2, bottom }

class WavePainter extends CustomPainter {
  final double animationValue;
  final WavePosition position;
  final Color color;

  WavePainter({
    required this.animationValue,
    required this.position,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;

    Path path = Path();
    if (position == WavePosition.top || position == WavePosition.top2) {
      path
        ..moveTo(0, size.height * 0.10)
        ..quadraticBezierTo(
          size.width * 0.25,
          size.height * 0.10 - animationValue,
          size.width * 0.5,
          size.height * 0.10,
        )
        ..quadraticBezierTo(
          size.width * 0.75,
          size.height * 0.10 + animationValue,
          size.width,
          size.height * 0.10,
        )
        ..lineTo(size.width, 0)
        ..lineTo(0, 0)
        ..close();
    } else if (position == WavePosition.bottom) {
      path
        ..moveTo(0, size.height * 0.85)
        ..quadraticBezierTo(
          size.width * 0.25,
          size.height * 0.85 - animationValue * 1.5,
          size.width * 0.5,
          size.height * 0.85,
        )
        ..quadraticBezierTo(
          size.width * 0.75,
          size.height * 0.85 + animationValue * 1.5,
          size.width,
          size.height * 0.85,
        )
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
