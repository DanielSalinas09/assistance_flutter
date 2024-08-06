import 'package:assistance_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    bool isAuthenticated = await authProvider.checkUserSession();
    _navigateToNextPage(isAuthenticated);
  }

  void _navigateToNextPage(bool isAuthenticated) {
    if (isAuthenticated) {
      Navigator.pushNamedAndRemoveUntil(
        context, '/home', (Route<dynamic> route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const SizedBox(height:30),
            Image.asset(
              'assets/unilibre.png',
              height: 200, // Ajusta el tamaño según sea necesario
              fit: BoxFit.cover,
            ),
            const Spacer(),
            const CircularProgressIndicator(
              strokeWidth: 3.0,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEB1A0B)),
            ),
            const SizedBox(height: 40,)
          ],
        ),
      ),
    );
  }
}