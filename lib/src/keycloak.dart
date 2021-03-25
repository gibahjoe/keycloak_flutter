@JS()
library keycloak;

import "package:js/js.dart";

/// MIT License
/// Copyright 2017 Brett Epps <https://github.com/eppsilon>
/// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
/// associated documentation files (the "Software"), to deal in the Software without restriction, including
/// without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
/// following conditions:
/// The above copyright notice and this permission notice shall be included in all copies or substantial
/// portions of the Software.
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
/// LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
/// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
/// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
/// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
/* WARNING: export assignment not yet supported. */

// Module Keycloak
/*type KeycloakAdapterName = 'cordova' | 'cordova-native' | 'default' | any;*/
/*type KeycloakOnLoad = 'login-required' | 'check-sso';*/
/*type KeycloakResponseMode = 'query' | 'fragment';*/
/*type KeycloakResponseType = 'code' | 'id_token token' | 'code id_token token';*/
/*type KeycloakFlow = 'standard' | 'implicit' | 'hybrid';*/
/*type KeycloakPkceMethod = 'S256';*/
@anonymous
@JS()
abstract class KeycloakConfig {
  /// URL to the Keycloak server, for example: http://keycloak-server/auth
  external String get url;
  external set url(String v);

  /// Name of the realm, for example: 'myrealm'
  external String get realm;
  external set realm(String v);

  /// Client identifier, example: 'myapp'
  external String get clientId;
  external set clientId(String v);
  external factory KeycloakConfig({String url, String realm, String clientId});
}

@anonymous
@JS()
abstract class KeycloakInitOptions {
  /// Adds a [cryptographic nonce](https://en.wikipedia.org/wiki/Cryptographic_nonce)
  /// to verify that the authentication response matches the request.
  /// @default true
  external bool get useNonce;
  external set useNonce(bool v);

  /// Allows to use different adapter:
  /// - {string} default - using browser api for redirects
  /// - {string} cordova - using cordova plugins
  /// - {function} - allows to provide custom function as adapter.
  external dynamic /*'cordova'|'cordova-native'|'default'|dynamic*/ get adapter;
  external set adapter(
      dynamic /*'cordova'|'cordova-native'|'default'|dynamic*/ v);

  /// Specifies an action to do on load.
  external String /*'login-required'|'check-sso'*/ get onLoad;
  external set onLoad(String /*'login-required'|'check-sso'*/ v);

  /// Set an initial value for the token.
  external String get token;
  external set token(String v);

  /// Set an initial value for the refresh token.
  external String get refreshToken;
  external set refreshToken(String v);

  /// Set an initial value for the id token (only together with `token` or
  /// `refreshToken`).
  external String get idToken;
  external set idToken(String v);

  /// Set an initial value for skew between local time and Keycloak server in
  /// seconds (only together with `token` or `refreshToken`).
  external num get timeSkew;
  external set timeSkew(num v);

  /// Set to enable/disable monitoring login state.
  /// @default true
  external bool get checkLoginIframe;
  external set checkLoginIframe(bool v);

  /// Set the interval to check login state (in seconds).
  /// @default 5
  external num get checkLoginIframeInterval;
  external set checkLoginIframeInterval(num v);

  /// Set the OpenID Connect response mode to send to Keycloak upon login.
  /// @default fragment After successful authentication Keycloak will redirect
  /// to JavaScript application with OpenID Connect parameters
  /// added in URL fragment. This is generally safer and
  /// recommended over query.
  external String /*'query'|'fragment'*/ get responseMode;
  external set responseMode(String /*'query'|'fragment'*/ v);

  /// Specifies a default uri to redirect to after login or logout.
  /// This is currently supported for adapter 'cordova-native' and 'default'
  external String get redirectUri;
  external set redirectUri(String v);

  /// Specifies an uri to redirect to after silent check-sso.
  /// Silent check-sso will only happen, when this redirect uri is given and
  /// the specified uri is available whithin the application.
  external String get silentCheckSsoRedirectUri;
  external set silentCheckSsoRedirectUri(String v);

  /// Set the OpenID Connect flow.
  /// @default standard
  external String /*'standard'|'implicit'|'hybrid'*/ get flow;
  external set flow(String /*'standard'|'implicit'|'hybrid'*/ v);

  /// Configures the Proof Key for Code Exchange (PKCE) method to use.
  /// The currently allowed method is 'S256'.
  /// If not configured, PKCE will not be used.
  external String /*'S256'*/ get pkceMethod;
  external set pkceMethod(String /*'S256'*/ v);

