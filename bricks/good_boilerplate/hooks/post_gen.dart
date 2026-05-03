import 'dart:io';

import 'package:mason/mason.dart';

Future<void> run(HookContext context) async {
  final projectName = _snakeCase('${context.vars['project_name']}');
  final appId = '${context.vars['app_id']}';
  final appName = '${context.vars['app_name']}';
  final description = '${context.vars['description']}';
  final orgName = _orgFromAppId(appId);
  final projectDir = Directory(projectName);

  context.logger.info('Creating Flutter platform folders...');

  final flutterCreate = await Process.run(
    'flutter',
    [
      'create',
      '--project-name',
      projectName,
      '--org',
      orgName,
      '--description',
      description,
      '--platforms',
      'android,ios,web,macos',
      projectDir.path,
    ],
  );

  if (flutterCreate.exitCode != 0) {
    context.logger.err('Flutter platform folder generation failed.');
    context.logger.err('${flutterCreate.stderr}');
    context.logger.info(
      'Run this manually from the output folder: '
      'flutter create --project-name $projectName --org $orgName '
      '--description "$description" --platforms android,ios,web,macos '
      '${projectDir.path}',
    );
  } else {
    await _removeFlutterDefaultMain(projectDir);
    await _patchNativeMetadata(
      projectDir: projectDir,
      projectName: projectName,
      appId: appId,
      appName: appName,
      orgName: orgName,
    );
    await _patchAndroidConcurrentFuturesDependency(projectDir);
    await _patchAdMobMetadata(projectDir);
    context.logger.success('Flutter platform folders created.');
  }

  context.logger.success('Generated $projectName.');
  context.logger.info('Next steps:');
  context.logger.info('  cd $projectName');
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

String _orgFromAppId(String appId) {
  final parts = appId.split('.').where((part) => part.isNotEmpty).toList();
  if (parts.length < 2) return appId;

  return parts.take(parts.length - 1).join('.');
}

String _lowerCamelCase(String value) {
  final words =
      _snakeCase(value).split('_').where((word) => word.isNotEmpty).toList();

  if (words.isEmpty) return 'myApp';

  return [
    words.first,
    ...words.skip(1).map((word) {
      return word.substring(0, 1).toUpperCase() + word.substring(1);
    }),
  ].join();
}

String _titleCase(String value) {
  return _snakeCase(value)
      .split('_')
      .where((word) => word.isNotEmpty)
      .map((word) => word.substring(0, 1).toUpperCase() + word.substring(1))
      .join(' ');
}

Future<void> _removeFlutterDefaultMain(Directory projectDir) async {
  final defaultMain = File('${projectDir.path}/lib/main.dart');
  if (await defaultMain.exists()) {
    await defaultMain.delete();
  }
}

Future<void> _patchNativeMetadata({
  required Directory projectDir,
  required String projectName,
  required String appId,
  required String appName,
  required String orgName,
}) async {
  final createdAndroidId = '$orgName.$projectName';
  final createdAppleId = '$orgName.${_lowerCamelCase(projectName)}';
  final createdTitle = _titleCase(projectName);

  await _replaceInFile(
    File('${projectDir.path}/android/app/build.gradle.kts'),
    {
      createdAndroidId: appId,
    },
  );
  await _replaceInFile(
    File('${projectDir.path}/android/app/src/main/AndroidManifest.xml'),
    {
      'android:label="$projectName"': 'android:label="$appName"',
    },
  );
  await _patchAndroidMainActivity(
    projectDir: projectDir,
    createdAndroidId: createdAndroidId,
    appId: appId,
  );
  await _replaceInFile(
    File('${projectDir.path}/ios/Runner.xcodeproj/project.pbxproj'),
    {
      '$createdAppleId.RunnerTests': '$appId.RunnerTests',
      createdAppleId: appId,
    },
  );
  await _replaceInFile(
    File('${projectDir.path}/ios/Runner/Info.plist'),
    {
      '<key>CFBundleDisplayName</key>\n\t<string>$createdTitle</string>':
          '<key>CFBundleDisplayName</key>\n\t<string>$appName</string>',
      '<key>CFBundleName</key>\n\t<string>$projectName</string>':
          '<key>CFBundleName</key>\n\t<string>$appName</string>',
    },
  );
  await _replaceInFile(
    File('${projectDir.path}/macos/Runner/Configs/AppInfo.xcconfig'),
    {
      'PRODUCT_NAME = $projectName': 'PRODUCT_NAME = $appName',
      'PRODUCT_BUNDLE_IDENTIFIER = $createdAppleId':
          'PRODUCT_BUNDLE_IDENTIFIER = $appId',
    },
  );
  await _replaceInFile(
    File('${projectDir.path}/macos/Runner.xcodeproj/project.pbxproj'),
    {
      '$createdAppleId.RunnerTests': '$appId.RunnerTests',
      createdAppleId: appId,
      '$projectName.app': '$appName.app',
      '/$projectName"': '/$appName"',
    },
  );
  await _replaceInFile(
    File(
      '${projectDir.path}/macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme',
    ),
    {
      '$projectName.app': '$appName.app',
    },
  );
  await _replaceInFile(
    File('${projectDir.path}/web/manifest.json'),
    {
      '"name": "$projectName"': '"name": "$appName"',
      '"short_name": "$projectName"': '"short_name": "$appName"',
    },
  );
  await _replaceInFile(
    File('${projectDir.path}/web/index.html'),
    {
      'content="$projectName"': 'content="$appName"',
      '<title>$projectName</title>': '<title>$appName</title>',
    },
  );
}

Future<void> _replaceInFile(
  File file,
  Map<String, String> replacements,
) async {
  if (!await file.exists()) return;

  var content = await file.readAsString();

  for (final entry in replacements.entries) {
    content = content.replaceAll(entry.key, entry.value);
  }

  await file.writeAsString(content);
}

Future<void> _patchAndroidMainActivity({
  required Directory projectDir,
  required String createdAndroidId,
  required String appId,
}) async {
  final sourcePath =
      '${projectDir.path}/android/app/src/main/kotlin/${createdAndroidId.replaceAll('.', '/')}/MainActivity.kt';
  final targetPath =
      '${projectDir.path}/android/app/src/main/kotlin/${appId.replaceAll('.', '/')}/MainActivity.kt';
  final sourceFile = File(sourcePath);

  if (!await sourceFile.exists()) return;

  var content = await sourceFile.readAsString();
  content = content.replaceAll(
    'package $createdAndroidId',
    'package $appId',
  );

  final targetFile = File(targetPath);
  await targetFile.parent.create(recursive: true);
  await targetFile.writeAsString(content);

  if (sourceFile.path != targetFile.path) {
    await sourceFile.delete();
  }
}

Future<void> _patchAdMobMetadata(Directory projectDir) async {
  await _patchAndroidAdMobAppId(projectDir);
  await _patchIosAdMobAppId(projectDir);
}

Future<void> _patchAndroidConcurrentFuturesDependency(Directory projectDir) async {
  final gradleFile = File('${projectDir.path}/android/build.gradle.kts');

  if (!await gradleFile.exists()) return;

  var content = await gradleFile.readAsString();
  if (content.contains('androidx.concurrent:concurrent-futures')) {
    return;
  }

  content = content.replaceFirst(
    'tasks.register<Delete>("clean") {',
    'subprojects {\n'
        '    configurations.configureEach {\n'
        '        if (name == "implementation" || name == "compileOnly") {\n'
        '            project.dependencies.add(\n'
        '                name,\n'
        '                "androidx.concurrent:concurrent-futures:1.2.0",\n'
        '            )\n'
        '        }\n'
        '    }\n'
        '}\n\n'
        'tasks.register<Delete>("clean") {',
  );

  await gradleFile.writeAsString(content);
}

Future<void> _patchAndroidAdMobAppId(Directory projectDir) async {
  const androidTestAppId = 'ca-app-pub-3940256099942544~3347511713';
  final manifest = File(
    '${projectDir.path}/android/app/src/main/AndroidManifest.xml',
  );

  if (!await manifest.exists()) return;

  var content = await manifest.readAsString();
  if (content.contains('com.google.android.gms.ads.APPLICATION_ID')) {
    return;
  }

  content = content.replaceFirst(
    '    </application>',
    '        <meta-data\n'
        '            android:name="com.google.android.gms.ads.APPLICATION_ID"\n'
        '            android:value="$androidTestAppId" />\n'
        '    </application>',
  );
  await manifest.writeAsString(content);
}

Future<void> _patchIosAdMobAppId(Directory projectDir) async {
  const iosTestAppId = 'ca-app-pub-3940256099942544~1458002511';
  final infoPlist = File('${projectDir.path}/ios/Runner/Info.plist');

  if (!await infoPlist.exists()) return;

  var content = await infoPlist.readAsString();
  if (content.contains('GADApplicationIdentifier')) {
    return;
  }

  content = content.replaceFirst(
    '</dict>',
    '\t<key>GADApplicationIdentifier</key>\n'
        '\t<string>$iosTestAppId</string>\n'
        '</dict>',
  );
  await infoPlist.writeAsString(content);
}
