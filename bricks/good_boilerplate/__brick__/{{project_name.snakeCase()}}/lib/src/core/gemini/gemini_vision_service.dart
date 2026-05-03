import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:{{project_name.snakeCase()}}/src/app/app_config.dart';

class GeminiVisionService {
  GeminiVisionService(this._config)
    : _dio = Dio(
        BaseOptions(
          baseUrl: _config.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 60),
          headers: const {'Content-Type': 'application/json'},
        ),
      );

  final GeminiConfig _config;
  final Dio _dio;

  Future<String> analyzeImage({
    required String imagePath,
    String? prompt,
  }) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      throw const GeminiVisionException('File gambar tidak ditemukan.');
    }

    if (!_config.hasApiKey) {
      return _dummyAnalysisResult;
    }

    final imageBytes = await file.readAsBytes();
    final response = await _dio.post<Map<String, dynamic>>(
      '/v1beta/models/${_config.model}:generateContent',
      options: Options(headers: {'x-goog-api-key': _config.apiKey}),
      data: {
        'contents': [
          {
            'parts': [
              {
                'inline_data': {
                  'mime_type': _mimeTypeForPath(imagePath),
                  'data': base64Encode(imageBytes),
                },
              },
              {'text': prompt ?? _config.prompt},
            ],
          },
        ],
      },
    );

    final text = _extractText(response.data);
    if (text == null || text.trim().isEmpty) {
      throw const GeminiVisionException('Gemini tidak mengembalikan hasil.');
    }

    return text.trim();
  }

  static const _dummyAnalysisResult =
      'Ini adalah hasil analisis dummy karena Gemini API key belum dikonfigurasi. Objek pada gambar terlihat jelas dan dapat digunakan untuk menguji alur capture, gallery picker, quota, loading, dan result bottom sheet sebelum API asli diaktifkan.';

  static String _mimeTypeForPath(String path) {
    final lowerPath = path.toLowerCase();
    if (lowerPath.endsWith('.png')) return 'image/png';
    if (lowerPath.endsWith('.webp')) return 'image/webp';
    if (lowerPath.endsWith('.heic')) return 'image/heic';
    if (lowerPath.endsWith('.heif')) return 'image/heif';
    return 'image/jpeg';
  }

  static String? _extractText(Map<String, dynamic>? data) {
    final candidates = data?['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      return null;
    }

    final content = candidates.first['content'];
    if (content is! Map<String, dynamic>) {
      return null;
    }

    final parts = content['parts'];
    if (parts is! List) {
      return null;
    }

    return parts
        .whereType<Map<String, dynamic>>()
        .map((part) => part['text'])
        .whereType<String>()
        .join('\n')
        .trim();
  }
}

class GeminiVisionException implements Exception {
  const GeminiVisionException(this.message);

  final String message;

  @override
  String toString() => message;
}
