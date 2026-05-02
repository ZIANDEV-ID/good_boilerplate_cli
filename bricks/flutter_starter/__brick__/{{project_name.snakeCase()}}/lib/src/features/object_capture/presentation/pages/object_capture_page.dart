import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
            const SnackBar(content: Text("You have reached your daily limit.")),
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

            // Capture Button
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: BlocBuilder<ObjectCaptureCubit, ObjectCaptureState>(
                builder: (context, state) {
                  final isAnalyzing = state.status == ObjectCaptureStatus.analyzing;
                  return Center(
                    child: GestureDetector(
                      onTap: isAnalyzing
                          ? null
                          : () => context.read<ObjectCaptureCubit>().startAnalysis(),
                      child: Container(
                        height: 80,
                        width: 80,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
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
