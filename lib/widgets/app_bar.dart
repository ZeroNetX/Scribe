import '../imports.dart';

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: 64.0,
        color: Colors.amber,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Spacer(flex: themeController.pagePadding.value),
            Flexible(
              flex: themeController.bodyFlex.value,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      menuController.goto(Menu.homePage);
                      menuController.isFullScreen.value = false;
                    },
                    child: const Text(
                      'Scribe',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F2109),
                      ),
                    ),
                  ),
                  zeroNetController.siteInfo.value!.certUserId != null
                      ? GestureDetector(
                          onTap: () => showZeroNetxDialog(context, () {}),
                          child: CircleAvatar(
                            radius: 20,
                            child: Text(
                              zeroNetController.siteInfo.value!.certUserId!
                                  .split('@')
                                  .first[0]
                                  .toUpperCase(),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            showZeroNetxDialog(context, () {});
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFF2F2109),
                            ),
                            minimumSize:
                                MaterialStateProperty.all(const Size(90, 45)),
                          ),
                          child: const Text("Sign In"),
                        ),
                ],
              ),
            ),
            Spacer(flex: themeController.pagePadding.value),
          ],
        ),
      );
    });
  }
}
