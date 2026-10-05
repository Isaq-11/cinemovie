import 'package:flutter/material.dart';

import 'info_card.dart';
import 'info_chip.dart';
import 'occupancy_bar.dart';
import 'poster_preview.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({
    super.key,
    required this.filmeTitulo,
    required this.sala,
    required this.horario,
    required this.vendidos,
    required this.capacidade,
    this.posterUrl,
    this.data,
    this.formato,
    this.idioma,
    this.onTap,
    this.trailing,
  });

  final String filmeTitulo;
  final String sala;
  final String horario;
  final int vendidos;
  final int capacidade;
  final String? posterUrl;
  final String? data;
  final String? formato;
  final String? idioma;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      sala,
      if (data != null) '$data $horario',
      if (data == null) horario,
    ].join(' • ');

    return InfoCard(
      title: filmeTitulo,

      subtitle: subtitle,

      leading: PosterPreview(imageUrl: posterUrl, width: 70),

      chips: [
        if (formato != null) InfoChip(label: formato!),
        if (idioma != null) InfoChip(label: idioma!),
      ],

      footer: OccupancyBar(current: vendidos, total: capacidade),

      onTap: onTap,
    );
  }
}
