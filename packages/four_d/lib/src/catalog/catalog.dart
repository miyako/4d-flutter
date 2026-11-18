import '../errors/four_d_exception.dart';
import '../transport/transport.dart';
import '../uri/rest_uri_builder.dart';

/// Minimal catalog client. Its DTO shape remains intentionally transparent
/// until verified fixtures establish the supported 4D-server versions.
class FourDCatalogClient {
  const FourDCatalogClient(this._transport, this._uris);

  final FourDTransport _transport;
  final RestUriBuilder _uris;

  Future<Map<String, Object?>> fetch() async {
    final FourDResponse response = await _transport.send(
      FourDRequest(method: 'GET', uri: _uris.catalog()),
    );
    if (!response.isSuccess) {
      throw FourDHttpException(response.statusCode, 'Unable to load the 4D catalog.');
    }
    final Object? decoded = response.json;
    if (decoded is! Map) {
      throw const FourDProtocolException('The catalog response must be a JSON object.');
    }
    return decoded.cast<String, Object?>();
  }
}
