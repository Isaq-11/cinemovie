import 'package:flutter/material.dart';
import 'empty_state.dart';

class DataStream<T> extends StatelessWidget {
  const DataStream({super.key, required this.stream, required this.builder});

  final Stream<T> stream;
  final Widget Function(BuildContext context, T data) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T>(
      stream: stream,
      builder: (context, snap) {
        if (snap.hasError) {
          debugPrint('DataStream erro: ${snap.error}');
          return const EmptyState(
            icon: Icons.cloud_off_outlined,
            title: 'Erro ao carregar',
            message: 'Verifique sua conexão e tente novamente.',
          );
        }
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return builder(context, snap.data as T);
      },
    );
  }
}