  /// Enables logging messages from Keycloak to the console.
  /// @default false
  external bool get enableLogging;
  external set enableLogging(bool v);
  external factory KeycloakInitOptions(
      {bool useNonce,
      dynamic /*'cordova'|'cordova-native'|'default'|dynamic*/ adapter,
      String /*'login-required'|'check-sso'*/ onLoad,
      String token,
      String refreshToken,
      String idToken,
      num timeSkew,
      bool checkLoginIframe,
      num checkLoginIframeInterval,
      String /*'query'|'fragment'*/ responseMode,
      String redirectUri,
      String silentCheckSsoRedirectUri,
      String /*'standard'|'implicit'|'hybrid'*/ flow,
      String /*'S256'*/ pkceMethod,
      bool enableLogging});
}

@anonymous
@JS()
abstract class KeycloakLoginOptions {
  /// @private Undocumented.
  external String get scope;
  external set scope(String v);

  /// Specifies the uri to redirect to after login.
  external String get redirectUri;
  external set redirectUri(String v);

  /// By default the login screen is displayed if the user is not logged into
  /// Keycloak. To only authenticate to the application if the user is already
  /// logged in and not display the login page if the user is not logged in, set
  /// this option to `'none'`. To always require re-authentication and ignore
  /// SSO, set this option to `'login'`.
  external String /*'none'|'login'*/ get prompt;
  external set prompt(String /*'none'|'login'*/ v);

  /// If value is `'register'` then user is redirected to registration page,
  /// otherwise to login page.
  external String get action;
  external set action(String v);

  /// Used just if user is already authenticated. Specifies maximum time since
  /// the authentication of user happened. If user is already authenticated for
  /// longer time than `'maxAge'`, the SSO is ignored and he will need to
  /// authenticate again.
  external num get maxAge;
  external set maxAge(num v);

  /// Used to pre-fill the username/email field on the login form.
  external String get loginHint;
  external set loginHint(String v);

  /// Used to tell Keycloak which IDP the user wants to authenticate with.
  external String get idpHint;
  external set idpHint(String v);

  /// Sets the 'ui_locales' query param in compliance with section 3.1.2.1
  /// of the OIDC 1.0 specification.
  external String get locale;
  external set locale(String v);

  /// Specifies arguments that are passed to the Cordova in-app-browser (if applicable).
  /// Options 'hidden' and 'location' are not affected by these arguments.
  /// All available options are defined at https://cordova.apache.org/docs/en/latest/reference/cordova-plugin-inappbrowser/.
  /// Example of use: { zoom: "no", hardwareback: "yes" }
  external dynamic /*JSMap of <String,String>*/ get cordovaOptions;
  external set cordovaOptions(dynamic /*JSMap of <String,String>*/ v);
  external factory KeycloakLoginOptions(
      {String scope,
      String redirectUri,
      String /*'none'|'login'*/ prompt,
      String action,
      num maxAge,
      String loginHint,
      String idpHint,
      String locale,
      dynamic /*JSMap of <String,String>*/ cordovaOptions});
}

@anonymous
@JS()
abstract class KeycloakLogoutOptions {
  /// Specifies the uri to redirect to after logout.
  external String get redirectUri;
  external set redirectUri(String v);
  external factory KeycloakLogoutOptions({String redirectUri});
}

typedef void KeycloakPromiseCallback<T>(T result);

// @JS("Keycloak.KeycloakPromise")
// class KeycloakPromise<TSuccess, TError> extends Future<TSuccess> {
//   // @Ignore
//   KeycloakPromise.fakeConstructor$() : super.fakeConstructor$();
//
//   /// Function to call if the promised action succeeds.
//   /// Use `.then()` instead.
//   external KeycloakPromise<TSuccess, TError> success(
//       KeycloakPromiseCallback<TSuccess> callback);
//
//   /// Function to call if the promised action throws an error.
//   /// Use `.catch()` instead.
//   external KeycloakPromise<TSuccess, TError> error(
//       KeycloakPromiseCallback<TError> callback);
// }

@anonymous
@JS()
abstract class KeycloakError {
  external String get error;
  external set error(String v);
  external String get error_description;
  external set error_description(String v);
  external factory KeycloakError({String error, String error_description});
}

