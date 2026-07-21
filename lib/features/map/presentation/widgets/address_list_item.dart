import 'package:eco_ushuaia/core/theme/theme.dart';
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
      color: Color.fromRGBO(249, 249, 249, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        leading: CircleAvatar(
          radius: 25,
          backgroundColor: camarone100,
          child: const Icon(Icons.place, color: camarone700, size: 25,),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600,),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text('Direccion: $direccion', style: Theme.of(context).textTheme.labelMedium,)
          ],
        ),
        trailing: dragHandle,
      ),
    );
  }
}