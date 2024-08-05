import 'dart:io';

import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'package:localization_text_generator/console_Ui/parse_args.dart';
import 'package:localization_text_generator/consts/exceptions.dart';
import 'package:localization_text_generator/json_string_adapter.dart';
import 'package:localization_text_generator/text_matcher.dart';

class FileManger {
  /// TextMatcher for current File
  late TextMatcher? _textMatcher;

  /// Current Working Directory
  late Directory _currentDirectory;
  late JsonStringAdapter _adapter;
  late CommandName? _command;
  /// Current Working Directory Getter
  Directory get currentDirectory => _currentDirectory;

  /// Constructor
  FileManger(TextMatcher? textMatcher, Directory? directory,JsonStringAdapter adapter,[CommandName? command]) {
    _adapter = adapter;
    _command=command;
    _textMatcher = textMatcher;
    _currentDirectory = directory?.existsSync() == true? directory! : Directory.current.absolute;
    if (!_currentDirectory.existsSync()) {
      _currentDirectory.createSync(recursive: true);
    }
    _adapter = JsonStringAdapter();
  }

  /// List Directories inside lib folder
  List<FileSystemEntity> listDirectoryDartFiles(List<String>? excludes) {
    String glob;
    if (currentDirectory.path.endsWith('lib')) {
      glob = '${currentDirectory.path}/**.dart';
      _currentDirectory = currentDirectory.parent;
    } else if (Directory('${currentDirectory.path}/lib').existsSync()) {
      glob = '${currentDirectory.path}/lib/**.dart';
    } else {
      /// lib/**.dart
      glob = 'lib/**.dart';
    }
    List<FileSystemEntity> dartFiles = Glob(glob, recursive: true).listSync();
    if (excludes != null) {
      for (String exclude in excludes) {
        dartFiles = dartFiles.where((e) => e.path.contains(exclude) == false).toList();
      }
    }
    return dartFiles;
  }

  /// Using Dart's New Record Feature, Checking if file has a screen  widget currently works on StatelessWidget(s) and
  /// StatefulWidget(s)
  (bool, String) _checkIfScreenFile(File file, bool checkEnabled) {
    String content = file.readAsStringSync();
    bool isScreenFile = checkEnabled
        ? content.contains('package:flutter/material.dart') || content.contains('package:flutter/cupertino.dart')
        : true;
    return (isScreenFile, content);
  }

  /// Get Screen Texts
  List<File> getScreensTexts(List<FileSystemEntity> dartFiles, [bool checkEnabled = false]) {
    List<File> acceptedFiles = [];
    for (final file in dartFiles) {
      // iterate over all files and get content
      if (file is File) {
        final result = _checkIfScreenFile(file, checkEnabled);
        bool isScreenFile = result.$1;
        String content = result.$2;
        if (isScreenFile) {
          _textMatcher?.matchAndExtractTexts(content, file.path);
          acceptedFiles.add(file);
        }
      }
    }

    return acceptedFiles;
  }

  void writeDataToJsonFile(Map<String, dynamic> map, {required String name, required String? path}) {
    try {
      final file = File(getJsonPath(path, name))..createSync(recursive: true);
      if (file.existsSync()) {
        final Map<String, String> old = _adapter.convertJsonToMap(file.readAsStringSync(),_command);
        map.addAll(old);
      }

      final data = _adapter.convertMapToJsonString(map.map(((key, value) => MapEntry(key, value.toString()))));

      file.writeAsStringSync(data);
    } catch (e) {
      throw (Exceptions.couldNotWriteJsonFile);
    }
  }

  String getJsonPath(String? path, String filename) =>
      '${(path == './' || path == '.' || path == null)? _currentDirectory.path : path.startsWith('./') ? '${currentDirectory.path}${path.replaceFirst('.', '')}' : path}/$filename.json';

  void writeDateToDartFile(String content, File file) => file.writeAsStringSync(content);

  void createGeneratedDartFile(String fileContent, String fileName) {
    String path = '${currentDirectory.path}/lib/generated/$fileName.g.dart';
    if (!File(path).existsSync()) {
      File(path).createSync(recursive: true);
    }
    File(path).writeAsStringSync(fileContent);
  }
}
