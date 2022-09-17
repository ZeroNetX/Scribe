import '../imports.dart';

extension WidgetExt on Widget {
  Widget contained({Color? color}) {
    return Container(
      color: themeController.debugWidgets ? color : null,
      child: this,
    );
  }

  Widget minSized({double? width, double? height}) {
    return Container(
      constraints: BoxConstraints(
        minWidth: width ?? 0.0,
        minHeight: height ?? 0.0,
      ),
      child: this,
    );
  }
}
