import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 6,
      shadowColor: Colors.black.withOpacity(0.3),
      leading: Padding(
        padding: const EdgeInsets.only(left: 8.0), // ✅ Padding uniquement à gauche
        child: Image.asset(
          'assets/images/logo_lbs9dkiwatik.png',
          fit: BoxFit.contain,
          height: 50,
          width: 50,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.dark_mode, color: Colors.red),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.language, color: Colors.black54),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
      ],
    );
  }
}
