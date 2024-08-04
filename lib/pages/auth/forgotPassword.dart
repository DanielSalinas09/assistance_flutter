
import 'package:flutter/material.dart';

class ForgotpasswordPage extends StatelessWidget {
  ForgotpasswordPage({super.key});

  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Restablecer Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Campo para el DNI
              TextFormField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'DNI',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu DNI';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              
              // Campo para el correo
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo electrónico';
                  } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Por favor ingresa un correo electrónico válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              
              // Botón de enviar
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Procesar la solicitud de restablecimiento de contraseña
                    // Aquí puedes agregar el código para enviar los datos
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Procesando...')),
                    );
                    Navigator.pushNamed(context, '/confirm-forgot-password');
                  }
                },
                child: const Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}