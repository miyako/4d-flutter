import 'package:four_d/four_d.dart';
import 'package:test/test.dart';

void main() {
  final RestUriBuilder uris = RestUriBuilder(
    FourDConfig(serverUri: Uri.parse('https://four-d.example/base/')),
  );

  test('builds a catalog URI without string concatenation', () {
    expect(uris.catalog().toString(), 'https://four-d.example/base/rest/%24catalog');
  });

  test('encodes query values exactly once', () {
    final Uri uri = uris.dataClass('People', query: <String, String>{r'$filter': "name = 'A & B'"});
    expect(uri.queryParameters[r'$filter'], "name = 'A & B'");
    expect(uri.toString(), contains('%24filter='));
    expect(uri.toString(), contains('A+%26+B'));
  });
}
