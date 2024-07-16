import 'package:flutter/material.dart';
import 'package:synctours/screens/user/search_results.dart';
import 'package:synctours/theme/colors.dart';

class RecentSearchItem extends StatelessWidget {
  final String query;

  const RecentSearchItem({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchResults(query: query),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  query,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.search, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
