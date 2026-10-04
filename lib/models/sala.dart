class Sala {
  const Sala({
    this.id = '',
    required this.nome,
    required this.tipo,
    required this.capacidade,
    this.acessivel = true,
    this.ativa = true,
  });

  final String id;
  final String nome;
  final String tipo;
  final int capacidade;
  final bool acessivel;
  final bool ativa;

  factory Sala.fromMap(String id, Map<String, dynamic> m) => Sala(
    id: id,
    nome: m['nome'] ?? '',
    tipo: m['tipo'] ?? '2D',
    capacidade: (m['capacidade'] ?? 0) as int,
    acessivel: m['acessivel'] ?? true,
    ativa: m['ativa'] ?? true,
  );

  Map<String, dynamic> toMap() => {
    'nome': nome,
    'tipo': tipo,
    'capacidade': capacidade,
    'acessivel': acessivel,
    'ativa': ativa,
  };
}