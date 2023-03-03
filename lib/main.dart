import 'imports.dart';

void main() async {
  await init();
  runApp(
    LayoutBuilder(
      builder: (ctx, cons) {
        themeController.layoutChanged(cons.biggest);
        return const MyApp();
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Scribe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: const MaterialColor(0xFF2F2109, {
          50: Color(0xFF2F2109),
          100: Color(0xFF2F2109),
          200: Color(0xFF2F2109),
          300: Color(0xFF2F2109),
          400: Color(0xFF2F2109),
          500: Color(0xFF2F2109),
          600: Color(0xFF2F2109),
          700: Color(0xFF2F2109),
          800: Color(0xFF2F2109),
          900: Color(0xFF2F2109),
        }),
      ),
      home: Obx(
        () {
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
            floatingActionButton: Obx(() {
              return menuController.currentRoute.value == Menu.article
                  ? LayoutBuilder(builder: (context, constrains) {
                      return Align(
                        alignment: Alignment.bottomRight,
                        child: PhysicalModel(
                          color: Colors.black12,
                          elevation: 3,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: 220,
                            height: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Obx(() {
                                  return Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (zeroNetController
                                                  .siteInfo.value!.certUserId !=
                                              null) {
                                            zeroNetController
                                                    .userObject.postVotes[
                                                menuController
                                                    .currentArticle.value!.id
                                                    .toString()] = 1;
                                            zeroNetController.likeArticle(
                                              menuController
                                                  .currentArticle.value!.id,
                                            );
                                          } else {
                                            showZeroNetxDialog(
                                              context,
                                              () {
                                                zeroNetController.likeArticle(
                                                  menuController
                                                      .currentArticle.value!.id,
                                                );
                                              },
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.thumb_up_sharp,
                                          color: zeroNetController
                                                  .userObject.postVotes
                                                  .containsKey(
                                            menuController
                                                .currentArticle.value!.id
                                                .toString(),
                                          )
                                              ? Colors.amber
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        menuController.currentArticle.value !=
                                                null
                                            ? menuController.currentArticle
                                                .value!.likesCount
                                                .toString()
                                            : '0',
                                        style: const TextStyle(
                                            color: Colors.black45),
                                      ),
                                    ],
                                  );
                                }),
                                Container(
                                  width: 1,
                                  color: Colors.black12,
                                  height: 50,
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        menuController.showCommentBox.value =
                                            !menuController
                                                .showCommentBox.value;
                                      },
                                      icon: const Icon(Icons.messenger),
                                    ),
                                    Obx(() {
                                      return Text(
                                        menuController.currentArticle.value !=
                                                null
                                            ? menuController.currentArticle
                                                .value!.commentsCount
                                                .toString()
                                            : '0',
                                        style: const TextStyle(
                                          color: Colors.black45,
                                        ),
                                      );
                                    })
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                  : const SizedBox();
            }),
            body: SingleChildScrollView(
              //controller: ScrollController(),
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
        },
      ),
    );
  }
}
