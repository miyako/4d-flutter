import 'dart:async';

import 'package:four_d/four_d.dart';
import 'package:test/test.dart';

void main() {
  test('retains session cookies and serializes concurrent authentication', () async {
    final FourDSessionManager session = FourDSessionManager();
    final Completer<FourDResponse> completion = Completer<FourDResponse>();
    var calls = 0;

    Future<FourDResponse> authenticate() {
      calls += 1;
      return completion.future;
    }

    final Future<void> first = session.authenticate(authenticate);
    final Future<void> second = session.authenticate(authenticate);
    expect(session.state, FourDSessionState.authenticating);
    expect(calls, 1);

    completion.complete(const FourDResponse(
      statusCode: 200,
      headers: <String, List<String>>{'set-cookie': <String>['4DSID=abc; Path=/']},
    ));
    await Future.wait(<Future<void>>[first, second]);

    expect(session.state, FourDSessionState.authenticated);
    expect(session.cookieHeader, '4DSID=abc');
  });
}
