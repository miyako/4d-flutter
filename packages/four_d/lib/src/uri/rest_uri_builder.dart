import '../config/four_d_config.dart';

/// Centralizes REST URI construction and prevents path/query encoding drift.
class RestUriBuilder {
  RestUriBuilder(FourDConfig config)
      : _baseSegments = <String>[
          ...config.serverUri.pathSegments.where((String item) => item.isNotEmpty),
          ...config.restPath.split('/').where((String item) => item.isNotEmpty),
        ],
        _authority = config.serverUri;

  final Uri _authority;
  final List<String> _baseSegments;

  Uri catalog() => resource(r'$catalog');

  Uri dataClass(String name, {Map<String, String>? query}) =>
      resource(name, query: query);

  Uri entity(String dataClassName, String key, {Map<String, String>? query}) =>
      resource('$dataClassName($key)', query: query);

  Uri resource(String resource, {Map<String, String>? query}) {
    if (resource.isEmpty) {
      throw ArgumentError.value(resource, 'resource', 'must not be empty');
    }
    return _authority.replace(
      pathSegments: <String>[..._baseSegments, resource],
      queryParameters: query,
    );
  }
}
