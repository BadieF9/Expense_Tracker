import 'package:expense_tracking_app/dialogs/add_tag_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:expense_tracking_app/models/tag.dart';
import 'package:expense_tracking_app/providers/expense_provider.dart';

class TagManagementScreen extends StatelessWidget {
  const TagManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpenseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tags'),
      ),
      body: ListView.builder(
        itemCount: provider.tags.length,
        itemBuilder: (context, index) {
          final tag = provider.tags[index];
          return ListTile(
            title: Text(tag.name),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                provider.removeTag(tag.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? tagName = await showDialog(
              context: context, builder: (context) => const AddTagDialog());
          if (tagName != null) {
            final tag = Tag(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: tagName,
            );
            provider.addTag(tag);
          }
        },
        tooltip: 'Add Tag',
        child: const Icon(Icons.add),
      ),
    );
  }
}
