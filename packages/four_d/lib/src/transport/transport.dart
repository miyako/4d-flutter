import 'dart:convert';

/// A deliberately small transport boundary; applications may provide Dio,
/// `package:http`, a browser, or a test implementation without changing ORDA code.
abstract interface class FourDTransport {
  Future<FourDResponse> send(FourDRequest request);
}

class FourDRequest {
  const FourDRequest({
    required this.method,
    required this.uri,
    this.headers = const <String, String>{},
    this.body,
  });

  final String method;
  final Uri uri;
  final Map<String, String> headers;
  final Object? body;

  String? get encodedJsonBody => body == null ? null : jsonEncode(body);
}

class FourDResponse {
  const FourDResponse({
    required this.statusCode,
    this.headers = const <String, List<String>>{},
    this.body = '',
  });

  final int statusCode;
  final Map<String, List<String>> headers;
  final String body;

  bool get isSuccess => statusCode >= 200 && statusCode < 300;

  Object? get json => body.isEmpty ? null : jsonDecode(body);
}
