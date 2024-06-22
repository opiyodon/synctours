import 'package:flutter/material.dart';
import 'package:synctours/theme/colors.dart';
import 'package:synctours/widgets/brand_name.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

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
          brandName(),
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
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
