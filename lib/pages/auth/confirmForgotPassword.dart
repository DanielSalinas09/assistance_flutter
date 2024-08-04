

import 'package:assistance_flutter/providers/confirm_forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmForgotPasswordPage extends StatelessWidget {
  ConfirmForgotPasswordPage({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final confirmForgotPasswordProvider = Provider.of<ConfirmForgotPasswordProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmar Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo para la nueva contraseña
              TextFormField(
                controller: _passwordController,
                obscureText: confirmForgotPasswordProvider.isPasswordVisible,
                decoration: const InputDecoration(
                  labelText: 'Nueva Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una contraseña';
                  } else if (value.length < 6) {
                    return 'La contraseña debe tener mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              
              // Campo para confirmar la contraseña
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: confirmForgotPasswordProvider.isConfirmPasswordVisible,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Contraseña',
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Procesar la confirmación de la contraseña
                    // Aquí puedes agregar el código para enviar los datos
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Contraseña confirmada')),
                    );
                  }
                },
                child: const Text('Confirmar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}