import 'package:get/get.dart';
import 'package:scribe/controllers/zeronet.dart';
import 'package:zeronet_ws/models/siteinfo.dart';

final homeController = HomeController();

class HomeController extends GetxController {
  final siteInfo = SiteInfo().obs;
  final infoStr = ''.obs;

  void loadSiteInfo() async {
    print("Fetching SiteInfo");
    printError(info: "Fetching SiteInfo");
    final res = (await znxController.siteInfo()).result;
    printError(info: "Got SiteInfo");
    final info = SiteInfo.fromJson(res);
    print("Fetched SiteInfo");
    printError(info: "Fetched SiteInfo");
    infoStr.value = 'Site Address: ${info.address!}';
    infoStr.value += '\nPeers: ${info.peers}';
    infoStr.value += '\nModified: ${info.settings!.modified}';
  }
}