@anonymous
@JS()
abstract class KeycloakAdapter {
  external Future login([KeycloakLoginOptions options]);
  external Future logout([KeycloakLogoutOptions options]);
  external Future register([KeycloakLoginOptions options]);
  external Future accountManagement();
  external String redirectUri(
      dynamic /*{ redirectUri: string; }*/ options, bool encodeHash);
}

@anonymous
@JS()
abstract class KeycloakProfile {
  external String get id;
  external set id(String v);
  external String get username;
  external set username(String v);
  external String get email;
  external set email(String v);
  external String get firstName;
  external set firstName(String v);
  external String get lastName;
  external set lastName(String v);
  external bool get enabled;
  external set enabled(bool v);
  external bool get emailVerified;
  external set emailVerified(bool v);
  external bool get totp;
  external set totp(bool v);
  external num get createdTimestamp;
  external set createdTimestamp(num v);
  external factory KeycloakProfile(
      {String id,
      String username,
      String email,
      String firstName,
      String lastName,
      bool enabled,
      bool emailVerified,
      bool totp,
      num createdTimestamp});
}

@anonymous
@JS()
abstract class KeycloakTokenParsed {
  external num get exp;
  external set exp(num v);
  external num get iat;
  external set iat(num v);
  external String get nonce;
  external set nonce(String v);
  external String get sub;
  external set sub(String v);
  external String get session_state;
  external set session_state(String v);
  external KeycloakRoles get realm_access;
  external set realm_access(KeycloakRoles v);
  external KeycloakResourceAccess get resource_access;
  external set resource_access(KeycloakResourceAccess v);
  external factory KeycloakTokenParsed(
      {num exp,
      num iat,
      String nonce,
      String sub,
      String session_state,
      KeycloakRoles realm_access,
      KeycloakResourceAccess resource_access});
}

@anonymous
@JS()
abstract class KeycloakResourceAccess {
  /* Index signature is not yet supported by JavaScript interop. */
}

@anonymous
@JS()
abstract class KeycloakRoles {
  external List<String> get roles;
  external set roles(List<String> v);
  external factory KeycloakRoles({List<String> roles});
}

/// A client for the Keycloak authentication server.
/// @see [https://keycloak.gitbooks.io/securing-client-applications-guide/content/topics/oidc/javascript-adapter.html|Keycloak JS adapter documentation]
@JS()
abstract class Keycloak {
  /// Creates a new Keycloak client instance.
  external factory Keycloak(KeycloakConfig? options);

  /// Is true if the user is authenticated, false otherwise.
  external bool get authenticated;
  external set authenticated(bool v);

  /// The user id.
  external String get subject;
  external set subject(String v);

  /// Response mode passed in init (default value is `'fragment'`).
  external String /*'query'|'fragment'*/ get responseMode;
  external set responseMode(String /*'query'|'fragment'*/ v);

  /// Response type sent to Keycloak with login requests. This is determined
  /// based on the flow value used during initialization, but can be overridden
  /// by setting this value.
  external String /*'code'|'id_token token'|'code id_token token'*/ get responseType;
  external set responseType(
      String /*'code'|'id_token token'|'code id_token token'*/ v);

  /// Flow passed in init.
  external String /*'standard'|'implicit'|'hybrid'*/ get flow;
  external set flow(String /*'standard'|'implicit'|'hybrid'*/ v);

  /// The realm roles associated with the token.
  external KeycloakRoles get realmAccess;
  external set realmAccess(KeycloakRoles v);

  /// The resource roles associated with the token.
  external KeycloakResourceAccess get resourceAccess;
  external set resourceAccess(KeycloakResourceAccess v);

  /// The base64 encoded token that can be sent in the Authorization header in
  /// requests to services.
  external String get token;
  external set token(String v);

  /// The parsed token as a JavaScript object.
  external KeycloakTokenParsed get tokenParsed;
  external set tokenParsed(KeycloakTokenParsed v);

  /// The base64 encoded refresh token that can be used to retrieve a new token.
  external String get refreshToken;
  external set refreshToken(String v);

  /// The parsed refresh token as a JavaScript object.
  external KeycloakTokenParsed get refreshTokenParsed;
  external set refreshTokenParsed(KeycloakTokenParsed v);

  /// The base64 encoded ID token.
  external String get idToken;
  external set idToken(String v);

  /// The parsed id token as a JavaScript object.
  external KeycloakTokenParsed get idTokenParsed;
  external set idTokenParsed(KeycloakTokenParsed v);

