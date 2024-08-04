import 'dart:io';

import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/text_matcher.dart';

class RenameFileManager extends FileManger{

  /// Current Working Directory
  late Directory _currentDirectory;

  /// Current Working Directory Getter
  @override
  Directory get currentDirectory => _currentDirectory;
  RenameFileManager(TextMatcher? textMatcher,Directory directory) : super(textMatcher, directory){
    _currentDirectory = directory.existsSync() ? directory : Directory.current.absolute;
    if (!_currentDirectory.existsSync()) {
      _currentDirectory.createSync(recursive: true);
    }
  }
  @override
  List<File> getScreensTexts(List<FileSystemEntity> dartFiles, [bool checkEnabled=false]){
    List<File> acceptedFiles = [];
    for (final file in dartFiles) {
      // iterate over all files and get content
      if (file is File) {
        acceptedFiles.add(file);

      }
    }

    return acceptedFiles;
  }







}