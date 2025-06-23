import 'package:flutter/material.dart';
import 'signup_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFF8BBD9), // Rose plus intense en haut
              Color(0xFFFFE4F1), // Rose très clair
              Color(0xFFFFFFFF), // Blanc en bas
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              child: Column(
                children: [
                  // Header avec logo
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        // Logo de l'application
                        Image.asset(
                          'assets/images/logo_lbs9dkiwatik.png',
                          height: 80,
                          width: 150,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  
                  // Section Couturier
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(userType: 'couturier'),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image/icône du couturier
                                Flexible(
                                  child: Image.asset(
                                    'assets/images/couturier_logo.png',
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                
                                const SizedBox(height: 15),
                                
                                // Titre "Couturier"
                                const Text(
                                  'Couturier',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE91E63),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Forme ondulée de séparation
                  SizedBox(
                    height: 80,
                    child: CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 80),
                      painter: WavePainter(),
                    ),
                  ),
                  
                  // Section Client
                  Expanded(
                    flex: 2,
                    child: Container(
                      width: double.infinity,
                      color: Colors.white,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(userType: 'client'),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Image des silhouettes client
                                Flexible(
                                  child: Image.asset(
                                    'assets/images/client_logo.png',
                                    height: 80,
                                    width: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                
                                const SizedBox(height: 15),
                                
                                // Titre "Client"
                                const Text(
                                  'Client',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D2D2D),
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // Bouton retour
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Déjà un compte ? Se connecter',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter pour créer la forme ondulée
class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Commencer du coin gauche
    path.moveTo(0, size.height);
    
    // Créer la courbe ondulée
    path.quadraticBezierTo(
      size.width * 0.25, 0,  // Point de contrôle
      size.width * 0.5, 15,  // Point final de la première courbe
    );
    
    path.quadraticBezierTo(
      size.width * 0.75, 30,  // Point de contrôle
      size.width, 0,          // Point final - coin droit
    );
    
    // Ligne vers le coin inférieur droit
    path.lineTo(size.width, size.height);
    
    // Fermer le chemin
    path.close();
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}