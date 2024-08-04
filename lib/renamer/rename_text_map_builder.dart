import 'dart:io';

import 'package:localization_text_generator/console_Ui/printer.dart';
import 'package:localization_text_generator/consts/progress_consts.dart';
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

    for(File file in files){
      printer.updateCurrentProgress(ProgressConsts.editingFiles((files.indexOf(file))+1, files.length));
      String fileString=file.readAsStringSync();
      for(String key in textMap.keys){
        fileString.replaceAll(key, textMap[key]);
      }
      _fileManger.writeDateToDartFile(fileString, file);
    }
  }

  @override
  // TODO: implement textsMap
  Map<String, String> get textsMap => throw UnimplementedError();

}