import 'package:cine_movie/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CineMovie());
}

class CineMovie extends StatelessWidget {
  const CineMovie({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineGestão',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const Scaffold(
        body: Center(child: Text('CineMovie Inicializado!')),
      ),
        //home: const FilmeFormScreen(),
    );
  }
}
