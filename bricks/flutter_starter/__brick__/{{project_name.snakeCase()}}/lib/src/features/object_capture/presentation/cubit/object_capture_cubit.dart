import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/quota/daily_quota_service.dart';

part 'object_capture_state.dart';

class ObjectCaptureCubit extends Cubit<ObjectCaptureState> {
  final DailyQuotaService _quotaService;
  static const String _featureKey = 'object_capture';
  static const int _dailyLimit = 5;

  ObjectCaptureCubit(this._quotaService) : super(ObjectCaptureState());

  Future<void> init() async {
    final usage = await _quotaService.getUsage(
      featureKey: _featureKey,
      dailyLimit: _dailyLimit,
    );
    emit(state.copyWith(
      status: ObjectCaptureStatus.initial,
      remainingQuota: usage.remaining,
    ));
  }

  Future<void> onCameraReady() async {
    final usage = await _quotaService.getUsage(
      featureKey: _featureKey,
      dailyLimit: _dailyLimit,
    );
    emit(state.copyWith(
      status: ObjectCaptureStatus.cameraReady,
      remainingQuota: usage.remaining,
    ));
  }

  Future<void> startAnalysis({String? imagePath}) async {
    final canConsume = await _quotaService.canConsume(
      featureKey: _featureKey,
      dailyLimit: _dailyLimit,
    );

    if (!canConsume) {
      emit(state.copyWith(status: ObjectCaptureStatus.noQuota));
      return;
    }

    emit(state.copyWith(status: ObjectCaptureStatus.analyzing));

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 3));

    // Consume quota on success
    final newUsage = await _quotaService.consume(
      featureKey: _featureKey,
      dailyLimit: _dailyLimit,
    );

    final source = imagePath != null ? 'dari gallery' : 'dari kamera';
    emit(state.copyWith(
      status: ObjectCaptureStatus.success,
      remainingQuota: newUsage.remaining,
      result: "Ini adalah objek dummy yang berhasil dianalisis $source. Objek ini terlihat sangat menarik dan memiliki potensi besar untuk digunakan dalam berbagai aplikasi.",
    ));
  }

  void reset() {
    emit(state.copyWith(status: ObjectCaptureStatus.cameraReady, result: null));
  }
}
