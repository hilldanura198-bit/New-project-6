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

class _ScanPageState extends ConsumerState<ScanPage> {
  CameraController? _cameraController;
  Future<void>? _initializeFuture;

  @override
  void initState() {
    super.initState();
    _initializeFuture = _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final back = cameras.firstWhere((c) => c.lensDirection == CameraLensDirection.back, orElse: () => cameras.first);
    final controller = CameraController(back, ResolutionPreset.high, enableAudio: false);
    await controller.initialize();
    if (!mounted) return;
    setState(() => _cameraController = controller);
  }

  Future<void> _scan() async {
    if (_cameraController == null) return;
    await _cameraController!.takePicture();
    final artwork = await ref.read(scanControllerProvider.notifier).scanAndDetect();
    if (!mounted || artwork == null) return;
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => ArtworkDetailPage(artwork: artwork)));
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scanControllerProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done || _cameraController == null || !_cameraController!.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(_cameraController!),
              Container(color: Colors.black.withAlpha(70)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(20)),
                        child: Text('CAMERA ACTIVE', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700, height: 1.3)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Point camera at artwork\nCenter the object inside frame',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white, height: 1.5, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: 240,
                        height: 280,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.white54, width: 2)),
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: state.isScanning ? null : _scan,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Color(0xFF4A63F2), Color(0xFF1657C0)])),
                          child: state.isScanning
                              ? const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Icon(Icons.search_rounded, color: Colors.white, size: 32),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('TAP TO SCAN', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                      const Spacer(),
                    ],
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
