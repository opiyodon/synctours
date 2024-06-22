import 'package:flutter/material.dart';

class RecentSearchItem extends StatelessWidget {
  final String query;

  const RecentSearchItem({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(query),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
