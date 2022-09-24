import 'package:scribe/controllers/home.dart';

import '../imports.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    homeController.loadSiteInfo();
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Obx(
            () => Text(
              homeController.infoStr.value,
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ],
      ),
    );
  }
}
