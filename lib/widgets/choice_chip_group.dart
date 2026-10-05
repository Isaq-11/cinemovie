import 'package:flutter/material.dart';

class ChoiceChipGroup extends StatelessWidget {
  final String? label;
  final List<String> options;
  final String? selected;
  final ValueChanged<String> onSelected;
  final Color? selectedColor;
  final WrapAlignment? wrapAlignment;

  const ChoiceChipGroup({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.label,
    this.selectedColor,
    this.wrapAlignment = WrapAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
        ],
        SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: wrapAlignment!,
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              return ChoiceChip(
                label: Text(option),
                selected: selected == option,
                selectedColor: selectedColor,
                onSelected: (_) {
                  onSelected(option);
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
