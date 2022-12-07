import 'package:flutter_test/flutter_test.dart';
import 'package:masterclass_api/app/repository/anime_repository.dart';

void main() {
  test('Test Api Anime', () async {
    final repository = AnimeRepository();

    final result = await repository.search();

    expect(result.length, 10);
  });
}
