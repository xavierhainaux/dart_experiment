//use case :
//downloadSheet('slot',
//    tabs: ['CommonSlot', 'Faelorn', 'HiRoller', 'SpinQuest']);

import 'dart:io';
import 'package:args/args.dart';
import 'package:learn_args/do_something.dart';

const sheet = 'sheet';
const tabs = 'tabs';

ArgResults argResults;

void main(List<String> arguments) {
  exitCode = 0; //presume success
  final parser = new ArgParser()
    ..addOption(sheet, abbr: 's')
    ..addOption(tabs, abbr: 't', allowMultiple: true, splitCommas: true);

  argResults = parser.parse(arguments);

  print('argResults["sheet"] : ${argResults['sheet']}');
  assert(argResults['sheet'].length > 0);

  print('argResults["tabs"] : ${argResults['tabs']}');
  assert(argResults['tabs'].length > 0);

  doSomething('hello');
}