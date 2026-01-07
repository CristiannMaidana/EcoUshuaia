import 'package:flutter/material.dart';

class AddressListItem extends StatelessWidget {
  final String title;
  final Widget? dragHandle;

  const AddressListItem({
    super.key,
    required this.title,
    this.dragHandle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        leading: dragHandle,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: CircleAvatar(
          radius: 16,
          backgroundColor: Colors.blueGrey.shade50,
          child: const Icon(Icons.place, color: Colors.black87, size: 18),
        ),
      ),
    );
  }
}