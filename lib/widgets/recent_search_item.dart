import 'package:flutter/material.dart';
import 'package:synctours/screens/user/search_results.dart';

class RecentSearchItem extends StatelessWidget {
  final String query;

  const RecentSearchItem({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(query),
      trailing: const Icon(Icons.search),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResults(query: query),
          ),
        );
      },
    );
  }
}