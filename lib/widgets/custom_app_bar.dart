import 'package:flutter/material.dart';
import 'package:synctours/screens/user/profile.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/widgets/brand_name.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar(
      {super.key, required this.title, required List<IconButton> actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu),
            color: AppColors.buttonText,
            onPressed: () {
              Scaffold.of(context)
                  .openDrawer(); // Open drawer from the left side
            },
          ),
          const SizedBox(width: 8.0),
          brandName(title),
        ],
      ),
      backgroundColor: AppColors.primary,
      automaticallyImplyLeading: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle_outlined),
          color: AppColors.buttonText,
          onPressed: () {
            // Open profile page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Profile()),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
