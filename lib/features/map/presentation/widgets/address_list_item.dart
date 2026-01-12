import 'package:flutter/material.dart';

class AddressListItem extends StatelessWidget {
  final String title;
  final String direccion;
  final Widget dragHandle;

  const AddressListItem({
    super.key,
    required this.title,
    required this.dragHandle,
    required this.direccion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        leading: CircleAvatar(
          radius: 18,
          backgroundColor: Colors.green.shade100,
          child: const Icon(Icons.place, color: Colors.green),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(direccion, style: Theme.of(context).textTheme.titleSmall,)
          ],
        ),
        trailing: dragHandle,
      ),
    );
  }
}