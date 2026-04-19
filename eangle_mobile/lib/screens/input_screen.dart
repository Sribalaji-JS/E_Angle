import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../services/api_service.dart';
import '../models/models.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _capacityController = TextEditingController();
  final _boltsController = TextEditingController();
  int _selectedRows = 1;
  bool _isLoading = false;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
            CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _capacityController.dispose();
    _boltsController.dispose();
    super.dispose();
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await ApiService.recommend(
        targetCapacity: double.parse(_capacityController.text),
        bolts: int.parse(_boltsController.text),
        rows: _selectedRows,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, a, __) => ResultScreen(
            result: result,
            inputCapacity: double.parse(_capacityController.text),
            inputBolts: int.parse(_boltsController.text),
            inputRows: _selectedRows,
          ),
          transitionsBuilder: (_, anim, __, child) => SlideTransition(
            position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0), end: Offset.zero)
                .animate(
                    CurvedAnimation(parent: anim, curve: Curves.easeOutCubic)),
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Deep slate foundation
      body: Stack(
        children: [
          // 1. Dynamic Background Layer
          const _GlassBackground(),

          // 2. Content Layer
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildInputCard(),
                            const SizedBox(height: 32),
                            _buildCalculateButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _buildGlassFAB() {
  //   return ClipRRect(
  //     borderRadius: BorderRadius.circular(30),
  //     child: BackdropFilter(
  //       filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
  //       child: Container(
  //         width: 60,
  //         height: 60,
  //         decoration: BoxDecoration(
  //           color: Colors.white.withOpacity(0.1),
  //           borderRadius: BorderRadius.circular(30),
  //           border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
  //         ),
  //         child: IconButton(
  //           icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
  //           onPressed: () {},
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildHeader() {
    return ClipRRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withOpacity(0.6),
            border: Border(
                bottom:
                    BorderSide(color: Colors.white.withOpacity(0.1), width: 1)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  // Glass Logo
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withOpacity(0.15),
                          Colors.white.withOpacity(0.05)
                        ],
                      ),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.2), width: 1),
                    ),
                    child: CustomPaint(
                      painter: _MiniAnglePainter(),
                      size: const Size(46, 46),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                          children: [
                            TextSpan(text: 'ℇ_'),
                            TextSpan(
                              text: 'Angle',
                              style: TextStyle(color: Color(0xFF7DD3FC)),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'ENGINEERED ANGLE SECTION SELECTOR',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Modern AI Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF7DD3FC).withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.auto_awesome, color: Color(0xFF7DD3FC), size: 10),
                        const SizedBox(width: 5),
                        const Text(
                          'AI ACTIVE',
                          style: TextStyle(
                            color: Color(0xFF7DD3FC),
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
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


  Widget _buildInputCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Glass Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  border: Border(
                      bottom: BorderSide(
                          color: Colors.white.withOpacity(0.1), width: 1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.analytics_outlined,
                        color: Color(0xFF7DD3FC), size: 22),
                    const SizedBox(width: 12),
                    const Text(
                      'Parameter Suite',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _capacityController,
                      label: 'TARGET CAPACITY',
                      hint: '0.00',
                      subtext: 'Required tensile capacity in kilonewtons',
                      icon: Icons.flash_on_rounded,
                      suffix: 'kN',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _boltsController,
                      label: 'BOLT COUNT',
                      hint: '4',
                      subtext: 'Total bolts in connection (2 to 8)',
                      icon: Icons.grid_view_rounded,
                      suffix: 'Bolts',
                      keyboardType: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildRowSelector(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required String suffix,
    required TextInputType keyboardType,
    String? subtext,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
              prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.5), size: 20),
              suffixText: suffix,
              suffixStyle:
                  const TextStyle(color: Color(0xFF7DD3FC), fontWeight: FontWeight.bold),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
        ),
        if (subtext != null) ...[
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: const Color(0xFF7DD3FC).withOpacity(0.6), size: 14),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  subtext,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildRowSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ROW CONFIGURATION',
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [1, 2].map((r) {
            final selected = _selectedRows == r;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedRows = r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.only(right: r == 1 ? 12 : 0),
                  height: 60,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF7DD3FC).withOpacity(0.15)
                        : Colors.white.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected
                          ? const Color(0xFF7DD3FC).withOpacity(0.5)
                          : Colors.white.withOpacity(0.08),
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      r == 1 ? 'SINGLE' : 'DOUBLE',
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.white.withOpacity(0.4),
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.info_outline_rounded, 
                 color: const Color(0xFF7DD3FC).withOpacity(0.6), 
                 size: 14),
            const SizedBox(width: 8),
            Text(
              "Available for sections ≥ 100×100 only",
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _calculate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'CALCULATE DESIGN',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5),
                  ),
                  SizedBox(width: 12),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 16),
                ],
              ),
      ),
    );
  }
}

// ── Glass Background System ─────────────────────────────────
class _GlassBackground extends StatelessWidget {
  const _GlassBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
            ),
          ),
        ),
        // Floating Orbs (Blue Palette Only)
        Positioned(
          top: -100,
          right: -100,
          child: _BlurOrb(color: const Color(0xFF3B82F6).withOpacity(0.2), size: 300),
        ),
        Positioned(
          bottom: 100,
          left: -50,
          child: _BlurOrb(color: const Color(0xFF0EA5E9).withOpacity(0.15), size: 250),
        ),
        Positioned(
          top: 300,
          left: 100,
          child: _BlurOrb(color: const Color(0xFF1D4ED8).withOpacity(0.1), size: 200),
        ),
      ],
    );
  }
}

class _BlurOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _BlurOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 80, sigmaY: 80),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class _MiniAnglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
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
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.2), 3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
