import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:{{project_name.snakeCase()}}/src/core/theme/app_colors.dart';
import 'package:{{project_name.snakeCase()}}/src/features/onboarding/domain/onboarding_slide.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({required this.type, super.key});

  final OnboardingIllustrationType type;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _OnboardingIllustrationPainter(type),
      size: const Size(double.infinity, 280),
    );
  }
}

class _OnboardingIllustrationPainter extends CustomPainter {
  const _OnboardingIllustrationPainter(this.type);

  final OnboardingIllustrationType type;

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case OnboardingIllustrationType.soundWave:
        _paintSoundWave(canvas, size);
      case OnboardingIllustrationType.phonePatterns:
        _paintPhonePatterns(canvas, size);
      case OnboardingIllustrationType.speakerTest:
        _paintSpeakerTest(canvas, size);
    }
  }

  void _paintSoundWave(Canvas canvas, Size size) {
    final centerY = size.height * 0.52;
    final startX = size.width * 0.08;
    final endX = size.width * 0.92;
    final width = endX - startX;
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [AppColors.accentSky, AppColors.accentLilac],
      ).createShader(Rect.fromLTWH(startX, 0, width, size.height))
      ..style = PaintingStyle.fill;
    final highlight = Paint()
      ..color = Colors.white.withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;
    final path = Path()..moveTo(startX, centerY);
    const peaks = [
      0.26,
      0.42,
      0.62,
      0.48,
      0.33,
      0.44,
      0.38,
      0.57,
      0.41,
      0.36,
      0.50,
      0.28,
      0.43,
      0.25,
    ];
    final segment = width / peaks.length;

    for (var i = 0; i < peaks.length; i++) {
      final x = startX + segment * i;
      final nextX = x + segment;
      final amp = size.height * peaks[i] * 0.5;
      path.cubicTo(
        x + segment * 0.20,
        centerY - amp,
        x + segment * 0.30,
        centerY - amp,
        x + segment * 0.50,
        centerY,
      );
      path.cubicTo(
        x + segment * 0.70,
        centerY + amp,
        x + segment * 0.80,
        centerY + amp,
        nextX,
        centerY,
      );
    }

    final lowerPath = Path.from(path)
      ..lineTo(endX, centerY)
      ..lineTo(endX, centerY)
      ..close();
    canvas.drawPath(lowerPath, paint);

    for (var i = 0; i < 26; i++) {
      final x = startX + width * i / 25;
      final lineHeight = size.height * (0.06 + 0.12 * math.sin(i * 1.7).abs());
      canvas.drawLine(
        Offset(x, centerY - lineHeight),
        Offset(x, centerY + lineHeight),
        highlight,
      );
    }
  }

  void _paintPhonePatterns(Canvas canvas, Size size) {
    final blobPaint = Paint()..color = AppColors.primarySoft;
    final shadowPaint = Paint()..color = AppColors.shadow;
    final phonePaint = Paint()..color = AppColors.textPrimary;
    final sidePaint = Paint()..color = AppColors.accentSky;
    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    final blob = Path()
      ..moveTo(size.width * 0.16, size.height * 0.58)
      ..cubicTo(
        size.width * 0.13,
        size.height * 0.34,
        size.width * 0.40,
        size.height * 0.36,
        size.width * 0.53,
        size.height * 0.44,
      )
      ..cubicTo(
        size.width * 0.76,
        size.height * 0.28,
        size.width * 0.93,
        size.height * 0.43,
        size.width * 0.84,
        size.height * 0.64,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.89,
        size.width * 0.31,
        size.height * 0.88,
        size.width * 0.16,
        size.height * 0.58,
      )
      ..close();
    canvas.drawPath(blob, blobPaint);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.78, size.height * 0.72),
        width: size.width * 0.09,
        height: size.height * 0.08,
      ),
      blobPaint,
    );

    canvas.save();
    canvas.translate(size.width * 0.50, size.height * 0.50);
    canvas.rotate(-0.54);
    final phoneRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.48,
        height: size.height * 0.34,
      ),
      const Radius.circular(22),
    );
    canvas.drawRRect(phoneRect.shift(const Offset(18, 16)), shadowPaint);
    canvas.drawRRect(phoneRect.shift(const Offset(0, 20)), sidePaint);
    canvas.drawRRect(phoneRect, phonePaint);
    canvas.drawRRect(
      phoneRect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5,
    );
    canvas.restore();

    for (final anchor in [
      Offset(size.width * 0.30, size.height * 0.72),
      Offset(size.width * 0.66, size.height * 0.35),
    ]) {
      for (var i = 0; i < 3; i++) {
        final rect = Rect.fromCircle(center: anchor, radius: 30 + i * 22);
        canvas.drawArc(rect, -0.65, 1.25, false, strokePaint);
      }
    }
  }

  void _paintSpeakerTest(Canvas canvas, Size size) {
    final blobPaint = Paint()..color = AppColors.secondarySoft;
    final blackStroke = Paint()
      ..color = AppColors.textPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fillWhite = Paint()..color = Colors.white;
    final accent = Paint()..color = AppColors.accentLilac;

    final blob = Path()
      ..moveTo(size.width * 0.18, size.height * 0.55)
      ..cubicTo(
        size.width * 0.09,
        size.height * 0.25,
        size.width * 0.38,
        size.height * 0.18,
        size.width * 0.54,
        size.height * 0.32,
      )
      ..cubicTo(
        size.width * 0.74,
        size.height * 0.28,
        size.width * 0.90,
        size.height * 0.45,
        size.width * 0.82,
        size.height * 0.68,
      )
      ..cubicTo(
        size.width * 0.69,
        size.height * 0.96,
        size.width * 0.24,
        size.height * 0.89,
        size.width * 0.18,
        size.height * 0.55,
      )
      ..close();
    canvas.drawPath(blob, blobPaint);

    canvas.save();
    canvas.translate(size.width * 0.43, size.height * 0.62);
    canvas.rotate(-0.58);
    final phone = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset.zero,
        width: size.width * 0.34,
        height: size.height * 0.48,
      ),
      const Radius.circular(18),
    );
    canvas.drawRRect(phone.shift(const Offset(8, 8)), accent);
    canvas.drawRRect(phone, fillWhite);
    canvas.drawRRect(phone, blackStroke);
    canvas.drawLine(
      Offset(-size.width * 0.10, -size.height * 0.20),
      Offset(size.width * 0.02, -size.height * 0.20),
      blackStroke,
    );
    canvas.restore();

    final horn = Path()
      ..moveTo(size.width * 0.47, size.height * 0.50)
      ..lineTo(size.width * 0.59, size.height * 0.36)
      ..lineTo(size.width * 0.68, size.height * 0.55)
      ..lineTo(size.width * 0.52, size.height * 0.58)
      ..close();
    canvas.drawPath(horn, fillWhite);
    canvas.drawPath(horn, blackStroke);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.68, size.height * 0.46),
        width: size.width * 0.09,
        height: size.height * 0.26,
      ),
      fillWhite,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.68, size.height * 0.46),
        width: size.width * 0.09,
        height: size.height * 0.26,
      ),
      blackStroke,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.68, size.height * 0.46),
        width: size.width * 0.03,
        height: size.height * 0.08,
      ),
      Paint()..color = AppColors.textPrimary,
    );

    final hand = Path()
      ..moveTo(size.width * 0.43, size.height * 0.56)
      ..cubicTo(
        size.width * 0.47,
        size.height * 0.54,
        size.width * 0.50,
        size.height * 0.59,
        size.width * 0.48,
        size.height * 0.65,
      )
      ..lineTo(size.width * 0.47, size.height * 0.78)
      ..moveTo(size.width * 0.39, size.height * 0.58)
      ..cubicTo(
        size.width * 0.34,
        size.height * 0.66,
        size.width * 0.34,
        size.height * 0.72,
        size.width * 0.32,
        size.height * 0.78,
      );
    canvas.drawPath(hand, blackStroke);

    for (var i = 0; i < 3; i++) {
      final start = Offset(
        size.width * (0.73 + i * 0.04),
        size.height * (0.33 + i * 0.08),
      );
      canvas.drawLine(
        start,
        start + Offset(size.width * 0.05, -size.height * 0.04),
        blackStroke,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OnboardingIllustrationPainter oldDelegate) {
    return oldDelegate.type != type;
  }
}
