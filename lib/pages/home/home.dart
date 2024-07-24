import 'package:assistance_flutter/pages/home/widgets/shedule_widget.dart';
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
    
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: const Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/unilibre.png'),
            ),
            SizedBox(width: 20),
            Text(
              'Hola Daniel',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
