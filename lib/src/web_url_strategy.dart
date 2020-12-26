import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class WebUrlStrategy extends PathUrlStrategy {
  WebUrlStrategy([
    this._platformLocation = const BrowserPlatformLocation(),
  ]) : super(_platformLocation);

  final PlatformLocation _platformLocation;

  @override
  String getPath() {
    var p = super.getPath() + _platformLocation.hash;
    return p;
  }
}
