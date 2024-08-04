import 'dart:io';

import 'package:localization_text_generator/console_Ui/printer.dart';
import 'package:localization_text_generator/consts/progress_consts.dart';
import 'package:localization_text_generator/file_manager.dart';

import 'generate_dart_class.dart';

class TextMapBuilder {
  /// Texts Map
  late Map<String, String> _textsMap;
  /// Texts Map Getter
  Map<String, String> get textsMap => _textsMap;
  late FileManger _fileManger;
  late GenerateDartClasses _generateDartClasses;
  TextMapBuilder(FileManger fileManger,[GenerateDartClasses? generateDartClasses]) {
    _fileManger=fileManger;
    if(generateDartClasses!=null) _generateDartClasses=generateDartClasses;
    _textsMap = {};
  }

  /// Builds a Map from a List of String(s) with a value of String and key of
  /// a generated name text{number}
  void generateTextMap(List<File> files,Map<String, dynamic> textMap) {
    textMap as Map<String,(String key,String textWithoutQuotes)>;
    final printer=PrintHelper();
    for(int i=0; i<files.length;i++){
          printer.updateCurrentProgress(ProgressConsts.editingFiles(i+1, files.length));
          // TODO: Get File Content
          String fileContent = files[i].readAsStringSync();
          String newContent = fileContent;
        for(String key in textMap.keys){
         if(textMap[key]!=null) {
           _generateDartClasses.addKey(textMap[key]!.$1);
           fileContent = fileContent.replaceAll(key, 'JsonKeys.${textMap[key]!.$1}.get()');
          textsMap[(textMap[key]!.$1)] = textMap[key]!.$2;
        }
      }

      if(fileContent!=newContent)_fileManger.writeDateToDartFile(_generateDartClasses.importPackageNameFor(filename: 'json_keys.g')+fileContent, files[i]);
    }


  }
}
