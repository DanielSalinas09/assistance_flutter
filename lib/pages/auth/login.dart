import 'dart:developer';

import 'package:assistance_flutter/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final response = await authProvider.canUseFingerprintLogin();
      if (response) {
        signInFingerprint(context);
      }
    });

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: this._formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  'assets/unilibre.png',
                  height: 150, // Ajusta el tamaño según sea necesario
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 40),
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    //color: Colors.grey
                  ),
                ),
                const SizedBox(height: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Usuario',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _usernameController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 5) {
                          return 'Por favor ingresa su DNI';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Contraseña',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: authProvider.visibilityPassword,
                        decoration:  InputDecoration(
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                          icon: Icon(
                            authProvider.visibilityPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            authProvider.toggleVisibility();
                          },
                        ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor ingresa tu contraseña';
                          } else if (value.length < 6) {
                            return 'La contraseña debe tener minimo 6 caracteres';
                          }
                          return null;
                        },
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 30),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: authProvider.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      final response = await authProvider.login(
                                        _usernameController.text,
                                        _passwordController.text,
                                      );
                                      if (response) {
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/home',
                                            (Route<dynamic> route) => false);
                                      } else {
                                        errorFingerprint(context);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEB1A0B),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: authProvider.isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'Iniciar sesión',
                                    style: TextStyle(color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/forgot-password');
                          },
                          child: const Text(
                            '¿Has olvidado tu contraseña?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        const SizedBox(height: 30),
                        IconButton(
                            onPressed: () async {
                              final authProvider = Provider.of<AuthProvider>(
                                  context,
                                  listen: false);
                              final response =
                                  await authProvider.canUseFingerprintLogin();
                              if (response) {
                                signInFingerprint(context);
                              } else {
                                errorFingerprint(context);
                              }
                            },
                            iconSize: 50,
                            icon: Icon(Icons.fingerprint)),
                        const Text(
                          'Ingresa con huella',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('¡Error al iniciar sesión!')),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Ha ocuurido un error al iniciar sesion, por favor intente nuevamente'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signInFingerprint(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                authProvider.isLoadingFingerprint
                    ? const Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.red),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          )
                        ],
                      )
                    : const Icon(
                        Icons.fingerprint,
                        size: 90,
                      ),
                const Text(
                  'Verifica tu huella digital',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Color(0xFFEB1A0B)),
                    ))
              ],
            ),
          );
        });
      },
    );
    final response = await authProvider.authenticateWithFingerprint();
    log("RESPUESTA: $response");
    if (response) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    } else {
      errorFingerprint(context);
    }
  }

  Future<void> errorFingerprint(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer<AuthProvider>(builder: (context, authProvider, child) {
          return AlertDialog(
              title: const Center(
                  child: Text(
                '¡Información de Inicio de Sesión!',
                textAlign: TextAlign.center,
                style: TextStyle(),
              )),
              content: SingleChildScrollView(
                child: ListBody(children: <Widget>[
                  Text(authProvider.errorMessage),
                ]),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Aceptar',
                    style: TextStyle(
                      color: const Color(0xFFEB1A0B),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ]);
        });
      },
    );
  }
}
