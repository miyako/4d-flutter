import '../catalog/catalog.dart';
import '../config/four_d_config.dart';
import '../errors/four_d_exception.dart';
import '../session/session_manager.dart';
import '../transport/transport.dart';
import '../uri/rest_uri_builder.dart';

/// Entry point for the verified core 4D REST vertical slice.
class FourDClient {
  FourDClient({required FourDConfig config, required FourDTransport transport})
      : _transport = transport,
        uris = RestUriBuilder(config),
        session = FourDSessionManager();

  final FourDTransport _transport;
  final RestUriBuilder uris;
  final FourDSessionManager session;

  late final FourDCatalogClient catalog = FourDCatalogClient(_authenticatedTransport(), uris);

  /// Fetches a raw DataClass selection while the typed ORDA layer is developed.
  Future<Map<String, Object?>> query(
    String dataClass, {
    Map<String, String> parameters = const <String, String>{},
  }) async {
    final FourDResponse response = await _send(
      FourDRequest(method: 'GET', uri: uris.dataClass(dataClass, query: parameters)),
    );
    if (!response.isSuccess) {
      throw FourDHttpException(response.statusCode, 'Unable to query $dataClass.');
    }
    final Object? decoded = response.json;
    if (decoded is! Map) {
      throw const FourDProtocolException('A DataClass response must be a JSON object.');
    }
    return decoded.cast<String, Object?>();
  }

  Future<FourDResponse> _send(FourDRequest request) async {
    final Map<String, String> headers = <String, String>{...request.headers};
    final String? cookie = session.cookieHeader;
    if (cookie != null) headers['cookie'] = cookie;
    final FourDResponse response = await _transport.send(
      FourDRequest(method: request.method, uri: request.uri, headers: headers, body: request.body),
    );
    session.updateFrom(response);
    return response;
  }

  FourDTransport _authenticatedTransport() => _ClientTransport(_send);
}

class _ClientTransport implements FourDTransport {
  const _ClientTransport(this._send);
  final Future<FourDResponse> Function(FourDRequest request) _send;
  @override
  Future<FourDResponse> send(FourDRequest request) => _send(request);
}
