import 'package:flutter/material.dart';

abstract final class Formatters {
  static String data(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  static String horario(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  static String moeda(double v) =>
      'R\$ ${v.toStringAsFixed(2).replaceAll('.', ',')}';
}
