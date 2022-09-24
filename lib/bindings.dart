// ignore_for_file: non_constant_identifier_names

@JS('frame')
library bindings.js;

import 'package:js/js.dart';

external void cmd(String cmd, List params);

external Object cmdp(String cmd, List params);

external void on_request(String cmd, Function handler);
