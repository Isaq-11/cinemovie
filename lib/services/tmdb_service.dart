import 'dart:convert';
import 'package:http/http.dart' as http;

class TmdbMovie {
  const TmdbMovie({
    required this.id,
    required this.titulo,
    required this.sinopse,
    this.poster,
    this.ano,
    this.genero,
  });

  final int id;
  final String titulo;
  final String sinopse;
  final String? poster;
  final String? ano;
  final String? genero; 
}

class TmdbService {
  static const _key = String.fromEnvironment('TMDB_KEY');
  static const _host = 'api.themoviedb.org';

  static const _generos = {
    28: 'Ação',
    12: 'Aventura',
    16: 'Animação',
    35: 'Comédia',
    99: 'Documentário',
    18: 'Drama',
    878: 'Ficção científica',
    10749: 'Romance',
    27: 'Terror',
  };

  static void _checarChave() {
    if (_key.isEmpty) {
      throw Exception(
        'TMDB_KEY ausente. Rode com --dart-define-from-file=env.json',
      );
    }
  }

  static Future<List<TmdbMovie>> buscar(String titulo) async {
    _checarChave();
    final res = await http
        .get(
          Uri.https(_host, '/3/search/movie', {
            'api_key': _key,
            'query': titulo,
            'language': 'pt-BR',
            'include_adult': 'false',
          }),
        )
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) throw Exception('TMDB: ${res.statusCode}');

    final lista = jsonDecode(res.body)['results'] as List;
    return lista.take(15).map((j) {
      final data = (j['release_date'] ?? '') as String;
      final ids = ((j['genre_ids'] ?? []) as List).cast<int>();
      final path = j['poster_path'] as String?;
      return TmdbMovie(
        id: j['id'] as int,
        titulo: j['title'] ?? '',
        sinopse: j['overview'] ?? '',
        poster: path == null ? null : 'https://image.tmdb.org/t/p/w500$path',
        ano: data.length >= 4 ? data.substring(0, 4) : null,
        genero: ids.map((i) => _generos[i]).whereType<String>().firstOrNull,
      );
    }).toList();
  }

  static Future<int?> duracao(int id) async {
    _checarChave();
    final res = await http
        .get(
          Uri.https(_host, '/3/movie/$id', {
            'api_key': _key,
            'language': 'pt-BR',
          }),
        )
        .timeout(const Duration(seconds: 10));
    if (res.statusCode != 200) return null;
    final runtime = jsonDecode(res.body)['runtime'];
    return runtime is int && runtime > 0 ? runtime : null;
  }
}
