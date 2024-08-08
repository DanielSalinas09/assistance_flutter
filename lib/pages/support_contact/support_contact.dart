

import 'package:assistance_flutter/providers/auth_provider.dart';
import 'package:assistance_flutter/providers/contact_support_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SupportAndContactPage extends StatefulWidget {

  const SupportAndContactPage({super.key});
  @override
  _SupportAndContactPageState createState() => _SupportAndContactPageState();
}

class _SupportAndContactPageState extends State<SupportAndContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idController = TextEditingController();
  final _programController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _idController.dispose();
    _programController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        surfaceTintColor: Colors.grey[200],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Soporte y Contacto',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Nombre',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu nombre.';
                    }
                    return null;
                  },
                ),
                 const SizedBox(height: 8.0),
                const Text(
                  'Correo Electrónico',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu correo electrónico.';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Por favor ingresa un correo electrónico válido';
                    }
                    return null;
                  },
                ),
                 const SizedBox(height: 8.0),
                const Text(
                  'Número de Documento de Identidad',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _idController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu número de documento de identidad.';
                    }
                    return null;
                  },
                ),
                 const SizedBox(height: 8.0),
                const Text(
                  'Programa',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _programController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu programa.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Mensaje',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _messageController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa tu mensaje.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32.0),
                
                Consumer<ContactSupportProvider>(
                    builder: (context, contactProvider, child) {
                      return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: contactProvider.isLoading
                    ?null
                    :()async{
                      if (_formKey.currentState!.validate()) {
                          final contactSupportProvider = Provider.of<ContactSupportProvider>(context, listen: false);
                          final authProvider = Provider.of<AuthProvider>(context, listen: false);
                          final response = await contactSupportProvider.createSupport(_messageController.text, authProvider.user.id);

                            if(response){
                              // Aquí puedes manejar el envío del formulario, por ejemplo, enviarlo a un servidor
                              _clearForm();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Formulario enviado con éxito')),
                                );
                            }else{
                              showErrorDialog(context);
                            }
      
    }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEB1A0B),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child:contactProvider.isLoading
                    ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3.0,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : 
                     const Text(
                      'Enviar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
                    })
                
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> showErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('¡Error!')),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'La información no pudo ser enviada con éxito. 📤 Por favor, intenta nuevamente.'),
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

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _idController.clear();
    _programController.clear();
    _messageController.clear();
  }
}