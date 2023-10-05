import 'dart:async';

import 'package:js/js_util.dart';
import 'package:keycloak_flutter/src/keycloak.dart';

/// @author Gibah Joseph
/// email: gibahjoe@gmail.com
/// Nov, 2020

class KeycloakService {
  late Keycloak _keycloak;
  KeycloakProfile? _userProfile;
  StreamController<KeycloakEvent> _keycloakEvents =
      StreamController.broadcast();
  late bool _loadUserProfileAtStartUp;
  bool _silentRefresh = false;

  KeycloakService(KeycloakConfig config) {
    _keycloak = Keycloak(config);
  }

  Future<bool> init(
      {KeycloakInitOptions? initOptions,
      bool loadUserProfileAtStartUp = false}) async {
    _loadUserProfileAtStartUp = loadUserProfileAtStartUp;
    _bindEvents();
    bool authed = false;
    authed = await promiseToFuture<bool>(_keycloak.init(initOptions))
        .catchError((e) {
      return false;
    });
    if (authed && this._loadUserProfileAtStartUp) {
      await this.loadUserProfile();
    }
    return authed;
  }

  void _bindEvents() {
    _keycloak.onAuthSuccess = allowInterop(() {
      _keycloakEvents.add(KeycloakEvent(type: KeycloakEventType.onAuthSuccess));
    });
    _keycloak.onAuthError = allowInterop((error) {
      _keycloakEvents
          .add(KeycloakEvent(type: KeycloakEventType.onAuthError, args: error));
    });
    _keycloak.onReady = allowInterop((authenticated) {
      _keycloakEvents.add(
          KeycloakEvent(type: KeycloakEventType.onReady, args: authenticated));
    });
    _keycloak.onAuthRefreshError = allowInterop(() {
      _keycloakEvents
          .add(KeycloakEvent(type: KeycloakEventType.onAuthRefreshError));
    });
    _keycloak.onAuthLogout = allowInterop(() {
      _keycloakEvents.add(KeycloakEvent(type: KeycloakEventType.onAuthLogout));
    });
    _keycloak.onTokenExpired = allowInterop(() {
      _keycloakEvents
          .add(KeycloakEvent(type: KeycloakEventType.onTokenExpired));
    });
  }

  Stream<KeycloakEvent> get keycloakEventsStream => _keycloakEvents.stream;

  Future<void> login([KeycloakLoginOptions? options]) async {
    this._keycloak.login(options);

    if (this._loadUserProfileAtStartUp) {
      await this.loadUserProfile();
    }
  }

  get authenticated {
    return _keycloak.authenticated;
  }

  Future<String> getToken([bool forceLogin = false]) async {
    await this.updateToken(10);
    return this._keycloak.token;
  }

  Future<String> getIdToken([bool forceLogin = false]) async {
    await this.updateToken(10);
    return this._keycloak.idToken;
  }

  Future<void> logout([KeycloakLogoutOptions? options]) async {
    this._keycloak.logout(options);
    this._userProfile = null;
  }

  FutureOr<KeycloakProfile?> loadUserProfile([bool forceReload = false]) async {
    if (this._userProfile != null && !forceReload) {
      return this._userProfile!;
    }

    if (!this._keycloak.authenticated) {
      throw new Exception(
          'The user profile was not loaded as the user is not logged in.');
    }
    return this._userProfile =
        await promiseToFuture(this._keycloak.loadUserProfile());
  }

  /// Check if user is logged in.
  ///
  /// @returns
  /// A boolean that indicates if the user is logged in.
  Future<bool> isLoggedIn() async {
    try {
      if (!this._keycloak.authenticated) {
        return false;
      }
      await this.updateToken(20);
      return true;
    } catch (error) {
      return false;
    }
  }

  /// If the token expires within minValidity seconds the token is refreshed. If the
  /// session status iframe is enabled, the session status is also checked.
  /// Returns a promise telling if the token was refreshed or not. If the session is not active
  /// anymore, the promise is rejected.
  ///
  /// @param [minValidity]
  /// Seconds left. ([minValidity] is optional, if not specified 5 is used)
  /// @returns
  /// Promise with a boolean indicating if the token was succesfully updated.
  Future<bool> updateToken([num minValidity = 5]) async {
    // TODO: this is a workaround until the silent refresh (issue #43)
    // is not implemented, avoiding the redirect loop.
    if (this._silentRefresh) {
      var tokenExpired = this.isTokenExpired();
      if (tokenExpired) {
        throw new Exception(
            'Failed to refresh the token, or the session is expired');
      }

      return true;
    }

    return promiseToFuture<bool>(this._keycloak.updateToken(minValidity));
  }

  ///
  /// Returns true if the token has less than minValidity seconds left before
  /// it expires.
  ///
  /// @param [minValidity]
  /// Seconds left. [minValidity] is optional. Default value is 0.
  /// @returns
  ///  Boolean indicating if the token is expired.
  ///
  bool isTokenExpired([num? minValidity]) {
    return this._keycloak.isTokenExpired(minValidity);
  }

  void dispose() {
    _keycloakEvents.close();
  }
}

enum KeycloakEventType {
  /// Called if there was an error during authentication.
  onAuthError,

  /// Called if the user is logged out (will only be called if the session status
  /// iframe is enabled, or in Cordova mode).
  onAuthLogout,

  /// Called if there was an error while trying to refresh the token.
  onAuthRefreshError,

  /// Called when the token is refreshed
  onAuthRefreshSuccess,

  /// Called when a user is successfully authenticated.
  onAuthSuccess,

  /// Called when the adapter is initialized.
  onReady,

  ///  Called when the access token is expired. If a refresh token is available
  ///  the token can be refreshed with updateToken, or in cases where it is not
  ///  (that is, with implicit flow) you can redirect to login screen to obtain a new access token.
  onTokenExpired
}

class KeycloakEvent {
  /// Represents various type keycloak events that can be subscribed to
  ///
  /// [KeycloakEventType.onAuthError] is called if there was an error during authentication.
  /// [KeycloakEventType.onAuthLogout] Called if the user is logged out (will only be called if the session status
  /// iframe is enabled, or in Cordova mode).
  /// [KeycloakEventType.onAuthRefreshError] Called if there was an error while trying to refresh the token.
  /// [KeycloakEventType.onAuthRefreshSuccess] Called when the token is refreshed
  /// [KeycloakEventType.onAuthSuccess] Called when a user is successfully authenticated.
  /// [KeycloakEventType.onReady] Called when the adapter is initialized.
  ///  [KeycloakEventType.onTokenExpired] Called when the access token is expired. If a refresh token is available
  ///  the token can be refreshed with updateToken, or in cases where it is not
  ///  (that is, with implicit flow) you can redirect to login screen to obtain a new access token.
  final KeycloakEventType? type;

  final dynamic args;

  KeycloakEvent({this.type, this.args});
}
