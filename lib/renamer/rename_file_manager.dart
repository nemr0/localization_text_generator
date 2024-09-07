import 'dart:io';

import 'package:localization_text_generator/console_Ui/parse_args.dart';
import 'package:localization_text_generator/file_manager.dart';
import 'package:localization_text_generator/json_string_adapter.dart';
import 'package:localization_text_generator/text_matcher.dart';

class RenameFileManager extends FileManger{

  /// Current Working Directory
  late Directory _currentDirectory;

  /// Current Working Directory Getter
  @override
  Directory get currentDirectory => _currentDirectory;
  RenameFileManager(TextMatcher? textMatcher,Directory directory,JsonStringAdapter adapter) : super(textMatcher, directory,adapter){
    _currentDirectory = directory.existsSync() ? directory : Directory.current.absolute;
    if (!_currentDirectory.existsSync()) {
      _currentDirectory.createSync(recursive: true);
    }
  }
  @override
  List<File> getScreensTexts(List<FileSystemEntity> dartFiles, [bool checkEnabled=false])=>dartFiles.whereType<File>().toList();

}