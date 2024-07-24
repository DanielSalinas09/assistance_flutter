import 'package:assistance_flutter/pages/home/home.dart';
import 'package:assistance_flutter/pages/login.dart';
import 'package:assistance_flutter/providers/shedule_prodiver.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/scanner.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ScheduleProviderModel()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/scanner': (context) => const ScannerPage(),
      },
    );
  }
}
