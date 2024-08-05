import 'dart:io';

import 'package:localization_text_generator/console_Ui/printer.dart';
import 'package:localization_text_generator/consts/exceptions.dart';
import 'package:localization_text_generator/consts/progress_consts.dart';
import 'package:localization_text_generator/exception/detailed_exception.dart';
import 'package:localization_text_generator/renamer/rename_file_manager.dart';
import 'package:localization_text_generator/text_map_builder.dart';

class RenameTextMapBuilder extends TextMapBuilder{
  late RenameFileManager _fileManger;

  RenameTextMapBuilder(fileManger):super(fileManger){
   _fileManger=fileManger;
  }


  @override
  void generateTextMap(List<File> files, Map<String, dynamic> textMap) {
    final printer=PrintHelper();
    int numberOfEdits=0;
    print(files.length);
    for(File file in files){
      printer.updateCurrentProgress(ProgressConsts.editingFiles((files.indexOf(file))+1, files.length));
      String fileString=file.readAsStringSync();
      final String content=fileString;
      for(String key in textMap.keys){
        fileString = fileString.replaceAll(key, textMap[key]);
      }
      if(fileString!=content) {
        _fileManger.writeDateToDartFile(fileString, file);
        numberOfEdits+=1;
      }
    }
    if(numberOfEdits==0){
      throw DetailedException(message: Exceptions.noEditsFound,verboseMessage: 'numberOfEdits: $numberOfEdits',);
    }
  }

  @override
  // TODO: implement textsMap
  Map<String, String> get textsMap => throw UnimplementedError();

}