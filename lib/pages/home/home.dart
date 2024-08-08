import 'package:assistance_flutter/helper/format_name.dart';
import 'package:assistance_flutter/pages/home/widgets/shedule_widget.dart';
import 'package:assistance_flutter/providers/auth_provider.dart';
import 'package:assistance_flutter/providers/shedule_prodiver.dart';
import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ScheduleProviderModel>(context, listen: false).getSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/unilibre.png'),
            ),
            const SizedBox(width: 20),
            Consumer<ScheduleProviderModel>(
                builder: (context, scheduleModel, child) {
              return Text(
                'Hola ${scheduleModel.name}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              );
            })
          ],
        ),
        
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(cutUserName(
                  "${authProvider.getUser()['name']} ${authProvider.getUser()['surnames']}",
                  "2")),
              accountEmail: Text(authProvider.getUser()['email']),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: AssetImage('assets/unilibre.png'),
              ),
            ),
            ListTile(
              selectedColor:Colors.red,
              leading: const Icon(Icons.check_circle, color: Colors.red),
              title: const Text('Tomar asistencia'),
              onTap: () {
                Navigator.pushNamed(context, '/scanner');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Cambiar contraseña'),
              onTap: () {
                Navigator.pushNamed(context, '/update-password');
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Términos y condiciones'),
              onTap: () {
                // Acción para términos y condiciones
                Navigator.pushNamed(context, '/terms');
              },
            ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Contacto y soporte'),
              onTap: () {
                // Acción para soporte y contacto
                Navigator.pushNamed(context, '/support');
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Cerrar sesión'),
              onTap: () {
                authProvider.logout();
                Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            '/login',
                                            (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              BannerCarousel(
                banners: BannerImages.listBanners,
                onTap: (id) => print(id),
              ),
              const ScheduleWidget()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/scanner');
        },
        backgroundColor: Colors.red[200],
        child: const Icon(Icons.qr_code),
      ),
    );
  }
}

class BannerImages {
  static const String banner1 = 'assets/banner1.jpeg';
  static const String banner2 = 'assets/banner2.jpeg';
  static const String banner3 = 'assets/banner3.jpeg';

  static List<BannerModel> listBanners = [
    BannerModel(imagePath: banner1, id: "1"),
    BannerModel(imagePath: banner2, id: "2"),
    BannerModel(imagePath: banner3, id: "3"),
  ];
}
