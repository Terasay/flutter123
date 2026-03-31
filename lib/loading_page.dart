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
  late final Animation<double> _progress;

  static const Duration _animationDuration = Duration(milliseconds: 2600);
  static const double _logoSize = 140;
  static const String _bgAsset = 'assets/images/image_1.jpg';
  static const String _logoAsset = 'assets/images/logo.png';

  double? _bgAspectRatio;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this,
    );

    _progress = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _resolveBackgroundRatio();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      _animationController.forward(from: 0);
    });
  }

  void _resolveBackgroundRatio() {
    final stream = const AssetImage(_bgAsset).resolve(
      const ImageConfiguration(),
    );
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (info, _) {
        final ratio = info.image.width / info.image.height;
        if (mounted) {
          setState(() {
            _bgAspectRatio = ratio;
          });
        } else {
          _bgAspectRatio = ratio;
        }
        stream.removeListener(listener);
      },
      onError: (_, __) {
        stream.removeListener(listener);
      },
    );
    stream.addListener(listener);
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
    return Scaffold(
      body: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final screenHeight = constraints.maxHeight;
            final ratio = _bgAspectRatio ?? (16 / 9);

            var bgWidth = screenHeight * ratio;
            var bgHeight = screenHeight;
            if (bgWidth < screenWidth) {
              bgWidth = screenWidth;
              bgHeight = screenWidth / ratio;
            }

            final maxShift = (bgWidth - screenWidth) / 2;
            final logoStartX = -(screenWidth / 2 + _logoSize);

            return Stack(
              fit: StackFit.expand,
              children: [
                AnimatedBuilder(
                  animation: _progress,
                  builder: (context, child) {
                    final t = _progress.value;
                    final bgOffsetX = -maxShift * t;

                    return Transform.translate(
                      offset: Offset(bgOffsetX, 0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: SizedBox(
                          width: bgWidth,
                          height: bgHeight,
                          child: Image.asset(
                            _bgAsset,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                AnimatedBuilder(
                  animation: _progress,
                  builder: (context, child) {
                    final t = _progress.value;
                    final logoOffsetX = logoStartX * (1 - t);
                    final spin = t * 2 * math.pi;
                    final flip = math.sin(math.pi * t) * math.pi;

                    return Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(logoOffsetX, 0),
                        child: Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..setEntry(3, 2, 0.001)
                            ..rotateX(flip)
                            ..rotateZ(spin),
                          child: Image.asset(
                            _logoAsset,
                            width: _logoSize,
                            height: _logoSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
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
      ),
    );
  }
}
