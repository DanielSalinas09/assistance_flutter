

import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {


  const TermsAndConditionsPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Términos y Condiciones'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Términos y Condiciones',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                '1. Introducción',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Bienvenido a la aplicación de toma de asistencia por QR de la Universidad Libre. '
                'Al usar esta aplicación, aceptas cumplir con estos términos y condiciones. '
                'Por favor, léelos detenidamente antes de usar la aplicación.',
              ),
              SizedBox(height: 20),
              Text(
                '2. Uso de la Aplicación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'La aplicación está diseñada para facilitar la toma de asistencia en la Universidad Libre. '
                'Los usuarios pueden escanear códigos QR generados por los profesores para registrar su asistencia.',
              ),
              SizedBox(height: 20),
              Text(
                '3. Privacidad y Seguridad',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Nos comprometemos a proteger tu privacidad y la seguridad de tus datos personales. '
                'La información recolectada a través de la aplicación se utilizará únicamente para fines relacionados con la asistencia y no será compartida con terceros sin tu consentimiento.',
              ),
              SizedBox(height: 20),
              Text(
                '4. Responsabilidades del Usuario',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Como usuario, eres responsable de la veracidad de la información proporcionada y del uso adecuado de la aplicación. '
                'Cualquier intento de manipulación o uso indebido de la aplicación será sancionado de acuerdo con las políticas de la Universidad.',
              ),
              SizedBox(height: 20),
              Text(
                '5. Modificaciones a los Términos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Nos reservamos el derecho de modificar estos términos y condiciones en cualquier momento. '
                'Las modificaciones serán efectivas una vez publicadas en la aplicación. '
                'Es tu responsabilidad revisar regularmente los términos y condiciones para estar al tanto de cualquier cambio.',
              ),
              SizedBox(height: 20),
              Text(
                '6. Contacto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Si tienes alguna pregunta o inquietud sobre estos términos y condiciones, por favor contacta al soporte de la Universidad Libre.',
              ),
              SizedBox(height: 20),
              Text(
                'Fecha de última actualización: 6 de agosto de 2024',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}