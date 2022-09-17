import 'package:scribe/controllers/theme.dart';
import 'package:scribe/pages/article.dart';

import 'imports.dart';

void main() {
  init();
  runApp(LayoutBuilder(builder: (ctx, cons) {
    themeController.layoutChanged(cons.biggest);
    return const MyApp();
  }));
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
          case Menu.article:
            body = ArticlePage(menuController.currentArticle.value!);
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
                    Spacer(flex: themeController.pagePadding.value),
                    Flexible(
                      flex: themeController.bodyFlex.value,
                      child: body,
                    ),
                    Spacer(flex: themeController.pagePadding.value)
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
