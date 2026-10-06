import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/filme.dart';
import '../models/sala.dart';
import '../models/sessao.dart';

abstract class Repository<T> {
  Repository(this.collection);
  final String collection;

  T fromMap(String id, Map<String, dynamic> map);
  Map<String, dynamic> toMap(T item);
  int Function(T a, T b)? get sorter => null;

  CollectionReference<Map<String, dynamic>> get col => FirebaseFirestore
      .instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection(collection);

  List<T> _parse(QuerySnapshot<Map<String, dynamic>> snap) {
    final lista = snap.docs.map((d) => fromMap(d.id, d.data())).toList();
    final ordem = sorter;
    if (ordem != null) lista.sort(ordem);
    return lista;
  }

  Stream<List<T>> watchAll() => col.snapshots().map(_parse);
  Future<List<T>> getAll() async => _parse(await col.get());
  Stream<int> watchCount() => col.snapshots().map((s) => s.size);

  Stream<T?> watchById(String id) => col
      .doc(id)
      .snapshots()
      .map((d) => d.exists ? fromMap(d.id, d.data()!) : null);

  Future<T?> getById(String id) async {
    final d = await col.doc(id).get();
    return d.exists ? fromMap(d.id, d.data()!) : null;
  }

  Future<void> save(T item, {String? id}) async {
    if (id == null) {
      await col.add(toMap(item));
    } else {
      await col.doc(id).set(toMap(item));
    }
  }

  Future<void> delete(String id) => col.doc(id).delete();
}

class FilmeRepository extends Repository<Filme> {
  FilmeRepository._() : super('filmes');
  static final instance = FilmeRepository._();

  @override
  Filme fromMap(String id, Map<String, dynamic> m) => Filme.fromMap(id, m);
  @override
  Map<String, dynamic> toMap(Filme f) => f.toMap();
  @override
  int Function(Filme, Filme)? get sorter =>
      (a, b) => a.titulo.toLowerCase().compareTo(b.titulo.toLowerCase());
}

class SalaRepository extends Repository<Sala> {
  SalaRepository._() : super('salas');
  static final instance = SalaRepository._();

  @override
  Sala fromMap(String id, Map<String, dynamic> m) => Sala.fromMap(id, m);
  @override
  Map<String, dynamic> toMap(Sala s) => s.toMap();
  @override
  int Function(Sala, Sala)? get sorter =>
      (a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
}

class SessaoRepository extends Repository<Sessao> {
  SessaoRepository._() : super('sessoes');
  static final instance = SessaoRepository._();

  @override
  Sessao fromMap(String id, Map<String, dynamic> m) => Sessao.fromMap(id, m);
  @override
  Map<String, dynamic> toMap(Sessao s) => s.toMap();
  @override
  int Function(Sessao, Sessao)? get sorter =>
      (a, b) => a.inicio.compareTo(b.inicio);

  Future<void> setVendidos(String id, int valor) =>
      col.doc(id).update({'vendidos': valor});
}
