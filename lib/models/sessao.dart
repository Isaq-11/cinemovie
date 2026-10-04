import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/formatters.dart';

class Sessao {
  const Sessao({
    this.id = '',
    required this.filmeId,
    required this.filme,
    this.poster,
    required this.salaId,
    required this.sala,
    required this.capacidade,
    required this.inicio,
    required this.formato,
    required this.idioma,
    required this.preco,
    this.vendidos = 0,
  });

  final String id;
  final String filmeId;
  final String filme; // título (copiado do filme)
  final String? poster;
  final String salaId;
  final String sala; // nome (copiado da sala)
  final int capacidade;
  final DateTime inicio;
  final String formato;
  final String idioma;
  final double preco;
  final int vendidos;

  String get horario => Formatters.horario(TimeOfDay.fromDateTime(inicio));

  String get data {
    final agora = DateTime.now();
    final hoje = DateTime(agora.year, agora.month, agora.day);
    final dia = DateTime(inicio.year, inicio.month, inicio.day);
    final diff = dia.difference(hoje).inDays;
    if (diff == 0) return 'Hoje';
    if (diff == 1) return 'Amanhã';
    return Formatters.data(inicio);
  }

  factory Sessao.fromMap(String id, Map<String, dynamic> m) => Sessao(
    id: id,
    filmeId: m['filmeId'] ?? '',
    filme: m['filme'] ?? '',
    poster: m['poster'],
    salaId: m['salaId'] ?? '',
    sala: m['sala'] ?? '',
    capacidade: (m['capacidade'] ?? 0) as int,
    inicio: (m['inicio'] as Timestamp).toDate(),
    formato: m['formato'] ?? '2D',
    idioma: m['idioma'] ?? 'Dublado',
    preco: ((m['preco'] ?? 0) as num).toDouble(),
    vendidos: (m['vendidos'] ?? 0) as int,
  );

  Map<String, dynamic> toMap() => {
    'filmeId': filmeId,
    'filme': filme,
    'poster': poster,
    'salaId': salaId,
    'sala': sala,
    'capacidade': capacidade,
    'inicio': Timestamp.fromDate(inicio),
    'formato': formato,
    'idioma': idioma,
    'preco': preco,
    'vendidos': vendidos,
  };
}