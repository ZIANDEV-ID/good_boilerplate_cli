import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/quota/daily_quota_service.dart';
import '../../../../core/gemini/gemini_vision_service.dart';

part 'object_capture_state.dart';

class ObjectCaptureCubit extends Cubit<ObjectCaptureState> {
  static const String _featureKey = 'object_capture';
  static const int _dailyLimit = 5;

  ObjectCaptureCubit(this._quotaService, this._geminiVisionService)
    : super(ObjectCaptureState());

  final DailyQuotaService _quotaService;
  final GeminiVisionService _geminiVisionService;

  Future<void> init() async {
    final usage = await _quotaService.getUsage(
      featureKey: _featureKey,
      dailyLimit: _dailyLimit,
    );
    emit(
      state.copyWith(
        status: ObjectCaptureStatus.initial,
        remainingQuota: usage.remaining,
      ),
    );
  }

  Future<void> onCameraReady() async {
    final usage = await _quotaService.getUsage(
      featureKey: _featureKey,
      dailyLimit: _dailyLimit,
    );
    emit(
      state.copyWith(
        status: ObjectCaptureStatus.cameraReady,
        remainingQuota: usage.remaining,
      ),
    );
  }

  Future<void> startAnalysis({String? imagePath}) async {
    if (imagePath == null) {
      emit(
        state.copyWith(
          status: ObjectCaptureStatus.failure,
          errorMessage: 'Gambar belum tersedia untuk dianalisis.',
        ),
      );
      return;
    }

    final canConsume = await _quotaService.canConsume(
      featureKey: _featureKey,
      dailyLimit: _dailyLimit,
    );

    if (!canConsume) {
      emit(state.copyWith(status: ObjectCaptureStatus.noQuota));
      return;
    }

    emit(state.copyWith(status: ObjectCaptureStatus.analyzing));

    try {
      final result = await _geminiVisionService.analyzeImage(
        imagePath: imagePath,
      );
      final newUsage = await _quotaService.consume(
        featureKey: _featureKey,
        dailyLimit: _dailyLimit,
      );

      emit(
        state.copyWith(
          status: ObjectCaptureStatus.success,
          remainingQuota: newUsage.remaining,
          result: result,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ObjectCaptureStatus.failure,
          errorMessage: error.toString(),
        ),
      );
    }
  }

  void reset() {
    emit(
      state.copyWith(
        status: ObjectCaptureStatus.cameraReady,
        clearErrorMessage: true,
        clearResult: true,
      ),
    );
  }
}
