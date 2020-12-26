# Keycloak Flutter

[![pub package](https://img.shields.io/pub/v/keycloak_flutter.svg)](https://pub.dev/packages/keycloak_flutter)

> Easy Keycloak setup for Flutter applications.

## About

This library helps you to use [keycloak-js](https://www.keycloak.org/docs/latest/securing_apps/index.html#_javascript_adapter) in Flutter applications providing the following features:

- A **Keycloak Service** which wraps the `keycloak-js` methods to be used in Flutter, giving extra
  functionalities to the original functions and adding new methods to make it easier to be consumed by
  Flutter applications.
- ~~Generic **AuthGuard implementation**, so you can customize your own AuthGuard logic inheriting the authentication logic and the roles load.~~ (_coming soon_)
- ~~A **HttpClient interceptor** that adds the authorization header to all HttpClient requests.~~ 
  ~~It is also possible to disable this interceptor or exclude routes from having the authorization header.~~ (_coming soon_)
- ~~This documentation also assists you to configure the keycloak in your Flutter applications and with
  the client setup in the admin console of your keycloak installation.~~ (_coming soon_)


## Installation
Firstly, you need to have keycloak configured. Duh!

Include [keycloak_flutter](https://pub.dev/packages/keycloak_flutter) as a dependency in the
dependencies section of your pubspec.yaml file :

```yaml
dependencies:
  flutter_web_plugins:
    sdk: flutter
  keycloak_flutter: ^latest.version
```

Next, your application needs to be properly configured to use the regular url scheme (`http://localhost.com`) instead of
the default that comes with flutter (`http://localhost.com/#/`). Follow the instructions below to do this.

1. Add `<base href="/">` inside the <head> section of your `web/index.html` file. This will be added automatically for
   new projects created by flutter create. But for existing apps, the developer needs to add it manually.
2. Add the below code as the first line in your main function

```dart
void main() {
  configureUrlStrategy();
  runApp(MyApp());
}
```

The `configureUrlStrategy()` above uses a custom implementation of the PathUrlStrategy which cleans out your url to be
more like a regular web application url. This is required for keycloak to work properly. More
info [here]( https://github.com/flutter/flutter/issues/33245#issuecomment-705095853)

Next, In your `web/index.html`, you need to add a `script` with a source that references your keycloak.js file. You can
find `v10.0.2` in the example project. Your head tag should look as below.

#### Choosing the right keycloak-js version

The Keycloak client documentation recommends to use the same version of your Keycloak installation.

> A best practice is to load the JavaScript adapter directly from Keycloak Server as it will automatically be updated when you upgrade the server. If you copy the adapter to your web application instead, make sure you upgrade the adapter only after you have upgraded the server.

```html
<!DOCTYPE html>
<html>
<head>
    <base href="/">
    <!-- CODE REMOVED FOR BREVITY   -->
    <link rel="manifest" href="manifest.json">
    <script src="js/keycloak.js"></script>
</head>
<body>
<script>
    if ('serviceWorker' in navigator) {
        window.addEventListener('flutter-first-frame', function () {
            navigator.serviceWorker.register('flutter_service_worker.js');
        });
    }
</script>
<script src="main.dart.js" type="application/javascript"></script>
</body>
</html>
```

You can now use keycloak in your app.

## Note

You need to ensure you do not create multiple instances of keycloak. The example below uses a provider to ensure this.

Use the code provided below as an example and implement it's functionality in your application. In this process ensure that the configuration you are providing matches that of your client as configured in Keycloak.

- Read more about keycloak client adapter [here](https://www.keycloak.org/docs/latest/securing_apps/#_javascript_adapter)

# Example
```dart
void main() {
  configureUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (_) {
            var keycloakService = KeycloakService();
            keycloakService.keycloakEventsStream.listen((event) {
              if (event.type == KeycloakEventType.OnAuthSuccess) {
                // User is authenticated
              }
            });
            return keycloakService
              ..init(
                config: KeycloakConfig(
                    url: 'http://localhost:8080/auth', // Keycloak auth base url
                    realm: 'realm',
                    clientId: 'realm-frontend'),
                initOptions: KeycloakInitOptions(
                  onLoad: 'check-sso',
                  silentCheckSsoRedirectUri:
                  '${window.location.origin}/silent-check-sso.html',
                ),
              );
          },
        ),
      ],
      child: MaterialApp(
        title: 'Keycloak Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Keycloak demo'),
      ),
    );
  }
}
```

In the example we have set up Keycloak to use a silent `check-sso`. With this feature enabled, your browser will not do a full redirect to the Keycloak server and back to your application, instead this action will be performed in a hidden iframe, so your application resources only need to be loaded and parsed once by the browser when the app is initialized and not again after the redirect back from Keycloak to your app.

To ensure that Keycloak can communicate through the iframe you will have to serve a static HTML asset from your application at the location provided in `silentCheckSsoRedirectUri`.

Create a file called `silent-check-sso.html` in the `assets` directory of your application and paste in the contents as seen below.

```html
<html>
  <body>
    <script>
      parent.postMessage(location.href, location.origin);
    </script>
  </body>
</html>
```

If you want to know more about these options and various other capabilities of the Keycloak client is recommended to read the [JavaScript Adapter documentation](https://www.keycloak.org/docs/latest/securing_apps/#_javascript_adapter).

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/gibahjoe/keycloak_flutter/issues
