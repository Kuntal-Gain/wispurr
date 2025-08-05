// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:wispurr/app/screens/home_screen.dart';
import 'package:wispurr/utils/constants/colors.dart';

class FaceAuthScreen extends StatefulWidget {
  const FaceAuthScreen({super.key});

  @override
  State<FaceAuthScreen> createState() => _FaceAuthScreenState();
}

class _FaceAuthScreenState extends State<FaceAuthScreen>
    with TickerProviderStateMixin {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _isProcessing = false;
  bool _imageCaptured = false;
  bool _permissionDenied = false;
  XFile? _capturedImage;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkPermissionsAndInitialize();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  Future<void> _checkPermissionsAndInitialize() async {
    final hasPermission = await _checkAndRequestPermissions();
    if (hasPermission) {
      await _initializeCamera();
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    // Check camera permission
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied) {
      cameraStatus = await Permission.camera.request();
    }

    if (cameraStatus.isPermanentlyDenied) {
      setState(() {
        _permissionDenied = true;
      });
      _showPermissionDialog();
      return false;
    }

    if (cameraStatus.isGranted) {
      setState(() {
        _permissionDenied = false;
      });
      return true;
    }

    setState(() {
      _permissionDenied = true;
    });
    return false;
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        // Use front camera for face authentication
        final frontCamera = _cameras!.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => _cameras!.first,
        );

        _cameraController = CameraController(
          frontCamera,
          ResolutionPreset.medium,
          enableAudio: false,
        );

        await _cameraController!.initialize();

        setState(() {
          _isCameraInitialized = true;
        });

        // Start pulse animation for face overlay
        _pulseController.repeat(reverse: true);
      }
    } catch (e) {
      _showCameraError();
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xff1F2C34),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Camera Permission Required',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'This app needs camera access to capture your face for authentication. Please grant camera permission to continue.',
            style: TextStyle(
              color: Color(0xff8696A0),
              fontSize: 16,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to previous screen
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xff8696A0),
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                openAppSettings();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kAccentPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Open Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showCameraError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Failed to initialize camera. Please try again.',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: _checkPermissionsAndInitialize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildCameraView()),
              _buildControls(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const Spacer(),
              const Text(
                'Face Authentication',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kAccentPurple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: kAccentPurple.withOpacity(0.3)),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.security,
                  color: kAccentPurple,
                  size: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your face data will be converted to an encryption key for secure E2E chats',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    if (_permissionDenied) {
      return _buildPermissionDeniedView();
    }

    if (!_isCameraInitialized || _cameraController == null) {
      return _buildCameraPlaceholder();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Text(
            _imageCaptured
                ? 'Image captured successfully!'
                : 'Position your face within the frame',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xff8696A0),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      _imageCaptured ? const Color(0xff00A884) : kAccentPurple,
                  width: 3,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: _imageCaptured && _capturedImage != null
                    ? Image.file(
                        File(_capturedImage!.path),
                        fit: BoxFit.cover,
                      )
                    : Stack(
                        children: [
                          CameraPreview(_cameraController!),
                          _buildFaceOverlay(),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionDeniedView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Text(
            'Camera permission required',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff8696A0),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1F2C34),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xff3C4043),
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.camera_alt_outlined,
                      color: Color(0xff8696A0),
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Camera access needed',
                      style: TextStyle(
                        color: Color(0xff8696A0),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please enable camera permission\nin app settings to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff8696A0),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _checkPermissionsAndInitialize,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kAccentPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const Text(
            'Initializing camera...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xff8696A0),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff1F2C34),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xff3C4043),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xff8696A0)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading camera...',
                      style: TextStyle(
                        color: Color(0xff8696A0),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaceOverlay() {
    return Center(
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 200,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.8),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: CustomPaint(
                painter: FaceGuidelinePainter(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildControls() {
    if (_permissionDenied) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          if (!_imageCaptured) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Flash toggle
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xff1F2C34),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff3C4043),
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _isCameraInitialized ? _toggleFlash : null,
                    icon: const Icon(
                      Icons.flash_off,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                // Capture button
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: (_isProcessing || !_isCameraInitialized)
                          ? null
                          : _captureImage,
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: (_isCameraInitialized && !_isProcessing)
                              ? kAccentPurple
                              : kAccentPurple.withOpacity(0.5),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: kAccentPurple.withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: _isProcessing
                            ? const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 32,
                              ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 32),
                // Camera switch placeholder
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xff1F2C34),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xff3C4043),
                      width: 2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text(
              'Tap the capture button when your face is clearly visible',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff8696A0),
                fontSize: 14,
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _retakeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1F2C34),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      side: const BorderSide(
                        color: Color(0xff3C4043),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(0, 56),
                    ),
                    child: const Text(
                      'Retake',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : _processImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kAccentPurple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(0, 56),
                    ),
                    child: _isProcessing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Generate Key',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _toggleFlash() async {
    if (_cameraController != null) {
      try {
        await _cameraController!.setFlashMode(FlashMode.torch);
        // ignore: empty_catches
      } catch (e) {}
    }
  }

  void _captureImage() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile image = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = image;
        _imageCaptured = true;
        _isProcessing = false;
      });

      _pulseController.stop();
    } catch (e) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _retakeImage() {
    setState(() {
      _imageCaptured = false;
      _capturedImage = null;
    });
    _pulseController.repeat(reverse: true);
  }

  void _processImage() async {
    if (_capturedImage == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Here you would implement your facial recognition algorithm
      // For now, we'll simulate the processing
      await Future.delayed(const Duration(seconds: 3));

      // TODO: Implement facial recognition and key generation
      // 1. Process the captured image
      // 2. Extract facial features
      // 3. Generate encryption key from facial features
      // 4. Store the key securely for E2E encryption

      // Navigate to next screen or back to chat
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to process image. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}

// Custom painter for face guidelines
class FaceGuidelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);

    // Draw eye guidelines
    canvas.drawCircle(
      Offset(center.dx - 30, center.dy - 20),
      8,
      paint,
    );
    canvas.drawCircle(
      Offset(center.dx + 30, center.dy - 20),
      8,
      paint,
    );

    // Draw nose guideline
    canvas.drawLine(
      Offset(center.dx, center.dy - 10),
      Offset(center.dx, center.dy + 10),
      paint,
    );

    // Draw mouth guideline
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + 25),
        width: 40,
        height: 20,
      ),
      0,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
