/// Base type for all errors raised by this package.
sealed class FourDException implements Exception {
  const FourDException(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// A response could not be decoded as the documented 4D wire format.
final class FourDProtocolException extends FourDException {
  const FourDProtocolException(super.message, {super.cause});
}

/// The server rejected authentication or the active session is no longer valid.
final class FourDAuthenticationException extends FourDException {
  const FourDAuthenticationException(super.message, {super.cause});
}

/// An HTTP request completed with an unsuccessful status code.
final class FourDHttpException extends FourDException {
  const FourDHttpException(this.statusCode, super.message, {super.cause});

  final int statusCode;
}

/// A client operation was attempted in an invalid lifecycle state.
final class FourDStateException extends FourDException {
  const FourDStateException(super.message, {super.cause});
}
