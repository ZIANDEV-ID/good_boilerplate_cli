import 'package:mason/mason.dart';

void run(HookContext context) {
  final themeStyle = '${context.vars['theme_style']}';
  context.vars['theme_style_soft_pastel'] = themeStyle == 'soft_pastel';
  context.vars['theme_style_neubrutalism'] = themeStyle == 'neubrutalism';

  context.logger.info(
    'Generating Flutter starter project with the $themeStyle theme...',
  );
}
