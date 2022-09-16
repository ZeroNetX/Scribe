import 'imports.dart';

void main() {
  init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scribe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Obx(() {
        Widget body;
        switch (menuController.currentRoute.value) {
          case Menu.homePage:
            body = const HomePage();
            break;
          default:
            body = Container();
        }
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppBar(),
                Row(
                  children: [
                    const Spacer(flex: 1),
                    Flexible(flex: 16, child: body),
                    const Spacer(flex: 1)
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
