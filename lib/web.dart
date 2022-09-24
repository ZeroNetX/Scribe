import 'dart:async';
import 'dart:html';

const CMD_INNER_READY = 'innerReady';
// const CMD_RESPONSE = 'response';
// const CMD_WRAPPER_READY = 'wrapperReady';
// const CMD_PING = 'ping';
// const CMD_PONG = 'pong';
// const CMD_WRAPPER_OPENED_WEBSOCKET = 'wrapperOpenedWebsocket';
// const CMD_WRAPPER_CLOSE_WEBSOCKET = 'wrapperClosedWebsocket';

class ZeroFrameWeb {
  late final Window target;
  late final String wrapperNonce;
  int nextMsgId = 0;
  Map<int, MessageCallback> waitingCallbacks = {};

  ZeroFrameWeb() {
    target = document.window as Window;
    target.addEventListener('message', (event) => onMessage, false);
    wrapperNonce = (document.window?.location as Location)
        .href
        .split('wrapper_nonce=')
        .last;
    print(wrapperNonce);
  }

  void connect(String url) {
    wrapperGetAjaxKey().then((value) => print(value));
    // cmd(CMD_INNER_READY);
  }

  void onMessage(Event event) {
    log('onMessage');
    print('Print :: onMessage');
    final msg = event;
    log(msg);
    print('Print :: onMessage $msg');
  }

  void cmd(
    String cmd, [
    Map params = const {},
    MessageCallback? callback,
  ]) {
    send({
      'cmd': cmd,
      'params': params,
    }, callback);
  }

  void cmdp(String cmd, [Map params = const {}]) {
    this.cmd(cmd, params);
  }

  void send(Map<String, dynamic> message, MessageCallback? callback) {
    message['wrapper_nonce'] = wrapperNonce;
    message['id'] = nextMsgId;
    nextMsgId++;
    target.postMessage(message, '*');
    if (callback != null) {
      waitingCallbacks[message['id']] = callback;
    }
  }

  void log(dynamic args) {
    target.console.log(args);
  }

  void onOpenWebsocket() {
    this.log('Websocket open');
  }

  void onCloseWebsocket() {
    this.log('Websocket close');
  }

  Future<String> wrapperGetAjaxKey() async {
    final completer = Completer();
    cmd('wrapperGetAjaxKey', {}, (message) {
      completer.complete(message);
    });
    return await completer.future;
  }
}
