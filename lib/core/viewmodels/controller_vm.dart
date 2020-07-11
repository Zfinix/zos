import 'dart:convert';
import 'dart:io';

import 'package:zos/drop_target.dart';
import 'package:flutter/material.dart';

import 'package:path/path.dart' as path;

String get pcHome {
  String home = "";
  Map<String, String> envVars = Platform.environment;
  if (Platform.isMacOS) {
    home = envVars['HOME'];
  } else if (Platform.isLinux) {
    home = envVars['HOME'];
  } else if (Platform.isWindows) {
    home = envVars['UserProfile'];
  }
  return home;
}

class ControllerVM extends ChangeNotifier {
  Directory applicationsDir;
  String applications;

  List<String> _appPathList = [];
  List<String> get appPathList => _appPathList;

  set appPathList(List<String> val) {
    _appPathList = val;
    notifyListeners();
  }

  bool isLoading = false;
  bool isError = false;

  int _selectedPIndex;
  int get selectedPIndex => _selectedPIndex;

  set selectedPIndex(int val) {
    _selectedPIndex = val;
    notifyListeners();
  }

  void init(context) async {
    try {
      isLoading = true;
      notifyListeners();

      applications = path.dirname(pcHome);
      applicationsDir = new Directory('/Applications');
      if (Directory('./apps/').existsSync())
        Directory('./apps/').deleteSync(recursive: true);

      Directory('./apps/').createSync();

      var apps = applicationsDir.listSync();
      apps.sort((a, b) => a.path.compareTo(b.path));
      process(apps);
      // ;

      // gitPList = ;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e.toString());
      isError = false;
      isLoading = false;
      notifyListeners();
    }
  }

  listenToDrop() {
    DropTarget.instance.droppedController.stream.listen((e) {
      process(
        [
          ...e.map(
            (f) => File(
              path.normalize(f.path),
            ),
          )
        ],
      );
    });
  }

  void process(List<FileSystemEntity> apps) async {
    if (!Directory('./apps/').existsSync()) Directory('./apps/').createSync();

    ///Convert APPS PLIST to JSON
    List<String> tempList = [];

    for (var app in apps) {
      File file = File(path.join(app.path, 'Contents/Info.plist')).existsSync()
          ? File(path.join(app.path, 'Contents/Info.plist'))
          : File(path.join(app.path, 'Contents/Resources/Info.plist'))
                  .existsSync()
              ? File(path.join(app.path, 'Contents/Resources/Info.plist'))
              : null;

      if (file != null) {
        tempList.add(app.path);
        try {
         await Process.run('plutil', [
            '-convert',
            'json',
            '-o',
            './apps/${path.basename(app.path)}.json',
            file.path
          ]);
        } catch (e) {
          return;
        }
      }
    }

    ///Extract CFBundleIconFile ICNS FILE from JSON
    var getAppsJson = Directory('./apps').listSync();
    getAppsJson.sort((a, b) => a.path.compareTo(b.path));
    getAppsJson.removeWhere((e) => e.path.contains('png'));

    for (var item in getAppsJson) {
      Map data = json.decode(File(item.path).readAsStringSync());
      String iconFile = data['CFBundleIconFile'].replaceAll('.icns', '');

      var filename = path.basename(item.path).replaceAll('.json', '');
      
      File file = File(path.join(
        '/Applications',
        filename,
        'Contents/$iconFile.icns',
      )).existsSync()
          ? File(path.join(
              '/Applications',
              filename,
              'Contents/$iconFile.icns',
            ))
          : File(path.join(
              '/Applications',
              filename,
              'Contents/Resources/$iconFile.icns',
            )).existsSync()
              ? File(path.join(
                  '/Applications',
                  filename,
                  'Contents/Resources/$iconFile.icns',
                ))
              : File(path.join(
                  '/System/Applications',
                  filename,
                  'Contents/Resources/$iconFile.icns',
                )).existsSync()
                  ? File(path.join(
                      '/System/Applications',
                      filename,
                      'Contents/Resources/$iconFile.icns',
                    ))
                  : null;

      if (file != null)
       await Process.run('sips', [
          '-s',
          'format',
          'png',
          file.path,
          '--out',
          './apps/${filename.replaceAll(' ', '')}.png'
        ]);

      //  File(item.path).deleteSync();
      //  Navigator.pop(context);
    }
    _appPathList.addAll(tempList);
    notifyListeners();
  }

  void open(String app) async {
    try {
     await Process.run('open', [app]);
    } catch (e) {}
  }
}
