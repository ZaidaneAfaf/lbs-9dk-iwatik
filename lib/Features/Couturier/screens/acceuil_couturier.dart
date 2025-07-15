import 'package:flutter/material.dart';
import '../../Shared/navbar_buttom.dart';
import '../../Shared/custom_app_bar.dart';


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

  final List<Widget> _pages = const [
    Center(child: Text('Mes Travaux')),
    Center(child: Text('Messages Couturier')),
    Center(child: Text('Profil Couturier')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}