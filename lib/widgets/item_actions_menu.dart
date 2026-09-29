import 'package:flutter/material.dart';

class ItemActionsMenu extends StatelessWidget {
  const ItemActionsMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;

          case 'delete':
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'edit',
          child: ListTile(
            leading: Icon(Icons.edit_outlined),
            title: Text('Editar'),
            contentPadding: EdgeInsets.zero,
          ),
        ),

        const PopupMenuItem(
          value: 'delete',
          child: ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Excluir'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
