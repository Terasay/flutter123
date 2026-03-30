import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key, required this.nextPage});

  final Widget nextPage;

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  late final VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _showStaticState = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/loading.mp4')
      ..setLooping(false)
      ..setVolume(0);
    _controller.addListener(_handleVideoState);
    _initializeVideo();
  }

  void _handleVideoState() {
    if (!_isInitialized || _showStaticState) {
      return;
    }
    if (_controller.value.isCompleted) {
      setState(() {
        _showStaticState = true;
      });
    }
  }

  Future<void> _initializeVideo() async {
    await _controller.initialize();
    if (!mounted) {
      return;
    }
    await _controller.play();
    setState(() {
      _isInitialized = true;
    });
  }

  void _skip() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute<void>(builder: (_) => widget.nextPage));
  }

  @override
  void dispose() {
    _controller.removeListener(_handleVideoState);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            opacity: _showStaticState ? 0 : 1,
            duration: const Duration(milliseconds: 650),
            curve: Curves.easeInOut,
            child: _isInitialized
                ? FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : const ColoredBox(color: Colors.black),
          ),
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
