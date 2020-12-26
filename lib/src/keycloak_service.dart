import 'dart:async';

import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:keycloak_flutter/src/keycloak.dart';
import 'package:logger/logger.dart';

/// @author Gibah Joseph
/// email: gibahjoe@gmail.com
/// Nov, 2020

class KeycloakService {
  Keycloak _keycloak;
  KeycloakProfile _userProfile;
  StreamController<KeycloakEvent> _keycloakEvents =
      StreamController.broadcast();
  bool _loadUserProfileAtStartUp;
  final log = Logger();
  bool _silentRefresh = false;

  KeycloakService();

  Future<bool> init(
      {KeycloakConfig config,
      KeycloakInitOptions initOptions,
      bool loadUserProfileAtStartUp = false}) async {
    log.i('-->inited kc $_keycloak');
    _loadUserProfileAtStartUp = loadUserProfileAtStartUp;
    _keycloak = Keycloak(config);
    _bindEvents();
    bool authed = false;

    authed = await promiseToFuture<bool>(_keycloak.init(initOptions));
    if (authed && this._loadUserProfileAtStartUp) {
      await this.loadUserProfile();
    }
    return authed;
  }

  void _bindEvents() {
    _keycloak.onAuthSuccess = allowInterop(() {
      _keycloakEvents.add(KeycloakEvent(type: KeycloakEventType.OnAuthSuccess));
    });
    _keycloak.onAuthError = allowInterop((error) {
      _keycloakEvents
          .add(KeycloakEvent(type: KeycloakEventType.OnAuthError, args: error));
    });
    _keycloak.onReady = allowInterop((authenticated) {
      _keycloakEvents.add(
          KeycloakEvent(type: KeycloakEventType.OnReady, args: authenticated));
    });
    _keycloak.onAuthRefreshError = allowInterop(() {
      _keycloakEvents
          .add(KeycloakEvent(type: KeycloakEventType.OnAuthRefreshError));
    });
    _keycloak.onAuthLogout = allowInterop(() {
      _keycloakEvents.add(KeycloakEvent(type: KeycloakEventType.OnAuthLogout));
    });
    _keycloak.onTokenExpired = allowInterop(() {
      _keycloakEvents
          .add(KeycloakEvent(type: KeycloakEventType.OnTokenExpired));
    });
  }

  Stream<KeycloakEvent> get keycloakEventsStream => _keycloakEvents.stream;

  Future<void> login([KeycloakLoginOptions options]) async {
    log.i('-->loging kc $_keycloak');
    await this._keycloak.login(options);

    if (this._loadUserProfileAtStartUp) {
      await this.loadUserProfile();
    }
  }

  Future<String> getToken([bool forceLogin = false]) async {
    await this.updateToken(10);
    return this._keycloak.token;
  }

  Future<void> logout([KeycloakLogoutOptions options]) async {
    await this._keycloak.logout(options);
    this._userProfile = null;
  }

  FutureOr<KeycloakProfile> loadUserProfile([bool forceReload = false]) async {
    if (this._userProfile != null && !forceReload) {
      return this._userProfile;
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

    if (this._keycloak == null) {
      throw new Exception('Keycloak Dart library is not initialized.');
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
  bool isTokenExpired([num minValidity]) {
    return this._keycloak.isTokenExpired(minValidity);
  }

  @override
  void dispose() {
    _keycloakEvents.close();
  }
}

enum KeycloakEventType {
  OnAuthError,
  OnAuthLogout,
  OnAuthRefreshError,
  OnAuthRefreshSuccess,
  OnAuthSuccess,
  OnReady,
  OnTokenExpired
}

class KeycloakEvent {
  final KeycloakEventType type;

  final dynamic args;

  KeycloakEvent({this.type, this.args});
}
