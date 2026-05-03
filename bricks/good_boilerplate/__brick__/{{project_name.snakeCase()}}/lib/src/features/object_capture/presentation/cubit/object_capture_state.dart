part of 'object_capture_cubit.dart';

enum ObjectCaptureStatus {
  initial,
  loadingCamera,
  cameraReady,
  capturing,
  analyzing,
  success,
  failure,
  noQuota,
}

class ObjectCaptureState {
  final ObjectCaptureStatus status;
  final String? errorMessage;
  final int remainingQuota;
  final String? result;

  ObjectCaptureState({
    this.status = ObjectCaptureStatus.initial,
    this.errorMessage,
    this.remainingQuota = 0,
    this.result,
  });

  ObjectCaptureState copyWith({
    ObjectCaptureStatus? status,
    String? errorMessage,
    int? remainingQuota,
    String? result,
    bool clearErrorMessage = false,
    bool clearResult = false,
  }) {
    return ObjectCaptureState(
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      remainingQuota: remainingQuota ?? this.remainingQuota,
      result: clearResult ? null : result ?? this.result,
    );
  }
}
