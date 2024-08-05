import 'dart:convert';

import 'package:localization_text_generator/console_Ui/parse_args.dart';

/// Json String Adapter Class
class JsonStringAdapter {
  /// Conversion of Map to string using [jsonEncode] from dart:convert library
     String convertMapToJsonString(Map<String, String> data,) {

      // Map<String,String> contentOfJson={};
      //
      //   for (var map in data) {
      //     contentOfJson.addAll(map);
      //   }
      return jsonEncode(data).replaceAll('\\\\', '\\').replaceAll("\\'", "'");
      }
      Map<String,String> convertJsonToMap(String json,[CommandName? command]) {
       if(json.isEmpty){
         if(command?.name=='rename'){
           return {'old-key-example':'new-key-example'};
         }
         return{'example':'this is an example'};

       }
       final Map<String,String> map=(jsonDecode(json) as Map<String,dynamic>).map((k,v)=>MapEntry(k, v.toString()));
       if(map.isEmpty){
         if(command?.name=='rename'){
           return {'old-key-example':'new-key-example'};
         }
         return{'example':'this is an example'};
       }
       return map;}
}
