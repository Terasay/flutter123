import 'dart:math' as math;

import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key, required this.nextPage});

  final Widget nextPage;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  static const Duration _animationDuration = Duration(milliseconds: 2600);
  static const double _logoSize = 200;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) {
          _animationController.forward(from: 0.0);
        }
      });
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (mounted) {
      _animationController.forward(from: 0.0);
    }
  }

  void _skip() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => widget.nextPage));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final t = Curves.easeInOutCubic.transform(_animationController.value);

          final bgWidth = screenWidth * 3.0;
          final currentBgLeft = -(screenWidth / 0.52) * t;

          final logoStart = -_logoSize;
          final logoEnd = screenWidth / 2 - _logoSize / 2;
          final currentLogoLeft = logoStart + (logoEnd - logoStart) * t;

          final currentRotation = t * 2 * math.pi;

          return Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: currentBgLeft,
                width: bgWidth,
                child: Image.asset(
                  'assets/images/image_1.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.centerLeft,
                ),
              ),
              Positioned(
                top: screenHeight / 2 - _logoSize / 2,
                left: currentLogoLeft,
                width: _logoSize,
                height: _logoSize,
                child: Transform.rotate(
                  angle: currentRotation,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                    child: SizedBox(
                      width: 62,
                      height: 62,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 4,
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF9C6A32),
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: _skip,
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
