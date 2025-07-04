import 'package:flutter/material.dart';
import '../../Couturier/screens/couturier_signup_screen.dart';
import '../../Client/screens/client_signup_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final imageSize = size.width * 0.55;

    return Scaffold(
      body: Stack(
        children: [
          // 🎨 Fond rose courbé
          Positioned.fill(
            child: CustomPaint(
              painter: _CurvedBackgroundPainter(),
            ),
          ),

          // Logo centré en haut
          Positioned(
            top: size.height * 0.06,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/logo_lbs9dkiwatik.png',
                width: size.width * 0.65,
                height: size.height * 0.13,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 🧵 Image Couturier à droite
          Positioned(
            top: size.height * 0.20,
            right: size.width * 0.04,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CouturierSignupScreen(),
                  ),
                );
              },
              child: Transform.rotate(
                angle: 0.05,
                child: Image.asset(
                  'assets/images/couturier.png',
                  width: imageSize,
                  height: imageSize,
                ),
              ),
            ),
          ),

          // 👤 Image Client à gauche
          Positioned(
            top: size.height * 0.58,
            left: size.width * 0.04,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClientSignupScreen(),
                  ),
                );
              },
              child: Transform.rotate(
                angle: -0.05,
                child: Image.asset(
                  'assets/images/client.png',
                  width: imageSize,
                  height: imageSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 🎨 Fond rose avec courbe
class _CurvedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFE0E5)
      ..style = PaintingStyle.fill;

    final sx = size.width / 390;
    final sy = size.height / 841;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..cubicTo(
        6.37827 * sx,
        103.766 * sy,
        -5.57867 * sx,
        416.983 * sy,
        187.646 * sx,
        416.983 * sy,
      )
      ..cubicTo(
        380.871 * sx,
        416.983 * sy,
        size.width,
        size.height,
        size.width,
        size.height,
      )
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
