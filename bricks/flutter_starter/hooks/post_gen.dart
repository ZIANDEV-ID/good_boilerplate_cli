import 'package:mason/mason.dart';

void run(HookContext context) {
  final projectName = _snakeCase('${context.vars['project_name']}');

  context.logger.success('Generated $projectName.');
  context.logger.info('Next steps:');
  context.logger.info('  cd $projectName');
  context.logger.info('  flutter pub get');
  context.logger.info('  flutter run -t lib/main_dev.dart');
  context.logger.info('  flutter run -t lib/main_prod.dart');
  context.logger.info('  dart run build_runner build');
}

String _snakeCase(String value) {
  final spaced = value
      .replaceAllMapped(
        RegExp('([a-z0-9])([A-Z])'),
        (match) => '${match[1]} ${match[2]}',
      )
      .replaceAll(RegExp('[^A-Za-z0-9]+'), ' ')
      .trim();

  if (spaced.isEmpty) return 'my_app';

  return spaced
      .split(RegExp(r'\s+'))
      .where((word) => word.isNotEmpty)
      .map((word) => word.toLowerCase())
      .join('_');
}
