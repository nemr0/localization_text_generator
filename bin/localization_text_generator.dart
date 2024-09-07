import 'dart:developer';

import 'package:localization_text_generator/console_Ui/parse_args.dart';
import 'package:localization_text_generator/localization_generator_facade.dart';
import 'package:localization_text_generator/localization_keys_renamer.dart';

/// Entry Point for the package
void main(List<String> arguments) {
  final List<Arg> args = parseArgs(arguments);
  print(args.toString());
  // bool isRenameCommand = args.where((arg) => arg.name == CommandName.rename && arg.value!=null).isNotEmpty;
  // if (isRenameCommand) {
  //   LocalizationKeysRenamer(args).run();
  // } else {
  //   /// creating object from [LocalizationJsonFacade]
  //   LocalizationJsonFacade(args).run();
  // }
}
