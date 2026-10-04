class Filme {
  const Filme({
    this.id = '',
    required this.titulo,
    required this.genero,
    required this.duracao,
    required this.classificacao,
    this.sinopse = '',
    this.poster,
  });

  final String id;
  final String titulo;
  final String genero;
  final int duracao;
  final String classificacao;
  final String sinopse;
  final String? poster;

  factory Filme.fromMap(String id, Map<String, dynamic> m) => Filme(
    id: id,
    titulo: m['titulo'] ?? '',
    genero: m['genero'] ?? '',
    duracao: (m['duracao'] ?? 0) as int,
    classificacao: m['classificacao'] ?? 'L',
    sinopse: m['sinopse'] ?? '',
    poster: m['poster'],
  );

  Map<String, dynamic> toMap() => {
    'titulo': titulo,
    'genero': genero,
    'duracao': duracao,
    'classificacao': classificacao,
    'sinopse': sinopse,
    'poster': poster,
  };
}