import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Shared/navbar_buttom.dart';
import '../../Shared/custom_app_bar.dart';
import '../controllers/model_controller.dart';
import 'models_list_screen.dart';

class CouturierHomePage extends StatefulWidget {
  const CouturierHomePage({Key? key}) : super(key: key);

  @override
  State<CouturierHomePage> createState() => _CouturierHomePageState();
}

class _CouturierHomePageState extends State<CouturierHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const ModelsListScreen(),
    const MessagesPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF2F8),
      appBar: CustomAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// Page Messages avec le même style
class MessagesPage extends StatelessWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFE8D5E8),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.message_outlined,
              size: 64,
              color: Color(0xFFE91E63),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Messages Couturier',
            style: TextStyle(
              color: Color(0xFF2C3E50),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vos conversations apparaîtront ici',
            style: TextStyle(
              color: Color(0xFF7F8C8D),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 48,
                  color: Color(0xFFE91E63),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Aucune conversation',
                  style: TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Commencez à échanger avec vos clients',
                  style: TextStyle(
                    color: Color(0xFF7F8C8D),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Page Profil avec le même style
class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // En-tête du profil
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8D5E8),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Color(0xFFE91E63),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Profil Couturier',
                  style: TextStyle(
                    color: Color(0xFF2C3E50),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gérez vos informations personnelles',
                  style: TextStyle(
                    color: Color(0xFF7F8C8D),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Options du profil
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildProfileOption(
                  icon: Icons.edit,
                  title: 'Modifier le profil',
                  subtitle: 'Changez vos informations',
                  onTap: () {},
                ),
                const Divider(color: Color(0xFFE8D5E8), height: 1),
                _buildProfileOption(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  subtitle: 'Préférences de l\'application',
                  onTap: () {},
                ),
                const Divider(color: Color(0xFFE8D5E8), height: 1),
                _buildProfileOption(
                  icon: Icons.help_outline,
                  title: 'Aide',
                  subtitle: 'Support et FAQ',
                  onTap: () {},
                ),
                const Divider(color: Color(0xFFE8D5E8), height: 1),
                _buildProfileOption(
                  icon: Icons.logout,
                  title: 'Déconnexion',
                  subtitle: 'Se déconnecter du compte',
                  onTap: () {},
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDestructive 
                      ? const Color(0xFFFFEBEE) 
                      : const Color(0xFFFDF2F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: isDestructive 
                      ? Colors.red 
                      : const Color(0xFFE91E63),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isDestructive 
                            ? Colors.red 
                            : const Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF7F8C8D),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Color(0xFF7F8C8D),
              ),
            ],
          ),
        ),
      ),
    );
  }
}