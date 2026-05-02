import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../artwork/presentation/pages/artwork_detail_page.dart';
import '../providers/scan_provider.dart';

class ScanPage extends ConsumerStatefulWidget {
  const ScanPage({super.key});

  @override
  ConsumerState<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage>
    with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  Future<void>? _initializeFuture;
  late final AnimationController _scanFrameController;

  @override
  void initState() {
    super.initState();
    _scanFrameController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _initializeFuture = _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      backCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();
    if (!mounted) {
      await controller.dispose();
      return;
    }

    setState(() {
      _cameraController = controller;
    });
  }

  Future<void> _scan() async {
    final cameraController = _cameraController;
    if (cameraController == null) {
      return;
    }

    await cameraController.takePicture();
    final artwork = await ref.read(scanControllerProvider.notifier).scanAndDetect();

    if (!mounted || artwork == null) {
      return;
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 360),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
            child: ArtworkDetailPage(artwork: artwork),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scanFrameController.dispose();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanControllerProvider);

    return Scaffold(
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              _cameraController == null ||
              !_cameraController!.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(_cameraController!),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.62),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.66),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'Camera Active',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              letterSpacing: 1,
                            ),
                      ),
                    ),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: _scanFrameController,
                      builder: (context, child) {
                        final t = _scanFrameController.value;
                        return Container(
                          width: 280,
                          height: 360,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            border: Border.all(
                              color: Color.lerp(
                                    const Color(0x80FFFFFF),
                                    const Color(0xFFC8A96B),
                                    t,
                                  ) ??
                                  const Color(0x80FFFFFF),
                              width: 2.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFC8A96B).withValues(alpha: 0.16),
                                blurRadius: 28,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const Spacer(),
                    if (scanState.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          scanState.error!,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 36),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: scanState.isScanning ? null : _scan,
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xCC111110),
                            foregroundColor: const Color(0xFFF6E8CB),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(color: Color(0x66C8A96B)),
                            ),
                          ),
                          child: scanState.isScanning
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Color(0xFFF6E8CB),
                                  ),
                                )
                              : const Text('Tap to Scan'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
