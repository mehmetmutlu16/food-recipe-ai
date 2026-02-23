import 'package:equatable/equatable.dart';

/// Domain-level failure representation.
/// Provides user-friendly messages for all error scenarios.
class AppFailure extends Equatable {
  final String message;
  final String? code;
  final dynamic originalError;

  const AppFailure({
    required this.message,
    this.code,
    this.originalError,
  });

  /// Network connection failure
  factory AppFailure.network() => const AppFailure(
        message: 'İnternet bağlantınızı kontrol edin ve tekrar deneyin.',
        code: 'NETWORK_ERROR',
      );

  /// Server-side error
  factory AppFailure.server([String? detail]) => AppFailure(
        message: detail ?? 'Sunucuda bir hata oluştu. Lütfen tekrar deneyin.',
        code: 'SERVER_ERROR',
      );

  /// AI processing failure
  factory AppFailure.aiProcessing() => const AppFailure(
        message: 'Yapay zeka şu anda yanıt veremiyor. Lütfen tekrar deneyin.',
        code: 'AI_ERROR',
      );

  /// Validation failure
  factory AppFailure.validation(String message) => AppFailure(
        message: message,
        code: 'VALIDATION_ERROR',
      );

  /// Image processing failure
  factory AppFailure.imageProcessing() => const AppFailure(
        message: 'Görsel işlenirken bir hata oluştu. Farklı bir görsel deneyin.',
        code: 'IMAGE_ERROR',
      );

  /// Unknown / catch-all failure
  factory AppFailure.unknown() => const AppFailure(
        message: 'Beklenmeyen bir hata oluştu. Lütfen tekrar deneyin.',
        code: 'UNKNOWN',
      );

  @override
  List<Object?> get props => [message, code];
}
