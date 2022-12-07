import 'package:dio/dio.dart';
import 'package:masterclass_api/app/model/anime_model.dart';

class AnimeRepository {
  final dio = Dio();

  Future<List<AnimeModel>> search({int page = 1}) async {
    final URL =
        'https://www.intoxianime.com/?rest_route=/wp/v2/posts&page=$page&per_page=10';
    try {
      final result = await dio.get(URL);
      final data = result.data as List;
      if (data.isEmpty) return [];
      return data
          .map((map) => AnimeModel.fromMap(map as Map<String, dynamic>))
          .toList();
    } on DioError {
      rethrow;
    }
  }
}
