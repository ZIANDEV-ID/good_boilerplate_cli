import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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
        debugPrint("Camera Error: $e");
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
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
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

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ObjectCaptureCubit, ObjectCaptureState>(
      listener: (context, state) {
        if (state.status == ObjectCaptureStatus.success && state.result != null) {
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
                  Text("Kamu telah mencapai batas harian."),
                ],
              ),
              backgroundColor: Colors.red.shade700,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Camera Preview
            if (_controller != null && _controller!.value.isInitialized)
              Center(
                child: CameraPreview(_controller!),
              )
            else
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            // Top Bar
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  BlocBuilder<ObjectCaptureCubit, ObjectCaptureState>(
                    builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          "Quota: ${state.remainingQuota}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Bottom Controls: Gallery | Capture | (placeholder)
            Positioned(
              bottom: 40,
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
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.white, width: 4),
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
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white30, width: 1.5),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_library_outlined, color: Colors.white, size: 24),
              SizedBox(height: 2),
              Text(
                'Gallery',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
