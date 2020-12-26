import 'dart:html';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_web_plugins/src/navigation/url_strategy.dart';
import 'package:keycloak_flutter/keycloak_flutter.dart';

void configureUrlStrategy() {
  setUrlStrategy(WebUrlStrategy());
}
