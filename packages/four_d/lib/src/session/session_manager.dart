import '../errors/four_d_exception.dart';
import '../transport/transport.dart';

enum FourDSessionState { idle, authenticating, authenticated, closed }

/// Owns the session lifecycle and serializes authentication attempts.
///
/// 4D session-cookie names vary by deployment/version, so this class preserves
/// every Set-Cookie pair. Endpoint-specific cookie verification belongs in the
/// protocol-contract suite before a stable release.
class FourDSessionManager {
  FourDSessionState _state = FourDSessionState.idle;
  final Map<String, String> _cookies = <String, String>{};
  Future<void>? _authentication;

  FourDSessionState get state => _state;
  bool get isAuthenticated => _state == FourDSessionState.authenticated;

  String? get cookieHeader =>
      _cookies.isEmpty ? null : _cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');

  Future<void> authenticate(Future<FourDResponse> Function() request) {
    if (_state == FourDSessionState.closed) {
      throw const FourDStateException('The session manager has been closed.');
    }
    if (_authentication != null) return _authentication!;
    _authentication = _runAuthentication(request);
    return _authentication!;
  }

  Future<void> _runAuthentication(Future<FourDResponse> Function() request) async {
    _state = FourDSessionState.authenticating;
    try {
      final FourDResponse response = await request();
      _captureCookies(response.headers);
      if (!response.isSuccess) {
        throw FourDAuthenticationException('Authentication failed (${response.statusCode}).');
      }
      _state = FourDSessionState.authenticated;
    } on FourDException {
      _state = FourDSessionState.idle;
      rethrow;
    } catch (error) {
      _state = FourDSessionState.idle;
      throw FourDAuthenticationException('Authentication request failed.', cause: error);
    } finally {
      _authentication = null;
    }
  }

  void updateFrom(FourDResponse response) => _captureCookies(response.headers);

  void close() {
    _cookies.clear();
    _state = FourDSessionState.closed;
  }

  void _captureCookies(Map<String, List<String>> headers) {
    final List<String>? setCookies = headers.entries
        .where((MapEntry<String, List<String>> entry) => entry.key.toLowerCase() == 'set-cookie')
        .expand((MapEntry<String, List<String>> entry) => entry.value)
        .toList();
    for (final String value in setCookies ?? const <String>[]) {
      final String pair = value.split(';').first;
      final int separator = pair.indexOf('=');
      if (separator > 0) _cookies[pair.substring(0, separator)] = pair.substring(separator + 1);
    }
  }
}
