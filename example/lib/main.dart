import 'dart:html';

import 'package:flutter/material.dart';
import 'package:keycloak_flutter/keycloak_flutter.dart';

late KeycloakService keycloakService;

void main() {
  keycloakService = KeycloakService(KeycloakConfig(
      url: 'https://kc.devappliance.com', // Keycloak auth base url
      realm: 'keycloak_flutter',
      clientId: 'sample-flutter'));
  keycloakService.init(
    initOptions: KeycloakInitOptions(
      onLoad: 'check-sso',
      silentCheckSsoRedirectUri:
          '${window.location.origin}/silent-check-sso.html',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keycloak Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Keycloak demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  KeycloakProfile? _keycloakProfile;

  void _login() {
    keycloakService.login(KeycloakLoginOptions(
      redirectUri: '${window.location.origin}',
    ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      keycloakService.keycloakEventsStream.listen((event) async {
        print(event);
        if (event.type == KeycloakEventType.onAuthSuccess) {
          _keycloakProfile = await keycloakService.loadUserProfile();
        } else {
          _keycloakProfile = null;
        }
        setState(() {});
      });
      // if(keycloakService.authenticated){
      //   _keycloakProfile = await keycloakService.loadUserProfile(false);
      // }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await keycloakService.logout();
              }),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome ${_keycloakProfile?.username ?? 'Guest'}',
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20,
            ),
            if (_keycloakProfile?.username == null)
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Login',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            SizedBox(
              height: 20,
            ),
            if (_keycloakProfile?.username != null)
              ElevatedButton(
                onPressed: () async {
                  print('refreshing token');
                  await keycloakService.updateToken(1000).then((value) {
                    print(value);
                  }).catchError((onError) {
                    print(onError);
                  });
                },
                child: Text(
                  'Refresh token',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _login,
        tooltip: 'Login',
        child: Icon(Icons.login),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
