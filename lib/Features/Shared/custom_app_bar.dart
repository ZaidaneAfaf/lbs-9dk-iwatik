import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  CustomAppBar({Key? key})
      : preferredSize = const Size.fromHeight(60.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDF2F8), // Arrière-plan #FDF2F8
      elevation: 0,
      shadowColor: Colors.black.withOpacity(0.1),
      leading: Container(
        padding: const EdgeInsets.all(6.0), // Padding réduit pour agrandir le logo
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Fond blanc pour faire ressortir le logo
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFE8D5E8),
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Image.asset(
              'assets/images/logo_lbs9dkiwatik.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      actions: [
        // Bouton mode sombre
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFEBEE),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.dark_mode_outlined,
              color: Color(0xFFE91E63),
              size: 22,
            ),
            onPressed: () {},
            tooltip: 'Mode sombre',
          ),
        ),
        
        // Bouton langue
        Container(
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.white, // Fond blanc pour contraster avec l'arrière-plan
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.language_outlined,
              color: Color(0xFF2C3E50),
              size: 22,
            ),
            onPressed: () {},
            tooltip: 'Langue',
          ),
        ),
        
        // Bouton menu
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFE8D5E8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: Color(0xFF2C3E50),
              size: 22,
            ),
            onPressed: () {},
            tooltip: 'Menu',
          ),
        ),
      ],
      // Ligne de séparation en bas
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE8D5E8).withOpacity(0.3),
                const Color(0xFFE8D5E8),
                const Color(0xFFE8D5E8).withOpacity(0.3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}