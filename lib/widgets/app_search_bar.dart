import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final VoidCallback onSearch;
  final bool isLoading;
  final ValueChanged<String>? onChanged;

  const AppSearchBar({
    super.key,
    this.controller,
    required this.hint,
    required this.onSearch,
    this.isLoading = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      onFieldSubmitted: (_) => onSearch(),
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: IconButton(
          onPressed: isLoading ? null : onSearch,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.search),
        ),
      ),
    );
  }
}
