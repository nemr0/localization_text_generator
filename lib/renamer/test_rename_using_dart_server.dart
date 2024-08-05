


import 'package:analyzer_plugin/utilities/change_builder/change_builder_core.dart';

class RenameServer{

  run() async {
    ChangeBuilder changeBuilder =  ChangeBuilder(session: session);
    //
    // AnalysisServer server = await AnalysisServer.create();
    // await server.server.onConnected.first;
    // VersionResult version = await server.server.getVersion();
    // print(version.version);
    // (  await server.edit.getRefactoring('RENAME','filePath', null, null, null,options: RenameRefactoringOptions(newName: '')));
    // server.dispose();
  }

}