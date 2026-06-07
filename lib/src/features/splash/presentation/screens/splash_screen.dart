import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:water_collector/src/core/constants/app_constants.dart';
import 'package:water_collector/src/core/constants/asset_constants.dart';
import 'package:water_collector/src/core/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Timer? _navigationTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    _navigationTimer = Timer(AppConstants.splashDuration, _openTemporaryScreen);
  }

  void _openTemporaryScreen() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF075195),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: const _SplashContent(),
        ),
      ),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    // Responsive values based on screen size
    final logoSize = (width * 0.32).clamp(90.0, 140.0);
    final titleFontSize = (width * 0.068).clamp(18.0, 28.0);
    final subtitleFontSize = (width * 0.042).clamp(12.0, 18.0);
    final tagFontSize = (width * 0.028).clamp(9.0, 12.0);
    final smallFontSize = (width * 0.032).clamp(10.0, 14.0);
    final spacing1 = height * 0.04;
    final spacing2 = height * 0.05;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Professional Gradient Background
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF075195),
                Color(0xFF043B6E),
                Color(0xFF022647),
              ],
            ),
          ),
        ),

        // ✅ FIXED: Background pattern using CustomPaint — no RenderFlex overflow
        Positioned.fill(
          child: Opacity(
            opacity: 0.05,
            child: CustomPaint(
              painter: _WaterDropPatternPainter(),
            ),
          ),
        ),

        // Main content — fully responsive, no hardcoded widths
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.08),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Container(
                padding: EdgeInsets.all(width * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    AssetConstants.tmcLogo,
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: spacing1),

              // Marathi Title
              Text(
                'ठाणे महानगरपालिका',
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),

              // English Title
              Text(
                'THANE MUNICIPAL CORPORATION (TMC)',
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 2,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: subtitleFontSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 6),

              // Establishment info
              Text(
                'Thane, Maharashtra — Est. 1982',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: smallFontSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Water Testing Application badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  'WATER TESTING APPLICATION',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: tagFontSize,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.6,
                  ),
                ),
              ),

              SizedBox(height: spacing2),

              // Loading indicator
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Color(0xFFF57C00),
                  strokeWidth: 4,
                  strokeCap: StrokeCap.round,
                ),
              ),
            ],
          ),
        ),

        // Footer — anchored to bottom, never overflows
        Positioned(
          bottom: 24,
          left: 16,
          right: 16,
          child: Text(
            '© ${DateTime.now().year} Developed by Alphonsol',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// ✅ Replaces the overflow-prone Row/Column pattern grid
/// Draws water drop icons across the full screen using Canvas — zero layout overflow risk
class _WaterDropPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    const iconSpacingX = 48.0;
    const iconSpacingY = 48.0;
    const dropRadius = 9.0;

    final cols = (size.width / iconSpacingX).ceil() + 1;
    final rows = (size.height / iconSpacingY).ceil() + 1;

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final cx = col * iconSpacingX + (row.isOdd ? iconSpacingX / 2 : 0);
        final cy = row * iconSpacingY;
        _drawWaterDrop(canvas, paint, Offset(cx, cy), dropRadius);
      }
    }
  }

  void _drawWaterDrop(
      Canvas canvas, Paint paint, Offset center, double radius) {
    final path = Path();
    // Teardrop shape: circle bottom, pointed top
    path.moveTo(center.dx, center.dy - radius * 1.6); // tip top
    path.cubicTo(
      center.dx + radius * 1.1,
      center.dy - radius * 0.5,
      center.dx + radius,
      center.dy + radius * 0.5,
      center.dx,
      center.dy + radius,
    );
    path.cubicTo(
      center.dx - radius,
      center.dy + radius * 0.5,
      center.dx - radius * 1.1,
      center.dy - radius * 0.5,
      center.dx,
      center.dy - radius * 1.6,
    );
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}