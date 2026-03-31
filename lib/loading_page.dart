import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key, required this.nextPage});

  final Widget nextPage;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showStaticState = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animationController.addListener(() {
      if (_animationController.isCompleted && !_showStaticState) {
        setState(() {
          _showStaticState = true;
        });
      }
    });

    _animationController.forward();
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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Animation state - background slides from left with rotating logo
          AnimatedOpacity(
            opacity: _showStaticState ? 0 : 1,
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Animated background - slides from left to right
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) {
                    // Background moves from left edge to center
                    // Assuming image is 2x screen width
                    final offsetX = -screenSize.width +
                        (screenSize.width * _animationController.value);

                    return ClipRect(
                      child: Transform.translate(
                        offset: Offset(offsetX, 0),
                        child: Image.asset(
                          'assets/images/image_1.jpg',
                          fit: BoxFit.cover,
                          width: screenSize.width * 2,
                          height: screenSize.height,
                        ),
                      ),
                    );
                  },
                ),
                // Animated logo - slides from left and rotates 360 degrees
                LayoutBuilder(
                  builder: (context, constraints) {
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        // Logo starts off-screen to the left
                        final screenWidth = constraints.maxWidth;
                        final logoStartX = -140.0; // Start off-screen left
                        final logoEndX = screenWidth / 2 - 70; // End at center

                        final logoOffsetX = logoStartX +
                            (logoEndX - logoStartX) *
                                _animationController.value;

                        // Rotation: clockwise 360 degrees
                        final rotation =
                            _animationController.value * 2 * 3.14159265359;

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Positioned(
                              left: logoOffsetX,
                              top: screenSize.height / 2 - 70,
                              child: Transform.rotate(
                                angle: rotation,
                                child: Image.asset(
                                  'assets/images/logo.png',
                                  width: 140,
                                  height: 140,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                // Skip button visible during animation
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
            ),
          ),
          // Static state - shown after animation completes
          AnimatedOpacity(
            opacity: _showStaticState ? 1 : 0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: IgnorePointer(
              ignoring: !_showStaticState,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset('assets/images/image_1.jpg', fit: BoxFit.cover),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.contain,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
