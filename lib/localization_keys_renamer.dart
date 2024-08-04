import 'dart:convert';
import 'dart:io';

import 'package:localization_text_generator/localization_generator_facade.dart';
import 'package:localization_text_generator/renamer/rename_file_manager.dart';
import 'package:localization_text_generator/renamer/rename_text_map_builder.dart';

import 'console_Ui/parse_args.dart';
import 'console_Ui/printer.dart';
import 'consts/exceptions.dart';
import 'consts/progress_consts.dart';
import 'exception/detailed_exception.dart';


class LocalizationKeysRenamer extends LocalizationJsonFacade {

  // File Manager
  late RenameFileManager _fileManger;
  late PrintHelper _printer;

  // Text Map Builder
  late RenameTextMapBuilder _textMapBuilder;
  late List<FileSystemEntity> _dartFiles;
  late List<File> _acceptedFiles;
  Map<String,dynamic> _json={};
  void _initializeArgs(List<Arg> args) {

    for (Arg arg in args) {
      _printer.print('${arg.name.name}:${arg.value}');
      if (arg.name case CommandName.path) {
        path = arg.value;
      } else if (arg.name case CommandName.screenOnly) {
        defaultsToScreensOnly = arg.value;
      } else if (arg.name case CommandName.replaceTextWithVariables) {
        replaceTextWithVariables = arg.value;
      } else if (arg.name case CommandName.filename) {
        filename = arg.value;
      } else if (arg.name case CommandName.exclude) {

        exclude = arg.value;
      }
      else if( arg.name case CommandName.verbose){
        verbose=arg.value;
      }
      else if(arg.name case CommandName.jsonPath){
        jsonPath=arg.value;
      }
    }
    return;
  }
  LocalizationKeysRenamer(List<Arg> args) : super(args) {
    _initializeArgs(args);
    _printer = PrintHelper();


    _fileManger = RenameFileManager(null, path == null ? Directory.current : Directory(path!));

    _textMapBuilder = RenameTextMapBuilder(_fileManger);
  }

  void _getAllFiles() {
    try {
      _dartFiles = _fileManger.listDirectoryDartFiles(exclude);
    } catch (e, s) {
      throw (DetailedException(stackTrace: s, message: Exceptions.noFilesFound, verboseMessage: e.toString()));
    }
    if (_dartFiles.isEmpty) {
      throw (DetailedException(message: Exceptions.noFilesFound, verboseMessage: '_dartFiles is empty'));
    }
  }

  /// Gets all files within lib folder, and returns files text
  void _fetchAllTexts() {
    try {
      _acceptedFiles = _fileManger.getScreensTexts(_dartFiles);
    } catch (e, s) {
      throw (DetailedException(stackTrace: s, message: Exceptions.noTextFound, verboseMessage: e.toString()));
    }

  }
  void _fetchJson(){
    try{
      if (jsonPath == null) throw (DetailedException(message: Exceptions.couldNotFindJsonFile));
      _json = jsonDecode(File(jsonPath!).readAsStringSync());
    } catch (e,s){
      if(e is DetailedException) rethrow;
      throw DetailedException(message: e.toString(),stackTrace: s,);
    }
  }
  /// Creation of texts map
  void _createTextsMap() {
    try {
      _textMapBuilder.generateTextMap( _acceptedFiles, _json);
    } catch (e, s) {
      throw (DetailedException(
          stackTrace: s, message: Exceptions.couldNotGenerateTextMap, verboseMessage: e.toString()));
    }
  }  void _createJson() {
    try {
      _fileManger.writeDataToJsonFile(_json, name: filename??'newJson', path: jsonPath);
    } catch (e, s) {
      throw (DetailedException(
          stackTrace: s, message: Exceptions.couldNotGenerateTextMap, verboseMessage: e.toString()));
    }
  }

  @override
  void generateLocalizationFile() {
    _printer.showLogo();
    _printer.addProgress(ProgressConsts.getAllFiles);

    /// Listing Files
    _getAllFiles();

    _printer.updateProgress(ProgressConsts.fetchAllText);

    /// Fetching all Text
    _fetchAllTexts();
    _printer.updateProgress(ProgressConsts.fetchJson);

    _fetchJson();
    _printer.updateProgress(ProgressConsts.creatingTextMap);
    /// Text Map Creation
    _createTextsMap();


    /// Converting Map To String
    _printer.updateProgress(ProgressConsts.generatingJsonFile);
    /// Writing JSON File
    _createJson();
    _printer.completeProgress();
  }
}
