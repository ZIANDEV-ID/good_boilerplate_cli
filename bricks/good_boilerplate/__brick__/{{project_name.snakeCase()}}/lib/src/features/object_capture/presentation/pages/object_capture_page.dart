import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:{{project_name.snakeCase()}}/src/app/router/app_router.dart';
import 'package:{{project_name.snakeCase()}}/src/core/theme/app_colors.dart';
import '../cubit/object_capture_cubit.dart';
import '../widgets/analyzing_overlay.dart';
import '../widgets/result_bottom_sheet.dart';

class ObjectCapturePage extends StatefulWidget {
  const ObjectCapturePage({super.key});

  @override
  State<ObjectCapturePage> createState() => _ObjectCapturePageState();
}

class _ObjectCapturePageState extends State<ObjectCapturePage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  final ImagePicker _imagePicker = ImagePicker();
  bool _isFlashEnabled = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras![0],
        ResolutionPreset.high,
        enableAudio: false,
      );

      try {
        await _controller!.initialize();
        if (mounted) {
          context.read<ObjectCaptureCubit>().onCameraReady();
          setState(() {});
        }
      } catch (e) {
        debugPrint('Camera Error: $e');
      }
    }
  }

  Future<void> _pickFromGallery() async {
    final cubit = context.read<ObjectCaptureCubit>();
    final currentState = cubit.state;

    if (currentState.status == ObjectCaptureStatus.analyzing) return;

    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile == null) return;
    if (!mounted) return;

    // Show snackbar confirming image selected, then trigger analysis
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Gambar dipilih: ${pickedFile.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );

    // Trigger analysis (passing path to cubit – currently used for future real API)
    await cubit.startAnalysis(imagePath: pickedFile.path);
  }

  Future<void> _toggleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return;
    }

    final nextValue = !_isFlashEnabled;
    try {
      await controller.setFlashMode(
        nextValue ? FlashMode.torch : FlashMode.off,
      );
      if (!mounted) {
        return;
      }

      setState(() => _isFlashEnabled = nextValue);
    } catch (e) {
      debugPrint('Flash Error: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildCameraPreview() {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final previewSize = controller.value.previewSize;
    if (previewSize == null) {
      return SizedBox.expand(child: CameraPreview(controller));
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: previewSize.height,
          height: previewSize.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ObjectCaptureCubit, ObjectCaptureState>(
      listener: (context, state) {
        if (state.status == ObjectCaptureStatus.success &&
            state.result != null) {
          showResultBottomSheet(
            context,
            result: state.result!,
            remainingQuota: state.remainingQuota,
            onReset: () => context.read<ObjectCaptureCubit>().reset(),
          );
        } else if (state.status == ObjectCaptureStatus.noQuota) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.block, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Kamu telah mencapai batas harian.'),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Camera Preview
            _buildCameraPreview(),

            // Top Bar
            Positioned(
              top: MediaQuery.of(context).padding.top + 25,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _CameraTopIconButton(
                        icon: _isFlashEnabled
                            ? Icons.flash_on_rounded
                            : Icons.flash_off_rounded,
                        onTap: _toggleFlash,
                      ),
                      const SizedBox(width: 10),
                      _CameraTopIconButton(
                        icon: Icons.settings_rounded,
                        onTap: () => context.push(AppRoutes.settings),
                      ),
                    ],
                  ),
                  BlocBuilder<ObjectCaptureCubit, ObjectCaptureState>(
                    builder: (context, state) {
                      if (state.remainingQuota > 0) {
                        return _DailyLimitText(
                          remainingQuota: state.remainingQuota,
                        );
                      }

                      return _PremiumButton(
                        onTap: () => context.push(AppRoutes.paywall),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom Controls: Gallery | Capture | (placeholder)
            Positioned(
              bottom: 55,
              left: 0,
              right: 0,
              child: BlocBuilder<ObjectCaptureCubit, ObjectCaptureState>(
                builder: (context, state) {
                  final isAnalyzing =
                      state.status == ObjectCaptureStatus.analyzing;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Gallery Button
                        _GalleryButton(
                          onTap: isAnalyzing ? null : _pickFromGallery,
                        ),

                        // Capture Button
                        GestureDetector(
                          onTap: isAnalyzing
                              ? null
                              : () => context
                                    .read<ObjectCaptureCubit>()
                                    .startAnalysis(),
                          child: Container(
                            height: 80,
                            width: 80,
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: isAnalyzing
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                        ),

                        // Spacer (symmetrical with gallery button)
                        const SizedBox(width: 56),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Analyzing Overlay
            BlocBuilder<ObjectCaptureCubit, ObjectCaptureState>(
              builder: (context, state) {
                if (state.status == ObjectCaptureStatus.analyzing) {
                  return const AnalyzingOverlay();
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Gallery Button Widget ────────────────────────────────────────────────────

class _GalleryButton extends StatelessWidget {
  const _GalleryButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isDisabled ? 0.4 : 1.0,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white12,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white30, width: 1.5),
          ),
          child: const Icon(
            Icons.photo_library_outlined,
            color: AppColors.primary,
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _CameraTopIconButton extends StatelessWidget {
  const _CameraTopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.black45,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}

class _PremiumButton extends StatelessWidget {
  const _PremiumButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: const Color(0xFFFFD60A).withValues(alpha: 0.5),
          ),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xFFFFD60A),
              size: 18,
            ),
            SizedBox(width: 6),
            Text(
              'Get Premium',
              style: TextStyle(
                color: Color(0xFFFFD60A),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyLimitText extends StatelessWidget {
  const _DailyLimitText({required this.remainingQuota});

  final int remainingQuota;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        'Daily Limit: $remainingQuota',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
