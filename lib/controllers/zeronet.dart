import 'dart:async';

import 'package:scribe/web.dart';

import '../imports.dart';

const _siteAddr = String.fromEnvironment('SITE_ADDR');

final znxController = ZeroNetXController();

class ZeroNetXController extends GetxController {
  late final ZeroFrameWeb _zeroNet = ZeroFrameWeb();
  Future<void> init() async {
    _zeroNet.connect(_siteAddr);
  }

  Future<Message> siteInfo() async {
    final completer = Completer();
    _zeroNet.cmd('siteInfo', {}, (message) {
      completer.complete(Message.fromJson(message as Map<String, dynamic>));
    });
    return await completer.future;
  }

  String get address => _siteAddr;
}
