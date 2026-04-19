import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../theme/app_theme.dart';
import 'input_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _particleController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _cardOpacity;
  late Animation<Offset> _cardSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _textController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _particleController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();

    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _logoController,
            curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(parent: _textController, curve: Curves.easeOut));
    _cardOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _textController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeIn)));
    _cardSlide =
        Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _textController,
                curve:
                    const Interval(0.4, 1.0, curve: Curves.easeOut)));

    _logoController.forward().then((_) => _textController.forward());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.primaryGradient),
        child: Stack(
          children: [
            // Animated particles
            AnimatedBuilder(
              animation: _particleController,
              builder: (context, _) => CustomPaint(
                painter: _ParticlePainter(_particleController.value),
                size: MediaQuery.of(context).size,
              ),
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Logo
                    ScaleTransition(
                      scale: _logoScale,
                      child: FadeTransition(
                        opacity: _logoOpacity,
                        child: _buildLogoIcon(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Title
                    SlideTransition(
                      position: _textSlide,
                      child: FadeTransition(
                        opacity: _textOpacity,
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: 52,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -1.5,
                                  color: Colors.white,
                                  fontFamily: 'Outfit',
                                ),
                                children: [
                                  const TextSpan(text: 'ℇ_'),
                                  TextSpan(
                                      text: 'Angle',
                                      style: TextStyle(
                                          color: const Color(0xFFA8C4E8))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ENGINEERED ANGLE SECTION SELECTOR',
                              style: TextStyle(
                                color: const Color(0xFFA8C4E8),
                                fontSize: 12,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Dev Card
                    SlideTransition(
                      position: _cardSlide,
                      child: FadeTransition(
                        opacity: _cardOpacity,
                        child: _buildDevCard(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _cardOpacity,
                      child: _buildLaunchButton(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white.withOpacity(0.12),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent2.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(painter: _AnglePainter()),
    );
  }

  Widget _buildDevCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'DEVELOPED BY',
            style: TextStyle(
              color: const Color(0xFFC8D8F0),
              fontSize: 10,
              letterSpacing: 3,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _devName('1.  S. Sriharithra'),
          _devName('2.  S. Veerapathira Hariharan'),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withOpacity(0.15)),
          const SizedBox(height: 6),
          Text(
            'Guided by Dr. S. Arul Mary',
            style: TextStyle(
              color: const Color(0xFFA8C4E8),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _devName(String name) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  Widget _buildLaunchButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, a, __) => const InputScreen(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 1.5),
          color: Colors.white.withOpacity(0.12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Launch Application',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_rounded,
                color: Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the angle section logo
class _AnglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Angle symbol
    paint.color = const Color(0xFFA8C4E8);
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.lineTo(size.width * 0.5, size.height * 0.2);
    path.lineTo(size.width * 0.8, size.height * 0.8);
    canvas.drawPath(path, paint);

    // Cross bar
    paint.color = Colors.white;
    canvas.drawLine(Offset(size.width * 0.33, size.height * 0.55),
        Offset(size.width * 0.67, size.height * 0.55), paint);

    // Top dot
    paint.style = PaintingStyle.fill;
    paint.color = const Color(0xFFA8C4E8);
    canvas.drawCircle(
        Offset(size.width * 0.5, size.height * 0.2), 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Floating particles
class _ParticlePainter extends CustomPainter {
  final double progress;
  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.04);
    final rand = math.Random(42);
    for (int i = 0; i < 20; i++) {
      final x = rand.nextDouble() * size.width;
      final baseY = rand.nextDouble() * size.height;
      final y = (baseY + progress * size.height * 0.3 * (i % 3 + 1)) %
          size.height;
      final r = rand.nextDouble() * 4 + 2;
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) => old.progress != progress;
}
