typedef FilmeMock = ({
  String titulo,
  String genero,
  int duracao,
  String classificacao,
  String? poster,
});
typedef SalaMock = ({
  String nome,
  String tipo,
  int capacidade,
  bool acessivel,
  bool ativa,
});
typedef SessaoMock = ({
  String filme,
  String? poster,
  String sala,
  String data,
  String horario,
  String formato,
  String idioma,
  double preco,
  int vendidos,
  int capacidade,
});

const List<FilmeMock> mockFilmes = [
  (
    titulo: 'Duna: Parte Dois',
    genero: 'Ficção científica',
    duracao: 166,
    classificacao: '14',
    poster: null,
  ),
  (
    titulo: 'Divertida Mente 2',
    genero: 'Animação',
    duracao: 96,
    classificacao: 'L',
    poster: null,
  ),
  (
    titulo: 'Oppenheimer',
    genero: 'Drama',
    duracao: 180,
    classificacao: '16',
    poster: null,
  ),
];

const List<SalaMock> mockSalas = [
  (nome: 'Sala 1', tipo: '2D', capacidade: 80, acessivel: true, ativa: true),
  (nome: 'Sala 2', tipo: '3D', capacidade: 120, acessivel: true, ativa: true),
  (
    nome: 'Sala 3',
    tipo: 'IMAX',
    capacidade: 200,
    acessivel: false,
    ativa: false,
  ),
];

const List<SessaoMock> mockSessoes = [
  (
    filme: 'Duna: Parte Dois',
    poster: null,
    sala: 'Sala 3',
    data: 'Hoje',
    horario: '19:30',
    formato: 'IMAX',
    idioma: 'Legendado',
    preco: 45.0,
    vendidos: 185,
    capacidade: 200,
  ),
  (
    filme: 'Divertida Mente 2',
    poster: null,
    sala: 'Sala 1',
    data: 'Hoje',
    horario: '16:00',
    formato: '2D',
    idioma: 'Dublado',
    preco: 28.0,
    vendidos: 42,
    capacidade: 80,
  ),
  (
    filme: 'Oppenheimer',
    poster: null,
    sala: 'Sala 2',
    data: 'Amanhã',
    horario: '21:00',
    formato: '3D',
    idioma: 'Legendado',
    preco: 35.0,
    vendidos: 84,
    capacidade: 120,
  ),
];
