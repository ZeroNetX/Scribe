import 'dart:async';
// ignore: unused_import
import '' if (dart.library.html) 'dart:html' if (dart.library.io) '';

import 'package:scribe/bindings.dart';
import 'package:zeronet_ws/models/siteinfo.dart';

import '../imports.dart';

const _siteAddr = String.fromEnvironment('SITE_ADDR');

final znxController = ZeroNetXController();

class ZeroNetXController extends GetxController {
  Future<SiteInfo> siteInfo() async {
    final siteInfo = await promiseToFutureAsMap(cmdp('siteInfo', []));
    return SiteInfo.fromJson(siteInfo ?? {});
  }

  String get address => _siteAddr;
}
