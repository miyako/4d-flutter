/// Immutable configuration for a [FourDClient].
class FourDConfig {
  const FourDConfig({
    required this.serverUri,
    this.restPath = 'rest',
    this.requestTimeout = const Duration(seconds: 30),
  }) : assert(restPath != '');

  /// Base URI of the 4D server, for example `https://example.test/`.
  final Uri serverUri;

  /// The REST mount path. This is normally `rest`.
  final String restPath;

  /// Default timeout applied by a concrete transport.
  final Duration requestTimeout;
}
