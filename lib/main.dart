import 'package:assistance_flutter/pages/auth/confirmForgotPassword.dart';
import 'package:assistance_flutter/pages/auth/forgotPassword.dart';
import 'package:assistance_flutter/pages/home/home.dart';
import 'package:assistance_flutter/pages/auth/login.dart';
import 'package:assistance_flutter/pages/support_contact/support_contact.dart';
import 'package:assistance_flutter/pages/terms_conditions.dart/terms_conditions.dart';
import 'package:assistance_flutter/pages/update_password/update_password.dart';
import 'package:assistance_flutter/providers/assistance_provider.dart';
import 'package:assistance_flutter/providers/contact_support_provider.dart';
import 'package:assistance_flutter/providers/forgot_password.dart';
import 'package:assistance_flutter/providers/shedule_prodiver.dart';
import 'package:assistance_flutter/providers/auth_provider.dart';
import 'package:assistance_flutter/providers/update_password_provider.dart';
import 'package:assistance_flutter/services/persistent_storage_service.dart';
import 'package:assistance_flutter/splash_screend.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/scanner/scanner.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferencesUser();
  await prefs.initPrefs();
  runApp(
     const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AssistanceProvider()),
        ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
         ChangeNotifierProvider(create: (context) => ScheduleProviderModel()),
         ChangeNotifierProvider(create: (context) => ContactSupportProvider()),
         ChangeNotifierProvider(create: (context) => UpdatePasswordProvider()),
      ],
      child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => LoginPage(),
        '/forgot-password': (context) => ForgotpasswordPage(),
        '/confirm-forgot-password': (context) => ConfirmForgotPasswordPage(),
        '/home': (context) => const HomePage(),
        '/scanner': (context) => const ScannerPage(),
        '/terms': (context) =>  const TermsAndConditionsPage(),
        '/support': (context) =>  const SupportAndContactPage(),
        '/update-password': (context) =>  UpdatePasswordPage(),
      },
    ));
  }
}
