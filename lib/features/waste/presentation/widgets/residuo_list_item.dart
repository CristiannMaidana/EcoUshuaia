import 'package:flutter/material.dart';
import '../../domain/entities/residuo.dart';

class ResiduoListItem extends StatelessWidget {
  final Residuo item;
  const ResiduoListItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildLeading(),
      title: Text(item.nombre),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.categoria != null && item.categoria!.isNotEmpty)
          Text('Categoría: ${item.categoria!}'),
          if (item.peso != null) Text('Peso: ${item.peso!.toStringAsFixed(2)} kg'),
          if (item.descripcion != null && item.descripcion!.isNotEmpty)
          Text(
            item.descripcion!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      isThreeLine: true,
    );
  }

  Widget _buildLeading() {
    if (item.imagen != null && item.imagen!.isNotEmpty) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        item.imagen!,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      ),
    );
    }
    return const CircleAvatar(child: Icon(Icons.recycling));
  }
}