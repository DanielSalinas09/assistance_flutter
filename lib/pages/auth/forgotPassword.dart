import 'package:assistance_flutter/providers/forgot_password.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotpasswordPage extends StatelessWidget {
  ForgotpasswordPage({super.key});

  final TextEditingController _dniController =
      TextEditingController();
  final TextEditingController _emailController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
              const Text('Restablecer tu contraseña',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Para restablecer tu contraseña, sigue las instrucciones y completa los campos indicados',
                style: const TextStyle(
                  fontSize: 15,
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
                    // Campo para el DNI
                    const Text(
                      'Documento de identificacion',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _dniController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Ej: 100xxxxxxx',
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
                    const Text(
                      'Correo electronico',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Ej: example@example.com',
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

                    Consumer<ForgotPasswordProvider>(
                        builder: (context, authProvider, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final response = await authProvider.validateUser(
                                _dniController.text,
                                _emailController.text,
                              );

                              if (response.isNotEmpty) {
                                showValidatePhone(context, response);
                              } else {
                                showError(context, authProvider.errorMessage,false);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEB1A0B),
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: authProvider.isLoadingValidateUser
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
                                  'Validar información',
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

  Future<void> showValidatePhone(
      BuildContext context, List<dynamic> phones) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Consumer<ForgotPasswordProvider>(
            builder: (context, authProvider, child) {
          return AlertDialog(
            title: const Center(child: Text('Seleccione su telefono')),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Para verificar su identidad, seleccione el número de teléfono correcto de la lista.',
                    textAlign: TextAlign.justify,
                  ),
                  ...phones.map((option) {
                    return RadioListTile<String>(
                      value: option,
                      groupValue: authProvider.selectedPhone,
                      onChanged: (String? value) {
                        if (value != null) {
                          authProvider.selectPhone(value);
                        }
                      },
                      title: Text('$option'),
                    );
                  })
                ],
              ),
            ),
            actions: <Widget>[
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB1A0B),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: authProvider.isLoadingValidatePhone
                      ? null
                      : () async {
                          final forgotPasswordProvider =
                              Provider.of<ForgotPasswordProvider>(context,
                                  listen: false);
                          final response =
                              await forgotPasswordProvider.validatePhone();
                          if (response) {
                            Navigator.pushNamed(
                                context, '/confirm-forgot-password');
                          } else {
                            showError(context,
                                forgotPasswordProvider.errorMessagePhone,true);
                          }
                        },
                  child: authProvider.isLoadingValidatePhone
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Validar',style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> showError(BuildContext context, String message,bool pagePrevious ) async {
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
                  if(pagePrevious){
                    Navigator.of(context).pop();
                  }
                },
              ),
            ]);
      },
    );
  }
}