  /// The estimated time difference between the browser time and the Keycloak
  /// server in seconds. This value is just an estimation, but is accurate
  /// enough when determining if a token is expired or not.
  external num get timeSkew;
  external set timeSkew(num v);

  /// @private Undocumented.
  external bool get loginRequired;
  external set loginRequired(bool v);

  /// @private Undocumented.
  external String get authServerUrl;
  external set authServerUrl(String v);

  /// @private Undocumented.
  external String get realm;
  external set realm(String v);

  /// @private Undocumented.
  external String get clientId;
  external set clientId(String v);

  /// @private Undocumented.
  external String get clientSecret;
  external set clientSecret(String v);

  /// @private Undocumented.
  external String get redirectUri;
  external set redirectUri(String v);

  /// @private Undocumented.
  external String get sessionId;
  external set sessionId(String v);

  /// @private Undocumented.
  external KeycloakProfile get profile;
  external set profile(KeycloakProfile v);

  /// @private Undocumented.
  external dynamic /*{}*/ get userInfo;
  external set userInfo(dynamic /*{}*/ v);

  /// Called when the adapter is initialized.
  external set onReady(Function(bool) onReady);

  /// Called when a user is successfully authenticated.
  external set onAuthSuccess(Function onAuthSuccess);

  /// Called if there was an error during authentication.
  external set onAuthError(Function(KeycloakError) onAuthError);

  /// Called when the token is refreshed.
  external set onAuthRefreshSuccess(Function() onAuthRefreshSuccess);

  /// Called if there was an error while trying to refresh the token.
  external set onAuthRefreshError(Function() onAuthRefreshError);

  /// Called if the user is logged out (will only be called if the session
  /// status iframe is enabled, or in Cordova mode).
  external set onAuthLogout(Function() onAuthLogout);

  /// Called when the access token is expired. If a refresh token is available
  /// the token can be refreshed with Keycloak#updateToken, or in cases where
  /// it's not (ie. with implicit flow) you can redirect to login screen to
  /// obtain a new access token.
  external set onTokenExpired(Function() onTokenExpired);

  /// Called when a AIA has been requested by the application.
  external void onActionUpdate(String /*'success'|'cancelled'|'error'*/ status);

  /// Called to initialize the adapter.
  external Future<bool> init(KeycloakInitOptions? initOptions);

  /// Redirects to login form.
  external Future login([KeycloakLoginOptions? options]);

  /// Redirects to logout.
  external Future logout([KeycloakLogoutOptions? options]);

  /// Redirects to registration form.
  /// set to `'register'`.
  external Future register([dynamic options]);

  /// Redirects to the Account Management Console.
  external Future accountManagement();

  /// Returns the URL to login form.
  external String createLoginUrl([KeycloakLoginOptions options]);

  /// Returns the URL to logout the user.
  external String createLogoutUrl([KeycloakLogoutOptions options]);

  /// Returns the URL to registration page.
  /// `action` is set to `'register'`.
  external String createRegisterUrl([KeycloakLoginOptions options]);

  /// Returns the URL to the Account Management Console.
  external String createAccountUrl();

  /// Returns true if the token has less than `minValidity` seconds left before
  /// it expires.
  external bool isTokenExpired([num? minValidity]);

  /// If the token expires within `minValidity` seconds, the token is refreshed.
  /// If the session status iframe is enabled, the session status is also
  /// checked.
  /// still valid, or if the token is no longer valid.
  /// @example
  /// ```js
  /// keycloak.updateToken(5).success(function(refreshed) {
  /// if (refreshed) {
  /// alert('Token was successfully refreshed');
  /// } else {
  /// alert('Token is still valid');
  /// }
  /// }).error(function() {
  /// alert('Failed to refresh the token, or the session has expired');
  /// });
  external Future<bool> updateToken(num minValidity);

  /// Clears authentication state, including tokens. This can be useful if
  /// the application has detected the session was expired, for example if
  /// updating token fails. Invoking this results in Keycloak#onAuthLogout
  /// callback listener being invoked.
  external void clearToken();

  /// Returns true if the token has the given realm role.
  external bool hasRealmRole(String role);

  /// Returns true if the token has the given role for the resource.
  external bool hasResourceRole(String role, [String resource]);

  /// Loads the user's profile.
  external Future<KeycloakProfile> loadUserProfile();

  /// @private Undocumented.
  external Future<dynamic /*{}*/ > loadUserInfo();
}

// End module Keycloak
