import 'package:assistance_flutter/providers/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmForgotPasswordPage extends StatelessWidget {
  ConfirmForgotPasswordPage({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final confirmForgotPasswordProvider =
        Provider.of<ForgotPasswordProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/unilibre.png',
                height: 150, // Ajusta el tamaño según sea necesario
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 40,
              ),
              const Text('Confirmar contraseña',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Tu identidad ha sido verificada, por favor rellena los campos y recuerda que no puedes colocar una contraseña ya usada.',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Nueva contraseña',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText:
                          confirmForgotPasswordProvider.isPasswordVisible,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa una contraseña.';
                        } else if (value.length < 6) {
                          return 'La contraseña debe tener mínimo 6 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),

                    // Campo para el correo
                    const Text(
                      'Confirmar contraseña',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: confirmForgotPasswordProvider
                          .isConfirmPasswordVisible,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor confirma tu contraseña';
                        } else if (value != _passwordController.text) {
                          return 'Las contraseñas no coinciden';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32.0),

                    // Botón de enviar
                    Consumer<ForgotPasswordProvider>(
                        builder: (context, authProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              
                              final response = await authProvider.changePassword(_passwordController.text,_confirmPasswordController.text);
                              if(response){
                                ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Contraseña cambiada correctamente.')),
                              );
                              Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/login',
                                            (Route<dynamic> route) => false);
                              }else{
                                showError(context,authProvider.errorMessagechangePassword);
                              }
                              
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEB1A0B),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child:authProvider.isLoadingForgotPassword 
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
                                  'Enviar',
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      );
                    })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> showError(BuildContext context, String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Center(
                child: Text(
              '¡Información!',
              textAlign: TextAlign.center,
              style: TextStyle(),
            )),
            content: SingleChildScrollView(
              child: ListBody(children: <Widget>[
                Text(message),
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
      },
    );
  }
}
