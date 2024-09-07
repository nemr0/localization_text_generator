
import 'dart:io';

import 'package:args/args.dart';

enum CommandType { option, flag, multiOption,command }

enum CommandName {
  path(CommandType.option),
  jsonPath(CommandType.option),
  screenOnly(CommandType.flag),
  replaceTextWithVariables(CommandType.flag),
  filename(CommandType.option),
  exclude(CommandType.multiOption),
  verbose(CommandType.flag);
  final CommandType type;

  const CommandName(this.type);
}
const List<CommandName> mainCommands=CommandName.values;
const List<CommandName> renameCommands=[CommandName.path,CommandName.jsonPath,CommandName.filename,CommandName.verbose];
class Arg {
  final CommandName name;
  final dynamic value;

  Arg({required this.name, required this.value});
  @override
  String toString() => '${name.name}:$value';

}

List<Arg> parseArgs(List<String> arguments) {
  var renameParser=ArgParser();
  var parser = ArgParser()
    ..addCommand('rename',renameParser)
    ..addMultiOption(CommandName.exclude.name, abbr: 'e', defaultsTo: null,help: 'exclude a directory or a path | uses .contain on file paths')
    ..addOption(CommandName.path.name,
      abbr: 'p', defaultsTo: Directory.current.path, help: 'defaults to current directory if not used, example: "--path=./" or "-p ."')
    ..addOption(CommandName.jsonPath.name,defaultsTo: Directory.current.path)
    ..addOption(
      CommandName.filename.name,
      abbr: 'n',
      defaultsTo: 'strings',
      help: 'generated json file name, defaults to: "strings", should be named without ".json".',
    )
  ..addFlag(CommandName.verbose.name,abbr: 'v',defaultsTo: false,help: 'if verbose or not')
  ..addFlag(CommandName.screenOnly.name,
      defaultsTo: true, help: 'defaults to any screen with "StateFullWidget" or "StatelessWidget" ')
  ..addFlag(CommandName.replaceTextWithVariables.name, defaultsTo: false, help: 'replaces all text in dart files with related variable');


  renameParser
    ..addOption(CommandName.path.name,
      abbr: 'p', defaultsTo: Directory.current.path, help: 'defaults to current directory if not used, example: "--path=./" or "-p ."')
    ..addOption(CommandName.jsonPath.name,defaultsTo: Directory.current.path)
    ..addOption(
      CommandName.filename.name,
      abbr: 'n',
      defaultsTo: 'new-keys',
      help: 'generated json file name, defaults to: "strings", should be named without ".json".',
    )
    ..addFlag(CommandName.verbose.name,abbr: 'v',defaultsTo: false,help: 'if verbose or not');
  // json path

  // filename





  /// ----------------------------------
  /// ----------------------------------
  ArgResults results = parser.parse(arguments);
  ArgResults renameResults = renameParser.parse(arguments);
  List<Arg> args = [];
  bool renameCommand = arguments.singleWhere((e)=>e.contains('rename'),orElse: ()=>'').isNotEmpty;
  ArgResults actualResults =(renameCommand?renameResults: results);
  List<CommandName> actualCommands=renameCommand?renameCommands:mainCommands;
  for (CommandName name in actualCommands ) {
    if (name.type case CommandType.option) {
      args.add(Arg(name: name, value:actualResults.option(name.name)));
    } else if (name.type case CommandType.flag) {
      args.add(Arg(name: name, value: actualResults.flag(name.name)));
    } else if (name.type case CommandType.multiOption) {
      args.add(Arg(name: name, value: actualResults.multiOption(name.name)));
    } else if (name.type case CommandType.command) {
      args.add(Arg(name: name, value: actualResults.command?.name));
    }
  }
  return args;
}
